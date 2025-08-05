from flask import Blueprint, request, jsonify
from ..extensions import db
from ..models import Voter, Interaction, Campaign, CampaignVoter
from datetime import datetime, timezone
import csv
import io

voters_api_bp = Blueprint('voters_api', __name__, url_prefix='/api/v1/voters')

public_api_bp = Blueprint('public_api', __name__, url_prefix='/api/v1')

@public_api_bp.route('/signups', methods=['POST'])
def public_create_signup():
    data = request.get_json(force=True, silent=True)

    if not data:
        return jsonify({"error": "Invalid or empty JSON payload"}), 400

    required_fields = ['first_name', 'last_name', 'email_address', 'campaign_id']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonify({"error": f"Missing required fields: {', '.join(missing_fields)}"}), 400

    email = data['email_address'].lower()
    phone = data.get('phone_number')
    first_name = data['first_name']
    last_name = data['last_name']
    campaign_id = data['campaign_id']

    middle_name = data.get('middle_name')
    notes_from_payload = data.get('notes', '')
    interaction_type_from_payload = data.get('interaction_type', 'Website Signup')
    interests_from_payload = data.get('interests', {})

    campaign = db.session.get(Campaign, campaign_id)
    if not campaign:
        return jsonify({"error": f"Campaign with ID {campaign_id} not found."}), 404

    voter = None
    if email:
        voter = Voter.query.filter(db.func.lower(Voter.email_address) == email).first()

    if not voter and phone:
        voter = Voter.query.filter_by(phone_number=phone).first()

    try:
        if voter:
            pass
        else:
            voter = Voter(
                first_name=first_name,
                last_name=last_name,
                email_address=email,
                phone_number=phone,
                middle_name=middle_name,
                source_campaign_id=campaign_id,
            )
            db.session.add(voter)
            db.session.flush()

        interaction_notes_list = []
        if notes_from_payload:
            interaction_notes_list.append(notes_from_payload)

        if interests_from_payload.get('wants_to_endorse'):
            interaction_notes_list.append("Expressed interest: Endorse.")
        if interests_from_payload.get('wants_to_get_involved'):
            interaction_notes_list.append("Expressed interest: Get Involved.")

        final_interaction_notes = " ".join(filter(None, interaction_notes_list)).strip()

        new_interaction = Interaction(
            voter_id=voter.voter_id,
            campaign_id=campaign_id,
            interaction_type=interaction_type_from_payload,
            interaction_date=datetime.now(timezone.utc),
            notes=final_interaction_notes if final_interaction_notes else "Website signup.",
            outcome="Signed Up"
        )
        db.session.add(new_interaction)

        existing_campaign_voter_assoc = CampaignVoter.query.filter_by(
            campaign_id=campaign_id,
            voter_id=voter.voter_id
        ).first()

        if not existing_campaign_voter_assoc:
            campaign_voter_assoc = CampaignVoter(
                campaign_id=campaign_id,
                voter_id=voter.voter_id
            )
            db.session.add(campaign_voter_assoc)

        db.session.commit()

        return jsonify({
            "message": "Signup processed successfully.",
            "voter_id": voter.voter_id,
            "interaction_id": new_interaction.interaction_id
        }), 201

    except Exception as e:
        db.session.rollback()
        print(f"Error processing signup: {str(e)}")
        return jsonify({"error": "An internal error occurred. Please try again later."}), 500

@voters_api_bp.route('/', methods=['POST'])
def create_voter_via_portal():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    required_fields = ['first_name', 'last_name', 'email_address']
    if any(field not in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    try:
        new_voter = Voter(**data)
        db.session.add(new_voter)
        db.session.commit()
        return jsonify(new_voter.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        print(f"Error creating voter: {str(e)}")
        return jsonify({"error": "Failed to create voter."}), 500

@voters_api_bp.route('/', methods=['GET'])
def list_voters_via_portal():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)

    voters_query = Voter.query

    voters_page = voters_query.paginate(page=page, per_page=per_page, error_out=False)

    return jsonify({
        "voters": [voter.to_dict() for voter in voters_page.items],
        "total_pages": voters_page.pages,
        "current_page": voters_page.page,
        "total_voters": voters_page.total
    }), 200

@voters_api_bp.route('/<int:voter_id>', methods=['GET'])
def get_voter_detail_via_portal(voter_id):
    voter = Voter.query.get_or_404(voter_id)
    return jsonify(voter.to_dict()), 200

@voters_api_bp.route('/<int:voter_id>', methods=['PUT'])
def update_voter_via_portal(voter_id):
    voter = Voter.query.get_or_404(voter_id)
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    for key, value in data.items():
        if hasattr(voter, key) and key not in ['voter_id', 'created_at', 'updated_at']:
            setattr(voter, key, value)

    try:
        db.session.commit()
        return jsonify(voter.to_dict()), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error updating voter {voter_id}: {str(e)}")
        return jsonify({"error": "Failed to update voter."}), 500

@voters_api_bp.route('/<int:voter_id>', methods=['DELETE'])
def delete_voter_via_portal(voter_id):
    voter = Voter.query.get_or_404(voter_id)
    try:
        db.session.delete(voter)
        db.session.commit()
        return jsonify({"message": f"Voter {voter_id} deleted successfully."}), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error deleting voter {voter_id}: {str(e)}")
        return jsonify({"error": "Failed to delete voter. It might be referenced elsewhere."}), 500

@voters_api_bp.route('/upload', methods=['POST'])
def upload_voters():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    if file:
        try:
            stream = io.StringIO(file.stream.read().decode("UTF8"), newline=None)
            csv_input = csv.reader(stream)
            header = next(csv_input)
            for row in csv_input:
                first_name, last_name, email = row[0], row[1], row[2]

                first_name = first_name.strip().title()
                last_name = last_name.strip().title()
                email = email.strip().lower()

                voter = Voter.query.filter_by(email_address=email).first()
                if not voter:
                    voter = Voter(
                        first_name=first_name,
                        last_name=last_name,
                        email_address=email,
                    )
                    db.session.add(voter)
            db.session.commit()
            return jsonify({"message": "File processed successfully"}), 200
        except Exception as e:
            db.session.rollback()
            return jsonify({"error": str(e)}), 500
