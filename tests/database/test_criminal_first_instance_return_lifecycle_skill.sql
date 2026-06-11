-- Test: criminal first-instance return-to-Procuracy lifecycle statistics.
-- Requires database/migrations/007_case_occurrences_and_resolution_events.sql
-- and database/seed/test/040_test_criminal_first_instance_return_lifecycle.sql.

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS tmp_return_periods;
CREATE TEMP TABLE tmp_return_periods (
    period_code TEXT PRIMARY KEY,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    expected_accepted INTEGER NOT NULL,
    expected_resolved INTEGER NOT NULL,
    expected_return INTEGER NOT NULL,
    expected_judgment INTEGER NOT NULL,
    expected_remaining INTEGER NOT NULL
);

INSERT INTO tmp_return_periods (
    period_code,
    from_date,
    to_date,
    expected_accepted,
    expected_resolved,
    expected_return,
    expected_judgment,
    expected_remaining
)
VALUES
    ('A', DATE '2026-03-01', DATE '2026-05-31', 6, 4, 4, 0, 2),
    ('B', DATE '2026-03-01', DATE '2026-06-30', 8, 6, 4, 2, 2),
    ('C', DATE '2026-06-01', DATE '2026-06-30', 2, 2, 0, 2, 2),
    ('D', DATE '2026-01-01', DATE '2026-12-31', 10, 9, 7, 2, 1),
    ('E', DATE '2026-07-01', DATE '2026-07-31', 0, 1, 1, 0, 1);

DROP TABLE IF EXISTS tmp_return_cases;
CREATE TEMP TABLE tmp_return_cases AS
SELECT cf.case_id, cf.case_code, cf.case_number
FROM case_files cf
WHERE cf.case_type = 'criminal'
  AND cf.case_group = 'SO_THAM'
  AND cf.case_code LIKE 'HSST-RETURN-%';

DROP TABLE IF EXISTS tmp_return_actual_summary;
CREATE TEMP TABLE tmp_return_actual_summary AS
SELECT
    p.period_code,
    p.from_date,
    p.to_date,
    p.expected_accepted,
    p.expected_resolved,
    p.expected_return,
    p.expected_judgment,
    p.expected_remaining,
    (
        SELECT COUNT(*)
        FROM case_occurrences co
        JOIN tmp_return_cases c ON c.case_id = co.case_id
        WHERE co.acceptance_date BETWEEN p.from_date AND p.to_date
    ) AS actual_accepted,
    (
        SELECT COUNT(*)
        FROM case_resolution_events re
        JOIN tmp_return_cases c ON c.case_id = re.case_id
        WHERE re.counted_as_resolved IS TRUE
          AND re.event_date BETWEEN p.from_date AND p.to_date
    ) AS actual_resolved,
    (
        SELECT COUNT(*)
        FROM case_resolution_events re
        JOIN tmp_return_cases c ON c.case_id = re.case_id
        WHERE re.counted_as_resolved IS TRUE
          AND re.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
          AND re.event_date BETWEEN p.from_date AND p.to_date
    ) AS actual_return,
    (
        SELECT COUNT(*)
        FROM case_resolution_events re
        JOIN tmp_return_cases c ON c.case_id = re.case_id
        WHERE re.counted_as_resolved IS TRUE
          AND re.resolution_type_code = 'TRIAL_JUDGMENT'
          AND re.event_date BETWEEN p.from_date AND p.to_date
    ) AS actual_judgment,
    (
        SELECT COUNT(*)
        FROM case_occurrences co
        JOIN tmp_return_cases c ON c.case_id = co.case_id
        WHERE co.acceptance_date <= p.to_date
          AND NOT EXISTS (
              SELECT 1
              FROM case_resolution_events re
              WHERE re.occurrence_id = co.occurrence_id
                AND re.counted_as_resolved IS TRUE
                AND re.event_date <= p.to_date
          )
    ) AS actual_remaining
FROM tmp_return_periods p;

DO $$
DECLARE
    mismatch RECORD;
    v_total_returns INTEGER;
    v_distinct_return_cases INTEGER;
    v_open_occurrence_count INTEGER;
BEGIN
    SELECT *
    INTO mismatch
    FROM tmp_return_actual_summary
    WHERE expected_accepted <> actual_accepted
       OR expected_resolved <> actual_resolved
       OR expected_return <> actual_return
       OR expected_judgment <> actual_judgment
       OR expected_remaining <> actual_remaining
    ORDER BY period_code
    LIMIT 1;

    IF FOUND THEN
        RAISE EXCEPTION
            'Mismatch period %, expected acc/res/return/judgment/rem = %/%/%/%/%, actual = %/%/%/%/%',
            mismatch.period_code,
            mismatch.expected_accepted,
            mismatch.expected_resolved,
            mismatch.expected_return,
            mismatch.expected_judgment,
            mismatch.expected_remaining,
            mismatch.actual_accepted,
            mismatch.actual_resolved,
            mismatch.actual_return,
            mismatch.actual_judgment,
            mismatch.actual_remaining;
    END IF;

    SELECT COUNT(*), COUNT(DISTINCT re.case_id)
    INTO v_total_returns, v_distinct_return_cases
    FROM case_resolution_events re
    JOIN tmp_return_cases c ON c.case_id = re.case_id
    WHERE re.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
      AND re.event_date BETWEEN DATE '2026-01-01' AND DATE '2026-12-31';

    IF v_total_returns <> 7 OR v_distinct_return_cases <> 4 THEN
        RAISE EXCEPTION 'Return event count must be occurrence-based: total %, distinct cases %',
            v_total_returns, v_distinct_return_cases;
    END IF;

    SELECT COUNT(*)
    INTO v_open_occurrence_count
    FROM case_occurrences co
    JOIN case_files cf ON cf.case_id = co.case_id
    WHERE cf.case_code = 'HSST-RETURN-003'
      AND co.occurrence_no = 4
      AND co.acceptance_date = DATE '2026-06-12'
      AND NOT EXISTS (
          SELECT 1
          FROM case_resolution_events re
          WHERE re.occurrence_id = co.occurrence_id
            AND re.counted_as_resolved IS TRUE
            AND re.event_date <= DATE '2026-12-31'
      );

    IF v_open_occurrence_count <> 1 THEN
        RAISE EXCEPTION 'HSST-RETURN-003 occurrence 4 must remain open through 2026.';
    END IF;
END $$;

SELECT
    'SUMMARY_EXPECTED_ACTUAL' AS section,
    period_code,
    from_date,
    to_date,
    expected_accepted,
    actual_accepted,
    expected_resolved,
    actual_resolved,
    expected_return,
    actual_return,
    expected_judgment,
    actual_judgment,
    expected_remaining,
    actual_remaining
FROM tmp_return_actual_summary
ORDER BY period_code;

SELECT
    'ACCEPTED_BY_PERIOD' AS section,
    p.period_code,
    c.case_code,
    co.occurrence_no,
    co.acceptance_date,
    co.acceptance_type_code
FROM tmp_return_periods p
JOIN case_occurrences co
    ON co.acceptance_date BETWEEN p.from_date AND p.to_date
JOIN tmp_return_cases c ON c.case_id = co.case_id
ORDER BY p.period_code, co.acceptance_date, c.case_code, co.occurrence_no;

SELECT
    'RESOLVED_BY_PERIOD' AS section,
    p.period_code,
    c.case_code,
    co.occurrence_no,
    re.event_date,
    re.resolution_type_code,
    COALESCE(re.return_to_agency_code, '') AS return_to_agency_code,
    re.decision_number
FROM tmp_return_periods p
JOIN case_resolution_events re
    ON re.counted_as_resolved IS TRUE
   AND re.event_date BETWEEN p.from_date AND p.to_date
JOIN tmp_return_cases c ON c.case_id = re.case_id
JOIN case_occurrences co ON co.occurrence_id = re.occurrence_id
ORDER BY p.period_code, re.event_date, c.case_code, co.occurrence_no;

SELECT
    'RETURN_TO_PROCURACY_BY_PERIOD' AS section,
    p.period_code,
    c.case_code,
    co.occurrence_no,
    re.event_date,
    re.resolution_type_code,
    re.return_to_agency_code,
    re.decision_number
FROM tmp_return_periods p
JOIN case_resolution_events re
    ON re.counted_as_resolved IS TRUE
   AND re.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
   AND re.event_date BETWEEN p.from_date AND p.to_date
JOIN tmp_return_cases c ON c.case_id = re.case_id
JOIN case_occurrences co ON co.occurrence_id = re.occurrence_id
ORDER BY p.period_code, re.event_date, c.case_code, co.occurrence_no;

SELECT
    'ACCEPTED_OCCURRENCES' AS section,
    c.case_code,
    co.occurrence_no,
    co.acceptance_date,
    co.acceptance_type_code
FROM case_occurrences co
JOIN tmp_return_cases c ON c.case_id = co.case_id
ORDER BY c.case_code, co.occurrence_no;

SELECT
    'RESOLUTION_EVENTS' AS section,
    c.case_code,
    co.occurrence_no,
    re.event_date,
    re.resolution_type_code,
    COALESCE(re.return_to_agency_code, '') AS return_to_agency_code,
    re.decision_number
FROM case_resolution_events re
JOIN tmp_return_cases c ON c.case_id = re.case_id
JOIN case_occurrences co ON co.occurrence_id = re.occurrence_id
ORDER BY c.case_code, co.occurrence_no, re.event_date;

SELECT
    'REMAINING_BY_PERIOD' AS section,
    p.period_code,
    c.case_code,
    co.occurrence_no,
    co.acceptance_date,
    co.acceptance_type_code
FROM tmp_return_periods p
JOIN case_occurrences co ON co.acceptance_date <= p.to_date
JOIN tmp_return_cases c ON c.case_id = co.case_id
WHERE NOT EXISTS (
    SELECT 1
    FROM case_resolution_events re
    WHERE re.occurrence_id = co.occurrence_id
      AND re.counted_as_resolved IS TRUE
      AND re.event_date <= p.to_date
)
ORDER BY p.period_code, c.case_code, co.occurrence_no;

SELECT 'PASS' AS result, 'criminal first-instance return lifecycle occurrence skill test' AS test_name;
