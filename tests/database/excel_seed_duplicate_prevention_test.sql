BEGIN;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM dm_category_items
        GROUP BY category_id, item_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate item_code within dm_category_items category';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM statistical_indicator_options
        GROUP BY statistical_indicator_id, option_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate option_code within statistical_indicator_options indicator';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_legal_relationships
        GROUP BY relationship_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate relationship_code in dm_legal_relationships';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_crimes
        GROUP BY crime_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate crime_code in dm_crimes';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM dm_trial_result_types
        GROUP BY result_code
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate result_code in dm_trial_result_types';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM defendant_statistical_option_values
        GROUP BY defendant_id, option_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate defendant statistical option value';
    END IF;
END $$;

ROLLBACK;

SELECT 'excel_seed_duplicate_prevention_test passed' AS result;
