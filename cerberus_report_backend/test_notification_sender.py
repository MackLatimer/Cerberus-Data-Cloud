import unittest
from unittest.mock import patch, MagicMock, call
import os
import sys
from datetime import datetime, timedelta, timezone
import logging

# Add the parent directory to sys.path to allow importing notification_sender
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Import functions and variables from notification_sender
# We need to be careful with imports if some modules (like sendgrid) might not be installed
# For now, let's assume they are for testing, or mock them out.
try:
    import notification_sender
    from notification_sender import (
        check_env_vars,
        format_html_content,
        fetch_new_agenda_items,
        process_subscriptions,
        send_email_notification # We will mock this often
    )
    # Mock SENDGRID_AVAILABLE for tests if the library isn't actually there during testing
    if not notification_sender.SENDGRID_AVAILABLE:
        notification_sender.SENDGRID_AVAILABLE = True # Assume it's available for most tests
        notification_sender.SENDGRID_API_KEY = "test_api_key"
        notification_sender.SENDER_EMAIL = "test_sender@example.com"

except ImportError as e:
    print(f"Error importing notification_sender: {e}. Ensure it's in the Python path.")
    print("Attempting to set up mocks for critical parts if notification_sender itself is missing.")
    # If notification_sender itself can't be imported, we need to define mocks
    # This is a fallback, ideally the import should work.
    check_env_vars = MagicMock()
    format_html_content = MagicMock()
    fetch_new_agenda_items = MagicMock()
    process_subscriptions = MagicMock()
    send_email_notification = MagicMock()
    # Mock the module itself for patching its attributes
    notification_sender = MagicMock()
    notification_sender.SENDGRID_API_KEY = "test_api_key"
    notification_sender.SENDER_EMAIL = "test_sender@example.com"
    notification_sender.APP_BASE_URL = "http://test.app"
    notification_sender.SENDGRID_AVAILABLE = True


# Suppress logging output during tests unless specifically needed
logging.disable(logging.CRITICAL)


class TestNotificationSender(unittest.TestCase):

    def setUp(self):
        # Reset any globally patched variables in notification_sender if necessary
        # This is important if tests modify these directly.
        if hasattr(notification_sender, 'SENDGRID_API_KEY'):
             self.original_api_key = notification_sender.SENDGRID_API_KEY
        if hasattr(notification_sender, 'SENDER_EMAIL'):
            self.original_sender_email = notification_sender.SENDER_EMAIL

        notification_sender.SENDGRID_API_KEY = "test_api_key"
        notification_sender.SENDER_EMAIL = "test_sender@example.com"
        notification_sender.APP_BASE_URL = "http://test.app"
        notification_sender.SENDGRID_AVAILABLE = True


    def tearDown(self):
        # Restore original values if they were changed
        if hasattr(self, 'original_api_key') and hasattr(notification_sender, 'SENDGRID_API_KEY'):
            notification_sender.SENDGRID_API_KEY = self.original_api_key
        if hasattr(self, 'original_sender_email') and hasattr(notification_sender, 'SENDER_EMAIL'):
             notification_sender.SENDER_EMAIL = self.original_sender_email

    @patch('notification_sender.logging')
    @patch('os.environ.get')
    def test_check_env_vars_all_present_sendgrid_available(self, mock_os_get, mock_logging):
        """Test check_env_vars when all environment variables are present and SendGrid is available."""
        # Simulate SendGrid being available
        notification_sender.SENDGRID_AVAILABLE = True

        def side_effect(key, default=None):
            if key == "INSTANCE_CONNECTION_NAME": return "test_instance"
            if key == "DB_USER": return "test_user"
            if key == "DB_PASS": return "test_pass"
            if key == "DB_NAME": return "test_db"
            if key == "SENDGRID_API_KEY": return "sg_key"
            if key == "SENDER_EMAIL": return "sender@example.com"
            if key == "APP_BASE_URL": return "http://test.app"
            return default
        mock_os_get.side_effect = side_effect

        # Update module-level variables based on mock_os_get for consistency during the test
        notification_sender.INSTANCE_CONNECTION_NAME = "test_instance"
        notification_sender.DB_USER = "test_user"
        notification_sender.DB_PASS = "test_pass"
        notification_sender.DB_NAME = "test_db"
        notification_sender.SENDGRID_API_KEY = "sg_key"
        notification_sender.SENDER_EMAIL = "sender@example.com"

        result = notification_sender.check_env_vars()
        self.assertTrue(result)
        mock_logging.error.assert_not_called()

    @patch('notification_sender.logging')
    @patch('os.environ.get')
    def test_check_env_vars_db_missing(self, mock_os_get, mock_logging):
        """Test check_env_vars when a database environment variable is missing."""
        notification_sender.SENDGRID_AVAILABLE = True
        def side_effect(key, default=None):
            if key == "INSTANCE_CONNECTION_NAME": return "test_instance"
            # DB_USER is missing
            if key == "DB_PASS": return "test_pass"
            if key == "DB_NAME": return "test_db"
            if key == "SENDGRID_API_KEY": return "sg_key"
            if key == "SENDER_EMAIL": return "sender@example.com"
            return default
        mock_os_get.side_effect = side_effect

        notification_sender.INSTANCE_CONNECTION_NAME = "test_instance"
        notification_sender.DB_USER = None # Simulate missing
        notification_sender.DB_PASS = "test_pass"
        notification_sender.DB_NAME = "test_db"
        notification_sender.SENDGRID_API_KEY = "sg_key"
        notification_sender.SENDER_EMAIL = "sender@example.com"

        result = notification_sender.check_env_vars()
        self.assertFalse(result)
        mock_logging.error.assert_any_call("Missing database connection environment variables: DB_USER")


    @patch('notification_sender.logging')
    @patch('os.environ.get')
    def test_check_env_vars_sendgrid_key_missing_but_available(self, mock_os_get, mock_logging):
        """Test check_env_vars when SENDGRID_API_KEY is missing but SendGrid lib is available."""
        notification_sender.SENDGRID_AVAILABLE = True # Lib is there
        def side_effect(key, default=None):
            if key == "INSTANCE_CONNECTION_NAME": return "test_instance"
            if key == "DB_USER": return "test_user"
            if key == "DB_PASS": return "test_pass"
            if key == "DB_NAME": return "test_db"
            # SENDGRID_API_KEY is missing
            if key == "SENDER_EMAIL": return "sender@example.com"
            return default
        mock_os_get.side_effect = side_effect

        notification_sender.INSTANCE_CONNECTION_NAME = "test_instance"
        notification_sender.DB_USER = "test_user"
        notification_sender.DB_PASS = "test_pass"
        notification_sender.DB_NAME = "test_db"
        notification_sender.SENDGRID_API_KEY = None # Simulate missing
        notification_sender.SENDER_EMAIL = "sender@example.com"

        result = notification_sender.check_env_vars()
        # Should return True to allow script to run, but log an error
        self.assertTrue(result)
        mock_logging.error.assert_any_call("SendGrid API Key or Sender Email not configured. Email sending will be skipped.")


    @patch('notification_sender.logging')
    @patch('os.environ.get')
    def test_check_env_vars_sendgrid_not_available(self, mock_os_get, mock_logging):
        """Test check_env_vars when SendGrid library is not available."""
        notification_sender.SENDGRID_AVAILABLE = False # Lib is not there
        def side_effect(key, default=None):
            # DB vars are present
            if key == "INSTANCE_CONNECTION_NAME": return "test_instance"
            if key == "DB_USER": return "test_user"
            if key == "DB_PASS": return "test_pass"
            if key == "DB_NAME": return "test_db"
            # SendGrid keys might be missing, but it shouldn't matter for check_env_vars's return value
            return default
        mock_os_get.side_effect = side_effect

        notification_sender.INSTANCE_CONNECTION_NAME = "test_instance"
        notification_sender.DB_USER = "test_user"
        notification_sender.DB_PASS = "test_pass"
        notification_sender.DB_NAME = "test_db"
        notification_sender.SENDGRID_API_KEY = None
        notification_sender.SENDER_EMAIL = None

        result = notification_sender.check_env_vars()
        self.assertTrue(result) # Still true, allows script to run for other tasks
        mock_logging.warning.assert_any_call("SendGrid library not installed. Email sending is disabled.")
        mock_logging.error.assert_not_called() # No error if lib itself is missing


    def test_format_html_content_empty(self):
        """Test format_html_content with no items."""
        html = notification_sender.format_html_content([])
        self.assertIn("No new agenda items", html)
        self.assertNotIn("<li>", html)

    def test_format_html_content_with_items(self):
        """Test format_html_content with a list of sample agenda items."""
        sample_items = [
            {
                'id': 1,
                'heading': 'Test Heading 1',
                'municipality_name': 'City A',
                'agenda_date': datetime(2023, 1, 15).date(), # Use date object as from DB
                'category': 'Planning',
                'item_text': 'This is a short description for item 1.',
                'pdf_url': 'http://example.com/pdf1.pdf',
                'created_at': datetime.now(timezone.utc)
            },
            {
                'id': 2,
                'heading': 'Another Topic',
                'municipality_name': 'Town B',
                'agenda_date': "2023-01-16", # Test with string date
                'category': None, # Test missing category
                'item_text': 'L' * 300, # Long text
                'pdf_url': None, # Test missing PDF URL
                'created_at': datetime.now(timezone.utc)
            }
        ]
        html = notification_sender.format_html_content(sample_items)

        self.assertIn("<h1>New Agenda Items</h1>", html)
        self.assertIn("Test Heading 1", html)
        self.assertIn("City A", html)
        self.assertIn("2023-01-15", html)
        self.assertIn("Planning", html)
        self.assertIn("http://example.com/pdf1.pdf", html)
        self.assertIn("short description", html)

        self.assertIn("Another Topic", html)
        self.assertIn("Town B", html)
        self.assertIn("2023-01-16", html)
        self.assertNotIn("<strong>Category:</strong>", html.split("Another Topic")[1].split("</li>")[0]) # Check category is not there for item 2
        self.assertIn("L" * 200 + "...", html) # Check truncation
        self.assertNotIn('href="None"', html) # Check missing PDF URL handling

        self.assertIn(f"adjust your notification settings or search for more items at <a href='{notification_sender.APP_BASE_URL}'>", html)
        self.assertTrue(html.count("<li>") == 2)


    @patch('notification_sender.get_db_connection')
    def test_fetch_new_agenda_items_query_construction(self, mock_get_db_connection):
        """Test the SQL query construction in fetch_new_agenda_items."""
        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_get_db_connection.return_value = mock_conn
        mock_conn.cursor.return_value = mock_cursor
        mock_cursor.description = [('id',), ('heading',)] # Dummy description
        mock_cursor.fetchall.return_value = [] # No actual data needed for query check

        last_checked_ts = datetime(2023, 1, 1, 12, 0, 0, tzinfo=timezone.utc)

        # Test case 1: Only keyword
        filter_settings_1 = {'keyword': 'solar'}
        notification_sender.fetch_new_agenda_items(mock_conn, filter_settings_1, last_checked_ts)
        args1, _ = mock_cursor.execute.call_args
        sql_query1 = args1[0]
        self.assertIn("ai.created_at > %s", sql_query1)
        self.assertTrue(any("ai.item_text ILIKE %s" in condition for condition in sql_query1.split("AND") if "WHERE" in sql_query1)) # Checks one of the keyword fields
        self.assertIn("%solar%", args1[1]) # Check keyword param

        # Test case 2: Keyword and municipality
        filter_settings_2 = {'keyword': 'meeting', 'municipality': 'Springfield'}
        notification_sender.fetch_new_agenda_items(mock_conn, filter_settings_2, last_checked_ts)
        args2, _ = mock_cursor.execute.call_args
        sql_query2 = args2[0]
        self.assertIn("m.name = %s", sql_query2)
        self.assertTrue(any("ai.heading ILIKE %s" in condition for condition in sql_query2.split("AND") if "WHERE" in sql_query2))
        self.assertIn("%meeting%", args2[1])
        self.assertIn("Springfield", args2[1])

        # Test case 3: All filters
        filter_settings_3 = {
            'keyword': 'budget',
            'municipality': 'Capital City',
            'start_date': '2023-01-01',
            'end_date': '2023-01-31',
            'heading': 'Finance Committee',
            'category': 'Government'
        }
        notification_sender.fetch_new_agenda_items(mock_conn, filter_settings_3, last_checked_ts)
        args3, _ = mock_cursor.execute.call_args
        sql_query3 = args3[0]
        self.assertIn("a.date >= %s", sql_query3)
        self.assertIn("a.date <= %s", sql_query3)
        self.assertIn("m.name = %s", sql_query3)
        self.assertIn("ai.heading = %s", sql_query3)
        self.assertIn("ai.category = %s", sql_query3)
        self.assertTrue(any("ai.item_text ILIKE %s" in condition for condition in sql_query3.split("AND") if "WHERE" in sql_query3))
        self.assertIn('2023-01-01', args3[1])
        self.assertIn('Capital City', args3[1])
        self.assertIn('Finance Committee', args3[1])
        self.assertIn('Government', args3[1])
        self.assertIn(last_checked_ts, args3[1])

        # Test case 4: No filters (should only have created_at > %s)
        filter_settings_4 = {}
        notification_sender.fetch_new_agenda_items(mock_conn, filter_settings_4, last_checked_ts)
        args4, _ = mock_cursor.execute.call_args
        sql_query4 = args4[0]
        self.assertIn("WHERE ai.created_at > %s", sql_query4) # Ensure it's the only condition in WHERE
        self.assertNotIn("AND", sql_query4.split("WHERE")[1]) # No other conditions after WHERE
        self.assertEqual(len(args4[1]), 1) # Only one param: last_checked_ts
        self.assertIn(last_checked_ts, args4[1])

    @patch('notification_sender.SendGridAPIClient')
    def test_send_email_notification_success(self, mock_sg_client_constructor):
        """Test successful email sending via send_email_notification."""
        mock_sg_instance = MagicMock()
        mock_response = MagicMock()
        mock_response.status_code = 202 # Accepted
        mock_sg_instance.send.return_value = mock_response
        mock_sg_client_constructor.return_value = mock_sg_instance

        # Ensure SENDGRID_AVAILABLE is True for this test
        original_sg_available = notification_sender.SENDGRID_AVAILABLE
        notification_sender.SENDGRID_AVAILABLE = True

        # Ensure API key and sender email are set for this test
        original_api_key = notification_sender.SENDGRID_API_KEY
        original_sender_email = notification_sender.SENDER_EMAIL
        notification_sender.SENDGRID_API_KEY = "dummy_key"
        notification_sender.SENDER_EMAIL = "dummy_sender@example.com"

        result = notification_sender.send_email_notification("recipient@example.com", "Test Subject", "<p>Hello</p>")

        self.assertTrue(result)
        mock_sg_client_constructor.assert_called_once_with("dummy_key")
        mock_sg_instance.send.assert_called_once()
        message_arg = mock_sg_instance.send.call_args[0][0]
        self.assertEqual(message_arg.to_emails[0].email, "recipient@example.com")
        self.assertEqual(message_arg.subject.subject, "Test Subject")

        # Restore original values
        notification_sender.SENDGRID_AVAILABLE = original_sg_available
        notification_sender.SENDGRID_API_KEY = original_api_key
        notification_sender.SENDER_EMAIL = original_sender_email

    @patch('notification_sender.SendGridAPIClient')
    @patch('notification_sender.logging')
    def test_send_email_notification_failure(self, mock_logging, mock_sg_client_constructor):
        """Test failed email sending."""
        mock_sg_instance = MagicMock()
        mock_response = MagicMock()
        mock_response.status_code = 500 # Internal Server Error
        mock_response.body = "Error body"
        mock_sg_instance.send.return_value = mock_response
        mock_sg_client_constructor.return_value = mock_sg_instance

        original_sg_available = notification_sender.SENDGRID_AVAILABLE
        notification_sender.SENDGRID_AVAILABLE = True
        original_api_key = notification_sender.SENDGRID_API_KEY
        original_sender_email = notification_sender.SENDER_EMAIL
        notification_sender.SENDGRID_API_KEY = "dummy_key"
        notification_sender.SENDER_EMAIL = "dummy_sender@example.com"

        result = notification_sender.send_email_notification("recipient@example.com", "Test Subject", "<p>Hello</p>")

        self.assertFalse(result)
        mock_logging.error.assert_called_with(unittest.mock.ANY) # Check that some error was logged

        notification_sender.SENDGRID_AVAILABLE = original_sg_available
        notification_sender.SENDGRID_API_KEY = original_api_key
        notification_sender.SENDER_EMAIL = original_sender_email

    def test_send_email_notification_sendgrid_not_available(self):
        """Test email sending when SendGrid library is not available."""
        original_sg_available = notification_sender.SENDGRID_AVAILABLE
        notification_sender.SENDGRID_AVAILABLE = False # Simulate SendGrid not being available

        # No need to mock SendGridAPIClient as it shouldn't be called
        result = notification_sender.send_email_notification("recipient@example.com", "Test Subject", "<p>Hello</p>")

        self.assertTrue(result) # Should return True as per function's logic to allow workflow

        notification_sender.SENDGRID_AVAILABLE = original_sg_available

    @patch('notification_sender.logging')
    def test_send_email_notification_no_api_key(self, mock_logging):
        """Test email sending when API key is missing."""
        original_sg_available = notification_sender.SENDGRID_AVAILABLE
        notification_sender.SENDGRID_AVAILABLE = True
        original_api_key = notification_sender.SENDGRID_API_KEY
        notification_sender.SENDGRID_API_KEY = None # API key is missing

        result = notification_sender.send_email_notification("recipient@example.com", "Test Subject", "<p>Hello</p>")
        self.assertFalse(result)
        mock_logging.error.assert_called_with(unittest.mock.ANY)

        notification_sender.SENDGRID_AVAILABLE = original_sg_available
        notification_sender.SENDGRID_API_KEY = original_api_key


class TestProcessSubscriptions(unittest.TestCase):

    def setUp(self):
        # Ensure a clean state for module-level variables that might be patched elsewhere or modified
        self.original_sg_available = notification_sender.SENDGRID_AVAILABLE
        self.original_api_key = notification_sender.SENDGRID_API_KEY
        self.original_sender_email = notification_sender.SENDER_EMAIL
        self.original_app_base_url = notification_sender.APP_BASE_URL

        notification_sender.SENDGRID_AVAILABLE = True # Default to available for these tests
        notification_sender.SENDGRID_API_KEY = "test_sg_key"
        notification_sender.SENDER_EMAIL = "test_sender@example.com"
        notification_sender.APP_BASE_URL = "http://test.app.com"

        # Mock the DB connection globally for this test class
        self.mock_db_conn = MagicMock()
        self.mock_cursor = MagicMock()
        self.mock_db_conn.cursor.return_value = self.mock_cursor

        # Common sample data
        self.sample_filter_settings = {"keyword": "important"}
        self.sample_email = "user@example.com"
        self.now = datetime.now(timezone.utc)
        self.one_day_ago = self.now - timedelta(days=1)

    def tearDown(self):
        notification_sender.SENDGRID_AVAILABLE = self.original_sg_available
        notification_sender.SENDGRID_API_KEY = self.original_api_key
        notification_sender.SENDER_EMAIL = self.original_sender_email
        notification_sender.APP_BASE_URL = self.original_app_base_url

    @patch('notification_sender.get_db_connection')
    @patch('notification_sender.fetch_new_agenda_items', return_value=[]) # No items found
    @patch('notification_sender.send_email_notification')
    @patch('notification_sender.logging')
    def test_process_subscriptions_no_active_subscriptions(self, mock_logging, mock_send_email, mock_fetch_items, mock_get_db_conn):
        mock_get_db_conn.return_value = self.mock_db_conn
        self.mock_cursor.fetchall.return_value = [] # No subscriptions
        self.mock_cursor.description = [('id',), ('email',), ('filter_settings',), ('last_checked',)]


        notification_sender.process_subscriptions(self.mock_db_conn)

        mock_fetch_items.assert_not_called()
        mock_send_email.assert_not_called()

        # Verify that no UPDATE calls were made to 'subscriptions' table
        update_calls = [c for c in self.mock_cursor.execute.call_args_list if "UPDATE subscriptions" in c[0][0]]
        self.assertEqual(len(update_calls), 0, "Should not attempt to update last_checked if no subscriptions.")

        # Check that an info log about no active subscriptions was made
        mock_logging.info.assert_any_call("No active subscriptions found.")


    @patch('notification_sender.get_db_connection')
    @patch('notification_sender.fetch_new_agenda_items')
    @patch('notification_sender.send_email_notification', return_value=True) # Email sent successfully
    def test_process_subscriptions_new_items_and_sends_email(self, mock_send_email, mock_fetch_items, mock_get_db_conn):
        mock_get_db_conn.return_value = self.mock_db_conn

        # One active subscription, last checked one day ago
        subscriptions_data = [(1, self.sample_email, self.sample_filter_settings, self.one_day_ago)]
        self.mock_cursor.fetchall.return_value = subscriptions_data
        self.mock_cursor.description = [('id',), ('email',), ('filter_settings',), ('last_checked',)]

        sample_new_items = [{'id': 101, 'heading': 'New Item 1', 'created_at': self.now}]
        mock_fetch_items.return_value = sample_new_items

        notification_sender.process_subscriptions(self.mock_db_conn)

        mock_fetch_items.assert_called_once_with(self.mock_db_conn, self.sample_filter_settings, self.one_day_ago.replace(tzinfo=timezone.utc))
        mock_send_email.assert_called_once()
        # Check some args of send_email_notification
        call_args = mock_send_email.call_args[0]
        self.assertEqual(call_args[0], self.sample_email) # recipient_email
        self.assertIn("New Agenda Items", call_args[1]) # subject
        self.assertIn("New Item 1", call_args[2]) # html_content

        # Check that last_checked was updated
        self.mock_cursor.execute.assert_any_call(
            "UPDATE subscriptions SET last_checked = %s WHERE id = %s;",
            (unittest.mock.ANY, 1) # ANY for current_time_utc, ID is 1
        )
        self.mock_db_conn.commit.assert_called()


    @patch('notification_sender.get_db_connection')
    @patch('notification_sender.fetch_new_agenda_items', return_value=[]) # No new items
    @patch('notification_sender.send_email_notification')
    def test_process_subscriptions_no_new_items(self, mock_send_email, mock_fetch_items, mock_get_db_conn):
        mock_get_db_conn.return_value = self.mock_db_conn
        subscriptions_data = [(1, self.sample_email, self.sample_filter_settings, self.one_day_ago)]
        self.mock_cursor.fetchall.return_value = subscriptions_data
        self.mock_cursor.description = [('id',), ('email',), ('filter_settings',), ('last_checked',)]

        notification_sender.process_subscriptions(self.mock_db_conn)

        mock_fetch_items.assert_called_once_with(self.mock_db_conn, self.sample_filter_settings, self.one_day_ago.replace(tzinfo=timezone.utc))
        mock_send_email.assert_not_called()
        # last_checked should NOT be updated to current time if no email was sent AND last_checked was not NULL
        # However, if last_checked WAS NULL, it would be updated.
        # In this test, last_checked was self.one_day_ago, so no update call for this specific reason.
        # We count the calls to execute: one for fetching subs, one for potentially updating last_checked if it was null.
        initial_fetch_call = call("SELECT id, email, filter_settings, last_checked \n            FROM subscriptions \n            WHERE active = TRUE;")

        # Filter out the initial fetch call to see if any other execute (like update) was made
        update_calls = [c for c in self.mock_cursor.execute.call_args_list if c != initial_fetch_call]
        self.assertEqual(len(update_calls), 0, "last_checked should not be updated if no new items and not initial run")

    @patch('notification_sender.get_db_connection')
    @patch('notification_sender.fetch_new_agenda_items')
    @patch('notification_sender.send_email_notification', return_value=True) # Email sent
    def test_process_subscriptions_initial_run_no_new_items(self, mock_send_email, mock_fetch_items, mock_get_db_conn):
        mock_get_db_conn.return_value = self.mock_db_conn
        # last_checked is NULL (initial run)
        subscriptions_data = [(1, self.sample_email, self.sample_filter_settings, None)]
        self.mock_cursor.fetchall.return_value = subscriptions_data
        self.mock_cursor.description = [('id',), ('email',), ('filter_settings',), ('last_checked',)]

        mock_fetch_items.return_value = [] # No new items found even on initial check

        notification_sender.process_subscriptions(self.mock_db_conn)

        # fetch_new_agenda_items should be called with a default timedelta (e.g., last 24 hours)
        self.assertTrue(isinstance(mock_fetch_items.call_args[0][2], datetime)) # effective_last_checked
        mock_send_email.assert_not_called()

        # last_checked SHOULD be updated to current time because it was an initial run (was NULL)
        self.mock_cursor.execute.assert_any_call(
            "UPDATE subscriptions SET last_checked = %s WHERE id = %s;",
            (unittest.mock.ANY, 1)
        )
        self.mock_db_conn.commit.assert_called_once() # Should be called for the last_checked update


    @patch('notification_sender.get_db_connection')
    @patch('notification_sender.fetch_new_agenda_items')
    @patch('notification_sender.send_email_notification', return_value=False) # Email sending fails
    @patch('notification_sender.logging')
    def test_process_subscriptions_email_send_failure(self, mock_logging, mock_send_email, mock_fetch_items, mock_get_db_conn):
        mock_get_db_conn.return_value = self.mock_db_conn
        subscriptions_data = [(1, self.sample_email, self.sample_filter_settings, self.one_day_ago)]
        self.mock_cursor.fetchall.return_value = subscriptions_data
        self.mock_cursor.description = [('id',), ('email',), ('filter_settings',), ('last_checked',)]

        sample_new_items = [{'id': 102, 'heading': 'Another New Item', 'created_at': self.now}]
        mock_fetch_items.return_value = sample_new_items

        notification_sender.process_subscriptions(self.mock_db_conn)

        mock_send_email.assert_called_once()
        # Check that last_checked was NOT updated
        initial_fetch_call = call("SELECT id, email, filter_settings, last_checked \n            FROM subscriptions \n            WHERE active = TRUE;")
        update_calls = [c for c in self.mock_cursor.execute.call_args_list if "UPDATE subscriptions" in c[0][0]]
        self.assertEqual(len(update_calls), 0, "last_checked should not be updated if email sending failed")
        mock_logging.warning.assert_any_call(f"Email not sent to {self.sample_email} (ID: 1). last_checked will not be updated to current time.")


if __name__ == '__main__':
    # Re-enable logging for test runner output if needed, or use -v flag
    # logging.disable(logging.NOTSET)
    unittest.main()
