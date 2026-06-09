-- Seed 010: legal catalog data from TAND Vietnam seed source.
-- Source: database/seed/legal_seed_data_tand_vietnam/all_legal_seed_master.csv
-- Date values in this source are embedded in text legal-basis fields only; no DATE seed is inserted here.

CREATE TEMP TABLE legal_seed_data_stage (
    seed_id TEXT,
    case_group TEXT,
    case_type TEXT,
    article TEXT,
    item_no TEXT,
    name TEXT,
    legal_basis TEXT,
    source_document TEXT,
    source_url TEXT,
    chapter TEXT,
    chapter_name TEXT,
    notes TEXT
);

\copy legal_seed_data_stage (seed_id, case_group, case_type, article, item_no, name, legal_basis, source_document, source_url, chapter, chapter_name, notes) FROM 'database/seed/legal_seed_data_tand_vietnam/all_legal_seed_master.csv' WITH (FORMAT csv, HEADER true)

INSERT INTO statistical_categories (category_code, category_name, description, case_type_scope, sort_order)
VALUES
    ('criminal_offenses', 'Tội danh hình sự', 'Danh mục tội danh từ nguồn legal_seed_data_tand_vietnam.', 'criminal', 25)
ON CONFLICT (category_code) DO UPDATE SET
    category_name = EXCLUDED.category_name,
    description = EXCLUDED.description,
    case_type_scope = EXCLUDED.case_type_scope,
    sort_order = EXCLUDED.sort_order,
    updated_at = CURRENT_TIMESTAMP;

WITH category_ref AS (
    SELECT statistical_category_id
    FROM statistical_categories
    WHERE category_code = 'criminal_offenses'
)
INSERT INTO statistical_indicators (
    statistical_category_id,
    indicator_code,
    indicator_name,
    input_control_type,
    value_type,
    allow_multiple,
    applies_to_entity,
    case_type_scope,
    legal_basis,
    description,
    sort_order
)
SELECT
    c.statistical_category_id,
    'criminal_offense_selector',
    'Tội danh hình sự',
    'dropdown',
    'option',
    FALSE,
    'charge',
    'criminal',
    'database/seed/legal_seed_data_tand_vietnam/all_legal_seed_master.csv',
    'UI nên dùng searchable dropdown từ dm_crimes.crime_name.',
    25
FROM category_ref c
ON CONFLICT (indicator_code) DO UPDATE SET
    indicator_name = EXCLUDED.indicator_name,
    input_control_type = EXCLUDED.input_control_type,
    value_type = EXCLUDED.value_type,
    allow_multiple = EXCLUDED.allow_multiple,
    applies_to_entity = EXCLUDED.applies_to_entity,
    case_type_scope = EXCLUDED.case_type_scope,
    legal_basis = EXCLUDED.legal_basis,
    description = EXCLUDED.description,
    sort_order = EXCLUDED.sort_order,
    updated_at = CURRENT_TIMESTAMP;

WITH src AS (
    SELECT DISTINCT ON (article)
        article,
        name,
        chapter,
        legal_basis,
        source_document,
        source_url,
        notes
    FROM legal_seed_data_stage
    WHERE case_type = 'Tội danh'
      AND NULLIF(article, '') IS NOT NULL
    ORDER BY article, seed_id
)
INSERT INTO dm_penal_code_articles (
    code,
    article_number,
    article_title,
    chapter,
    law_code,
    description,
    source_document,
    source_url,
    notes,
    requires_human_review
)
SELECT
    'BLHS_' || article,
    article,
    name,
    NULLIF(chapter, ''),
    'BLHS_VBHN_135_2025',
    legal_basis,
    source_document,
    source_url,
    notes,
    TRUE
FROM src
ON CONFLICT (code) DO UPDATE SET
    article_number = EXCLUDED.article_number,
    article_title = EXCLUDED.article_title,
    chapter = EXCLUDED.chapter,
    law_code = EXCLUDED.law_code,
    description = EXCLUDED.description,
    source_document = EXCLUDED.source_document,
    source_url = EXCLUDED.source_url,
    notes = EXCLUDED.notes,
    requires_human_review = EXCLUDED.requires_human_review,
    is_active = TRUE;

WITH src AS (
    SELECT
        seed_id,
        article,
        name,
        chapter,
        chapter_name,
        legal_basis,
        source_document,
        source_url,
        notes,
        ROW_NUMBER() OVER (ORDER BY article::INTEGER NULLS LAST, seed_id) AS sort_order
    FROM legal_seed_data_stage
    WHERE case_type = 'Tội danh'
      AND NULLIF(seed_id, '') IS NOT NULL
)
INSERT INTO dm_crimes (
    article_id,
    crime_code,
    crime_name,
    default_statistical_group,
    legal_basis,
    source_document,
    source_url,
    notes,
    requires_human_review,
    sort_order
)
SELECT
    a.article_id,
    s.seed_id,
    s.name,
    COALESCE(NULLIF(s.chapter, ''), NULLIF(s.chapter_name, '')),
    s.legal_basis,
    s.source_document,
    s.source_url,
    s.notes,
    TRUE,
    s.sort_order
FROM src s
LEFT JOIN dm_penal_code_articles a ON a.code = 'BLHS_' || s.article
ON CONFLICT (crime_code) DO UPDATE SET
    article_id = EXCLUDED.article_id,
    crime_name = EXCLUDED.crime_name,
    default_statistical_group = EXCLUDED.default_statistical_group,
    legal_basis = EXCLUDED.legal_basis,
    source_document = EXCLUDED.source_document,
    source_url = EXCLUDED.source_url,
    notes = EXCLUDED.notes,
    requires_human_review = EXCLUDED.requires_human_review,
    sort_order = EXCLUDED.sort_order,
    is_active = TRUE;

WITH src AS (
    SELECT
        seed_id,
        case_group,
        case_type,
        article,
        item_no,
        name,
        legal_basis,
        source_document,
        source_url,
        notes,
        CASE case_group
            WHEN 'Dân sự' THEN 'civil'
            WHEN 'Hôn nhân và gia đình' THEN 'marriage_family'
            WHEN 'Kinh doanh thương mại' THEN 'business_commercial'
            WHEN 'Lao động' THEN 'labor'
            WHEN 'Hành chính' THEN 'administrative'
            ELSE 'other'
        END AS case_type_scope,
        ROW_NUMBER() OVER (
            ORDER BY
                case_group,
                CASE WHEN article ~ '^[0-9]+$' THEN article::INTEGER END NULLS LAST,
                CASE WHEN item_no ~ '^[0-9]+$' THEN item_no::INTEGER END NULLS LAST,
                item_no,
                seed_id
        ) AS sort_order
    FROM legal_seed_data_stage
    WHERE case_type <> 'Tội danh'
      AND NULLIF(seed_id, '') IS NOT NULL
)
INSERT INTO dm_legal_relationships (
    relationship_code,
    relationship_name,
    case_type_scope,
    legal_basis,
    source_document,
    source_url,
    notes,
    requires_human_review,
    sort_order
)
SELECT
    seed_id,
    name,
    case_type_scope,
    legal_basis,
    source_document,
    source_url,
    concat_ws(' | ', NULLIF(case_group, ''), NULLIF(case_type, ''), NULLIF(notes, '')),
    FALSE,
    sort_order
FROM src
ON CONFLICT (relationship_code) DO UPDATE SET
    relationship_name = EXCLUDED.relationship_name,
    case_type_scope = EXCLUDED.case_type_scope,
    legal_basis = EXCLUDED.legal_basis,
    source_document = EXCLUDED.source_document,
    source_url = EXCLUDED.source_url,
    notes = EXCLUDED.notes,
    requires_human_review = EXCLUDED.requires_human_review,
    sort_order = EXCLUDED.sort_order,
    is_active = TRUE;

DROP TABLE IF EXISTS legal_seed_data_stage;
