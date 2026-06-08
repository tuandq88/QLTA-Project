-- RANDOM CASE ASSIGNMENT MODULE
-- For TAND Quang Ngai Court Management System

CREATE TABLE judge_profiles (
    judge_profile_id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(user_id),
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

CREATE TABLE assignment_batches (
    assignment_batch_id UUID PRIMARY KEY,
    court_id UUID NOT NULL REFERENCES courts(court_id),
    batch_date TIMESTAMP NOT NULL,
    assignment_method VARCHAR(30) NOT NULL,
    created_by UUID REFERENCES users(user_id),
    decided_by UUID REFERENCES users(user_id),
    status VARCHAR(30) DEFAULT 'draft',
    algorithm_version VARCHAR(50),
    random_seed_hash TEXT,
    legal_basis TEXT,
    integrity_hash TEXT,
    public_note TEXT
);

CREATE TABLE assignment_batch_cases (
    id UUID PRIMARY KEY,
    assignment_batch_id UUID NOT NULL REFERENCES assignment_batches(assignment_batch_id),
    case_id UUID NOT NULL REFERENCES case_files(case_id),
    case_order INTEGER NOT NULL,
    case_group VARCHAR(100),
    assignment_method VARCHAR(30),
    designated_reason_code VARCHAR(100),
    is_assigned BOOLEAN DEFAULT FALSE
);

CREATE TABLE assignment_batch_judges (
    id UUID PRIMARY KEY,
    assignment_batch_id UUID NOT NULL REFERENCES assignment_batches(assignment_batch_id),
    judge_id UUID NOT NULL REFERENCES users(user_id),
    judge_order INTEGER,
    active_case_count INTEGER DEFAULT 0,
    suspended_case_count INTEGER DEFAULT 0,
    overdue_case_count INTEGER DEFAULT 0,
    subjective_cancel_modify_count_1y INTEGER DEFAULT 0,
    eligible BOOLEAN DEFAULT TRUE,
    exclusion_reason VARCHAR(255),
    specialized_group VARCHAR(100)
);

CREATE TABLE judge_status_periods (
    status_period_id UUID PRIMARY KEY,
    judge_id UUID NOT NULL REFERENCES users(user_id),
    status_type VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT,
    decision_document_id UUID REFERENCES documents(document_id)
);

CREATE TABLE judge_workload_snapshots (
    snapshot_id UUID PRIMARY KEY,
    judge_id UUID NOT NULL REFERENCES users(user_id),
    court_id UUID NOT NULL REFERENCES courts(court_id),
    snapshot_date DATE NOT NULL,
    case_group VARCHAR(100),
    active_case_count INTEGER DEFAULT 0,
    suspended_case_count INTEGER DEFAULT 0,
    overdue_case_count INTEGER DEFAULT 0,
    subjective_cancel_modify_count_1y INTEGER DEFAULT 0,
    annual_assigned_count INTEGER DEFAULT 0,
    annual_resolved_count INTEGER DEFAULT 0
);

CREATE TABLE judge_case_conflicts (
    conflict_id UUID PRIMARY KEY,
    case_id UUID NOT NULL REFERENCES case_files(case_id),
    judge_id UUID NOT NULL REFERENCES users(user_id),
    conflict_type VARCHAR(100),
    description TEXT,
    detected_by UUID REFERENCES users(user_id),
    confirmed_by UUID REFERENCES users(user_id),
    status VARCHAR(30) DEFAULT 'pending'
);

CREATE TABLE judge_replacement_history (
    replacement_id UUID PRIMARY KEY,
    assignment_id UUID NOT NULL REFERENCES case_assignments(assignment_id),
    old_judge_id UUID REFERENCES users(user_id),
    new_judge_id UUID REFERENCES users(user_id),
    replacement_date DATE NOT NULL,
    replacement_reason TEXT,
    decided_by UUID REFERENCES users(user_id)
);

CREATE TABLE assignment_audit_logs (
    audit_id UUID PRIMARY KEY,
    assignment_batch_id UUID NOT NULL REFERENCES assignment_batches(assignment_batch_id),
    event_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actor_id UUID REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    before_data_hash TEXT,
    after_data_hash TEXT,
    detail TEXT
);

ALTER TABLE case_assignments
ADD COLUMN IF NOT EXISTS assignment_batch_id UUID REFERENCES assignment_batches(assignment_batch_id),
ADD COLUMN IF NOT EXISTS assignment_method VARCHAR(30),
ADD COLUMN IF NOT EXISTS assigned_by UUID REFERENCES users(user_id),
ADD COLUMN IF NOT EXISTS legal_basis TEXT,
ADD COLUMN IF NOT EXISTS designated_reason_code VARCHAR(100),
ADD COLUMN IF NOT EXISTS judge_rank_at_assignment INTEGER,
ADD COLUMN IF NOT EXISTS case_order_at_assignment INTEGER,
ADD COLUMN IF NOT EXISTS integrity_hash TEXT,
ADD COLUMN IF NOT EXISTS status VARCHAR(30) DEFAULT 'active',
ADD COLUMN IF NOT EXISTS replacement_reason TEXT;
