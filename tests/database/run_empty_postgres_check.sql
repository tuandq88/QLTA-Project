\set ON_ERROR_STOP on

-- Aggregate empty PostgreSQL check for unified schema + migrations + seed.
-- Run after schema, migrations and seed have completed.

DO $$
DECLARE
    missing_tables text[];
    missing_types text[];
    missing_constraints text[];
    missing_indexes text[];
BEGIN
    SELECT array_agg(table_name)
    INTO missing_tables
    FROM unnest(ARRAY[
        'courts',
        'users',
        'case_files',
        'participants',
        'documents',
        'hearings',
        'decisions',
        'case_assignments',
        'civil_case_details',
        'criminal_case_details',
        'defendants',
        'charges',
        'administrative_case_details',
        'assignment_batches',
        'appellate_trackings',
        'statistics_periods',
        'statistics_snapshots',
        'kpi_metrics',
        'kpi_values',
        'dm_categories',
        'dm_category_items',
        'statistical_categories',
        'statistical_indicators',
        'statistical_indicator_options',
        'entity_statistical_attributes',
        'dm_defendant_statistical_features',
        'dm_legal_relationships',
        'dm_trial_result_types',
        'dm_appellate_result_codes',
        'dm_statistical_metrics'
    ]) AS expected(table_name)
    WHERE to_regclass('public.' || expected.table_name) IS NULL;

    IF missing_tables IS NOT NULL THEN
        RAISE EXCEPTION 'Missing required tables: %', missing_tables;
    END IF;

    SELECT array_agg(type_name)
    INTO missing_types
    FROM unnest(ARRAY[
        'court_level_enum',
        'user_role_enum',
        'case_type_enum',
        'case_status_enum',
        'assignment_method_enum',
        'assignment_status_enum',
        'appeal_protest_type_enum',
        'fault_classification_enum',
        'validation_severity_enum'
    ]) AS expected(type_name)
    WHERE NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = expected.type_name
    );

    IF missing_types IS NOT NULL THEN
        RAISE EXCEPTION 'Missing required enum/type: %', missing_types;
    END IF;

    SELECT array_agg(con_name)
    INTO missing_constraints
    FROM unnest(ARRAY[
        'chk_courts_parent_not_self',
        'chk_case_files_closed_after_acceptance',
        'chk_statistics_snapshots_metric_nonnegative',
        'chk_kpi_values_actual_nonnegative',
        'chk_appeal_protest_items_not_both',
        'fk_charges_crime_id_dm_crimes',
        'fk_decisions_trial_result_type',
        'fk_appellate_trackings_final_result_code',
        'fk_statistics_snapshots_metric_catalog'
    ]) AS expected(con_name)
    WHERE NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = expected.con_name
    );

    IF missing_constraints IS NOT NULL THEN
        RAISE EXCEPTION 'Missing required constraints/FKs: %', missing_constraints;
    END IF;

    SELECT array_agg(index_name)
    INTO missing_indexes
    FROM unnest(ARRAY[
        'uq_case_files_court_number_type',
        'uq_statistics_snapshots_period_scope_metric',
        'uq_kpi_values_metric_period_scope',
        'uq_dm_category_items_category_code',
        'uq_case_legal_relationship_primary',
        'uq_entity_statistical_attribute_value_scope',
        'idx_statistical_indicators_category',
        'idx_statistics_snapshots_metric_id'
    ]) AS expected(index_name)
    WHERE to_regclass('public.' || expected.index_name) IS NULL;

    IF missing_indexes IS NOT NULL THEN
        RAISE EXCEPTION 'Missing required indexes: %', missing_indexes;
    END IF;
END $$;

SELECT 'run_empty_postgres_check.sql passed' AS result;
