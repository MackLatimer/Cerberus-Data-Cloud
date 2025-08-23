from flask import Blueprint, request, jsonify
from ..extensions import db
from ..models import Person, PersonCampaignInteraction, Campaign, PersonEmail, PersonPhone, DataSource
from datetime import datetime, timezone
import csv
import io
from sqlalchemy import text
from ..config import current_config
from ..utils.security import token_required, encrypt_data, decrypt_data

voters_api_bp = Blueprint('voters_api', __name__, url_prefix='/api/v1/voters')

public_api_bp = Blueprint('public_api', __name__, url_prefix='/api/v1/public')



@public_api_bp.route('/signups', methods=['POST'])
def public_create_signup():
    data = request.get_json(force=True, silent=True)

    if not data:
        return jsonify({"error": "Invalid or empty JSON payload"}), 400

    required_fields = ['first_name', 'last_name', 'email_address', 'campaign_id']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonify({"error": f"Missing required fields: {', '.join(missing_fields)}"}), 400

    email_str = data['email_address'].lower()
    phone_str = data.get('phone_number')
    first_name = data['first_name']
    last_name = data['last_name']
    campaign_id = data['campaign_id']

    middle_name = data.get('middle_name')
    notes_from_payload = data.get('notes', '')
    interaction_type_from_payload = data.get('interaction_type', 'ContactForm') # Changed to match new ENUM
    interests_from_payload = data.get('interests', {})

    campaign = db.session.get(Campaign, campaign_id)
    if not campaign:
        return jsonify({"error": f"Campaign with ID {campaign_id} not found."}), 404

    person = None
    encrypted_email = encrypt_data(email_str)
    if email_str:
        person_email_obj = PersonEmail.query.filter_by(email=encrypted_email).first()
        if person_email_obj: # Check if person_email_obj exists before accessing its person attribute
            person = person_email_obj.person

    if not person and phone_str:
        encrypted_phone = encrypt_data(phone_str)
        person_phone_obj = PersonPhone.query.filter_by(phone_number=encrypted_phone).first()
        if person_phone_obj: # Check if person_phone_obj exists before accessing its person attribute
            person = person_phone_obj.person

    try:
        if person:
            pass # Person already exists, no need to create a new one
        else:
            # Assuming a default data source with source_id = 1 exists
            default_source_id = 1
            person = Person(
                first_name=first_name,
                last_name=last_name,
                source_id=default_source_id,
                # Add other fields as necessary from the payload or defaults
            )
            db.session.add(person)
            db.session.flush() # Flush to get person.person_id

            if email_str:
                new_person_email = PersonEmail(
                    person_id=person.person_id,
                    email=encrypted_email,
                    email_type='Personal', # Default type
                    source_id=default_source_id
                )
                db.session.add(new_person_email)

            if phone_str:
                new_person_phone = PersonPhone(
                    person_id=person.person_id,
                    phone_number=encrypted_phone,
                    phone_type='Mobile', # Default type
                    source_id=default_source_id
                )
                db.session.add(new_person_phone)

        interaction_notes_list = []
        if notes_from_payload:
            interaction_notes_list.append(notes_from_payload)

        if interests_from_payload.get('wants_to_endorse'):
            interaction_notes_list.append("Expressed interest: Endorse.")
        if interests_from_payload.get('wants_to_get_involved'):
            interaction_notes_list.append("Expressed interest: Get Involved.")

        final_interaction_notes = " ".join(filter(None, interaction_notes_list)).strip()

        # Assuming a default data source with source_id = 1 exists
        default_source_id = 1
        new_interaction = PersonCampaignInteraction(
            person_id=person.person_id,
            campaign_id=campaign_id,
            user_id=1,
            interaction_type=interaction_type_from_payload,
            interaction_date=datetime.now(timezone.utc).date(), # Changed to .date() for DATE type
            details={'notes': final_interaction_notes} if final_interaction_notes else {'notes': "Website signup.'''"},
            source_id=default_source_id
        )
        db.session.add(new_interaction)

        db.session.commit()

        return jsonify({
            "message": "Signup processed successfully.",
            "person_id": person.person_id,
            "interaction_id": new_interaction.interaction_id
        }), 201

    except Exception as e:
        db.session.rollback()
        print(f"Error processing signup: {str(e)}")
        return jsonify({"error": "An internal error occurred. Please try again later."}), 500

@voters_api_bp.route('/', methods=['POST'])
@token_required
def create_person_via_portal(current_user):
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    required_fields = ['first_name', 'last_name']
    if any(field not in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    try:
        # Assuming a default data source with source_id = 1 exists
        default_source_id = 1
        person_data = {k: v for k, v in data.items() if k not in ['email_address', 'phone_number']}
        person_data['source_id'] = default_source_id

        new_person = Person(**person_data)
        db.session.add(new_person)
        db.session.flush() # Flush to get person.person_id

        email_str = data.get('email_address')
        if email_str:
            encrypted_email = encrypt_data(email_str)
            new_person_email = PersonEmail(
                person_id=new_person.person_id,
                email=encrypted_email,
                email_type='Personal', # Default type
                source_id=default_source_id
            )
            db.session.add(new_person_email)

        phone_str = data.get('phone_number')
        if phone_str:
            encrypted_phone = encrypt_data(phone_str)
            new_person_phone = PersonPhone(
                person_id=new_person.person_id,
                phone_number=encrypted_phone,
                phone_type='Mobile', # Default type
                source_id=default_source_id
            )
            db.session.add(new_person_phone)

        db.session.commit()

        return jsonify(new_person.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        print(f"Error creating person: {str(e)}")
        return jsonify({"error": "Failed to create person."}), 500

@voters_api_bp.route('/', methods=['GET'])
@token_required
def list_persons_via_portal(current_user):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)

    persons_query = Person.query.options(joinedload(Person.emails), joinedload(Person.phones))

    persons_page = persons_query.paginate(page=page, per_page=per_page, error_out=False)

    # Decrypt emails and phones for display
    persons_data = []
    for person in persons_page.items:
        person_dict = person.to_dict()
        person_dict['emails'] = [decrypt_data(pe.email) for pe in person.emails]
        person_dict['phones'] = [decrypt_data(pp.phone_number) for pp in person.phones]
        persons_data.append(person_dict)

    return jsonify({
        "persons": persons_data,
        "total_pages": persons_page.pages,
        "current_page": persons_page.page,
        "total_persons": persons_page.total
    }), 200

@voters_api_bp.route('/<int:person_id>', methods=['GET'])
@token_required
def get_person_detail_via_portal(current_user, person_id):
    person = Person.query.get_or_404(person_id)
    person_dict = person.to_dict()

    person_emails = PersonEmail.query.filter_by(person_id=person.person_id).all()
    person_phones = PersonPhone.query.filter_by(person_id=person.person_id).all()
    person_dict['emails'] = [decrypt_data(pe.email) for pe in person_emails]
    person_dict['phones'] = [decrypt_data(pp.phone_number) for pp in person_phones]

    return jsonify(person_dict), 200

@voters_api_bp.route('/<int:person_id>', methods=['PUT'])
@token_required
def update_person_via_portal(current_user, person_id):
    person = Person.query.get_or_404(person_id)
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    # Assuming a default data source with source_id = 1 exists
    default_source_id = 1

    for key, value in data.items():
        if key == 'email_address':
            # Handle email update: find existing or create new
            existing_email = PersonEmail.query.filter_by(person_id=person.person_id, email_type='Personal').first()
            if existing_email:
                existing_email.email = encrypt_data(value)
                existing_email.updated_at = datetime.now(timezone.utc)
            else:
                new_person_email = PersonEmail(
                    person_id=person.person_id,
                    email=encrypt_data(value),
                    email_type='Personal',
                    source_id=default_source_id
                )
                db.session.add(new_person_email)
        elif key == 'phone_number':
            # Handle phone update: find existing or create new
            existing_phone = PersonPhone.query.filter_by(person_id=person.person_id, phone_type='Mobile').first()
            if existing_phone:
                existing_phone.phone_number = encrypt_data(value)
                existing_phone.updated_at = datetime.now(timezone.utc)
            else:
                new_person_phone = PersonPhone(
                    person_id=person.person_id,
                    phone_number=encrypt_data(value),
                    phone_type='Mobile',
                    source_id=default_source_id
                )
                db.session.add(new_person_phone)
        elif hasattr(person, key) and key not in ['person_id', 'created_at', 'updated_at']:
            setattr(person, key, value)

    try:
        db.session.commit()
        return jsonify(person.to_dict()), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error updating person {person_id}: {str(e)}")
        return jsonify({"error": "Failed to update person."}), 500

@voters_api_bp.route('/<int:person_id>', methods=['DELETE'])
@token_required
def delete_person_via_portal(current_user, person_id):
    person = Person.query.get_or_404(person_id)
    try:
        db.session.delete(person)
        db.session.commit()
        return jsonify({"message": f"Person {person_id} deleted successfully."}), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error deleting person {person_id}: {str(e)}")
        return jsonify({"error": "Failed to delete person. It might be referenced elsewhere."}), 500

@voters_api_bp.route('/upload', methods=['POST'])
@token_required
def upload_persons(current_user):
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    if file:
        try:
            stream = io.TextIOWrapper(file.stream, encoding='utf-8')
            csv_input = csv.reader(stream)
            header = next(csv_input)
            # Assuming a default data source with source_id = 1 exists
            default_source_id = 1

            for row in csv_input:
                # Adjust column indices based on your CSV structure
                try:
                    first_name, last_name, email_str, phone_str = row[0], row[1], row[2], row[3] if len(row) > 3 else None
                except IndexError:
                    # Handle rows with missing columns
                    continue

                # Basic validation and sanitization
                if not first_name or not last_name:
                    continue # Skip rows with missing required fields

                first_name = first_name.strip().title()
                last_name = last_name.strip().title()
                email_str = email_str.strip().lower() if email_str else None
                phone_str = phone_str.strip() if phone_str else None

                # Add more robust validation here (e.g., email format)

                person = None
                if email_str:
                    encrypted_email = encrypt_data(email_str)
                    person_email_obj = PersonEmail.query.filter_by(email=encrypted_email).first()
                    if person_email_obj:
                        person = person_email_obj.person

                if not person and phone_str:
                    encrypted_phone = encrypt_data(phone_str)
                    person_phone_obj = PersonPhone.query.filter_by(phone_number=encrypted_phone).first()
                    if person_phone_obj:
                        person = person_phone_obj.person

                if not person:
                    person = Person(
                        first_name=first_name,
                        last_name=last_name,
                        source_id=default_source_id
                    )
                    db.session.add(person)
                    db.session.flush() # Flush to get person.person_id

                    if email_str:
                        new_person_email = PersonEmail(
                            person_id=person.person_id,
                            email=encrypt_data(email_str),
                            email_type='Personal',
                            source_id=default_source_id
                        )
                        db.session.add(new_person_email)

                    if phone_str:
                        new_person_phone = PersonPhone(
                            person_id=person.person_id,
                            phone_number=encrypt_data(phone_str),
                            phone_type='Mobile',
                            source_id=default_source_id
                        )
                        db.session.add(new_person_phone)
            db.session.commit()
            return jsonify({"message": "File processed successfully"}), 200
        except Exception as e:
            db.session.rollback()
            return jsonify({"error": str(e)}), 500