from flask import Flask, request, jsonify, g
from flask_cors import CORS
import logging
import traceback
import os
import json
# Import the new database utility functions
from database import get_db_connection, with_db_connection

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    force=True  # Ensures basicConfig takes effect in GCP environments like Cloud Run
)

app = Flask(__name__)

# Configure CORS
CORS(app, origins=[
    "https://www.cerberuscampaigns.com", 
    "https://cerberuscampaigns.com", 
    "http://localhost:3000", 
    "http://localhost:8080",
    "https://8080-cs-9b9f5209-bdda-4e1f-a989-e1b50ec9ffba.cs-us-central1-pits.cloudshell.dev" # <-- ADDED THIS
], supports_credentials=True)

@app.route('/search', methods=['GET'])
@with_db_connection
def search():
    logging.info(f"Search request received with args: {request.args}")
    
    filter_mapping = {
        'category': 'ai.category',
        'heading': 'ai.heading',
    }
    query_params = []
    sql_conditions = []

    # --- Argument parsing (same as before) ---
    keyword = request.args.get('keyword', '').strip()
    municipality_name = request.args.get('municipality') if request.args.get('municipality', '').lower() not in ['all', ''] else None
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    if start_date:
        sql_conditions.append("a.date >= %s")
        query_params.append(start_date)
    if end_date:
        sql_conditions.append("a.date <= %s")
        query_params.append(end_date)
    if municipality_name:
        sql_conditions.append("m.name = %s")
        query_params.append(municipality_name)
    for wix_filter_name, db_column in filter_mapping.items():
        value = request.args.get(wix_filter_name)
        if value and value.lower() not in ['all', '']:
            sql_conditions.append(f"{db_column} = %s")
            query_params.append(value)
    if keyword:
        keyword_search_fields = ['m.name', 'ai.category', 'ai.heading', 'ai.item_text']
        keyword_conditions_group = " OR ".join([f"{field} ILIKE %s" for field in keyword_search_fields])
        sql_conditions.append(f"({keyword_conditions_group})")
        for _ in keyword_search_fields:
            query_params.append(f"%{keyword}%")
    # --- End of argument parsing ---

    base_query = """
        SELECT ai.id, ai.heading, ai.file_prefix, 
               ai.item_text, ai.category,
               m.name AS municipality, 
               a.date, a.pdf_url
        FROM agenda_items ai
        JOIN agendas a ON ai.agenda_id = a.id
        JOIN municipalities m ON a.municipality_id = m.id
    """
    full_query = base_query
    if sql_conditions:
        full_query += " WHERE " + " AND ".join(sql_conditions)
    full_query += " ORDER BY a.date DESC, m.name, ai.id"
    
    logging.info(f"Executing search query: {full_query}")
    logging.info(f"With params: {query_params}")

    try:
        with g.db_conn.cursor() as cur:
            cur.execute(full_query, tuple(query_params))
            results = cur.fetchall()
            column_names = [desc[0] for desc in cur.description]
            items = [dict(zip(column_names, row)) for row in results]
            logging.info(f"Query returned {len(items)} results.")
            return jsonify(items)
    except Exception as e:
        logging.error(f"Error in /search endpoint: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error during search"}), 500

@app.route('/subscribe', methods=['POST'])
@with_db_connection
def subscribe():
    data = request.get_json()
    if not data:
        logging.warning("No JSON data received for /subscribe")
        return jsonify({"error": "Invalid JSON payload"}), 400

    email = data.get('email')
    filter_settings = data.get('filter_settings') 

    if not email or not filter_settings or not isinstance(filter_settings, dict):
        logging.warning(f"Missing email or invalid filter_settings in /subscribe. Email: {email}")
        return jsonify({"error": "Email and valid filter_settings (JSON object) are required"}), 400
        
    logging.info(f"Subscription attempt for {email} with filters: {filter_settings}")
    try:
        with g.db_conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO subscriptions (email, filter_settings, active)
                VALUES (%s, %s, TRUE)
                ON CONFLICT (email)
                DO UPDATE SET filter_settings = EXCLUDED.filter_settings, active = TRUE
                """,
                (email, json.dumps(filter_settings))
            )
        g.db_conn.commit() # Make sure to commit changes
        logging.info(f"Subscription created/updated successfully for {email}")
        return jsonify({"message": "Subscription successful!"}), 201
    except Exception as e:
        logging.error(f"Error in /subscribe endpoint for {email}: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error during subscription"}), 500

@app.route('/webhook/order_canceled', methods=['POST'])
def order_canceled():
    try:
        # Outer try for request parsing and initial validation
        data = request.get_json()
        if not data or 'data' not in data or 'email' not in data['data']: 
            logging.warning(f"Invalid or missing data in order_canceled webhook: {data}")
            return jsonify({"error": "Invalid payload"}), 400
        
        email = data['data']['email']
        logging.info(f"Received order_canceled webhook for email: {email}")
        conn = None
        cur = None
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("UPDATE subscriptions SET active = FALSE WHERE email = %s", (email,))
            conn.commit()
            logging.info(f"Subscription deactivated for {email} due to order cancellation.")
            return jsonify({"message": "Subscription deactivated"}), 200
        except Exception as e:
            if conn:
                conn.rollback()
            logging.error(f"Error in /webhook/order_canceled: {e}\n{traceback.format_exc()}")
            return jsonify({"error": "Internal server error"}), 500
        finally:
            if cur:
                cur.close()
            if conn:
                conn.close()
    except Exception as e: # Catch error from request.get_json() or initial validation
        logging.error(f"Outer error in /webhook/order_canceled: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error"}), 500

@app.route('/webhook/order_renewed', methods=['POST'])
def order_renewed():
    try:
        # Outer try for request parsing and initial validation
        data = request.get_json()
        if not data or 'data' not in data or 'email' not in data['data']: 
            logging.warning(f"Invalid or missing data in order_renewed webhook: {data}")
            return jsonify({"error": "Invalid payload"}), 400

        email = data['data']['email']
        logging.info(f"Received order_renewed webhook for email: {email}")
        conn = None
        cur = None
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("UPDATE subscriptions SET active = TRUE WHERE email = %s", (email,))
            conn.commit()
            logging.info(f"Subscription reactivated for {email} due to order renewal.")
            return jsonify({"message": "Subscription reactivated"}), 200
        except Exception as e:
            if conn:
                conn.rollback()
            logging.error(f"Error in /webhook/order_renewed: {e}\n{traceback.format_exc()}")
            return jsonify({"error": "Internal server error"}), 500
        finally:
            if cur:
                cur.close()
            if conn:
                conn.close()
    except Exception as e: # Catch error from request.get_json() or initial validation
        logging.error(f"Outer error in /webhook/order_renewed: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error"}), 500

@app.route('/municipalities', methods=['GET'])
def get_municipalities():
    conn = None
    cur = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        # Execute the query to get IDs and names for specific municipalities
        cur.execute("SELECT id, name FROM municipalities WHERE name IN ('City of Progress', 'Town of Innovation')")
        # Fetch all results
        results = cur.fetchall()
        # Get column names from cursor description
        column_names = [desc[0] for desc in cur.description]
        # Convert results to a list of dictionaries
        municipalities = [dict(zip(column_names, row)) for row in results]

        if not municipalities:
            logging.info("Municipalities 'City of Progress' or 'Town of Innovation' not found.")
            return jsonify({"message": "Specified municipalities not found"}), 404

        return jsonify(municipalities)
    except Exception as e:
        logging.error(f"Error in /municipalities endpoint: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error"}), 500
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

@app.route('/categories', methods=['GET'])
def get_categories():
    conn = None
    cur = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT DISTINCT category FROM agenda_items WHERE category IS NOT NULL AND category <> '' ORDER BY category")
        categories = [row[0] for row in cur.fetchall()] # MODIFIED: category is row[0]
        return jsonify(categories)
    except Exception as e:
        logging.error(f"Error in /categories endpoint: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error"}), 500
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

@app.route('/headings', methods=['GET'])
def get_headings():
    conn = None
    cur = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT DISTINCT heading FROM agenda_items WHERE heading IS NOT NULL AND heading <> '' ORDER BY heading")
        headings = [row[0] for row in cur.fetchall()] # MODIFIED: heading is row[0]
        return jsonify(headings)
    except Exception as e:
        logging.error(f"Error in /headings endpoint: {e}\n{traceback.format_exc()}")
        return jsonify({"error": "Internal server error"}), 500
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

@app.route('/test_db', methods=['GET'])
def test_db():
    conn = None
    cur = None  # Define cur here for the finally block
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT 1") # A minimal query to test execution
        cur.fetchone() # Ensure the query can be fetched
        # logging.info("Database connection test successful via /test_db.")
        return jsonify({"message": "Database connection successful"})
    except Exception as e:
        logging.error(f"Database connection test failed in /test_db: {e}\n{traceback.format_exc()}")
        return jsonify({"message": f"Database connection failed: {str(e)}"}), 500
    finally:
        if cur: # Ensure cur is closed if it was created
            cur.close()
        if conn:
            conn.close()

@app.route('/', methods=['GET'])
@app.route('/test', methods=['GET']) 
def health_check():
    """Basic health check endpoint."""
    logging.info("Health check endpoint was hit.")
    return jsonify({"message": "API is running and healthy!"}), 200

@app.route('/debug_db_url', methods=['GET'])
def debug_db_url():
    env_vars_status = {
        "INSTANCE_CONNECTION_NAME_is_set": bool(os.environ.get("INSTANCE_CONNECTION_NAME")),
        "DB_USER_is_set": bool(os.environ.get("DB_USER")),
        "DB_PASS_is_set": bool(os.environ.get("DB_PASS")), # Only checks presence, not value
        "DB_NAME_is_set": bool(os.environ.get("DB_NAME"))
    }
    return jsonify({
        "env_vars_check": env_vars_status,
        "NOTE": "This checks if the environment variables needed by google-cloud-sqlconnector are set."
    }), 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080)) 
    # For local development, set debug=True if you want. For production (like Cloud Run), it should be False.
    # Example: app.run(host="0.0.0.0", port=port, debug=os.environ.get('FLASK_DEBUG', 'False').lower() == 'true')
    app.run(host="0.0.0.0", port=port)