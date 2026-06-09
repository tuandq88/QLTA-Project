-- Core schema integrity smoke test.
-- Run on a disposable database after applying database/migrations/001_core_database_schema.sql.

\set ON_ERROR_STOP on

DO $$
DECLARE
    expected_tables text[] := ARRAY[
        'courts', 'users', 'judge_profiles', 'case_files', 'participants',
        'documents', 'hearings', 'decisions', 'case_assignments', 'case_events',
        'deadlines', 'validation_results', 'audit_logs'
    ];
    expected_types text[] := ARRAY[
        'court_level_enum', 'user_role_enum', 'case_type_enum', 'case_status_enum',
        'participant_type_enum', 'document_type_enum', 'hearing_type_enum',
        'hearing_status_enum', 'decision_type_enum', 'assignment_role_enum',
        'assignment_status_enum', 'deadline_status_enum', 'validation_severity_enum',
        'audit_action_type_enum'
    ];
    item text;
BEGIN
    FOREACH item IN ARRAY expected_tables LOOP
        IF to_regclass('public.' || item) IS NULL THEN
            RAISE EXCEPTION 'Missing core table: %', item;
        END IF;
    END LOOP;

    FOREACH item IN ARRAY expected_types LOOP
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = item) THEN
            RAISE EXCEPTION 'Missing core enum/type: %', item;
        END IF;
    END LOOP;
END $$;

DO $$
DECLARE
    expected_constraints text[] := ARRAY[
        'users_court_id_fkey',
        'judge_profiles_user_id_fkey',
        'case_files_court_id_fkey',
        'case_files_assigned_judge_id_fkey',
        'participants_case_id_fkey',
        'documents_case_id_fkey',
        'hearings_case_id_fkey',
        'decisions_case_id_fkey',
        'case_assignments_case_id_fkey',
        'case_assignments_user_id_fkey',
        'case_events_case_id_fkey',
        'deadlines_case_id_fkey',
        'validation_results_case_id_fkey',
        'audit_logs_actor_id_fkey'
    ];
    expected_indexes text[] := ARRAY[
        'idx_courts_parent',
        'idx_users_court',
        'idx_case_files_court_status',
        'idx_case_files_court_type_acceptance',
        'uq_case_files_business_key',
        'uq_documents_case_type_number_date',
        'uq_decisions_case_type_number_date',
        'uq_case_assignments_active_primary_role',
        'idx_deadlines_pending_overdue',
        'idx_audit_logs_table_record'
    ];
    item text;
BEGIN
    FOREACH item IN ARRAY expected_constraints LOOP
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = item) THEN
            RAISE EXCEPTION 'Missing FK/constraint: %', item;
        END IF;
    END LOOP;

    FOREACH item IN ARRAY expected_indexes LOOP
        IF to_regclass('public.' || item) IS NULL THEN
            RAISE EXCEPTION 'Missing index: %', item;
        END IF;
    END LOOP;
END $$;

BEGIN;

WITH inserted_court AS (
    INSERT INTO courts (court_code, court_name, court_level, province)
    VALUES ('TEST_QNG_CORE', 'TAND tinh Quang Ngai test', 'province', 'Quang Ngai')
    RETURNING court_id
),
inserted_user AS (
    INSERT INTO users (court_id, full_name, position_title, role_code, email)
    SELECT court_id, 'Nguyen Van Test', 'Judge', 'judge', 'core-test@example.local'
    FROM inserted_court
    RETURNING user_id, court_id
),
inserted_judge AS (
    INSERT INTO judge_profiles (user_id, judge_code, judge_title, specialized_group)
    SELECT user_id, 'JUDGE_CORE_TEST', 'Judge', 'civil'
    FROM inserted_user
    RETURNING judge_profile_id
),
inserted_case AS (
    INSERT INTO case_files (court_id, case_code, case_number, case_type, case_status, acceptance_date, current_stage, assigned_judge_id)
    SELECT court_id, 'CASE_CORE_TEST', '01/2026/TLST-DS', 'civil', 'accepted', DATE '2026-06-08', 'accepted', user_id
    FROM inserted_user
    RETURNING case_id, assigned_judge_id
),
inserted_participant AS (
    INSERT INTO participants (case_id, participant_type, full_name, date_of_birth)
    SELECT case_id, 'plaintiff', 'Tran Thi Test', DATE '1980-01-01'
    FROM inserted_case
    RETURNING participant_id, case_id
),
inserted_document AS (
    INSERT INTO documents (case_id, document_type, document_number, document_date, file_name, checksum)
    SELECT case_id, 'petition', 'DOC-CORE-TEST', DATE '2026-06-08', 'petition.pdf', 'checksum-core-test'
    FROM inserted_case
    RETURNING document_id, case_id
),
inserted_hearing AS (
    INSERT INTO hearings (case_id, hearing_type, scheduled_date, scheduled_time, hearing_status)
    SELECT case_id, 'trial', DATE '2026-07-01', TIME '08:00', 'scheduled'
    FROM inserted_case
    RETURNING hearing_id
),
inserted_decision AS (
    INSERT INTO decisions (case_id, decision_type, decision_number, decision_date, result_code, document_id)
    SELECT c.case_id, 'judgment', 'DEC-CORE-TEST', DATE '2026-07-02', 'accepted', d.document_id
    FROM inserted_case c CROSS JOIN inserted_document d
    RETURNING decision_id
),
inserted_assignment AS (
    INSERT INTO case_assignments (case_id, user_id, assignment_role, assigned_date, is_primary, status)
    SELECT case_id, assigned_judge_id, 'primary_judge', DATE '2026-06-08', TRUE, 'active'
    FROM inserted_case
    RETURNING assignment_id
),
inserted_event AS (
    INSERT INTO case_events (case_id, event_type, event_stage, event_date, performed_by, source_document_id)
    SELECT c.case_id, 'accepted', 'acceptance', DATE '2026-06-08', c.assigned_judge_id, d.document_id
    FROM inserted_case c CROSS JOIN inserted_document d
    RETURNING event_id
),
inserted_deadline AS (
    INSERT INTO deadlines (case_id, deadline_type, start_date, due_date, deadline_status, legal_basis)
    SELECT case_id, 'trial_preparation', DATE '2026-06-08', DATE '2026-10-08', 'pending', 'Pending legal-basis confirmation'
    FROM inserted_case
    RETURNING deadline_id
),
inserted_validation AS (
    INSERT INTO validation_results (case_id, rule_code, severity, validation_status, message, field_name, suggested_action)
    SELECT case_id, 'CORE_TEST_RULE', 'info', 'open', 'Core validation test', 'case_code', 'No action'
    FROM inserted_case
    RETURNING validation_id
)
INSERT INTO audit_logs (table_name, record_id, action, actor_id, note)
SELECT 'case_files', case_id, 'insert', assigned_judge_id, 'Core schema integrity test'
FROM inserted_case;

ROLLBACK;

SELECT 'core_schema_integrity_test passed' AS result;
