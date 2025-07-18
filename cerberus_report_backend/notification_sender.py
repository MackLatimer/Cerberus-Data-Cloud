import os
import json
from datetime import datetime, timedelta, timezone
import logging
import traceback

# Attempt to import SendGrid, fail gracefully if not installed for local testing without email sending
try:
    from sendgrid import SendGridAPIClient
    from sendgrid.helpers.mail import Mail
    SENDGRID_AVAILABLE = True
except ImportError:
    logging.warning("SendGrid library not found. Email sending will be disabled.")
    SENDGRID_AVAILABLE = False

from google.cloud.sql.connector import Connector, IPTypes
# pg8000 is used by the connector but not directly imported

# --- Configuration ---
# Basic Logging Setup
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(module)s - %(funcName)s - %(message)s',
    force=True
)

# SendGrid Configuration
SENDGRID_API_KEY = os.environ.get("SENDGRID_API_KEY")
SENDER_EMAIL = os.environ.get("SENDER_EMAIL")

if SENDGRID_AVAILABLE:
    if not SENDGRID_API_KEY:
        logging.error("SENDGRID_API_KEY environment variable not set. Email notifications will fail.")
    if not SENDER_EMAIL:
        logging.error("SENDER_EMAIL environment variable not set. Email notifications will fail.")

# Import the shared database connection utility
from database import get_db_connection

# Database Configuration (from environment variables, similar to api.py)
INSTANCE_CONNECTION_NAME = os.environ.get("INSTANCE_CONNECTION_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_NAME = os.environ.get("DB_NAME")

# Application Base URL (for links in emails)
APP_BASE_URL = os.environ.get("APP_BASE_URL", "http://localhost:3000") # Default for local dev

def check_env_vars():
    """Checks if all necessary environment variables are set."""
    required_db_vars = {
        "INSTANCE_CONNECTION_NAME": INSTANCE_CONNECTION_NAME,
        "DB_USER": DB_USER,
        "DB_PASS_is_set": "yes" if DB_PASS else "no",
        "DB_NAME": DB_NAME
    }
    missing_db_vars = [var for var, val in required_db_vars.items() if not val or (var == "DB_PASS_is_set" and val == "no")]
    if missing_db_vars:
        logging.error(f"Missing database connection environment variables: {', '.join(missing_db_vars)}")
        return False

    if SENDGRID_AVAILABLE:
        if not SENDGRID_API_KEY or not SENDER_EMAIL:
            logging.error("SendGrid API Key or Sender Email not configured. Email sending will be skipped.")
            # Allow script to run for testing other parts, but emails won't send.
            # return False
    elif not SENDGRID_AVAILABLE:
        logging.warning("SendGrid library not installed. Email sending is disabled.")
        # Allow script to run for testing other parts.

    return True



def send_email_notification(recipient_email: str, subject: str, html_content: str) -> bool:
    """
    Sends an email notification using SendGrid.
    Returns True if the email was sent successfully (or if SendGrid is disabled), False otherwise.
    """
    if not SENDGRID_AVAILABLE:
        logging.warning(f"SendGrid library not available. Skipping email to {recipient_email}.")
        return True # Indicate success to allow workflow to proceed (e.g., update last_checked)

    if not SENDGRID_API_KEY or not SENDER_EMAIL:
        logging.error(f"SendGrid API Key or Sender Email not configured. Cannot send email to {recipient_email}.")
        return False

    message = Mail(
        from_email=SENDER_EMAIL,
        to_emails=recipient_email,
        subject=subject,
        html_content=html_content
    )
    try:
        sg = SendGridAPIClient(SENDGRID_API_KEY)
        response = sg.send(message)
        if response.status_code >= 200 and response.status_code < 300:
            logging.info(f"Email sent successfully to {recipient_email}. Status code: {response.status_code}")
            return True
        else:
            logging.error(f"Failed to send email to {recipient_email}. Status code: {response.status_code}. Body: {response.body}")
            return False
    except Exception as e:
        logging.error(f"Error sending email to {recipient_email}: {e}\n{traceback.format_exc()}")
        return False


def fetch_new_agenda_items(db_conn, filter_settings: dict, last_checked_timestamp: datetime) -> list:
    """
    Fetches new agenda items from the database based on filter_settings and last_checked_timestamp.
    Uses agenda_items.created_at for checking newness.
    """
    items = []
    if not db_conn:
        logging.error("No database connection available for fetching agenda items.")
        return items

    cur = None
    try:
        cur = db_conn.cursor()

        base_query = """
            SELECT ai.id, ai.heading, ai.file_prefix,
                   ai.item_text, ai.category,
                   m.name AS municipality_name,
                   a.date AS agenda_date, a.pdf_url,
                   ai.created_at
            FROM agenda_items ai
            JOIN agendas a ON ai.agenda_id = a.id
            JOIN municipalities m ON a.municipality_id = m.id
        """

        sql_conditions = []
        query_params = []

        # Filter based on filter_settings
        keyword = filter_settings.get('keyword', '').strip()
        municipality_name_filter = filter_settings.get('municipality') # From filter_settings
        start_date_filter = filter_settings.get('start_date')
        end_date_filter = filter_settings.get('end_date')
        heading_filter = filter_settings.get('heading')
        category_filter = filter_settings.get('category')

        if start_date_filter:
            sql_conditions.append("a.date >= %s")
            query_params.append(start_date_filter)
        if end_date_filter:
            sql_conditions.append("a.date <= %s")
            query_params.append(end_date_filter)
        if municipality_name_filter and municipality_name_filter.lower() not in ['all', '']:
            sql_conditions.append("m.name = %s")
            query_params.append(municipality_name_filter)
        if heading_filter and heading_filter.lower() not in ['all', '']:
            sql_conditions.append("ai.heading = %s")
            query_params.append(heading_filter)
        if category_filter and category_filter.lower() not in ['all', '']:
            sql_conditions.append("ai.category = %s")
            query_params.append(category_filter)

        if keyword:
            keyword_search_fields = ['m.name', 'ai.category', 'ai.heading', 'ai.item_text']
            keyword_conditions_group = " OR ".join([f"{field} ILIKE %s" for field in keyword_search_fields])
            sql_conditions.append(f"({keyword_conditions_group})")
            for _ in keyword_search_fields:
                query_params.append(f"%{keyword}%")

        # Crucial condition for newness
        sql_conditions.append("ai.created_at > %s")
        query_params.append(last_checked_timestamp)

        full_query = base_query
        if sql_conditions:
            full_query += " WHERE " + " AND ".join(sql_conditions)
        full_query += " ORDER BY ai.created_at DESC, m.name, ai.id" # Or a.date DESC

        logging.info(f"Executing fetch_new_agenda_items query: {full_query} with params: {query_params}")
        cur.execute(full_query, tuple(query_params))
        results = cur.fetchall()

        column_names = [desc[0] for desc in cur.description]
        items = [dict(zip(column_names, row)) for row in results]
        logging.info(f"Found {len(items)} new agenda items matching criteria.")

    except Exception as e:
        logging.error(f"Error fetching new agenda items: {e}\n{traceback.format_exc()}")
        # Optionally, rollback if any write operations were planned (not in this read-only func)
        # if db_conn:
        #     db_conn.rollback()
    finally:
        if cur:
            cur.close()
    return items


def format_html_content(new_items: list) -> str:
    """Formats a list of new agenda items into a user-friendly HTML email."""
    if not new_items:
        return "<p>No new agenda items matching your criteria were found at this time.</p>"

    html = "<h1>New Agenda Items</h1>"
    html += "<p>Here are the latest agenda items matching your filter criteria:</p>"
    html += "<ul>"

    for item in new_items:
        html += "<li>"
        html += f"<h3>{item.get('heading', 'No Heading')}</h3>"
        html += f"<p><strong>Municipality:</strong> {item.get('municipality_name', 'N/A')}</p>"

        agenda_date = item.get('agenda_date')
        if isinstance(agenda_date, datetime):
            agenda_date_str = agenda_date.strftime('%Y-%m-%d')
        elif isinstance(agenda_date, str): # Should be date object from DB, but good to be safe
            agenda_date_str = agenda_date
        else:
            agenda_date_str = 'N/A'
        html += f"<p><strong>Agenda Date:</strong> {agenda_date_str}</p>"

        if item.get('category'):
            html += f"<p><strong>Category:</strong> {item.get('category')}</p>"

        item_text_snippet = item.get('item_text', '')
        if item_text_snippet and len(item_text_snippet) > 200:
            item_text_snippet = item_text_snippet[:200] + "..."
        html += f"<p><em>{item_text_snippet}</em></p>"

        pdf_url = item.get('pdf_url')
        if pdf_url:
            html += f'<p><a href="{pdf_url}">View Full Agenda PDF</a></p>'

        # Link to a specific item page - placeholder, as item-specific pages might not exist
        # item_detail_url = f"{APP_BASE_URL}/item/{item.get('id')}" # Assuming an item detail page
        # html += f'<p><a href="{item_detail_url}">View Item Details</a></p>'
        html += "</li><hr/>"

    html += "</ul>"
    html += f"<p>You can adjust your notification settings or search for more items at <a href='{APP_BASE_URL}'>{APP_BASE_URL}</a>.</p>"
    return html

def process_subscriptions(db_conn):
    """
    Fetches active subscriptions, checks for new items, and sends notifications.
    """
    if not db_conn:
        logging.error("No database connection available for processing subscriptions.")
        return

    cur = None
    try:
        cur = db_conn.cursor()
        cur.execute("""
            SELECT id, email, filter_settings, last_checked
            FROM subscriptions
            WHERE active = TRUE;
        """)
        subscriptions = cur.fetchall()

        if not subscriptions:
            logging.info("No active subscriptions found.")
            return

        # Get column names to access by dict key
        column_names = [desc[0] for desc in cur.description]

        for sub_row in subscriptions:
            subscription = dict(zip(column_names, sub_row))
            sub_id = subscription['id']
            email = subscription['email']
            filter_settings = subscription['filter_settings'] # Already a dict if JSONB from DB
            last_checked_db = subscription['last_checked'] # This will be a datetime object if not NULL

            logging.info(f"Processing subscription for {email} (ID: {sub_id}). Last checked: {last_checked_db}")

            # Determine the effective last_checked_timestamp for fetching items
            if last_checked_db:
                # Ensure it's timezone-aware (UTC, as NOW() in PostgreSQL is often UTC)
                effective_last_checked = last_checked_db.replace(tzinfo=timezone.utc) if last_checked_db.tzinfo is None else last_checked_db
            else:
                # If never checked, fetch items from the last 24 hours
                effective_last_checked = datetime.now(timezone.utc) - timedelta(days=1)
                logging.info(f"Subscription for {email} never checked. Using default timespan: last 24 hours.")

            new_items = fetch_new_agenda_items(db_conn, filter_settings, effective_last_checked)

            current_time_utc = datetime.now(timezone.utc) # For updating last_checked

            if new_items:
                logging.info(f"Found {len(new_items)} new items for {email}.")
                subject = "New Agenda Items Matching Your Filters"
                html_content = format_html_content(new_items)

                email_sent = send_email_notification(email, subject, html_content)

                if email_sent:
                    # Update last_checked to current time if email was sent successfully
                    # or if SendGrid is disabled (to avoid re-sending)
                    try:
                        update_cur = db_conn.cursor()
                        update_cur.execute("UPDATE subscriptions SET last_checked = %s WHERE id = %s;", (current_time_utc, sub_id))
                        db_conn.commit()
                        logging.info(f"Updated last_checked for {email} to {current_time_utc}.")
                    except Exception as e_update:
                        logging.error(f"Failed to update last_checked for {email} (ID: {sub_id}): {e_update}\n{traceback.format_exc()}")
                        if db_conn: # Rollback this specific commit if update fails
                            db_conn.rollback()
                    finally:
                        if update_cur:
                            update_cur.close()
                else:
                    logging.warning(f"Email not sent to {email} (ID: {sub_id}). last_checked will not be updated to current time.")
            else:
                logging.info(f"No new items found for {email} since {effective_last_checked}. No notification needed.")
                # Even if no new items, update last_checked if it was NULL to prevent re-fetching old items on next run
                if last_checked_db is None:
                    try:
                        update_cur = db_conn.cursor()
                        update_cur.execute("UPDATE subscriptions SET last_checked = %s WHERE id = %s;", (current_time_utc, sub_id))
                        db_conn.commit()
                        logging.info(f"Initialized last_checked for {email} (ID: {sub_id}) to {current_time_utc} as no items were found on first check.")
                    except Exception as e_init_update:
                        logging.error(f"Failed to initialize last_checked for {email} (ID: {sub_id}): {e_init_update}\n{traceback.format_exc()}")
                        if db_conn:
                            db_conn.rollback()
                    finally:
                        if update_cur:
                            update_cur.close()

    except Exception as e:
        logging.error(f"Error processing subscriptions: {e}\n{traceback.format_exc()}")
        if db_conn: # Rollback any potential transaction from main cursor if error occurs
            db_conn.rollback()
    finally:
        if cur:
            cur.close()


if __name__ == '__main__':
    logging.info("Notification sender script started.")
    if not check_env_vars():
        logging.error("Required environment variables are missing. Exiting.")
        exit(1)

    # Warning about SendGrid is already in check_env_vars if SENDGRID_AVAILABLE is True but keys are missing.
    # If SENDGRID_AVAILABLE is False, it's also logged there.

    conn = get_db_connection()
    if conn:
        try:
            process_subscriptions(conn)
        finally: # Ensure connection is closed even if process_subscriptions fails
            conn.close()
            logging.info("Database connection closed.")
    else:
        logging.error("Failed to get database connection. Cannot process subscriptions.")

    logging.info("Notification sender script finished.")
