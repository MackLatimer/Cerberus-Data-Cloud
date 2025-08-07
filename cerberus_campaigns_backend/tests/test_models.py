import pytest
from app.models import (Campaign, Person, User, PersonCampaignInteraction,
                        SurveyResult, DataSource, PersonEmail, PersonPhone, Voter)
from app.extensions import db as app_db
from datetime import date, datetime, timezone
from sqlalchemy.exc import IntegrityError
from sqlalchemy import text
from app.config import current_config

PGCRYPTO_SECRET_KEY = current_config.PGCRYPTO_SECRET_KEY

def encrypt_data(data):
    if data is None: return None
    return app_db.session.scalar(text("SELECT pgp_sym_encrypt(:data, :key)"), {'data': data, 'key': PGCRYPTO_SECRET_KEY})

def decrypt_data(data):
    if data is None: return None
    return app_db.session.scalar(text("SELECT pgp_sym_decrypt(:data, :key)"), {'data': data, 'key': PGCRYPTO_SECRET_KEY})

@pytest.fixture(scope='function')
def setup_data_source(session):
    # Ensure a default data source exists for tests
    data_source = DataSource.query.get(1)
    if not data_source:
        data_source = DataSource(source_id=1, source_name="Test Source", source_type="Manual")
        session.add(data_source)
        session.commit()
    return data_source

def is_postgres_db(db_session):
    return "postgresql" in db_session.bind.engine.url.drivername

def test_create_campaign(session, setup_data_source, skip_if_sqlite):
    campaign_name = "Test Campaign 2024"
    start = date(2024, 1, 1)
    end = date(2024, 11, 5)
    details = {"description": "This is a test campaign."}
    campaign = Campaign(campaign_name=campaign_name, start_date=start, end_date=end, details=details, source_id=setup_data_source.source_id)
    session.add(campaign)
    session.commit()
    assert campaign.campaign_id is not None
    assert campaign.campaign_name == campaign_name
    assert campaign.details["description"] == "This is a test campaign."
    retrieved_campaign = session.get(Campaign, campaign.campaign_id)
    assert retrieved_campaign == campaign

def test_campaign_name_unique(session, setup_data_source):
    campaign1 = Campaign(campaign_name="Unique Campaign Name", source_id=setup_data_source.source_id)
    session.add(campaign1)
    session.flush()
    campaign2 = Campaign(campaign_name="Unique Campaign Name", source_id=setup_data_source.source_id)
    session.add(campaign2)
    with pytest.raises(IntegrityError):
        session.flush()

def test_campaign_to_dict(session, setup_data_source):
    campaign = Campaign(campaign_name="Dict Test Campaign", start_date=date(2023, 1, 1), details={"description": "Testing to_dict"}, source_id=setup_data_source.source_id)
    session.add(campaign)
    session.commit()
    campaign_dict = campaign.to_dict()
    assert campaign_dict['campaign_id'] == campaign.campaign_id
    assert campaign_dict['campaign_name'] == "Dict Test Campaign"
    assert campaign_dict['details']['description'] == "Testing to_dict"

def test_create_user(session):
    user = User(username="testuser", password="password123", email="test@example.com")
    session.add(user)
    session.commit()
    assert user.user_id is not None
    assert user.check_password("password123")

def test_user_username_unique(session):
    user1 = User(username="unique_user", password="password123")
    session.add(user1)
    session.flush()
    user2 = User(username="unique_user", password="password456")
    session.add(user2)
    with pytest.raises(IntegrityError):
        session.flush()

def test_create_person(session, setup_data_source):
    person_data = {"first_name": "John", "last_name": "Doe", "source_id": setup_data_source.source_id}
    person = Person(**person_data)
    session.add(person)
    session.flush()

    email_address = "john.doe@example.com"
    phone_number = "1234567890"

    person_email = PersonEmail(person_id=person.person_id, email=email_address, email_type="Personal", source_id=setup_data_source.source_id)
    person_phone = PersonPhone(person_id=person.person_id, phone_number=phone_number, phone_type="Mobile", source_id=setup_data_source.source_id)

    session.add_all([person_email, person_phone])
    session.commit()

    assert person.person_id is not None
    assert person_email.email == email_address
    assert person_phone.phone_number == phone_number

def test_person_email_unique(session, setup_data_source):
    person1 = Person(first_name="Jane", last_name="Doe", source_id=setup_data_source.source_id)
    session.add(person1)
    session.flush()
    person_email1 = PersonEmail(person_id=person1.person_id, email="unique.person@example.com", email_type="Personal", source_id=setup_data_source.source_id)
    session.add(person_email1)
    session.flush()

    person2 = Person(first_name="Jim", last_name="Beam", source_id=setup_data_source.source_id)
    session.add(person2)
    session.flush()
    person_email2 = PersonEmail(person_id=person2.person_id, email="unique.person@example.com", email_type="Personal", source_id=setup_data_source.source_id)
    session.add(person_email2)
    with pytest.raises(IntegrityError):
        session.flush()

def test_create_person_campaign_interaction(session, setup_data_source, skip_if_sqlite):
    campaign = Campaign(campaign_name="Interaction Campaign", source_id=setup_data_source.source_id)
    person = Person(first_name="Interacting", last_name="Person", source_id=setup_data_source.source_id)
    user = User(username="logger", password="password")
    session.add_all([campaign, person, user])
    session.commit()
    
    interaction = PersonCampaignInteraction(
        person_id=person.person_id,
        campaign_id=campaign.campaign_id,
        user_id=user.user_id,
        interaction_type="ContactForm", # Updated to match new ENUM
        interaction_date=date.today(),
        amount=100.00,
        follow_up_needed=True,
        details={'notes': 'Spoke about policy.'},
        confidence_score=80,
        source_id=setup_data_source.source_id
    )
    session.add(interaction)
    session.commit()
    assert interaction.interaction_id is not None
    assert interaction.details['notes'] == 'Spoke about policy.'

def test_create_survey_result(session, setup_data_source, skip_if_sqlite):
    campaign = Campaign(campaign_name="Survey Campaign", source_id=setup_data_source.source_id)
    session.add(campaign)
    session.commit()

    voter = Voter(first_name="Survey", last_name="Taker", source_campaign_id=campaign.campaign_id)
    session.add(voter)
    session.commit()

    survey_data = {
        "voter_id": voter.voter_id,
        "survey_date": date.today(),
        "survey_source": "Website",
        "responses": {"q1": "answer1", "q2": "answer2"},
        "confidence_score": 90,
        "response_time": 120,
        "survey_channel": "Online",
        "completion_status": "Complete",
        "source_id": setup_data_source.source_id
    }
    survey_result = SurveyResult(**survey_data)
    session.add(survey_result)
    session.commit()

    assert survey_result.survey_id is not None
    assert survey_result.responses == {"q1": "answer1", "q2": "answer2"}
    assert survey_result.search_vector is not None # Should be populated by trigger
