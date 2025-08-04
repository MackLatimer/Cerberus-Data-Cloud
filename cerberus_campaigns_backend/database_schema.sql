-- Database Schema for Cerberus Data Cloud

-- Campaigns Table
-- Stores information about different political campaigns.
CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL UNIQUE,
    start_date DATE,
    end_date DATE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Users Table
-- Stores information about users who can access the voter data portal.
-- This table will also be used for logging actions.
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Store hashed passwords only
    email VARCHAR(255) UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(50) DEFAULT 'viewer', -- e.g., 'admin', 'editor', 'viewer'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);

-- Voters Table
-- Stores information about individual voters.
-- This is the central table for voter data.
CREATE TABLE voters (
    voter_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(50),

    -- Address Information
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    county VARCHAR(100),
    precinct VARCHAR(100),

    -- Contact Information
    phone_number VARCHAR(20) UNIQUE,
    email_address VARCHAR(255) UNIQUE,

    -- Employer and Occupation
    employer VARCHAR(255),
    occupation VARCHAR(255),

    -- Contact preferences (checkboxes)
    contact_email BOOLEAN DEFAULT FALSE,
    contact_phone BOOLEAN DEFAULT FALSE,
    contact_mail BOOLEAN DEFAULT FALSE,
    contact_sms BOOLEAN DEFAULT FALSE,

    -- Voter Registration Information
    registration_status VARCHAR(50), -- e.g., 'Registered', 'Not Registered', 'Pending'
    voter_registration_id VARCHAR(100) UNIQUE, -- State-specific ID
    registration_date DATE,
    party_affiliation VARCHAR(100),

    -- Engagement Metrics (can be updated by interactions)
    engagement_score INTEGER DEFAULT 0,
    last_contacted_date TIMESTAMP WITH TIME ZONE,
    preferred_contact_method VARCHAR(50), -- e.g., 'Email', 'Phone', 'SMS'

    -- Custom Fields (flexible for different campaign needs)
    -- Consider using a separate EAV table or JSONB for more complex custom fields
    -- For simplicity here, a JSONB field is used.
    custom_fields JSONB,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    source_campaign_id INTEGER REFERENCES campaigns(campaign_id) -- Optional: campaign that initially sourced this voter
);

-- Create indexes for frequently queried columns on Voters table
CREATE INDEX idx_voters_last_name ON voters(last_name);
CREATE INDEX idx_voters_zip_code ON voters(zip_code);
CREATE INDEX idx_voters_email ON voters(email_address);
CREATE INDEX idx_voters_phone ON voters(phone_number);

-- Campaign Voters Table (Many-to-Many Relationship)
-- Links voters to specific campaigns they are relevant to.
-- This allows a voter to be part of multiple campaigns over time.
CREATE TABLE campaign_voters (
    campaign_voter_id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    voter_id INTEGER NOT NULL REFERENCES voters(voter_id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (campaign_id, voter_id) -- Ensure a voter is only added once per campaign
);

-- Interactions Table
-- Logs all interactions with voters (e.g., calls, emails, door knocks, survey responses).
CREATE TABLE interactions (
    interaction_id SERIAL PRIMARY KEY,
    voter_id INTEGER NOT NULL REFERENCES voters(voter_id) ON DELETE CASCADE,
    campaign_id INTEGER REFERENCES campaigns(campaign_id) ON DELETE SET NULL, -- Interaction can be campaign-specific or general
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL, -- User who logged the interaction
    interaction_type VARCHAR(100) NOT NULL, -- e.g., 'Phone Call', 'Email Sent', 'Door Knock', 'Survey', 'Event Attendance'
    interaction_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    outcome VARCHAR(255), -- e.g., 'Interested', 'Not Home', 'Wrong Number', 'Pledged Support'
    notes TEXT,
    duration_minutes INTEGER, -- For calls or meetings
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_interactions_voter_id ON interactions(voter_id);
CREATE INDEX idx_interactions_campaign_id ON interactions(campaign_id);
CREATE INDEX idx_interactions_type ON interactions(interaction_type);

-- Survey Questions Table
-- Stores questions for surveys that can be linked to campaigns.
CREATE TABLE survey_questions (
    question_id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(campaign_id) ON DELETE CASCADE, -- Optional: campaign-specific questions
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL, -- e.g., 'Multiple Choice', 'Open Text', 'Rating Scale'
    possible_answers JSONB, -- For multiple choice, e.g., {"A": "Answer 1", "B": "Answer 2"}
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Survey Responses Table
-- Stores voter responses to survey questions.
CREATE TABLE survey_responses (
    response_id SERIAL PRIMARY KEY,
    interaction_id INTEGER REFERENCES interactions(interaction_id) ON DELETE CASCADE, -- Link to the interaction where survey was taken
    voter_id INTEGER NOT NULL REFERENCES voters(voter_id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES survey_questions(question_id) ON DELETE CASCADE,
    response_value TEXT, -- For open text or single choice
    response_values JSONB, -- For multiple selections from multiple choice
    responded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_survey_responses_voter_id ON survey_responses(voter_id);
CREATE INDEX idx_survey_responses_question_id ON survey_responses(question_id);

-- Function to update `updated_at` timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers to automatically update `updated_at` timestamps
CREATE TRIGGER set_campaigns_timestamp
BEFORE UPDATE ON campaigns
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_voters_timestamp
BEFORE UPDATE ON voters
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Notes on Schema Design for Multi-Campaign and Central Voter Store:
-- 1. `campaigns` table: Allows defining multiple distinct campaigns. Each campaign site can be associated with a `campaign_id`.
-- 2. `voters` table: Central repository for all voter information. Data can be enhanced over time from various sources.
-- 3. `campaign_voters` table: Manages the many-to-many relationship between voters and campaigns. A voter can be relevant to multiple campaigns without duplicating voter core data.
-- 4. `interactions` table: Can be linked to a specific `campaign_id` or be general (NULL `campaign_id`). This helps in tracking campaign-specific outreach versus general voter engagement.
-- 5. `users` table: Manages access to the central voter data portal. Roles can define permissions.
-- 6. `custom_fields` in `voters` (JSONB): Provides flexibility for campaigns to store specific data points not covered by standard fields without altering the schema frequently.
-- 7. `source_campaign_id` in `voters`: Optional field to track which campaign initially added a voter, useful for data attribution.
-- 8. Scalability: Indexes are added on frequently queried columns. The separation of concerns (voters, campaigns, interactions) helps in managing data growth.
--    For very large datasets, consider partitioning tables (e.g., `voters` by region, `interactions` by date).

-- Example of adding a campaign:
-- INSERT INTO campaigns (campaign_name, start_date, end_date, description) VALUES ('Emmons for Mayor 2024', '2024-01-01', '2024-11-05', 'John Emmons mayoral campaign.');

-- Example of adding a user for the portal:
-- INSERT INTO users (username, password_hash, email, first_name, last_name, role) VALUES ('admin_user', 'hashed_password_example', 'admin@example.com', 'Admin', 'User', 'admin');

-- Example of adding a voter:
-- INSERT INTO voters (first_name, last_name, email_address, zip_code, party_affiliation) VALUES ('Jane', 'Doe', 'jane.doe@example.com', '12345', 'Independent');

-- Example of associating a voter with a campaign:
-- INSERT INTO campaign_voters (campaign_id, voter_id) VALUES (1, 1);

-- Example of logging an interaction:
-- INSERT INTO interactions (voter_id, campaign_id, user_id, interaction_type, outcome, notes) VALUES (1, 1, 1, 'Phone Call', 'Interested', 'Expressed interest in volunteering.');

COMMIT;

CREATE TABLE donations (
    id SERIAL PRIMARY KEY,
    amount FLOAT NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'usd',
    payment_status VARCHAR(50) NOT NULL DEFAULT 'pending',
    stripe_payment_intent_id VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    address_city VARCHAR(100),
    address_state VARCHAR(100),
    address_zip VARCHAR(20),
    employer VARCHAR(255),
    occupation VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(50),
    contact_email BOOLEAN DEFAULT FALSE,
    contact_phone BOOLEAN DEFAULT FALSE,
    contact_mail BOOLEAN DEFAULT FALSE,
    contact_sms BOOLEAN DEFAULT FALSE,
    is_recurring BOOLEAN DEFAULT FALSE,
    covers_fees BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
