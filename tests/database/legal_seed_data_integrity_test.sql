BEGIN;

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM dm_crimes;
    IF v_count < 300 THEN
        RAISE EXCEPTION 'Expected at least 300 criminal offense seed rows, found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count FROM dm_legal_relationships;
    IF v_count < 70 THEN
        RAISE EXCEPTION 'Expected at least 70 legal relationship seed rows, found %', v_count;
    END IF;

    SELECT COUNT(*) INTO v_count FROM dm_penal_code_articles;
    IF v_count < 300 THEN
        RAISE EXCEPTION 'Expected at least 300 penal-code article seed rows, found %', v_count;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM dm_crimes
        GROUP BY crime_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate crime_code values found in dm_crimes';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_legal_relationships
        GROUP BY relationship_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate relationship_code values found in dm_legal_relationships';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_category_items
        GROUP BY category_id, item_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate item_code values found within a dm_category_items category';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM statistical_indicator_options
        GROUP BY statistical_indicator_id, option_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate option_code values found within a statistical indicator';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM dm_crimes
        WHERE btrim(crime_name) = ''
           OR crime_name IS NULL
           OR is_active IS NULL
           OR source_document IS NULL
    ) THEN
        RAISE EXCEPTION 'Invalid display/source data found in dm_crimes';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_legal_relationships
        WHERE btrim(relationship_name) = ''
           OR relationship_name IS NULL
           OR is_active IS NULL
           OR (
                source_document IS NULL
                AND relationship_code NOT LIKE '%general_review_required'
           )
    ) THEN
        RAISE EXCEPTION 'Invalid display/source data found in dm_legal_relationships';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_crimes c
        LEFT JOIN dm_penal_code_articles a ON a.article_id = c.article_id
        WHERE c.crime_code NOT LIKE 'excel_crime_%'
          AND (c.article_id IS NULL OR a.article_id IS NULL)
    ) THEN
        RAISE EXCEPTION 'Invalid FK from dm_crimes to dm_penal_code_articles';
    END IF;
END $$;

DO $$
DECLARE
    missing_codes TEXT;
BEGIN
    SELECT string_agg(code, ', ' ORDER BY code)
    INTO missing_codes
    FROM (
        VALUES
            ('case_type'),
            ('participant_type'),
            ('document_type'),
            ('appellate_result'),
            ('fault_classification')
    ) AS required(code)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dm_categories c
        WHERE c.category_code = required.code
    );

    IF missing_codes IS NOT NULL THEN
        RAISE EXCEPTION 'Missing required dm_categories: %', missing_codes;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dm_trial_result_types WHERE is_active IS TRUE) THEN
        RAISE EXCEPTION 'Missing active trial result types';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dm_appellate_result_codes WHERE is_active IS TRUE) THEN
        RAISE EXCEPTION 'Missing active appellate result codes';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dm_fault_classifications WHERE is_active IS TRUE) THEN
        RAISE EXCEPTION 'Missing active fault classifications';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dm_defendant_statistical_features WHERE is_active IS TRUE) THEN
        RAISE EXCEPTION 'Missing active defendant statistical features';
    END IF;
END $$;

ROLLBACK;

SELECT 'legal_seed_data_integrity_test passed' AS result;
