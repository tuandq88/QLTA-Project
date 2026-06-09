-- Migration 005: legal seed data normalization support.
-- Scope: additive/compatible only. Required by database/seed/010_legal_seed_data_tand_vietnam.sql.

ALTER TABLE statistical_indicator_options
    ALTER COLUMN option_name TYPE TEXT;

ALTER TABLE dm_penal_code_articles
    ALTER COLUMN article_title TYPE TEXT,
    ADD COLUMN IF NOT EXISTS source_document TEXT,
    ADD COLUMN IF NOT EXISTS source_url TEXT,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS requires_human_review BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE dm_crimes
    ALTER COLUMN crime_name TYPE TEXT,
    ADD COLUMN IF NOT EXISTS legal_basis TEXT,
    ADD COLUMN IF NOT EXISTS source_document TEXT,
    ADD COLUMN IF NOT EXISTS source_url TEXT,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS requires_human_review BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE dm_legal_relationships
    ALTER COLUMN relationship_name TYPE TEXT,
    ADD COLUMN IF NOT EXISTS source_document TEXT,
    ADD COLUMN IF NOT EXISTS source_url TEXT,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS requires_human_review BOOLEAN NOT NULL DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_dm_crimes_active_sort
    ON dm_crimes (is_active, sort_order, crime_code);

CREATE INDEX IF NOT EXISTS idx_dm_legal_relationships_scope_active_sort
    ON dm_legal_relationships (case_type_scope, is_active, sort_order, relationship_code);
