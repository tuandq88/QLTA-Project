-- Migration 006: trial level catalog and hearing member model.
-- Adds court_staff and case_hearing_members without changing existing case data.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS court_staff (
    staff_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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
    case_hearing_member_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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

CREATE UNIQUE INDEX IF NOT EXISTS uq_court_staff_court_normalized_name
    ON court_staff(court_id, normalized_name);
CREATE UNIQUE INDEX IF NOT EXISTS uq_case_hearing_members_case_staff_role
    ON case_hearing_members(case_id, staff_id, role_code);
CREATE INDEX IF NOT EXISTS idx_case_hearing_members_case_role
    ON case_hearing_members(case_id, role_code, member_order);
CREATE INDEX IF NOT EXISTS idx_case_hearing_members_staff
    ON case_hearing_members(staff_id);
