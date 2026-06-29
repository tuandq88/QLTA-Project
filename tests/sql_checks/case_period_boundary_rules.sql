-- Kiểm tra độc lập quy tắc kỳ báo cáo, không ghi dữ liệu.
-- Hai mốc from_date/to_date đều được tính bao gồm.
WITH params AS (
    SELECT DATE '2026-06-01' AS from_date, DATE '2026-06-30' AS to_date
),
sample_cases(case_code, acceptance_date, resolution_date) AS (
    VALUES
        ('ACCEPTED_FROM', DATE '2026-06-01', NULL::date),
        ('ACCEPTED_TO', DATE '2026-06-30', NULL::date),
        ('OLD_UNRESOLVED', DATE '2026-05-01', NULL::date),
        ('OLD_RESOLVED_TO', DATE '2026-05-01', DATE '2026-06-30'),
        ('OLD_RESOLVED_AFTER', DATE '2026-05-01', DATE '2026-07-01')
),
classified AS (
    SELECT s.*,
           acceptance_date BETWEEN p.from_date AND p.to_date AS is_accepted_in_period,
           acceptance_date < p.from_date
               AND (resolution_date IS NULL OR resolution_date > p.to_date) AS is_opening_pending,
           resolution_date BETWEEN p.from_date AND p.to_date AS is_resolved_in_period,
           resolution_date > p.to_date AS is_resolved_after_period
    FROM sample_cases s
    CROSS JOIN params p
)
SELECT
    CASE WHEN COUNT(*) FILTER (WHERE is_accepted_in_period) = 2 THEN 'PASS' ELSE 'FAIL' END AS accepted_boundary_check,
    CASE WHEN COUNT(*) FILTER (WHERE is_opening_pending) = 2 THEN 'PASS' ELSE 'FAIL' END AS opening_pending_check,
    CASE WHEN COUNT(*) FILTER (WHERE is_resolved_in_period) = 1 THEN 'PASS' ELSE 'FAIL' END AS resolved_boundary_check,
    CASE WHEN COUNT(*) FILTER (WHERE is_resolved_after_period) = 1 THEN 'PASS' ELSE 'FAIL' END AS after_period_check
FROM classified;
