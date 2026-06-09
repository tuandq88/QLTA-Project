-- Unified PostgreSQL schema for TAND Quang Ngai court management.
-- Source: database diagrams, starter schema, random assignment module,
-- and appeal/protest tracking module.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ---------------------------------------------------------------------
-- Enum types
-- ---------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'court_level_enum') THEN
        CREATE TYPE court_level_enum AS ENUM ('province', 'district', 'regional', 'military', 'upper', 'supreme');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role_enum') THEN
        CREATE TYPE user_role_enum AS ENUM ('chief_judge', 'deputy_chief_judge', 'judge', 'clerk', 'leader', 'admin', 'viewer', 'ai_agent');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'case_type_enum') THEN
        CREATE TYPE case_type_enum AS ENUM (
            'civil',
            'marriage_family',
            'business_commercial',
            'labor',
            'criminal',
            'administrative',
            'civil_matter',
            'bankruptcy',
            'administrative_measure',
            'other'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'case_status_enum') THEN
        CREATE TYPE case_status_enum AS ENUM (
            'draft',
            'received',
            'accepted',
            'preparing',
            'trial_scheduled',
            'resolved',
            'appealed',
            'effective',
            'temporarily_suspended',
            'suspended',
            'overdue',
            'closed'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'assignment_method_enum') THEN
        CREATE TYPE assignment_method_enum AS ENUM ('RANDOM', 'DESIGNATED', 'MIXED');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'assignment_status_enum') THEN
        CREATE TYPE assignment_status_enum AS ENUM ('draft', 'running', 'completed', 'cancelled', 'active', 'replaced');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'appeal_protest_type_enum') THEN
        CREATE TYPE appeal_protest_type_enum AS ENUM ('APPEAL', 'PROTEST', 'BOTH');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'fault_classification_enum') THEN
        CREATE TYPE fault_classification_enum AS ENUM ('objective', 'subjective', 'mixed', 'unknown');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'validation_severity_enum') THEN
        CREATE TYPE validation_severity_enum AS ENUM ('INFO', 'WARNING', 'ERROR', 'CRITICAL');
    END IF;
END $$;

-- ---------------------------------------------------------------------
-- Master data
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS courts (
    court_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_court_id UUID REFERENCES courts(court_id),
    court_code VARCHAR(50) UNIQUE NOT NULL,
    court_name VARCHAR(255) NOT NULL,
    court_level court_level_enum NOT NULL,
    province VARCHAR(100) DEFAULT 'Quảng Ngãi',
    district_area VARCHAR(100),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    court_id UUID REFERENCES courts(court_id),
    full_name VARCHAR(255) NOT NULL,
    position_title VARCHAR(100),
    role_code user_role_enum NOT NULL DEFAULT 'viewer',
    department VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Case core
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS case_files (
    case_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    court_id UUID NOT NULL REFERENCES courts(court_id),
    case_code VARCHAR(100) UNIQUE,
    case_number VARCHAR(100),
    case_type case_type_enum NOT NULL,
    case_group VARCHAR(100),
    procedure_law VARCHAR(50),
    filing_date DATE,
    acceptance_date DATE,
    current_stage VARCHAR(100),
    case_status case_status_enum NOT NULL DEFAULT 'draft',
    resolution_status VARCHAR(100),
    has_foreign_element BOOLEAN DEFAULT FALSE,
    is_minor_related BOOLEAN DEFAULT FALSE,
    is_confidential BOOLEAN DEFAULT FALSE,
    closed_date DATE,
    summary TEXT,
    created_by UUID REFERENCES users(user_id),
    updated_by UUID REFERENCES users(user_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT case_files_acceptance_after_filing CHECK (
        acceptance_date IS NULL OR filing_date IS NULL OR acceptance_date >= filing_date
    )
);

CREATE TABLE IF NOT EXISTS participants (
    participant_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    participant_type VARCHAR(100) NOT NULL,
    full_name VARCHAR(255),
    organization_name VARCHAR(255),
    legal_representative VARCHAR(255),
    id_number VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(20),
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    is_minor BOOLEAN DEFAULT FALSE,
    needs_interpreter BOOLEAN DEFAULT FALSE,
    note TEXT
);

CREATE TABLE IF NOT EXISTS documents (
    document_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    document_type VARCHAR(100) NOT NULL,
    document_number VARCHAR(100),
    document_date DATE,
    issued_by VARCHAR(255),
    file_name VARCHAR(255),
    storage_path TEXT,
    checksum VARCHAR(128),
    is_required BOOLEAN DEFAULT FALSE,
    is_valid BOOLEAN DEFAULT TRUE,
    uploaded_by UUID REFERENCES users(user_id),
    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS case_events (
    event_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    event_type VARCHAR(100) NOT NULL,
    event_stage VARCHAR(100),
    event_date DATE NOT NULL DEFAULT CURRENT_DATE,
    performed_by UUID REFERENCES users(user_id),
    description TEXT,
    source_document_id UUID REFERENCES documents(document_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS case_assignments (
    assignment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(user_id),
    assignment_role VARCHAR(100) NOT NULL DEFAULT 'primary_judge',
    assigned_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_date DATE,
    is_primary BOOLEAN DEFAULT TRUE,
    assignment_method assignment_method_enum,
    assigned_by UUID REFERENCES users(user_id),
    legal_basis TEXT,
    designated_reason_code VARCHAR(100),
    judge_rank_at_assignment INTEGER,
    case_order_at_assignment INTEGER,
    integrity_hash TEXT,
    status assignment_status_enum DEFAULT 'active',
    replacement_reason TEXT
);

CREATE TABLE IF NOT EXISTS hearings (
    hearing_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    hearing_type VARCHAR(100),
    scheduled_date DATE,
    scheduled_time TIME,
    courtroom VARCHAR(100),
    panel_composition TEXT,
    hearing_status VARCHAR(100),
    postponement_reason TEXT,
    actual_opened_date DATE,
    actual_closed_date DATE,
    note TEXT
);

CREATE TABLE IF NOT EXISTS decisions (
    decision_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    decision_type VARCHAR(100) NOT NULL,
    decision_number VARCHAR(100),
    decision_date DATE,
    result_code VARCHAR(100),
    result_summary TEXT,
    is_final BOOLEAN DEFAULT FALSE,
    effective_date DATE,
    document_id UUID REFERENCES documents(document_id)
);

CREATE TABLE IF NOT EXISTS appeals (
    appeal_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    appeal_type VARCHAR(50) NOT NULL,
    appellant_type VARCHAR(100),
    appellant_name VARCHAR(255),
    appeal_date DATE,
    appeal_scope TEXT,
    appeal_status VARCHAR(100),
    appellate_case_id UUID REFERENCES case_files(case_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS deadlines (
    deadline_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    deadline_type VARCHAR(100) NOT NULL,
    start_date DATE,
    due_date DATE,
    completed_date DATE,
    extended_days INTEGER DEFAULT 0,
    deadline_status VARCHAR(50),
    legal_basis TEXT,
    warning_level VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT deadlines_due_after_start CHECK (due_date IS NULL OR start_date IS NULL OR due_date >= start_date)
);

CREATE TABLE IF NOT EXISTS validation_results (
    validation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    rule_code VARCHAR(100) NOT NULL,
    severity validation_severity_enum NOT NULL DEFAULT 'WARNING',
    validation_status VARCHAR(50) NOT NULL DEFAULT 'open',
    message TEXT NOT NULL,
    field_name VARCHAR(100),
    checked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checked_by VARCHAR(100),
    legal_basis TEXT,
    suggested_action TEXT
);

-- ---------------------------------------------------------------------
-- Civil, marriage-family, business-commercial, labor
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS civil_case_details (
    civil_detail_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID UNIQUE NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    civil_category VARCHAR(100),
    dispute_type VARCHAR(255),
    claim_value NUMERIC(18,2),
    jurisdiction_basis TEXT,
    mediation_required BOOLEAN DEFAULT TRUE,
    mediation_completed BOOLEAN DEFAULT FALSE,
    mediation_result VARCHAR(100),
    temporary_measure_requested BOOLEAN DEFAULT FALSE,
    court_fee_advance_paid BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS civil_claims (
    claim_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    civil_detail_id UUID NOT NULL REFERENCES civil_case_details(civil_detail_id) ON DELETE CASCADE,
    claim_type VARCHAR(100),
    claimant_name VARCHAR(255),
    respondent_name VARCHAR(255),
    claim_amount NUMERIC(18,2),
    claim_content TEXT,
    claim_status VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS mediation_sessions (
    mediation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    civil_detail_id UUID NOT NULL REFERENCES civil_case_details(civil_detail_id) ON DELETE CASCADE,
    mediation_date DATE,
    mediation_status VARCHAR(100),
    result VARCHAR(100),
    agreement_content TEXT,
    recognized_by_court BOOLEAN DEFAULT FALSE
);

-- ---------------------------------------------------------------------
-- Criminal module
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS criminal_case_details (
    criminal_detail_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID UNIQUE NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    procuracy_name VARCHAR(255),
    indictment_number VARCHAR(100),
    indictment_date DATE,
    investigation_agency VARCHAR(255),
    dossier_received_date DATE,
    has_civil_claim BOOLEAN DEFAULT FALSE,
    has_minor_defendant BOOLEAN DEFAULT FALSE,
    has_legal_aid BOOLEAN DEFAULT FALSE,
    trial_panel_type VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS defendants (
    defendant_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criminal_detail_id UUID NOT NULL REFERENCES criminal_case_details(criminal_detail_id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    nationality VARCHAR(100),
    ethnicity VARCHAR(100),
    occupation VARCHAR(255),
    residence TEXT,
    criminal_record_status VARCHAR(100),
    is_minor BOOLEAN DEFAULT FALSE,
    is_detained BOOLEAN DEFAULT FALSE,
    detention_start_date DATE,
    detention_end_date DATE
);

CREATE TABLE IF NOT EXISTS charges (
    charge_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    crime_name VARCHAR(255),
    penal_code_article VARCHAR(100),
    clause_point VARCHAR(100),
    crime_severity VARCHAR(100),
    prosecution_decision TEXT,
    court_finding TEXT
);

CREATE TABLE IF NOT EXISTS preventive_measures (
    measure_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    measure_type VARCHAR(100),
    start_date DATE,
    end_date DATE,
    issued_by VARCHAR(255),
    status VARCHAR(100),
    replacement_measure VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS sentences (
    sentence_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    sentence_type VARCHAR(100),
    imprisonment_years NUMERIC(6,2),
    suspended_years NUMERIC(6,2),
    probation_years NUMERIC(6,2),
    fine_amount NUMERIC(18,2),
    additional_penalty TEXT,
    civil_liability TEXT
);

CREATE TABLE IF NOT EXISTS victims (
    victim_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criminal_detail_id UUID NOT NULL REFERENCES criminal_case_details(criminal_detail_id) ON DELETE CASCADE,
    full_name VARCHAR(255),
    organization_name VARCHAR(255),
    injury_rate VARCHAR(50),
    damage_amount NUMERIC(18,2),
    claim_status VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS investigation_returns (
    return_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criminal_detail_id UUID NOT NULL REFERENCES criminal_case_details(criminal_detail_id) ON DELETE CASCADE,
    return_date DATE,
    return_reason TEXT,
    requested_by VARCHAR(255),
    result_after_return TEXT
);

-- ---------------------------------------------------------------------
-- Administrative module
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS administrative_case_details (
    admin_detail_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID UNIQUE NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    lawsuit_type VARCHAR(150),
    defendant_agency_name VARCHAR(255),
    agency_representative VARCHAR(255),
    agency_level VARCHAR(100),
    compensation_claimed BOOLEAN DEFAULT FALSE,
    compensation_amount NUMERIC(18,2),
    urgent_case BOOLEAN DEFAULT FALSE,
    jurisdiction_basis TEXT
);

CREATE TABLE IF NOT EXISTS challenged_admin_objects (
    object_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_detail_id UUID NOT NULL REFERENCES administrative_case_details(admin_detail_id) ON DELETE CASCADE,
    object_type VARCHAR(100),
    object_number VARCHAR(100),
    object_issue_date DATE,
    issuing_agency VARCHAR(255),
    object_summary TEXT,
    challenged_scope TEXT,
    legality_review_result TEXT
);

CREATE TABLE IF NOT EXISTS dialogue_sessions (
    dialogue_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_detail_id UUID NOT NULL REFERENCES administrative_case_details(admin_detail_id) ON DELETE CASCADE,
    dialogue_date DATE,
    dialogue_status VARCHAR(100),
    result VARCHAR(100),
    agreement_content TEXT
);

CREATE TABLE IF NOT EXISTS admin_enforcement_tracking (
    enforcement_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_detail_id UUID NOT NULL REFERENCES administrative_case_details(admin_detail_id) ON DELETE CASCADE,
    decision_id UUID REFERENCES decisions(decision_id),
    obligated_agency VARCHAR(255),
    obligation_due_date DATE,
    compliance_date DATE,
    enforcement_status VARCHAR(100),
    note TEXT
);

-- ---------------------------------------------------------------------
-- Statistics and KPI
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS statistics_periods (
    period_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    period_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    report_year INTEGER,
    report_month INTEGER,
    report_quarter INTEGER,
    CONSTRAINT statistics_periods_valid_range CHECK (end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS statistics_snapshots (
    snapshot_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    period_id UUID NOT NULL REFERENCES statistics_periods(period_id) ON DELETE CASCADE,
    court_id UUID REFERENCES courts(court_id),
    case_id UUID REFERENCES case_files(case_id),
    statistic_form_code VARCHAR(100),
    case_group VARCHAR(100),
    metric_code VARCHAR(100) NOT NULL,
    metric_value NUMERIC(18,2) NOT NULL DEFAULT 0,
    aggregation_level VARCHAR(100),
    source_table VARCHAR(100),
    source_record_id UUID,
    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS kpi_metrics (
    metric_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_code VARCHAR(100) UNIQUE NOT NULL,
    metric_name VARCHAR(255) NOT NULL,
    metric_group VARCHAR(100),
    formula TEXT,
    warning_threshold NUMERIC(18,4),
    target_value NUMERIC(18,4),
    legal_basis TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS kpi_values (
    kpi_value_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_id UUID NOT NULL REFERENCES kpi_metrics(metric_id),
    period_id UUID NOT NULL REFERENCES statistics_periods(period_id),
    court_id UUID REFERENCES courts(court_id),
    judge_id UUID REFERENCES users(user_id),
    actual_value NUMERIC(18,4) NOT NULL DEFAULT 0,
    target_value NUMERIC(18,4),
    status VARCHAR(50),
    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Random assignment module
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS judge_profiles (
    judge_profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(user_id),
    judge_code VARCHAR(100),
    judge_title VARCHAR(100),
    specialized_court_code VARCHAR(100),
    specialized_group VARCHAR(100),
    is_leadership BOOLEAN DEFAULT FALSE,
    leadership_quota NUMERIC(5,2),
    maternity_quota_status BOOLEAN DEFAULT FALSE,
    annual_assignment_quota INTEGER,
    can_handle_minor_cases BOOLEAN DEFAULT FALSE,
    is_active_for_assignment BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS assignment_batches (
    assignment_batch_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    court_id UUID NOT NULL REFERENCES courts(court_id),
    batch_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assignment_method assignment_method_enum NOT NULL,
    created_by UUID REFERENCES users(user_id),
    decided_by UUID REFERENCES users(user_id),
    status assignment_status_enum DEFAULT 'draft',
    algorithm_version VARCHAR(50),
    random_seed_hash TEXT,
    legal_basis TEXT,
    integrity_hash TEXT,
    public_note TEXT
);

CREATE TABLE IF NOT EXISTS assignment_batch_cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assignment_batch_id UUID NOT NULL REFERENCES assignment_batches(assignment_batch_id) ON DELETE CASCADE,
    case_id UUID NOT NULL REFERENCES case_files(case_id),
    case_order INTEGER NOT NULL,
    case_group VARCHAR(100),
    assignment_method assignment_method_enum,
    designated_reason_code VARCHAR(100),
    is_assigned BOOLEAN DEFAULT FALSE,
    UNIQUE (assignment_batch_id, case_id),
    UNIQUE (assignment_batch_id, case_order)
);

CREATE TABLE IF NOT EXISTS assignment_batch_judges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assignment_batch_id UUID NOT NULL REFERENCES assignment_batches(assignment_batch_id) ON DELETE CASCADE,
    judge_id UUID NOT NULL REFERENCES users(user_id),
    judge_order INTEGER,
    active_case_count INTEGER DEFAULT 0,
    suspended_case_count INTEGER DEFAULT 0,
    overdue_case_count INTEGER DEFAULT 0,
    subjective_cancel_modify_count_1y INTEGER DEFAULT 0,
    eligible BOOLEAN DEFAULT TRUE,
    exclusion_reason VARCHAR(255),
    specialized_group VARCHAR(100),
    UNIQUE (assignment_batch_id, judge_id)
);

ALTER TABLE case_assignments
    ADD COLUMN IF NOT EXISTS assignment_batch_id UUID REFERENCES assignment_batches(assignment_batch_id);

CREATE TABLE IF NOT EXISTS judge_status_periods (
    status_period_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    judge_id UUID NOT NULL REFERENCES users(user_id),
    status_type VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT,
    decision_document_id UUID REFERENCES documents(document_id),
    CONSTRAINT judge_status_periods_valid_range CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS judge_workload_snapshots (
    snapshot_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    judge_id UUID NOT NULL REFERENCES users(user_id),
    court_id UUID NOT NULL REFERENCES courts(court_id),
    snapshot_date DATE NOT NULL,
    case_group VARCHAR(100),
    active_case_count INTEGER DEFAULT 0,
    suspended_case_count INTEGER DEFAULT 0,
    overdue_case_count INTEGER DEFAULT 0,
    subjective_cancel_modify_count_1y INTEGER DEFAULT 0,
    annual_assigned_count INTEGER DEFAULT 0,
    annual_resolved_count INTEGER DEFAULT 0,
    UNIQUE (judge_id, snapshot_date, case_group)
);

CREATE TABLE IF NOT EXISTS judge_case_conflicts (
    conflict_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    judge_id UUID NOT NULL REFERENCES users(user_id),
    conflict_type VARCHAR(100),
    description TEXT,
    detected_by UUID REFERENCES users(user_id),
    confirmed_by UUID REFERENCES users(user_id),
    status VARCHAR(30) DEFAULT 'pending',
    UNIQUE (case_id, judge_id, conflict_type)
);

CREATE TABLE IF NOT EXISTS judge_replacement_history (
    replacement_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assignment_id UUID NOT NULL REFERENCES case_assignments(assignment_id),
    old_judge_id UUID REFERENCES users(user_id),
    new_judge_id UUID REFERENCES users(user_id),
    replacement_date DATE NOT NULL,
    replacement_reason TEXT,
    decided_by UUID REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS assignment_audit_logs (
    audit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assignment_batch_id UUID NOT NULL REFERENCES assignment_batches(assignment_batch_id) ON DELETE CASCADE,
    event_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actor_id UUID REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    before_data_hash TEXT,
    after_data_hash TEXT,
    detail TEXT
);

-- ---------------------------------------------------------------------
-- Appeal/protest tracking module
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS appellate_trackings (
    appellate_tracking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    original_case_id UUID NOT NULL REFERENCES case_files(case_id),
    original_decision_id UUID NOT NULL REFERENCES decisions(decision_id),
    original_court_id UUID NOT NULL REFERENCES courts(court_id),
    upper_court_id UUID REFERENCES courts(court_id),
    case_type case_type_enum NOT NULL,
    appeal_protest_type appeal_protest_type_enum NOT NULL,
    received_date DATE NOT NULL,
    appeal_deadline_status VARCHAR(50),
    appeal_or_protest_deadline_date DATE,
    deadline_basis_code VARCHAR(100),
    deadline_basis_article VARCHAR(100),
    is_late BOOLEAN,
    late_reason TEXT,
    late_accepted_by_upper_court BOOLEAN,
    tracking_status VARCHAR(50) NOT NULL DEFAULT 'received',
    sent_to_upper_court_date DATE,
    upper_court_acceptance_date DATE,
    upper_court_case_number VARCHAR(100),
    resolved_date DATE,
    final_result_code VARCHAR(100),
    fault_classification fault_classification_enum,
    quality_kpi_impact BOOLEAN,
    note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT appellate_upper_after_sent CHECK (
        upper_court_acceptance_date IS NULL
        OR sent_to_upper_court_date IS NULL
        OR upper_court_acceptance_date >= sent_to_upper_court_date
    ),
    CONSTRAINT appellate_resolved_after_acceptance CHECK (
        resolved_date IS NULL
        OR upper_court_acceptance_date IS NULL
        OR resolved_date >= upper_court_acceptance_date
    )
);

CREATE TABLE IF NOT EXISTS appeal_protest_items (
    item_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id) ON DELETE CASCADE,
    item_type appeal_protest_type_enum NOT NULL,
    subtype VARCHAR(100),
    appellant_participant_id UUID REFERENCES participants(participant_id),
    protest_agency_name VARCHAR(255),
    source_document_id UUID REFERENCES documents(document_id),
    document_number VARCHAR(100),
    document_date DATE,
    received_date DATE NOT NULL,
    scope TEXT,
    content_summary TEXT,
    status VARCHAR(50) DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS appellate_results (
    appellate_result_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id) ON DELETE CASCADE,
    result_document_id UUID REFERENCES documents(document_id),
    result_number VARCHAR(100),
    result_date DATE NOT NULL,
    result_code VARCHAR(100) NOT NULL,
    result_scope VARCHAR(100),
    summary TEXT,
    effective_date DATE,
    requires_retrial BOOLEAN,
    retrial_case_id UUID REFERENCES case_files(case_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS appellate_fault_assessments (
    fault_assessment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appellate_result_id UUID NOT NULL REFERENCES appellate_results(appellate_result_id) ON DELETE CASCADE,
    fault_classification fault_classification_enum NOT NULL,
    fault_reason_group VARCHAR(100),
    responsible_level VARCHAR(100),
    responsible_court_id UUID REFERENCES courts(court_id),
    responsible_judge_id UUID REFERENCES users(user_id),
    assessment_source VARCHAR(255),
    assessment_date DATE,
    approved_by UUID REFERENCES users(user_id),
    description TEXT
);

CREATE TABLE IF NOT EXISTS appellate_followup_actions (
    followup_action_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id) ON DELETE CASCADE,
    action_type VARCHAR(100) NOT NULL,
    due_date DATE,
    completed_date DATE,
    assigned_to UUID REFERENCES users(user_id),
    status VARCHAR(50) DEFAULT 'pending',
    note TEXT
);

CREATE TABLE IF NOT EXISTS appellate_status_history (
    status_history_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id) ON DELETE CASCADE,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_by UUID REFERENCES users(user_id),
    note TEXT
);

-- ---------------------------------------------------------------------
-- AI and audit support
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ai_suggestions (
    suggestion_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    suggestion_type VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    confidence NUMERIC(5,4),
    source_context TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    reviewed_by UUID REFERENCES users(user_id),
    reviewed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS case_risk_flags (
    risk_flag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    risk_type VARCHAR(100) NOT NULL,
    severity validation_severity_enum NOT NULL DEFAULT 'WARNING',
    message TEXT NOT NULL,
    source_rule_code VARCHAR(100),
    status VARCHAR(50) DEFAULT 'open',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit_logs (
    audit_log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID,
    action VARCHAR(50) NOT NULL,
    actor_id UUID REFERENCES users(user_id),
    action_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB,
    integrity_hash TEXT
);

-- ---------------------------------------------------------------------
-- Reference data foundation synchronized from migrations 003 and 004.
-- These tables are required by database/seed/*.sql in UnifiedOnly mode.
-- ---------------------------------------------------------------------

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
    CONSTRAINT chk_dm_categories_code_format CHECK (category_code ~ '^[a-z][a-z0-9_]*$'),
    CONSTRAINT chk_dm_categories_sort_order_nonnegative CHECK (sort_order >= 0)
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
    CONSTRAINT chk_dm_category_items_code_format CHECK (item_code ~ '^[A-Za-z0-9_.:-]+$'),
    CONSTRAINT chk_dm_category_items_sort_order_nonnegative CHECK (sort_order >= 0),
    CONSTRAINT chk_dm_category_items_valid_range CHECK (valid_to IS NULL OR valid_from IS NULL OR valid_to >= valid_from)
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
    CONSTRAINT chk_dm_table_reference_columns_phase_positive CHECK (migration_phase > 0)
);

CREATE TABLE IF NOT EXISTS statistical_categories (
    statistical_category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_code VARCHAR(100) UNIQUE NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    description TEXT,
    case_type_scope VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_statistical_categories_code CHECK (category_code ~ '^[a-z][a-z0-9_]*$'),
    CONSTRAINT chk_statistical_categories_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS statistical_indicators (
    statistical_indicator_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    statistical_category_id UUID NOT NULL REFERENCES statistical_categories(statistical_category_id) ON DELETE RESTRICT,
    indicator_code VARCHAR(150) UNIQUE NOT NULL,
    indicator_name VARCHAR(255) NOT NULL,
    input_control_type VARCHAR(50) NOT NULL,
    value_type VARCHAR(50) NOT NULL DEFAULT 'option',
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    allow_multiple BOOLEAN NOT NULL DEFAULT FALSE,
    applies_to_entity VARCHAR(100) NOT NULL,
    case_type_scope VARCHAR(100),
    legal_basis TEXT,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_statistical_indicators_input_control
        CHECK (input_control_type IN ('dropdown', 'radio', 'checkbox', 'checkbox_group', 'number', 'date', 'text')),
    CONSTRAINT chk_statistical_indicators_value_type
        CHECK (value_type IN ('option', 'boolean', 'numeric', 'date', 'text')),
    CONSTRAINT chk_statistical_indicators_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS statistical_indicator_options (
    option_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE CASCADE,
    option_code VARCHAR(150) NOT NULL,
    option_name TEXT NOT NULL,
    option_value VARCHAR(255),
    parent_option_id UUID REFERENCES statistical_indicator_options(option_id) ON DELETE RESTRICT,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_statistical_indicator_options_code UNIQUE (statistical_indicator_id, option_code),
    CONSTRAINT chk_statistical_indicator_options_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS statistical_indicator_applicability (
    applicability_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE CASCADE,
    case_type VARCHAR(100),
    entity_type VARCHAR(100) NOT NULL,
    procedure_law VARCHAR(100),
    applies_to_court_level VARCHAR(100),
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    note TEXT
);

CREATE TABLE IF NOT EXISTS entity_statistical_attributes (
    attribute_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID NOT NULL,
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE RESTRICT,
    option_id UUID REFERENCES statistical_indicator_options(option_id) ON DELETE RESTRICT,
    boolean_value BOOLEAN,
    numeric_value NUMERIC(18,4),
    text_value TEXT,
    date_value DATE,
    source_table VARCHAR(100),
    source_field VARCHAR(100),
    created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_entity_statistical_attribute_option UNIQUE (entity_type, entity_id, statistical_indicator_id, option_id),
    CONSTRAINT chk_entity_statistical_attribute_one_value CHECK (
        num_nonnulls(option_id, boolean_value, numeric_value, text_value, date_value) = 1
    )
);

CREATE TABLE IF NOT EXISTS dm_penal_code_articles (
    article_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) UNIQUE NOT NULL,
    article_number VARCHAR(50) NOT NULL,
    article_title TEXT,
    chapter VARCHAR(100),
    law_code VARCHAR(100),
    effective_from DATE,
    effective_to DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    source_document TEXT,
    source_url TEXT,
    notes TEXT,
    requires_human_review BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT chk_dm_penal_code_articles_valid_range
        CHECK (effective_to IS NULL OR effective_from IS NULL OR effective_to >= effective_from)
);

CREATE TABLE IF NOT EXISTS dm_crimes (
    crime_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES dm_penal_code_articles(article_id) ON DELETE RESTRICT,
    crime_code VARCHAR(100) UNIQUE NOT NULL,
    crime_name TEXT NOT NULL,
    crime_severity VARCHAR(100),
    default_statistical_group VARCHAR(100),
    legal_basis TEXT,
    source_document TEXT,
    source_url TEXT,
    notes TEXT,
    requires_human_review BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_dm_crimes_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS dm_defendant_statistical_features (
    feature_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    feature_code VARCHAR(100) UNIQUE NOT NULL,
    feature_name VARCHAR(255) NOT NULL,
    input_control_type VARCHAR(50) NOT NULL DEFAULT 'checkbox',
    description TEXT,
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_dm_defendant_features_input CHECK (input_control_type IN ('checkbox', 'radio', 'dropdown')),
    CONSTRAINT chk_dm_defendant_features_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS defendant_statistical_features (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    feature_id UUID NOT NULL REFERENCES dm_defendant_statistical_features(feature_id) ON DELETE RESTRICT,
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    selected BOOLEAN NOT NULL DEFAULT TRUE,
    note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (defendant_id, feature_id)
);

CREATE TABLE IF NOT EXISTS dm_statistical_option_groups (
    group_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_code VARCHAR(100) UNIQUE NOT NULL,
    group_name VARCHAR(255) NOT NULL,
    allow_multiple BOOLEAN NOT NULL DEFAULT FALSE,
    applies_to_entity VARCHAR(100),
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_statistical_options (
    option_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES dm_statistical_option_groups(group_id) ON DELETE CASCADE,
    option_code VARCHAR(100) NOT NULL,
    option_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    UNIQUE (group_id, option_code)
);

CREATE TABLE IF NOT EXISTS defendant_statistical_option_values (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    group_id UUID NOT NULL REFERENCES dm_statistical_option_groups(group_id) ON DELETE RESTRICT,
    option_id UUID NOT NULL REFERENCES dm_statistical_options(option_id) ON DELETE RESTRICT,
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (defendant_id, option_id)
);

CREATE OR REPLACE FUNCTION enforce_defendant_statistical_option_group()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_allow_multiple BOOLEAN;
BEGIN
    SELECT allow_multiple INTO v_allow_multiple
    FROM dm_statistical_option_groups
    WHERE group_id = NEW.group_id;

    IF NOT EXISTS (
        SELECT 1 FROM dm_statistical_options
        WHERE option_id = NEW.option_id AND group_id = NEW.group_id
    ) THEN
        RAISE EXCEPTION 'statistical option % does not belong to group %', NEW.option_id, NEW.group_id;
    END IF;

    IF v_allow_multiple IS FALSE AND EXISTS (
        SELECT 1 FROM defendant_statistical_option_values existing
        WHERE existing.defendant_id = NEW.defendant_id
          AND existing.group_id = NEW.group_id
          AND existing.id <> COALESCE(NEW.id, uuid_nil())
    ) THEN
        RAISE EXCEPTION 'defendant % already has a value for single-select group %', NEW.defendant_id, NEW.group_id;
    END IF;

    RETURN NEW;
END $$;

DO $$
BEGIN
    CREATE TRIGGER trg_defendant_statistical_option_group
    BEFORE INSERT OR UPDATE ON defendant_statistical_option_values
    FOR EACH ROW EXECUTE FUNCTION enforce_defendant_statistical_option_group();
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS dm_legal_relationships (
    legal_relationship_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    relationship_code VARCHAR(150) UNIQUE NOT NULL,
    relationship_name TEXT NOT NULL,
    case_type_scope VARCHAR(100),
    parent_id UUID REFERENCES dm_legal_relationships(legal_relationship_id) ON DELETE RESTRICT,
    legal_basis TEXT,
    source_document TEXT,
    source_url TEXT,
    notes TEXT,
    requires_human_review BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS case_legal_relationships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    legal_relationship_id UUID NOT NULL REFERENCES dm_legal_relationships(legal_relationship_id) ON DELETE RESTRICT,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    note TEXT,
    UNIQUE (case_id, legal_relationship_id)
);

CREATE TABLE IF NOT EXISTS dm_trial_result_types (
    trial_result_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    result_code VARCHAR(100) UNIQUE NOT NULL,
    result_name VARCHAR(255) NOT NULL,
    case_type_scope VARCHAR(100),
    stage_scope VARCHAR(100),
    affects_kpi BOOLEAN NOT NULL DEFAULT TRUE,
    is_final_result BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS decision_result_attributes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    decision_id UUID NOT NULL REFERENCES decisions(decision_id) ON DELETE CASCADE,
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE RESTRICT,
    option_id UUID NOT NULL REFERENCES statistical_indicator_options(option_id) ON DELETE RESTRICT,
    UNIQUE (decision_id, statistical_indicator_id, option_id)
);

CREATE TABLE IF NOT EXISTS dm_appellate_result_codes (
    appellate_result_code_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    result_code VARCHAR(100) UNIQUE NOT NULL,
    result_name VARCHAR(255) NOT NULL,
    is_cancelled BOOLEAN NOT NULL DEFAULT FALSE,
    is_modified BOOLEAN NOT NULL DEFAULT FALSE,
    is_upheld BOOLEAN NOT NULL DEFAULT FALSE,
    is_withdrawn BOOLEAN NOT NULL DEFAULT FALSE,
    requires_fault_classification BOOLEAN NOT NULL DEFAULT FALSE,
    affects_quality_kpi BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_fault_classifications (
    fault_classification_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    classification_code VARCHAR(100) UNIQUE NOT NULL,
    classification_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_fault_reason_groups (
    fault_reason_group_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reason_code VARCHAR(100) UNIQUE NOT NULL,
    reason_name VARCHAR(255) NOT NULL,
    classification_scope VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_appeal_protest_types (
    appeal_protest_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type_code VARCHAR(100) UNIQUE NOT NULL,
    type_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_statistical_forms (
    form_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_code VARCHAR(100) UNIQUE NOT NULL,
    form_name VARCHAR(255) NOT NULL,
    case_type_scope VARCHAR(100),
    report_period_type VARCHAR(100),
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dm_statistical_metrics (
    metric_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_code VARCHAR(100) UNIQUE NOT NULL,
    metric_name VARCHAR(255) NOT NULL,
    metric_group VARCHAR(100),
    value_type VARCHAR(50) NOT NULL DEFAULT 'numeric',
    aggregation_method VARCHAR(50) NOT NULL DEFAULT 'sum',
    formula TEXT,
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dm_statistical_form_items (
    form_item_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES dm_statistical_forms(form_id) ON DELETE CASCADE,
    item_code VARCHAR(150) NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    parent_item_id UUID REFERENCES dm_statistical_form_items(form_item_id) ON DELETE RESTRICT,
    metric_code VARCHAR(100),
    metric_id UUID REFERENCES dm_statistical_metrics(metric_id) ON DELETE RESTRICT,
    input_control_type VARCHAR(50),
    source_table VARCHAR(100),
    source_field VARCHAR(100),
    formula_ref VARCHAR(255),
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (form_id, item_code)
);

-- Nullable FK columns for reference-data and statistical catalogs.
ALTER TABLE courts ADD COLUMN IF NOT EXISTS court_level_id UUID;
ALTER TABLE users ADD COLUMN IF NOT EXISTS role_id UUID;
ALTER TABLE case_files
    ADD COLUMN IF NOT EXISTS case_type_id UUID,
    ADD COLUMN IF NOT EXISTS case_status_id UUID,
    ADD COLUMN IF NOT EXISTS case_group_id UUID,
    ADD COLUMN IF NOT EXISTS procedure_law_id UUID,
    ADD COLUMN IF NOT EXISTS current_stage_id UUID,
    ADD COLUMN IF NOT EXISTS resolution_status_id UUID;
ALTER TABLE participants ADD COLUMN IF NOT EXISTS participant_type_id UUID;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS document_type_id UUID;
ALTER TABLE decisions
    ADD COLUMN IF NOT EXISTS decision_type_id UUID,
    ADD COLUMN IF NOT EXISTS result_code_id UUID,
    ADD COLUMN IF NOT EXISTS trial_result_type_id UUID;
ALTER TABLE deadlines
    ADD COLUMN IF NOT EXISTS deadline_type_id UUID,
    ADD COLUMN IF NOT EXISTS deadline_status_id UUID,
    ADD COLUMN IF NOT EXISTS warning_level_id UUID;
ALTER TABLE validation_results
    ADD COLUMN IF NOT EXISTS rule_id UUID,
    ADD COLUMN IF NOT EXISTS severity_id UUID,
    ADD COLUMN IF NOT EXISTS validation_status_id UUID;
ALTER TABLE kpi_metrics
    ADD COLUMN IF NOT EXISTS metric_group_id UUID,
    ADD COLUMN IF NOT EXISTS statistical_metric_id UUID;
ALTER TABLE statistics_periods ADD COLUMN IF NOT EXISTS period_type_id UUID;
ALTER TABLE statistics_snapshots
    ADD COLUMN IF NOT EXISTS statistic_form_id UUID,
    ADD COLUMN IF NOT EXISTS case_group_id UUID,
    ADD COLUMN IF NOT EXISTS aggregation_level_id UUID,
    ADD COLUMN IF NOT EXISTS metric_id UUID,
    ADD COLUMN IF NOT EXISTS form_item_id UUID;
ALTER TABLE charges
    ADD COLUMN IF NOT EXISTS crime_severity_id UUID,
    ADD COLUMN IF NOT EXISTS crime_id UUID,
    ADD COLUMN IF NOT EXISTS article_id UUID;
ALTER TABLE defendants
    ADD COLUMN IF NOT EXISTS gender_id UUID,
    ADD COLUMN IF NOT EXISTS criminal_record_status_id UUID;
ALTER TABLE civil_case_details
    ADD COLUMN IF NOT EXISTS civil_category_id UUID,
    ADD COLUMN IF NOT EXISTS dispute_type_id UUID,
    ADD COLUMN IF NOT EXISTS mediation_result_id UUID;
ALTER TABLE appellate_trackings
    ADD COLUMN IF NOT EXISTS tracking_status_id UUID,
    ADD COLUMN IF NOT EXISTS final_result_id UUID,
    ADD COLUMN IF NOT EXISTS final_result_code_id UUID,
    ADD COLUMN IF NOT EXISTS appeal_protest_type_catalog_id UUID,
    ADD COLUMN IF NOT EXISTS fault_classification_catalog_id UUID;
ALTER TABLE appellate_results ADD COLUMN IF NOT EXISTS result_code_id UUID;
ALTER TABLE appellate_fault_assessments
    ADD COLUMN IF NOT EXISTS fault_reason_group_id UUID,
    ADD COLUMN IF NOT EXISTS fault_classification_catalog_id UUID,
    ADD COLUMN IF NOT EXISTS fault_reason_group_catalog_id UUID;
ALTER TABLE case_risk_flags
    ADD COLUMN IF NOT EXISTS risk_type_id UUID,
    ADD COLUMN IF NOT EXISTS severity_id UUID,
    ADD COLUMN IF NOT EXISTS status_id UUID;
ALTER TABLE audit_logs ADD COLUMN IF NOT EXISTS action_id UUID;

DO $$
DECLARE
    r record;
    constraint_name text;
BEGIN
    FOR r IN
        SELECT * FROM (VALUES
            ('case_files', 'case_group_id'),
            ('case_files', 'procedure_law_id'),
            ('case_files', 'current_stage_id'),
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
        EXECUTE format('CREATE INDEX IF NOT EXISTS %I ON %I (%I)', 'idx_' || r.table_name || '_' || r.column_name, r.table_name, r.column_name);
    END LOOP;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_charges_crime_id_dm_crimes') THEN
        ALTER TABLE charges ADD CONSTRAINT fk_charges_crime_id_dm_crimes
            FOREIGN KEY (crime_id) REFERENCES dm_crimes(crime_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_charges_article_id_dm_penal_code_articles') THEN
        ALTER TABLE charges ADD CONSTRAINT fk_charges_article_id_dm_penal_code_articles
            FOREIGN KEY (article_id) REFERENCES dm_penal_code_articles(article_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_decisions_trial_result_type') THEN
        ALTER TABLE decisions ADD CONSTRAINT fk_decisions_trial_result_type
            FOREIGN KEY (trial_result_type_id) REFERENCES dm_trial_result_types(trial_result_type_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_trackings_final_result_code') THEN
        ALTER TABLE appellate_trackings ADD CONSTRAINT fk_appellate_trackings_final_result_code
            FOREIGN KEY (final_result_code_id) REFERENCES dm_appellate_result_codes(appellate_result_code_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_trackings_appeal_protest_type_catalog') THEN
        ALTER TABLE appellate_trackings ADD CONSTRAINT fk_appellate_trackings_appeal_protest_type_catalog
            FOREIGN KEY (appeal_protest_type_catalog_id) REFERENCES dm_appeal_protest_types(appeal_protest_type_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_trackings_fault_classification_catalog') THEN
        ALTER TABLE appellate_trackings ADD CONSTRAINT fk_appellate_trackings_fault_classification_catalog
            FOREIGN KEY (fault_classification_catalog_id) REFERENCES dm_fault_classifications(fault_classification_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_fault_classification_catalog') THEN
        ALTER TABLE appellate_fault_assessments ADD CONSTRAINT fk_appellate_fault_classification_catalog
            FOREIGN KEY (fault_classification_catalog_id) REFERENCES dm_fault_classifications(fault_classification_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_fault_reason_group_catalog') THEN
        ALTER TABLE appellate_fault_assessments ADD CONSTRAINT fk_appellate_fault_reason_group_catalog
            FOREIGN KEY (fault_reason_group_id) REFERENCES dm_fault_reason_groups(fault_reason_group_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_statistics_snapshots_metric_catalog') THEN
        ALTER TABLE statistics_snapshots ADD CONSTRAINT fk_statistics_snapshots_metric_catalog
            FOREIGN KEY (metric_id) REFERENCES dm_statistical_metrics(metric_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_statistics_snapshots_form_item') THEN
        ALTER TABLE statistics_snapshots ADD CONSTRAINT fk_statistics_snapshots_form_item
            FOREIGN KEY (form_item_id) REFERENCES dm_statistical_form_items(form_item_id) ON DELETE RESTRICT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_kpi_metrics_statistical_metric') THEN
        ALTER TABLE kpi_metrics ADD CONSTRAINT fk_kpi_metrics_statistical_metric
            FOREIGN KEY (statistical_metric_id) REFERENCES dm_statistical_metrics(metric_id) ON DELETE RESTRICT;
    END IF;
END $$;

-- Stable constraints and indexes synchronized from migration 002 for UnifiedOnly tests.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_courts_parent_not_self') THEN
        ALTER TABLE courts ADD CONSTRAINT chk_courts_parent_not_self
            CHECK (parent_court_id IS NULL OR parent_court_id <> court_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_case_files_closed_after_acceptance') THEN
        ALTER TABLE case_files ADD CONSTRAINT chk_case_files_closed_after_acceptance
            CHECK (closed_date IS NULL OR acceptance_date IS NULL OR closed_date >= acceptance_date);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_preventive_measures_end_after_start') THEN
        ALTER TABLE preventive_measures ADD CONSTRAINT chk_preventive_measures_end_after_start
            CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_statistics_snapshots_metric_nonnegative') THEN
        ALTER TABLE statistics_snapshots ADD CONSTRAINT chk_statistics_snapshots_metric_nonnegative
            CHECK (metric_value >= 0);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_kpi_values_actual_nonnegative') THEN
        ALTER TABLE kpi_values ADD CONSTRAINT chk_kpi_values_actual_nonnegative
            CHECK (actual_value >= 0);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_kpi_values_target_nonnegative') THEN
        ALTER TABLE kpi_values ADD CONSTRAINT chk_kpi_values_target_nonnegative
            CHECK (target_value IS NULL OR target_value >= 0);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_admin_enforcement_compliance_after_due') THEN
        ALTER TABLE admin_enforcement_tracking ADD CONSTRAINT chk_admin_enforcement_compliance_after_due
            CHECK (compliance_date IS NULL OR obligation_due_date IS NULL OR compliance_date >= obligation_due_date);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignment_batch_cases_order_positive') THEN
        ALTER TABLE assignment_batch_cases ADD CONSTRAINT chk_assignment_batch_cases_order_positive
            CHECK (case_order > 0);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignment_batch_judges_order_positive') THEN
        ALTER TABLE assignment_batch_judges ADD CONSTRAINT chk_assignment_batch_judges_order_positive
            CHECK (judge_order IS NULL OR judge_order > 0);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignment_batch_judges_counts_nonnegative') THEN
        ALTER TABLE assignment_batch_judges ADD CONSTRAINT chk_assignment_batch_judges_counts_nonnegative
            CHECK (
                active_case_count >= 0
                AND suspended_case_count >= 0
                AND overdue_case_count >= 0
                AND subjective_cancel_modify_count_1y >= 0
            );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_judge_workload_counts_nonnegative') THEN
        ALTER TABLE judge_workload_snapshots ADD CONSTRAINT chk_judge_workload_counts_nonnegative
            CHECK (
                active_case_count >= 0
                AND suspended_case_count >= 0
                AND overdue_case_count >= 0
                AND subjective_cancel_modify_count_1y >= 0
                AND annual_assigned_count >= 0
                AND annual_resolved_count >= 0
            );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_appeal_protest_items_not_both') THEN
        ALTER TABLE appeal_protest_items ADD CONSTRAINT chk_appeal_protest_items_not_both
            CHECK (item_type::text IN ('APPEAL', 'PROTEST'));
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_appellate_tracking_resolved_has_result') THEN
        ALTER TABLE appellate_trackings ADD CONSTRAINT chk_appellate_tracking_resolved_has_result
            CHECK (tracking_status <> 'resolved' OR final_result_code IS NOT NULL);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_appellate_fault_subjective_requires_reason') THEN
        ALTER TABLE appellate_fault_assessments ADD CONSTRAINT chk_appellate_fault_subjective_requires_reason
            CHECK (fault_classification <> 'subjective' OR fault_reason_group IS NOT NULL);
    END IF;
END $$;

-- ---------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_users_court ON users(court_id);
CREATE INDEX IF NOT EXISTS idx_case_files_court ON case_files(court_id);
CREATE INDEX IF NOT EXISTS idx_case_files_type_status ON case_files(case_type, case_status);
CREATE INDEX IF NOT EXISTS idx_case_files_acceptance_date ON case_files(acceptance_date);
CREATE INDEX IF NOT EXISTS idx_participants_case ON participants(case_id);
CREATE INDEX IF NOT EXISTS idx_documents_case ON documents(case_id);
CREATE INDEX IF NOT EXISTS idx_case_events_case_date ON case_events(case_id, event_date);
CREATE INDEX IF NOT EXISTS idx_case_assignments_case ON case_assignments(case_id);
CREATE INDEX IF NOT EXISTS idx_case_assignments_user ON case_assignments(user_id);
CREATE INDEX IF NOT EXISTS idx_hearings_case ON hearings(case_id);
CREATE INDEX IF NOT EXISTS idx_decisions_case ON decisions(case_id);
CREATE INDEX IF NOT EXISTS idx_deadlines_case_status ON deadlines(case_id, deadline_status);
CREATE INDEX IF NOT EXISTS idx_validation_case_status ON validation_results(case_id, validation_status);
CREATE INDEX IF NOT EXISTS idx_statistics_period_metric ON statistics_snapshots(period_id, metric_code);
CREATE INDEX IF NOT EXISTS idx_kpi_values_period_court ON kpi_values(period_id, court_id);
CREATE INDEX IF NOT EXISTS idx_assignment_batches_court_date ON assignment_batches(court_id, batch_date);
CREATE INDEX IF NOT EXISTS idx_assignment_batch_cases_batch ON assignment_batch_cases(assignment_batch_id);
CREATE INDEX IF NOT EXISTS idx_assignment_batch_judges_batch ON assignment_batch_judges(assignment_batch_id);
CREATE INDEX IF NOT EXISTS idx_judge_workload_judge_date ON judge_workload_snapshots(judge_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_appellate_trackings_original_case ON appellate_trackings(original_case_id);
CREATE INDEX IF NOT EXISTS idx_appellate_trackings_status ON appellate_trackings(tracking_status);
CREATE INDEX IF NOT EXISTS idx_appellate_trackings_final_result ON appellate_trackings(final_result_code);
CREATE INDEX IF NOT EXISTS idx_appellate_fault_responsible_judge ON appellate_fault_assessments(responsible_judge_id);
CREATE INDEX IF NOT EXISTS idx_appellate_fault_classification ON appellate_fault_assessments(fault_classification);

CREATE INDEX IF NOT EXISTS idx_dm_categories_active_sort ON dm_categories(is_active, sort_order, category_code);
CREATE INDEX IF NOT EXISTS idx_dm_category_items_category_active_sort ON dm_category_items(category_id, is_active, sort_order, item_code);
CREATE INDEX IF NOT EXISTS idx_dm_category_items_parent ON dm_category_items(parent_item_id);
CREATE INDEX IF NOT EXISTS idx_dm_table_reference_columns_table ON dm_table_reference_columns(table_name, reference_column_name);
CREATE UNIQUE INDEX IF NOT EXISTS uq_dm_table_reference_columns_scope
    ON dm_table_reference_columns(category_id, table_name, COALESCE(source_column_name, ''), reference_column_name);

CREATE INDEX IF NOT EXISTS idx_statistical_categories_active_sort ON statistical_categories(is_active, sort_order, category_code);
CREATE INDEX IF NOT EXISTS idx_statistical_indicators_category ON statistical_indicators(statistical_category_id, is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_statistical_indicator_options_indicator ON statistical_indicator_options(statistical_indicator_id, is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_stat_indicator_applicability_entity ON statistical_indicator_applicability(entity_type, case_type, is_active);
CREATE UNIQUE INDEX IF NOT EXISTS uq_stat_indicator_applicability_scope
    ON statistical_indicator_applicability(
        statistical_indicator_id,
        COALESCE(case_type, ''),
        entity_type,
        COALESCE(procedure_law, ''),
        COALESCE(applies_to_court_level, '')
    );
CREATE INDEX IF NOT EXISTS idx_entity_stat_attributes_case ON entity_statistical_attributes(case_id);
CREATE INDEX IF NOT EXISTS idx_entity_stat_attributes_entity ON entity_statistical_attributes(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_stat_attributes_indicator ON entity_statistical_attributes(statistical_indicator_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_entity_statistical_attribute_value_scope
    ON entity_statistical_attributes(entity_type, entity_id, statistical_indicator_id, COALESCE(option_id, uuid_nil()));

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_files_court_number_type
    ON case_files(court_id, case_number, case_type)
    WHERE case_number IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_assignments_active_primary
    ON case_assignments(case_id)
    WHERE is_primary IS TRUE AND status = 'active';
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_assignments_active_user_role
    ON case_assignments(case_id, user_id, assignment_role)
    WHERE status = 'active';
CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email_lower
    ON users(lower(email))
    WHERE email IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_profiles_judge_code
    ON judge_profiles(judge_code)
    WHERE judge_code IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_participants_case_identity
    ON participants(case_id, participant_type, COALESCE(id_number, ''), COALESCE(full_name, ''), COALESCE(organization_name, ''))
    WHERE id_number IS NOT NULL OR full_name IS NOT NULL OR organization_name IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_documents_case_type_number
    ON documents(case_id, document_type, document_number)
    WHERE document_number IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_hearings_case_type_datetime
    ON hearings(case_id, hearing_type, scheduled_date, scheduled_time)
    WHERE scheduled_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_decisions_case_type_number
    ON decisions(case_id, decision_type, decision_number)
    WHERE decision_number IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_appeals_case_type_appellant_date
    ON appeals(case_id, appeal_type, appellant_name, appeal_date)
    WHERE appellant_name IS NOT NULL AND appeal_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_deadlines_case_type_start
    ON deadlines(case_id, deadline_type, start_date)
    WHERE start_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_civil_claims_detail_claim_parties
    ON civil_claims(civil_detail_id, claim_type, COALESCE(claimant_name, ''), COALESCE(respondent_name, ''))
    WHERE claimant_name IS NOT NULL OR respondent_name IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_mediation_sessions_detail_date
    ON mediation_sessions(civil_detail_id, mediation_date)
    WHERE mediation_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_defendants_detail_name_dob
    ON defendants(criminal_detail_id, full_name, date_of_birth)
    WHERE full_name IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_charges_defendant_crime_article
    ON charges(defendant_id, crime_name, COALESCE(penal_code_article, ''), COALESCE(clause_point, ''))
    WHERE crime_name IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_victims_detail_identity
    ON victims(criminal_detail_id, COALESCE(full_name, ''), COALESCE(organization_name, ''))
    WHERE full_name IS NOT NULL OR organization_name IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_investigation_returns_detail_date_reason
    ON investigation_returns(criminal_detail_id, return_date, return_reason)
    WHERE return_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_challenged_admin_objects_detail_number
    ON challenged_admin_objects(admin_detail_id, object_type, object_number)
    WHERE object_number IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_dialogue_sessions_detail_date
    ON dialogue_sessions(admin_detail_id, dialogue_date)
    WHERE dialogue_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_admin_enforcement_detail_decision
    ON admin_enforcement_tracking(admin_detail_id, decision_id)
    WHERE decision_id IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_statistics_periods_type_range
    ON statistics_periods(period_type, start_date, end_date);
CREATE UNIQUE INDEX IF NOT EXISTS uq_statistics_snapshots_period_scope_metric
    ON statistics_snapshots(
        period_id,
        COALESCE(court_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(case_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(statistic_form_code, ''),
        metric_code,
        COALESCE(aggregation_level, '')
    );
CREATE UNIQUE INDEX IF NOT EXISTS uq_kpi_values_metric_period_scope
    ON kpi_values(
        metric_id,
        period_id,
        COALESCE(court_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(judge_id, '00000000-0000-0000-0000-000000000000'::uuid)
    );
CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_trackings_case_decision_type
    ON appellate_trackings(
        original_case_id,
        COALESCE(original_decision_id, '00000000-0000-0000-0000-000000000000'::uuid),
        appeal_protest_type
    );
CREATE UNIQUE INDEX IF NOT EXISTS uq_appeal_protest_items_document
    ON appeal_protest_items(
        appellate_tracking_id,
        item_type,
        COALESCE(document_number, ''),
        received_date,
        COALESCE(appellant_participant_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(protest_agency_name, '')
    );
CREATE UNIQUE INDEX IF NOT EXISTS uq_assignment_batches_integrity_hash
    ON assignment_batches(integrity_hash)
    WHERE integrity_hash IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_assignment_batch_judges_order
    ON assignment_batch_judges(assignment_batch_id, judge_order)
    WHERE judge_order IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_status_periods_start
    ON judge_status_periods(judge_id, status_type, start_date);
CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_workload_snapshot_group
    ON judge_workload_snapshots(judge_id, snapshot_date, COALESCE(case_group, ''));
CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_case_conflicts_type
    ON judge_case_conflicts(case_id, judge_id, COALESCE(conflict_type, ''));
CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_replacement_history_event
    ON judge_replacement_history(assignment_id, replacement_date, old_judge_id, new_judge_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_results_tracking_result
    ON appellate_results(appellate_tracking_id, result_code, result_date, COALESCE(result_number, ''));
CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_fault_assessments_scope
    ON appellate_fault_assessments(
        appellate_result_id,
        fault_classification,
        COALESCE(responsible_judge_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(fault_reason_group, '')
    );
CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_followup_actions_scope
    ON appellate_followup_actions(
        appellate_tracking_id,
        action_type,
        COALESCE(assigned_to, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(due_date, '0001-01-01'::date)
    );
CREATE UNIQUE INDEX IF NOT EXISTS uq_appellate_status_history_event
    ON appellate_status_history(appellate_tracking_id, new_status, changed_at);
CREATE UNIQUE INDEX IF NOT EXISTS uq_validation_results_open_rule_field
    ON validation_results(case_id, rule_code, COALESCE(field_name, ''))
    WHERE validation_status = 'open';
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_risk_flags_open_rule
    ON case_risk_flags(case_id, risk_type, COALESCE(source_rule_code, ''))
    WHERE status = 'open';
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_legal_relationship_primary
    ON case_legal_relationships(case_id)
    WHERE is_primary IS TRUE;

CREATE INDEX IF NOT EXISTS idx_case_files_dashboard_status ON case_files(court_id, case_type, case_status, acceptance_date);
CREATE INDEX IF NOT EXISTS idx_case_files_closed_dashboard ON case_files(court_id, closed_date, case_type) WHERE closed_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_case_files_assignment_pool ON case_files(court_id, acceptance_date, case_number) WHERE case_status = 'accepted';
CREATE INDEX IF NOT EXISTS idx_case_events_case_time ON case_events(case_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_case_assignments_user_status ON case_assignments(user_id, status, assigned_date);
CREATE INDEX IF NOT EXISTS idx_hearings_schedule ON hearings(case_id, scheduled_date, scheduled_time);
CREATE INDEX IF NOT EXISTS idx_deadlines_status_due ON deadlines(deadline_status, due_date);
CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_dashboard ON statistics_snapshots(period_id, court_id, metric_code);
CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_metric_time ON statistics_snapshots(metric_code, calculated_at DESC);
CREATE INDEX IF NOT EXISTS idx_kpi_values_dashboard ON kpi_values(period_id, court_id, judge_id);
CREATE INDEX IF NOT EXISTS idx_kpi_values_metric_time ON kpi_values(metric_id, calculated_at DESC);
CREATE INDEX IF NOT EXISTS idx_assignment_batches_court_status_date ON assignment_batches(court_id, status, batch_date DESC);
CREATE INDEX IF NOT EXISTS idx_assignment_batch_cases_batch_order ON assignment_batch_cases(assignment_batch_id, case_order);
CREATE INDEX IF NOT EXISTS idx_assignment_batch_judges_batch_order ON assignment_batch_judges(assignment_batch_id, judge_order);
CREATE INDEX IF NOT EXISTS idx_judge_status_periods_lookup ON judge_status_periods(judge_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_judge_case_conflicts_status ON judge_case_conflicts(case_id, judge_id, status);
CREATE INDEX IF NOT EXISTS idx_assignment_audit_logs_batch_time ON assignment_audit_logs(assignment_batch_id, event_time DESC);
CREATE INDEX IF NOT EXISTS idx_appellate_trackings_upper_status ON appellate_trackings(upper_court_id, tracking_status, upper_court_acceptance_date);
CREATE INDEX IF NOT EXISTS idx_appellate_trackings_original_received ON appellate_trackings(original_court_id, received_date);
CREATE INDEX IF NOT EXISTS idx_validation_results_status_severity ON validation_results(validation_status, severity, checked_at DESC);
CREATE INDEX IF NOT EXISTS idx_appeal_protest_items_status ON appeal_protest_items(appellate_tracking_id, item_type, status);
CREATE INDEX IF NOT EXISTS idx_appellate_results_tracking_date ON appellate_results(appellate_tracking_id, result_date DESC);
CREATE INDEX IF NOT EXISTS idx_appellate_fault_judge ON appellate_fault_assessments(responsible_judge_id, fault_classification) WHERE responsible_judge_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_appellate_followup_status_due ON appellate_followup_actions(status, due_date);
CREATE INDEX IF NOT EXISTS idx_ai_suggestions_pending ON ai_suggestions(case_id, status, confidence DESC) WHERE status IN ('draft', 'pending_review');
CREATE INDEX IF NOT EXISTS idx_case_risk_flags_open ON case_risk_flags(case_id, severity, created_at DESC) WHERE status = 'open';
CREATE INDEX IF NOT EXISTS idx_audit_logs_record_time ON audit_logs(table_name, record_id, action_at DESC);
CREATE INDEX IF NOT EXISTS idx_defendant_stat_features_defendant ON defendant_statistical_features(defendant_id);
CREATE INDEX IF NOT EXISTS idx_defendant_stat_features_feature ON defendant_statistical_features(feature_id);
CREATE INDEX IF NOT EXISTS idx_defendant_stat_option_values_defendant ON defendant_statistical_option_values(defendant_id);
CREATE INDEX IF NOT EXISTS idx_case_legal_relationships_case ON case_legal_relationships(case_id);
CREATE INDEX IF NOT EXISTS idx_case_legal_relationships_relationship ON case_legal_relationships(legal_relationship_id);
CREATE INDEX IF NOT EXISTS idx_dm_statistical_form_items_form ON dm_statistical_form_items(form_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_charges_crime_id ON charges(crime_id);
CREATE INDEX IF NOT EXISTS idx_charges_article_id ON charges(article_id);
CREATE INDEX IF NOT EXISTS idx_decisions_trial_result_type ON decisions(trial_result_type_id);
CREATE INDEX IF NOT EXISTS idx_appellate_trackings_final_result_code_id ON appellate_trackings(final_result_code_id);
CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_metric_id ON statistics_snapshots(metric_id);
CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_form_item_id ON statistics_snapshots(form_item_id);
CREATE INDEX IF NOT EXISTS idx_dm_crimes_active_sort ON dm_crimes(is_active, sort_order, crime_code);
CREATE INDEX IF NOT EXISTS idx_dm_legal_relationships_scope_active_sort ON dm_legal_relationships(case_type_scope, is_active, sort_order, relationship_code);
