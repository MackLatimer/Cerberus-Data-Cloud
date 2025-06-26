import pytest
from app.models import Campaign, Voter, User, Interaction, SurveyQuestion, SurveyResponse, CampaignVoter
from app.extensions import db as app_db
from datetime import date, datetime, timezone
from sqlalchemy.exc import IntegrityError

def is_postgres_db(db_session):
    return "postgresql" in db_session.bind.engine.url.drivername

def test_create_campaign(session):
    campaign_name = "Test Campaign 2024"
    start = date(2024, 1, 1)
    end = date(2024, 11, 5)
    description = "This is a test campaign."
    campaign = Campaign(campaign_name=campaign_name, start_date=start, end_date=end, description=description)
    session.add(campaign)
    session.commit()
    assert campaign.campaign_id is not None
    assert campaign.campaign_name == campaign_name
    retrieved_campaign = session.get(Campaign, campaign.campaign_id)
    assert retrieved_campaign == campaign

def test_campaign_name_unique(session):
    campaign1 = Campaign(campaign_name="Unique Campaign Name")
    session.add(campaign1)
    session.commit()
    campaign2 = Campaign(campaign_name="Unique Campaign Name")
    session.add(campaign2)
    with pytest.raises(IntegrityError):
        session.commit()
    session.rollback()

def test_campaign_to_dict(session):
    campaign = Campaign(campaign_name="Dict Test Campaign", start_date=date(2023, 1, 1), description="Testing to_dict")
    session.add(campaign)
    session.commit()
    campaign_dict = campaign.to_dict()
    assert campaign_dict['campaign_id'] == campaign.campaign_id
    assert campaign_dict['campaign_name'] == "Dict Test Campaign"

def test_create_user(session):
    user = User(username="testuser", password="password123", email="test@example.com")
    session.add(user)
    session.commit()
    assert user.user_id is not None
    assert user.check_password("password123")

def test_user_username_unique(session):
    user1 = User(username="unique_user", password="password123")
    session.add(user1)
    session.commit()
    user2 = User(username="unique_user", password="password456")
    session.add(user2)
    with pytest.raises(IntegrityError):
        session.commit()
    session.rollback()

def test_create_voter(session):
    voter_data = {"first_name": "John", "last_name": "Doe", "email_address": "john.doe@example.com", "zip_code": "12345"}
    voter_data["custom_fields"] = {"source": "test_creation"}
    voter = Voter(**voter_data)
    session.add(voter)
    session.commit()
    assert voter.voter_id is not None
    assert voter.custom_fields == {"source": "test_creation"}


def test_voter_email_unique(session):
    voter1 = Voter(first_name="Jane", last_name="Doe", email_address="unique.voter@example.com")
    session.add(voter1)
    session.commit()
    voter2 = Voter(first_name="Jim", last_name="Beam", email_address="unique.voter@example.com")
    session.add(voter2)
    with pytest.raises(IntegrityError):
        session.commit()
    session.rollback()

def test_campaign_voter_association(session):
    campaign = Campaign(campaign_name="Assoc Test Campaign")
    voter = Voter(first_name="AssocVoter", last_name="Test", email_address="assoc@example.com")
    session.add_all([campaign, voter])
    session.commit()
    campaign_voter_assoc = CampaignVoter(campaign_id=campaign.campaign_id, voter_id=voter.voter_id)
    session.add(campaign_voter_assoc)
    session.commit()
    assert campaign_voter_assoc.campaign_voter_id is not None
    session.refresh(campaign); session.refresh(voter)
    assert campaign in [cv.campaign for cv in voter.campaigns_association.all()]
    assert voter in [cv.voter for cv in campaign.voters_association.all()]
    duplicate_assoc = CampaignVoter(campaign_id=campaign.campaign_id, voter_id=voter.voter_id)
    session.add(duplicate_assoc)
    with pytest.raises(IntegrityError):
        session.commit()
    session.rollback()

def test_create_interaction(session):
    campaign = Campaign(campaign_name="Interaction Campaign")
    voter = Voter(first_name="Interacting", last_name="Voter", email_address="interact@example.com")
    user = User(username="logger", password="password")
    session.add_all([campaign, voter, user])
    session.commit()
    interaction = Interaction(voter_id=voter.voter_id, campaign_id=campaign.campaign_id, user_id=user.user_id, interaction_type="Phone Call", outcome="Interested")
    session.add(interaction)
    session.commit()
    assert interaction.interaction_id is not None

def test_create_survey_question(session):
    sq_data = {"question_text": "What is your favorite color?", "question_type": "Multiple Choice"}
    sq_data["possible_answers"] = {"A": "Red", "B": "Blue"}
    question = SurveyQuestion(**sq_data)
    session.add(question)
    session.commit()
    assert question.question_id is not None
    assert question.possible_answers == {"A": "Red", "B": "Blue"}


def test_create_survey_response(session):
    voter = Voter(first_name="Responder", last_name="Test", email_address="responder@example.com")
    question_data = {"question_text": "Rate your experience (1-5)", "question_type": "Rating Scale"}
    question_data["possible_answers"] = {"1": "Bad", "5": "Good"}
    question = SurveyQuestion(**question_data)
    session.add_all([voter, question])
    session.commit()
    sr_data = {"voter_id": voter.voter_id, "question_id": question.question_id, "response_value": "5"}
    sr_data["response_values"] = ["Opt1", "Opt2"]
    response = SurveyResponse(**sr_data)
    session.add(response)
    session.commit()
    assert response.response_id is not None
    assert response.response_value == "5"
    assert response.response_values == ["Opt1", "Opt2"]
