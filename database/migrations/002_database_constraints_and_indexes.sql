-- Migration 002: additive constraints and indexes for QLTA unified schema.
-- Scope: no DROP, no data rewrite, no business table/column rename.
-- Run after database/schema/unified_postgresql_schema.sql.

-- ---------------------------------------------------------------------
-- Master data and core case duplicate prevention
-- ---------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_courts_parent_not_self') THEN
        ALTER TABLE courts
            ADD CONSTRAINT chk_courts_parent_not_self
            CHECK (parent_court_id IS NULL OR parent_court_id <> court_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_case_files_closed_after_acceptance') THEN
        ALTER TABLE case_files
            ADD CONSTRAINT chk_case_files_closed_after_acceptance
            CHECK (closed_date IS NULL OR acceptance_date IS NULL OR closed_date >= acceptance_date);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email_lower
    ON users (lower(email))
    WHERE email IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_profiles_judge_code
    ON judge_profiles (judge_code)
    WHERE judge_code IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_files_court_number_type
    ON case_files (court_id, case_number, case_type)
    WHERE case_number IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_participants_case_identity
    ON participants (
        case_id,
        participant_type,
        COALESCE(id_number, ''),
        COALESCE(full_name, ''),
        COALESCE(organization_name, '')
    )
    WHERE id_number IS NOT NULL OR full_name IS NOT NULL OR organization_name IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_documents_case_type_number
    ON documents (case_id, document_type, document_number)
    WHERE document_number IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_assignments_active_primary
    ON case_assignments (case_id)
    WHERE is_primary IS TRUE AND status = 'active';

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_assignments_active_user_role
    ON case_assignments (case_id, user_id, assignment_role)
    WHERE status = 'active';

CREATE UNIQUE INDEX IF NOT EXISTS uq_hearings_case_type_datetime
    ON hearings (case_id, hearing_type, scheduled_date, scheduled_time)
    WHERE scheduled_date IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_decisions_case_type_number
    ON decisions (case_id, decision_type, decision_number)
    WHERE decision_number IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_appeals_case_type_appellant_date
    ON appeals (case_id, appeal_type, appellant_name, appeal_date)
    WHERE appellant_name IS NOT NULL AND appeal_date IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_deadlines_case_type_start
    ON deadlines (case_id, deadline_type, start_date)
    WHERE start_date IS NOT NULL;

-- ---------------------------------------------------------------------
-- Specialized case modules
-- ---------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_preventive_measures_end_after_start') THEN
        ALTER TABLE preventive_measures
            ADD CONSTRAINT chk_preventive_measures_end_after_start
            CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_admin_enforcement_compliance_after_due') THEN
        ALTER TABLE admin_enforcement_tracking
            ADD CONSTRAINT chk_admin_enforcement_compliance_after_due
            CHECK (compliance_date IS NULL OR obligation_due_date IS NULL OR compliance_date >= obligation_due_date);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_civil_claims_detail_claim_parties
    ON civil_claims (
        civil_detail_id,
        claim_type,
        COALESCE(claimant_name, ''),
        COALESCE(respondent_name, '')
    )
    WHERE claimant_name IS NOT NULL OR respondent_name IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_mediation_sessions_detail_date
    ON mediation_sessions (civil_detail_id, mediation_date)
    WHERE mediation_date IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_defendants_detail_name_dob
    ON defendants (criminal_detail_id, full_name, date_of_birth)
    WHERE full_name IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_charges_defendant_crime_article
    ON charges (
        defendant_id,
        crime_name,
        COALESCE(penal_code_article, ''),
        COALESCE(clause_point, '')
    )
    WHERE crime_name IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_victims_detail_identity
    ON victims (
        criminal_detail_id,
        COALESCE(full_name, ''),
        COALESCE(organization_name, '')
    )
    WHERE full_name IS NOT NULL OR organization_name IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_investigation_returns_detail_date_reason
    ON investigation_returns (criminal_detail_id, return_date, return_reason)
    WHERE return_date IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_challenged_admin_objects_detail_number
    ON challenged_admin_objects (admin_detail_id, object_type, object_number)
    WHERE object_number IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_dialogue_sessions_detail_date
    ON dialogue_sessions (admin_detail_id, dialogue_date)
    WHERE dialogue_date IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_admin_enforcement_detail_decision
    ON admin_enforcement_tracking (admin_detail_id, decision_id)
    WHERE decision_id IS NOT NULL;

-- ---------------------------------------------------------------------
-- Statistics and KPI
-- ---------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_statistics_snapshots_metric_nonnegative') THEN
        ALTER TABLE statistics_snapshots
            ADD CONSTRAINT chk_statistics_snapshots_metric_nonnegative
            CHECK (metric_value >= 0);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_kpi_values_actual_nonnegative') THEN
        ALTER TABLE kpi_values
            ADD CONSTRAINT chk_kpi_values_actual_nonnegative
            CHECK (actual_value >= 0);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_kpi_values_target_nonnegative') THEN
        ALTER TABLE kpi_values
            ADD CONSTRAINT chk_kpi_values_target_nonnegative
            CHECK (target_value IS NULL OR target_value >= 0);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_statistics_snapshots_period_scope_metric
    ON statistics_snapshots (
        period_id,
        COALESCE(court_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(case_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(statistic_form_code, ''),
        metric_code,
        COALESCE(aggregation_level, '')
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_statistics_periods_type_range
    ON statistics_periods (period_type, start_date, end_date);

CREATE UNIQUE INDEX IF NOT EXISTS uq_kpi_values_metric_period_scope
    ON kpi_values (
        metric_id,
        period_id,
        COALESCE(court_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(judge_id, '00000000-0000-0000-0000-000000000000'::uuid)
    );

-- ---------------------------------------------------------------------
-- Random assignment
-- ---------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignment_batch_cases_order_positive') THEN
        ALTER TABLE assignment_batch_cases
            ADD CONSTRAINT chk_assignment_batch_cases_order_positive
            CHECK (case_order > 0);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignment_batch_judges_order_positive') THEN
        ALTER TABLE assignment_batch_judges
            ADD CONSTRAINT chk_assignment_batch_judges_order_positive
            CHECK (judge_order IS NULL OR judge_order > 0);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignment_batch_judges_counts_nonnegative') THEN
        ALTER TABLE assignment_batch_judges
            ADD CONSTRAINT chk_assignment_batch_judges_counts_nonnegative
            CHECK (
                active_case_count >= 0
                AND suspended_case_count >= 0
                AND overdue_case_count >= 0
                AND subjective_cancel_modify_count_1y >= 0
            );
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_judge_workload_counts_nonnegative') THEN
        ALTER TABLE judge_workload_snapshots
            ADD CONSTRAINT chk_judge_workload_counts_nonnegative
            CHECK (
                active_case_count >= 0
                AND suspended_case_count >= 0
                AND overdue_case_count >= 0
                AND subjective_cancel_modify_count_1y >= 0
                AND annual_assigned_count >= 0
                AND annual_resolved_count >= 0
            );
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_assignment_batches_integrity_hash
    ON assignment_batches (integrity_hash)
    WHERE integrity_hash IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_assignment_batch_judges_order
    ON assignment_batch_judges (assignment_batch_id, judge_order)
    WHERE judge_order IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_status_periods_start
    ON judge_status_periods (judge_id, status_type, start_date);

CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_workload_snapshot_group
    ON judge_workload_snapshots (
        judge_id,
        snapshot_date,
        COALESCE(case_group, '')
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_case_conflicts_type
    ON judge_case_conflicts (
        case_id,
        judge_id,
        COALESCE(conflict_type, '')
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_replacement_history_event
    ON judge_replacement_history (assignment_id, replacement_date, old_judge_id, new_judge_id);

-- ---------------------------------------------------------------------
-- Appeal/protest tracking
-- ---------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_appeal_protest_items_not_both') THEN
        ALTER TABLE appeal_protest_items
            ADD CONSTRAINT chk_appeal_protest_items_not_both
            CHECK (item_type::text IN ('APPEAL', 'PROTEST'));
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_appellate_tracking_resolved_has_result') THEN
        ALTER TABLE appellate_trackings
            ADD CONSTRAINT chk_appellate_tracking_resolved_has_result
            CHECK (tracking_status <> 'resolved' OR final_result_code IS NOT NULL);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_appellate_fault_subjective_requires_reason') THEN
        ALTER TABLE appellate_fault_assessments
            ADD CONSTRAINT chk_appellate_fault_subjective_requires_reason
            CHECK (fault_classification <> 'subjective' OR fault_reason_group IS NOT NULL);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_trackings_case_decision_type
    ON appellate_trackings (
        original_case_id,
        COALESCE(original_decision_id, '00000000-0000-0000-0000-000000000000'::uuid),
        appeal_protest_type
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_appeal_protest_items_document
    ON appeal_protest_items (
        appellate_tracking_id,
        item_type,
        COALESCE(document_number, ''),
        received_date,
        COALESCE(appellant_participant_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(protest_agency_name, '')
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_results_tracking_result
    ON appellate_results (
        appellate_tracking_id,
        result_code,
        result_date,
        COALESCE(result_number, '')
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_fault_assessments_scope
    ON appellate_fault_assessments (
        appellate_result_id,
        fault_classification,
        COALESCE(responsible_judge_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(fault_reason_group, '')
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_followup_actions_scope
    ON appellate_followup_actions (
        appellate_tracking_id,
        action_type,
        COALESCE(assigned_to, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(due_date, '0001-01-01'::date)
    );

CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_status_history_event
    ON appellate_status_history (appellate_tracking_id, new_status, changed_at);

-- ---------------------------------------------------------------------
-- Validation, AI and audit layer
-- ---------------------------------------------------------------------

CREATE UNIQUE INDEX IF NOT EXISTS uq_validation_results_open_rule_field
    ON validation_results (
        case_id,
        rule_code,
        COALESCE(field_name, '')
    )
    WHERE validation_status = 'open';

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_risk_flags_open_rule
    ON case_risk_flags (
        case_id,
        risk_type,
        COALESCE(source_rule_code, '')
    )
    WHERE status = 'open';

-- ---------------------------------------------------------------------
-- Read-path indexes: dashboard, assignment, appeal/protest, KPI, audit
-- ---------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_case_files_dashboard_status
    ON case_files (court_id, case_type, case_status, acceptance_date);

CREATE INDEX IF NOT EXISTS idx_case_files_closed_dashboard
    ON case_files (court_id, closed_date, case_type)
    WHERE closed_date IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_case_files_assignment_pool
    ON case_files (court_id, acceptance_date, case_number)
    WHERE case_status = 'accepted';

CREATE INDEX IF NOT EXISTS idx_case_events_case_time
    ON case_events (case_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_case_assignments_user_status
    ON case_assignments (user_id, status, assigned_date);

CREATE INDEX IF NOT EXISTS idx_hearings_schedule
    ON hearings (case_id, scheduled_date, scheduled_time);

CREATE INDEX IF NOT EXISTS idx_deadlines_status_due
    ON deadlines (deadline_status, due_date);

CREATE INDEX IF NOT EXISTS idx_validation_results_status_severity
    ON validation_results (validation_status, severity, checked_at DESC);

CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_dashboard
    ON statistics_snapshots (period_id, court_id, metric_code);

CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_metric_time
    ON statistics_snapshots (metric_code, calculated_at DESC);

CREATE INDEX IF NOT EXISTS idx_kpi_values_dashboard
    ON kpi_values (period_id, court_id, judge_id);

CREATE INDEX IF NOT EXISTS idx_kpi_values_metric_time
    ON kpi_values (metric_id, calculated_at DESC);

CREATE INDEX IF NOT EXISTS idx_assignment_batches_court_status_date
    ON assignment_batches (court_id, status, batch_date DESC);

CREATE INDEX IF NOT EXISTS idx_assignment_batch_cases_batch_order
    ON assignment_batch_cases (assignment_batch_id, case_order);

CREATE INDEX IF NOT EXISTS idx_assignment_batch_judges_batch_order
    ON assignment_batch_judges (assignment_batch_id, judge_order);

CREATE INDEX IF NOT EXISTS idx_judge_status_periods_lookup
    ON judge_status_periods (judge_id, start_date, end_date);

CREATE INDEX IF NOT EXISTS idx_judge_case_conflicts_status
    ON judge_case_conflicts (case_id, judge_id, status);

CREATE INDEX IF NOT EXISTS idx_assignment_audit_logs_batch_time
    ON assignment_audit_logs (assignment_batch_id, event_time DESC);

CREATE INDEX IF NOT EXISTS idx_appellate_trackings_upper_status
    ON appellate_trackings (upper_court_id, tracking_status, upper_court_acceptance_date);

CREATE INDEX IF NOT EXISTS idx_appellate_trackings_original_received
    ON appellate_trackings (original_court_id, received_date);

CREATE INDEX IF NOT EXISTS idx_appellate_trackings_final_result
    ON appellate_trackings (final_result_code, resolved_date);

CREATE INDEX IF NOT EXISTS idx_appeal_protest_items_status
    ON appeal_protest_items (appellate_tracking_id, item_type, status);

CREATE INDEX IF NOT EXISTS idx_appellate_results_tracking_date
    ON appellate_results (appellate_tracking_id, result_date DESC);

CREATE INDEX IF NOT EXISTS idx_appellate_fault_judge
    ON appellate_fault_assessments (responsible_judge_id, fault_classification)
    WHERE responsible_judge_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_appellate_followup_status_due
    ON appellate_followup_actions (status, due_date);

CREATE INDEX IF NOT EXISTS idx_ai_suggestions_pending
    ON ai_suggestions (case_id, status, confidence DESC)
    WHERE status IN ('draft', 'pending_review');

CREATE INDEX IF NOT EXISTS idx_case_risk_flags_open
    ON case_risk_flags (case_id, severity, created_at DESC)
    WHERE status = 'open';

CREATE INDEX IF NOT EXISTS idx_audit_logs_record_time
    ON audit_logs (table_name, record_id, action_at DESC);
