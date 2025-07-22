import unittest
from unittest.mock import patch, MagicMock, call
from datetime import datetime, timedelta

from app.services import scraper

class TestScraper(unittest.TestCase):

    def setUp(self):
        # Mock for the database connection
        self.mock_db_conn = MagicMock()
        self.mock_db_conn.cursor.return_value.__enter__.return_value = MagicMock() # Mock cursor context manager

        # Patch get_db_connection to return our mock connection
        self.patcher_db_connection = patch('app.services.scraper.get_db_connection', return_value=self.mock_db_conn)
        self.mock_get_db_connection = self.patcher_db_connection.start()

        # Mock municipality record that will be passed to process_municipality_agendas
        self.municipality_record = {
            'id': 1,
            'name': 'Testville',
            'agenda_url': 'http://testville.com/agendas',
            'scraper_type': 'TestScraperType', # A unique type for testing
            'config': '{}' # Empty JSON config
        }

        # Define dates for testing "last month"
        self.today = datetime.now()
        self.last_month_date_obj = self.today - timedelta(days=15)
        self.last_month_date_str = self.last_month_date_obj.strftime("%Y-%m-%d")
        self.older_date_obj = self.today - timedelta(days=45)
        self.older_date_str = self.older_date_obj.strftime("%Y-%m-%d")

        # Agenda URLs to be returned by the mock scraper function
        self.mock_agenda_urls = [
            {'url': 'http://testville.com/agenda_last_month.pdf', 'date': self.last_month_date_str},
            {'url': 'http://testville.com/agenda_older.pdf', 'date': self.older_date_str}
        ]

        # Parsed items to be returned by mock PDF parser
        self.mock_parsed_items_last_month = [
            ('Section 1', 'PFX1', 'Item 1 description last month'),
            ('Section 2', 'PFX2', 'Item 2 description last month')
        ]

    def tearDown(self):
        self.patcher_db_connection.stop()
        patch.stopall()

    def test_initial_setup_passes(self):
        self.assertTrue(True)

    @patch('scraper.download_and_parse_agenda')
    @patch('scraper.store_agenda_items')
    @patch('scraper.get_or_create_agenda_record')
    def test_process_municipality_agendas_last_month(self,
                                               mock_get_or_create_agenda_record,
                                               mock_store_agenda_items,
                                               mock_download_and_parse_agenda):
        # --- Setup Mocks for this test ---

        # Mock for the specific scraper function (e.g., find_agenda_urls_legistar)
        mock_specific_scraper_function = MagicMock(return_value=self.mock_agenda_urls)

        # Patch SCRAPER_DISPATCH to return our mock function for 'TestScraperType'
        with patch.dict(scraper.SCRAPER_DISPATCH, {'TestScraperType': mock_specific_scraper_function}):
            # Configure side effects for download_and_parse_agenda:
            # It should return items for the "last month" URL, and empty list for older URL
            def download_side_effect(pdf_url, municipality_name, config_json=None):
                if pdf_url == 'http://testville.com/agenda_last_month.pdf':
                    return self.mock_parsed_items_last_month
                elif pdf_url == 'http://testville.com/agenda_older.pdf':
                    return [] # No items for the older agenda, or it's just not processed further
                return []
            mock_download_and_parse_agenda.side_effect = download_side_effect

            # Configure get_or_create_agenda_record:
            # Assume the "last month" agenda is new (returns ID, True)
            # Assume the "older" agenda is also new for simplicity here, or could be (ID, False)
            # Let's say the first call (last_month) is new, second (older) is also new.
            mock_get_or_create_agenda_record.side_effect = [
                (101, True), # agenda_id = 101, is_new = True for last_month_date_str
                (102, True)  # agenda_id = 102, is_new = True for older_date_str
            ]

            # --- Call the function under test ---
            scraper.process_municipality_agendas(self.mock_db_conn, self.municipality_record)

            # --- Assertions ---
            # 1. Assert that the specific scraper function was called
            mock_specific_scraper_function.assert_called_once_with(
                self.municipality_record['agenda_url'],
                self.municipality_record['name'],
                self.municipality_record['config']
            )

            # 2. Assert get_or_create_agenda_record calls
            expected_get_or_create_calls = [
                call(self.mock_db_conn, self.municipality_record['id'], self.last_month_date_str, 'http://testville.com/agenda_last_month.pdf'),
                call(self.mock_db_conn, self.municipality_record['id'], self.older_date_str, 'http://testville.com/agenda_older.pdf')
            ]
            # The order of calls from scraper_function might not be guaranteed if it processes async or from a set.
            # However, the current scraper code processes them sequentially as returned by the find_agenda_urls_*
            mock_get_or_create_agenda_record.assert_has_calls(expected_get_or_create_calls, any_order=False)


            # 3. Assert download_and_parse_agenda calls
            # It should be called if get_or_create_agenda_record returns `is_new=True`.
            # Based on our side_effect for get_or_create_agenda_record, both are new.
            expected_download_calls = [
                call('http://testville.com/agenda_last_month.pdf', self.municipality_record['name'], self.municipality_record['config']),
                call('http://testville.com/agenda_older.pdf', self.municipality_record['name'], self.municipality_record['config'])
            ]
            mock_download_and_parse_agenda.assert_has_calls(expected_download_calls, any_order=False)

            # 4. Assert store_agenda_items call
            # Should only be called for the "last month" agenda if it's new and items were parsed.
            # Based on our download_side_effect, only last_month_date_str yields items.
            mock_store_agenda_items.assert_called_once_with(
                self.mock_db_conn, 101, self.mock_parsed_items_last_month
            )

            # 5. Assert that last_scraped_at is updated
            self.mock_db_conn.cursor.return_value.__enter__.return_value.execute.assert_any_call(
                "UPDATE municipalities SET last_scraped_at = %s WHERE id = %s",
                (unittest.mock.ANY, self.municipality_record['id']) # ANY for datetime.now()
            )
            self.mock_db_conn.commit.assert_called()


if __name__ == '__main__':
    unittest.main()
