import pytest
import json
from app.models import Person, PersonCampaignInteraction, Campaign, PersonEmail, PersonPhone, DataSource
from app.extensions import db


@pytest.mark.skip_if_sqlite
def test_create_signup_success_new_voter(client, session, setup_data_source):
    campaign = Campaign(campaign_name="Test Campaign for Signups", source_id=setup_data_source.source_id)
    session.add(campaign)
    session.commit()

    signup_data = {
        "first_name": "New", "last_name": "Voter", "email_address": "new.voter@example.com",
        "phone_number": "1234567890", "campaign_id": campaign.campaign_id,
        "notes": "Signed up via API test.", "interaction_type": "ContactForm", # Updated to match new ENUM
        "interests": {"wants_to_endorse": True, "wants_to_get_involved": False}
    }
    response = client.post('/api/v1/signups', data=json.dumps(signup_data), content_type='application/json')
    assert response.status_code == 201
    response_data = response.get_json()
    assert response_data["message"] == "Signup processed successfully."
    
    person = session.get(Person, response_data["person_id"])
    assert person is not None and person.first_name == "New"

    person_email = PersonEmail.query.filter_by(person_id=person.person_id).first()
    assert person_email is not None
    assert person_email.email == "new.voter@example.com"

    person_phone = PersonPhone.query.filter_by(person_id=person.person_id).first()
    assert person_phone is not None
    assert person_phone.phone_number == "1234567890"

    interaction = session.get(PersonCampaignInteraction, response_data["interaction_id"])
    assert interaction is not None
    assert interaction.details['notes'] == "Signed up via API test. Expressed interest: Endorse."

@pytest.mark.skip_if_sqlite
def test_create_signup_success_existing_voter_by_email(client, session, setup_data_source):
    campaign = Campaign(campaign_name="Signup Campaign Existing Email", source_id=setup_data_source.source_id)
    existing_person = Person(first_name="Existing", last_name="User", source_id=setup_data_source.source_id)
    session.add(existing_person)
    session.flush()

    existing_email = PersonEmail(person_id=existing_person.person_id, email="existing.user@example.com", email_type="Personal", source_id=setup_data_source.source_id)
    existing_phone = PersonPhone(person_id=existing_person.person_id, phone_number="0000000000", phone_type="Mobile", source_id=setup_data_source.source_id)
    session.add_all([campaign, existing_email, existing_phone])
    session.commit()

    original_person_id = existing_person.person_id
    signup_data = {
        "first_name": "Existing", "last_name": "UserUpdated", "email_address": "existing.user@example.com",
        "phone_number": "1112223333", "campaign_id": campaign.campaign_id,
        "notes": "Re-signed up with new interest.", "interaction_type": "ContactForm", # Updated to match new ENUM
        "interests": {"wants_to_get_involved": True}
    }
    response = client.post('/api/v1/signups', data=json.dumps(signup_data), content_type='application/json')
    assert response.status_code == 201
    response_data = response.get_json()
    assert response_data["person_id"] == original_person_id
    
    interaction = session.get(PersonCampaignInteraction, response_data["interaction_id"])
    assert interaction is not None
    assert interaction.details['notes'] == "Re-signed up with new interest. Expressed interest: Get Involved."


def test_create_signup_missing_required_fields(client, session, setup_data_source):
    campaign = Campaign(campaign_name="Signup Missing Fields Camp", source_id=setup_data_source.source_id)
    session.add(campaign)
    session.commit()
    signup_data = {"first_name": "Test", "campaign_id": campaign.campaign_id}
    response = client.post('/api/v1/signups', data=json.dumps(signup_data), content_type='application/json')
    assert response.status_code == 400
    response_data = response.get_json()
    assert "Missing required fields" in response_data["error"]

def test_create_signup_invalid_campaign_id(client, session, setup_data_source):
    signup_data = {
        "first_name": "Invalid", "last_name": "Campaigner", "email_address": "invalid.campaign@example.com",
        "campaign_id": 99999
    }
    response = client.post('/api/v1/signups', data=json.dumps(signup_data), content_type='application/json')
    assert response.status_code == 404

def test_create_signup_no_payload(client, session):
    response = client.post('/api/v1/signups', content_type='application/json') # No data sent
    assert response.status_code == 400
    assert "Invalid or empty JSON payload" in response.get_json()["error"]

def test_create_signup_empty_payload(client, session):
    response = client.post('/api/v1/signups', data=json.dumps({}), content_type='application/json')
    assert response.status_code == 400
    assert "Invalid or empty JSON payload" in response.get_json()["error"]