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
