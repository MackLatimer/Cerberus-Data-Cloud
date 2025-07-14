import os
from io import BytesIO
from unittest.mock import patch

def test_upload_voters(client, session):
    """
    Tests the voter upload functionality.
    """
    # Create a dummy CSV file
    csv_data = b"first_name,last_name,email_address\nJohn,Doe,john.doe@example.com\nJane,Doe,jane.doe@example.com"
    data = {
        'file': (BytesIO(csv_data), 'test.csv')
    }

    # Make a POST request to the upload endpoint
    response = client.post('/api/v1/voters/upload', data=data, content_type='multipart/form-data')

    # Assert that the request was successful
    assert response.status_code == 200
    assert response.json['message'] == 'File processed successfully'

    # You would also want to assert that the voters were actually added to the database.
    # This would require querying the database and checking for the new records.
    # For example:
    # from app.models import Voter
    # assert Voter.query.count() == 2
    # assert Voter.query.filter_by(email_address='john.doe@example.com').first() is not None
    # assert Voter.query.filter_by(email_address='jane.doe@example.com').first() is not None
