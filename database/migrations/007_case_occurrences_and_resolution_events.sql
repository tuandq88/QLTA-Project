-- Migration 007: case occurrence lifecycle and resolution event model.
-- Purpose: support occurrence-based statistics for cases that are returned
-- to the Procuracy for supplemental investigation and later re-accepted.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS case_occurrences (
    occurrence_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    occurrence_no INTEGER NOT NULL,
    acceptance_date DATE NOT NULL,
    acceptance_type_code VARCHAR(100) NOT NULL,
    acceptance_type_id UUID,
    previous_occurrence_id UUID REFERENCES case_occurrences(occurrence_id) ON DELETE SET NULL,
    source_note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_case_occurrences_case_no UNIQUE (case_id, occurrence_no),
    CONSTRAINT chk_case_occurrences_occurrence_no CHECK (occurrence_no > 0),
    CONSTRAINT chk_case_occurrences_acceptance_type CHECK (
        acceptance_type_code IN (
            'INITIAL_ACCEPTANCE',
            'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION'
        )
    )
);

CREATE TABLE IF NOT EXISTS case_resolution_events (
    resolution_event_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    occurrence_id UUID NOT NULL REFERENCES case_occurrences(occurrence_id) ON DELETE CASCADE,
    event_type_code VARCHAR(100) NOT NULL DEFAULT 'RESOLUTION',
    event_date DATE NOT NULL,
    resolution_type_code VARCHAR(150) NOT NULL,
    resolution_type_id UUID,
    return_to_agency_code VARCHAR(100),
    return_to_agency_id UUID,
    decision_number VARCHAR(100),
    counted_as_resolved BOOLEAN NOT NULL DEFAULT TRUE,
    reason TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_case_resolution_events_event_type CHECK (btrim(event_type_code) <> ''),
    CONSTRAINT chk_case_resolution_events_resolution_type CHECK (btrim(resolution_type_code) <> ''),
    CONSTRAINT chk_case_resolution_events_return_agency CHECK (
        return_to_agency_code IS NULL OR btrim(return_to_agency_code) <> ''
    )
);

ALTER TABLE case_occurrences
    ADD COLUMN IF NOT EXISTS acceptance_type_id UUID;

ALTER TABLE case_resolution_events
    ADD COLUMN IF NOT EXISTS event_type_code VARCHAR(100) NOT NULL DEFAULT 'RESOLUTION',
    ADD COLUMN IF NOT EXISTS resolution_type_id UUID,
    ADD COLUMN IF NOT EXISTS return_to_agency_id UUID;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_case_occurrences_acceptance_type_id_dm_items') THEN
        ALTER TABLE case_occurrences
            ADD CONSTRAINT fk_case_occurrences_acceptance_type_id_dm_items
            FOREIGN KEY (acceptance_type_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_case_resolution_events_resolution_type_id_dm_items') THEN
        ALTER TABLE case_resolution_events
            ADD CONSTRAINT fk_case_resolution_events_resolution_type_id_dm_items
            FOREIGN KEY (resolution_type_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_case_resolution_events_return_to_agency_id_dm_items') THEN
        ALTER TABLE case_resolution_events
            ADD CONSTRAINT fk_case_resolution_events_return_to_agency_id_dm_items
            FOREIGN KEY (return_to_agency_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_case_occurrences_case_acceptance
    ON case_occurrences(case_id, acceptance_date);

CREATE INDEX IF NOT EXISTS idx_case_occurrences_acceptance_type
    ON case_occurrences(acceptance_type_code, acceptance_date);

CREATE INDEX IF NOT EXISTS idx_case_resolution_events_case_date
    ON case_resolution_events(case_id, event_date);

CREATE INDEX IF NOT EXISTS idx_case_resolution_events_occurrence_date
    ON case_resolution_events(occurrence_id, event_date);

CREATE INDEX IF NOT EXISTS idx_case_resolution_events_type_date
    ON case_resolution_events(resolution_type_code, event_date);

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_resolution_events_occurrence_type_date_decision
    ON case_resolution_events(occurrence_id, resolution_type_code, event_date, COALESCE(decision_number, ''));
