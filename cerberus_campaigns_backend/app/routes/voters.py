from flask import Blueprint, request, jsonify, current_app
from ..extensions import db # Assuming auth_required is defined in extensions or another utility
from .auth import token_required
from ..models import Voter, Interaction, Campaign, CampaignVoter # Ensure CampaignVoter is imported
from datetime import datetime, timezone # Import timezone
import csv
import io

# Define a Blueprint for voter-related operations that are typically protected (for portal)
voters_api_bp = Blueprint('voters_api', __name__, url_prefix='/api/v1/voters')

# Define a Blueprint for public-facing API endpoints like signups
public_api_bp = Blueprint('public_api', __name__, url_prefix='/api/v1')

@public_api_bp.route('/signups', methods=['POST'])
def public_create_signup():
    """
    Handles new signups from public campaign websites (e.g., Emmons-Frontend).
    Creates a Voter record (or uses existing by email/phone) and an Interaction.
    Associates the voter with the specified campaign.
    """
    # force=True: parse even if Content-Type header is not application/json
    # silent=True: return None if parsing fails, instead of raising BadRequest
    data = request.get_json(force=True, silent=True)

    if not data: # This will catch None from silent=True on parse failure, or if data is truly empty
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

    # Validate campaign
    campaign = db.session.get(Campaign, campaign_id)
    if not campaign:
        return jsonify({"error": f"Campaign with ID {campaign_id} not found."}), 404

    voter = None
    # Try to find existing voter by email first, then by phone if email doesn't match
    if email:
        voter = Voter.query.filter(db.func.lower(Voter.email_address) == email).first()

    if not voter and phone:
        # Be cautious with matching only by phone if it's not unique enough or could be shared.
        # For this example, we proceed if email match failed.
        voter = Voter.query.filter_by(phone_number=phone).first()

    try:
        if voter:
            # Voter exists. We'll add a new interaction and ensure they're linked to this campaign.
            # Optionally: update voter fields if new data is provided and considered more current.
            # For simplicity, we are not updating existing voter's core details here.
            pass
        else:
            # Create a new voter
            voter = Voter(
                first_name=first_name,
                last_name=last_name,
                email_address=email, # Store the validated/normalized email
                phone_number=phone,
                middle_name=middle_name,
                source_campaign_id=campaign_id, # Attribute first touch
                # Potentially add initial custom_fields from signup if applicable
                # custom_fields = data.get('custom_fields_on_signup')
            )
            db.session.add(voter)
            db.session.flush() # Required to get voter.voter_id for new voter

        # Construct interaction notes
        interaction_notes_list = []
        if notes_from_payload: # Notes from the 'notes' field in payload
            interaction_notes_list.append(notes_from_payload)

        if interests_from_payload.get('wants_to_endorse'):
            interaction_notes_list.append("Expressed interest: Endorse.")
        if interests_from_payload.get('wants_to_get_involved'):
            interaction_notes_list.append("Expressed interest: Get Involved.")

        final_interaction_notes = " ".join(filter(None, interaction_notes_list)).strip()

        # Create Interaction Record
        new_interaction = Interaction(
            voter_id=voter.voter_id,
            campaign_id=campaign_id,
            # user_id=None, # System-generated, no specific logged-in portal user
            interaction_type=interaction_type_from_payload,
            interaction_date=datetime.now(timezone.utc), # Use imported timezone
            notes=final_interaction_notes if final_interaction_notes else "Website signup.",
            outcome="Signed Up" # Or a more generic "Submitted Online Form"
        )
        db.session.add(new_interaction)

        # Ensure voter is associated with the campaign in campaign_voters
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
            # Potentially return voter.to_dict() if frontend needs more voter data
        }), 201

    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error processing signup: {str(e)}", exc_info=True)
        # Consider logging e.__traceback__ as well for debugging
        return jsonify({"error": "An internal error occurred. Please try again later."}), 500


# --- CRUD for Voters (example, intended for internal portal, requires auth) ---

@voters_api_bp.route('/', methods=['POST'])
@token_required
def create_voter_via_portal():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    # Add more robust validation here (e.g., using Marshmallow or Pydantic)
    required_fields = ['first_name', 'last_name', 'email_address'] # Example
    if any(field not in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    try:
        new_voter = Voter(**data) # Assumes data keys match Voter model fields
        db.session.add(new_voter)
        db.session.commit()
        return jsonify(new_voter.to_dict()), 201
    except Exception as e: # Catch more specific exceptions
        db.session.rollback()
        current_app.logger.error(f"Error creating voter: {str(e)}", exc_info=True)
        return jsonify({"error": "Failed to create voter."}), 500

@voters_api_bp.route('/', methods=['GET'])
@token_required
def list_voters_via_portal():
    # Add pagination, filtering, sorting
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)

    voters_query = Voter.query
    # Example filtering:
    # if 'last_name' in request.args:
    #     voters_query = voters_query.filter(Voter.last_name.ilike(f"%{request.args['last_name']}%"))

    voters_page = voters_query.paginate(page=page, per_page=per_page, error_out=False)

    return jsonify({
        "voters": [voter.to_dict() for voter in voters_page.items],
        "total_pages": voters_page.pages,
        "current_page": voters_page.page,
        "total_voters": voters_page.total
    }), 200

@voters_api_bp.route('/<int:voter_id>', methods=['GET'])
@token_required
def get_voter_detail_via_portal(voter_id):
    voter = Voter.query.get_or_404(voter_id)
    return jsonify(voter.to_dict()), 200

@voters_api_bp.route('/<int:voter_id>', methods=['PUT'])
@token_required
def update_voter_via_portal(voter_id):
    voter = Voter.query.get_or_404(voter_id)
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    # Update fields - be careful about which fields are updatable
    for key, value in data.items():
        if hasattr(voter, key) and key not in ['voter_id', 'created_at', 'updated_at']: # Prevent updating certain fields
            setattr(voter, key, value)

    try:
        db.session.commit()
        return jsonify(voter.to_dict()), 200
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error updating voter {voter_id}: {str(e)}", exc_info=True)
        return jsonify({"error": "Failed to update voter."}), 500

@voters_api_bp.route('/<int:voter_id>', methods=['DELETE'])
@token_required
def delete_voter_via_portal(voter_id):
    voter = Voter.query.get_or_404(voter_id)
    try:
        db.session.delete(voter)
        db.session.commit()
        return jsonify({"message": f"Voter {voter_id} deleted successfully."}), 200
    except Exception as e: # Consider specific exceptions e.g. IntegrityError if voter is referenced
        db.session.rollback()
        current_app.logger.error(f"Error deleting voter {voter_id}: {str(e)}", exc_info=True)
        return jsonify({"error": "Failed to delete voter. It might be referenced elsewhere."}), 500


# Note: Authentication (@auth_required) is critical for the voters_api_bp endpoints
# and needs to be implemented. The public_api_bp /signups endpoint is intentionally public.

@voters_api_bp.route('/upload', methods=['POST'])
@token_required # CRITICAL: This endpoint must be protected
def upload_voters():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    if file:
        try:
            stream = io.StringIO(file.stream.read().decode("UTF8"), newline=None)
            # Use DictReader to handle columns by name, making it robust
            # Define expected header names and their corresponding model fields
            field_map = {
                'first_name': ['first name', 'firstname', 'first'],
                'last_name': ['last name', 'lastname', 'last'],
                'email_address': ['email', 'email address', 'emailaddress']
            }
            
            csv_reader = csv.DictReader(stream)
            
            for row in csv_reader:
                # Normalize row keys (lowercase, strip spaces)
                normalized_row = {k.lower().strip(): v for k, v in row.items()}
                
                # Find data using possible header names
                first_name = next((normalized_row[h] for h in field_map['first_name'] if h in normalized_row), None)
                last_name = next((normalized_row[h] for h in field_map['last_name'] if h in normalized_row), None)
                email = next((normalized_row[h] for h in field_map['email_address'] if h in normalized_row), None)
                
                if not all([first_name, last_name, email]):
                    current_app.logger.warning(f"Skipping row due to missing data: {row}")
                    continue
                
                # Basic data cleaning
                email = email.strip().lower()
                # Check for existing voter
                voter = Voter.query.filter_by(email_address=email).first()
                if not voter:
                    voter = Voter(
                        first_name=first_name.strip().title(),
                        last_name=last_name.strip().title(),
                        email_address=email,
                    )
                    db.session.add(voter)
            db.session.commit()
            return jsonify({"message": "File processed successfully"}), 200
        except Exception as e:
            db.session.rollback()
            return jsonify({"error": str(e)}), 500
