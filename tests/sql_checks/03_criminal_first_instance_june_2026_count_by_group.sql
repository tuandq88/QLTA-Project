-- 03_criminal_first_instance_june_2026_count_by_group.sql
-- Mục tiêu: Đếm số vụ án hình sự sơ thẩm tháng 06/2026 theo từng nhóm nghiệp vụ và tổng sau khi khử trùng.
-- Yêu cầu schema: case_files có các cột case_type_code, trial_level_code, acceptance_date, resolved_date.

\pset pager off
\timing on

WITH params AS (
    SELECT
        DATE '2026-06-01' AS period_start,
        LEAST(CURRENT_DATE, DATE '2026-06-30') AS as_of_date
),
matched_cases AS (
    SELECT cf.id, 'DA_GIAI_QUYET_TRONG_KY' AS matched_reason
    FROM case_files cf
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND cf.resolved_date BETWEEN p.period_start AND p.as_of_date
      AND cf.case_type_code = 'HINH_SU'
      AND cf.trial_level_code = 'SO_THAM'

    UNION ALL

    SELECT cf.id, 'THU_LY_TRONG_KY' AS matched_reason
    FROM case_files cf
    CROSS JOIN params p
    WHERE cf.acceptance_date BETWEEN p.period_start AND p.as_of_date
      AND cf.case_type_code = 'HINH_SU'
      AND cf.trial_level_code = 'SO_THAM'

    UNION ALL

    SELECT cf.id, 'CHUA_GIAI_QUYET_DEN_NGAY_HIEN_TAI' AS matched_reason
    FROM case_files cf
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND (
            cf.resolved_date IS NULL
            OR cf.resolved_date > p.as_of_date
          )
      AND cf.case_type_code = 'HINH_SU'
      AND cf.trial_level_code = 'SO_THAM'
)
SELECT
    matched_reason,
    COUNT(DISTINCT id) AS total_cases
FROM matched_cases
GROUP BY matched_reason

UNION ALL

SELECT
    'TONG_HOP_SAU_KHI_KHU_TRUNG' AS matched_reason,
    COUNT(DISTINCT id) AS total_cases
FROM matched_cases
ORDER BY matched_reason;
