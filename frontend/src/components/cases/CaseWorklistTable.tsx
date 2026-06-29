import { ChevronLeft, ChevronRight, Eye, FileWarning } from "lucide-react";
import type { ApiMeta, CaseWorklistItem } from "../../types/cases";
import { caseTypeLabel, courtNameLabel, displayText, formatDate } from "../../utils/format";
import { CaseStatusBadge } from "./CaseStatusBadge";

type Props = {
  rows: CaseWorklistItem[];
  meta?: ApiMeta;
  selectedCaseId?: string | null;
  readonly?: boolean;
  onSelect: (caseId: string) => void;
  onPageChange: (page: number) => void;
};

export function CaseWorklistTable({ rows, meta, selectedCaseId, readonly, onSelect, onPageChange }: Props) {
  const page = meta?.page ?? 1;
  const pageSize = meta?.pageSize ?? rows.length;
  const total = meta?.total ?? rows.length;
  const pageCount = Math.max(meta?.pageCount ?? 1, 1);

  return (
    <section className="table-shell" aria-label="Danh sách hồ sơ án">
      <div className="table-summary">
        <span>
          Hiển thị <strong>{rows.length}</strong> / <strong>{total}</strong> hồ sơ
        </span>
      </div>

      <div className="table-scroll">
        <table>
          <thead>
            <tr>
              <th>STT</th>
              <th>Hồ sơ án</th>
              <th>Ngày thụ lý</th>
              <th>Loại án</th>
              <th>Tòa án</th>
              <th>Ngày giải quyết</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row, index) => {
              const ordinal = (page - 1) * pageSize + index + 1;
              const isSelected = row.case_id === selectedCaseId;

              return (
                <tr key={row.case_id} className={isSelected ? "selected-row" : undefined}>
                  <td className="numeric">{ordinal}</td>
                  <td>
                    <div className="case-title">{displayText(row.case_number ?? row.case_code)}</div>
                    <div className="muted small">{displayText(row.case_code)}</div>
                    <div className="muted small">Tóm tắt: {displayText(row.summary)}</div>
                  </td>
                  <td>{formatDate(row.acceptance_date)}</td>
                  <td>{caseTypeLabel(row.case_type)}</td>
                  <td>
                    <div>{courtNameLabel(row.court_name)}</div>
                    <div className="muted small">{displayText(row.court_code)}</div>
                  </td>
                  <td>{formatDate(row.closed_date)}</td>
                  <td>
                    <CaseStatusBadge status={row.case_status} />
                    {row.open_validation_count > 0 ? (
                      <span className="warning-chip warning-chip-inline">
                        <FileWarning size={14} aria-hidden="true" />
                        {row.open_validation_count}
                      </span>
                    ) : (
                      <span className="muted small status-note">Không có cảnh báo</span>
                    )}
                  </td>
                  <td>
                    <button
                      className="icon-button"
                      type="button"
                      disabled={readonly}
                      title={readonly ? "Chỉ xem dữ liệu, thao tác chi tiết đang bị khóa" : "Xem chi tiết hồ sơ"}
                      aria-label="Xem chi tiết hồ sơ"
                      onClick={() => onSelect(row.case_id)}
                    >
                      <Eye size={17} aria-hidden="true" />
                    </button>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <div className="pagination-bar">
        <button
          className="button button-secondary"
          type="button"
          disabled={page <= 1}
          onClick={() => onPageChange(page - 1)}
        >
          <ChevronLeft size={16} aria-hidden="true" />
          Trang trước
        </button>
        <span>
          Trang <strong>{page}</strong> / <strong>{pageCount}</strong>
        </span>
        <button
          className="button button-secondary"
          type="button"
          disabled={page >= pageCount}
          onClick={() => onPageChange(page + 1)}
        >
          Trang sau
          <ChevronRight size={16} aria-hidden="true" />
        </button>
      </div>
    </section>
  );
}
