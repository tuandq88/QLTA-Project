@'
\pset pager off
\timing on

WITH params AS (
    SELECT
        DATE '2026-06-01' AS period_start,
        LEAST(CURRENT_DATE, DATE '2026-06-30') AS as_of_date
),
criminal_first_instance_cases AS (
    SELECT cf.*
    FROM case_files cf
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND (
            lower(cf.case_type::text) LIKE '%hinh%'
         OR lower(cf.case_type::text) LIKE '%criminal%'
         OR lower(cf.case_type::text) LIKE '%hs%'
         OR lower(cf.case_type::text) LIKE '%hinh_su%'
      )
      AND (
            lower(coalesce(cf.case_group, '')) LIKE '%so tham%'
         OR lower(coalesce(cf.case_group, '')) LIKE '%so_tham%'
         OR lower(coalesce(cf.case_group, '')) LIKE '%first%'
         OR lower(coalesce(cf.procedure_law, '')) LIKE '%so tham%'
         OR lower(coalesce(cf.procedure_law, '')) LIKE '%so_tham%'
         OR lower(coalesce(cf.procedure_law, '')) LIKE '%first%'
         OR lower(coalesce(cf.current_stage, '')) LIKE '%so tham%'
         OR lower(coalesce(cf.current_stage, '')) LIKE '%so_tham%'
         OR lower(coalesce(cf.current_stage, '')) LIKE '%first%'
      )
),
matched_cases AS (
    SELECT cf.case_id, 'DA_GIAI_QUYET_TRONG_KY' AS matched_reason
    FROM criminal_first_instance_cases cf
    CROSS JOIN params p
    WHERE cf.closed_date BETWEEN p.period_start AND p.as_of_date

    UNION

    SELECT cf.case_id, 'THU_LY_TRONG_KY' AS matched_reason
    FROM criminal_first_instance_cases cf
    CROSS JOIN params p
    WHERE cf.acceptance_date BETWEEN p.period_start AND p.as_of_date

    UNION

    SELECT cf.case_id, 'CHUA_GIAI_QUYET_DEN_NGAY_HIEN_TAI' AS matched_reason
    FROM criminal_first_instance_cases cf
    CROSS JOIN params p
    WHERE cf.acceptance_date <= p.as_of_date
      AND (cf.closed_date IS NULL OR cf.closed_date > p.as_of_date)
),
case_reasons AS (
    SELECT
        case_id,
        string_agg(DISTINCT matched_reason, ', ' ORDER BY matched_reason) AS matched_reasons
    FROM matched_cases
    GROUP BY case_id
)
SELECT
    cf.case_id,
    cf.case_code,
    cf.case_number,
    cf.case_type,
    cf.case_group,
    cf.procedure_law,
    cf.acceptance_date,
    cf.closed_date,
    cf.current_stage,
    cf.case_status,
    cf.resolution_status,
    cf.summary,
    cr.matched_reasons
FROM case_reasons cr
JOIN case_files cf ON cf.case_id = cr.case_id
ORDER BY
    cf.acceptance_date,
    cf.case_number,
    cf.case_code;
'@ | Set-Content -Path .\tests\sql_checks\criminal_first_instance_june_2026_fixed.sql -Encoding UTF8