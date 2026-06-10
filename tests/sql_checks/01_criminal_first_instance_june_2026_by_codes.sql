-- 01_criminal_first_instance_june_2026_by_codes.sql
-- Mục tiêu: Liệt kê vụ án hình sự sơ thẩm tháng 06/2026 theo 3 nhóm nghiệp vụ:
-- 1) Đã giải quyết từ 01/06/2026 đến ngày hiện tại
-- 2) Thụ lý từ 01/06/2026 đến ngày hiện tại
-- 3) Chưa giải quyết đến ngày hiện tại, bao gồm resolved_date IS NULL hoặc resolved_date > ngày hiện tại
-- Yêu cầu schema: case_files có các cột case_type_code, trial_level_code, acceptance_date, resolved_date.

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
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND cf.resolved_date BETWEEN p.period_start AND p.as_of_date
      AND cf.case_type_code = 'HINH_SU'
      AND cf.trial_level_code = 'SO_THAM'

    UNION

    SELECT
        cf.id AS case_file_id,
        'THU_LY_TRONG_KY' AS matched_reason
    FROM case_files cf
    CROSS JOIN params p
    WHERE cf.acceptance_date BETWEEN p.period_start AND p.as_of_date
      AND cf.case_type_code = 'HINH_SU'
      AND cf.trial_level_code = 'SO_THAM'

    UNION

    SELECT
        cf.id AS case_file_id,
        'CHUA_GIAI_QUYET_DEN_NGAY_HIEN_TAI' AS matched_reason
    FROM case_files cf
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND (
            cf.resolved_date IS NULL
            OR cf.resolved_date > p.as_of_date
          )
      AND cf.case_type_code = 'HINH_SU'
      AND cf.trial_level_code = 'SO_THAM'
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
    cf.case_type_code,
    cf.trial_level_code,
    cf.status_code,
    cf.resolution_type_code,
    cr.matched_reasons
FROM case_reasons cr
JOIN case_files cf ON cf.id = cr.case_file_id
ORDER BY
    cf.acceptance_date,
    cf.case_number;
