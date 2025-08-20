import os
import pg8000.dbapi
import time

# Retry connecting to the database for a few seconds
for i in range(10):
    try:
        conn = pg8000.dbapi.connect(
            host='db',
            user=os.environ.get('POSTGRES_USER'),
            password=os.environ.get('POSTGRES_PASSWORD'),
            database=os.environ.get('POSTGRES_DB')
        )
        break
    except Exception as e:
        print(f"Waiting for database to be ready... ({e})")
        time.sleep(1)
else:
    print("Could not connect to the database.")
    exit(1)

try:
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM campaigns LIMIT 1")
    print("Database already initialized.")
    exit(0)
except Exception as e:
    print("Database not initialized, running migrations.")
    exit(1)
finally:
    conn.close()