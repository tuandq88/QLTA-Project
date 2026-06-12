-- Test: Excel appellate import must persist "Tòa án xét xử sơ thẩm".
-- Requires schema, dictionary seeds and database/seed/030_excel_seed_case_files.sql.

\set ON_ERROR_STOP on

DO $$
DECLARE
    v_appellate_count INTEGER;
    v_missing_first_instance_court INTEGER;
    v_unjoined_first_instance_court INTEGER;
    v_distinct_first_instance_court INTEGER;
    v_distinct_regional_court INTEGER;
    v_distinct_district_court INTEGER;
    v_same_as_current_court INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_appellate_count
    FROM case_files
    WHERE case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
       OR case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%';

    IF v_appellate_count <> 1127 THEN
        RAISE EXCEPTION 'Expected 1127 Excel appellate rows from two source files, got %', v_appellate_count;
    END IF;

    SELECT COUNT(*)
    INTO v_missing_first_instance_court
    FROM case_files
    WHERE (case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
        OR case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%')
      AND first_instance_court_id IS NULL;

    IF v_missing_first_instance_court <> 0 THEN
        RAISE EXCEPTION 'Excel appellate rows missing first_instance_court_id: %', v_missing_first_instance_court;
    END IF;

    SELECT COUNT(*)
    INTO v_unjoined_first_instance_court
    FROM case_files cf
    LEFT JOIN courts c ON c.court_id = cf.first_instance_court_id
    WHERE (cf.case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
        OR cf.case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%')
      AND c.court_id IS NULL;

    IF v_unjoined_first_instance_court <> 0 THEN
        RAISE EXCEPTION 'Excel appellate first_instance_court_id cannot join courts: %', v_unjoined_first_instance_court;
    END IF;

    SELECT
        COUNT(DISTINCT cf.first_instance_court_id),
        COUNT(DISTINCT cf.first_instance_court_id) FILTER (WHERE c.court_level = 'regional'),
        COUNT(DISTINCT cf.first_instance_court_id) FILTER (WHERE c.court_level = 'district')
    INTO v_distinct_first_instance_court, v_distinct_regional_court, v_distinct_district_court
    FROM case_files cf
    JOIN courts c ON c.court_id = cf.first_instance_court_id
    WHERE cf.case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
       OR cf.case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%';

    IF v_distinct_first_instance_court < 26 THEN
        RAISE EXCEPTION 'Expected at least 26 distinct Excel first-instance courts, got %',
            v_distinct_first_instance_court;
    END IF;

    IF v_distinct_regional_court < 11 THEN
        RAISE EXCEPTION 'Expected at least 11 regional first-instance courts from Excel, got %',
            v_distinct_regional_court;
    END IF;

    IF v_distinct_district_court < 15 THEN
        RAISE EXCEPTION 'Expected at least 15 district/old district first-instance courts from Excel, got %',
            v_distinct_district_court;
    END IF;

    SELECT COUNT(*)
    INTO v_same_as_current_court
    FROM case_files
    WHERE (case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
        OR case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%')
      AND first_instance_court_id = court_id;

    IF v_same_as_current_court <> 0 THEN
        RAISE EXCEPTION 'Excel appellate first-instance court must not be collapsed into current appellate court: %',
            v_same_as_current_court;
    END IF;

    RAISE NOTICE 'Excel appellate first-instance court import passed: rows=%, distinct_courts=%, regional=%, district=%',
        v_appellate_count, v_distinct_first_instance_court, v_distinct_regional_court, v_distinct_district_court;
END $$;
