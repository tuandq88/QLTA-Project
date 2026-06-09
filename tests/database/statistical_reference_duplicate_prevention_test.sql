-- Statistical reference duplicate-prevention test.
-- Prerequisite: unified schema + migrations 003/004 + seed 004.
-- This file is intended for a disposable/staging database.

BEGIN;

DO $$
DECLARE
    v_court_id UUID;
    v_case_id UUID;
    v_criminal_detail_id UUID;
    v_defendant_id UUID;
    v_feature_id UUID;
    v_relationship_id UUID;
    v_form_id UUID;
    v_failed BOOLEAN;
BEGIN
    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('TEST_STAT_DUP_COURT', 'Test statistical duplicate court', 'province')
    RETURNING court_id INTO v_court_id;

    INSERT INTO case_files (court_id, case_code, case_type, filing_date, acceptance_date, case_status)
    VALUES (v_court_id, 'TEST-STAT-DUP-001', 'criminal', CURRENT_DATE, CURRENT_DATE, 'accepted')
    RETURNING case_id INTO v_case_id;

    INSERT INTO criminal_case_details (case_id)
    VALUES (v_case_id)
    RETURNING criminal_detail_id INTO v_criminal_detail_id;

    INSERT INTO defendants (criminal_detail_id, full_name)
    VALUES (v_criminal_detail_id, 'Duplicate Test Defendant')
    RETURNING defendant_id INTO v_defendant_id;

    SELECT feature_id INTO v_feature_id
    FROM dm_defendant_statistical_features
    WHERE feature_code = 'minor';

    SELECT legal_relationship_id INTO v_relationship_id
    FROM dm_legal_relationships
    WHERE relationship_code = 'civil_general_review_required';

    SELECT form_id INTO v_form_id
    FROM dm_statistical_forms
    WHERE form_code = 'FORM_REVIEW_REQUIRED';

    v_failed := FALSE;
    BEGIN
        INSERT INTO dm_defendant_statistical_features (feature_code, feature_name)
        VALUES ('minor', 'Duplicate feature');
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate feature_code to fail';
    END IF;

    INSERT INTO dm_penal_code_articles (code, article_number)
    VALUES ('TEST_DUP_ARTICLE', 'TEST-DUP');

    INSERT INTO dm_crimes (crime_code, crime_name)
    VALUES ('TEST_DUP_CRIME', 'Test duplicate crime');

    v_failed := FALSE;
    BEGIN
        INSERT INTO dm_crimes (crime_code, crime_name)
        VALUES ('TEST_DUP_CRIME', 'Duplicate crime');
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate crime_code to fail';
    END IF;

    v_failed := FALSE;
    BEGIN
        INSERT INTO dm_legal_relationships (relationship_code, relationship_name)
        VALUES ('civil_general_review_required', 'Duplicate relationship');
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate relationship_code to fail';
    END IF;

    v_failed := FALSE;
    BEGIN
        INSERT INTO dm_trial_result_types (result_code, result_name)
        VALUES ('accepted_claim', 'Duplicate result');
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate trial result_code to fail';
    END IF;

    INSERT INTO defendant_statistical_features (defendant_id, case_id, feature_id)
    VALUES (v_defendant_id, v_case_id, v_feature_id);

    v_failed := FALSE;
    BEGIN
        INSERT INTO defendant_statistical_features (defendant_id, case_id, feature_id)
        VALUES (v_defendant_id, v_case_id, v_feature_id);
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate defendant feature to fail';
    END IF;

    INSERT INTO case_legal_relationships (case_id, legal_relationship_id)
    VALUES (v_case_id, v_relationship_id);

    v_failed := FALSE;
    BEGIN
        INSERT INTO case_legal_relationships (case_id, legal_relationship_id)
        VALUES (v_case_id, v_relationship_id);
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate case legal relationship to fail';
    END IF;

    INSERT INTO dm_statistical_form_items (form_id, item_code, item_name)
    VALUES (v_form_id, 'TEST_DUP_ITEM', 'Test duplicate item');

    v_failed := FALSE;
    BEGIN
        INSERT INTO dm_statistical_form_items (form_id, item_code, item_name)
        VALUES (v_form_id, 'TEST_DUP_ITEM', 'Duplicate form item');
    EXCEPTION WHEN unique_violation THEN
        v_failed := TRUE;
    END;
    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate statistical form item in same form to fail';
    END IF;
END $$;

ROLLBACK;
