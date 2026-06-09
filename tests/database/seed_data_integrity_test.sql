\set ON_ERROR_STOP on

-- Test tính toàn vẹn seed danh mục. Test không tạo dữ liệu vụ án thật.

BEGIN;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_tables(table_name) AS (
        VALUES
            ('dm_categories'), ('dm_category_items'), ('statistical_categories'),
            ('statistical_indicators'), ('statistical_indicator_options'),
            ('dm_penal_code_articles'), ('dm_crimes'), ('dm_legal_relationships'),
            ('dm_trial_result_types'), ('dm_appellate_result_codes'),
            ('dm_appeal_protest_types'), ('dm_statistical_forms'),
            ('dm_statistical_metrics'), ('dm_statistical_form_items')
    )
    SELECT array_agg(table_name)
    INTO missing_items
    FROM expected_tables
    WHERE to_regclass('public.' || table_name) IS NULL;

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Thiếu bảng seed cần kiểm tra: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    empty_items text[];
BEGIN
    WITH required_seed(table_name) AS (
        VALUES
            ('dm_categories'), ('dm_category_items'), ('statistical_categories'),
            ('statistical_indicators'), ('statistical_indicator_options'),
            ('dm_trial_result_types'), ('dm_appellate_result_codes'),
            ('dm_appeal_protest_types'), ('dm_statistical_forms'),
            ('dm_statistical_metrics'), ('dm_statistical_form_items')
    ),
    counts AS (
        SELECT table_name,
               (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', table_name), false, true, '')))[1]::text::int AS row_count
        FROM required_seed
    )
    SELECT array_agg(table_name)
    INTO empty_items
    FROM counts
    WHERE row_count = 0;

    IF empty_items IS NOT NULL THEN
        RAISE EXCEPTION 'Bảng seed đang rỗng: %', empty_items;
    END IF;
END $$;

DO $$
DECLARE
    duplicate_count integer;
BEGIN
    SELECT count(*)
    INTO duplicate_count
    FROM (
        SELECT category_code FROM dm_categories GROUP BY category_code HAVING count(*) > 1
        UNION ALL
        SELECT indicator_code FROM statistical_indicators GROUP BY indicator_code HAVING count(*) > 1
        UNION ALL
        SELECT metric_code FROM dm_statistical_metrics GROUP BY metric_code HAVING count(*) > 1
        UNION ALL
        SELECT form_code FROM dm_statistical_forms GROUP BY form_code HAVING count(*) > 1
        UNION ALL
        SELECT result_code FROM dm_trial_result_types GROUP BY result_code HAVING count(*) > 1
        UNION ALL
        SELECT result_code FROM dm_appellate_result_codes GROUP BY result_code HAVING count(*) > 1
    ) d;

    IF duplicate_count > 0 THEN
        RAISE EXCEPTION 'Có code trùng trong seed danh mục: %', duplicate_count;
    END IF;
END $$;

DO $$
DECLARE
    blank_count integer;
BEGIN
    SELECT
        (SELECT count(*) FROM dm_categories WHERE is_active AND btrim(category_name) = '') +
        (SELECT count(*) FROM dm_category_items WHERE is_active AND btrim(item_name) = '') +
        (SELECT count(*) FROM statistical_categories WHERE is_active AND btrim(category_name) = '') +
        (SELECT count(*) FROM statistical_indicators WHERE is_active AND btrim(indicator_name) = '') +
        (SELECT count(*) FROM statistical_indicator_options WHERE is_active AND btrim(option_name) = '') +
        (SELECT count(*) FROM dm_statistical_forms WHERE is_active AND btrim(form_name) = '') +
        (SELECT count(*) FROM dm_statistical_metrics WHERE is_active AND btrim(metric_name) = '')
    INTO blank_count;

    IF blank_count > 0 THEN
        RAISE EXCEPTION 'Có bản ghi active thiếu tên hiển thị: %', blank_count;
    END IF;
END $$;

DO $$
DECLARE
    orphan_count integer;
BEGIN
    SELECT
        (SELECT count(*) FROM dm_category_items i LEFT JOIN dm_categories c ON c.category_id = i.category_id WHERE c.category_id IS NULL) +
        (SELECT count(*) FROM statistical_indicators i LEFT JOIN statistical_categories c ON c.statistical_category_id = i.statistical_category_id WHERE c.statistical_category_id IS NULL) +
        (SELECT count(*) FROM statistical_indicator_options o LEFT JOIN statistical_indicators i ON i.statistical_indicator_id = o.statistical_indicator_id WHERE i.statistical_indicator_id IS NULL) +
        (SELECT count(*) FROM dm_statistical_form_items i LEFT JOIN dm_statistical_forms f ON f.form_id = i.form_id WHERE f.form_id IS NULL)
    INTO orphan_count;

    IF orphan_count > 0 THEN
        RAISE EXCEPTION 'Có FK mồ côi trong seed danh mục: %', orphan_count;
    END IF;
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: seed_data_integrity_test.sql';
END $$;
