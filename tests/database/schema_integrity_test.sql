\set ON_ERROR_STOP on

-- Schema integrity test for unified schema + migration 002.
-- Usage:
--   psql "$DATABASE_URL" -f database/schema/unified_postgresql_schema.sql
--   psql "$DATABASE_URL" -f database/migrations/002_database_constraints_and_indexes.sql
--   psql "$DATABASE_URL" -f tests/database/schema_integrity_test.sql

BEGIN;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_indexes(index_name) AS (
        VALUES
            ('uq_case_files_court_number_type'),
            ('uq_case_assignments_active_primary'),
            ('uq_statistics_periods_type_range'),
            ('uq_statistics_snapshots_period_scope_metric'),
            ('uq_kpi_values_metric_period_scope'),
            ('uq_appellate_trackings_case_decision_type'),
            ('uq_appeal_protest_items_document'),
            ('uq_validation_results_open_rule_field'),
            ('uq_case_risk_flags_open_rule'),
            ('idx_case_files_dashboard_status'),
            ('idx_assignment_batches_court_status_date'),
            ('idx_appellate_trackings_upper_status'),
            ('idx_validation_results_status_severity'),
            ('idx_audit_logs_record_time')
    )
    SELECT array_agg(index_name)
    INTO missing_items
    FROM expected_indexes
    WHERE to_regclass('public.' || index_name) IS NULL;

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected indexes: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_constraints(con_name) AS (
        VALUES
            ('chk_courts_parent_not_self'),
            ('chk_case_files_closed_after_acceptance'),
            ('chk_preventive_measures_end_after_start'),
            ('chk_statistics_snapshots_metric_nonnegative'),
            ('chk_kpi_values_actual_nonnegative'),
            ('chk_assignment_batch_cases_order_positive'),
            ('chk_appeal_protest_items_not_both'),
            ('chk_appellate_fault_subjective_requires_reason')
    )
    SELECT array_agg(con_name)
    INTO missing_items
    FROM expected_constraints
    WHERE NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = con_name
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected constraints: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_fk(source_table, target_table) AS (
        VALUES
            ('case_files', 'courts'),
            ('case_assignments', 'case_files'),
            ('case_assignments', 'users'),
            ('civil_case_details', 'case_files'),
            ('criminal_case_details', 'case_files'),
            ('administrative_case_details', 'case_files'),
            ('assignment_batch_cases', 'assignment_batches'),
            ('assignment_batch_cases', 'case_files'),
            ('assignment_batch_judges', 'assignment_batches'),
            ('assignment_batch_judges', 'users'),
            ('appellate_trackings', 'case_files'),
            ('appellate_results', 'appellate_trackings'),
            ('validation_results', 'case_files'),
            ('ai_suggestions', 'case_files'),
            ('audit_logs', 'users')
    )
    SELECT array_agg(source_table || ' -> ' || target_table)
    INTO missing_items
    FROM expected_fk
    WHERE NOT EXISTS (
        SELECT 1
        FROM pg_constraint c
        JOIN pg_class src ON src.oid = c.conrelid
        JOIN pg_class dst ON dst.oid = c.confrelid
        WHERE c.contype = 'f'
          AND src.relname = source_table
          AND dst.relname = target_table
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected foreign keys: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_enums(enum_name) AS (
        VALUES
            ('court_level_enum'),
            ('user_role_enum'),
            ('case_type_enum'),
            ('case_status_enum'),
            ('assignment_method_enum'),
            ('assignment_status_enum'),
            ('appeal_protest_type_enum'),
            ('fault_classification_enum'),
            ('validation_severity_enum')
    )
    SELECT array_agg(enum_name)
    INTO missing_items
    FROM expected_enums
    WHERE NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = enum_name
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected enums: %', missing_items;
    END IF;
END $$;

ROLLBACK;

SELECT 'schema_integrity_test passed' AS result;
