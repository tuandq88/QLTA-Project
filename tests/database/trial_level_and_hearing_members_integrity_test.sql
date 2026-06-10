\set ON_ERROR_STOP on

-- Kiem tra tach cap xet xu khoi loai an/giai doan/thu tuc
-- va kiem tra seed thanh phan phien toa tu Excel.

BEGIN;

DO $$
DECLARE
    v_count integer;
BEGIN
    IF to_regclass('public.court_staff') IS NULL THEN
        RAISE EXCEPTION 'Thieu bang court_staff';
    END IF;
    IF to_regclass('public.case_hearing_members') IS NULL THEN
        RAISE EXCEPTION 'Thieu bang case_hearing_members';
    END IF;

    SELECT count(*)
    INTO v_count
    FROM dm_categories c
    JOIN dm_category_items i ON i.category_id = c.category_id
    WHERE c.category_code = 'case_group'
      AND i.item_code IN ('SO_THAM', 'PHUC_THAM');
    IF v_count <> 2 THEN
        RAISE EXCEPTION 'Danh muc case_group thieu SO_THAM/PHUC_THAM. Found %', v_count;
    END IF;

    SELECT count(*)
    INTO v_count
    FROM dm_categories c
    JOIN dm_category_items i ON i.category_id = c.category_id
    WHERE c.category_code = 'hearing_member_role'
      AND i.item_code IN ('PRESIDING_JUDGE', 'PANEL_JUDGE', 'HEARING_CLERK');
    IF v_count <> 3 THEN
        RAISE EXCEPTION 'Danh muc hearing_member_role thieu role bat buoc. Found %', v_count;
    END IF;
END $$;

DO $$
DECLARE
    v_missing integer;
    v_bad integer;
BEGIN
    SELECT count(*)
    INTO v_missing
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%'
      AND (case_group IS NULL OR case_group_id IS NULL);
    IF v_missing > 0 THEN
        RAISE EXCEPTION 'Ho so Excel thieu case_group/case_group_id: %', v_missing;
    END IF;

    SELECT count(*)
    INTO v_bad
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%'
      AND case_group NOT IN ('SO_THAM', 'PHUC_THAM');
    IF v_bad > 0 THEN
        RAISE EXCEPTION 'Ho so Excel co case_group khong phai cap xet xu: %', v_bad;
    END IF;

    SELECT count(*)
    INTO v_bad
    FROM case_files
    WHERE case_code LIKE 'EXCEL-%'
      AND (
          upper(coalesce(case_type::text, '')) IN ('SO_THAM', 'PHUC_THAM')
          OR upper(coalesce(procedure_law, '')) IN ('SO_THAM', 'PHUC_THAM')
          OR upper(coalesce(current_stage, '')) IN ('SO_THAM', 'PHUC_THAM')
      );
    IF v_bad > 0 THEN
        RAISE EXCEPTION 'Cap xet xu bi ghi sai vao case_type/procedure_law/current_stage: %', v_bad;
    END IF;
END $$;

DO $$
DECLARE
    v_staff integer;
    v_members integer;
    v_orphan integer;
    v_bad_role integer;
    v_duplicate integer;
    v_bad_presiding integer;
BEGIN
    SELECT count(*) INTO v_staff FROM court_staff;
    IF v_staff <= 0 THEN
        RAISE EXCEPTION 'court_staff khong co du lieu';
    END IF;

    SELECT count(*)
    INTO v_members
    FROM case_hearing_members chm
    JOIN case_files cf ON cf.case_id = chm.case_id
    WHERE cf.case_code LIKE 'EXCEL-%';
    IF v_members <= 0 THEN
        RAISE EXCEPTION 'case_hearing_members khong co du lieu Excel';
    END IF;

    SELECT count(*)
    INTO v_orphan
    FROM case_hearing_members chm
    LEFT JOIN case_files cf ON cf.case_id = chm.case_id
    LEFT JOIN court_staff cs ON cs.staff_id = chm.staff_id
    WHERE cf.case_id IS NULL OR cs.staff_id IS NULL;
    IF v_orphan > 0 THEN
        RAISE EXCEPTION 'case_hearing_members co orphan: %', v_orphan;
    END IF;

    SELECT count(*)
    INTO v_bad_role
    FROM case_hearing_members
    WHERE role_code NOT IN ('PRESIDING_JUDGE', 'PANEL_JUDGE', 'HEARING_CLERK');
    IF v_bad_role > 0 THEN
        RAISE EXCEPTION 'case_hearing_members co role_code khong hop le: %', v_bad_role;
    END IF;

    SELECT count(*)
    INTO v_duplicate
    FROM (
        SELECT case_id, staff_id, role_code
        FROM case_hearing_members
        GROUP BY case_id, staff_id, role_code
        HAVING count(*) > 1
    ) duplicated;
    IF v_duplicate > 0 THEN
        RAISE EXCEPTION 'case_hearing_members co dong trung case/staff/role: %', v_duplicate;
    END IF;

    SELECT count(*)
    INTO v_bad_presiding
    FROM (
        SELECT cf.case_id
        FROM case_files cf
        LEFT JOIN case_hearing_members chm
          ON chm.case_id = cf.case_id
         AND chm.role_code = 'PRESIDING_JUDGE'
        WHERE cf.case_code LIKE 'EXCEL-%'
        GROUP BY cf.case_id
        HAVING count(chm.case_hearing_member_id) <> 1
    ) bad;
    IF v_bad_presiding > 0 THEN
        RAISE EXCEPTION 'Ho so Excel khong co dung 1 chu toa/tham phan: %', v_bad_presiding;
    END IF;
END $$;

DO $$
DECLARE
    v_missing_clerk integer;
    v_bad_first_panel integer;
    v_bad_appeal_panel integer;
BEGIN
    SELECT count(*)
    INTO v_missing_clerk
    FROM (
        SELECT cf.case_id
        FROM case_files cf
        LEFT JOIN case_hearing_members chm
          ON chm.case_id = cf.case_id
         AND chm.role_code = 'HEARING_CLERK'
        WHERE cf.case_code LIKE 'EXCEL-%'
        GROUP BY cf.case_id
        HAVING count(chm.case_hearing_member_id) = 0
    ) bad;

    SELECT count(*)
    INTO v_bad_first_panel
    FROM (
        SELECT cf.case_id
        FROM case_files cf
        LEFT JOIN case_hearing_members chm
          ON chm.case_id = cf.case_id
         AND chm.role_code = 'PANEL_JUDGE'
        WHERE cf.case_code LIKE 'EXCEL-%'
          AND cf.case_group = 'SO_THAM'
        GROUP BY cf.case_id
        HAVING count(chm.case_hearing_member_id) > 1
    ) bad;

    SELECT count(*)
    INTO v_bad_appeal_panel
    FROM (
        SELECT cf.case_id
        FROM case_files cf
        LEFT JOIN case_hearing_members chm
          ON chm.case_id = cf.case_id
         AND chm.role_code = 'PANEL_JUDGE'
        WHERE cf.case_code LIKE 'EXCEL-%'
          AND cf.case_group = 'PHUC_THAM'
        GROUP BY cf.case_id
        HAVING count(chm.case_hearing_member_id) <> 2
    ) bad;

    RAISE NOTICE 'CANH BAO DU LIEU NGUON: ho so Excel thieu thu ky: %', coalesce(v_missing_clerk, 0);
    RAISE NOTICE 'CANH BAO DU LIEU NGUON: so tham co hon 1 PANEL_JUDGE: %', coalesce(v_bad_first_panel, 0);
    RAISE NOTICE 'CANH BAO DU LIEU NGUON: phuc tham khong co dung 2 PANEL_JUDGE: %', coalesce(v_bad_appeal_panel, 0);
    RAISE NOTICE 'Chi tiet file/sheet/row nam trong tests/database/EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT.md';
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: trial_level_and_hearing_members_integrity_test.sql';
END $$;
