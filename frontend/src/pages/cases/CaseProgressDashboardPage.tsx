import { useEffect, useMemo, useState, type ReactNode } from "react";
import {
  AlertTriangle,
  BarChart3,
  CalendarDays,
  CheckCircle2,
  FileDown,
  FileSpreadsheet,
  Gavel,
  RefreshCw,
  UserCheck
} from "lucide-react";
import {
  exportCasePeriodReport,
  getCasePeriodCases,
  getCaseProgressDashboard,
  getCourts,
  getUsers
} from "../../api/cases";
import { DataState } from "../../components/common/DataState";
import type {
  CaseProgressDashboard,
  CaseProgressDashboardQuery,
  CasePeriodCategory,
  CasePeriodReportItem,
  CourtItem,
  UserItem
} from "../../types/cases";
import { caseTypeLabel, courtNameLabel } from "../../utils/format";

type ViewMode = "normal" | "readonly" | "permission_denied";

const caseTypes = [
  "civil",
  "marriage_family",
  "business_commercial",
  "labor",
  "criminal",
  "administrative",
  "other"
];

const initialQuery: CaseProgressDashboardQuery = {
  from_date: "2025-10-01",
  to_date: "2026-09-30"
};

export function CaseProgressDashboardPage() {
  const [query, setQuery] = useState<CaseProgressDashboardQuery>(initialQuery);
  const [data, setData] = useState<CaseProgressDashboard | null>(null);
  const [periodLists, setPeriodLists] = useState<Record<CasePeriodCategory, CasePeriodReportItem[]>>({
    accepted_in_period: [],
    opening_pending: [],
    resolved_in_period: []
  });
  const [courts, setCourts] = useState<CourtItem[]>([]);
  const [judges, setJudges] = useState<UserItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<ViewMode>("normal");
  const [exporting, setExporting] = useState<"xlsx" | "pdf" | null>(null);

  const permissionDenied = viewMode === "permission_denied";
  const readonly = viewMode === "readonly";

  useEffect(() => {
    let ignore = false;

    async function loadFilters() {
      const [courtResponse, judgeResponse] = await Promise.all([
        getCourts().catch(() => ({ data: [] })),
        getUsers({ role_code: "judge" }).catch(() => ({ data: [] }))
      ]);

      if (!ignore) {
        setCourts(courtResponse.data ?? []);
        setJudges(judgeResponse.data ?? []);
      }
    }

    void loadFilters();
    return () => {
      ignore = true;
    };
  }, []);

  useEffect(() => {
    if (permissionDenied) return;

    let ignore = false;
    setLoading(true);
    setError(null);

    Promise.all([
      getCaseProgressDashboard(query),
      getCasePeriodCases(query, "accepted_in_period"),
      getCasePeriodCases(query, "opening_pending"),
      getCasePeriodCases(query, "resolved_in_period")
    ])
      .then(([dashboard, accepted, openingPending, resolved]) => {
        if (!ignore) {
          setData(dashboard.data ?? null);
          setPeriodLists({
            accepted_in_period: accepted.data ?? [],
            opening_pending: openingPending.data ?? [],
            resolved_in_period: resolved.data ?? []
          });
        }
      })
      .catch((err: unknown) => {
        if (!ignore) {
          setData(null);
          setPeriodLists({ accepted_in_period: [], opening_pending: [], resolved_in_period: [] });
          setError(err instanceof Error ? err.message : "Không tải được dữ liệu dashboard.");
        }
      })
      .finally(() => {
        if (!ignore) setLoading(false);
      });

    return () => {
      ignore = true;
    };
  }, [permissionDenied, query]);

  const totals = data?.totals;
  const clearanceRate = totals && totals.total_cases > 0 ? Math.round((totals.resolved_cases / totals.total_cases) * 100) : 0;
  const randomAssignmentRate =
    totals && totals.total_cases > 0 ? Math.round((totals.random_assigned_cases / totals.total_cases) * 100) : 0;

  const maxTypeCount = useMemo(
    () => Math.max(1, ...(data?.byType.map((item) => item.accepted_count) ?? [1])),
    [data?.byType]
  );

  const maxMonthCount = useMemo(
    () => Math.max(1, ...(data?.byMonth.map((item) => Math.max(item.accepted_count, item.resolved_count)) ?? [1])),
    [data?.byMonth]
  );

  function updateQuery(patch: Partial<CaseProgressDashboardQuery>) {
    setQuery((current) => ({ ...current, ...patch }));
  }

  function resetFilters() {
    setQuery(initialQuery);
  }

  async function handleExport(format: "xlsx" | "pdf") {
    setExporting(format);
    setError(null);
    try {
      await exportCasePeriodReport(query, format);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Không xuất được báo cáo.");
    } finally {
      setExporting(null);
    }
  }

  return (
    <main className="app-shell dashboard-shell">
      <header className="page-header dashboard-header">
        <div>
          <p className="eyebrow">Dashboard điều hành</p>
          <h1>Theo dõi thụ lý, giải quyết và án hủy/sửa</h1>
          <p>
            Màn hình phục vụ lãnh đạo theo dõi tiến trình xử lý hồ sơ theo thời gian, tiến độ của từng Thẩm phán và
            kết quả cấp trên đối với hồ sơ của đơn vị.
          </p>
        </div>
        <div className="header-actions">
          <label className="mode-control">
            <span>Trạng thái quyền</span>
            <select value={viewMode} onChange={(event) => setViewMode(event.target.value as ViewMode)}>
              <option value="normal">Được xem</option>
              <option value="readonly">Chỉ xem</option>
              <option value="permission_denied">Từ chối quyền</option>
            </select>
          </label>
          <button className="button button-secondary" type="button" disabled={permissionDenied || exporting !== null} onClick={() => void handleExport("xlsx")}>
            <FileSpreadsheet size={16} aria-hidden="true" />
            {exporting === "xlsx" ? "Đang xuất..." : "Xuất Excel"}
          </button>
          <button className="button button-secondary" type="button" disabled={permissionDenied || exporting !== null} onClick={() => void handleExport("pdf")}>
            <FileDown size={16} aria-hidden="true" />
            {exporting === "pdf" ? "Đang xuất..." : "Xuất PDF"}
          </button>
          <button className="button button-primary" type="button" onClick={() => setQuery((current) => ({ ...current }))}>
            <RefreshCw size={16} aria-hidden="true" />
            Tải lại
          </button>
        </div>
      </header>

      <section className="dashboard-filter-panel" aria-label="Bộ lọc dashboard">
        <div className="filter-title">
          <CalendarDays size={18} aria-hidden="true" />
          <span>Kỳ theo dõi</span>
        </div>
        <label className="field">
          <span>Từ ngày (bao gồm)</span>
          <input
            type="date"
            value={query.from_date ?? ""}
            disabled={permissionDenied}
            onChange={(event) => updateQuery({ from_date: event.target.value || undefined })}
          />
        </label>
        <label className="field">
          <span>Đến ngày (bao gồm)</span>
          <input
            type="date"
            value={query.to_date ?? ""}
            disabled={permissionDenied}
            onChange={(event) => updateQuery({ to_date: event.target.value || undefined })}
          />
        </label>
        <label className="field">
          <span>Tòa án</span>
          <select
            value={query.court_id ?? ""}
            disabled={permissionDenied}
            onChange={(event) => updateQuery({ court_id: event.target.value || undefined })}
          >
            <option value="">Tất cả</option>
            {courts.map((court) => (
              <option key={court.court_id} value={court.court_id}>
                {courtNameLabel(court.court_name)}
              </option>
            ))}
          </select>
        </label>
        <label className="field">
          <span>Loại án</span>
          <select
            value={query.case_type ?? ""}
            disabled={permissionDenied}
            onChange={(event) => updateQuery({ case_type: event.target.value || undefined })}
          >
            <option value="">Tất cả</option>
            {caseTypes.map((type) => (
              <option key={type} value={type}>
                {caseTypeLabel(type)}
              </option>
            ))}
          </select>
        </label>
        <label className="field">
          <span>Thẩm phán</span>
          <select
            value={query.judge_id ?? ""}
            disabled={permissionDenied}
            onChange={(event) => updateQuery({ judge_id: event.target.value || undefined })}
          >
            <option value="">Tất cả</option>
            {judges.map((judge) => (
              <option key={judge.user_id} value={judge.user_id}>
                {judge.full_name}
              </option>
            ))}
          </select>
        </label>
        <button className="button button-secondary" type="button" onClick={resetFilters} disabled={permissionDenied}>
          Đặt lại
        </button>
      </section>

      {permissionDenied ? (
        <DataState state="permission_denied" />
      ) : loading ? (
        <DataState state="loading" title="Đang tải dashboard" description="Hệ thống đang tổng hợp số liệu điều hành." />
      ) : error ? (
        <DataState
          state="error"
          description={error}
          action={
            <button className="button button-secondary" type="button" onClick={() => setQuery((current) => ({ ...current }))}>
              Thử lại
            </button>
          }
        />
      ) : !data || !totals || totals.total_cases === 0 ? (
        <DataState
          state="empty"
          title="Chưa có số liệu trong kỳ"
          description="Không tìm thấy hồ sơ phù hợp với bộ lọc hiện tại."
        />
      ) : (
        <>
          {readonly ? <DataState state="readonly" description="Dashboard đang ở chế độ chỉ xem, không có thao tác ghi dữ liệu." /> : null}

          <section className="dashboard-kpi-grid" aria-label="Tổng quan tiến trình">
            <MetricCard icon={<Gavel />} label="Thụ lý mới trong kỳ" value={totals.accepted_in_period_cases} />
            <MetricCard icon={<CheckCircle2 />} label="Đã giải quyết trong kỳ" value={totals.resolved_cases} note={`${clearanceRate}% trên số phải giải quyết`} />
            <MetricCard icon={<BarChart3 />} label="Tồn đến cuối kỳ" value={totals.pending_cases} note={`${totals.opening_pending_cases} hồ sơ thụ lý trước kỳ`} />
            <MetricCard
              icon={<AlertTriangle />}
              label="Quá hạn/cảnh báo"
              value={totals.overdue_cases + totals.open_validation_count}
              note={`${totals.overdue_cases} quá hạn, ${totals.open_validation_count} cảnh báo dữ liệu`}
              tone="warning"
            />
            <MetricCard
              icon={<UserCheck />}
              label="Phân công ngẫu nhiên"
              value={`${randomAssignmentRate}%`}
              note={`${totals.random_assigned_cases} hồ sơ được phân công ngẫu nhiên`}
            />
          </section>

          <section className="dashboard-grid">
            <div className="dashboard-panel dashboard-panel-wide">
              <PanelHeader title="Tiến trình thụ lý và giải quyết theo tháng" />
              <div className="month-chart" role="img" aria-label="Biểu đồ cột thụ lý và giải quyết theo tháng">
                {data.byMonth.map((item) => (
                  <div className="month-chart-row" key={item.period}>
                    <span>{item.period}</span>
                    <div className="month-bars">
                      <span className="bar accepted" style={{ width: `${(item.accepted_count / maxMonthCount) * 100}%` }}>
                        {item.accepted_count}
                      </span>
                      <span className="bar resolved" style={{ width: `${(item.resolved_count / maxMonthCount) * 100}%` }}>
                        {item.resolved_count}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
              <div className="chart-legend">
                <span><i className="legend-accepted" /> Thụ lý</span>
                <span><i className="legend-resolved" /> Giải quyết</span>
              </div>
            </div>

            <div className="dashboard-panel">
              <PanelHeader title="Cơ cấu theo loại án" />
              <div className="type-bars">
                {data.byType.map((item) => {
                  const resolvedRate = item.accepted_count > 0 ? Math.round((item.resolved_count / item.accepted_count) * 100) : 0;
                  return (
                    <div className="type-bar-item" key={item.case_type}>
                      <div>
                        <strong>{caseTypeLabel(item.case_type)}</strong>
                        <span>{item.resolved_count}/{item.accepted_count} đã giải quyết, {item.overdue_count} quá hạn</span>
                      </div>
                      <div className="progress-track" aria-label={`${resolvedRate}% đã giải quyết`}>
                        <span style={{ width: `${(item.accepted_count / maxTypeCount) * 100}%` }} />
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            <div className="dashboard-panel dashboard-panel-wide">
              <PanelHeader title="Tiến độ công việc của từng Thẩm phán" />
              <div className="compact-table-scroll">
                <table className="compact-table judge-table">
                  <thead>
                    <tr>
                      <th>Thẩm phán</th>
                      <th className="numeric">Được phân công</th>
                      <th className="numeric">Đã giải quyết</th>
                      <th className="numeric">Tỷ lệ</th>
                      <th className="numeric">Quá hạn</th>
                      <th className="numeric">Cảnh báo</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.judgeProgress.map((judge) => {
                      const rate = judge.assigned_count > 0 ? Math.round((judge.resolved_count / judge.assigned_count) * 100) : 0;
                      return (
                        <tr key={judge.judge_id ?? "unassigned"}>
                          <td>
                            <strong>{judge.judge_name}</strong>
                            <div className="mini-progress"><span style={{ width: `${rate}%` }} /></div>
                          </td>
                          <td className="numeric">{judge.assigned_count}</td>
                          <td className="numeric">{judge.resolved_count}</td>
                          <td className="numeric">{rate}%</td>
                          <td className="numeric">{judge.overdue_count}</td>
                          <td className="numeric">{judge.open_validation_count}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>

            <div className="dashboard-panel">
              <PanelHeader title="Theo dõi án hủy/sửa" />
              {data.appellateQuality.length === 0 ? (
                <p className="empty-inline">Chưa có kết quả cấp trên trong kỳ lọc.</p>
              ) : (
                <ul className="quality-list">
                  {data.appellateQuality.map((item) => (
                    <li key={`${item.result_code}-${item.fault_classification}`}>
                      <div>
                        <strong>{qualityResultLabel(item.result_code)}</strong>
                        <span>Phân loại lỗi: {faultLabel(item.fault_classification)}</span>
                      </div>
                      <b>{item.tracking_count}</b>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          </section>

          <section className="period-report-grid" aria-label="Danh sách vụ án theo kỳ báo cáo">
            <PeriodCaseTable
              title="Thụ lý mới trong kỳ"
              description="Ngày thụ lý nằm trong kỳ báo cáo."
              rows={periodLists.accepted_in_period}
            />
            <PeriodCaseTable
              title="Thụ lý trước kỳ, chưa giải quyết đến cuối kỳ"
              description="Bao gồm hồ sơ đã có kết quả sau ngày cuối kỳ; kết quả đó chỉ hiển thị ở ghi chú."
              rows={periodLists.opening_pending}
            />
            <PeriodCaseTable
              title="Giải quyết trong kỳ"
              description="Ngày giải quyết nằm trong kỳ báo cáo."
              rows={periodLists.resolved_in_period}
            />
          </section>
        </>
      )}
    </main>
  );
}

function PeriodCaseTable({ title, description, rows }: { title: string; description: string; rows: CasePeriodReportItem[] }) {
  return (
    <article className="dashboard-panel period-report-panel">
      <div className="panel-header">
        <h2>{title} <span className="report-count">{rows.length}</span></h2>
        <p>{description}</p>
      </div>
      {rows.length === 0 ? (
        <p className="empty-inline report-empty">Không có hồ sơ phù hợp.</p>
      ) : (
        <div className="compact-table-scroll">
          <table className="compact-table period-case-table">
            <thead>
              <tr>
                <th>Hồ sơ</th>
                <th>Loại án</th>
                <th>Đơn vị / Thẩm phán</th>
                <th>Ngày thụ lý</th>
                <th>Kết quả trong kỳ</th>
                <th>Ghi chú</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.case_id} className={row.is_resolved_after_period ? "after-period-row" : undefined}>
                  <td><strong>{row.case_number ?? row.case_code ?? "Chưa có số"}</strong></td>
                  <td>{caseTypeLabel(row.case_type)}</td>
                  <td>{courtNameLabel(row.court_name)}<small>{row.judge_name}</small></td>
                  <td>{formatReportDate(row.acceptance_date)}</td>
                  <td>
                    {row.report_resolution_status ?? "—"}
                    {row.report_resolution_date ? <small>{formatReportDate(row.report_resolution_date)}</small> : null}
                  </td>
                  <td>
                    {row.is_resolved_after_period ? <span className="after-period-badge">Sau kỳ báo cáo</span> : null}
                    {row.report_note ? <small>{row.report_note}</small> : "—"}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </article>
  );
}

function formatReportDate(value: string | null) {
  if (!value) return "—";
  const [year, month, day] = value.slice(0, 10).split("-");
  return `${day}/${month}/${year}`;
}

function MetricCard({
  icon,
  label,
  value,
  note,
  tone
}: {
  icon: ReactNode;
  label: string;
  value: ReactNode;
  note?: string;
  tone?: "warning";
}) {
  return (
    <article className={`dashboard-metric ${tone === "warning" ? "dashboard-metric-warning" : ""}`}>
      <div className="dashboard-metric-icon">{icon}</div>
      <div>
        <span>{label}</span>
        <strong>{value}</strong>
        {note ? <small>{note}</small> : null}
      </div>
    </article>
  );
}

function PanelHeader({ title }: { title: string }) {
  return (
    <div className="panel-header">
      <h2>{title}</h2>
    </div>
  );
}

function qualityResultLabel(value: string) {
  const normalized = value.toLowerCase();
  if (normalized.includes("cancel") || normalized.includes("huy")) return "Án hủy";
  if (normalized.includes("modif") || normalized.includes("sua")) return "Án sửa";
  if (normalized.includes("upheld") || normalized.includes("giu")) return "Giữ nguyên";
  return value === "unknown" ? "Chưa phân loại kết quả" : value;
}

function faultLabel(value: string) {
  const labels: Record<string, string> = {
    objective: "Khách quan",
    subjective: "Chủ quan",
    mixed: "Hỗn hợp",
    unknown: "Chưa xác định"
  };

  return labels[value] ?? value;
}
