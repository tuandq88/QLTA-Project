import { useEffect, useMemo, useState } from "react";
import { RefreshCw } from "lucide-react";
import { getCaseOverview, getCaseWorklist, getCourts } from "../../api/cases";
import { CaseOverviewPanel } from "../../components/cases/CaseOverviewPanel";
import { CaseWorklistFilters } from "../../components/cases/CaseWorklistFilters";
import { CaseWorklistTable } from "../../components/cases/CaseWorklistTable";
import { DataState } from "../../components/common/DataState";
import type { ApiMeta, CaseOverview, CaseWorklistItem, CaseWorklistQuery, CourtItem } from "../../types/cases";

type ViewMode = "normal" | "readonly" | "permission_denied";

const initialQuery: CaseWorklistQuery = {
  page: 1,
  pageSize: 20,
  sort_by: "updated_at",
  sort_dir: "desc"
};

export function CaseWorklistPage() {
  const [query, setQuery] = useState<CaseWorklistQuery>(initialQuery);
  const [rows, setRows] = useState<CaseWorklistItem[]>([]);
  const [meta, setMeta] = useState<ApiMeta>();
  const [courts, setCourts] = useState<CourtItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<ViewMode>("normal");

  const [selectedCaseId, setSelectedCaseId] = useState<string | null>(null);
  const [overview, setOverview] = useState<CaseOverview | null>(null);
  const [overviewLoading, setOverviewLoading] = useState(false);
  const [overviewError, setOverviewError] = useState<string | null>(null);

  const readonly = viewMode === "readonly";
  const permissionDenied = viewMode === "permission_denied";
  const warningCountOnPage = useMemo(
    () => rows.reduce((total, row) => total + row.open_validation_count, 0),
    [rows]
  );
  const resolvedCountOnPage = useMemo(
    () => rows.filter((row) => ["resolved", "effective", "closed"].includes(row.case_status)).length,
    [rows]
  );

  useEffect(() => {
    let ignore = false;

    async function loadCourts() {
      try {
        const response = await getCourts();
        if (!ignore) setCourts(response.data ?? []);
      } catch {
        if (!ignore) setCourts([]);
      }
    }

    void loadCourts();
    return () => {
      ignore = true;
    };
  }, []);

  useEffect(() => {
    if (permissionDenied) return;

    let ignore = false;
    setLoading(true);
    setError(null);

    getCaseWorklist(query)
      .then((response) => {
        if (ignore) return;
        setRows(response.data ?? []);
        setMeta(response.meta);
      })
      .catch((err: unknown) => {
        if (ignore) return;
        setRows([]);
        setMeta(undefined);
        setError(err instanceof Error ? err.message : "Không tải được danh sách hồ sơ án.");
      })
      .finally(() => {
        if (!ignore) setLoading(false);
      });

    return () => {
      ignore = true;
    };
  }, [permissionDenied, query]);

  useEffect(() => {
    if (!selectedCaseId || permissionDenied) {
      setOverview(null);
      return;
    }

    let ignore = false;
    setOverviewLoading(true);
    setOverviewError(null);
    setOverview(null);

    getCaseOverview(selectedCaseId)
      .then((response) => {
        if (!ignore) setOverview(response.data ?? null);
      })
      .catch((err: unknown) => {
        if (!ignore) setOverviewError(err instanceof Error ? err.message : "Không tải được chi tiết hồ sơ.");
      })
      .finally(() => {
        if (!ignore) setOverviewLoading(false);
      });

    return () => {
      ignore = true;
    };
  }, [permissionDenied, selectedCaseId]);

  const sortedRows = useMemo(() => {
    const sortBy = query.sort_by ?? "updated_at";
    const direction = query.sort_dir === "asc" ? 1 : -1;
    return [...rows].sort((left, right) => {
      const leftValue = getSortValue(left, sortBy);
      const rightValue = getSortValue(right, sortBy);
      return leftValue.localeCompare(rightValue, "vi") * direction;
    });
  }, [query.sort_by, query.sort_dir, rows]);

  function updateQuery(patch: Partial<CaseWorklistQuery>) {
    setQuery((current) => ({ ...current, ...patch }));
  }

  function resetFilters() {
    setQuery(initialQuery);
  }

  return (
    <main className="app-shell">
      <header className="page-header">
        <div>
          <p className="eyebrow">TAND hai cấp tỉnh Quảng Ngãi</p>
          <h1>Quản lý hồ sơ án</h1>
          <p>Tra cứu, rà soát trạng thái và mở nhanh chi tiết từng hồ sơ vụ án.</p>
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
          <button className="button button-primary" type="button" onClick={() => setQuery((current) => ({ ...current }))}>
            <RefreshCw size={16} aria-hidden="true" />
            Tải lại
          </button>
        </div>
      </header>

      <section className="metric-strip" aria-label="Tổng quan trang hiện tại">
        <div>
          <span className="metric-label">Tổng hồ sơ</span>
          <strong>{meta?.total ?? "Chưa có dữ liệu"}</strong>
        </div>
        <div>
          <span className="metric-label">Hồ sơ trên trang</span>
          <strong>{rows.length}</strong>
          <span className="metric-note">Trang {meta?.page ?? query.page}</span>
        </div>
        <div>
          <span className="metric-label">Đã giải quyết trên trang</span>
          <strong>{resolvedCountOnPage}</strong>
          <span className="metric-note">Chỉ đếm dữ liệu đang hiển thị</span>
        </div>
        <div className={warningCountOnPage > 0 ? "metric-warning" : undefined}>
          <span className="metric-label">Cảnh báo mở trên trang</span>
          <strong>{warningCountOnPage}</strong>
          <span className="metric-note">Cần rà soát</span>
        </div>
      </section>

      <CaseWorklistFilters
        query={query}
        courts={courts}
        disabled={permissionDenied}
        onChange={updateQuery}
        onReset={resetFilters}
      />

      <div className="workspace-grid">
        <section className="worklist-column">
          {permissionDenied ? (
            <DataState state="permission_denied" />
          ) : loading ? (
            <DataState state="loading" />
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
          ) : rows.length === 0 ? (
            <DataState state="empty" />
          ) : (
            <>
              {readonly ? <DataState state="readonly" /> : null}
              <CaseWorklistTable
                rows={sortedRows}
                meta={meta}
                selectedCaseId={selectedCaseId}
                readonly={false}
                onSelect={setSelectedCaseId}
                onPageChange={(page) => updateQuery({ page })}
              />
            </>
          )}
        </section>

        <CaseOverviewPanel
          overview={overview}
          loading={overviewLoading}
          error={overviewError}
          readonly={readonly}
          permissionDenied={permissionDenied}
          onClose={() => setSelectedCaseId(null)}
        />
      </div>
    </main>
  );
}

function getSortValue(row: CaseWorklistItem, sortBy: NonNullable<CaseWorklistQuery["sort_by"]>) {
  if (sortBy === "court_name") return row.court_name ?? "";
  const value = row[sortBy];
  return value === null || value === undefined ? "" : String(value);
}
