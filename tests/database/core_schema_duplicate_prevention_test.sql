-- Core duplicate-prevention test.
-- Run on a disposable database after applying database/migrations/001_core_database_schema.sql.

\set ON_ERROR_STOP on

BEGIN;

DO $$
DECLARE
    v_court_id uuid;
    v_user_id uuid;
    v_case_id uuid;
BEGIN
    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('DUP_CORE_COURT', 'Duplicate test court', 'province')
    RETURNING court_id INTO v_court_id;

    BEGIN
        INSERT INTO courts (court_code, court_name, court_level)
        VALUES ('DUP_CORE_COURT', 'Duplicate test court 2', 'province');
        RAISE EXCEPTION 'Expected duplicate court_code to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate court_code';
    END;

    INSERT INTO users (court_id, full_name, role_code, email)
    VALUES (v_court_id, 'Duplicate User', 'judge', 'dup-core@example.local')
    RETURNING user_id INTO v_user_id;

    BEGIN
        INSERT INTO users (court_id, full_name, role_code, email)
        VALUES (v_court_id, 'Duplicate Email User', 'judge', 'DUP-core@example.local');
        RAISE EXCEPTION 'Expected duplicate non-null email to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate user email';
    END;

    INSERT INTO judge_profiles (user_id, judge_code)
    VALUES (v_user_id, 'DUP_JUDGE_CODE');

    BEGIN
        INSERT INTO users (court_id, full_name, role_code, email)
        VALUES (v_court_id, 'Second Judge', 'judge', 'dup-core-2@example.local')
        RETURNING user_id INTO v_user_id;
        INSERT INTO judge_profiles (user_id, judge_code)
        VALUES (v_user_id, 'DUP_JUDGE_CODE');
        RAISE EXCEPTION 'Expected duplicate judge_code to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate judge_code';
    END;

    SELECT user_id INTO v_user_id FROM users WHERE email = 'dup-core@example.local';

    INSERT INTO case_files (court_id, case_code, case_number, case_type, case_status, acceptance_date)
    VALUES (v_court_id, 'DUP_CASE_CODE', 'DUP-01', 'civil', 'accepted', DATE '2026-06-08')
    RETURNING case_id INTO v_case_id;

    BEGIN
        INSERT INTO case_files (court_id, case_code, case_number, case_type, case_status, acceptance_date)
        VALUES (v_court_id, 'DUP_CASE_CODE', 'DUP-02', 'civil', 'accepted', DATE '2026-06-08');
        RAISE EXCEPTION 'Expected duplicate case_code to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate case_code';
    END;

    BEGIN
        INSERT INTO case_files (court_id, case_code, case_number, case_type, case_status, acceptance_date)
        VALUES (v_court_id, 'DUP_CASE_BUSINESS_KEY', 'DUP-01', 'civil', 'accepted', DATE '2026-06-08');
        RAISE EXCEPTION 'Expected duplicate case business key to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate case business key';
    END;

    INSERT INTO documents (case_id, document_type, document_number, document_date, checksum)
    VALUES (v_case_id, 'petition', 'DUP-DOC', DATE '2026-06-08', 'dup-doc-checksum');

    BEGIN
        INSERT INTO documents (case_id, document_type, document_number, document_date, checksum)
        VALUES (v_case_id, 'petition', 'DUP-DOC', DATE '2026-06-08', 'dup-doc-checksum-2');
        RAISE EXCEPTION 'Expected duplicate document in same case to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate document in same case';
    END;

    INSERT INTO decisions (case_id, decision_type, decision_number, decision_date)
    VALUES (v_case_id, 'judgment', 'DUP-DECISION', DATE '2026-07-01');

    BEGIN
        INSERT INTO decisions (case_id, decision_type, decision_number, decision_date)
        VALUES (v_case_id, 'judgment', 'DUP-DECISION', DATE '2026-07-01');
        RAISE EXCEPTION 'Expected duplicate decision in same case to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate decision in same case';
    END;

    INSERT INTO case_assignments (case_id, user_id, assignment_role, assigned_date, is_primary, status)
    VALUES (v_case_id, v_user_id, 'primary_judge', DATE '2026-06-08', TRUE, 'active');

    BEGIN
        INSERT INTO case_assignments (case_id, user_id, assignment_role, assigned_date, is_primary, status)
        VALUES (v_case_id, v_user_id, 'primary_judge', DATE '2026-06-09', TRUE, 'active');
        RAISE EXCEPTION 'Expected duplicate active primary assignment to fail';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Expected failure: duplicate active primary assignment';
    END;
END $$;

ROLLBACK;

SELECT 'core_schema_duplicate_prevention_test passed' AS result;
