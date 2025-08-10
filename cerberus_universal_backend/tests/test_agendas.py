import pytest
import json
from app.extensions import db
from app.models import Agenda, AgendaItem, GovernmentBody, Subscription

@pytest.fixture
def setup_data(session):
    gov_body = GovernmentBody(body_name='Test City', jurisdiction='Test Jurisdiction')
    session.add(gov_body)
    session.commit()

    agenda = Agenda(body_id=gov_body.body_id, date='2024-01-01', pdf_url='http://example.com/agenda.pdf')
    session.add(agenda)
    session.commit()

    agenda_item = AgendaItem(agenda_id=agenda.id, item_text='Test item 1', category='Test Category', heading='Test Heading')
    session.add(agenda_item)
    session.commit()

    return gov_body, agenda, agenda_item

def test_search_no_filters(client, setup_data):
    response = client.get('/api/v1/agendas/search')
    assert response.status_code == 200
    data = response.get_json()
    assert len(data) == 1
    assert data[0]['item_text'] == 'Test item 1'

def test_search_with_keyword(client, setup_data):
    response = client.get('/api/v1/agendas/search?keyword=Test')
    assert response.status_code == 200
    data = response.get_json()
    assert len(data) == 1
    assert data[0]['item_text'] == 'Test item 1'

def test_search_with_municipality(client, setup_data):
    response = client.get('/api/v1/agendas/search?municipality=Test+City')
    assert response.status_code == 200
    data = response.get_json()
    assert len(data) == 1
    assert data[0]['municipality'] == 'Test City'

def test_subscribe(client, session):
    subscription_data = {
        "email": "test@example.com",
        "filter_settings": {"keyword": "test"}
    }
    response = client.post('/api/v1/agendas/subscribe', data=json.dumps(subscription_data), content_type='application/json')
    assert response.status_code == 201

    subscription = Subscription.query.filter_by(email="test@example.com").first()
    assert subscription is not None
    assert subscription.filter_settings['keyword'] == 'test'

def test_get_municipalities(client, setup_data):
    # Add the specific municipalities the endpoint looks for
    gov_body_1 = GovernmentBody(body_name='City of Progress')
    gov_body_2 = GovernmentBody(body_name='Town of Innovation')
    db.session.add_all([gov_body_1, gov_body_2])
    db.session.commit()

    response = client.get('/api/v1/agendas/municipalities')
    assert response.status_code == 200
    data = response.get_json()
    assert len(data) == 3
    assert 'City of Progress' in [d['name'] for d in data]
    assert 'Town of Innovation' in [d['name'] for d in data]

def test_get_categories(client, setup_data):
    response = client.get('/api/v1/agendas/categories')
    assert response.status_code == 200
    data = response.get_json()
    assert len(data) == 1
    assert data[0] == 'Test Category'

def test_get_headings(client, setup_data):
    response = client.get('/api/v1/agendas/headings')
    assert response.status_code == 200
    data = response.get_json()
    assert len(data) == 1
    assert data[0] == 'Test Heading'
