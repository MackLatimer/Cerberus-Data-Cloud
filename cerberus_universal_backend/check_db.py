import os
import pg8000.dbapi

try:
    conn = pg8000.dbapi.connect(
        host='db',
        user=os.environ.get('POSTGRES_USER'),
        password=os.environ.get('POSTGRES_PASSWORD'),
        database=os.environ.get('POSTGRES_DB')
    )
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM alembic_version")
    print("Database already initialized.")
    exit(0)
except Exception as e:
    print("Database not initialized, running migrations.")
    exit(1)
