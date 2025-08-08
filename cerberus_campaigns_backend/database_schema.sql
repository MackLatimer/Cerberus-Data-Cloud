-- 1. Data Sources
CREATE TABLE data_sources (
    source_id SERIAL PRIMARY KEY,
    source_name VARCHAR(255),
    source_type VARCHAR(50), -- ENUM('Manual', 'API', 'Import') DEFAULT 'Manual',
    api_endpoint VARCHAR(255),
    import_date DATE,
    description TEXT,
    data_retention_period INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Persons
CREATE TABLE persons (
    person_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_of_birth DATE,
    gender VARCHAR(50), -- ENUM('Male', 'Female', 'Non-binary', 'Other', 'Unknown'),
    party_affiliation VARCHAR(100),
    ethnicity VARCHAR(100),
    income_bracket VARCHAR(50), -- ENUM('Low', 'Middle', 'High', 'Unknown'),
    education_level VARCHAR(100),
    voter_propensity_score INT CHECK (voter_propensity_score BETWEEN 0 AND 100),
    registration_status VARCHAR(50), -- ENUM('Active', 'Inactive', 'Purged') DEFAULT 'Active',
    status_change_date DATE,
    consent_opt_in BOOLEAN DEFAULT FALSE,
    duplicate_flag BOOLEAN DEFAULT FALSE,
    last_contact_date DATE,
    ml_tags JSONB,
    change_history JSONB,
    preferred_contact_method VARCHAR(50), -- ENUM('Email', 'Phone', 'Mail', 'SocialMedia', 'None'),
    language_preference VARCHAR(50),
    accessibility_needs TEXT,
    last_updated_by VARCHAR(255),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);
CREATE INDEX idx_persons_name ON persons(first_name, last_name);
CREATE INDEX idx_persons_propensity ON persons(voter_propensity_score);
CREATE INDEX idx_persons_registration ON persons(registration_status);

-- 3. Party Affiliation History
CREATE TABLE party_affiliation_history (
    history_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    party_affiliation VARCHAR(100),
    valid_from DATE NOT NULL,
    valid_to DATE,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 4. Person Identifiers
CREATE TABLE person_identifiers (
    identifier_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    identifier_type VARCHAR(50) NOT NULL,
    identifier_value BYTEA NOT NULL UNIQUE,  -- Encrypt: pgp_sym_encrypt
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    issue_date DATE,
    expiration_date DATE,
    verification_status VARCHAR(50), -- ENUM('Verified', 'Pending', 'Invalid') DEFAULT 'Pending',
    source_id INT,
    source VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);
CREATE INDEX idx_person_identifiers_value ON person_identifiers(identifier_value);

-- 5. Addresses
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    census_block VARCHAR(50),
    ward VARCHAR(50),
    geom GEOMETRY(POINT, 4326),
    mail_forwarding_info TEXT,
    parent_address_id INT,
    metadata JSONB,
    change_history JSONB,
    enrichment_status VARCHAR(50), -- ENUM('Pending', 'Enriched', 'Failed') DEFAULT 'Pending',
    property_type VARCHAR(50), -- ENUM('Residential', 'Commercial', 'Mixed', 'Vacant'),
    delivery_point_code VARCHAR(10),
    last_validated_date DATE,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_address_id) REFERENCES addresses(address_id),
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);
CREATE INDEX idx_addresses_geom ON addresses USING GIST(geom);
CREATE INDEX idx_addresses_zip ON addresses(zip_code);

-- 6. Person Addresses
CREATE TABLE person_addresses (
    person_address_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    address_id INT NOT NULL,
    address_type VARCHAR(50), -- ENUM('Home', 'Work', 'Mailing', 'Other'),
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    is_current BOOLEAN DEFAULT TRUE,
    start_date DATE,
    end_date DATE,
    occupancy_status VARCHAR(50), -- ENUM('Owner', 'Renter', 'Temporary', 'Unknown') DEFAULT 'Unknown',
    move_in_date DATE,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id),
    UNIQUE (person_id, address_id)
);

-- 7. Person Emails
CREATE TABLE person_emails (
    email_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    email BYTEA UNIQUE,
    email_type VARCHAR(50), -- ENUM('Personal', 'Work', 'Other'),
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    is_verified BOOLEAN DEFAULT FALSE,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 8. Person Phones
CREATE TABLE person_phones (
    phone_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    phone_number BYTEA UNIQUE,
    phone_type VARCHAR(50), -- ENUM('Mobile', 'Home', 'Work', 'Other'),
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    is_verified BOOLEAN DEFAULT FALSE,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 9. Person Social Media
CREATE TABLE person_social_media (
    social_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    platform VARCHAR(50),
    handle VARCHAR(255) UNIQUE,
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 10. Person Employers
CREATE TABLE person_employers (
    employer_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    employer_name VARCHAR(255),
    occupation VARCHAR(255),
    start_date DATE,
    end_date DATE,
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 11. Person Payment Info
CREATE TABLE person_payment_info (
    payment_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    payment_type VARCHAR(50), -- ENUM('CreditCard', 'BankAccount', 'PayPal', 'Other'),
    details BYTEA,  -- Encrypt: pgp_sym_encrypt
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 12. Person Other Contacts
CREATE TABLE person_other_contacts (
    contact_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    contact_type VARCHAR(100),
    contact_value TEXT,
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 13. Voter History

-- 13. Survey Results
CREATE TABLE survey_results (
    survey_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    survey_date DATE,
    survey_source VARCHAR(255),
    responses JSONB,
    search_vector TSVECTOR,
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    response_time INT,
    survey_channel VARCHAR(50), -- ENUM('Online', 'Phone', 'InPerson', 'Mail'),
    completion_status VARCHAR(50), -- ENUM('Complete', 'Partial', 'Abandoned') DEFAULT 'Complete',
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);
CREATE INDEX idx_survey_results_search ON survey_results USING GIN(search_vector);

-- Trigger for search_vector
CREATE FUNCTION survey_search_trigger() RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', NEW.responses::TEXT);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER survey_search_update BEFORE INSERT OR UPDATE ON survey_results FOR EACH ROW EXECUTE FUNCTION survey_search_trigger();

-- 14. Voter History
CREATE TABLE voter_history (
    history_id SERIAL,
    person_id INT NOT NULL,
    election_date DATE NOT NULL,
    election_type VARCHAR(100),
    voted BOOLEAN,
    voting_method VARCHAR(50), -- ENUM('InPerson', 'Mail', 'Absentee', 'Other'),
    turnout_reason TEXT,
    survey_link_id INT,
    details JSONB,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (election_date, history_id),
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (survey_link_id) REFERENCES survey_results(survey_id),
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
) PARTITION BY RANGE (election_date);
CREATE INDEX idx_voter_history_date ON voter_history(election_date);

-- 15. Person Relationships
CREATE TABLE person_relationships (
    relationship_id SERIAL PRIMARY KEY,
    person_id1 INT NOT NULL,
    person_id2 INT NOT NULL,
    relationship_type VARCHAR(50), -- ENUM('Family', 'Spouse', 'Friend', 'Colleague', 'Other'),
    details TEXT,
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id1) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (person_id2) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id),
    UNIQUE (person_id1, person_id2)
);

-- 16. Districts
CREATE TABLE districts (
    district_id SERIAL PRIMARY KEY,
    district_name VARCHAR(255),
    district_type VARCHAR(50), -- ENUM('Federal', 'State', 'Local', 'Special'),
    boundaries JSONB,
    geom GEOMETRY(MULTIPOLYGON, 4326),
    district_code VARCHAR(50),
    election_cycle VARCHAR(50),
    population_estimate INT,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);
CREATE INDEX idx_districts_geom ON districts USING GIST(geom);

-- 17. Address Districts
CREATE TABLE address_districts (
    address_district_id SERIAL PRIMARY KEY,
    address_id INT NOT NULL,
    district_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE CASCADE,
    FOREIGN KEY (district_id) REFERENCES districts(district_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id),
    UNIQUE (address_id, district_id)
);

-- 18. Campaigns
CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    campaign_type VARCHAR(50), -- ENUM('Local', 'State', 'Federal', 'Issue'),
    details JSONB,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 19. Person Campaign Interactions
CREATE TABLE person_campaign_interactions (
    interaction_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    campaign_id INT NOT NULL,
    interaction_type VARCHAR(50), -- ENUM('ContactForm', 'Donation', 'Endorsement', 'Volunteer', 'Other'),
    interaction_date DATE,
    amount DECIMAL(10,2),
    follow_up_needed BOOLEAN DEFAULT FALSE,
    details JSONB,
    confidence_score INT DEFAULT 100 CHECK (confidence_score BETWEEN 0 AND 100),
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 20. Government Bodies
CREATE TABLE government_bodies (
    body_id SERIAL PRIMARY KEY,
    body_name VARCHAR(255),
    jurisdiction VARCHAR(100),
    details JSONB,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 21. Positions
CREATE TABLE positions (
    position_id SERIAL PRIMARY KEY,
    body_id INT NOT NULL,
    position_title VARCHAR(255),
    term_length INT,
    salary DECIMAL(10,2),
    requirements TEXT,
    current_holder_person_id INT,
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (body_id) REFERENCES government_bodies(body_id) ON DELETE CASCADE,
    FOREIGN KEY (current_holder_person_id) REFERENCES persons(person_id),
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);

-- 22. Donations (Stripe Functionality)
CREATE TABLE donations (
    id SERIAL PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_status VARCHAR(50), -- ENUM('succeeded', 'pending', 'failed', 'requires_payment_method', 'requires_confirmation') DEFAULT 'pending',
    stripe_payment_intent_id VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    address_city VARCHAR(100),
    address_state VARCHAR(50),
    address_zip VARCHAR(20),
    employer VARCHAR(255),
    occupation VARCHAR(255),
    email BYTEA,
    phone_number BYTEA,
    contact_email BOOLEAN DEFAULT FALSE,
    contact_phone BOOLEAN DEFAULT FALSE,
    contact_mail BOOLEAN DEFAULT FALSE,
    contact_sms BOOLEAN DEFAULT FALSE,
    is_recurring BOOLEAN DEFAULT FALSE,
    covers_fees BOOLEAN DEFAULT FALSE,
    person_id INT,  -- Optional FK to persons (if donor matches an existing voter)
    campaign_id INT NOT NULL,  -- FK to campaigns
    source_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE SET NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES data_sources(source_id)
);
CREATE INDEX idx_donations_stripe_id ON donations(stripe_payment_intent_id);
CREATE INDEX idx_donations_campaign ON donations(campaign_id);

-- 23. Person Merges
CREATE TABLE person_merges (
    merge_id SERIAL PRIMARY KEY,
    merged_from_person_id INT NOT NULL,
    merged_to_person_id INT NOT NULL,
    merge_date DATE DEFAULT CURRENT_DATE,
    merge_reason TEXT,
    merge_confidence INT CHECK (merge_confidence BETWEEN 0 AND 100),
    merge_method VARCHAR(50), -- ENUM('Manual', 'Automated') DEFAULT 'Manual',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (merged_from_person_id) REFERENCES persons(person_id),
    FOREIGN KEY (merged_to_person_id) REFERENCES persons(person_id)
);

-- 24. Audit Logs
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    record_id INT,
    action_type VARCHAR(50), -- ENUM('INSERT', 'UPDATE', 'DELETE'),
    changed_by_user VARCHAR(255),
    ip_address VARCHAR(45),
    session_id VARCHAR(100),
    changes JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example Trigger for Audit
CREATE OR REPLACE FUNCTION audit_trigger() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action_type, changes, changed_by_user, ip_address, session_id)
    VALUES (TG_TABLE_NAME, NEW.id, TG_OP, row_to_json(NEW)::JSONB - row_to_json(OLD)::JSONB, current_user, inet_client_addr(), session_user);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER persons_audit AFTER UPDATE ON persons FOR EACH ROW EXECUTE FUNCTION audit_trigger();
CREATE TRIGGER donations_audit AFTER UPDATE ON donations FOR EACH ROW EXECUTE FUNCTION audit_trigger();
-- Repeat for other tables as needed

-- 25. Backup Logs
CREATE TABLE backup_logs (
    backup_id SERIAL PRIMARY KEY,
    backup_type VARCHAR(50), -- ENUM('Full', 'Incremental', 'WAL'),
    backup_location VARCHAR(255),
    backup_size BIGINT,
    backup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50), -- ENUM('Success', 'Failed') DEFAULT 'Success',
    retention_expiry_date DATE,
    encryption_status BOOLEAN DEFAULT FALSE
);

-- 26. Materialized View
CREATE MATERIALIZED VIEW voter_turnout_summary AS
SELECT party_affiliation, AVG(voter_propensity_score) AS avg_score, COUNT(*) AS count
FROM persons
WHERE registration_status = 'Active'
GROUP BY party_affiliation;

-- Refresh: REFRESH MATERIALIZED VIEW voter_turnout_summary;