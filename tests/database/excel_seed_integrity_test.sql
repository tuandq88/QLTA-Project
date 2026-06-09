BEGIN;

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM dm_categories
    WHERE category_code IN ('excel_case_type_alias', 'excel_hearing_format');
    IF v_count <> 2 THEN
        RAISE EXCEPTION 'Missing Excel seed dm_categories; found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM dm_category_items i
    JOIN dm_categories c ON c.category_id = i.category_id
    WHERE c.category_code IN ('excel_case_type_alias', 'excel_hearing_format')
      AND btrim(i.item_name) <> ''
      AND i.is_active IS TRUE;
    IF v_count < 10 THEN
        RAISE EXCEPTION 'Expected Excel category items, found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM statistical_indicators
    WHERE indicator_code IN ('excel_hearing_format', 'excel_appellate_result_detail')
      AND btrim(indicator_name) <> ''
      AND is_active IS TRUE;
    IF v_count <> 2 THEN
        RAISE EXCEPTION 'Missing Excel statistical indicators; found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM statistical_indicator_options o
    JOIN statistical_indicators i ON i.statistical_indicator_id = o.statistical_indicator_id
    WHERE i.indicator_code IN ('excel_hearing_format', 'excel_appellate_result_detail')
      AND btrim(o.option_name) <> ''
      AND o.is_active IS TRUE;
    IF v_count < 10 THEN
        RAISE EXCEPTION 'Expected Excel statistical indicator options, found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM dm_legal_relationships
    WHERE source_document LIKE '%.xlsx%'
      AND btrim(relationship_name) <> ''
      AND is_active IS TRUE;
    IF v_count < 50 THEN
        RAISE EXCEPTION 'Expected Excel legal relationship seed rows, found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM dm_crimes
    WHERE btrim(crime_name) = ''
       OR crime_name IS NULL
       OR is_active IS NULL;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Invalid dm_crimes display/active data found: % rows', v_count;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM dm_category_items i
        LEFT JOIN dm_categories c ON c.category_id = i.category_id
        WHERE c.category_id IS NULL
    ) THEN
        RAISE EXCEPTION 'Invalid FK from dm_category_items to dm_categories';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM statistical_indicator_options o
        LEFT JOIN statistical_indicators i ON i.statistical_indicator_id = o.statistical_indicator_id
        WHERE i.statistical_indicator_id IS NULL
    ) THEN
        RAISE EXCEPTION 'Invalid FK from statistical_indicator_options to statistical_indicators';
    END IF;
END $$;

ROLLBACK;

SELECT 'excel_seed_integrity_test passed' AS result;
