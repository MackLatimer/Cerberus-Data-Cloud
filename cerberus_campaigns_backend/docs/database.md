# Cerberus Backend Database Documentation

## Overview

The database is designed to support multiple campaign frontends while maintaining a central repository for voter information. It uses PostgreSQL.

## Schema Definition

The canonical SQL schema definition can be found in [`database_schema.sql`](../database_schema.sql) in the root of the repository. This file defines all tables, columns, types, relationships, indexes, and initial functions/triggers.

The SQLAlchemy models, which should correspond to this schema, are located in `cerberus_backend/app/models/`.

## Key Tables

-   **`campaigns`**: Stores information about different political campaigns. Each campaign frontend (like Emmons-Frontend) will be associated with a record here.
    -   `campaign_id` (PK)
    -   `campaign_name` (Unique)
    -   `start_date`, `end_date`, `description`

-   **`users`**: Manages user accounts for accessing the (future) voter data portal.
    -   `user_id` (PK)
    -   `username` (Unique)
    -   `password_hash`
    -   `email` (Unique)
    -   `role` (e.g., 'admin', 'editor', 'viewer')

-   **`voters`**: The central table for all voter information. Data can be aggregated from multiple campaigns and sources.
    -   `voter_id` (PK)
    -   Personal details (`first_name`, `last_name`, `date_of_birth`, etc.)
    -   Address information (`street_address`, `city`, `state`, `zip_code`, etc.)
    -   Contact information (`phone_number`, `email_address` - both unique where possible)
    -   Voter registration details (`registration_status`, `voter_registration_id`, etc.)
    -   Engagement metrics (`engagement_score`, `last_contacted_date`)
    -   `custom_fields` (JSON, for flexible campaign-specific data)
    -   `source_campaign_id` (FK to `campaigns`, optional, to track initial data source)

-   **`campaign_voters`**: A many-to-many association table linking `voters` to `campaigns`. This allows a single voter record to be associated with multiple campaigns without data duplication.
    -   `campaign_voter_id` (PK)
    -   `campaign_id` (FK)
    -   `voter_id` (FK)
    -   Unique constraint on (`campaign_id`, `voter_id`)

-   **`interactions`**: Logs all types of interactions with voters (e.g., website signups, calls, emails, survey responses).
    -   `interaction_id` (PK)
    -   `voter_id` (FK)
    -   `campaign_id` (FK, optional, can be general or campaign-specific)
    -   `user_id` (FK to `users`, optional, for interactions logged by a portal user)
    -   `interaction_type`, `interaction_date`, `outcome`, `notes`

-   **`survey_questions`**: Stores questions for surveys.
    -   `question_id` (PK)
    -   `campaign_id` (FK, optional, for campaign-specific surveys)
    -   `question_text`, `question_type`
    -   `possible_answers` (JSON, for multiple choice options)

-   **`survey_responses`**: Stores voter responses to survey questions.
    -   `response_id` (PK)
    -   `interaction_id` (FK, if survey was part of a broader interaction)
    -   `voter_id` (FK)
    -   `question_id` (FK)
    -   `response_value` (Text, for single answers)
    -   `response_values` (JSON, for multiple selections)

## Relationships

-   Voters can be associated with multiple Campaigns (via `campaign_voters`).
-   Interactions are linked to a Voter, and optionally to a Campaign and a User (who logged it).
-   Survey Questions can be general or linked to a Campaign.
-   Survey Responses link a Voter to a Survey Question, and optionally to an Interaction.

## Timestamps

Most tables include `created_at` and `updated_at` timestamp columns.
-   `created_at` typically defaults to `CURRENT_TIMESTAMP`.
-   `updated_at` is managed by a database trigger (`trigger_set_timestamp`) in PostgreSQL that updates the timestamp on any row update. The SQLAlchemy models also specify `onupdate=func.now()`.

## Migrations

Database schema migrations are managed by Flask-Migrate (which uses Alembic). Migration scripts are stored in `cerberus_backend/migrations/versions/`.
-   To initialize (if not already done): `flask db init`
-   To generate a new migration after model changes: `flask db migrate -m "Descriptive message"`
-   To apply migrations: `flask db upgrade`

Refer to Flask-Migrate documentation for more details.
