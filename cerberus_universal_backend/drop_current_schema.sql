-- Drop Triggers
DROP TRIGGER IF EXISTS persons_audit ON persons;
DROP TRIGGER IF EXISTS donations_audit ON donations;
DROP TRIGGER IF EXISTS survey_search_update ON survey_results;

-- Drop Functions
DROP FUNCTION IF EXISTS audit_trigger();
DROP FUNCTION IF EXISTS survey_search_trigger();

-- Drop Materialized Views
DROP MATERIALIZED VIEW IF EXISTS voter_turnout_summary;

-- Drop Tables (in reverse order of dependencies)
DROP TABLE IF EXISTS backup_logs;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS person_merges;
DROP TABLE IF EXISTS donations;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS government_bodies;
DROP TABLE IF EXISTS person_campaign_interactions;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS address_districts;
DROP TABLE IF EXISTS districts;
DROP TABLE IF EXISTS person_relationships;
DROP TABLE IF EXISTS voter_history;
DROP TABLE IF EXISTS person_other_contacts;
DROP TABLE IF EXISTS person_payment_info;
DROP TABLE IF EXISTS person_employers;
DROP TABLE IF EXISTS person_social_media;
DROP TABLE IF EXISTS person_phones;
DROP TABLE IF EXISTS person_emails;
DROP TABLE IF EXISTS person_addresses;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS person_identifiers;
DROP TABLE IF EXISTS party_affiliation_history;
DROP TABLE IF EXISTS persons;
DROP TABLE IF EXISTS data_sources;
DROP TABLE IF EXISTS survey_results;

-- Drop ENUM types (if they were created separately and not inline with table creation)
-- This step might not be necessary if ENUMs were defined inline, but it's good practice to include.
-- You might need to adjust these based on how your current ENUMs are defined.
DROP TYPE IF EXISTS source_type;
DROP TYPE IF EXISTS gender;
DROP TYPE IF EXISTS income_bracket;
DROP TYPE IF EXISTS registration_status;
DROP TYPE IF EXISTS preferred_contact_method;
DROP TYPE IF EXISTS verification_status;
DROP TYPE IF EXISTS enrichment_status;
DROP TYPE IF EXISTS property_type;
DROP TYPE IF EXISTS address_type;
DROP TYPE IF EXISTS occupancy_status;
DROP TYPE IF EXISTS email_type;
DROP TYPE IF EXISTS phone_type;
DROP TYPE IF EXISTS payment_type;
DROP TYPE IF EXISTS voting_method;
DROP TYPE IF EXISTS survey_channel;
DROP TYPE IF EXISTS completion_status;
DROP TYPE IF EXISTS relationship_type;
DROP TYPE IF EXISTS district_type;
DROP TYPE IF EXISTS campaign_type;
DROP TYPE IF EXISTS interaction_type;
DROP TYPE IF EXISTS payment_status;
DROP TYPE IF EXISTS merge_method;
DROP TYPE IF EXISTS action_type;
DROP TYPE IF EXISTS backup_type;
DROP TYPE IF EXISTS status;
