\set ON_ERROR_STOP on

-- Precheck điều kiện trước khi kiểm thử thuật toán thống kê.
-- Không kiểm thử thuật toán thống kê chi tiết trong file này.

BEGIN;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_tables(table_name) AS (
        VALUES
            ('statistics_periods'),
            ('statistics_snapshots'),
            ('kpi_values'),
            ('statistical_categories'),
            ('statistical_indicators'),
            ('statistical_indicator_options'),
            ('dm_statistical_forms'),
            ('dm_statistical_form_items'),
            ('dm_statistical_metrics')
    )
    SELECT array_agg(table_name)
    INTO missing_items
    FROM expected_tables
    WHERE to_regclass('public.' || table_name) IS NULL;

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Thiếu bảng thống kê/KPI bắt buộc: %', missing_items;
    END IF;

    IF to_regclass('public.kpi_metrics') IS NULL AND to_regclass('public.dm_kpi_metrics') IS NULL THEN
        RAISE EXCEPTION 'Thiếu bảng KPI metric: cần kpi_metrics hoặc dm_kpi_metrics';
    END IF;
END $$;

DO $$
DECLARE
    empty_items text[];
BEGIN
    WITH required_seed(table_name) AS (
        VALUES
            ('statistical_categories'),
            ('statistical_indicators'),
            ('statistical_indicator_options'),
            ('dm_statistical_forms'),
            ('dm_statistical_form_items'),
            ('dm_statistical_metrics')
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
        RAISE EXCEPTION 'Thiếu seed thống kê ở bảng: %', empty_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_category text[];
BEGIN
    WITH expected_categories(category_code) AS (
        VALUES
            ('case_type'),
            ('appellate_result'),
            ('appeal_protest_type'),
            ('fault_classification')
    )
    SELECT array_agg(category_code)
    INTO missing_category
    FROM expected_categories
    WHERE NOT EXISTS (
        SELECT 1 FROM dm_categories c WHERE c.category_code = expected_categories.category_code
    );

    IF missing_category IS NOT NULL THEN
        RAISE EXCEPTION 'Thiếu danh mục nền cho thống kê: %', missing_category;
    END IF;
END $$;

DO $$
DECLARE
    issue_count integer;
BEGIN
    SELECT
        (SELECT count(*) FROM dm_categories GROUP BY category_code HAVING count(*) > 1 LIMIT 1) +
        (SELECT count(*) FROM dm_category_items GROUP BY category_id, item_code HAVING count(*) > 1 LIMIT 1) +
        (SELECT count(*) FROM statistical_indicators GROUP BY indicator_code HAVING count(*) > 1 LIMIT 1) +
        (SELECT count(*) FROM dm_statistical_metrics GROUP BY metric_code HAVING count(*) > 1 LIMIT 1) +
        (SELECT count(*) FROM dm_statistical_forms GROUP BY form_code HAVING count(*) > 1 LIMIT 1)
    INTO issue_count;

    IF COALESCE(issue_count, 0) > 0 THEN
        RAISE EXCEPTION 'Có code trùng trong danh mục thống kê hoặc danh mục nền';
    END IF;
END $$;

DO $$
DECLARE
    blank_count integer;
    orphan_count integer;
BEGIN
    SELECT
        (SELECT count(*) FROM dm_statistical_metrics WHERE is_active AND btrim(metric_name) = '') +
        (SELECT count(*) FROM dm_statistical_forms WHERE is_active AND btrim(form_name) = '') +
        (SELECT count(*) FROM dm_statistical_form_items WHERE is_active AND btrim(item_name) = '') +
        (SELECT count(*) FROM statistical_indicators WHERE is_active AND btrim(indicator_name) = '') +
        (SELECT count(*) FROM statistical_indicator_options WHERE is_active AND btrim(option_name) = '')
    INTO blank_count;

    IF blank_count > 0 THEN
        RAISE EXCEPTION 'Có metric/form/indicator active thiếu tên tiếng Việt: %', blank_count;
    END IF;

    SELECT
        (SELECT count(*) FROM dm_statistical_form_items i LEFT JOIN dm_statistical_forms f ON f.form_id = i.form_id WHERE f.form_id IS NULL) +
        (SELECT count(*) FROM statistical_indicator_options o LEFT JOIN statistical_indicators i ON i.statistical_indicator_id = o.statistical_indicator_id WHERE i.statistical_indicator_id IS NULL)
    INTO orphan_count;

    IF orphan_count > 0 THEN
        RAISE EXCEPTION 'Có form item hoặc indicator option mồ côi: %', orphan_count;
    END IF;
END $$;

DO $$
DECLARE
    v_court_id uuid;
    v_period_id uuid;
    v_metric_id uuid;
BEGIN
    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('TEST_STAT_PRECHECK_COURT', 'Tòa test precheck thống kê', 'province')
    RETURNING court_id INTO v_court_id;

    INSERT INTO statistics_periods (period_type, start_date, end_date, report_year, report_month)
    VALUES ('month', DATE '2026-01-01', DATE '2026-01-31', 2026, 1)
    RETURNING period_id INTO v_period_id;

    INSERT INTO kpi_metrics (metric_code, metric_name, metric_group)
    VALUES ('TEST_PRECHECK_METRIC', 'Chỉ tiêu test precheck', 'test')
    RETURNING metric_id INTO v_metric_id;

    INSERT INTO statistics_snapshots (
        period_id, court_id, statistic_form_code, metric_code, metric_value, aggregation_level
    )
    VALUES (
        v_period_id, v_court_id, 'FORM_REVIEW_REQUIRED', 'TEST_PRECHECK_METRIC', 1, 'court'
    );

    INSERT INTO kpi_values (metric_id, period_id, court_id, actual_value)
    VALUES (v_metric_id, v_period_id, v_court_id, 1);
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: statistics_algorithm_precheck.sql';
END $$;
