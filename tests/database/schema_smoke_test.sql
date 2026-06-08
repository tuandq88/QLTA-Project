\set ON_ERROR_STOP on

BEGIN;

DO $$
DECLARE
    missing_tables text[];
    missing_enums text[];
    missing_fks text[];

    v_court_id uuid := uuid_generate_v4();
    v_upper_court_id uuid := uuid_generate_v4();
    v_judge_id uuid := uuid_generate_v4();
    v_clerk_id uuid := uuid_generate_v4();
    v_civil_case_id uuid := uuid_generate_v4();
    v_criminal_case_id uuid := uuid_generate_v4();
    v_admin_case_id uuid := uuid_generate_v4();
    v_participant_id uuid := uuid_generate_v4();
    v_document_id uuid := uuid_generate_v4();
    v_decision_id uuid := uuid_generate_v4();
    v_assignment_id uuid := uuid_generate_v4();
    v_batch_id uuid := uuid_generate_v4();
    v_civil_detail_id uuid := uuid_generate_v4();
    v_criminal_detail_id uuid := uuid_generate_v4();
    v_defendant_id uuid := uuid_generate_v4();
    v_admin_detail_id uuid := uuid_generate_v4();
    v_period_id uuid := uuid_generate_v4();
    v_metric_id uuid := uuid_generate_v4();
    v_tracking_id uuid := uuid_generate_v4();
    v_result_id uuid := uuid_generate_v4();
BEGIN
    SELECT array_agg(table_name)
    INTO missing_tables
    FROM unnest(ARRAY[
        'courts',
        'users',
        'judge_profiles',
        'case_files',
        'participants',
        'documents',
        'case_events',
        'case_assignments',
        'hearings',
        'decisions',
        'appeals',
        'civil_case_details',
        'civil_claims',
        'mediation_sessions',
        'criminal_case_details',
        'defendants',
        'charges',
        'preventive_measures',
        'sentences',
        'victims',
        'investigation_returns',
        'administrative_case_details',
        'challenged_admin_objects',
        'dialogue_sessions',
        'admin_enforcement_tracking',
        'assignment_batches',
        'assignment_batch_cases',
        'assignment_batch_judges',
        'judge_status_periods',
        'judge_workload_snapshots',
        'judge_case_conflicts',
        'judge_replacement_history',
        'assignment_audit_logs',
        'appellate_trackings',
        'appeal_protest_items',
        'appellate_results',
        'appellate_fault_assessments',
        'appellate_followup_actions',
        'appellate_status_history',
        'statistics_periods',
        'statistics_snapshots',
        'kpi_metrics',
        'kpi_values',
        'deadlines',
        'validation_results',
        'ai_suggestions',
        'case_risk_flags',
        'audit_logs'
    ]) AS expected(table_name)
    WHERE to_regclass(format('public.%I', table_name)) IS NULL;

    IF missing_tables IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected tables: %', missing_tables;
    END IF;

    SELECT array_agg(type_name)
    INTO missing_enums
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
        SELECT 1
        FROM pg_type
        WHERE typname = expected.type_name
    );

    IF missing_enums IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected enum types: %', missing_enums;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_enum e
        JOIN pg_type t ON t.oid = e.enumtypid
        WHERE t.typname = 'case_type_enum' AND e.enumlabel = 'criminal'
    ) THEN
        RAISE EXCEPTION 'case_type_enum is missing value criminal';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_enum e
        JOIN pg_type t ON t.oid = e.enumtypid
        WHERE t.typname = 'assignment_method_enum' AND e.enumlabel = 'RANDOM'
    ) THEN
        RAISE EXCEPTION 'assignment_method_enum is missing value RANDOM';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_enum e
        JOIN pg_type t ON t.oid = e.enumtypid
        WHERE t.typname = 'fault_classification_enum' AND e.enumlabel = 'subjective'
    ) THEN
        RAISE EXCEPTION 'fault_classification_enum is missing value subjective';
    END IF;

    SELECT array_agg(source_table || ' -> ' || target_table)
    INTO missing_fks
    FROM (
        VALUES
            ('users', 'courts'),
            ('case_files', 'courts'),
            ('participants', 'case_files'),
            ('documents', 'case_files'),
            ('case_assignments', 'case_files'),
            ('case_assignments', 'users'),
            ('hearings', 'case_files'),
            ('decisions', 'case_files'),
            ('civil_case_details', 'case_files'),
            ('criminal_case_details', 'case_files'),
            ('defendants', 'criminal_case_details'),
            ('administrative_case_details', 'case_files'),
            ('assignment_batches', 'courts'),
            ('assignment_batch_cases', 'assignment_batches'),
            ('assignment_batch_cases', 'case_files'),
            ('assignment_batch_judges', 'assignment_batches'),
            ('assignment_batch_judges', 'users'),
            ('appellate_trackings', 'case_files'),
            ('appellate_trackings', 'decisions'),
            ('appeal_protest_items', 'appellate_trackings'),
            ('appellate_results', 'appellate_trackings'),
            ('appellate_fault_assessments', 'appellate_results'),
            ('statistics_snapshots', 'statistics_periods'),
            ('kpi_values', 'kpi_metrics'),
            ('kpi_values', 'statistics_periods'),
            ('validation_results', 'case_files'),
            ('ai_suggestions', 'case_files'),
            ('case_risk_flags', 'case_files')
    ) AS expected(source_table, target_table)
    WHERE NOT EXISTS (
        SELECT 1
        FROM pg_constraint c
        JOIN pg_class src ON src.oid = c.conrelid
        JOIN pg_class tgt ON tgt.oid = c.confrelid
        WHERE c.contype = 'f'
          AND src.relname = expected.source_table
          AND tgt.relname = expected.target_table
    );

    IF missing_fks IS NOT NULL THEN
        RAISE EXCEPTION 'Missing expected foreign keys: %', missing_fks;
    END IF;

    INSERT INTO courts (court_id, court_code, court_name, court_level)
    VALUES
        (v_court_id, 'TQG_TEST_01', 'TAND Test Quang Ngai', 'province'),
        (v_upper_court_id, 'TQG_TEST_02', 'TAND Upper Test', 'upper');

    INSERT INTO users (user_id, court_id, full_name, role_code)
    VALUES
        (v_judge_id, v_court_id, 'Tham phan Test', 'judge'),
        (v_clerk_id, v_court_id, 'Thu ky Test', 'clerk');

    INSERT INTO judge_profiles (user_id, judge_code, judge_title, is_active_for_assignment)
    VALUES (v_judge_id, 'JUDGE_TEST', 'Tham phan', true);

    INSERT INTO case_files (case_id, court_id, case_code, case_number, case_type, case_status, acceptance_date)
    VALUES
        (v_civil_case_id, v_court_id, 'CASE_CIVIL_TEST', '01/2026/TLST-DS', 'civil', 'accepted', CURRENT_DATE),
        (v_criminal_case_id, v_court_id, 'CASE_CRIMINAL_TEST', '02/2026/TLST-HS', 'criminal', 'accepted', CURRENT_DATE),
        (v_admin_case_id, v_court_id, 'CASE_ADMIN_TEST', '03/2026/TLST-HC', 'administrative', 'accepted', CURRENT_DATE);

    INSERT INTO participants (participant_id, case_id, participant_type, full_name)
    VALUES (v_participant_id, v_civil_case_id, 'plaintiff', 'Duong su Test');

    INSERT INTO documents (document_id, case_id, document_type, document_number, file_name)
    VALUES (v_document_id, v_civil_case_id, 'judgment', '01/2026/DS-ST', 'judgment-test.pdf');

    INSERT INTO case_events (case_id, event_type, event_stage, performed_by, source_document_id, description)
    VALUES (v_civil_case_id, 'accepted', 'first_instance', v_clerk_id, v_document_id, 'Smoke test event');

    INSERT INTO case_assignments (
        assignment_id,
        case_id,
        user_id,
        assignment_role,
        assignment_method,
        assigned_by,
        legal_basis
    )
    VALUES (
        v_assignment_id,
        v_civil_case_id,
        v_judge_id,
        'primary_judge',
        'RANDOM',
        v_clerk_id,
        'Smoke test legal basis'
    );

    INSERT INTO hearings (case_id, hearing_type, scheduled_date, hearing_status)
    VALUES (v_civil_case_id, 'first_instance', CURRENT_DATE, 'scheduled');

    INSERT INTO decisions (decision_id, case_id, decision_type, decision_number, decision_date, document_id)
    VALUES (v_decision_id, v_civil_case_id, 'judgment', '01/2026/DS-ST', CURRENT_DATE, v_document_id);

    INSERT INTO appeals (case_id, appeal_type, appellant_type, appellant_name, appeal_date)
    VALUES (v_civil_case_id, 'APPEAL', 'participant', 'Duong su Test', CURRENT_DATE);

    INSERT INTO deadlines (case_id, deadline_type, start_date, due_date, deadline_status)
    VALUES (v_civil_case_id, 'prepare_trial', CURRENT_DATE, CURRENT_DATE + 30, 'normal');

    INSERT INTO validation_results (case_id, rule_code, severity, validation_status, message)
    VALUES (v_civil_case_id, 'SMOKE_VALIDATION', 'INFO', 'closed', 'Smoke validation passed');

    INSERT INTO civil_case_details (civil_detail_id, case_id, civil_category, dispute_type)
    VALUES (v_civil_detail_id, v_civil_case_id, 'civil', 'contract');

    INSERT INTO civil_claims (civil_detail_id, claim_type, claimant_name, respondent_name)
    VALUES (v_civil_detail_id, 'money', 'A', 'B');

    INSERT INTO mediation_sessions (civil_detail_id, mediation_date, mediation_status)
    VALUES (v_civil_detail_id, CURRENT_DATE, 'scheduled');

    INSERT INTO criminal_case_details (criminal_detail_id, case_id, procuracy_name, indictment_number)
    VALUES (v_criminal_detail_id, v_criminal_case_id, 'VKS Test', 'CT-01');

    INSERT INTO defendants (defendant_id, criminal_detail_id, full_name)
    VALUES (v_defendant_id, v_criminal_detail_id, 'Bi cao Test');

    INSERT INTO charges (defendant_id, crime_name, penal_code_article)
    VALUES (v_defendant_id, 'Toi danh test', '123');

    INSERT INTO preventive_measures (defendant_id, measure_type, start_date, status)
    VALUES (v_defendant_id, 'detention', CURRENT_DATE, 'active');

    INSERT INTO sentences (defendant_id, sentence_type, imprisonment_years)
    VALUES (v_defendant_id, 'imprisonment', 1);

    INSERT INTO victims (criminal_detail_id, full_name)
    VALUES (v_criminal_detail_id, 'Bi hai Test');

    INSERT INTO investigation_returns (criminal_detail_id, return_date, return_reason)
    VALUES (v_criminal_detail_id, CURRENT_DATE, 'Smoke return');

    INSERT INTO administrative_case_details (admin_detail_id, case_id, lawsuit_type, defendant_agency_name)
    VALUES (v_admin_detail_id, v_admin_case_id, 'administrative_decision', 'UBND Test');

    INSERT INTO challenged_admin_objects (admin_detail_id, object_type, object_number)
    VALUES (v_admin_detail_id, 'decision', 'QD-01');

    INSERT INTO dialogue_sessions (admin_detail_id, dialogue_date, dialogue_status)
    VALUES (v_admin_detail_id, CURRENT_DATE, 'scheduled');

    INSERT INTO admin_enforcement_tracking (admin_detail_id, decision_id, obligated_agency, enforcement_status)
    VALUES (v_admin_detail_id, v_decision_id, 'UBND Test', 'pending');

    INSERT INTO assignment_batches (
        assignment_batch_id,
        court_id,
        assignment_method,
        created_by,
        decided_by,
        status
    )
    VALUES (v_batch_id, v_court_id, 'RANDOM', v_clerk_id, v_judge_id, 'completed');

    UPDATE case_assignments
    SET assignment_batch_id = v_batch_id
    WHERE assignment_id = v_assignment_id;

    INSERT INTO assignment_batch_cases (assignment_batch_id, case_id, case_order, assignment_method, is_assigned)
    VALUES (v_batch_id, v_civil_case_id, 1, 'RANDOM', true);

    INSERT INTO assignment_batch_judges (assignment_batch_id, judge_id, judge_order, eligible)
    VALUES (v_batch_id, v_judge_id, 1, true);

    INSERT INTO judge_status_periods (judge_id, status_type, start_date, description, decision_document_id)
    VALUES (v_judge_id, 'training', CURRENT_DATE, 'Smoke status period', v_document_id);

    INSERT INTO judge_workload_snapshots (judge_id, court_id, snapshot_date, case_group)
    VALUES (v_judge_id, v_court_id, CURRENT_DATE, 'civil');

    INSERT INTO judge_case_conflicts (case_id, judge_id, conflict_type, detected_by, status)
    VALUES (v_civil_case_id, v_judge_id, 'smoke_conflict', v_clerk_id, 'pending');

    INSERT INTO judge_replacement_history (assignment_id, old_judge_id, new_judge_id, replacement_date, decided_by)
    VALUES (v_assignment_id, v_judge_id, v_judge_id, CURRENT_DATE, v_judge_id);

    INSERT INTO assignment_audit_logs (assignment_batch_id, actor_id, action, detail)
    VALUES (v_batch_id, v_clerk_id, 'smoke_test', 'Smoke audit log');

    INSERT INTO appellate_trackings (
        appellate_tracking_id,
        original_case_id,
        original_decision_id,
        original_court_id,
        upper_court_id,
        case_type,
        appeal_protest_type,
        received_date,
        tracking_status
    )
    VALUES (
        v_tracking_id,
        v_civil_case_id,
        v_decision_id,
        v_court_id,
        v_upper_court_id,
        'civil',
        'APPEAL',
        CURRENT_DATE,
        'received'
    );

    INSERT INTO appeal_protest_items (
        appellate_tracking_id,
        item_type,
        appellant_participant_id,
        source_document_id,
        received_date,
        status
    )
    VALUES (v_tracking_id, 'APPEAL', v_participant_id, v_document_id, CURRENT_DATE, 'active');

    INSERT INTO appellate_results (
        appellate_result_id,
        appellate_tracking_id,
        result_document_id,
        result_date,
        result_code
    )
    VALUES (v_result_id, v_tracking_id, v_document_id, CURRENT_DATE, 'UPHELD');

    INSERT INTO appellate_fault_assessments (
        appellate_result_id,
        fault_classification,
        responsible_court_id,
        responsible_judge_id,
        assessment_date
    )
    VALUES (v_result_id, 'unknown', v_court_id, v_judge_id, CURRENT_DATE);

    INSERT INTO appellate_followup_actions (appellate_tracking_id, action_type, status)
    VALUES (v_tracking_id, 'statistics_update', 'pending');

    INSERT INTO appellate_status_history (appellate_tracking_id, old_status, new_status, changed_by)
    VALUES (v_tracking_id, 'draft', 'received', v_clerk_id);

    INSERT INTO statistics_periods (period_id, period_type, start_date, end_date, report_year)
    VALUES (v_period_id, 'month', CURRENT_DATE, CURRENT_DATE, EXTRACT(YEAR FROM CURRENT_DATE)::integer);

    INSERT INTO statistics_snapshots (
        period_id,
        court_id,
        case_id,
        statistic_form_code,
        metric_code,
        metric_value,
        aggregation_level
    )
    VALUES (v_period_id, v_court_id, v_civil_case_id, 'SMOKE_FORM', 'SMOKE_METRIC', 1, 'case');

    INSERT INTO kpi_metrics (metric_id, metric_code, metric_name, metric_group)
    VALUES (v_metric_id, 'SMOKE_KPI', 'Smoke KPI', 'test');

    INSERT INTO kpi_values (metric_id, period_id, court_id, judge_id, actual_value)
    VALUES (v_metric_id, v_period_id, v_court_id, v_judge_id, 1);

    INSERT INTO ai_suggestions (case_id, suggestion_type, content, confidence)
    VALUES (v_civil_case_id, 'smoke', 'Smoke suggestion', 0.9);

    INSERT INTO case_risk_flags (case_id, risk_type, severity, message)
    VALUES (v_civil_case_id, 'smoke', 'INFO', 'Smoke risk flag');

    INSERT INTO audit_logs (table_name, record_id, action, actor_id)
    VALUES ('case_files', v_civil_case_id, 'smoke_test', v_clerk_id);

    RAISE NOTICE 'schema smoke test passed';
END $$;

ROLLBACK;
