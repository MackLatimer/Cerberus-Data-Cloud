-- Table for municipalities
CREATE TABLE municipalities (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    agenda_url TEXT,
    scraper_type TEXT, -- e.g., 'Legistar', 'Municode', 'CivicPlus', 'WordPress', 'CustomJS', 'RobotsBlocked'
    config JSONB,      -- For city-specific scraping parameters if needed
    is_active BOOLEAN DEFAULT TRUE,
    last_scraped_at TIMESTAMP
);

-- Table for agendas
CREATE TABLE agendas (
    id SERIAL PRIMARY KEY,
    municipality_id INTEGER NOT NULL REFERENCES municipalities(id) ON DELETE CASCADE,
    date TEXT NOT NULL,        -- Date of the meeting (YYYY-MM-DD format)
    pdf_url TEXT NOT NULL,     -- URL to the original PDF agenda document
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (municipality_id, date, pdf_url)
);

-- Table for agenda items
CREATE TABLE agenda_items (
    id SERIAL PRIMARY KEY,
    agenda_id INTEGER NOT NULL REFERENCES agendas(id) ON DELETE CASCADE,
    heading TEXT,
    file_prefix TEXT,
    item_text TEXT NOT NULL,
    category TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_agenda_item_text UNIQUE (agenda_id, item_text)
);

-- Table for user subscriptions
CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    filter_settings JSONB NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    last_checked TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
