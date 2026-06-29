import { downloadFile, getJson } from "./client";
import type { ApiResponse } from "../types/cases";
import type { StatisticalReport, StatisticalReportQuery } from "../types/statistics";

export function getStatisticalReport(
  formCode: string,
  query: StatisticalReportQuery
): Promise<ApiResponse<StatisticalReport>> {
  return getJson<StatisticalReport>(`/api/statistics/reports/${formCode}`, query);
}

export function exportStatisticalReport(formCode: string, query: StatisticalReportQuery) {
  return downloadFile(`/api/statistics/reports/${formCode}/export`, {
    ...query,
    format: "xlsx"
  });
}
