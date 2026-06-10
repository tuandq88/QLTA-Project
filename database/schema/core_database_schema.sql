-- Migration 001: standalone core database schema for QLTA.
-- Scope: core database only. No backend, frontend, module-specific logic, or data drop.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'court_level_enum') THEN
        CREATE TYPE court_level_enum AS ENUM ('province', 'district', 'regional', 'upper', 'supreme', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role_enum') THEN
        CREATE TYPE user_role_enum AS ENUM ('chief_judge', 'deputy_chief_judge', 'judge', 'clerk', 'leader', 'admin', 'viewer', 'ai_agent');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'case_type_enum') THEN
        CREATE TYPE case_type_enum AS ENUM ('civil', 'marriage_family', 'business_commercial', 'labor', 'criminal', 'administrative', 'civil_matter', 'bankruptcy', 'administrative_measure', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'case_status_enum') THEN
        CREATE TYPE case_status_enum AS ENUM ('draft', 'received', 'accepted', 'preparing', 'trial_scheduled', 'resolved', 'appealed', 'effective', 'temporarily_suspended', 'suspended', 'overdue', 'closed');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'participant_type_enum') THEN
        CREATE TYPE participant_type_enum AS ENUM ('plaintiff', 'defendant', 'petitioner', 'respondent', 'defendant_criminal', 'victim', 'related_person', 'representative', 'witness', 'interpreter', 'procuracy', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'document_type_enum') THEN
        CREATE TYPE document_type_enum AS ENUM ('petition', 'acceptance_notice', 'evidence', 'hearing_notice', 'minutes', 'judgment', 'decision', 'appeal', 'protest', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'hearing_type_enum') THEN
        CREATE TYPE hearing_type_enum AS ENUM ('trial', 'meeting', 'mediation', 'dialogue', 'appellate_trial', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'hearing_status_enum') THEN
        CREATE TYPE hearing_status_enum AS ENUM ('scheduled', 'opened', 'postponed', 'adjourned', 'completed', 'cancelled');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'decision_type_enum') THEN
        CREATE TYPE decision_type_enum AS ENUM ('judgment', 'decision', 'temporary_suspension', 'suspension', 'recognition', 'return_petition', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'assignment_role_enum') THEN
        CREATE TYPE assignment_role_enum AS ENUM ('primary_judge', 'panel_judge', 'clerk', 'procurator', 'assistant', 'other');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'assignment_status_enum') THEN
        CREATE TYPE assignment_status_enum AS ENUM ('active', 'ended', 'replaced', 'cancelled');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'deadline_status_enum') THEN
        CREATE TYPE deadline_status_enum AS ENUM ('pending', 'completed', 'overdue', 'extended', 'cancelled');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'validation_severity_enum') THEN
        CREATE TYPE validation_severity_enum AS ENUM ('info', 'warning', 'error', 'critical');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'audit_action_type_enum') THEN
        CREATE TYPE audit_action_type_enum AS ENUM ('insert', 'update', 'delete', 'login', 'logout', 'export', 'validate', 'assign', 'ai_suggest', 'other');
    END IF;
END $$;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END $$;

CREATE TABLE IF NOT EXISTS dm_categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_code VARCHAR(100) UNIQUE NOT NULL,
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
    item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES dm_categories(category_id) ON DELETE RESTRICT,
    item_code VARCHAR(150) NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    parent_item_id UUID REFERENCES dm_category_items(item_id) ON DELETE RESTRICT,
    description TEXT,
    legal_basis TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    valid_from DATE,
    valid_to DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dm_category_items_category_code UNIQUE (category_id, item_code),
    CONSTRAINT chk_dm_category_items_code_format CHECK (item_code ~ '^[A-Za-z0-9_.:-]+$'),
    CONSTRAINT chk_dm_category_items_sort_order_nonnegative CHECK (sort_order >= 0),
    CONSTRAINT chk_dm_category_items_valid_range CHECK (valid_to IS NULL OR valid_from IS NULL OR valid_to >= valid_from)
);

INSERT INTO dm_categories (category_code, category_name, description, sort_order)
VALUES
    ('court_level', 'Court level', 'Core court-level codes', 10),
    ('user_role', 'User role', 'Core system role codes', 20),
    ('case_type', 'Case type', 'Core case type codes', 30),
    ('case_group', 'Case group', 'Core trial-level case group codes', 35),
    ('case_status', 'Case status', 'Core case status codes', 40),
    ('participant_type', 'Participant type', 'Core participant type codes', 50),
    ('document_type', 'Document type', 'Core document type codes', 60),
    ('hearing_type', 'Hearing type', 'Core hearing type codes', 70),
    ('hearing_status', 'Hearing status', 'Core hearing status codes', 80),
    ('decision_type', 'Decision type', 'Core decision type codes', 90),
    ('assignment_role', 'Assignment role', 'Core assignment role codes', 100),
    ('deadline_status', 'Deadline status', 'Core deadline status codes', 110),
    ('validation_severity', 'Validation severity', 'Core validation severity codes', 120),
    ('audit_action_type', 'Audit action type', 'Core audit action codes', 130),
    ('hearing_member_role', 'Hearing member role', 'Core hearing member role codes', 140)
ON CONFLICT (category_code) DO NOTHING;

WITH seed_items(category_code, item_code, item_name, sort_order) AS (
    VALUES
    ('court_level', 'province', 'province', 10),
    ('court_level', 'district', 'district', 20),
    ('court_level', 'regional', 'regional', 30),
    ('user_role', 'chief_judge', 'chief_judge', 10),
    ('user_role', 'deputy_chief_judge', 'deputy_chief_judge', 20),
    ('user_role', 'judge', 'judge', 30),
    ('user_role', 'clerk', 'clerk', 40),
    ('user_role', 'admin', 'admin', 50),
    ('case_type', 'civil', 'civil', 10),
    ('case_type', 'marriage_family', 'marriage_family', 20),
    ('case_type', 'business_commercial', 'business_commercial', 30),
    ('case_type', 'labor', 'labor', 40),
    ('case_type', 'criminal', 'criminal', 50),
    ('case_type', 'administrative', 'administrative', 60),
    ('case_group', 'SO_THAM', 'So tham', 10),
    ('case_group', 'PHUC_THAM', 'Phuc tham', 20),
    ('case_status', 'draft', 'draft', 10),
    ('case_status', 'accepted', 'accepted', 20),
    ('case_status', 'preparing', 'preparing', 30),
    ('case_status', 'resolved', 'resolved', 40),
    ('case_status', 'effective', 'effective', 50),
    ('case_status', 'closed', 'closed', 60),
    ('participant_type', 'plaintiff', 'plaintiff', 10),
    ('participant_type', 'defendant', 'defendant', 20),
    ('participant_type', 'defendant_criminal', 'defendant_criminal', 30),
    ('participant_type', 'victim', 'victim', 40),
    ('participant_type', 'related_person', 'related_person', 50),
    ('document_type', 'petition', 'petition', 10),
    ('document_type', 'evidence', 'evidence', 20),
    ('document_type', 'judgment', 'judgment', 30),
    ('document_type', 'decision', 'decision', 40),
    ('hearing_type', 'trial', 'trial', 10),
    ('hearing_type', 'meeting', 'meeting', 20),
    ('hearing_type', 'mediation', 'mediation', 30),
    ('hearing_type', 'dialogue', 'dialogue', 40),
    ('hearing_status', 'scheduled', 'scheduled', 10),
    ('hearing_status', 'opened', 'opened', 20),
    ('hearing_status', 'postponed', 'postponed', 30),
    ('hearing_status', 'completed', 'completed', 40),
    ('decision_type', 'judgment', 'judgment', 10),
    ('decision_type', 'decision', 'decision', 20),
    ('decision_type', 'suspension', 'suspension', 30),
    ('assignment_role', 'primary_judge', 'primary_judge', 10),
    ('assignment_role', 'panel_judge', 'panel_judge', 20),
    ('assignment_role', 'clerk', 'clerk', 30),
    ('deadline_status', 'pending', 'pending', 10),
    ('deadline_status', 'completed', 'completed', 20),
    ('deadline_status', 'overdue', 'overdue', 30),
    ('validation_severity', 'info', 'info', 10),
    ('validation_severity', 'warning', 'warning', 20),
    ('validation_severity', 'error', 'error', 30),
    ('validation_severity', 'critical', 'critical', 40),
    ('audit_action_type', 'insert', 'insert', 10),
    ('audit_action_type', 'update', 'update', 20),
    ('audit_action_type', 'delete', 'delete', 30),
    ('audit_action_type', 'validate', 'validate', 40),
    ('audit_action_type', 'assign', 'assign', 50),
    ('hearing_member_role', 'PRESIDING_JUDGE', 'Presiding judge', 10),
    ('hearing_member_role', 'PANEL_JUDGE', 'Panel judge', 20),
    ('hearing_member_role', 'HEARING_CLERK', 'Hearing clerk', 30)
)
INSERT INTO dm_category_items (category_id, item_code, item_name, sort_order)
SELECT c.category_id, s.item_code, s.item_name, s.sort_order
FROM seed_items s
JOIN dm_categories c ON c.category_code = s.category_code
ON CONFLICT (category_id, item_code) DO NOTHING;

CREATE TABLE IF NOT EXISTS courts (
    court_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_court_id UUID REFERENCES courts(court_id) ON DELETE RESTRICT,
    court_code VARCHAR(50) UNIQUE NOT NULL,
    court_name VARCHAR(255) NOT NULL,
    court_level court_level_enum NOT NULL,
    province VARCHAR(100) DEFAULT 'Quang Ngai',
    district_area VARCHAR(100),
    address TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_courts_parent_not_self CHECK (parent_court_id IS NULL OR parent_court_id <> court_id)
);

CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    court_id UUID NOT NULL REFERENCES courts(court_id) ON DELETE RESTRICT,
    full_name VARCHAR(255) NOT NULL,
    position_title VARCHAR(100),
    role_code user_role_enum NOT NULL DEFAULT 'viewer',
    department VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS judge_profiles (
    judge_profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    judge_code VARCHAR(100),
    judge_title VARCHAR(100),
    specialized_court_code VARCHAR(100),
    specialized_group VARCHAR(100),
    is_leadership BOOLEAN NOT NULL DEFAULT FALSE,
    leadership_quota NUMERIC(5,2),
    maternity_quota_status BOOLEAN NOT NULL DEFAULT FALSE,
    annual_assignment_quota INTEGER,
    can_handle_minor_cases BOOLEAN NOT NULL DEFAULT FALSE,
    is_active_for_assignment BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS case_files (
    case_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    court_id UUID NOT NULL REFERENCES courts(court_id) ON DELETE RESTRICT,
    case_code VARCHAR(100),
    case_number VARCHAR(100),
    case_type case_type_enum NOT NULL,
    case_group VARCHAR(100),
    procedure_law VARCHAR(100),
    filing_date DATE,
    acceptance_date DATE,
    current_stage VARCHAR(100),
    case_status case_status_enum NOT NULL DEFAULT 'draft',
    resolution_status VARCHAR(100),
    has_foreign_element BOOLEAN NOT NULL DEFAULT FALSE,
    is_minor_related BOOLEAN NOT NULL DEFAULT FALSE,
    is_confidential BOOLEAN NOT NULL DEFAULT FALSE,
    assigned_judge_id UUID REFERENCES users(user_id) ON DELETE RESTRICT,
    closed_date DATE,
    summary TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_case_files_case_code UNIQUE (case_code),
    CONSTRAINT chk_case_files_acceptance_closed CHECK (acceptance_date IS NULL OR closed_date IS NULL OR acceptance_date <= closed_date),
    CONSTRAINT chk_case_files_closed_status CHECK (closed_date IS NULL OR case_status IN ('resolved', 'effective', 'closed'))
);

CREATE TABLE IF NOT EXISTS participants (
    participant_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    participant_type participant_type_enum NOT NULL,
    full_name VARCHAR(255),
    organization_name VARCHAR(255),
    legal_representative VARCHAR(255),
    id_number VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(20),
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    is_minor BOOLEAN NOT NULL DEFAULT FALSE,
    needs_interpreter BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_participants_identity_required CHECK (full_name IS NOT NULL OR organization_name IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS documents (
    document_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    document_type document_type_enum NOT NULL,
    document_number VARCHAR(100),
    document_date DATE,
    issued_by VARCHAR(255),
    file_name VARCHAR(255),
    storage_path TEXT,
    checksum VARCHAR(128),
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    is_valid BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS hearings (
    hearing_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    hearing_type hearing_type_enum NOT NULL,
    scheduled_date DATE,
    scheduled_time TIME,
    courtroom VARCHAR(100),
    panel_composition TEXT,
    hearing_status hearing_status_enum NOT NULL DEFAULT 'scheduled',
    postponement_reason TEXT,
    actual_opened_date DATE,
    actual_closed_date DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_hearings_actual_range CHECK (actual_opened_date IS NULL OR actual_closed_date IS NULL OR actual_opened_date <= actual_closed_date)
);

CREATE TABLE IF NOT EXISTS court_staff (
    staff_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    court_id UUID NOT NULL REFERENCES courts(court_id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    normalized_name VARCHAR(255) NOT NULL,
    staff_type VARCHAR(100),
    position_title VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_court_staff_normalized_name_not_blank CHECK (btrim(normalized_name) <> '')
);

CREATE TABLE IF NOT EXISTS case_hearing_members (
    case_hearing_member_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    staff_id UUID NOT NULL REFERENCES court_staff(staff_id) ON DELETE RESTRICT,
    role_code VARCHAR(50) NOT NULL,
    role_id UUID REFERENCES dm_category_items(item_id) ON DELETE RESTRICT,
    member_order INTEGER NOT NULL DEFAULT 1,
    source_file VARCHAR(255),
    source_sheet VARCHAR(255),
    source_row INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_case_hearing_members_role_code CHECK (role_code IN ('PRESIDING_JUDGE', 'PANEL_JUDGE', 'HEARING_CLERK')),
    CONSTRAINT chk_case_hearing_members_member_order CHECK (member_order > 0)
);

CREATE TABLE IF NOT EXISTS decisions (
    decision_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    decision_type decision_type_enum NOT NULL,
    decision_number VARCHAR(100),
    decision_date DATE,
    result_code VARCHAR(100),
    result_summary TEXT,
    is_final BOOLEAN NOT NULL DEFAULT FALSE,
    effective_date DATE,
    document_id UUID REFERENCES documents(document_id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_decisions_effective_after_decision CHECK (effective_date IS NULL OR decision_date IS NULL OR effective_date >= decision_date)
);

CREATE TABLE IF NOT EXISTS case_assignments (
    assignment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    assignment_role assignment_role_enum NOT NULL DEFAULT 'primary_judge',
    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    ended_date DATE,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    status assignment_status_enum NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_case_assignments_date_range CHECK (ended_date IS NULL OR ended_date >= assigned_date)
);

CREATE TABLE IF NOT EXISTS case_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    event_type VARCHAR(100) NOT NULL,
    event_stage VARCHAR(100),
    event_date DATE NOT NULL DEFAULT CURRENT_DATE,
    performed_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
    description TEXT,
    source_document_id UUID REFERENCES documents(document_id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS deadlines (
    deadline_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    deadline_type VARCHAR(100) NOT NULL,
    start_date DATE,
    due_date DATE,
    completed_date DATE,
    extended_days INTEGER NOT NULL DEFAULT 0,
    deadline_status deadline_status_enum NOT NULL DEFAULT 'pending',
    legal_basis TEXT,
    warning_level VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_deadlines_due_after_start CHECK (due_date IS NULL OR start_date IS NULL OR due_date >= start_date),
    CONSTRAINT chk_deadlines_completed_after_start CHECK (completed_date IS NULL OR start_date IS NULL OR completed_date >= start_date),
    CONSTRAINT chk_deadlines_extended_nonnegative CHECK (extended_days >= 0)
);

CREATE TABLE IF NOT EXISTS validation_results (
    validation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    rule_code VARCHAR(100) NOT NULL,
    severity validation_severity_enum NOT NULL DEFAULT 'warning',
    validation_status VARCHAR(50) NOT NULL DEFAULT 'open',
    message TEXT NOT NULL,
    field_name VARCHAR(100),
    checked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checked_by VARCHAR(100),
    legal_basis TEXT,
    suggested_action TEXT
);

CREATE TABLE IF NOT EXISTS audit_logs (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID,
    action audit_action_type_enum NOT NULL,
    actor_id UUID REFERENCES users(user_id) ON DELETE SET NULL,
    event_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    before_data JSONB,
    after_data JSONB,
    ip_address INET,
    user_agent TEXT,
    note TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email_lower ON users (lower(email)) WHERE email IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_judge_profiles_judge_code ON judge_profiles (judge_code) WHERE judge_code IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_files_business_key ON case_files (court_id, case_number, case_type, acceptance_date) WHERE case_number IS NOT NULL AND acceptance_date IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_participants_case_identity ON participants (case_id, participant_type, lower(COALESCE(full_name, '')), COALESCE(date_of_birth, DATE '0001-01-01')) WHERE full_name IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_documents_checksum ON documents (checksum) WHERE checksum IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_documents_case_type_number_date ON documents (case_id, document_type, document_number, document_date) WHERE document_number IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_decisions_case_type_number_date ON decisions (case_id, decision_type, decision_number, decision_date) WHERE decision_number IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_assignments_active_primary_role ON case_assignments (case_id, assignment_role) WHERE is_primary IS TRUE AND status = 'active';

CREATE INDEX IF NOT EXISTS idx_courts_parent ON courts(parent_court_id);
CREATE INDEX IF NOT EXISTS idx_courts_level ON courts(court_level);
CREATE INDEX IF NOT EXISTS idx_users_court ON users(court_id);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role_code);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_judge_profiles_specialized_group ON judge_profiles(specialized_group);
CREATE INDEX IF NOT EXISTS idx_judge_profiles_active_assignment ON judge_profiles(is_active_for_assignment);
CREATE INDEX IF NOT EXISTS idx_case_files_court ON case_files(court_id);
CREATE INDEX IF NOT EXISTS idx_case_files_type ON case_files(case_type);
CREATE INDEX IF NOT EXISTS idx_case_files_status ON case_files(case_status);
CREATE INDEX IF NOT EXISTS idx_case_files_acceptance_date ON case_files(acceptance_date);
CREATE INDEX IF NOT EXISTS idx_case_files_assigned_judge ON case_files(assigned_judge_id);
CREATE INDEX IF NOT EXISTS idx_case_files_current_stage ON case_files(current_stage);
CREATE INDEX IF NOT EXISTS idx_case_files_court_status ON case_files(court_id, case_status);
CREATE INDEX IF NOT EXISTS idx_case_files_court_type_acceptance ON case_files(court_id, case_type, acceptance_date);
CREATE INDEX IF NOT EXISTS idx_participants_case ON participants(case_id);
CREATE INDEX IF NOT EXISTS idx_participants_type ON participants(participant_type);
CREATE INDEX IF NOT EXISTS idx_participants_id_number ON participants(id_number) WHERE id_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_documents_case ON documents(case_id);
CREATE INDEX IF NOT EXISTS idx_documents_type ON documents(document_type);
CREATE INDEX IF NOT EXISTS idx_documents_date ON documents(document_date);
CREATE INDEX IF NOT EXISTS idx_documents_checksum ON documents(checksum);
CREATE INDEX IF NOT EXISTS idx_hearings_case ON hearings(case_id);
CREATE INDEX IF NOT EXISTS idx_hearings_scheduled_date ON hearings(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_hearings_status ON hearings(hearing_status);
CREATE UNIQUE INDEX IF NOT EXISTS uq_court_staff_court_normalized_name ON court_staff(court_id, normalized_name);
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_hearing_members_case_staff_role ON case_hearing_members(case_id, staff_id, role_code);
CREATE INDEX IF NOT EXISTS idx_case_hearing_members_case_role ON case_hearing_members(case_id, role_code, member_order);
CREATE INDEX IF NOT EXISTS idx_case_hearing_members_staff ON case_hearing_members(staff_id);
CREATE INDEX IF NOT EXISTS idx_decisions_case ON decisions(case_id);
CREATE INDEX IF NOT EXISTS idx_decisions_type ON decisions(decision_type);
CREATE INDEX IF NOT EXISTS idx_decisions_date ON decisions(decision_date);
CREATE INDEX IF NOT EXISTS idx_decisions_result_code ON decisions(result_code);
CREATE INDEX IF NOT EXISTS idx_decisions_final ON decisions(is_final);
CREATE INDEX IF NOT EXISTS idx_case_assignments_case ON case_assignments(case_id);
CREATE INDEX IF NOT EXISTS idx_case_assignments_user ON case_assignments(user_id);
CREATE INDEX IF NOT EXISTS idx_case_assignments_role ON case_assignments(assignment_role);
CREATE INDEX IF NOT EXISTS idx_case_assignments_status ON case_assignments(status);
CREATE INDEX IF NOT EXISTS idx_case_events_case ON case_events(case_id);
CREATE INDEX IF NOT EXISTS idx_case_events_date ON case_events(event_date);
CREATE INDEX IF NOT EXISTS idx_case_events_type ON case_events(event_type);
CREATE INDEX IF NOT EXISTS idx_case_events_performed_by ON case_events(performed_by);
CREATE INDEX IF NOT EXISTS idx_deadlines_case ON deadlines(case_id);
CREATE INDEX IF NOT EXISTS idx_deadlines_type ON deadlines(deadline_type);
CREATE INDEX IF NOT EXISTS idx_deadlines_due_date ON deadlines(due_date);
CREATE INDEX IF NOT EXISTS idx_deadlines_status ON deadlines(deadline_status);
CREATE INDEX IF NOT EXISTS idx_deadlines_pending_overdue ON deadlines(due_date) WHERE deadline_status IN ('pending', 'overdue');
CREATE INDEX IF NOT EXISTS idx_validation_results_case ON validation_results(case_id);
CREATE INDEX IF NOT EXISTS idx_validation_results_rule ON validation_results(rule_code);
CREATE INDEX IF NOT EXISTS idx_validation_results_severity ON validation_results(severity);
CREATE INDEX IF NOT EXISTS idx_validation_results_status ON validation_results(validation_status);
CREATE INDEX IF NOT EXISTS idx_validation_results_checked_at ON validation_results(checked_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON audit_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_event_time ON audit_logs(event_time);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);

DO $$
BEGIN
    CREATE TRIGGER trg_courts_updated_at BEFORE UPDATE ON courts FOR EACH ROW EXECUTE FUNCTION set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
    CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
    CREATE TRIGGER trg_case_files_updated_at BEFORE UPDATE ON case_files FOR EACH ROW EXECUTE FUNCTION set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
