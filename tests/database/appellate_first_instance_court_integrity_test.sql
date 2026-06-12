-- Test: appellate first-instance court metadata integrity.
-- Requires migration 009, seed 011 and seed test 060.

\set ON_ERROR_STOP on

DO $$
DECLARE
    v_test_case_count INTEGER;
    v_missing_first_instance_court INTEGER;
    v_unjoined_first_instance_court INTEGER;
    v_province_as_first_instance INTEGER;
    v_regional_court_count INTEGER;
    v_test_group_count INTEGER;
    v_missing_warning_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_test_case_count
    FROM case_files
    WHERE case_code IN (
        'HSPT-FIRSTCOURT-001',
        'DSPT-FIRSTCOURT-001',
        'HCPT-FIRSTCOURT-001'
    )
      AND case_group = 'PHUC_THAM';

    IF v_test_case_count <> 3 THEN
        RAISE EXCEPTION 'Expected 3 appellate first-court test cases, got %', v_test_case_count;
    END IF;

    SELECT COUNT(*)
    INTO v_missing_first_instance_court
    FROM case_files
    WHERE case_code IN (
        'HSPT-FIRSTCOURT-001',
        'DSPT-FIRSTCOURT-001',
        'HCPT-FIRSTCOURT-001'
    )
      AND first_instance_court_id IS NULL;

    IF v_missing_first_instance_court <> 0 THEN
        RAISE EXCEPTION 'Test appellate cases missing first_instance_court_id: %', v_missing_first_instance_court;
    END IF;

    SELECT COUNT(*)
    INTO v_unjoined_first_instance_court
    FROM case_files cf
    LEFT JOIN courts c ON c.court_id = cf.first_instance_court_id
    WHERE cf.case_code IN (
        'HSPT-FIRSTCOURT-001',
        'DSPT-FIRSTCOURT-001',
        'HCPT-FIRSTCOURT-001'
    )
      AND c.court_id IS NULL;

    IF v_unjoined_first_instance_court <> 0 THEN
        RAISE EXCEPTION 'first_instance_court_id does not join courts: %', v_unjoined_first_instance_court;
    END IF;

    SELECT COUNT(*)
    INTO v_province_as_first_instance
    FROM case_files cf
    JOIN courts current_court ON current_court.court_id = cf.court_id
    JOIN courts first_court ON first_court.court_id = cf.first_instance_court_id
    WHERE cf.case_code IN (
        'HSPT-FIRSTCOURT-001',
        'DSPT-FIRSTCOURT-001',
        'HCPT-FIRSTCOURT-001'
    )
      AND current_court.court_code = 'TAND_QUANG_NGAI_PROVINCE'
      AND first_court.court_code = 'TAND_QUANG_NGAI_PROVINCE';

    IF v_province_as_first_instance <> 0 THEN
        RAISE EXCEPTION 'Province court must not be used as first-instance court for test appellate cases: %', v_province_as_first_instance;
    END IF;

    SELECT COUNT(*)
    INTO v_regional_court_count
    FROM courts
    WHERE court_code IN (
        'TAND_KHU_VUC_01_QUANG_NGAI',
        'TAND_KHU_VUC_02_QUANG_NGAI',
        'TAND_KHU_VUC_03_QUANG_NGAI'
    )
      AND court_level = 'regional';

    IF v_regional_court_count <> 3 THEN
        RAISE EXCEPTION 'Expected 3 regional placeholder courts, got %', v_regional_court_count;
    END IF;

    SELECT COUNT(DISTINCT cf.first_instance_court_id)
    INTO v_test_group_count
    FROM case_files cf
    WHERE cf.case_code IN (
        'HSPT-FIRSTCOURT-001',
        'DSPT-FIRSTCOURT-001',
        'HCPT-FIRSTCOURT-001'
    );

    IF v_test_group_count < 3 THEN
        RAISE EXCEPTION 'Expected at least 3 first-instance court groups, got %', v_test_group_count;
    END IF;

    SELECT COUNT(*)
    INTO v_missing_warning_count
    FROM case_files cf
    LEFT JOIN courts c ON c.court_id = cf.first_instance_court_id
    WHERE cf.case_group = 'PHUC_THAM'
      AND (cf.first_instance_court_id IS NULL OR c.court_id IS NULL);

    RAISE NOTICE 'Appellate first-instance court integrity passed. Missing/invalid first-instance court rows currently requiring warning: %',
        v_missing_warning_count;
END $$;
