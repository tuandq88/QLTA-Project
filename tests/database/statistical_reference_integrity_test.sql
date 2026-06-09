-- Statistical reference integrity smoke test.
-- Prerequisite: unified schema + migrations 003/004 + seed 004.
-- This file is intended for a disposable/staging database.

BEGIN;

DO $$
DECLARE
    missing_count INTEGER;
BEGIN
    SELECT count(*)
    INTO missing_count
    FROM (VALUES
        ('statistical_categories'),
        ('statistical_indicators'),
        ('statistical_indicator_options'),
        ('entity_statistical_attributes'),
        ('dm_penal_code_articles'),
        ('dm_crimes'),
        ('dm_defendant_statistical_features'),
        ('defendant_statistical_features'),
        ('dm_legal_relationships'),
        ('case_legal_relationships'),
        ('dm_trial_result_types'),
        ('dm_appellate_result_codes'),
        ('dm_statistical_forms'),
        ('dm_statistical_form_items'),
        ('dm_statistical_metrics')
    ) AS expected(table_name)
    WHERE to_regclass(expected.table_name) IS NULL;

    IF missing_count <> 0 THEN
        RAISE EXCEPTION 'Missing statistical reference tables: %', missing_count;
    END IF;
END $$;

DO $$
DECLARE
    v_court_id UUID;
    v_user_id UUID;
    v_case_id UUID;
    v_criminal_detail_id UUID;
    v_defendant_id UUID;
    v_article_id UUID;
    v_crime_id UUID;
    v_feature_minor UUID;
    v_feature_detained UUID;
    v_relationship_id UUID;
    v_decision_id UUID;
    v_trial_result_type_id UUID;
BEGIN
    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('TEST_STAT_REF_COURT', 'Test statistical reference court', 'province')
    RETURNING court_id INTO v_court_id;

    INSERT INTO users (court_id, full_name, role_code)
    VALUES (v_court_id, 'Test Judge Statistical Reference', 'judge')
    RETURNING user_id INTO v_user_id;

    INSERT INTO case_files (court_id, case_code, case_type, filing_date, acceptance_date, case_status)
    VALUES (v_court_id, 'TEST-STAT-REF-001', 'criminal', CURRENT_DATE, CURRENT_DATE, 'accepted')
    RETURNING case_id INTO v_case_id;

    INSERT INTO criminal_case_details (case_id)
    VALUES (v_case_id)
    RETURNING criminal_detail_id INTO v_criminal_detail_id;

    INSERT INTO defendants (criminal_detail_id, full_name, is_minor, is_detained)
    VALUES (v_criminal_detail_id, 'Test Defendant', TRUE, TRUE)
    RETURNING defendant_id INTO v_defendant_id;

    INSERT INTO dm_penal_code_articles (code, article_number, article_title, law_code)
    VALUES ('TEST_ARTICLE_001', 'TEST-001', 'Test article for FK only', 'TEST')
    RETURNING article_id INTO v_article_id;

    INSERT INTO dm_crimes (article_id, crime_code, crime_name, crime_severity)
    VALUES (v_article_id, 'TEST_CRIME_001', 'Test crime for FK only', 'test')
    RETURNING crime_id INTO v_crime_id;

    INSERT INTO charges (defendant_id, crime_name, penal_code_article, crime_id, article_id)
    VALUES (v_defendant_id, 'legacy snapshot text', 'legacy article text', v_crime_id, v_article_id);

    SELECT feature_id INTO v_feature_minor
    FROM dm_defendant_statistical_features
    WHERE feature_code = 'minor';

    SELECT feature_id INTO v_feature_detained
    FROM dm_defendant_statistical_features
    WHERE feature_code = 'detained';

    INSERT INTO defendant_statistical_features (defendant_id, case_id, feature_id)
    VALUES (v_defendant_id, v_case_id, v_feature_minor);

    INSERT INTO defendant_statistical_features (defendant_id, case_id, feature_id)
    VALUES (v_defendant_id, v_case_id, v_feature_detained);

    SELECT legal_relationship_id INTO v_relationship_id
    FROM dm_legal_relationships
    WHERE relationship_code = 'civil_general_review_required';

    INSERT INTO case_legal_relationships (case_id, legal_relationship_id, is_primary)
    VALUES (v_case_id, v_relationship_id, TRUE);

    SELECT trial_result_type_id INTO v_trial_result_type_id
    FROM dm_trial_result_types
    WHERE result_code = 'accepted_claim';

    INSERT INTO decisions (case_id, decision_type, decision_date, trial_result_type_id)
    VALUES (v_case_id, 'judgment', CURRENT_DATE, v_trial_result_type_id)
    RETURNING decision_id INTO v_decision_id;

    IF v_decision_id IS NULL THEN
        RAISE EXCEPTION 'Decision insert with trial_result_type_id failed';
    END IF;
END $$;

DO $$
DECLARE
    v_failed BOOLEAN := FALSE;
BEGIN
    BEGIN
        INSERT INTO charges (defendant_id, crime_id)
        VALUES (uuid_generate_v4(), uuid_generate_v4());
    EXCEPTION
        WHEN foreign_key_violation THEN
            v_failed := TRUE;
    END;

    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected invalid charge FK insert to fail';
    END IF;
END $$;

DO $$
DECLARE
    v_defendant_id UUID;
    v_feature_id UUID;
    v_failed BOOLEAN := FALSE;
BEGIN
    SELECT dsf.defendant_id, dsf.feature_id
    INTO v_defendant_id, v_feature_id
    FROM defendant_statistical_features dsf
    LIMIT 1;

    BEGIN
        INSERT INTO defendant_statistical_features (defendant_id, feature_id)
        VALUES (v_defendant_id, v_feature_id);
    EXCEPTION
        WHEN unique_violation THEN
            v_failed := TRUE;
    END;

    IF v_failed IS FALSE THEN
        RAISE EXCEPTION 'Expected duplicate defendant feature insert to fail';
    END IF;
END $$;

ROLLBACK;
