\set ON_ERROR_STOP on

-- Kiem tra seed day du tu Excel: case_files + detail + bang lien quan.

BEGIN;

DO $$
DECLARE
    v_total integer;
    v_missing_detail integer;
BEGIN
    SELECT count(*) INTO v_total FROM case_files WHERE case_code LIKE 'EXCEL-%';
    IF v_total <> 2309 THEN
        RAISE EXCEPTION 'Tong ho so Excel khong khop. Expected 2309, found %', v_total;
    END IF;

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
        RAISE EXCEPTION 'Co ho so Excel khong co detail: %', v_missing_detail;
    END IF;
END $$;

DO $$
DECLARE
    v_count integer;
BEGIN
    SELECT count(*) INTO v_count
    FROM civil_case_details d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'civil_case_details trong'; END IF;

    SELECT count(*) INTO v_count
    FROM administrative_case_details d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'administrative_case_details trong'; END IF;

    SELECT count(*) INTO v_count
    FROM criminal_case_details d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'criminal_case_details trong'; END IF;

    SELECT count(*) INTO v_count
    FROM participants p
    JOIN case_files cf ON cf.case_id = p.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'participants trong'; END IF;

    SELECT count(*) INTO v_count
    FROM decisions d
    JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'decisions trong'; END IF;

    SELECT count(*) INTO v_count
    FROM appeals a
    JOIN case_files cf ON cf.case_id = a.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'appeals trong'; END IF;

    SELECT count(*) INTO v_count
    FROM appellate_trackings t
    JOIN case_files cf ON cf.case_id = t.original_case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_count <= 0 THEN RAISE EXCEPTION 'appellate_trackings trong'; END IF;
END $$;

DO $$
DECLARE
    v_orphan integer;
BEGIN
    SELECT count(*) INTO v_orphan
    FROM civil_case_details d
    LEFT JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_id IS NULL;
    IF v_orphan > 0 THEN RAISE EXCEPTION 'civil_case_details orphan: %', v_orphan; END IF;

    SELECT count(*) INTO v_orphan
    FROM administrative_case_details d
    LEFT JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_id IS NULL;
    IF v_orphan > 0 THEN RAISE EXCEPTION 'administrative_case_details orphan: %', v_orphan; END IF;

    SELECT count(*) INTO v_orphan
    FROM criminal_case_details d
    LEFT JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_id IS NULL;
    IF v_orphan > 0 THEN RAISE EXCEPTION 'criminal_case_details orphan: %', v_orphan; END IF;

    SELECT count(*) INTO v_orphan
    FROM participants p
    LEFT JOIN case_files cf ON cf.case_id = p.case_id
    WHERE cf.case_id IS NULL;
    IF v_orphan > 0 THEN RAISE EXCEPTION 'participants orphan: %', v_orphan; END IF;

    SELECT count(*) INTO v_orphan
    FROM decisions d
    LEFT JOIN case_files cf ON cf.case_id = d.case_id
    WHERE cf.case_id IS NULL;
    IF v_orphan > 0 THEN RAISE EXCEPTION 'decisions orphan: %', v_orphan; END IF;
END $$;

DO $$
DECLARE
    v_total integer;
    v_resolved integer;
    v_pending integer;
    v_detail_total integer;
BEGIN
    SELECT count(*),
           count(*) FILTER (WHERE case_status IN ('resolved', 'effective', 'closed')),
           count(*) FILTER (WHERE case_status NOT IN ('resolved', 'effective', 'closed'))
    INTO v_total, v_resolved, v_pending
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%';

    IF v_total <> v_resolved + v_pending THEN
        RAISE EXCEPTION 'Thong ke tong/resolved/pending khong khop: total %, resolved %, pending %', v_total, v_resolved, v_pending;
    END IF;

    SELECT
        (SELECT count(*) FROM civil_case_details d JOIN case_files cf ON cf.case_id = d.case_id WHERE cf.case_code LIKE 'EXCEL-%')
      + (SELECT count(*) FROM administrative_case_details d JOIN case_files cf ON cf.case_id = d.case_id WHERE cf.case_code LIKE 'EXCEL-%')
      + (SELECT count(*) FROM criminal_case_details d JOIN case_files cf ON cf.case_id = d.case_id WHERE cf.case_code LIKE 'EXCEL-%')
    INTO v_detail_total;

    IF v_detail_total <> v_total THEN
        RAISE EXCEPTION 'Tong detail khong bang tong case_files Excel: detail %, case_files %', v_detail_total, v_total;
    END IF;
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: excel_case_full_import_integrity_test.sql';
END $$;
