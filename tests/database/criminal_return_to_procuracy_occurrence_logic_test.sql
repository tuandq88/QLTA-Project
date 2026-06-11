\set ON_ERROR_STOP on

-- Kiem tra logic occurrence cho nghiep vu hinh su so tham tra ho so cho VKS
-- de dieu tra bo sung. Test dung bang tam de bao ve quy tac thong ke,
-- khong yeu cau schema hien tai da co case_occurrences/case_resolution_events.

BEGIN;

CREATE TEMP TABLE sample_case_files (
    case_id uuid PRIMARY KEY,
    case_code text NOT NULL,
    case_number text NOT NULL,
    case_type text NOT NULL,
    case_group text NOT NULL
) ON COMMIT DROP;

CREATE TEMP TABLE sample_case_occurrences (
    occurrence_id uuid PRIMARY KEY,
    case_id uuid NOT NULL REFERENCES sample_case_files(case_id),
    occurrence_no integer NOT NULL,
    acceptance_date date NOT NULL,
    acceptance_type_code text NOT NULL,
    previous_occurrence_id uuid,
    UNIQUE (case_id, occurrence_no)
) ON COMMIT DROP;

CREATE TEMP TABLE sample_case_resolution_events (
    event_id uuid PRIMARY KEY,
    case_id uuid NOT NULL REFERENCES sample_case_files(case_id),
    occurrence_id uuid NOT NULL REFERENCES sample_case_occurrences(occurrence_id),
    event_type_code text NOT NULL,
    event_date date NOT NULL,
    decision_number text,
    resolution_type_code text NOT NULL,
    return_to_agency_code text,
    reason text,
    counted_as_resolved boolean NOT NULL DEFAULT false
) ON COMMIT DROP;

INSERT INTO sample_case_files (case_id, case_code, case_number, case_type, case_group)
VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'CASE-A',
    '01/2026/TLST-HS',
    'HINH_SU',
    'SO_THAM'
);

INSERT INTO sample_case_occurrences (
    occurrence_id, case_id, occurrence_no, acceptance_date, acceptance_type_code, previous_occurrence_id
)
VALUES
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        1,
        DATE '2026-03-10',
        'INITIAL_ACCEPTANCE',
        NULL
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        2,
        DATE '2026-05-05',
        'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1'
    );

INSERT INTO sample_case_resolution_events (
    event_id, case_id, occurrence_id, event_type_code, event_date, decision_number,
    resolution_type_code, return_to_agency_code, reason, counted_as_resolved
)
VALUES
    (
        'cccccccc-cccc-cccc-cccc-ccccccccccc1',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'RESOLUTION',
        DATE '2026-04-15',
        '01/2026/QD-TA',
        'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION',
        'PROCURACY',
        'Can dieu tra bo sung',
        TRUE
    ),
    (
        'cccccccc-cccc-cccc-cccc-ccccccccccc2',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'RESOLUTION',
        DATE '2026-06-20',
        '01/2026/HS-ST',
        'TRIAL_JUDGMENT',
        NULL,
        'Xet xu ra ban an',
        TRUE
    );

DO $$
DECLARE
    v_accepted integer;
    v_resolved integer;
    v_remaining integer;
    v_return_list integer;
    v_distinct_case_accepted integer;
BEGIN
    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-06-30' AS to_date
    ),
    base AS (
        SELECT co.*
        FROM sample_case_occurrences co
        JOIN sample_case_files cf ON cf.case_id = co.case_id
        WHERE cf.case_type = 'HINH_SU'
          AND cf.case_group = 'SO_THAM'
    )
    SELECT
        count(*) FILTER (WHERE acceptance_date BETWEEN p.from_date AND p.to_date),
        count(DISTINCT case_id) FILTER (WHERE acceptance_date BETWEEN p.from_date AND p.to_date)
    INTO v_accepted, v_distinct_case_accepted
    FROM base CROSS JOIN params p;

    IF v_accepted <> 2 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-06-30 accepted_count phai bang 2 occurrence, found %', v_accepted;
    END IF;
    IF v_distinct_case_accepted = v_accepted THEN
        RAISE EXCEPTION 'Test khong chung minh duoc case_id khac occurrence';
    END IF;

    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-06-30' AS to_date
    )
    SELECT count(*)
    INTO v_resolved
    FROM sample_case_resolution_events cre
    JOIN sample_case_files cf ON cf.case_id = cre.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND cre.counted_as_resolved IS TRUE
      AND cre.event_date BETWEEN p.from_date AND p.to_date;

    IF v_resolved <> 2 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-06-30 resolved_count phai bang 2, found %', v_resolved;
    END IF;

    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-06-30' AS to_date
    )
    SELECT count(*)
    INTO v_remaining
    FROM sample_case_occurrences co
    JOIN sample_case_files cf ON cf.case_id = co.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND co.acceptance_date <= p.to_date
      AND NOT EXISTS (
          SELECT 1
          FROM sample_case_resolution_events cre
          WHERE cre.occurrence_id = co.occurrence_id
            AND cre.counted_as_resolved IS TRUE
            AND cre.event_date <= p.to_date
      );

    IF v_remaining <> 0 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-06-30 remaining_count phai bang 0, found %', v_remaining;
    END IF;

    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-06-30' AS to_date
    )
    SELECT count(*)
    INTO v_return_list
    FROM sample_case_resolution_events cre
    JOIN sample_case_files cf ON cf.case_id = cre.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND cre.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
      AND cre.counted_as_resolved IS TRUE
      AND cre.event_date BETWEEN p.from_date AND p.to_date;

    IF v_return_list <> 1 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-06-30 return_to_procuracy_list_count phai bang 1, found %', v_return_list;
    END IF;
END $$;

DO $$
DECLARE
    v_accepted integer;
    v_resolved integer;
    v_remaining integer;
    v_return_list integer;
BEGIN
    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-05-31' AS to_date
    )
    SELECT count(*)
    INTO v_accepted
    FROM sample_case_occurrences co
    JOIN sample_case_files cf ON cf.case_id = co.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND co.acceptance_date BETWEEN p.from_date AND p.to_date;

    IF v_accepted <> 2 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-05-31 accepted_count phai bang 2 occurrence, found %', v_accepted;
    END IF;

    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-05-31' AS to_date
    )
    SELECT count(*)
    INTO v_resolved
    FROM sample_case_resolution_events cre
    JOIN sample_case_files cf ON cf.case_id = cre.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND cre.counted_as_resolved IS TRUE
      AND cre.event_date BETWEEN p.from_date AND p.to_date;

    IF v_resolved <> 1 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-05-31 resolved_count phai bang 1, found %', v_resolved;
    END IF;

    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-05-31' AS to_date
    )
    SELECT count(*)
    INTO v_remaining
    FROM sample_case_occurrences co
    JOIN sample_case_files cf ON cf.case_id = co.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND co.acceptance_date <= p.to_date
      AND NOT EXISTS (
          SELECT 1
          FROM sample_case_resolution_events cre
          WHERE cre.occurrence_id = co.occurrence_id
            AND cre.counted_as_resolved IS TRUE
            AND cre.event_date <= p.to_date
      );

    IF v_remaining <> 1 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-05-31 remaining_count phai bang 1, found %', v_remaining;
    END IF;

    WITH params AS (
        SELECT DATE '2026-03-01' AS from_date, DATE '2026-05-31' AS to_date
    )
    SELECT count(*)
    INTO v_return_list
    FROM sample_case_resolution_events cre
    JOIN sample_case_files cf ON cf.case_id = cre.case_id
    CROSS JOIN params p
    WHERE cf.case_type = 'HINH_SU'
      AND cf.case_group = 'SO_THAM'
      AND cre.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
      AND cre.counted_as_resolved IS TRUE
      AND cre.event_date BETWEEN p.from_date AND p.to_date;

    IF v_return_list <> 1 THEN
        RAISE EXCEPTION 'Ky 2026-03-01..2026-05-31 return_to_procuracy_list_count phai bang 1, found %', v_return_list;
    END IF;
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: criminal_return_to_procuracy_occurrence_logic_test.sql';
END $$;
