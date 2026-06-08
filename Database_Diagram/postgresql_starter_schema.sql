-- PostgreSQL starter schema - TAND Quang Ngai Court Management System

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE courts (
    court_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    court_code VARCHAR(50) UNIQUE NOT NULL,
    court_name VARCHAR(255) NOT NULL,
    court_level VARCHAR(50) NOT NULL,
    province VARCHAR(100),
    district_area VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    court_id UUID REFERENCES courts(court_id),
    full_name VARCHAR(255) NOT NULL,
    position_title VARCHAR(100),
    role_code VARCHAR(50),
    department VARCHAR(100),
    email VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TYPE case_type_enum AS ENUM (
    'civil',
    'marriage_family',
    'business_commercial',
    'labor',
    'criminal',
    'administrative',
    'civil_matter'
);

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
    'overdue'
);

CREATE TABLE case_files (
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
    case_status case_status_enum,
    resolution_status VARCHAR(100),
    has_foreign_element BOOLEAN DEFAULT FALSE,
    is_minor_related BOOLEAN DEFAULT FALSE,
    is_confidential BOOLEAN DEFAULT FALSE,
    closed_date DATE,
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE participants (
    participant_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id),
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
    needs_interpreter BOOLEAN DEFAULT FALSE
);

CREATE TABLE civil_case_details (
    civil_detail_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID UNIQUE NOT NULL REFERENCES case_files(case_id),
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

CREATE TABLE criminal_case_details (
    criminal_detail_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID UNIQUE NOT NULL REFERENCES case_files(case_id),
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

CREATE TABLE defendants (
    defendant_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criminal_detail_id UUID NOT NULL REFERENCES criminal_case_details(criminal_detail_id),
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

CREATE TABLE charges (
    charge_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id),
    crime_name VARCHAR(255),
    penal_code_article VARCHAR(100),
    clause_point VARCHAR(100),
    crime_severity VARCHAR(100),
    prosecution_decision TEXT,
    court_finding TEXT
);

CREATE TABLE administrative_case_details (
    admin_detail_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID UNIQUE NOT NULL REFERENCES case_files(case_id),
    lawsuit_type VARCHAR(150),
    defendant_agency_name VARCHAR(255),
    agency_representative VARCHAR(255),
    agency_level VARCHAR(100),
    compensation_claimed BOOLEAN DEFAULT FALSE,
    compensation_amount NUMERIC(18,2),
    urgent_case BOOLEAN DEFAULT FALSE,
    jurisdiction_basis TEXT
);

CREATE TABLE deadlines (
    deadline_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id),
    deadline_type VARCHAR(100),
    start_date DATE,
    due_date DATE,
    completed_date DATE,
    extended_days INTEGER DEFAULT 0,
    deadline_status VARCHAR(50),
    legal_basis TEXT,
    warning_level VARCHAR(50)
);

CREATE TABLE validation_results (
    validation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id),
    rule_code VARCHAR(100),
    severity VARCHAR(50),
    validation_status VARCHAR(50),
    message TEXT,
    field_name VARCHAR(100),
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checked_by VARCHAR(100)
);
