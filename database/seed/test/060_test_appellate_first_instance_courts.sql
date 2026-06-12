-- Test seed 060: appellate cases with explicit first-instance courts.
-- This seed uses controlled placeholder regional courts from 011_courts_quang_ngai.sql.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

WITH required_courts AS (
    SELECT court_code, court_id
    FROM courts
    WHERE court_code IN (
        'TAND_QUANG_NGAI_PROVINCE',
        'TAND_KHU_VUC_01_QUANG_NGAI',
        'TAND_KHU_VUC_02_QUANG_NGAI',
        'TAND_KHU_VUC_03_QUANG_NGAI'
    )
),
required_categories AS (
    SELECT
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'case_group' AND dci.item_code = 'PHUC_THAM')::uuid AS phuc_tham_id,
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'case_type' AND dci.item_code = 'criminal')::uuid AS criminal_type_id,
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'case_type' AND dci.item_code = 'civil')::uuid AS civil_type_id,
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'case_type' AND dci.item_code = 'administrative')::uuid AS administrative_type_id,
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'procedure_law' AND dci.item_code = 'BLTTHS')::uuid AS bltths_id,
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'procedure_law' AND dci.item_code = 'BLTTDS')::uuid AS blttds_id,
        MAX(dci.item_id::text) FILTER (WHERE dc.category_code = 'procedure_law' AND dci.item_code = 'LTTHC')::uuid AS ltthc_id
    FROM dm_categories dc
    JOIN dm_category_items dci ON dci.category_id = dc.category_id
),
source_rows AS (
    SELECT *
    FROM (
        VALUES
            (
                'HSPT-FIRSTCOURT-001',
                '11/2026/HSPT-FIRSTCOURT',
                'criminal'::case_type_enum,
                'BLTTHS',
                DATE '2026-06-02',
                NULL::date,
                'TAND_KHU_VUC_01_QUANG_NGAI',
                '01/2026/HSST-FIRSTCOURT',
                '01/2026/HSST',
                DATE '2026-05-20',
                'Test án hình sự phúc thẩm có tòa sơ thẩm khu vực 01.'
            ),
            (
                'DSPT-FIRSTCOURT-001',
                '12/2026/DSPT-FIRSTCOURT',
                'civil'::case_type_enum,
                'BLTTDS',
                DATE '2026-05-25',
                DATE '2026-06-05',
                'TAND_KHU_VUC_02_QUANG_NGAI',
                '02/2026/DSST-FIRSTCOURT',
                '02/2026/DSST',
                DATE '2026-05-18',
                'Test án dân sự phúc thẩm đã giải quyết trong kỳ, tòa sơ thẩm khu vực 02.'
            ),
            (
                'HCPT-FIRSTCOURT-001',
                '13/2026/HCPT-FIRSTCOURT',
                'administrative'::case_type_enum,
                'LTTHC',
                DATE '2026-05-30',
                NULL::date,
                'TAND_KHU_VUC_03_QUANG_NGAI',
                '03/2026/HCST-FIRSTCOURT',
                '03/2026/HCST',
                DATE '2026-05-16',
                'Test án hành chính phúc thẩm còn lại cuối kỳ, tòa sơ thẩm khu vực 03.'
            )
    ) AS v(
        case_code,
        case_number,
        case_type,
        procedure_law,
        acceptance_date,
        closed_date,
        first_instance_court_code,
        first_instance_case_number,
        first_instance_judgment_number,
        first_instance_judgment_date,
        summary
    )
),
resolved AS (
    SELECT
        sr.*,
        current_court.court_id AS current_court_id,
        first_court.court_id AS first_instance_court_id,
        rc.phuc_tham_id,
        CASE
            WHEN sr.case_type = 'criminal' THEN rc.criminal_type_id
            WHEN sr.case_type = 'civil' THEN rc.civil_type_id
            WHEN sr.case_type = 'administrative' THEN rc.administrative_type_id
        END AS case_type_id,
        CASE
            WHEN sr.procedure_law = 'BLTTHS' THEN rc.bltths_id
            WHEN sr.procedure_law = 'BLTTDS' THEN rc.blttds_id
            WHEN sr.procedure_law = 'LTTHC' THEN rc.ltthc_id
        END AS procedure_law_id
    FROM source_rows sr
    CROSS JOIN required_categories rc
    JOIN required_courts current_court ON current_court.court_code = 'TAND_QUANG_NGAI_PROVINCE'
    JOIN required_courts first_court ON first_court.court_code = sr.first_instance_court_code
)
INSERT INTO case_files (
    case_id,
    court_id,
    case_code,
    case_number,
    case_type,
    case_group,
    procedure_law,
    filing_date,
    acceptance_date,
    current_stage,
    case_status,
    resolution_status,
    closed_date,
    summary,
    case_type_id,
    case_group_id,
    procedure_law_id,
    first_instance_court_id,
    first_instance_case_number,
    first_instance_judgment_number,
    first_instance_judgment_date
)
SELECT
    uuid_generate_v5(uuid_ns_url(), 'qlta:test:case:' || case_code),
    current_court_id,
    case_code,
    case_number,
    case_type,
    'PHUC_THAM',
    procedure_law,
    acceptance_date,
    acceptance_date,
    CASE WHEN closed_date IS NULL THEN 'appeal_tracking' ELSE 'resolved' END,
    CASE WHEN closed_date IS NULL THEN 'accepted'::case_status_enum ELSE 'resolved'::case_status_enum END,
    CASE WHEN closed_date IS NULL THEN NULL ELSE 'resolved' END,
    closed_date,
    summary,
    case_type_id,
    phuc_tham_id,
    procedure_law_id,
    first_instance_court_id,
    first_instance_case_number,
    first_instance_judgment_number,
    first_instance_judgment_date
FROM resolved
ON CONFLICT (case_code) DO UPDATE SET
    court_id = EXCLUDED.court_id,
    case_number = EXCLUDED.case_number,
    case_type = EXCLUDED.case_type,
    case_group = EXCLUDED.case_group,
    procedure_law = EXCLUDED.procedure_law,
    filing_date = EXCLUDED.filing_date,
    acceptance_date = EXCLUDED.acceptance_date,
    current_stage = EXCLUDED.current_stage,
    case_status = EXCLUDED.case_status,
    resolution_status = EXCLUDED.resolution_status,
    closed_date = EXCLUDED.closed_date,
    summary = EXCLUDED.summary,
    case_type_id = EXCLUDED.case_type_id,
    case_group_id = EXCLUDED.case_group_id,
    procedure_law_id = EXCLUDED.procedure_law_id,
    first_instance_court_id = EXCLUDED.first_instance_court_id,
    first_instance_case_number = EXCLUDED.first_instance_case_number,
    first_instance_judgment_number = EXCLUDED.first_instance_judgment_number,
    first_instance_judgment_date = EXCLUDED.first_instance_judgment_date,
    updated_at = CURRENT_TIMESTAMP;
