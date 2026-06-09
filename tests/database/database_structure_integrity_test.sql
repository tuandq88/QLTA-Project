\set ON_ERROR_STOP on

-- Test cấu trúc tổng hợp cho unified schema hoặc chuỗi migration chuẩn.
-- Test này không seed dữ liệu thật.

BEGIN;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_tables(table_name) AS (
        VALUES
            ('courts'), ('users'), ('judge_profiles'), ('dm_categories'), ('dm_category_items'),
            ('case_files'), ('participants'), ('documents'), ('hearings'), ('decisions'),
            ('case_assignments'), ('case_events'), ('deadlines'), ('validation_results'), ('audit_logs'),
            ('civil_case_details'), ('criminal_case_details'), ('defendants'), ('charges'),
            ('administrative_case_details'),
            ('assignment_batches'), ('assignment_batch_cases'), ('assignment_batch_judges'),
            ('judge_status_periods'), ('judge_case_conflicts'), ('judge_workload_snapshots'),
            ('judge_replacement_history'), ('assignment_audit_logs'),
            ('appellate_trackings'), ('appeal_protest_items'), ('appellate_results'),
            ('appellate_fault_assessments'), ('appellate_followup_actions'), ('appellate_status_history'),
            ('statistical_categories'), ('statistical_indicators'), ('statistical_indicator_options'),
            ('statistical_indicator_applicability'), ('entity_statistical_attributes'),
            ('dm_statistical_forms'), ('dm_statistical_form_items'), ('dm_statistical_metrics'),
            ('statistics_periods'), ('statistics_snapshots'), ('kpi_metrics'), ('kpi_values')
    )
    SELECT array_agg(table_name)
    INTO missing_items
    FROM expected_tables
    WHERE to_regclass('public.' || table_name) IS NULL;

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Thiếu bảng bắt buộc: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_fk(source_table, target_table) AS (
        VALUES
            ('users', 'courts'),
            ('judge_profiles', 'users'),
            ('case_files', 'courts'),
            ('case_assignments', 'case_files'),
            ('case_assignments', 'users'),
            ('participants', 'case_files'),
            ('documents', 'case_files'),
            ('hearings', 'case_files'),
            ('decisions', 'case_files'),
            ('deadlines', 'case_files'),
            ('civil_case_details', 'case_files'),
            ('criminal_case_details', 'case_files'),
            ('defendants', 'criminal_case_details'),
            ('charges', 'defendants'),
            ('administrative_case_details', 'case_files'),
            ('assignment_batches', 'courts'),
            ('assignment_batch_cases', 'assignment_batches'),
            ('assignment_batch_judges', 'assignment_batches'),
            ('appellate_trackings', 'case_files'),
            ('appeal_protest_items', 'appellate_trackings'),
            ('appellate_results', 'appellate_trackings'),
            ('statistics_snapshots', 'statistics_periods'),
            ('kpi_values', 'kpi_metrics'),
            ('kpi_values', 'statistics_periods'),
            ('dm_category_items', 'dm_categories'),
            ('statistical_indicators', 'statistical_categories'),
            ('statistical_indicator_options', 'statistical_indicators'),
            ('dm_statistical_form_items', 'dm_statistical_forms')
    )
    SELECT array_agg(source_table || ' -> ' || target_table)
    INTO missing_items
    FROM expected_fk
    WHERE NOT EXISTS (
        SELECT 1
        FROM pg_constraint con
        JOIN pg_class src ON src.oid = con.conrelid
        JOIN pg_class tgt ON tgt.oid = con.confrelid
        JOIN pg_namespace ns_src ON ns_src.oid = src.relnamespace
        JOIN pg_namespace ns_tgt ON ns_tgt.oid = tgt.relnamespace
        WHERE con.contype = 'f'
          AND ns_src.nspname = 'public'
          AND ns_tgt.nspname = 'public'
          AND src.relname = expected_fk.source_table
          AND tgt.relname = expected_fk.target_table
    );

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Thiếu FK quan trọng: %', missing_items;
    END IF;
END $$;

DO $$
DECLARE
    missing_items text[];
BEGIN
    WITH expected_indexes(index_name) AS (
        VALUES
            ('idx_users_court'),
            ('idx_case_files_court'),
            ('idx_case_files_type_status'),
            ('idx_case_assignments_case'),
            ('idx_case_assignments_user'),
            ('idx_statistics_period_metric'),
            ('idx_kpi_values_period_court'),
            ('idx_assignment_batches_court_date'),
            ('idx_appellate_trackings_original_case'),
            ('idx_dm_categories_active_sort'),
            ('idx_dm_category_items_category_active_sort'),
            ('idx_statistical_categories_active_sort'),
            ('idx_statistical_indicators_category'),
            ('idx_dm_statistical_form_items_form')
    )
    SELECT array_agg(index_name)
    INTO missing_items
    FROM expected_indexes
    WHERE to_regclass('public.' || index_name) IS NULL;

    IF missing_items IS NOT NULL THEN
        RAISE EXCEPTION 'Thiếu index/unique constraint quan trọng: %', missing_items;
    END IF;
END $$;

ROLLBACK;

DO $$
BEGIN
    RAISE NOTICE 'PASSED: database_structure_integrity_test.sql';
END $$;
