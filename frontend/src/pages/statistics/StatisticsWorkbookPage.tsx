import { useEffect, useMemo, useState } from "react";
import {
  AlertTriangle,
  CheckCircle2,
  Download,
  FileSpreadsheet,
  RefreshCw,
  Search,
  ZoomIn,
  ZoomOut
} from "lucide-react";
import workbookData from "../../data/statistics-workbooks.json";
import { getCourts } from "../../api/cases";
import { exportStatisticalReport, getStatisticalReport } from "../../api/statistics";
import { DataState } from "../../components/common/DataState";
import { WorkbookGrid } from "../../components/statistics/WorkbookGrid";
import type { CourtItem, DataState as DataStateType } from "../../types/cases";
import type { StatisticalReport, StatisticsWorkbook } from "../../types/statistics";

const workbooks = workbookData as unknown as StatisticsWorkbook[];

function defaultPeriod() {
  const today = new Date();
  const workingYear = today.getMonth() >= 9 ? today.getFullYear() + 1 : today.getFullYear();
  return {
    from_date: `${workingYear - 1}-10-01`,
    to_date: `${workingYear}-09-30`
  };
}

const initialPeriod = defaultPeriod();

export function StatisticsWorkbookPage() {
  const [selectedId, setSelectedId] = useState(() => window.location.hash.replace("#statistics/", "") || workbooks[0].id);
  const [search, setSearch] = useState("");
  const [fromDate, setFromDate] = useState(initialPeriod.from_date);
  const [toDate, setToDate] = useState(initialPeriod.to_date);
  const [courtId, setCourtId] = useState("");
  const [courts, setCourts] = useState<CourtItem[]>([]);
  const [report, setReport] = useState<StatisticalReport | null>(null);
  const [state, setState] = useState<DataStateType>("idle");
  const [message, setMessage] = useState("");
  const [zoom, setZoom] = useState(1);
  const [exporting, setExporting] = useState(false);
  const selected = workbooks.find((workbook) => workbook.id === selectedId) ?? workbooks[0];

  const grouped = useMemo(() => {
    const term = search.trim().toLocaleLowerCase("vi-VN");
    return workbooks.reduce<Record<string, StatisticsWorkbook[]>>((groups, workbook) => {
      if (term && !`${workbook.title} ${workbook.stageLabel}`.toLocaleLowerCase("vi-VN").includes(term)) return groups;
      (groups[workbook.caseType] ??= []).push(workbook);
      return groups;
    }, {});
  }, [search]);

  useEffect(() => {
    getCourts()
      .then((response) => setCourts(response.data ?? []))
      .catch(() => setCourts([]));
  }, []);

  useEffect(() => {
    window.location.hash = `statistics/${selected.id}`;
    setReport(null);
    setMessage("");
    if (!selected.formCode) {
      setState("empty");
      return;
    }
    void loadReport(selected.formCode);
    // Filters are applied explicitly by the user; selecting a workbook loads the current filter values.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selected.id]);

  async function loadReport(formCode = selected.formCode) {
    if (!formCode) return;
    if (fromDate > toDate) {
      setState("error");
      setMessage("Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.");
      return;
    }
    setState("loading");
    setMessage("");
    try {
      const response = await getStatisticalReport(formCode, {
        from_date: fromDate,
        to_date: toDate,
        court_id: courtId || undefined
      });
      const nextReport = response.data ?? null;
      setReport(nextReport);
      setState(nextReport ? "readonly" : "empty");
    } catch (error) {
      setReport(null);
      setState("error");
      setMessage(error instanceof Error ? error.message : "Không tải được số liệu thống kê.");
    }
  }

  function selectWorkbook(workbook: StatisticsWorkbook) {
    setSelectedId(workbook.id);
    setZoom(1);
  }

  async function handleExport() {
    if (!selected.formCode) return;
    setExporting(true);
    try {
      await exportStatisticalReport(selected.formCode, {
        from_date: fromDate,
        to_date: toDate,
        court_id: courtId || undefined
      });
    } catch (error) {
      setState("error");
      setMessage(error instanceof Error ? error.message : "Không xuất được workbook.");
    } finally {
      setExporting(false);
    }
  }

  const traceableCount = report
    ? Object.values(report.cells).filter((cell) => cell.status === "source" || cell.status === "formula").length
    : 0;

  return (
    <main className="app-shell statistics-shell">
      <header className="page-header statistics-page-header">
        <div>
          <p className="eyebrow">Biểu mẫu thống kê nghiệp vụ</p>
          <h1>{selected.title}</h1>
          <p>Mỗi trang giữ nguyên cấu trúc sheet nguồn để rà soát và nhận số liệu được tính từ hệ thống.</p>
        </div>
        <div className="statistics-header-meta">
          <span><FileSpreadsheet size={16} aria-hidden="true" /> {selected.fileName}</span>
          <span>Sheet: {selected.sheetName}</span>
        </div>
      </header>

      <section className="statistics-layout">
        <aside className="statistics-catalog" aria-label="Danh mục biểu mẫu thống kê">
          <div className="statistics-catalog-search">
            <Search size={16} aria-hidden="true" />
            <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Tìm biểu mẫu" aria-label="Tìm biểu mẫu" />
          </div>
          <div className="statistics-catalog-list">
            {Object.entries(grouped).map(([caseType, items]) => (
              <section key={caseType}>
                <h2>{caseType}</h2>
                {items.map((workbook) => (
                  <button
                    key={workbook.id}
                    type="button"
                    className={workbook.id === selected.id ? "statistics-template-active" : ""}
                    onClick={() => selectWorkbook(workbook)}
                  >
                    <span>{workbook.stageLabel}</span>
                    <small>{workbook.formCode ?? "Chưa mapping API"}</small>
                  </button>
                ))}
              </section>
            ))}
          </div>
        </aside>

        <div className="statistics-workspace">
          <section className="statistics-toolbar" aria-label="Bộ lọc báo cáo">
            <label className="field">
              <span>Từ ngày</span>
              <input type="date" value={fromDate} onChange={(event) => setFromDate(event.target.value)} />
            </label>
            <label className="field">
              <span>Đến ngày</span>
              <input type="date" value={toDate} onChange={(event) => setToDate(event.target.value)} />
            </label>
            <label className="field statistics-court-field">
              <span>Đơn vị Tòa án</span>
              <select value={courtId} onChange={(event) => setCourtId(event.target.value)}>
                <option value="">Tất cả đơn vị được phép xem</option>
                {courts.map((court) => <option key={court.court_id} value={court.court_id}>{court.court_name}</option>)}
              </select>
            </label>
            <button className="button button-primary" type="button" onClick={() => void loadReport()} disabled={!selected.formCode || state === "loading"}>
              <RefreshCw size={16} className={state === "loading" ? "spin" : ""} aria-hidden="true" /> Tính số liệu
            </button>
            <button className="button button-secondary" type="button" onClick={() => void handleExport()} disabled={!selected.formCode || exporting}>
              <Download size={16} aria-hidden="true" /> {exporting ? "Đang xuất" : "Xuất Excel"}
            </button>
          </section>

          <section className="statistics-status-bar" aria-label="Trạng thái biểu mẫu">
            <div>
              {report?.status === "invalid" ? <AlertTriangle size={16} aria-hidden="true" /> : <CheckCircle2 size={16} aria-hidden="true" />}
              <span>{selected.formCode ? `Mẫu ${selected.formCode}` : "Chưa có mapping nguồn dữ liệu"}</span>
              {report ? <span>{traceableCount} cột có thể truy vết</span> : null}
              {report?.unmappedCells.length ? <span>{report.unmappedCells.length} cột chưa mapping</span> : null}
            </div>
            <div className="statistics-zoom" aria-label="Thu phóng biểu mẫu">
              <button type="button" onClick={() => setZoom((value) => Math.max(0.6, value - 0.1))} aria-label="Thu nhỏ"><ZoomOut size={16} /></button>
              <span>{Math.round(zoom * 100)}%</span>
              <button type="button" onClick={() => setZoom((value) => Math.min(1.4, value + 0.1))} aria-label="Phóng to"><ZoomIn size={16} /></button>
            </div>
          </section>

          {state === "loading" ? <DataState state="loading" title="Đang tính số liệu thống kê" description="Hệ thống đang tổng hợp theo kỳ và đơn vị đã chọn." /> : null}
          {state === "error" ? <DataState state="error" title="Không tải được biểu mẫu" description={message} action={<button className="button button-secondary" type="button" onClick={() => void loadReport()}>Thử lại</button>} /> : null}
          {!selected.formCode ? (
            <DataState
              state="empty"
              title="Biểu mẫu đang ở chế độ khung"
              description="Cấu trúc workbook đã được render đầy đủ. Chưa có mapping nguồn và công thức được duyệt cho cấp xét xử này nên hệ thống không tự điền số liệu."
            />
          ) : null}

          <WorkbookGrid workbook={selected} report={report} fromDate={fromDate} toDate={toDate} zoom={zoom} />

          <footer className="workbook-legend">
            <span>Di chuột vào ô dòng “Tổng cộng” để xem trạng thái nguồn và công thức.</span>
            <span>Số liệu chỉ đọc, không ghi đè dữ liệu hồ sơ.</span>
          </footer>
        </div>
      </section>
    </main>
  );
}
