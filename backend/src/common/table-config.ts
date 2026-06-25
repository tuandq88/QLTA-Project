import type { TableConfig } from './repository.js';

export const tableConfigs: Record<string, TableConfig> = {
  users: {
    table: 'users',
    idColumn: 'user_id',
    selectable: ['user_id', 'court_id', 'full_name', 'position_title', 'role_code', 'department', 'email', 'phone', 'is_active', 'created_at', 'updated_at'],
    writable: ['court_id', 'full_name', 'position_title', 'role_code', 'department', 'email', 'phone', 'is_active'],
    searchable: ['full_name', 'email', 'phone', 'position_title'],
    defaultOrder: 'created_at'
  },
  courts: {
    table: 'courts',
    idColumn: 'court_id',
    selectable: ['court_id', 'parent_court_id', 'court_code', 'court_name', 'court_level', 'province', 'district_area', 'address', 'is_active', 'created_at', 'updated_at'],
    writable: [],
    searchable: ['court_code', 'court_name', 'district_area'],
    defaultOrder: 'court_code'
  },
  categories: {
    table: 'dm_categories',
    idColumn: 'category_id',
    selectable: ['category_id', 'category_code', 'category_name', 'description', 'is_system', 'is_active', 'sort_order', 'created_at', 'updated_at'],
    writable: [],
    searchable: ['category_code', 'category_name'],
    defaultOrder: 'sort_order'
  },
  categoryItems: {
    table: 'dm_category_items',
    idColumn: 'item_id',
    selectable: ['item_id', 'category_id', 'item_code', 'item_name', 'parent_item_id', 'description', 'legal_basis', 'is_active', 'sort_order', 'metadata', 'valid_from', 'valid_to'],
    writable: [],
    searchable: ['item_code', 'item_name'],
    defaultOrder: 'sort_order'
  },
  cases: {
    table: 'case_files',
    idColumn: 'case_id',
    selectable: ['case_id', 'court_id', 'case_code', 'case_number', 'case_type', 'case_group', 'procedure_law', 'filing_date', 'acceptance_date', 'current_stage', 'case_status', 'resolution_status', 'has_foreign_element', 'is_minor_related', 'is_confidential', 'first_instance_court_id', 'first_instance_case_number', 'first_instance_judgment_number', 'first_instance_judgment_date', 'closed_date', 'summary', 'created_by', 'updated_by', 'created_at', 'updated_at'],
    writable: ['court_id', 'case_code', 'case_number', 'case_type', 'case_group', 'procedure_law', 'filing_date', 'acceptance_date', 'current_stage', 'case_status', 'resolution_status', 'has_foreign_element', 'is_minor_related', 'is_confidential', 'first_instance_court_id', 'first_instance_case_number', 'first_instance_judgment_number', 'first_instance_judgment_date', 'closed_date', 'summary', 'created_by', 'updated_by'],
    searchable: ['case_code', 'case_number', 'summary'],
    defaultOrder: 'created_at'
  },
  occurrences: {
    table: 'case_occurrences',
    idColumn: 'occurrence_id',
    selectable: ['occurrence_id', 'case_id', 'occurrence_no', 'acceptance_date', 'acceptance_type_code', 'acceptance_type_id', 'previous_occurrence_id', 'source_note', 'created_at', 'updated_at'],
    writable: ['case_id', 'occurrence_no', 'acceptance_date', 'acceptance_type_code', 'acceptance_type_id', 'previous_occurrence_id', 'source_note'],
    defaultOrder: 'acceptance_date'
  },
  resolutionEvents: {
    table: 'case_resolution_events',
    idColumn: 'resolution_event_id',
    selectable: ['resolution_event_id', 'case_id', 'occurrence_id', 'event_type_code', 'event_date', 'resolution_type_code', 'resolution_type_id', 'return_to_agency_code', 'return_to_agency_id', 'decision_number', 'counted_as_resolved', 'reason', 'created_at', 'updated_at'],
    writable: ['case_id', 'occurrence_id', 'event_type_code', 'event_date', 'resolution_type_code', 'resolution_type_id', 'return_to_agency_code', 'return_to_agency_id', 'decision_number', 'counted_as_resolved', 'reason'],
    searchable: ['decision_number', 'reason'],
    defaultOrder: 'event_date'
  },
  participants: {
    table: 'participants',
    idColumn: 'participant_id',
    selectable: ['participant_id', 'case_id', 'participant_type', 'full_name', 'organization_name', 'legal_representative', 'id_number', 'date_of_birth', 'gender', 'address', 'phone', 'email', 'is_minor', 'needs_interpreter', 'note'],
    writable: ['case_id', 'participant_type', 'full_name', 'organization_name', 'legal_representative', 'id_number', 'date_of_birth', 'gender', 'address', 'phone', 'email', 'is_minor', 'needs_interpreter', 'note'],
    searchable: ['full_name', 'organization_name', 'id_number'],
    defaultOrder: 'participant_id'
  },
  hearings: {
    table: 'hearings',
    idColumn: 'hearing_id',
    selectable: ['hearing_id', 'case_id', 'hearing_type', 'scheduled_date', 'scheduled_time', 'courtroom', 'panel_composition', 'hearing_status', 'postponement_reason', 'actual_opened_date', 'actual_closed_date', 'note'],
    writable: ['case_id', 'hearing_type', 'scheduled_date', 'scheduled_time', 'courtroom', 'panel_composition', 'hearing_status', 'postponement_reason', 'actual_opened_date', 'actual_closed_date', 'note'],
    searchable: ['hearing_type', 'courtroom', 'note'],
    defaultOrder: 'scheduled_date'
  },
  hearingMembers: {
    table: 'case_hearing_members',
    idColumn: 'case_hearing_member_id',
    selectable: ['case_hearing_member_id', 'case_id', 'staff_id', 'role_code', 'role_id', 'member_order', 'source_file', 'source_sheet', 'source_row', 'created_at', 'updated_at'],
    writable: ['case_id', 'staff_id', 'role_code', 'role_id', 'member_order', 'source_file', 'source_sheet', 'source_row'],
    defaultOrder: 'member_order'
  },
  validationResults: {
    table: 'validation_results',
    idColumn: 'validation_id',
    selectable: ['validation_id', 'case_id', 'rule_code', 'severity', 'validation_status', 'message', 'field_name', 'checked_at', 'checked_by', 'legal_basis', 'suggested_action'],
    writable: ['case_id', 'rule_code', 'severity', 'validation_status', 'message', 'field_name', 'checked_by', 'legal_basis', 'suggested_action'],
    searchable: ['rule_code', 'message', 'field_name'],
    defaultOrder: 'checked_at'
  },
  auditLogs: {
    table: 'audit_logs',
    idColumn: 'audit_log_id',
    selectable: ['audit_log_id', 'table_name', 'record_id', 'action', 'actor_id', 'action_at', 'old_data', 'new_data', 'integrity_hash'],
    writable: [],
    searchable: ['table_name', 'action'],
    defaultOrder: 'action_at'
  }
};
