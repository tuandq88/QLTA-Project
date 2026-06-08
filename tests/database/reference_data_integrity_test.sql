\set ON_ERROR_STOP on

-- Usage:
--   psql "$DATABASE_URL" -f database/schema/unified_postgresql_schema.sql
--   psql "$DATABASE_URL" -f database/migrations/002_database_constraints_and_indexes.sql
--   psql "$DATABASE_URL" -f database/migrations/003_reference_data_and_foreign_keys.sql
--   psql "$DATABASE_URL" -f database/seed/003_reference_data_seed.sql
--   psql "$DATABASE_URL" -f tests/database/reference_data_integrity_test.sql

BEGIN;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_tables(table_name) AS (
        VALUES ('dm_categories'), ('dm_category_items'), ('dm_table_reference_columns')
    )
    SELECT array_agg(table_name)
    INTO missing_items
    FROM expected_tables
    WHERE to_regclass('public.' || table_name) IS NULL;

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing reference tables: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_categories(category_code) AS (
        VALUES
            ('case_type'), ('case_group'), ('procedure_law'), ('case_stage'),
            ('case_status'), ('participant_type'), ('document_type'),
            ('decision_type'), ('deadline_type'), ('validation_rule'),
            ('kpi_group'), ('appeal_protest_type'), ('appellate_result'),
            ('fault_classification'), ('assignment_role'), ('tracking_status'),
            ('period_type'), ('aggregation_level'), ('risk_type'), ('audit_action')
    )
    SELECT array_agg(category_code)
    INTO missing_items
    FROM expected_categories
    WHERE NOT EXISTS (
        SELECT 1 FROM dm_categories c WHERE c.category_code = expected_categories.category_code
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing seeded categories: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_columns(table_name, column_name) AS (
        VALUES
            ('case_files', 'case_group_id'),
            ('case_files', 'procedure_law_id'),
            ('participants', 'participant_type_id'),
            ('documents', 'document_type_id'),
            ('decisions', 'decision_type_id'),
            ('deadlines', 'deadline_type_id'),
            ('validation_results', 'rule_id'),
            ('kpi_metrics', 'metric_group_id'),
            ('appellate_trackings', 'tracking_status_id'),
            ('appellate_results', 'result_code_id'),
            ('case_risk_flags', 'risk_type_id'),
            ('audit_logs', 'action_id')
    )
    SELECT array_agg(table_name || '.' || column_name)
    INTO missing_items
    FROM expected_columns
    WHERE NOT EXISTS (
        SELECT 1
        FROM information_schema.columns c
        WHERE c.table_schema = 'public'
          AND c.table_name = expected_columns.table_name
          AND c.column_name = expected_columns.column_name
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing reference columns: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_fk(table_name, column_name) AS (
        VALUES
            ('case_files', 'case_group_id'),
            ('participants', 'participant_type_id'),
            ('documents', 'document_type_id'),
            ('deadlines', 'deadline_type_id'),
            ('validation_results', 'rule_id'),
            ('kpi_metrics', 'metric_group_id'),
            ('appellate_results', 'result_code_id'),
            ('case_risk_flags', 'risk_type_id')
    )
    SELECT array_agg(table_name || '.' || column_name)
    INTO missing_items
    FROM expected_fk
    WHERE NOT EXISTS (
        SELECT 1
        FROM pg_constraint con
        JOIN pg_class rel ON rel.oid = con.conrelid
        JOIN pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
        JOIN pg_class ref ON ref.oid = con.confrelid
        WHERE con.contype = 'f'
          AND rel.relname = expected_fk.table_name
          AND att.attname = expected_fk.column_name
          AND ref.relname = 'dm_category_items'
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing reference foreign keys: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    v_court_id uuid;
    v_case_group_id uuid;
BEGIN
    SELECT i.item_id
    INTO v_case_group_id
    FROM dm_category_items i
    JOIN dm_categories c ON c.category_id = i.category_id
    WHERE c.category_code = 'case_group' AND i.item_code = 'civil';

    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('REF-TST-001', 'Toa an test reference', 'province')
    RETURNING court_id INTO v_court_id;

    INSERT INTO case_files (case_code, case_number, case_type, case_status, court_id, case_group_id)
    VALUES ('REF-CASE-001', 'REF/001', 'civil', 'accepted', v_court_id, v_case_group_id);

    BEGIN
        INSERT INTO case_files (case_code, case_number, case_type, case_status, court_id, case_group_id)
        VALUES ('REF-CASE-002', 'REF/002', 'civil', 'accepted', v_court_id, uuid_generate_v4());
        RAISE EXCEPTION 'Expected invalid reference item FK to fail';
    EXCEPTION WHEN foreign_key_violation THEN
        NULL;
    END;
END $$;

ROLLBACK;

SELECT 'reference_data_integrity_test passed' AS result;
