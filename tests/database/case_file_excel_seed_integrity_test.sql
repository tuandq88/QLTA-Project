\set ON_ERROR_STOP on

-- Test seed ho so vu an mau doc tu Excel trong database/seed/danh_sach.
-- Seed 030 phai chay sau seed danh muc 003 va 020-025.

BEGIN;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM courts
    WHERE court_code = 'EXCEL_SEED_TAND_QNG';

    IF v_count <> 1 THEN
        RAISE EXCEPTION 'Thieu court ky thuat EXCEL_SEED_TAND_QNG hoac bi nhan ban: %', v_count;
    END IF;

    SELECT count(*)
    INTO v_count
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%';

    IF v_count <> 2309 THEN
        RAISE EXCEPTION 'So dong case_files seed tu Excel khong khop. Expected 2309, found %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM (
        SELECT case_code
        FROM case_files
        WHERE case_code LIKE 'EXCEL-%'
        GROUP BY case_code
        HAVING count(*) > 1
    ) d;

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Co case_code Excel bi trung: %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM case_files cf
    LEFT JOIN courts c ON c.court_id = cf.court_id
    WHERE cf.case_code LIKE 'EXCEL-%'
      AND c.court_id IS NULL;

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Co case_files Excel orphan court_id: %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%'
      AND (
          case_type_id IS NULL
          OR case_status_id IS NULL
          OR case_group_id IS NULL
          OR procedure_law_id IS NULL
          OR current_stage_id IS NULL
      );

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Co case_files Excel chua map du FK dm_category_items bat buoc cho seed: %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%'
      AND acceptance_date IS NOT NULL
      AND filing_date IS NOT NULL
      AND acceptance_date < filing_date;

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Co case_files Excel sai logic ngay nop/thu ly: %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%'
      AND (summary IS NULL OR summary NOT LIKE 'Nguồn Excel:%');

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Co case_files Excel thieu source marker trong summary: %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_missing_detail integer;
BEGIN
    SELECT count(*)
    INTO v_missing_detail
    FROM case_files cf
    LEFT JOIN civil_case_details civil ON civil.case_id = cf.case_id
    LEFT JOIN administrative_case_details admin_detail ON admin_detail.case_id = cf.case_id
    LEFT JOIN criminal_case_details criminal ON criminal.case_id = cf.case_id
    WHERE cf.case_code LIKE 'EXCEL-%'
      AND civil.case_id IS NULL
      AND admin_detail.case_id IS NULL
      AND criminal.case_id IS NULL;

    IF v_missing_detail > 0 THEN
        RAISE EXCEPTION 'Co case_files Excel chua co detail tuong ung: %', v_missing_detail;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*)
    INTO v_count
    FROM civil_case_details d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';

    IF v_count <= 0 THEN
        RAISE EXCEPTION 'civil_case_details phai co du lieu seed tu Excel';
    END IF;

    SELECT count(*)
    INTO v_count
    FROM administrative_case_details d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';

    IF v_count <= 0 THEN
        RAISE EXCEPTION 'administrative_case_details phai co du lieu seed tu Excel';
    END IF;

    SELECT count(*)
    INTO v_count
    FROM criminal_case_details d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';

    IF v_count <= 0 THEN
        RAISE EXCEPTION 'criminal_case_details phai co du lieu seed tu Excel';
    END IF;
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: case_file_excel_seed_integrity_test.sql';
END $$;
