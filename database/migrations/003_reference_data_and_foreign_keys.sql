-- Migration 003: reference data foundation and nullable foreign keys.
-- Scope: additive only. Do not drop legacy text/enum columns.
-- Run after unified schema and migration 002.

CREATE TABLE IF NOT EXISTS dm_categories (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_code VARCHAR(100) NOT NULL UNIQUE,
    category_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_system BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dm_categories_code_format
        CHECK (category_code ~ '^[a-z][a-z0-9_]*$'),
    CONSTRAINT chk_dm_categories_sort_order_nonnegative
        CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS dm_category_items (
    item_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES dm_categories(category_id) ON DELETE RESTRICT,
    item_code VARCHAR(150) NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    parent_item_id UUID REFERENCES dm_category_items(item_id) ON DELETE RESTRICT,
    description TEXT,
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    valid_from DATE,
    valid_to DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dm_category_items_category_code UNIQUE (category_id, item_code),
    CONSTRAINT chk_dm_category_items_code_format
        CHECK (item_code ~ '^[A-Za-z0-9_.:-]+$'),
    CONSTRAINT chk_dm_category_items_sort_order_nonnegative
        CHECK (sort_order >= 0),
    CONSTRAINT chk_dm_category_items_valid_range
        CHECK (valid_to IS NULL OR valid_from IS NULL OR valid_to >= valid_from)
);

CREATE TABLE IF NOT EXISTS dm_table_reference_columns (
    binding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES dm_categories(category_id) ON DELETE RESTRICT,
    table_name VARCHAR(100) NOT NULL,
    source_column_name VARCHAR(100),
    reference_column_name VARCHAR(100) NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    migration_phase INTEGER NOT NULL DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dm_table_reference_columns_phase_positive
        CHECK (migration_phase > 0)
);

CREATE INDEX IF NOT EXISTS idx_dm_categories_active_sort
    ON dm_categories (is_active, sort_order, category_code);

CREATE INDEX IF NOT EXISTS idx_dm_category_items_category_active_sort
    ON dm_category_items (category_id, is_active, sort_order, item_code);

CREATE INDEX IF NOT EXISTS idx_dm_category_items_parent
    ON dm_category_items (parent_item_id);

CREATE INDEX IF NOT EXISTS idx_dm_table_reference_columns_table
    ON dm_table_reference_columns (table_name, reference_column_name);

CREATE UNIQUE INDEX IF NOT EXISTS uq_dm_table_reference_columns_scope
    ON dm_table_reference_columns (
        category_id,
        table_name,
        COALESCE(source_column_name, ''),
        reference_column_name
    );

DO $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT * FROM (VALUES
            ('courts', 'court_level_id'),
            ('users', 'role_id'),
            ('case_files', 'case_type_id'),
            ('case_files', 'case_status_id'),
            ('case_files', 'case_group_id'),
            ('case_files', 'procedure_law_id'),
            ('case_files', 'current_stage_id'),
            ('case_files', 'resolution_status_id'),
            ('participants', 'participant_type_id'),
            ('documents', 'document_type_id'),
            ('case_events', 'event_type_id'),
            ('case_events', 'event_stage_id'),
            ('case_assignments', 'assignment_role_id'),
            ('case_assignments', 'designated_reason_id'),
            ('hearings', 'hearing_type_id'),
            ('hearings', 'hearing_status_id'),
            ('decisions', 'decision_type_id'),
            ('decisions', 'result_code_id'),
            ('appeals', 'appeal_type_id'),
            ('appeals', 'appellant_type_id'),
            ('appeals', 'appeal_status_id'),
            ('deadlines', 'deadline_type_id'),
            ('deadlines', 'deadline_status_id'),
            ('deadlines', 'warning_level_id'),
            ('validation_results', 'rule_id'),
            ('validation_results', 'severity_id'),
            ('validation_results', 'validation_status_id'),
            ('civil_case_details', 'civil_category_id'),
            ('civil_case_details', 'dispute_type_id'),
            ('civil_case_details', 'mediation_result_id'),
            ('civil_claims', 'claim_type_id'),
            ('civil_claims', 'claim_status_id'),
            ('mediation_sessions', 'mediation_status_id'),
            ('mediation_sessions', 'result_id'),
            ('criminal_case_details', 'trial_panel_type_id'),
            ('defendants', 'gender_id'),
            ('defendants', 'criminal_record_status_id'),
            ('charges', 'crime_severity_id'),
            ('preventive_measures', 'measure_type_id'),
            ('preventive_measures', 'status_id'),
            ('sentences', 'sentence_type_id'),
            ('victims', 'claim_status_id'),
            ('administrative_case_details', 'lawsuit_type_id'),
            ('administrative_case_details', 'agency_level_id'),
            ('challenged_admin_objects', 'object_type_id'),
            ('challenged_admin_objects', 'legality_review_result_id'),
            ('dialogue_sessions', 'dialogue_status_id'),
            ('dialogue_sessions', 'result_id'),
            ('admin_enforcement_tracking', 'enforcement_status_id'),
            ('statistics_periods', 'period_type_id'),
            ('statistics_snapshots', 'statistic_form_id'),
            ('statistics_snapshots', 'case_group_id'),
            ('statistics_snapshots', 'aggregation_level_id'),
            ('kpi_metrics', 'metric_group_id'),
            ('kpi_values', 'status_id'),
            ('judge_profiles', 'judge_title_id'),
            ('judge_profiles', 'specialized_group_id'),
            ('assignment_batch_cases', 'case_group_id'),
            ('assignment_batch_cases', 'designated_reason_id'),
            ('assignment_batch_judges', 'specialized_group_id'),
            ('judge_status_periods', 'status_type_id'),
            ('judge_case_conflicts', 'conflict_type_id'),
            ('judge_case_conflicts', 'status_id'),
            ('judge_replacement_history', 'replacement_reason_id'),
            ('assignment_audit_logs', 'action_id'),
            ('assignment_batches', 'assignment_method_id'),
            ('assignment_batches', 'status_id'),
            ('case_assignments', 'assignment_method_id'),
            ('case_assignments', 'status_id'),
            ('appellate_trackings', 'appeal_deadline_status_id'),
            ('appellate_trackings', 'appeal_protest_type_id'),
            ('appellate_trackings', 'tracking_status_id'),
            ('appellate_trackings', 'final_result_id'),
            ('appellate_trackings', 'deadline_basis_id'),
            ('appellate_trackings', 'fault_classification_id'),
            ('appeal_protest_items', 'item_type_id'),
            ('appeal_protest_items', 'subtype_id'),
            ('appeal_protest_items', 'status_id'),
            ('appellate_results', 'result_code_id'),
            ('appellate_results', 'result_scope_id'),
            ('appellate_fault_assessments', 'fault_classification_id'),
            ('appellate_fault_assessments', 'fault_reason_group_id'),
            ('appellate_fault_assessments', 'responsible_level_id'),
            ('appellate_followup_actions', 'action_type_id'),
            ('appellate_followup_actions', 'status_id'),
            ('appellate_status_history', 'old_status_id'),
            ('appellate_status_history', 'new_status_id'),
            ('ai_suggestions', 'suggestion_type_id'),
            ('ai_suggestions', 'status_id'),
            ('case_risk_flags', 'risk_type_id'),
            ('case_risk_flags', 'severity_id'),
            ('case_risk_flags', 'status_id'),
            ('audit_logs', 'action_id')
        ) AS v(table_name, column_name)
    LOOP
        EXECUTE format('ALTER TABLE %I ADD COLUMN IF NOT EXISTS %I UUID', r.table_name, r.column_name);
    END LOOP;
END $$;

DO $$
DECLARE
    r record;
    constraint_name text;
BEGIN
    FOR r IN
        SELECT * FROM (VALUES
            ('courts', 'court_level_id'),
            ('users', 'role_id'),
            ('case_files', 'case_type_id'),
            ('case_files', 'case_status_id'),
            ('case_files', 'case_group_id'),
            ('case_files', 'procedure_law_id'),
            ('case_files', 'current_stage_id'),
            ('case_files', 'resolution_status_id'),
            ('participants', 'participant_type_id'),
            ('documents', 'document_type_id'),
            ('case_events', 'event_type_id'),
            ('case_events', 'event_stage_id'),
            ('case_assignments', 'assignment_role_id'),
            ('case_assignments', 'designated_reason_id'),
            ('hearings', 'hearing_type_id'),
            ('hearings', 'hearing_status_id'),
            ('decisions', 'decision_type_id'),
            ('decisions', 'result_code_id'),
            ('appeals', 'appeal_type_id'),
            ('appeals', 'appellant_type_id'),
            ('appeals', 'appeal_status_id'),
            ('deadlines', 'deadline_type_id'),
            ('deadlines', 'deadline_status_id'),
            ('deadlines', 'warning_level_id'),
            ('validation_results', 'rule_id'),
            ('validation_results', 'severity_id'),
            ('validation_results', 'validation_status_id'),
            ('civil_case_details', 'civil_category_id'),
            ('civil_case_details', 'dispute_type_id'),
            ('civil_case_details', 'mediation_result_id'),
            ('civil_claims', 'claim_type_id'),
            ('civil_claims', 'claim_status_id'),
            ('mediation_sessions', 'mediation_status_id'),
            ('mediation_sessions', 'result_id'),
            ('criminal_case_details', 'trial_panel_type_id'),
            ('defendants', 'gender_id'),
            ('defendants', 'criminal_record_status_id'),
            ('charges', 'crime_severity_id'),
            ('preventive_measures', 'measure_type_id'),
            ('preventive_measures', 'status_id'),
            ('sentences', 'sentence_type_id'),
            ('victims', 'claim_status_id'),
            ('administrative_case_details', 'lawsuit_type_id'),
            ('administrative_case_details', 'agency_level_id'),
            ('challenged_admin_objects', 'object_type_id'),
            ('challenged_admin_objects', 'legality_review_result_id'),
            ('dialogue_sessions', 'dialogue_status_id'),
            ('dialogue_sessions', 'result_id'),
            ('admin_enforcement_tracking', 'enforcement_status_id'),
            ('statistics_periods', 'period_type_id'),
            ('statistics_snapshots', 'statistic_form_id'),
            ('statistics_snapshots', 'case_group_id'),
            ('statistics_snapshots', 'aggregation_level_id'),
            ('kpi_metrics', 'metric_group_id'),
            ('kpi_values', 'status_id'),
            ('judge_profiles', 'judge_title_id'),
            ('judge_profiles', 'specialized_group_id'),
            ('assignment_batch_cases', 'case_group_id'),
            ('assignment_batch_cases', 'designated_reason_id'),
            ('assignment_batch_judges', 'specialized_group_id'),
            ('judge_status_periods', 'status_type_id'),
            ('judge_case_conflicts', 'conflict_type_id'),
            ('judge_case_conflicts', 'status_id'),
            ('judge_replacement_history', 'replacement_reason_id'),
            ('assignment_audit_logs', 'action_id'),
            ('assignment_batches', 'assignment_method_id'),
            ('assignment_batches', 'status_id'),
            ('case_assignments', 'assignment_method_id'),
            ('case_assignments', 'status_id'),
            ('appellate_trackings', 'appeal_deadline_status_id'),
            ('appellate_trackings', 'appeal_protest_type_id'),
            ('appellate_trackings', 'tracking_status_id'),
            ('appellate_trackings', 'final_result_id'),
            ('appellate_trackings', 'deadline_basis_id'),
            ('appellate_trackings', 'fault_classification_id'),
            ('appeal_protest_items', 'item_type_id'),
            ('appeal_protest_items', 'subtype_id'),
            ('appeal_protest_items', 'status_id'),
            ('appellate_results', 'result_code_id'),
            ('appellate_results', 'result_scope_id'),
            ('appellate_fault_assessments', 'fault_classification_id'),
            ('appellate_fault_assessments', 'fault_reason_group_id'),
            ('appellate_fault_assessments', 'responsible_level_id'),
            ('appellate_followup_actions', 'action_type_id'),
            ('appellate_followup_actions', 'status_id'),
            ('appellate_status_history', 'old_status_id'),
            ('appellate_status_history', 'new_status_id'),
            ('ai_suggestions', 'suggestion_type_id'),
            ('ai_suggestions', 'status_id'),
            ('case_risk_flags', 'risk_type_id'),
            ('case_risk_flags', 'severity_id'),
            ('case_risk_flags', 'status_id'),
            ('audit_logs', 'action_id')
        ) AS v(table_name, column_name)
    LOOP
        constraint_name := 'fk_' || r.table_name || '_' || r.column_name || '_dm_item';
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = constraint_name) THEN
            EXECUTE format(
                'ALTER TABLE %I ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT',
                r.table_name,
                constraint_name,
                r.column_name
            );
        END IF;

        EXECUTE format(
            'CREATE INDEX IF NOT EXISTS %I ON %I (%I)',
            'idx_' || r.table_name || '_' || r.column_name,
            r.table_name,
            r.column_name
        );
    END LOOP;
END $$;
