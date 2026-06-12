-- Migration 009: store first-instance court metadata for appellate cases.
-- Purpose: separate current/appellate court (case_files.court_id) from the court
-- that issued the first-instance judgment/decision being appealed or protested.

ALTER TABLE case_files
    ADD COLUMN IF NOT EXISTS first_instance_court_id UUID,
    ADD COLUMN IF NOT EXISTS first_instance_case_number VARCHAR(100),
    ADD COLUMN IF NOT EXISTS first_instance_judgment_number VARCHAR(100),
    ADD COLUMN IF NOT EXISTS first_instance_judgment_date DATE;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_case_files_first_instance_court') THEN
        ALTER TABLE case_files
            ADD CONSTRAINT fk_case_files_first_instance_court
            FOREIGN KEY (first_instance_court_id) REFERENCES courts(court_id) ON DELETE RESTRICT;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_case_files_first_instance_court_id
    ON case_files(first_instance_court_id);

CREATE INDEX IF NOT EXISTS idx_case_files_appellate_first_instance_group
    ON case_files(first_instance_court_id, case_type, acceptance_date)
    WHERE case_group = 'PHUC_THAM';
