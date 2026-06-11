-- Test: criminal appellate defendant-level result statistics.
-- Requires database/migrations/008_criminal_appellate_defendant_results.sql
-- and database/seed/test/050_test_criminal_appellate_defendant_results.sql.

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS tmp_hspt_periods;
CREATE TEMP TABLE tmp_hspt_periods (
    period_code TEXT PRIMARY KEY,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);

INSERT INTO tmp_hspt_periods (period_code, from_date, to_date)
VALUES
    ('A', DATE '2026-06-01', DATE '2026-06-10'),
    ('B', DATE '2026-06-01', DATE '2026-06-30'),
    ('C', DATE '2026-07-01', DATE '2026-07-31'),
    ('D', DATE '2026-06-01', DATE '2026-07-31');

DROP TABLE IF EXISTS tmp_hspt_cases;
CREATE TEMP TABLE tmp_hspt_cases AS
SELECT cf.case_id, cf.case_code, cf.case_number
FROM case_files cf
WHERE cf.case_type = 'criminal'
  AND cf.case_group = 'PHUC_THAM'
  AND cf.case_code LIKE 'HSPT-%';

DROP TABLE IF EXISTS tmp_hspt_defendants;
CREATE TEMP TABLE tmp_hspt_defendants AS
SELECT
    c.case_id,
    c.case_code,
    d.defendant_id,
    d.full_name
FROM tmp_hspt_cases c
JOIN criminal_case_details ccd ON ccd.case_id = c.case_id
JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id;

DROP TABLE IF EXISTS tmp_hspt_case_status;
CREATE TEMP TABLE tmp_hspt_case_status AS
SELECT
    p.period_code,
    p.from_date,
    p.to_date,
    d.case_id,
    d.case_code,
    COUNT(*) AS total_defendant_count,
    COUNT(r.appellate_result_id) FILTER (
        WHERE r.is_final_result IS TRUE
          AND r.result_date <= p.to_date
    ) AS defendant_resolved_count,
    COUNT(*) - COUNT(r.appellate_result_id) FILTER (
        WHERE r.is_final_result IS TRUE
          AND r.result_date <= p.to_date
    ) AS defendant_remaining_count,
    CASE
        WHEN COUNT(*) = COUNT(r.appellate_result_id) FILTER (
            WHERE r.is_final_result IS TRUE
              AND r.result_date <= p.to_date
        )
        THEN 1 ELSE 0
    END AS case_resolved_count,
    CASE
        WHEN COUNT(*) = COUNT(r.appellate_result_id) FILTER (
            WHERE r.is_final_result IS TRUE
              AND r.result_date <= p.to_date
        )
        THEN 0 ELSE 1
    END AS case_remaining_count
FROM tmp_hspt_periods p
JOIN tmp_hspt_defendants d ON TRUE
LEFT JOIN criminal_appellate_defendant_results r
    ON r.case_id = d.case_id
   AND r.defendant_id = d.defendant_id
   AND r.is_final_result IS TRUE
GROUP BY p.period_code, p.from_date, p.to_date, d.case_id, d.case_code;

DROP TABLE IF EXISTS tmp_hspt_case_result_counts;
CREATE TEMP TABLE tmp_hspt_case_result_counts AS
SELECT
    p.period_code,
    r.case_id,
    SUM(CASE WHEN r.result_group_code = 'TERMINATION' THEN 1 ELSE 0 END) AS termination_defendant_count,
    SUM(CASE WHEN r.result_type_code = 'WITHDRAWAL_BEFORE_HEARING' THEN 1 ELSE 0 END) AS termination_before_hearing_count,
    SUM(CASE WHEN r.result_group_code = 'TERMINATION' AND r.decision_stage_code = 'AT_HEARING' THEN 1 ELSE 0 END) AS termination_at_hearing_count,
    SUM(CASE WHEN r.result_type_code = 'UPHOLD_FIRST_INSTANCE' THEN 1 ELSE 0 END) AS uphold_defendant_count,
    SUM(CASE WHEN r.result_type_code IN ('MODIFY_FIRST_INSTANCE_SUBJECTIVE', 'MODIFY_FIRST_INSTANCE_OBJECTIVE') THEN 1 ELSE 0 END) AS modify_defendant_count,
    SUM(CASE WHEN r.result_type_code IN ('CANCEL_FIRST_INSTANCE_SUBJECTIVE', 'CANCEL_FIRST_INSTANCE_OBJECTIVE') THEN 1 ELSE 0 END) AS cancel_defendant_count
FROM tmp_hspt_periods p
JOIN criminal_appellate_defendant_results r
    ON r.is_final_result IS TRUE
   AND r.result_date BETWEEN p.from_date AND p.to_date
JOIN tmp_hspt_cases c ON c.case_id = r.case_id
GROUP BY p.period_code, r.case_id;

DROP TABLE IF EXISTS tmp_hspt_expected;
CREATE TEMP TABLE tmp_hspt_expected (
    check_name TEXT PRIMARY KEY,
    actual_value INTEGER NOT NULL,
    expected_value INTEGER NOT NULL
);

INSERT INTO tmp_hspt_expected (check_name, actual_value, expected_value)
SELECT 'A_HSPT_001_defendant_resolved_count', defendant_resolved_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'A' AND case_code = 'HSPT-001'
UNION ALL
SELECT 'A_HSPT_001_defendant_remaining_count', defendant_remaining_count, 2
FROM tmp_hspt_case_status
WHERE period_code = 'A' AND case_code = 'HSPT-001'
UNION ALL
SELECT 'A_HSPT_001_case_resolved_count', case_resolved_count, 0
FROM tmp_hspt_case_status
WHERE period_code = 'A' AND case_code = 'HSPT-001'
UNION ALL
SELECT 'A_HSPT_001_case_remaining_count', case_remaining_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'A' AND case_code = 'HSPT-001'
UNION ALL
SELECT 'B_HSPT_002_termination_defendant_count', COALESCE(termination_defendant_count, 0), 2
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'B' AND case_code = 'HSPT-002'
UNION ALL
SELECT 'B_HSPT_002_uphold_defendant_count', COALESCE(uphold_defendant_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'B' AND case_code = 'HSPT-002'
UNION ALL
SELECT 'B_HSPT_002_modify_defendant_count', COALESCE(modify_defendant_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'B' AND case_code = 'HSPT-002'
UNION ALL
SELECT 'B_HSPT_002_case_resolved_count', case_resolved_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'B' AND case_code = 'HSPT-002'
UNION ALL
SELECT 'B_HSPT_002_case_remaining_count', case_remaining_count, 0
FROM tmp_hspt_case_status
WHERE period_code = 'B' AND case_code = 'HSPT-002'
UNION ALL
SELECT 'B_HSPT_003_case_remaining_count', case_remaining_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'B' AND case_code = 'HSPT-003'
UNION ALL
SELECT 'C_HSPT_003_case_resolved_count', case_resolved_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'C' AND case_code = 'HSPT-003'
UNION ALL
SELECT 'C_HSPT_003_cancel_defendant_count', COALESCE(cancel_defendant_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'C' AND case_code = 'HSPT-003'
UNION ALL
SELECT 'C_HSPT_003_modify_defendant_count', COALESCE(modify_defendant_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'C' AND case_code = 'HSPT-003'
UNION ALL
SELECT 'B_HSPT_004_termination_at_hearing_count', COALESCE(termination_at_hearing_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'B' AND case_code = 'HSPT-004'
UNION ALL
SELECT 'B_HSPT_004_case_resolved_count', case_resolved_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'B' AND case_code = 'HSPT-004'
UNION ALL
SELECT 'B_HSPT_005_uphold_defendant_count', COALESCE(uphold_defendant_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'B' AND case_code = 'HSPT-005'
UNION ALL
SELECT 'B_HSPT_005_modify_defendant_count', COALESCE(modify_defendant_count, 0), 1
FROM tmp_hspt_case_result_counts rc JOIN tmp_hspt_cases c ON c.case_id = rc.case_id
WHERE period_code = 'B' AND case_code = 'HSPT-005'
UNION ALL
SELECT 'B_HSPT_005_case_resolved_count', case_resolved_count, 0
FROM tmp_hspt_case_status
WHERE period_code = 'B' AND case_code = 'HSPT-005'
UNION ALL
SELECT 'B_HSPT_005_case_remaining_count', case_remaining_count, 1
FROM tmp_hspt_case_status
WHERE period_code = 'B' AND case_code = 'HSPT-005';

DO $$
DECLARE
    mismatch RECORD;
    v_expected_rows INTEGER;
    v_modify_without_criteria INTEGER;
    v_duplicate_final_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_expected_rows FROM tmp_hspt_expected;
    IF v_expected_rows <> 19 THEN
        RAISE EXCEPTION 'Expected 19 assertion rows, got %', v_expected_rows;
    END IF;

    SELECT *
    INTO mismatch
    FROM tmp_hspt_expected
    WHERE actual_value <> expected_value
    ORDER BY check_name
    LIMIT 1;

    IF FOUND THEN
        RAISE EXCEPTION 'Mismatch %, expected %, actual %',
            mismatch.check_name, mismatch.expected_value, mismatch.actual_value;
    END IF;

    SELECT COUNT(*)
    INTO v_modify_without_criteria
    FROM criminal_appellate_defendant_results r
    JOIN tmp_hspt_cases c ON c.case_id = r.case_id
    WHERE r.result_type_code IN ('MODIFY_FIRST_INSTANCE_SUBJECTIVE', 'MODIFY_FIRST_INSTANCE_OBJECTIVE')
      AND NOT EXISTS (
          SELECT 1
          FROM criminal_appellate_modify_criteria mc
          WHERE mc.appellate_result_id = r.appellate_result_id
      );

    IF v_modify_without_criteria <> 0 THEN
        RAISE EXCEPTION 'Modify appellate result must have at least one criterion, missing %', v_modify_without_criteria;
    END IF;

    SELECT COUNT(*)
    INTO v_duplicate_final_count
    FROM (
        SELECT case_id, defendant_id
        FROM criminal_appellate_defendant_results
        WHERE is_final_result IS TRUE
        GROUP BY case_id, defendant_id
        HAVING COUNT(*) > 1
    ) dup;

    IF v_duplicate_final_count <> 0 THEN
        RAISE EXCEPTION 'A defendant has more than one final appellate result.';
    END IF;

    BEGIN
        INSERT INTO criminal_appellate_defendant_results (
            appellate_result_id,
            case_id,
            defendant_id,
            decision_stage_code,
            result_group_code,
            result_type_code,
            result_date,
            is_final_result
        )
        VALUES (
            '97499999-0000-0000-0000-000000000001',
            '97100000-0000-0000-0000-000000000001',
            '97300000-0000-0000-0001-000000000001',
            'AT_HEARING',
            'TRIAL',
            'UPHOLD_FIRST_INSTANCE',
            DATE '2026-06-06',
            TRUE
        );
        RAISE EXCEPTION 'Duplicate final result insert must fail.';
    EXCEPTION
        WHEN unique_violation THEN
            NULL;
    END;
END $$;

SELECT
    'EXPECTED_VS_ACTUAL' AS section,
    check_name,
    expected_value,
    actual_value,
    CASE WHEN actual_value = expected_value THEN 'PASS' ELSE 'FAILED' END AS result
FROM tmp_hspt_expected
ORDER BY check_name;

SELECT
    'CASE_STATUS_AS_OF' AS section,
    period_code,
    case_code,
    total_defendant_count,
    defendant_resolved_count,
    defendant_remaining_count,
    case_resolved_count,
    case_remaining_count
FROM tmp_hspt_case_status
ORDER BY period_code, case_code;

SELECT
    'DEFENDANT_RESULTS' AS section,
    c.case_code,
    d.full_name,
    r.decision_stage_code,
    r.result_group_code,
    r.result_type_code,
    r.result_date,
    COALESCE(string_agg(mc.criterion_code, ', ' ORDER BY mc.criterion_code), '') AS modify_criteria
FROM tmp_hspt_defendants d
JOIN tmp_hspt_cases c ON c.case_id = d.case_id
LEFT JOIN criminal_appellate_defendant_results r
    ON r.case_id = d.case_id
   AND r.defendant_id = d.defendant_id
   AND r.is_final_result IS TRUE
LEFT JOIN criminal_appellate_modify_criteria mc
    ON mc.appellate_result_id = r.appellate_result_id
GROUP BY c.case_code, d.full_name, r.decision_stage_code, r.result_group_code, r.result_type_code, r.result_date
ORDER BY c.case_code, d.full_name;

SELECT 'PASS' AS result, 'criminal appellate defendant-level result skill test' AS test_name;
