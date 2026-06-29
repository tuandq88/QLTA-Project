import { downloadFile, getJson, postJson } from "./client";
import type {
  ApiResponse,
  CaseOverview,
  CaseProgressDashboard,
  CaseProgressDashboardQuery,
  CasePeriodCategory,
  CasePeriodReportItem,
  CaseIntakePayload,
  CaseIntakeResponse,
  CaseAssignment,
  CaseAssignmentCreatePayload,
  CaseOccurrence,
  CaseResolutionEvent,
  CaseWorklistItem,
  CaseWorklistQuery,
  CategoryItem,
  CourtItem,
  Defendant,
  DefendantCreatePayload,
  Hearing,
  HearingCreatePayload,
  OccurrenceCreatePayload,
  Participant,
  ParticipantCreatePayload,
  ResolutionEventCreatePayload,
  UserItem
} from "../types/cases";

export function getCaseWorklist(query: CaseWorklistQuery): Promise<ApiResponse<CaseWorklistItem[]>> {
  return getJson<CaseWorklistItem[]>("/api/cases/worklist", {
    page: query.page,
    pageSize: query.pageSize,
    search: query.search,
    court_id: query.court_id,
    case_type: query.case_type,
    case_group: query.case_group,
    case_status: query.case_status,
    current_stage: query.current_stage,
    from_date: query.from_date,
    to_date: query.to_date
  });
}

export function getCaseProgressDashboard(query: CaseProgressDashboardQuery): Promise<ApiResponse<CaseProgressDashboard>> {
  return getJson<CaseProgressDashboard>("/api/dashboard/case-progress", {
    from_date: query.from_date,
    to_date: query.to_date,
    court_id: query.court_id,
    case_type: query.case_type,
    judge_id: query.judge_id
  });
}

export function getCasePeriodCases(query: CaseProgressDashboardQuery, category: CasePeriodCategory) {
  return getJson<CasePeriodReportItem[]>("/api/statistics/case-period", {
    from_date: query.from_date,
    to_date: query.to_date,
    court_id: query.court_id,
    case_type: query.case_type,
    judge_id: query.judge_id,
    category
  });
}

export function exportCasePeriodReport(query: CaseProgressDashboardQuery, format: "xlsx" | "pdf") {
  return downloadFile("/api/statistics/case-period/export", {
    from_date: query.from_date,
    to_date: query.to_date,
    court_id: query.court_id,
    case_type: query.case_type,
    judge_id: query.judge_id,
    format
  });
}

export function getCaseOverview(caseId: string): Promise<ApiResponse<CaseOverview>> {
  return getJson<CaseOverview>(`/api/cases/${caseId}/overview`);
}

export function getCourts(): Promise<ApiResponse<CourtItem[]>> {
  return getJson<CourtItem[]>("/api/courts", { page: 1, pageSize: 100 });
}

export function getUsers(query?: { role_code?: string; court_id?: string }): Promise<ApiResponse<UserItem[]>> {
  return getJson<UserItem[]>("/api/users", {
    page: 1,
    pageSize: 100,
    role_code: query?.role_code,
    court_id: query?.court_id
  });
}

export function getCategoryItems(categoryCode: string): Promise<ApiResponse<CategoryItem[]>> {
  return getJson<CategoryItem[]>(`/api/categories/${categoryCode}/items`);
}

export function createCaseIntake(payload: CaseIntakePayload): Promise<ApiResponse<CaseIntakeResponse>> {
  return postJson<CaseIntakeResponse>("/api/cases/intake", payload);
}

export function createParticipant(payload: ParticipantCreatePayload): Promise<ApiResponse<Participant>> {
  return postJson<Participant>("/api/participants", payload);
}

export function createDefendant(payload: DefendantCreatePayload): Promise<ApiResponse<Defendant>> {
  return postJson<Defendant>("/api/defendants", payload);
}

export function createCaseAssignment(payload: CaseAssignmentCreatePayload): Promise<ApiResponse<CaseAssignment>> {
  return postJson<CaseAssignment>("/api/case-assignments", payload);
}

export function createHearing(payload: HearingCreatePayload): Promise<ApiResponse<Hearing>> {
  return postJson<Hearing>("/api/hearings", payload);
}

export function createCaseOccurrence(payload: OccurrenceCreatePayload): Promise<ApiResponse<CaseOccurrence>> {
  return postJson<CaseOccurrence>("/api/case-occurrences", payload);
}

export function createResolutionEvent(payload: ResolutionEventCreatePayload): Promise<ApiResponse<CaseResolutionEvent>> {
  return postJson<CaseResolutionEvent>("/api/case-resolution-events", payload);
}
