import os
from io import BytesIO
from unittest.mock import patch

def test_upload_voters(client, session):
    csv_data = b"first_name,last_name,email_address\nJohn,Doe,john.doe@example.com\nJane,Doe,jane.doe@example.com"
    data = {
        'file': (BytesIO(csv_data), 'test.csv')
    }

    response = client.post('/api/v1/voters/upload', data=data, content_type='multipart/form-data')

    assert response.status_code == 200
    assert response.json['message'] == 'File processed successfully'

