import { Filter, RotateCcw, Search } from "lucide-react";
import type { CaseWorklistQuery, CourtItem } from "../../types/cases";
import { caseTypeLabel, courtNameLabel, statusLabel } from "../../utils/format";

type Props = {
  query: CaseWorklistQuery;
  courts: CourtItem[];
  disabled?: boolean;
  onChange: (patch: Partial<CaseWorklistQuery>) => void;
  onReset: () => void;
};

const caseTypes = [
  "civil",
  "marriage_family",
  "business_commercial",
  "labor",
  "criminal",
  "administrative",
  "civil_matter",
  "bankruptcy",
  "administrative_measure",
  "other"
];

const caseStatuses = [
  "draft",
  "received",
  "accepted",
  "preparing",
  "trial_scheduled",
  "resolved",
  "appealed",
  "effective",
  "temporarily_suspended",
  "suspended",
  "overdue",
  "closed"
];

export function CaseWorklistFilters({ query, courts, disabled, onChange, onReset }: Props) {
  return (
    <section className="filter-panel" aria-label="Bộ lọc danh sách hồ sơ án">
      <div className="filter-title">
        <Filter size={18} aria-hidden="true" />
        <span>Bộ lọc tra cứu</span>
      </div>

      <label className="field field-wide">
        <span>Tìm kiếm</span>
        <div className="input-with-icon">
          <Search size={16} aria-hidden="true" />
          <input
            value={query.search ?? ""}
            disabled={disabled}
            onChange={(event) => onChange({ search: event.target.value, page: 1 })}
            placeholder="Số hồ sơ, mã hồ sơ, tòa án hoặc tóm tắt"
          />
        </div>
      </label>

      <label className="field">
        <span>Loại án</span>
        <select
          value={query.case_type ?? ""}
          disabled={disabled}
          onChange={(event) => onChange({ case_type: event.target.value || undefined, page: 1 })}
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
        <span>Tòa án</span>
        <select
          value={query.court_id ?? ""}
          disabled={disabled}
          onChange={(event) => onChange({ court_id: event.target.value || undefined, page: 1 })}
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
        <span>Trạng thái</span>
        <select
          value={query.case_status ?? ""}
          disabled={disabled}
          onChange={(event) => onChange({ case_status: event.target.value || undefined, page: 1 })}
        >
          <option value="">Tất cả</option>
          {caseStatuses.map((status) => (
            <option key={status} value={status}>
              {statusLabel(status)}
            </option>
          ))}
        </select>
      </label>

      <label className="field">
        <span>Từ ngày thụ lý</span>
        <input
          type="date"
          value={query.from_date ?? ""}
          disabled={disabled}
          onChange={(event) => onChange({ from_date: event.target.value || undefined, page: 1 })}
        />
      </label>

      <label className="field">
        <span>Đến ngày thụ lý</span>
        <input
          type="date"
          value={query.to_date ?? ""}
          disabled={disabled}
          onChange={(event) => onChange({ to_date: event.target.value || undefined, page: 1 })}
        />
      </label>

      <label className="field">
        <span>Sắp xếp</span>
        <select
          value={query.sort_by ?? "updated_at"}
          disabled={disabled}
          onChange={(event) =>
            onChange({ sort_by: event.target.value as CaseWorklistQuery["sort_by"], page: 1 })
          }
        >
          <option value="updated_at">Cập nhật mới nhất</option>
          <option value="acceptance_date">Ngày thụ lý</option>
          <option value="closed_date">Ngày giải quyết</option>
          <option value="case_type">Loại án</option>
          <option value="court_name">Tòa án</option>
        </select>
      </label>

      <label className="field">
        <span>Chiều sắp xếp</span>
        <select
          value={query.sort_dir ?? "desc"}
          disabled={disabled}
          onChange={(event) => onChange({ sort_dir: event.target.value as "asc" | "desc", page: 1 })}
        >
          <option value="desc">Giảm dần</option>
          <option value="asc">Tăng dần</option>
        </select>
      </label>

      <button className="button button-secondary" type="button" onClick={onReset} disabled={disabled}>
        <RotateCcw size={16} aria-hidden="true" />
        Đặt lại
      </button>
    </section>
  );
}
