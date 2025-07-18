import os
import logging
from functools import wraps
from flask import g, jsonify
from google.cloud.sql.connector import Connector, IPTypes

connector = None

def init_connector():
    """Initializes the global connector object."""
    global connector
    if connector is None:
        connector = Connector()

def get_db_connection():
    """Establishes a database connection using the global connector."""
    init_connector()
    instance_connection_name = os.environ.get("INSTANCE_CONNECTION_NAME")
    db_user = os.environ.get("DB_USER")
    db_pass = os.environ.get("DB_PASS")
    db_name = os.environ.get("DB_NAME")

    if not all([instance_connection_name, db_user, db_pass, db_name]):
        raise ValueError("Missing database configuration for sqlconnector.")

    return connector.connect(
        instance_connection_name,
        "pg8000",
        user=db_user,
        password=db_pass,
        db=db_name,
        ip_type=IPTypes.PUBLIC
    )

def with_db_connection(f):
    """A decorator to handle database connection for Flask routes."""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        try:
            g.db_conn = get_db_connection()
            return f(*args, **kwargs)
        finally:
            if 'db_conn' in g and g.db_conn:
                g.db_conn.close()
    return decorated_function