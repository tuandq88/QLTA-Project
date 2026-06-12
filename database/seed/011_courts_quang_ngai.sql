-- Seed 011: Quang Ngai courts used for appellate first-instance court metadata.
-- Regional court names are controlled placeholders until verified from an official source.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

WITH level_items AS (
    SELECT dci.item_code, dci.item_id
    FROM dm_category_items dci
    JOIN dm_categories dc ON dc.category_id = dci.category_id
    WHERE dc.category_code = 'court_level'
),
province_court AS (
    INSERT INTO courts (
        court_id,
        court_code,
        court_name,
        court_level,
        province,
        is_active,
        court_level_id
    )
    SELECT
        uuid_generate_v5(uuid_ns_url(), 'qlta:court:TAND_QUANG_NGAI_PROVINCE'),
        'TAND_QUANG_NGAI_PROVINCE',
        'TAND tỉnh Quảng Ngãi',
        'province'::court_level_enum,
        'Quảng Ngãi',
        TRUE,
        li.item_id
    FROM level_items li
    WHERE li.item_code = 'province'
    ON CONFLICT (court_code) DO UPDATE SET
        court_name = EXCLUDED.court_name,
        court_level = EXCLUDED.court_level,
        province = EXCLUDED.province,
        is_active = TRUE,
        court_level_id = EXCLUDED.court_level_id,
        updated_at = CURRENT_TIMESTAMP
    RETURNING court_id
),
parent_court AS (
    SELECT court_id FROM province_court
    UNION ALL
    SELECT court_id
    FROM courts
    WHERE court_code = 'TAND_QUANG_NGAI_PROVINCE'
    LIMIT 1
),
regional_source(court_code, court_name, sort_order) AS (
    VALUES
        ('TAND_KHU_VUC_01_QUANG_NGAI', 'TAND khu vực 01 - Quảng Ngãi', 1),
        ('TAND_KHU_VUC_02_QUANG_NGAI', 'TAND khu vực 02 - Quảng Ngãi', 2),
        ('TAND_KHU_VUC_03_QUANG_NGAI', 'TAND khu vực 03 - Quảng Ngãi', 3)
)
INSERT INTO courts (
    court_id,
    parent_court_id,
    court_code,
    court_name,
    court_level,
    province,
    is_active,
    court_level_id
)
SELECT
    uuid_generate_v5(uuid_ns_url(), 'qlta:court:' || rs.court_code),
    pc.court_id,
    rs.court_code,
    rs.court_name,
    'regional'::court_level_enum,
    'Quảng Ngãi',
    TRUE,
    li.item_id
FROM regional_source rs
CROSS JOIN parent_court pc
LEFT JOIN level_items li ON li.item_code = 'regional'
ON CONFLICT (court_code) DO UPDATE SET
    parent_court_id = EXCLUDED.parent_court_id,
    court_name = EXCLUDED.court_name,
    court_level = EXCLUDED.court_level,
    province = EXCLUDED.province,
    is_active = TRUE,
    court_level_id = EXCLUDED.court_level_id,
    updated_at = CURRENT_TIMESTAMP;
