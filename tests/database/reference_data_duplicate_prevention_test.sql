\set ON_ERROR_STOP on

-- Usage:
--   psql "$DATABASE_URL" -f database/schema/unified_postgresql_schema.sql
--   psql "$DATABASE_URL" -f database/migrations/003_reference_data_and_foreign_keys.sql
--   psql "$DATABASE_URL" -f database/seed/003_reference_data_seed.sql
--   psql "$DATABASE_URL" -f tests/database/reference_data_duplicate_prevention_test.sql

BEGIN;

DO $$
DECLARE
    v_category_id uuid;
    v_case_group_category_id uuid;
    v_document_type_category_id uuid;
BEGIN
    SELECT category_id INTO v_category_id
    FROM dm_categories
    WHERE category_code = 'case_group';

    BEGIN
        INSERT INTO dm_categories (category_code, category_name)
        VALUES ('case_group', 'Duplicate case group');
        RAISE EXCEPTION 'Expected duplicate category_code to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    BEGIN
        INSERT INTO dm_category_items (category_id, item_code, item_name)
        VALUES (v_category_id, 'civil', 'Duplicate civil');
        RAISE EXCEPTION 'Expected duplicate item_code in same category to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    SELECT category_id INTO v_case_group_category_id
    FROM dm_categories WHERE category_code = 'case_group';

    SELECT category_id INTO v_document_type_category_id
    FROM dm_categories WHERE category_code = 'document_type';

    INSERT INTO dm_category_items (category_id, item_code, item_name)
    VALUES (v_document_type_category_id, 'civil', 'Civil code allowed in another category');

    BEGIN
        INSERT INTO dm_table_reference_columns (
            category_id, table_name, source_column_name, reference_column_name
        )
        VALUES (
            v_case_group_category_id, 'case_files', 'case_group', 'case_group_id'
        );
        RAISE EXCEPTION 'Expected duplicate binding to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;
END $$;

ROLLBACK;

SELECT 'reference_data_duplicate_prevention_test passed' AS result;
