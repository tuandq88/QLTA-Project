-- 02_criminal_first_instance_june_2026_by_dm_join.sql
-- Mục tiêu: Liệt kê vụ án hình sự sơ thẩm tháng 06/2026 khi case_files dùng case_type_id/trial_level_id trỏ tới dm_category_items.
-- Điều chỉnh code danh mục nếu repo đang dùng mã khác với HINH_SU/CRIMINAL hoặc SO_THAM/FIRST_INSTANCE.

\pset pager off
\timing on

WITH params AS (
    SELECT
        DATE '2026-06-01' AS period_start,
        LEAST(CURRENT_DATE, DATE '2026-06-30') AS as_of_date
),
matched_cases AS (
    SELECT
        cf.id AS case_file_id,
        'DA_GIAI_QUYET_TRONG_KY' AS matched_reason
    FROM case_files cf
    JOIN dm_category_items case_type
        ON case_type.id = cf.case_type_id
    JOIN dm_category_items trial_level
        ON trial_level.id = cf.trial_level_id
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND cf.resolved_date BETWEEN p.period_start AND p.as_of_date
      AND case_type.code IN ('HINH_SU', 'CRIMINAL')
      AND trial_level.code IN ('SO_THAM', 'FIRST_INSTANCE')

    UNION

    SELECT
        cf.id AS case_file_id,
        'THU_LY_TRONG_KY' AS matched_reason
    FROM case_files cf
    JOIN dm_category_items case_type
        ON case_type.id = cf.case_type_id
    JOIN dm_category_items trial_level
        ON trial_level.id = cf.trial_level_id
    CROSS JOIN params p
    WHERE cf.acceptance_date BETWEEN p.period_start AND p.as_of_date
      AND case_type.code IN ('HINH_SU', 'CRIMINAL')
      AND trial_level.code IN ('SO_THAM', 'FIRST_INSTANCE')

    UNION

    SELECT
        cf.id AS case_file_id,
        'CHUA_GIAI_QUYET_DEN_NGAY_HIEN_TAI' AS matched_reason
    FROM case_files cf
    JOIN dm_category_items case_type
        ON case_type.id = cf.case_type_id
    JOIN dm_category_items trial_level
        ON trial_level.id = cf.trial_level_id
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND (
            cf.resolved_date IS NULL
            OR cf.resolved_date > p.as_of_date
          )
      AND case_type.code IN ('HINH_SU', 'CRIMINAL')
      AND trial_level.code IN ('SO_THAM', 'FIRST_INSTANCE')
),
case_reasons AS (
    SELECT
        case_file_id,
        string_agg(DISTINCT matched_reason, ', ' ORDER BY matched_reason) AS matched_reasons
    FROM matched_cases
    GROUP BY case_file_id
)
SELECT
    cf.id,
    cf.case_number,
    cf.case_title,
    cf.acceptance_date,
    cf.resolved_date,
    case_type.code AS case_type_code,
    case_type.name AS case_type_name,
    trial_level.code AS trial_level_code,
    trial_level.name AS trial_level_name,
    cr.matched_reasons
FROM case_reasons cr
JOIN case_files cf ON cf.id = cr.case_file_id
JOIN dm_category_items case_type
    ON case_type.id = cf.case_type_id
JOIN dm_category_items trial_level
    ON trial_level.id = cf.trial_level_id
ORDER BY
    cf.acceptance_date,
    cf.case_number;
