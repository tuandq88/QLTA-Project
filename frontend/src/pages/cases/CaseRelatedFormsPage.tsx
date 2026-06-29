import { useEffect, useMemo, useState } from "react";
import type { FormEvent, ReactNode } from "react";
import {
  AlertTriangle,
  BadgeCheck,
  CalendarDays,
  FileSearch,
  Gavel,
  GitBranch,
  RefreshCw,
  Save,
  UserRoundPlus
} from "lucide-react";
import {
  createCaseOccurrence,
  createHearing,
  createParticipant,
  createResolutionEvent,
  getCaseOverview,
  getCaseWorklist
} from "../../api/cases";
import type {
  CaseOverview,
  CaseWorklistItem,
  HearingCreatePayload,
  OccurrenceCreatePayload,
  ParticipantCreatePayload,
  ResolutionEventCreatePayload
} from "../../types/cases";
import { caseTypeLabel, courtNameLabel, displayText, formatDate } from "../../utils/format";

type SaveState = {
  status: "idle" | "saving" | "success" | "error";
  message: string;
};

type ParticipantForm = {
  participantType: string;
  fullName: string;
  organizationName: string;
  legalRepresentative: string;
  idNumber: string;
  dateOfBirth: string;
  gender: string;
  address: string;
  phone: string;
  email: string;
  isMinor: boolean;
  needsInterpreter: boolean;
  note: string;
};

type HearingForm = {
  hearingType: string;
  scheduledDate: string;
  scheduledTime: string;
  courtroom: string;
  panelComposition: string;
  hearingStatus: string;
  postponementReason: string;
  actualOpenedDate: string;
  actualClosedDate: string;
  note: string;
};

type OccurrenceForm = {
  occurrenceNo: string;
  acceptanceDate: string;
  acceptanceTypeCode: "INITIAL_ACCEPTANCE" | "RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION";
  previousOccurrenceId: string;
  sourceNote: string;
};

type ResolutionForm = {
  occurrenceId: string;
  eventTypeCode: string;
  eventDate: string;
  resolutionTypeCode: string;
  returnToAgencyCode: string;
  decisionNumber: string;
  countedAsResolved: boolean;
  reason: string;
};

const initialParticipantForm: ParticipantForm = {
  participantType: "PLAINTIFF",
  fullName: "",
  organizationName: "",
  legalRepresentative: "",
  idNumber: "",
  dateOfBirth: "",
  gender: "",
  address: "",
  phone: "",
  email: "",
  isMinor: false,
  needsInterpreter: false,
  note: ""
};

const initialHearingForm: HearingForm = {
  hearingType: "FIRST_INSTANCE",
  scheduledDate: "",
  scheduledTime: "",
  courtroom: "",
  panelComposition: "",
  hearingStatus: "scheduled",
  postponementReason: "",
  actualOpenedDate: "",
  actualClosedDate: "",
  note: ""
};

const initialOccurrenceForm: OccurrenceForm = {
  occurrenceNo: "2",
  acceptanceDate: "",
  acceptanceTypeCode: "RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION",
  previousOccurrenceId: "",
  sourceNote: ""
};

const initialResolutionForm: ResolutionForm = {
  occurrenceId: "",
  eventTypeCode: "RESOLUTION",
  eventDate: "",
  resolutionTypeCode: "JUDGMENT",
  returnToAgencyCode: "",
  decisionNumber: "",
  countedAsResolved: true,
  reason: ""
};

export function CaseRelatedFormsPage() {
  const [search, setSearch] = useState("UI-FORM");
  const [cases, setCases] = useState<CaseWorklistItem[]>([]);
  const [selectedCaseId, setSelectedCaseId] = useState("");
  const [overview, setOverview] = useState<CaseOverview | null>(null);
  const [loadingCases, setLoadingCases] = useState(false);
  const [loadingOverview, setLoadingOverview] = useState(false);
  const [loadError, setLoadError] = useState<string | null>(null);

  const [participantForm, setParticipantForm] = useState<ParticipantForm>(initialParticipantForm);
  const [hearingForm, setHearingForm] = useState<HearingForm>(initialHearingForm);
  const [occurrenceForm, setOccurrenceForm] = useState<OccurrenceForm>(initialOccurrenceForm);
  const [resolutionForm, setResolutionForm] = useState<ResolutionForm>(initialResolutionForm);

  const [participantState, setParticipantState] = useState<SaveState>({ status: "idle", message: "" });
  const [hearingState, setHearingState] = useState<SaveState>({ status: "idle", message: "" });
  const [occurrenceState, setOccurrenceState] = useState<SaveState>({ status: "idle", message: "" });
  const [resolutionState, setResolutionState] = useState<SaveState>({ status: "idle", message: "" });

  const selectedCase = useMemo(
    () => cases.find((item) => item.case_id === selectedCaseId) ?? null,
    [cases, selectedCaseId]
  );

  useEffect(() => {
    void loadCases();
  }, []);

  useEffect(() => {
    if (!selectedCaseId) {
      setOverview(null);
      return;
    }
    void loadOverview(selectedCaseId);
  }, [selectedCaseId]);

  useEffect(() => {
    const nextOccurrence = Math.max(...(overview?.occurrences.map((item) => item.occurrence_no) ?? [0])) + 1;
    const lastOccurrenceId = overview?.occurrences.at(-1)?.occurrence_id ?? "";
    setOccurrenceForm((current) => ({
      ...current,
      occurrenceNo: String(nextOccurrence),
      previousOccurrenceId: current.previousOccurrenceId || lastOccurrenceId
    }));
    setResolutionForm((current) => ({
      ...current,
      occurrenceId: current.occurrenceId || lastOccurrenceId
    }));
  }, [overview]);

  async function loadCases() {
    setLoadingCases(true);
    setLoadError(null);
    try {
      const response = await getCaseWorklist({
        page: 1,
        pageSize: 20,
        search,
        sort_by: "updated_at",
        sort_dir: "desc"
      });
      const rows = response.data ?? [];
      setCases(rows);
      setSelectedCaseId((current) => (rows.some((row) => row.case_id === current) ? current : rows[0]?.case_id ?? ""));
    } catch (error) {
      setCases([]);
      setSelectedCaseId("");
      setLoadError(error instanceof Error ? error.message : "Không tải được danh sách hồ sơ.");
    } finally {
      setLoadingCases(false);
    }
  }

  async function loadOverview(caseId: string) {
    setLoadingOverview(true);
    try {
      const response = await getCaseOverview(caseId);
      setOverview(response.data ?? null);
    } catch (error) {
      setOverview(null);
      setLoadError(error instanceof Error ? error.message : "Không tải được chi tiết hồ sơ.");
    } finally {
      setLoadingOverview(false);
    }
  }

  async function saveParticipant(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedCaseId) return;
    await saveWithState(setParticipantState, async () => {
      const payload: ParticipantCreatePayload = {
        case_id: selectedCaseId,
        participant_type: participantForm.participantType,
        full_name: optionalText(participantForm.fullName),
        organization_name: optionalText(participantForm.organizationName),
        legal_representative: optionalText(participantForm.legalRepresentative),
        id_number: optionalText(participantForm.idNumber),
        date_of_birth: optionalText(participantForm.dateOfBirth),
        gender: optionalText(participantForm.gender),
        address: optionalText(participantForm.address),
        phone: optionalText(participantForm.phone),
        email: optionalText(participantForm.email),
        is_minor: participantForm.isMinor,
        needs_interpreter: participantForm.needsInterpreter,
        note: optionalText(participantForm.note)
      };
      const response = await createParticipant(payload);
      setParticipantForm(initialParticipantForm);
      await loadOverview(selectedCaseId);
      return `Đã lưu người tham gia: ${displayText(response.data?.full_name ?? response.data?.organization_name)}`;
    });
  }

  async function saveHearing(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedCaseId) return;
    await saveWithState(setHearingState, async () => {
      const payload: HearingCreatePayload = {
        case_id: selectedCaseId,
        hearing_type: optionalText(hearingForm.hearingType),
        scheduled_date: optionalText(hearingForm.scheduledDate),
        scheduled_time: optionalText(hearingForm.scheduledTime),
        courtroom: optionalText(hearingForm.courtroom),
        panel_composition: optionalText(hearingForm.panelComposition),
        hearing_status: optionalText(hearingForm.hearingStatus),
        postponement_reason: optionalText(hearingForm.postponementReason),
        actual_opened_date: optionalText(hearingForm.actualOpenedDate),
        actual_closed_date: optionalText(hearingForm.actualClosedDate),
        note: optionalText(hearingForm.note)
      };
      const response = await createHearing(payload);
      setHearingForm(initialHearingForm);
      await loadOverview(selectedCaseId);
      return `Đã lưu phiên tòa: ${displayText(response.data?.hearing_id)}`;
    });
  }

  async function saveOccurrence(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedCaseId) return;
    await saveWithState(setOccurrenceState, async () => {
      const payload: OccurrenceCreatePayload = {
        case_id: selectedCaseId,
        occurrence_no: Number(occurrenceForm.occurrenceNo),
        acceptance_date: occurrenceForm.acceptanceDate,
        acceptance_type_code: occurrenceForm.acceptanceTypeCode,
        previous_occurrence_id: optionalText(occurrenceForm.previousOccurrenceId),
        source_note: optionalText(occurrenceForm.sourceNote)
      };
      const response = await createCaseOccurrence(payload);
      setOccurrenceForm(initialOccurrenceForm);
      await loadOverview(selectedCaseId);
      return `Đã lưu lần thụ lý: ${response.data?.occurrence_no}`;
    });
  }

  async function saveResolution(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedCaseId) return;
    await saveWithState(setResolutionState, async () => {
      const payload: ResolutionEventCreatePayload = {
        case_id: selectedCaseId,
        occurrence_id: resolutionForm.occurrenceId,
        event_type_code: resolutionForm.eventTypeCode || "RESOLUTION",
        event_date: resolutionForm.eventDate,
        resolution_type_code: resolutionForm.resolutionTypeCode,
        return_to_agency_code: optionalText(resolutionForm.returnToAgencyCode),
        decision_number: optionalText(resolutionForm.decisionNumber),
        counted_as_resolved: resolutionForm.countedAsResolved,
        reason: optionalText(resolutionForm.reason)
      };
      const response = await createResolutionEvent(payload);
      setResolutionForm(initialResolutionForm);
      await loadOverview(selectedCaseId);
      return `Đã lưu sự kiện giải quyết: ${displayText(response.data?.resolution_type_code)}`;
    });
  }

  return (
    <main className="app-shell related-shell">
      <header className="page-header">
        <div>
          <p className="eyebrow">Nhập dữ liệu liên quan hồ sơ</p>
          <h1>Bổ sung dữ liệu trong vòng đời hồ sơ vụ án</h1>
          <p>Chọn hồ sơ để cập nhật người tham gia tố tụng, lịch phiên tòa, lần thụ lý và kết quả giải quyết.</p>
        </div>
        <div className="header-actions">
          <button className="button button-secondary" type="button" onClick={() => void loadCases()} disabled={loadingCases}>
            <RefreshCw size={16} aria-hidden="true" />
            Tải lại
          </button>
        </div>
      </header>

      <section className="filter-panel related-filter" aria-label="Chọn hồ sơ để nhập dữ liệu liên quan">
        <div className="filter-title">
          <FileSearch size={18} aria-hidden="true" />
          <span>Chọn hồ sơ</span>
        </div>
        <label className="field field-wide">
          <span>Tìm hồ sơ</span>
          <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Số hồ sơ, mã hồ sơ hoặc nội dung tóm tắt" />
        </label>
        <button className="button button-secondary" type="button" onClick={() => void loadCases()} disabled={loadingCases}>
          Tìm
        </button>
        <label className="field related-case-select">
          <span>Hồ sơ đang thao tác</span>
          <select value={selectedCaseId} onChange={(event) => setSelectedCaseId(event.target.value)} disabled={!cases.length}>
            {cases.length ? (
              cases.map((item) => (
                <option key={item.case_id} value={item.case_id}>
                  {displayText(item.case_number ?? item.case_code)} | {caseTypeLabel(item.case_type)}
                </option>
              ))
            ) : (
              <option value="">Không có hồ sơ phù hợp</option>
            )}
          </select>
        </label>
      </section>

      {loadError ? (
        <section className="data-state data-state-error" role="alert">
          <div className="data-state-icon">
            <AlertTriangle aria-hidden="true" />
          </div>
          <div>
            <h3>Không tải được dữ liệu</h3>
            <p>{loadError}</p>
          </div>
        </section>
      ) : null}

      <div className="related-layout">
        <aside className="related-summary" aria-label="Tóm tắt hồ sơ đang chọn">
          <section className="validation-card">
            <h2>Hồ sơ đang chọn</h2>
            {selectedCase ? (
              <dl className="review-list">
                <div>
                  <dt>Số hồ sơ</dt>
                  <dd>{displayText(selectedCase.case_number ?? selectedCase.case_code)}</dd>
                </div>
                <div>
                  <dt>Loại án</dt>
                  <dd>{caseTypeLabel(selectedCase.case_type)}</dd>
                </div>
                <div>
                  <dt>Tòa án</dt>
                  <dd>{courtNameLabel(selectedCase.court_name)}</dd>
                </div>
                <div>
                  <dt>Ngày thụ lý</dt>
                  <dd>{formatDate(selectedCase.acceptance_date)}</dd>
                </div>
              </dl>
            ) : (
              <p className="muted">Chưa chọn hồ sơ.</p>
            )}
          </section>

          <section className="validation-card">
            <h2>Dữ liệu hiện có</h2>
            <dl className="review-list">
              <div>
                <dt>Người tham gia</dt>
                <dd>{overview?.participants.length ?? 0}</dd>
              </div>
              <div>
                <dt>Phiên tòa</dt>
                <dd>{overview?.hearings.length ?? 0}</dd>
              </div>
              <div>
                <dt>Lần thụ lý</dt>
                <dd>{overview?.occurrences.length ?? 0}</dd>
              </div>
              <div>
                <dt>Sự kiện giải quyết</dt>
                <dd>{overview?.resolutionEvents.length ?? 0}</dd>
              </div>
            </dl>
            {loadingOverview ? <p className="muted">Đang tải chi tiết hồ sơ...</p> : null}
          </section>
        </aside>

        <section className="related-form-grid">
          <RelatedFormCard
            title="Người tham gia tố tụng"
            icon={<UserRoundPlus size={18} aria-hidden="true" />}
            state={participantState}
            onSubmit={saveParticipant}
            disabled={!selectedCaseId}
          >
            <div className="form-grid form-grid-compact">
              <TextField label="Loại tham gia" value={participantForm.participantType} onChange={(value) => setParticipantForm((current) => ({ ...current, participantType: value }))} />
              <TextField label="Họ tên cá nhân" value={participantForm.fullName} onChange={(value) => setParticipantForm((current) => ({ ...current, fullName: value }))} />
              <TextField label="Tên tổ chức" value={participantForm.organizationName} onChange={(value) => setParticipantForm((current) => ({ ...current, organizationName: value }))} />
              <TextField label="Số định danh" value={participantForm.idNumber} onChange={(value) => setParticipantForm((current) => ({ ...current, idNumber: value }))} />
              <DateField label="Ngày sinh" value={participantForm.dateOfBirth} onChange={(value) => setParticipantForm((current) => ({ ...current, dateOfBirth: value }))} />
              <TextField label="Giới tính" value={participantForm.gender} onChange={(value) => setParticipantForm((current) => ({ ...current, gender: value }))} />
              <TextField label="Người đại diện" value={participantForm.legalRepresentative} onChange={(value) => setParticipantForm((current) => ({ ...current, legalRepresentative: value }))} />
              <TextField label="Số điện thoại" value={participantForm.phone} onChange={(value) => setParticipantForm((current) => ({ ...current, phone: value }))} />
            </div>
            <TextAreaField label="Địa chỉ" value={participantForm.address} onChange={(value) => setParticipantForm((current) => ({ ...current, address: value }))} />
            <TextAreaField label="Ghi chú" value={participantForm.note} onChange={(value) => setParticipantForm((current) => ({ ...current, note: value }))} />
            <div className="toggle-row">
              <CheckboxField label="Người chưa thành niên" checked={participantForm.isMinor} onChange={(checked) => setParticipantForm((current) => ({ ...current, isMinor: checked }))} />
              <CheckboxField label="Cần phiên dịch" checked={participantForm.needsInterpreter} onChange={(checked) => setParticipantForm((current) => ({ ...current, needsInterpreter: checked }))} />
            </div>
          </RelatedFormCard>

          <RelatedFormCard
            title="Phiên tòa / phiên họp"
            icon={<Gavel size={18} aria-hidden="true" />}
            state={hearingState}
            onSubmit={saveHearing}
            disabled={!selectedCaseId}
          >
            <div className="form-grid form-grid-compact">
              <TextField label="Loại phiên" value={hearingForm.hearingType} onChange={(value) => setHearingForm((current) => ({ ...current, hearingType: value }))} />
              <DateField label="Ngày mở phiên" value={hearingForm.scheduledDate} onChange={(value) => setHearingForm((current) => ({ ...current, scheduledDate: value }))} />
              <TextField label="Giờ mở phiên" value={hearingForm.scheduledTime} onChange={(value) => setHearingForm((current) => ({ ...current, scheduledTime: value }))} />
              <TextField label="Phòng xử" value={hearingForm.courtroom} onChange={(value) => setHearingForm((current) => ({ ...current, courtroom: value }))} />
              <TextField label="Trạng thái phiên" value={hearingForm.hearingStatus} onChange={(value) => setHearingForm((current) => ({ ...current, hearingStatus: value }))} />
              <DateField label="Ngày mở thực tế" value={hearingForm.actualOpenedDate} onChange={(value) => setHearingForm((current) => ({ ...current, actualOpenedDate: value }))} />
            </div>
            <TextAreaField label="Thành phần hội đồng" value={hearingForm.panelComposition} onChange={(value) => setHearingForm((current) => ({ ...current, panelComposition: value }))} />
            <TextAreaField label="Ghi chú phiên tòa" value={hearingForm.note} onChange={(value) => setHearingForm((current) => ({ ...current, note: value }))} />
          </RelatedFormCard>

          <RelatedFormCard
            title="Lần thụ lý / vòng đời"
            icon={<GitBranch size={18} aria-hidden="true" />}
            state={occurrenceState}
            onSubmit={saveOccurrence}
            disabled={!selectedCaseId}
          >
            <div className="form-grid form-grid-compact">
              <TextField label="Số lần thụ lý" value={occurrenceForm.occurrenceNo} onChange={(value) => setOccurrenceForm((current) => ({ ...current, occurrenceNo: value }))} />
              <DateField label="Ngày thụ lý lại" value={occurrenceForm.acceptanceDate} onChange={(value) => setOccurrenceForm((current) => ({ ...current, acceptanceDate: value }))} />
              <SelectField label="Loại thụ lý" value={occurrenceForm.acceptanceTypeCode} onChange={(value) => setOccurrenceForm((current) => ({ ...current, acceptanceTypeCode: value as OccurrenceForm["acceptanceTypeCode"] }))}>
                <option value="INITIAL_ACCEPTANCE">Thụ lý lần đầu</option>
                <option value="RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION">Thụ lý lại sau điều tra bổ sung</option>
              </SelectField>
              <SelectField label="Lần thụ lý trước" value={occurrenceForm.previousOccurrenceId} onChange={(value) => setOccurrenceForm((current) => ({ ...current, previousOccurrenceId: value }))}>
                <option value="">Không chọn</option>
                {(overview?.occurrences ?? []).map((item) => (
                  <option key={item.occurrence_id} value={item.occurrence_id}>
                    Lần {item.occurrence_no} | {formatDate(item.acceptance_date)}
                  </option>
                ))}
              </SelectField>
            </div>
            <TextAreaField label="Ghi chú thụ lý" value={occurrenceForm.sourceNote} onChange={(value) => setOccurrenceForm((current) => ({ ...current, sourceNote: value }))} />
          </RelatedFormCard>

          <RelatedFormCard
            title="Sự kiện giải quyết"
            icon={<CalendarDays size={18} aria-hidden="true" />}
            state={resolutionState}
            onSubmit={saveResolution}
            disabled={!selectedCaseId || !(overview?.occurrences.length)}
          >
            <div className="form-grid form-grid-compact">
              <SelectField label="Gắn với lần thụ lý" value={resolutionForm.occurrenceId} onChange={(value) => setResolutionForm((current) => ({ ...current, occurrenceId: value }))}>
                <option value="">Chọn lần thụ lý</option>
                {(overview?.occurrences ?? []).map((item) => (
                  <option key={item.occurrence_id} value={item.occurrence_id}>
                    Lần {item.occurrence_no} | {formatDate(item.acceptance_date)}
                  </option>
                ))}
              </SelectField>
              <TextField label="Loại sự kiện" value={resolutionForm.eventTypeCode} onChange={(value) => setResolutionForm((current) => ({ ...current, eventTypeCode: value }))} />
              <DateField label="Ngày sự kiện" value={resolutionForm.eventDate} onChange={(value) => setResolutionForm((current) => ({ ...current, eventDate: value }))} />
              <TextField label="Loại kết quả" value={resolutionForm.resolutionTypeCode} onChange={(value) => setResolutionForm((current) => ({ ...current, resolutionTypeCode: value }))} />
              <TextField label="Số quyết định" value={resolutionForm.decisionNumber} onChange={(value) => setResolutionForm((current) => ({ ...current, decisionNumber: value }))} />
              <TextField label="Cơ quan nhận trả hồ sơ" value={resolutionForm.returnToAgencyCode} onChange={(value) => setResolutionForm((current) => ({ ...current, returnToAgencyCode: value }))} />
            </div>
            <TextAreaField label="Lý do/Nội dung sự kiện" value={resolutionForm.reason} onChange={(value) => setResolutionForm((current) => ({ ...current, reason: value }))} />
            <div className="toggle-row">
              <CheckboxField label="Tính là đã giải quyết" checked={resolutionForm.countedAsResolved} onChange={(checked) => setResolutionForm((current) => ({ ...current, countedAsResolved: checked }))} />
            </div>
          </RelatedFormCard>
        </section>
      </div>
    </main>
  );
}

function RelatedFormCard({
  title,
  icon,
  state,
  disabled,
  onSubmit,
  children
}: {
  title: string;
  icon: ReactNode;
  state: SaveState;
  disabled?: boolean;
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
  children: ReactNode;
}) {
  return (
    <form className="form-section related-card" onSubmit={onSubmit}>
      <div className="section-heading">
        <h2>
          <span className="heading-icon">{icon}</span>
          {title}
        </h2>
      </div>
      {children}
      <div className="related-submit-row">
        <button className="button button-primary" type="submit" disabled={disabled || state.status === "saving"}>
          <Save size={16} aria-hidden="true" />
          {state.status === "saving" ? "Đang lưu" : "Lưu dữ liệu"}
        </button>
        <SaveMessage state={state} />
      </div>
    </form>
  );
}

function SaveMessage({ state }: { state: SaveState }) {
  if (state.status === "idle" || !state.message) return null;
  const className = state.status === "success" ? "validation-ok inline-save-message" : "save-error inline-save-message";
  return (
    <span className={className}>
      {state.status === "success" ? <BadgeCheck size={16} aria-hidden="true" /> : <AlertTriangle size={16} aria-hidden="true" />}
      {state.message}
    </span>
  );
}

async function saveWithState(setState: (state: SaveState) => void, action: () => Promise<string>) {
  setState({ status: "saving", message: "Đang lưu dữ liệu..." });
  try {
    const message = await action();
    setState({ status: "success", message });
  } catch (error) {
    setState({
      status: "error",
      message: error instanceof Error ? error.message : "Không lưu được dữ liệu."
    });
  }
}

function TextField({
  label,
  value,
  placeholder,
  onChange
}: {
  label: string;
  value: string;
  placeholder?: string;
  onChange: (value: string) => void;
}) {
  return (
    <label className="field">
      <span>{label}</span>
      <input aria-label={label} value={value} placeholder={placeholder} onChange={(event) => onChange(event.target.value)} />
    </label>
  );
}

function DateField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  return (
    <label className="field">
      <span>{label}</span>
      <input aria-label={label} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </label>
  );
}

function TextAreaField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  return (
    <label className="field textarea-field">
      <span>{label}</span>
      <textarea aria-label={label} value={value} rows={3} onChange={(event) => onChange(event.target.value)} />
    </label>
  );
}

function SelectField({
  label,
  value,
  children,
  onChange
}: {
  label: string;
  value: string;
  children: ReactNode;
  onChange: (value: string) => void;
}) {
  return (
    <label className="field">
      <span>{label}</span>
      <select aria-label={label} value={value} onChange={(event) => onChange(event.target.value)}>
        {children}
      </select>
    </label>
  );
}

function CheckboxField({ label, checked, onChange }: { label: string; checked: boolean; onChange: (checked: boolean) => void }) {
  return (
    <label className="checkbox-field">
      <input aria-label={label} type="checkbox" checked={checked} onChange={(event) => onChange(event.target.checked)} />
      <span>{label}</span>
    </label>
  );
}

function optionalText(value: string) {
  const trimmed = value.trim();
  return trimmed ? trimmed : null;
}
