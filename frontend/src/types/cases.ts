export type ApiResponse<T> = {
  success: boolean;
  data?: T;
  meta?: ApiMeta;
  error?: {
    code: string;
    message: string;
    details?: unknown;
  };
};

export type ApiMeta = {
  total?: number;
  page?: number;
  pageSize?: number;
  pageCount?: number;
  trace?: {
    sourceTables?: string[];
    filters?: Record<string, unknown>;
    note?: string;
  };
};

export type DataState = "idle" | "loading" | "empty" | "error" | "readonly" | "permission_denied";

export type CaseWorklistItem = {
  case_id: string;
  case_code: string | null;
  case_number: string | null;
  summary?: string | null;
  case_type: string;
  case_group: string | null;
  procedure_law: string | null;
  acceptance_date: string | null;
  current_stage: string | null;
  case_status: string;
  resolution_status: string | null;
  closed_date: string | null;
  updated_at: string;
  court_id: string;
  court_code: string | null;
  court_name: string;
  court_level: string | null;
  participant_count: number;
  hearing_count: number;
  occurrence_count: number;
  open_validation_count: number;
};

export type CaseWorklistQuery = {
  page: number;
  pageSize: number;
  search?: string;
  court_id?: string;
  case_type?: string;
  case_group?: string;
  case_status?: string;
  current_stage?: string;
  from_date?: string;
  to_date?: string;
  sort_by?: "acceptance_date" | "closed_date" | "case_type" | "court_name" | "updated_at";
  sort_dir?: "asc" | "desc";
};

export type CaseProgressDashboardQuery = {
  from_date?: string;
  to_date?: string;
  court_id?: string;
  case_type?: string;
  judge_id?: string;
};

export type CaseProgressDashboard = {
  totals: {
    total_cases: number;
    accepted_in_period_cases: number;
    opening_pending_cases: number;
    resolved_cases: number;
    pending_cases: number;
    overdue_cases: number;
    open_validation_count: number;
    random_assigned_cases: number;
  };
  byType: Array<{
    case_type: string;
    accepted_count: number;
    resolved_count: number;
    overdue_count: number;
  }>;
  byMonth: Array<{
    period: string;
    accepted_count: number;
    resolved_count: number;
  }>;
  judgeProgress: Array<{
    judge_id: string | null;
    judge_name: string;
    assigned_count: number;
    resolved_count: number;
    overdue_count: number;
    open_validation_count: number;
  }>;
  appellateQuality: Array<{
    result_code: string;
    fault_classification: string;
    tracking_count: number;
  }>;
};

export type CasePeriodCategory = "accepted_in_period" | "opening_pending" | "resolved_in_period";

export type CasePeriodReportItem = {
  case_id: string;
  case_code: string | null;
  case_number: string | null;
  case_type: string;
  case_group: string | null;
  acceptance_date: string;
  closed_date: string | null;
  report_resolution_date: string | null;
  report_resolution_status: string | null;
  report_note: string | null;
  is_resolved_after_period: boolean;
  court_name: string;
  judge_name: string;
};

export type CourtItem = {
  court_id: string;
  court_code: string | null;
  court_name: string;
  court_level: string | null;
};

export type UserItem = {
  user_id: string;
  court_id: string | null;
  full_name: string;
  position_title: string | null;
  role_code: "admin" | "chief_judge" | "deputy_chief_judge" | "judge" | "clerk" | "viewer";
  department: string | null;
  email: string | null;
  phone: string | null;
  is_active: boolean | null;
};

export type CategoryItem = {
  item_id: string;
  item_code: string;
  item_name: string;
};

export type CaseOverview = {
  case: CaseOverviewRecord;
  occurrences: CaseOccurrence[];
  resolutionEvents: CaseResolutionEvent[];
  participants: Participant[];
  hearings: Hearing[];
  hearingMembers: HearingMember[];
  validationResults: ValidationResult[];
  auditLogs: AuditLog[];
};

export type CaseOverviewRecord = {
  case_id: string;
  court_id: string;
  case_code: string | null;
  case_number: string | null;
  case_type: string;
  case_group: string | null;
  procedure_law: string | null;
  filing_date: string | null;
  acceptance_date: string | null;
  current_stage: string | null;
  case_status: string;
  resolution_status: string | null;
  has_foreign_element: boolean | null;
  is_minor_related: boolean | null;
  is_confidential: boolean | null;
  first_instance_court_id: string | null;
  first_instance_case_number: string | null;
  first_instance_judgment_number: string | null;
  first_instance_judgment_date: string | null;
  closed_date: string | null;
  summary: string | null;
  created_at: string;
  updated_at: string;
  court_code: string | null;
  court_name: string;
  court_level: string | null;
  first_instance_court_code: string | null;
  first_instance_court_name: string | null;
};

export type CaseIntakePayload = {
  case: {
    court_id: string;
    case_code?: string | null;
    case_number?: string | null;
    case_type: "criminal" | "civil" | "administrative" | "marriage_family" | "business_commercial" | "labor";
    case_group?: string | null;
    procedure_law?: string | null;
    filing_date?: string | null;
    acceptance_date?: string | null;
    current_stage?: string | null;
    case_status?: "draft" | "accepted" | "in_progress" | "suspended" | "resolved" | "closed" | "overdue";
    resolution_status?: string | null;
    has_foreign_element?: boolean;
    is_minor_related?: boolean;
    is_confidential?: boolean;
    first_instance_court_id?: string | null;
    first_instance_case_number?: string | null;
    first_instance_judgment_number?: string | null;
    first_instance_judgment_date?: string | null;
    summary?: string | null;
  };
  occurrence?: {
    occurrence_no: number;
    acceptance_date: string;
    acceptance_type_code: "INITIAL_ACCEPTANCE" | "RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION";
    source_note?: string | null;
  };
  criminalDetail?: Record<string, string | null>;
  civilDetail?: Record<string, string | number | boolean | null>;
  administrativeDetail?: Record<string, string | number | null>;
};

export type CaseIntakeResponse = {
  case: CaseOverviewRecord;
  occurrence?: CaseOccurrence | null;
  detail?: {
    tableName: string;
    row: Record<string, unknown>;
  } | null;
};

export type RelatedCreateResponse<T> = T;

export type DefendantCreatePayload = {
  case_id: string;
  full_name: string;
  date_of_birth?: string | null;
  gender?: string | null;
  nationality?: string | null;
  ethnicity?: string | null;
  occupation?: string | null;
  residence?: string | null;
  criminal_record_status?: string | null;
  is_minor?: boolean;
  is_detained?: boolean;
  detention_start_date?: string | null;
  detention_end_date?: string | null;
};

export type Defendant = {
  defendant_id: string;
  criminal_detail_id: string;
  case_id?: string;
  full_name: string;
  date_of_birth: string | null;
  gender: string | null;
  nationality: string | null;
  ethnicity: string | null;
  occupation: string | null;
  residence: string | null;
  criminal_record_status: string | null;
  is_minor: boolean | null;
  is_detained: boolean | null;
  detention_start_date: string | null;
  detention_end_date: string | null;
};

export type CaseAssignmentCreatePayload = {
  case_id: string;
  user_id: string;
  assignment_role: "primary_judge" | "panel_judge" | "clerk" | "procurator" | "assistant" | "other";
  assigned_date?: string | null;
  ended_date?: string | null;
  is_primary?: boolean;
  assignment_method?: "RANDOM" | "DESIGNATED" | "MIXED" | null;
  legal_basis?: string | null;
  designated_reason_code?: string | null;
  status?: "draft" | "running" | "completed" | "cancelled" | "active" | "replaced";
  replacement_reason?: string | null;
};

export type CaseAssignment = CaseAssignmentCreatePayload & {
  assignment_id: string;
  assigned_by: string | null;
  judge_rank_at_assignment: number | null;
  case_order_at_assignment: number | null;
  integrity_hash: string | null;
};

export type ParticipantCreatePayload = {
  case_id: string;
  participant_type: string;
  full_name?: string | null;
  organization_name?: string | null;
  legal_representative?: string | null;
  id_number?: string | null;
  date_of_birth?: string | null;
  gender?: string | null;
  address?: string | null;
  phone?: string | null;
  email?: string | null;
  is_minor?: boolean;
  needs_interpreter?: boolean;
  note?: string | null;
};

export type HearingCreatePayload = {
  case_id: string;
  hearing_type?: string | null;
  scheduled_date?: string | null;
  scheduled_time?: string | null;
  courtroom?: string | null;
  panel_composition?: string | null;
  hearing_status?: string | null;
  postponement_reason?: string | null;
  actual_opened_date?: string | null;
  actual_closed_date?: string | null;
  note?: string | null;
};

export type OccurrenceCreatePayload = {
  case_id: string;
  occurrence_no: number;
  acceptance_date: string;
  acceptance_type_code: "INITIAL_ACCEPTANCE" | "RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION";
  previous_occurrence_id?: string | null;
  source_note?: string | null;
};

export type ResolutionEventCreatePayload = {
  case_id: string;
  occurrence_id: string;
  event_type_code?: string;
  event_date: string;
  resolution_type_code: string;
  return_to_agency_code?: string | null;
  decision_number?: string | null;
  counted_as_resolved?: boolean;
  reason?: string | null;
};

export type CaseOccurrence = {
  occurrence_id: string;
  occurrence_no: number;
  acceptance_date: string;
  acceptance_type_code: string;
  source_note: string | null;
};

export type CaseResolutionEvent = {
  resolution_event_id: string;
  occurrence_id: string;
  event_type_code: string;
  event_date: string;
  resolution_type_code: string;
  decision_number: string | null;
  counted_as_resolved: boolean;
  reason: string | null;
};

export type Participant = {
  participant_id: string;
  case_id?: string;
  participant_type: string;
  full_name: string | null;
  organization_name: string | null;
  legal_representative: string | null;
  id_number?: string | null;
  date_of_birth?: string | null;
  gender?: string | null;
  address?: string | null;
  phone?: string | null;
  email?: string | null;
  is_minor?: boolean | null;
  needs_interpreter?: boolean | null;
  note: string | null;
};

export type Hearing = {
  hearing_id: string;
  case_id?: string;
  hearing_type: string | null;
  scheduled_date: string | null;
  scheduled_time: string | null;
  courtroom: string | null;
  panel_composition?: string | null;
  hearing_status: string | null;
  postponement_reason?: string | null;
  actual_opened_date?: string | null;
  actual_closed_date?: string | null;
  note: string | null;
};

export type HearingMember = {
  case_hearing_member_id: string;
  full_name: string;
  staff_type: string | null;
  position_title: string | null;
  role_code: "PRESIDING_JUDGE" | "PANEL_JUDGE" | "HEARING_CLERK";
  member_order: number;
};

export type ValidationResult = {
  validation_id: string;
  rule_code: string;
  severity: "INFO" | "WARNING" | "ERROR" | "CRITICAL";
  validation_status: string;
  message: string;
  field_name: string | null;
  checked_at: string;
  checked_by: string | null;
  legal_basis: string | null;
  suggested_action: string | null;
};

export type AuditLog = {
  audit_log_id: string;
  table_name: string;
  action: string;
  action_at: string;
  actor_id: string | null;
};
