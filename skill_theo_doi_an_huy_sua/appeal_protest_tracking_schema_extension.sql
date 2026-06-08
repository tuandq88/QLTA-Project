-- APPEAL / PROTEST TRACKING MODULE
-- TAND Quang Ngai Court Management System
-- Version 1.0

CREATE TABLE appellate_trackings (
    appellate_tracking_id UUID PRIMARY KEY,
    original_case_id UUID NOT NULL REFERENCES case_files(case_id),
    original_decision_id UUID NOT NULL REFERENCES decisions(decision_id),
    original_court_id UUID NOT NULL REFERENCES courts(court_id),
    upper_court_id UUID REFERENCES courts(court_id),
    case_type VARCHAR(100) NOT NULL,
    appeal_protest_type VARCHAR(30) NOT NULL,
    received_date DATE NOT NULL,
    appeal_deadline_status VARCHAR(50),
    tracking_status VARCHAR(50) NOT NULL DEFAULT 'received',
    sent_to_upper_court_date DATE,
    upper_court_acceptance_date DATE,
    upper_court_case_number VARCHAR(100),
    resolved_date DATE,
    final_result_code VARCHAR(100),
    fault_classification VARCHAR(50),
    quality_kpi_impact BOOLEAN,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appeal_protest_items (
    item_id UUID PRIMARY KEY,
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id),
    item_type VARCHAR(30) NOT NULL,
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

CREATE TABLE appellate_results (
    appellate_result_id UUID PRIMARY KEY,
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id),
    result_document_id UUID REFERENCES documents(document_id),
    result_number VARCHAR(100),
    result_date DATE NOT NULL,
    result_code VARCHAR(100) NOT NULL,
    result_scope VARCHAR(100),
    summary TEXT,
    effective_date DATE,
    requires_retrial BOOLEAN,
    retrial_case_id UUID REFERENCES case_files(case_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appellate_fault_assessments (
    fault_assessment_id UUID PRIMARY KEY,
    appellate_result_id UUID NOT NULL REFERENCES appellate_results(appellate_result_id),
    fault_classification VARCHAR(50) NOT NULL,
    fault_reason_group VARCHAR(100),
    responsible_level VARCHAR(100),
    responsible_court_id UUID REFERENCES courts(court_id),
    responsible_judge_id UUID REFERENCES users(user_id),
    assessment_source VARCHAR(255),
    assessment_date DATE,
    approved_by UUID REFERENCES users(user_id),
    description TEXT
);

CREATE TABLE appellate_followup_actions (
    followup_action_id UUID PRIMARY KEY,
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id),
    action_type VARCHAR(100) NOT NULL,
    due_date DATE,
    completed_date DATE,
    assigned_to UUID REFERENCES users(user_id),
    status VARCHAR(50) DEFAULT 'pending',
    note TEXT
);

CREATE TABLE appellate_status_history (
    status_history_id UUID PRIMARY KEY,
    appellate_tracking_id UUID NOT NULL REFERENCES appellate_trackings(appellate_tracking_id),
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by UUID REFERENCES users(user_id),
    note TEXT
);

CREATE INDEX idx_appellate_trackings_original_case
ON appellate_trackings(original_case_id);

CREATE INDEX idx_appellate_trackings_status
ON appellate_trackings(tracking_status);

CREATE INDEX idx_appellate_trackings_final_result
ON appellate_trackings(final_result_code);

CREATE INDEX idx_appellate_fault_responsible_judge
ON appellate_fault_assessments(responsible_judge_id);

CREATE INDEX idx_appellate_fault_classification
ON appellate_fault_assessments(fault_classification);

-- Optional compatibility extension for existing appeals table
-- Use only if the previous schema already contains appeals.
-- ALTER TABLE appeals
-- ADD COLUMN IF NOT EXISTS appellate_tracking_id UUID REFERENCES appellate_trackings(appellate_tracking_id),
-- ADD COLUMN IF NOT EXISTS protest_agency_name VARCHAR(255),
-- ADD COLUMN IF NOT EXISTS upper_court_acceptance_date DATE,
-- ADD COLUMN IF NOT EXISTS final_result_code VARCHAR(100),
-- ADD COLUMN IF NOT EXISTS fault_classification VARCHAR(50);
