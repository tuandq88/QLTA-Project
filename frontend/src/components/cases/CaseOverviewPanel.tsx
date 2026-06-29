import { X } from "lucide-react";
import type { ReactNode } from "react";
import type { CaseOverview } from "../../types/cases";
import { caseTypeLabel, courtLevelLabel, courtNameLabel, displayText, formatDate, roleLabel } from "../../utils/format";
import { DataState } from "../common/DataState";
import { CaseStatusBadge } from "./CaseStatusBadge";

type Props = {
  overview?: CaseOverview | null;
  loading?: boolean;
  error?: string | null;
  readonly?: boolean;
  permissionDenied?: boolean;
  onClose: () => void;
};

export function CaseOverviewPanel({ overview, loading, error, readonly, permissionDenied, onClose }: Props) {
  const record = overview?.case;
  const openWarnings = overview?.validationResults.filter((item) => item.validation_status === "open") ?? [];

  return (
    <aside className="detail-panel" aria-label="Chi tiết hồ sơ vụ án">
      <div className="detail-header">
        <div>
          <p className="eyebrow">Chi tiết hồ sơ vụ án</p>
          <h2>{displayText(record?.case_number ?? record?.case_code)}</h2>
          <div className="detail-meta">
            <span>{caseTypeLabel(record?.case_type)}</span>
            <span>{courtNameLabel(record?.court_name)}</span>
            {record ? <CaseStatusBadge status={record.case_status} /> : null}
          </div>
        </div>
        <button className="icon-button" type="button" onClick={onClose} aria-label="Đóng chi tiết hồ sơ">
          <X size={18} aria-hidden="true" />
        </button>
      </div>

      {permissionDenied ? (
        <DataState state="permission_denied" />
      ) : loading ? (
        <DataState state="loading" />
      ) : error ? (
        <DataState state="error" description={error} />
      ) : !overview || !record ? (
        <DataState state="empty" title="Chưa chọn hồ sơ" description="Chọn một hồ sơ trong danh sách để xem chi tiết." />
      ) : (
        <div className="detail-content">
          {readonly ? <DataState state="readonly" /> : null}

          {openWarnings.length > 0 ? (
            <section className="warning-box">
              <h3>Cảnh báo dữ liệu</h3>
              <ul>
                {openWarnings.slice(0, 5).map((warning) => (
                  <li key={warning.validation_id}>{warning.message}</li>
                ))}
              </ul>
            </section>
          ) : null}

          <DetailSection title="Thông tin chung vụ án">
            <InfoGrid
              items={[
                ["Mã hồ sơ", record.case_code],
                ["Số hồ sơ", record.case_number],
                ["Tóm tắt", record.summary],
                ["Trạng thái", record.case_status],
                ["Ngày tạo", formatDate(record.created_at)],
                ["Cập nhật lần cuối", formatDate(record.updated_at)]
              ]}
            />
          </DetailSection>

          <DetailSection title="Thông tin thụ lý">
            <InfoGrid
              items={[
                ["Ngày nộp", formatDate(record.filing_date)],
                ["Ngày thụ lý", formatDate(record.acceptance_date)],
                ["Giai đoạn hiện tại", record.current_stage],
                ["Trạng thái giải quyết", record.resolution_status],
                ["Ngày giải quyết", formatDate(record.closed_date)]
              ]}
            />
          </DetailSection>

          <DetailSection title="Loại án / nhóm án / cấp xét xử">
            <InfoGrid
              items={[
                ["Loại án", caseTypeLabel(record.case_type)],
                ["Nhóm án", record.case_group],
                ["Luật tố tụng", record.procedure_law],
                ["Tòa sơ thẩm", courtNameLabel(record.first_instance_court_name)],
                ["Số án sơ thẩm", record.first_instance_case_number],
                ["Số bản án sơ thẩm", record.first_instance_judgment_number],
                ["Ngày bản án sơ thẩm", formatDate(record.first_instance_judgment_date)]
              ]}
            />
          </DetailSection>

          <DetailSection title="Tòa án thụ lý">
            <InfoGrid
              items={[
                ["Tên tòa án", courtNameLabel(record.court_name)],
                ["Mã tòa án", record.court_code],
                ["Cấp tòa án", courtLevelLabel(record.court_level)]
              ]}
            />
          </DetailSection>

          <DetailSection title="Người tham gia tố tụng / đương sự / bị cáo">
            {overview.participants.length ? (
              <CompactTable
                headers={["Loại tham gia", "Họ tên/Tổ chức", "Đại diện", "Ghi chú"]}
                rows={overview.participants.map((item) => [
                  item.participant_type,
                  item.full_name ?? item.organization_name,
                  item.legal_representative,
                  item.note
                ])}
              />
            ) : (
              <EmptyInline />
            )}
          </DetailSection>

          <DetailSection title="Diễn biến xử lý hồ sơ">
            {overview.occurrences.length ? (
              <CompactTable
                headers={["Lần thụ lý", "Ngày thụ lý", "Loại thụ lý", "Ghi chú"]}
                rows={overview.occurrences.map((item) => [
                  item.occurrence_no,
                  formatDate(item.acceptance_date),
                  item.acceptance_type_code,
                  item.source_note
                ])}
              />
            ) : (
              <EmptyInline />
            )}
          </DetailSection>

          <DetailSection title="Phiên tòa / lịch xét xử">
            {overview.hearings.length ? (
              <CompactTable
                headers={["Loại phiên", "Ngày", "Giờ", "Phòng xử", "Trạng thái"]}
                rows={overview.hearings.map((item) => [
                  item.hearing_type,
                  formatDate(item.scheduled_date),
                  item.scheduled_time,
                  item.courtroom,
                  item.hearing_status
                ])}
              />
            ) : (
              <EmptyInline />
            )}
          </DetailSection>

          <DetailSection title="Người tiến hành tố tụng">
            {overview.hearingMembers.length ? (
              <CompactTable
                headers={["Họ tên", "Vai trò", "Chức danh", "Thứ tự"]}
                rows={overview.hearingMembers.map((item) => [
                  item.full_name,
                  roleLabel(item.role_code),
                  item.position_title,
                  item.member_order
                ])}
              />
            ) : (
              <EmptyInline />
            )}
          </DetailSection>

          <DetailSection title="Quyết định / kết quả giải quyết">
            {overview.resolutionEvents.length ? (
              <CompactTable
                headers={["Ngày", "Loại kết quả", "Số quyết định", "Tính là đã giải quyết", "Lý do"]}
                rows={overview.resolutionEvents.map((item) => [
                  formatDate(item.event_date),
                  item.resolution_type_code,
                  item.decision_number,
                  displayText(item.counted_as_resolved),
                  item.reason
                ])}
              />
            ) : (
              <EmptyInline />
            )}
          </DetailSection>

          <DetailSection title="Cảnh báo dữ liệu">
            {overview.validationResults.length ? (
              <CompactTable
                headers={["Mức độ", "Nội dung", "Thời điểm kiểm tra"]}
                rows={overview.validationResults.map((item) => [
                  item.severity,
                  item.message,
                  formatDate(item.checked_at)
                ])}
              />
            ) : (
              <EmptyInline />
            )}
          </DetailSection>

        </div>
      )}
    </aside>
  );
}

function DetailSection({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section className="detail-section">
      <h3>{title}</h3>
      {children}
    </section>
  );
}

function InfoGrid({ items }: { items: Array<[string, string | number | boolean | null | undefined]> }) {
  return (
    <dl className="info-grid">
      {items.map(([label, value]) => (
        <div key={label}>
          <dt>{label}</dt>
          <dd>{displayText(value)}</dd>
        </div>
      ))}
    </dl>
  );
}

function CompactTable({ headers, rows }: { headers: string[]; rows: Array<Array<string | number | boolean | null | undefined>> }) {
  return (
    <div className="compact-table-scroll">
      <table className="compact-table">
        <thead>
          <tr>
            {headers.map((header) => (
              <th key={header}>{header}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row, rowIndex) => (
            <tr key={rowIndex}>
              {row.map((cell, cellIndex) => (
                <td key={`${rowIndex}-${cellIndex}`}>{displayText(cell)}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function EmptyInline() {
  return <p className="empty-inline">Chưa có dữ liệu</p>;
}
