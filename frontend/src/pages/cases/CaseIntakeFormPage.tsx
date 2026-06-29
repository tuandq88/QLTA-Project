import { useEffect, useMemo, useState } from "react";
import type { Dispatch, FormEvent, ReactNode, SetStateAction } from "react";
import {
  AlertTriangle,
  BadgeCheck,
  Ban,
  CalendarDays,
  ClipboardCheck,
  FileCheck2,
  FilePlus2,
  Gavel,
  Lock,
  Plus,
  Trash2,
  UserCog,
  UserRoundPlus
} from "lucide-react";
import { createCaseAssignment, createCaseIntake, createDefendant, getCourts, getUsers } from "../../api/cases";
import type { CaseAssignmentCreatePayload, CaseIntakePayload, CourtItem, DefendantCreatePayload, UserItem } from "../../types/cases";
import { courtNameLabel } from "../../utils/format";

type CaseType =
  | "criminal"
  | "civil"
  | "marriage_family"
  | "business_commercial"
  | "labor"
  | "administrative";

type ViewMode = "normal" | "readonly" | "permission_denied";

type ToastTone = "info" | "success" | "warning" | "error";

type ToastMessage = {
  id: string;
  tone: ToastTone;
  title: string;
  description: string;
};

type FormState = {
  courtId: string;
  caseType: CaseType;
  caseGroup: string;
  procedureLaw: string;
  caseNumber: string;
  caseCode: string;
  filingDate: string;
  acceptanceDate: string;
  currentStage: string;
  summary: string;
  hasForeignElement: boolean;
  isMinorRelated: boolean;
  isConfidential: boolean;
  firstInstanceCourtId: string;
  firstInstanceCaseNumber: string;
  firstInstanceJudgmentNumber: string;
  firstInstanceJudgmentDate: string;
};

type CriminalDetailState = {
  procuracyName: string;
  indictmentNumber: string;
  indictmentDate: string;
  investigationAgency: string;
  dossierReceivedDate: string;
  trialPanelType: string;
};

type CivilDetailState = {
  civilCategory: string;
  disputeType: string;
  claimValue: string;
  jurisdictionBasis: string;
  mediationResult: string;
  courtFeeAdvancePaid: boolean;
};

type AdministrativeDetailState = {
  lawsuitType: string;
  defendantAgencyName: string;
  agencyRepresentative: string;
  agencyLevel: string;
  compensationAmount: string;
  jurisdictionBasis: string;
};

type DefendantDraft = {
  id: string;
  fullName: string;
  dateOfBirth: string;
  gender: string;
  nationality: string;
  ethnicity: string;
  occupation: string;
  residence: string;
  criminalRecordStatus: string;
  isMinor: boolean;
  isDetained: boolean;
  detentionStartDate: string;
  detentionEndDate: string;
};

type AssignmentDraft = {
  id: string;
  userId: string;
  fallbackName: string;
  assignmentRole: CaseAssignmentCreatePayload["assignment_role"];
  assignedDate: string;
  isPrimary: boolean;
  assignmentMethod: NonNullable<CaseAssignmentCreatePayload["assignment_method"]>;
  legalBasis: string;
  designatedReasonCode: string;
};

const initialFormState: FormState = {
  courtId: "",
  caseType: "criminal",
  caseGroup: "SO_THAM",
  procedureLaw: "",
  caseNumber: "",
  caseCode: "",
  filingDate: "",
  acceptanceDate: "",
  currentStage: "",
  summary: "",
  hasForeignElement: false,
  isMinorRelated: false,
  isConfidential: false,
  firstInstanceCourtId: "",
  firstInstanceCaseNumber: "",
  firstInstanceJudgmentNumber: "",
  firstInstanceJudgmentDate: ""
};

const initialCriminalDetail: CriminalDetailState = {
  procuracyName: "",
  indictmentNumber: "",
  indictmentDate: "",
  investigationAgency: "",
  dossierReceivedDate: "",
  trialPanelType: ""
};

const initialCivilDetail: CivilDetailState = {
  civilCategory: "",
  disputeType: "",
  claimValue: "",
  jurisdictionBasis: "",
  mediationResult: "",
  courtFeeAdvancePaid: false
};

const initialAdministrativeDetail: AdministrativeDetailState = {
  lawsuitType: "",
  defendantAgencyName: "",
  agencyRepresentative: "",
  agencyLevel: "",
  compensationAmount: "",
  jurisdictionBasis: ""
};

function createDefendantDraft(): DefendantDraft {
  return {
    id: crypto.randomUUID(),
    fullName: "",
    dateOfBirth: "",
    gender: "",
    nationality: "Việt Nam",
    ethnicity: "",
    occupation: "",
    residence: "",
    criminalRecordStatus: "",
    isMinor: false,
    isDetained: false,
    detentionStartDate: "",
    detentionEndDate: ""
  };
}

function createAssignmentDraft(role: AssignmentDraft["assignmentRole"] = "primary_judge"): AssignmentDraft {
  return {
    id: crypto.randomUUID(),
    userId: "",
    fallbackName: "",
    assignmentRole: role,
    assignedDate: new Date().toISOString().slice(0, 10),
    isPrimary: role === "primary_judge",
    assignmentMethod: "DESIGNATED",
    legalBasis: "",
    designatedReasonCode: "",
  };
}

const caseTypeOptions: Array<{ value: CaseType; label: string; description: string }> = [
  { value: "criminal", label: "Hình sự", description: "Bị cáo, tội danh, biện pháp ngăn chặn" },
  { value: "civil", label: "Dân sự", description: "Tranh chấp, yêu cầu, hòa giải" },
  { value: "marriage_family", label: "Hôn nhân gia đình", description: "Nhóm án dân sự cùng cấu trúc chi tiết" },
  { value: "business_commercial", label: "Kinh doanh thương mại", description: "Nhóm án dân sự cùng cấu trúc chi tiết" },
  { value: "labor", label: "Lao động", description: "Nhóm án dân sự cùng cấu trúc chi tiết" },
  { value: "administrative", label: "Hành chính", description: "Đối tượng bị kiện, đối thoại, thi hành" }
];

const caseGroups = [
  { value: "SO_THAM", label: "Sơ thẩm" },
  { value: "PHUC_THAM", label: "Phúc thẩm" }
];

export function CaseIntakeFormPage() {
  const [form, setForm] = useState<FormState>(initialFormState);
  const [criminalDetail, setCriminalDetail] = useState<CriminalDetailState>(initialCriminalDetail);
  const [civilDetail, setCivilDetail] = useState<CivilDetailState>(initialCivilDetail);
  const [administrativeDetail, setAdministrativeDetail] = useState<AdministrativeDetailState>(initialAdministrativeDetail);
  const [defendants, setDefendants] = useState<DefendantDraft[]>([]);
  const [assignments, setAssignments] = useState<AssignmentDraft[]>([createAssignmentDraft("primary_judge"), createAssignmentDraft("clerk")]);
  const [courts, setCourts] = useState<CourtItem[]>([]);
  const [users, setUsers] = useState<UserItem[]>([]);
  const [courtLoadError, setCourtLoadError] = useState<string | null>(null);
  const [userLoadError, setUserLoadError] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<ViewMode>("normal");
  const [saving, setSaving] = useState(false);
  const [toastSequence, setToastSequence] = useState(0);
  const [dismissedToastSequence, setDismissedToastSequence] = useState(0);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [createdCaseId, setCreatedCaseId] = useState<string | null>(null);
  const readonly = viewMode === "readonly";
  const permissionDenied = viewMode === "permission_denied";
  const toastVisible = toastSequence > dismissedToastSequence;

  const validations = useMemo(() => buildValidationMessages(form), [form]);
  const activeCaseType = caseTypeOptions.find((item) => item.value === form.caseType) ?? caseTypeOptions[0];
  const toastMessages = useMemo<ToastMessage[]>(() => {
    if (!toastVisible) return [];

    const messages: ToastMessage[] = [];

    if (saveError) {
      messages.push({
        id: "save-error",
        tone: "error",
        title: "Không lưu được hồ sơ",
        description: saveError
      });
    }

    if (createdCaseId) {
      messages.push({
        id: "save-success",
        tone: "success",
        title: "Đã lưu hồ sơ",
        description: `Mã hồ sơ: ${createdCaseId}`
      });
    }

    if (validations.length > 0) {
      messages.push(
        ...validations.map((item) => ({
          id: `validation-${item.field}`,
          tone: "warning" as const,
          title: item.message,
          description: `${item.field}: ${item.action}`
        }))
      );
    } else if (!saveError && !createdCaseId && !permissionDenied) {
      messages.push({
        id: "validation-ok",
        tone: "success",
        title: "Đủ trường lõi để lưu",
        description: "Validation sẽ tự cập nhật khi dữ liệu thay đổi."
      });
    }

    return messages;
  }, [createdCaseId, permissionDenied, saveError, toastVisible, validations]);

  useEffect(() => {
    if (!toastVisible) return;

    const visibleSequence = toastSequence;
    const timeoutId = window.setTimeout(() => {
      setDismissedToastSequence(visibleSequence);
    }, 1500);

    return () => window.clearTimeout(timeoutId);
  }, [toastSequence, toastVisible]);

  useEffect(() => {
    let ignore = false;
    void getCourts()
      .then((response) => {
        if (!ignore) {
          setCourts(response.data ?? []);
          setCourtLoadError(null);
        }
      })
      .catch((error: unknown) => {
        if (!ignore) {
          setCourts([]);
          setCourtLoadError(error instanceof Error ? error.message : "Không tải được danh sách Tòa án.");
        }
      });

    void getUsers()
      .then((response) => {
        if (!ignore) {
          setUsers((response.data ?? []).filter((item) => item.is_active !== false));
          setUserLoadError(null);
        }
      })
      .catch((error: unknown) => {
        if (!ignore) {
          setUsers([]);
          setUserLoadError(error instanceof Error ? error.message : "Không tải được danh sách người tiến hành tố tụng.");
        }
      });

    return () => {
      ignore = true;
    };
  }, []);

  function updateField<K extends keyof FormState>(key: K, value: FormState[K]) {
    setForm((current) => ({ ...current, [key]: value }));
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setSaveError(null);
    setCreatedCaseId(null);

    if (validations.length > 0 || readonly || permissionDenied) {
      setToastSequence((current) => current + 1);
      return;
    }

    setSaving(true);
    try {
      const payload = buildCaseIntakePayload(form, criminalDetail, civilDetail, administrativeDetail);
      const response = await createCaseIntake(payload);
      const caseId = response.data?.case.case_id ?? null;
      if (caseId) {
        await saveCaseChildren(caseId, form.caseType, defendants, assignments);
      }
      setCreatedCaseId(caseId);
      setToastSequence((current) => current + 1);
    } catch (error) {
      setSaveError(error instanceof Error ? error.message : "Không lưu được hồ sơ.");
      setToastSequence((current) => current + 1);
    } finally {
      setSaving(false);
    }
  }

  return (
    <main className="app-shell intake-shell">
      <header className="page-header">
        <div>
          <p className="eyebrow">Tiếp nhận hồ sơ</p>
          <h1>Nhập hồ sơ vụ án theo loại án</h1>
          <p>Nhập thông tin hồ sơ, dữ liệu riêng theo loại án, người tham gia và phân công xử lý.</p>
        </div>
        <div className="header-actions">
          <label className="mode-control">
            <span>Trạng thái quyền</span>
            <select value={viewMode} onChange={(event) => setViewMode(event.target.value as ViewMode)}>
              <option value="normal">Được nhập</option>
              <option value="readonly">Chỉ xem</option>
              <option value="permission_denied">Từ chối quyền</option>
            </select>
          </label>
          <button
            className="button button-primary"
            type="submit"
            form="case-intake-form"
            disabled={readonly || permissionDenied || saving}
          >
            <FileCheck2 size={16} aria-hidden="true" />
            {saving ? "Đang lưu" : "Lưu nháp"}
          </button>
        </div>
      </header>

      {permissionDenied ? (
        <section className="data-state data-state-permission_denied" role="status">
          <div className="data-state-icon">
            <Ban aria-hidden="true" />
          </div>
          <div>
            <h3>Không có quyền nhập hồ sơ</h3>
            <p>Tài khoản hiện tại cần quyền tạo hoặc cập nhật hồ sơ vụ án để mở form nhập liệu.</p>
          </div>
        </section>
      ) : (
        <div className="intake-layout">
          <ValidationToastStack messages={toastMessages} />
          <aside className="intake-rail" aria-label="Luồng nhập liệu">
            <div className="rail-block">
              <p className="rail-label">Loại án đang nhập</p>
              <strong>{activeCaseType.label}</strong>
              <span>{activeCaseType.description}</span>
            </div>
            <ol className="step-list">
              <li className="step-active">
                <FilePlus2 size={16} aria-hidden="true" />
                Thông tin lõi
              </li>
              <li>
                <Gavel size={16} aria-hidden="true" />
                Chi tiết loại án
              </li>
              <li>
                <UserRoundPlus size={16} aria-hidden="true" />
                Người tham gia
              </li>
              <li>
                <CalendarDays size={16} aria-hidden="true" />
                Vòng đời hồ sơ
              </li>
              <li>
                <ClipboardCheck size={16} aria-hidden="true" />
                Rà soát và lưu nháp
              </li>
            </ol>
          </aside>

          <form id="case-intake-form" className="intake-form" aria-label="Form nhập hồ sơ vụ án" onSubmit={handleSubmit}>
            {readonly ? (
              <section className="data-state data-state-readonly" role="status">
                <div className="data-state-icon">
                  <Lock aria-hidden="true" />
                </div>
                <div>
                  <h3>Chế độ chỉ xem</h3>
                  <p>Các trường đang bị khóa theo quyền của tài khoản hiện tại.</p>
                </div>
              </section>
            ) : null}

            <section className="form-section">
              <div className="section-heading">
                <div>
                  <h2>Chọn loại án</h2>
                  <p>Loại án quyết định nhóm thông tin nghiệp vụ cần nhập.</p>
                </div>
              </div>
              <div className="case-type-grid" role="radiogroup" aria-label="Loại án">
                {caseTypeOptions.map((option) => (
                  <button
                    className={`case-type-option ${form.caseType === option.value ? "case-type-option-active" : ""}`}
                    key={option.value}
                    type="button"
                    disabled={readonly}
                    role="radio"
                    aria-checked={form.caseType === option.value}
                    onClick={() => updateField("caseType", option.value)}
                  >
                    <span>{option.label}</span>
                    <small>{option.description}</small>
                  </button>
                ))}
              </div>
            </section>

            <section className="form-section">
              <div className="section-heading">
                <div>
                  <h2>Thông tin lõi hồ sơ</h2>
                </div>
              </div>

              <div className="form-grid">
                <SelectField label="Tòa án thụ lý" value={form.courtId} disabled={readonly} onChange={(value) => updateField("courtId", value)}>
                  <option value="">{courtLoadError ? "Không tải được danh sách Tòa án" : "Chọn Tòa án"}</option>
                  {courts.map((item) => (
                    <option key={item.court_id} value={item.court_id}>
                      {courtNameLabel(item.court_name)}
                    </option>
                  ))}
                </SelectField>
                <SelectField label="Cấp xét xử" value={form.caseGroup} disabled={readonly} onChange={(value) => updateField("caseGroup", value)}>
                  {caseGroups.map((item) => (
                    <option key={item.value} value={item.value}>
                      {item.label}
                    </option>
                  ))}
                </SelectField>
                <TextField label="Số hồ sơ" value={form.caseNumber} disabled={readonly} onChange={(value) => updateField("caseNumber", value)} />
                <TextField label="Mã hồ sơ" value={form.caseCode} disabled={readonly} onChange={(value) => updateField("caseCode", value)} />
                <DateField label="Ngày nộp" value={form.filingDate} disabled={readonly} onChange={(value) => updateField("filingDate", value)} />
                <DateField label="Ngày thụ lý" value={form.acceptanceDate} disabled={readonly} onChange={(value) => updateField("acceptanceDate", value)} />
                <TextField
                  label="Luật tố tụng"
                  value={form.procedureLaw}
                  disabled={readonly}
                  placeholder="Chọn hoặc nhập luật tố tụng"
                  onChange={(value) => updateField("procedureLaw", value)}
                />
                <TextField
                  label="Giai đoạn hiện tại"
                  value={form.currentStage}
                  disabled={readonly}
                  placeholder="Chọn giai đoạn hiện tại"
                  onChange={(value) => updateField("currentStage", value)}
                />
              </div>

              <label className="field textarea-field">
                <span>Tóm tắt nội dung vụ án</span>
                <textarea
                  aria-label="Tóm tắt nội dung vụ án"
                  value={form.summary}
                  disabled={readonly}
                  rows={4}
                  onChange={(event) => updateField("summary", event.target.value)}
                  placeholder="Nhập tóm tắt ngắn để hỗ trợ tra cứu hồ sơ"
                />
              </label>

              <div className="toggle-row" aria-label="Đặc điểm hồ sơ">
                <CheckboxField
                  label="Có yếu tố nước ngoài"
                  checked={form.hasForeignElement}
                  disabled={readonly}
                  onChange={(checked) => updateField("hasForeignElement", checked)}
                />
                <CheckboxField
                  label="Liên quan người chưa thành niên"
                  checked={form.isMinorRelated}
                  disabled={readonly}
                  onChange={(checked) => updateField("isMinorRelated", checked)}
                />
                <CheckboxField
                  label="Hồ sơ mật"
                  checked={form.isConfidential}
                  disabled={readonly}
                  onChange={(checked) => updateField("isConfidential", checked)}
                />
              </div>
            </section>

            {form.caseGroup === "PHUC_THAM" ? (
              <section className="form-section">
                <div className="section-heading">
                  <div>
                    <h2>Thông tin sơ thẩm của hồ sơ phúc thẩm</h2>
                    <p>Dùng để truy vết bản án/quyết định bị kháng cáo, kháng nghị.</p>
                  </div>
                </div>
                <div className="form-grid">
                  <SelectField
                    label="Tòa án sơ thẩm"
                    value={form.firstInstanceCourtId}
                    disabled={readonly}
                    onChange={(value) => updateField("firstInstanceCourtId", value)}
                  >
                    <option value="">{courtLoadError ? "Không tải được danh sách Tòa án" : "Chọn Tòa án"}</option>
                    {courts.map((item) => (
                      <option key={item.court_id} value={item.court_id}>
                        {courtNameLabel(item.court_name)}
                      </option>
                    ))}
                  </SelectField>
                  <TextField
                    label="Số án sơ thẩm"
                    value={form.firstInstanceCaseNumber}
                    disabled={readonly}
                    onChange={(value) => updateField("firstInstanceCaseNumber", value)}
                  />
                  <TextField
                    label="Số bản án sơ thẩm"
                    value={form.firstInstanceJudgmentNumber}
                    disabled={readonly}
                    onChange={(value) => updateField("firstInstanceJudgmentNumber", value)}
                  />
                  <DateField
                    label="Ngày bản án sơ thẩm"
                    value={form.firstInstanceJudgmentDate}
                    disabled={readonly}
                    onChange={(value) => updateField("firstInstanceJudgmentDate", value)}
                  />
                </div>
              </section>
            ) : null}

            <CaseTypeSpecificSection
              caseType={form.caseType}
              readonly={readonly}
              criminalDetail={criminalDetail}
              civilDetail={civilDetail}
              administrativeDetail={administrativeDetail}
              defendants={defendants}
              onCriminalDetailChange={setCriminalDetail}
              onCivilDetailChange={setCivilDetail}
              onAdministrativeDetailChange={setAdministrativeDetail}
              onDefendantsChange={setDefendants}
            />
            <ParticipantSection readonly={readonly} />
            <AssignmentSection
              readonly={readonly}
              assignments={assignments}
              users={users}
              userLoadError={userLoadError}
              onAssignmentsChange={setAssignments}
            />
            <LifecycleSection readonly={readonly} />

            <div className="submit-bar">
              <button className="button button-primary" type="submit" disabled={readonly || permissionDenied || saving}>
                <FileCheck2 size={16} aria-hidden="true" />
                {saving ? "Đang lưu hồ sơ" : "Lưu hồ sơ"}
              </button>
              <button
                className="button button-secondary"
                type="button"
                disabled={saving}
                onClick={() => {
                  setForm(initialFormState);
                  setCriminalDetail(initialCriminalDetail);
                  setCivilDetail(initialCivilDetail);
                  setAdministrativeDetail(initialAdministrativeDetail);
                  setDefendants([]);
                  setAssignments([createAssignmentDraft("primary_judge"), createAssignmentDraft("clerk")]);
                  setToastSequence(0);
                  setDismissedToastSequence(0);
                  setSaveError(null);
                  setCreatedCaseId(null);
                }}
              >
                Nhập hồ sơ khác
              </button>
            </div>
          </form>
        </div>
      )}
    </main>
  );
}

function ValidationToastStack({ messages }: { messages: ToastMessage[] }) {
  const visibleMessages = messages.slice(0, 4);
  const hiddenCount = Math.max(0, messages.length - visibleMessages.length);

  if (messages.length === 0) return null;

  return (
    <aside className="toast-stack" aria-label="Cảnh báo dữ liệu" aria-live="polite">
      {visibleMessages.map((message) => (
        <article className={`toast-message toast-${message.tone}`} key={message.id} role={message.tone === "error" ? "alert" : "status"}>
          <div className="toast-icon" aria-hidden="true">
            {message.tone === "success" ? <BadgeCheck size={18} /> : <AlertTriangle size={18} />}
          </div>
          <div>
            <strong>{message.title}</strong>
            <span>{message.description}</span>
          </div>
        </article>
      ))}
      {hiddenCount > 0 ? (
        <div className="toast-more" role="status">
          Còn {hiddenCount} cảnh báo khác. Sửa các trường đang báo lỗi để danh sách tự thu gọn.
        </div>
      ) : null}
    </aside>
  );
}

function CaseTypeSpecificSection({
  caseType,
  readonly,
  criminalDetail,
  civilDetail,
  administrativeDetail,
  defendants,
  onCriminalDetailChange,
  onCivilDetailChange,
  onAdministrativeDetailChange,
  onDefendantsChange
}: {
  caseType: CaseType;
  readonly: boolean;
  criminalDetail: CriminalDetailState;
  civilDetail: CivilDetailState;
  administrativeDetail: AdministrativeDetailState;
  defendants: DefendantDraft[];
  onCriminalDetailChange: Dispatch<SetStateAction<CriminalDetailState>>;
  onCivilDetailChange: Dispatch<SetStateAction<CivilDetailState>>;
  onAdministrativeDetailChange: Dispatch<SetStateAction<AdministrativeDetailState>>;
  onDefendantsChange: Dispatch<SetStateAction<DefendantDraft[]>>;
}) {
  if (caseType === "criminal") {
    return (
      <section className="form-section">
        <div className="section-heading">
          <div>
            <h2>Chi tiết án hình sự</h2>
            <p>Thông tin truy tố, hồ sơ điều tra và danh sách bị cáo.</p>
          </div>
        </div>
        <div className="form-grid">
          <TextField label="Viện kiểm sát truy tố" value={criminalDetail.procuracyName} disabled={readonly} onChange={(value) => onCriminalDetailChange((current) => ({ ...current, procuracyName: value }))} />
          <TextField label="Số cáo trạng" value={criminalDetail.indictmentNumber} disabled={readonly} onChange={(value) => onCriminalDetailChange((current) => ({ ...current, indictmentNumber: value }))} />
          <DateField label="Ngày cáo trạng" value={criminalDetail.indictmentDate} disabled={readonly} onChange={(value) => onCriminalDetailChange((current) => ({ ...current, indictmentDate: value }))} />
          <DateField label="Ngày nhận hồ sơ" value={criminalDetail.dossierReceivedDate} disabled={readonly} onChange={(value) => onCriminalDetailChange((current) => ({ ...current, dossierReceivedDate: value }))} />
          <TextField label="Cơ quan điều tra" value={criminalDetail.investigationAgency} disabled={readonly} onChange={(value) => onCriminalDetailChange((current) => ({ ...current, investigationAgency: value }))} />
          <TextField label="Loại hội đồng xét xử" value={criminalDetail.trialPanelType} disabled={readonly} onChange={(value) => onCriminalDetailChange((current) => ({ ...current, trialPanelType: value }))} />
        </div>
        <DefendantDraftTable rows={defendants} readonly={readonly} onChange={onDefendantsChange} />
      </section>
    );
  }

  if (caseType === "administrative") {
    return (
      <section className="form-section">
        <div className="section-heading">
          <div>
            <h2>Chi tiết án hành chính</h2>
            <p>Theo dõi đối tượng bị kiện, phiên đối thoại và thi hành quyết định hành chính nếu có.</p>
          </div>
        </div>
        <div className="form-grid">
          <TextField label="Loại khiếu kiện" value={administrativeDetail.lawsuitType} disabled={readonly} onChange={(value) => onAdministrativeDetailChange((current) => ({ ...current, lawsuitType: value }))} />
          <TextField label="Cơ quan bị kiện" value={administrativeDetail.defendantAgencyName} disabled={readonly} onChange={(value) => onAdministrativeDetailChange((current) => ({ ...current, defendantAgencyName: value }))} />
          <TextField label="Người đại diện cơ quan" value={administrativeDetail.agencyRepresentative} disabled={readonly} onChange={(value) => onAdministrativeDetailChange((current) => ({ ...current, agencyRepresentative: value }))} />
          <TextField label="Cấp cơ quan" value={administrativeDetail.agencyLevel} disabled={readonly} onChange={(value) => onAdministrativeDetailChange((current) => ({ ...current, agencyLevel: value }))} />
          <TextField label="Số tiền yêu cầu bồi thường" value={administrativeDetail.compensationAmount} disabled={readonly} onChange={(value) => onAdministrativeDetailChange((current) => ({ ...current, compensationAmount: value }))} />
          <TextField label="Căn cứ thẩm quyền" value={administrativeDetail.jurisdictionBasis} disabled={readonly} onChange={(value) => onAdministrativeDetailChange((current) => ({ ...current, jurisdictionBasis: value }))} />
        </div>
        <SubTable
          title="Quyết định hoặc hành vi hành chính bị kiện"
          headers={["Loại đối tượng", "Số ký hiệu", "Ngày ban hành", "Phạm vi bị kiện"]}
          readonly={readonly}
        />
      </section>
    );
  }

  return (
    <section className="form-section">
      <div className="section-heading">
        <div>
          <h2>Chi tiết án dân sự và nhóm tương tự</h2>
          <p>Dùng cho dân sự, hôn nhân gia đình, kinh doanh thương mại và lao động.</p>
        </div>
      </div>
      <div className="form-grid">
        <TextField label="Nhóm án dân sự" value={civilDetail.civilCategory} disabled={readonly} onChange={(value) => onCivilDetailChange((current) => ({ ...current, civilCategory: value }))} />
        <TextField label="Loại tranh chấp/yêu cầu" value={civilDetail.disputeType} disabled={readonly} onChange={(value) => onCivilDetailChange((current) => ({ ...current, disputeType: value }))} />
        <TextField label="Giá trị yêu cầu" value={civilDetail.claimValue} disabled={readonly} onChange={(value) => onCivilDetailChange((current) => ({ ...current, claimValue: value }))} />
        <TextField label="Kết quả hòa giải" value={civilDetail.mediationResult} disabled={readonly} onChange={(value) => onCivilDetailChange((current) => ({ ...current, mediationResult: value }))} />
        <TextField label="Căn cứ thẩm quyền" value={civilDetail.jurisdictionBasis} disabled={readonly} onChange={(value) => onCivilDetailChange((current) => ({ ...current, jurisdictionBasis: value }))} />
        <CheckboxField label="Đã nộp tạm ứng án phí" checked={civilDetail.courtFeeAdvancePaid} disabled={readonly} onChange={(checked) => onCivilDetailChange((current) => ({ ...current, courtFeeAdvancePaid: checked }))} />
      </div>
      <SubTable title="Yêu cầu trong vụ án" headers={["Người yêu cầu", "Bị yêu cầu", "Số tiền", "Nội dung"]} readonly={readonly} />
    </section>
  );
}

function DefendantDraftTable({
  rows,
  readonly,
  onChange
}: {
  rows: DefendantDraft[];
  readonly: boolean;
  onChange: Dispatch<SetStateAction<DefendantDraft[]>>;
}) {
  function updateRow(id: string, patch: Partial<DefendantDraft>) {
    onChange((current) => current.map((item) => (item.id === id ? { ...item, ...patch } : item)));
  }

  function removeRow(id: string) {
    onChange((current) => current.filter((item) => item.id !== id));
  }

  return (
    <div className="subtable-shell editable-subtable">
      <div className="subtable-header">
        <h3>Danh sách bị cáo</h3>
        <button className="button button-secondary" type="button" disabled={readonly} onClick={() => onChange((current) => [...current, createDefendantDraft()])}>
          <Plus size={16} aria-hidden="true" />
          Thêm bị cáo
        </button>
      </div>
      <div className="compact-table-scroll">
        <table className="compact-table editable-table">
          <thead>
            <tr>
              <th>Họ tên</th>
              <th>Ngày sinh</th>
              <th>Giới tính</th>
              <th>Quốc tịch/Dân tộc</th>
              <th>Nơi cư trú</th>
              <th>Tình trạng</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            {rows.length ? (
              rows.map((row) => (
                <tr key={row.id}>
                  <td>
                    <input aria-label="Họ tên bị cáo" value={row.fullName} disabled={readonly} onChange={(event) => updateRow(row.id, { fullName: event.target.value })} />
                  </td>
                  <td>
                    <input aria-label="Ngày sinh bị cáo" type="date" value={row.dateOfBirth} disabled={readonly} onChange={(event) => updateRow(row.id, { dateOfBirth: event.target.value })} />
                  </td>
                  <td>
                    <input aria-label="Giới tính bị cáo" value={row.gender} disabled={readonly} onChange={(event) => updateRow(row.id, { gender: event.target.value })} />
                  </td>
                  <td>
                    <div className="stacked-inputs">
                      <input aria-label="Quốc tịch bị cáo" value={row.nationality} disabled={readonly} onChange={(event) => updateRow(row.id, { nationality: event.target.value })} />
                      <input aria-label="Dân tộc bị cáo" value={row.ethnicity} disabled={readonly} placeholder="Dân tộc" onChange={(event) => updateRow(row.id, { ethnicity: event.target.value })} />
                    </div>
                  </td>
                  <td>
                    <textarea aria-label="Nơi cư trú bị cáo" value={row.residence} disabled={readonly} rows={2} onChange={(event) => updateRow(row.id, { residence: event.target.value })} />
                  </td>
                  <td>
                    <div className="stacked-checks">
                      <CheckboxField label="Chưa thành niên" checked={row.isMinor} disabled={readonly} onChange={(checked) => updateRow(row.id, { isMinor: checked })} />
                      <CheckboxField label="Đang tạm giam" checked={row.isDetained} disabled={readonly} onChange={(checked) => updateRow(row.id, { isDetained: checked })} />
                    </div>
                  </td>
                  <td>
                    <button className="icon-button" type="button" disabled={readonly} aria-label="Xóa bị cáo" onClick={() => removeRow(row.id)}>
                      <Trash2 size={16} aria-hidden="true" />
                    </button>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={7}>
                  <span className="muted">Chưa có bị cáo. Bấm “Thêm bị cáo” để nhập danh sách theo từng người.</span>
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function ParticipantSection({ readonly }: { readonly: boolean }) {
  return (
    <section className="form-section">
      <div className="section-heading">
        <h2>Người tham gia tố tụng</h2>
      </div>
      <SubTable
        title="Danh sách người tham gia"
        headers={["Loại tham gia", "Họ tên/Tổ chức", "Số định danh", "Ghi chú"]}
        readonly={readonly}
      />
    </section>
  );
}

function AssignmentSection({
  readonly,
  assignments,
  users,
  userLoadError,
  onAssignmentsChange
}: {
  readonly: boolean;
  assignments: AssignmentDraft[];
  users: UserItem[];
  userLoadError: string | null;
  onAssignmentsChange: Dispatch<SetStateAction<AssignmentDraft[]>>;
}) {
  const eligibleUsers = users.filter((item) => ["judge", "clerk", "chief_judge", "deputy_chief_judge"].includes(item.role_code));

  function updateRow(id: string, patch: Partial<AssignmentDraft>) {
    onAssignmentsChange((current) => current.map((item) => (item.id === id ? { ...item, ...patch } : item)));
  }

  function removeRow(id: string) {
    onAssignmentsChange((current) => current.filter((item) => item.id !== id));
  }

  return (
    <section className="form-section">
      <div className="section-heading">
        <div>
          <h2>Người tiến hành tố tụng và phân công</h2>
          <p>Phân công Thẩm phán, Hội đồng xét xử, Thư ký và người hỗ trợ hồ sơ.</p>
        </div>
      </div>
      {userLoadError ? (
        <div className="save-error" role="alert">
          <AlertTriangle size={16} aria-hidden="true" />
          {userLoadError}
        </div>
      ) : null}
      <div className="subtable-shell editable-subtable">
        <div className="subtable-header">
          <div>
            <h3>Danh sách phân công Thẩm phán, Thư ký</h3>
            {!eligibleUsers.length ? <span>Chưa có Thẩm phán hoặc Thư ký đủ điều kiện để phân công.</span> : null}
          </div>
          <button className="button button-secondary" type="button" disabled={readonly} onClick={() => onAssignmentsChange((current) => [...current, createAssignmentDraft("panel_judge")])}>
            <UserCog size={16} aria-hidden="true" />
            Thêm phân công
          </button>
        </div>
        <div className="compact-table-scroll">
          <table className="compact-table editable-table assignment-table">
            <thead>
              <tr>
                <th>Người được phân công</th>
                <th>Vai trò</th>
                <th>Ngày</th>
                <th>Phương thức</th>
                <th>Căn cứ/Lý do</th>
                <th>Chính</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {assignments.map((row) => (
                <tr key={row.id}>
                  <td>
                    <div className="stacked-inputs">
                      <select aria-label="Người được phân công" value={row.userId} disabled={readonly} onChange={(event) => updateRow(row.id, { userId: event.target.value })}>
                        <option value="">{eligibleUsers.length ? "Chọn Thẩm phán/Thư ký" : "Chưa có người đủ điều kiện"}</option>
                        {eligibleUsers.map((user) => (
                          <option key={user.user_id} value={user.user_id}>
                            {user.full_name} | {user.position_title ?? user.role_code}
                          </option>
                        ))}
                      </select>
                      <input aria-label="Tên tham khảo" value={row.fallbackName} disabled={readonly} placeholder="Tên tham khảo" onChange={(event) => updateRow(row.id, { fallbackName: event.target.value })} />
                    </div>
                  </td>
                  <td>
                    <select aria-label="Vai trò phân công" value={row.assignmentRole} disabled={readonly} onChange={(event) => updateRow(row.id, { assignmentRole: event.target.value as AssignmentDraft["assignmentRole"], isPrimary: event.target.value === "primary_judge" })}>
                      <option value="primary_judge">Thẩm phán giải quyết</option>
                      <option value="panel_judge">Thẩm phán HĐXX</option>
                      <option value="clerk">Thư ký</option>
                      <option value="assistant">Trợ lý</option>
                      <option value="other">Khác</option>
                    </select>
                  </td>
                  <td>
                    <input aria-label="Ngày phân công" type="date" value={row.assignedDate} disabled={readonly} onChange={(event) => updateRow(row.id, { assignedDate: event.target.value })} />
                  </td>
                  <td>
                    <select aria-label="Phương thức phân công" value={row.assignmentMethod} disabled={readonly} onChange={(event) => updateRow(row.id, { assignmentMethod: event.target.value as AssignmentDraft["assignmentMethod"] })}>
                      <option value="DESIGNATED">Chỉ định</option>
                      <option value="RANDOM">Ngẫu nhiên</option>
                      <option value="MIXED">Kết hợp</option>
                    </select>
                  </td>
                  <td>
                    <div className="stacked-inputs">
                      <input aria-label="Căn cứ phân công" value={row.legalBasis} disabled={readonly} onChange={(event) => updateRow(row.id, { legalBasis: event.target.value })} />
                      <input aria-label="Lý do chỉ định" value={row.designatedReasonCode} disabled={readonly} placeholder="Lý do chỉ định" onChange={(event) => updateRow(row.id, { designatedReasonCode: event.target.value })} />
                    </div>
                  </td>
                  <td>
                    <CheckboxField label="Chính" checked={row.isPrimary} disabled={readonly} onChange={(checked) => updateRow(row.id, { isPrimary: checked })} />
                  </td>
                  <td>
                    <button className="icon-button" type="button" disabled={readonly || assignments.length <= 1} aria-label="Xóa phân công" onClick={() => removeRow(row.id)}>
                      <Trash2 size={16} aria-hidden="true" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}

function LifecycleSection({ readonly }: { readonly: boolean }) {
  return (
    <section className="form-section">
      <div className="section-heading">
        <div>
          <h2>Vòng đời và kết quả xử lý</h2>
          <p>Tách lần thụ lý và sự kiện giải quyết để tránh đếm trùng trong thống kê.</p>
        </div>
      </div>
      <div className="lifecycle-grid">
        <SubTable
          title="Lần thụ lý"
          headers={["Lần", "Ngày thụ lý", "Loại thụ lý", "Ghi chú"]}
          readonly={readonly}
        />
        <SubTable
          title="Sự kiện giải quyết"
          headers={["Ngày", "Loại kết quả", "Số quyết định", "Tính đã giải quyết"]}
          readonly={readonly}
        />
      </div>
    </section>
  );
}

function SubTable({
  title,
  headers,
  readonly
}: {
  title: string;
  headers: string[];
  readonly: boolean;
}) {
  return (
    <div className="subtable-shell">
      <div className="subtable-header">
        <h3>{title}</h3>
        <button className="button button-secondary" type="button" disabled={readonly}>
          <UserRoundPlus size={16} aria-hidden="true" />
          Thêm dòng
        </button>
      </div>
      <div className="compact-table-scroll">
        <table className="compact-table">
          <thead>
            <tr>
              {headers.map((header) => (
                <th key={header}>{header}</th>
              ))}
              <th>Trạng thái</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              {headers.map((header) => (
                <td key={header}>
                  <span className="muted">Chờ nhập</span>
                </td>
              ))}
              <td>
                <span className="status-badge">Nháp</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}

function TextField({
  label,
  value = "",
  disabled,
  placeholder,
  onChange
}: {
  label: string;
  value?: string;
  disabled?: boolean;
  placeholder?: string;
  onChange?: (value: string) => void;
}) {
  return (
    <label className="field">
      <span>{label}</span>
      <input aria-label={label} value={value} disabled={disabled} placeholder={placeholder} onChange={(event) => onChange?.(event.target.value)} />
    </label>
  );
}

function DateField({
  label,
  value = "",
  disabled,
  onChange
}: {
  label: string;
  value?: string;
  disabled?: boolean;
  onChange?: (value: string) => void;
}) {
  return (
    <label className="field">
      <span>{label}</span>
      <input aria-label={label} type="date" value={value} disabled={disabled} onChange={(event) => onChange?.(event.target.value)} />
    </label>
  );
}

function SelectField({
  label,
  value,
  disabled,
  children,
  onChange
}: {
  label: string;
  value: string;
  disabled?: boolean;
  children: ReactNode;
  onChange: (value: string) => void;
}) {
  return (
    <label className="field">
      <span>{label}</span>
      <select aria-label={label} value={value} disabled={disabled} onChange={(event) => onChange(event.target.value)}>
        {children}
      </select>
    </label>
  );
}

function CheckboxField({
  label,
  checked,
  disabled,
  onChange
}: {
  label: string;
  checked: boolean;
  disabled?: boolean;
  onChange: (checked: boolean) => void;
}) {
  return (
    <label className="checkbox-field">
      <input aria-label={label} type="checkbox" checked={checked} disabled={disabled} onChange={(event) => onChange(event.target.checked)} />
      <span>{label}</span>
    </label>
  );
}

function buildValidationMessages(form: FormState) {
  const messages: Array<{ field: string; message: string; action: string }> = [];

  if (!form.courtId) {
    messages.push({
      field: "court_id",
      message: "Thiếu Tòa án thụ lý",
      action: "Chọn đơn vị từ danh mục courts trước khi lưu."
    });
  }

  if (!form.caseNumber) {
    messages.push({
      field: "case_number",
      message: "Thiếu số hồ sơ",
      action: "Nhập số hồ sơ để kiểm tra trùng trong cùng đơn vị và loại án."
    });
  }

  if (!form.acceptanceDate) {
    messages.push({
      field: "acceptance_date",
      message: "Thiếu ngày thụ lý",
      action: "Bổ sung acceptance_date để theo dõi thời hạn và vòng đời hồ sơ."
    });
  }

  if (form.filingDate && form.acceptanceDate && form.acceptanceDate < form.filingDate) {
    messages.push({
      field: "acceptance_date",
      message: "Ngày thụ lý trước ngày nộp",
      action: "Ngày thụ lý không được trước ngày nộp đơn."
    });
  }

  if (form.caseGroup === "PHUC_THAM" && !form.firstInstanceJudgmentNumber) {
    messages.push({
      field: "first_instance_judgment_number",
      message: "Thiếu thông tin bản án sơ thẩm",
      action: "Bổ sung số bản án/quyết định sơ thẩm để theo dõi kháng cáo, kháng nghị."
    });
  }

  return messages;
}

function buildCaseIntakePayload(
  form: FormState,
  criminalDetail: CriminalDetailState,
  civilDetail: CivilDetailState,
  administrativeDetail: AdministrativeDetailState
): CaseIntakePayload {
  const payload: CaseIntakePayload = {
    case: {
      court_id: form.courtId,
      case_code: optionalText(form.caseCode),
      case_number: optionalText(form.caseNumber),
      case_type: form.caseType,
      case_group: optionalText(form.caseGroup),
      procedure_law: optionalText(form.procedureLaw),
      filing_date: optionalText(form.filingDate),
      acceptance_date: optionalText(form.acceptanceDate),
      current_stage: optionalText(form.currentStage),
      case_status: "accepted",
      has_foreign_element: form.hasForeignElement,
      is_minor_related: form.isMinorRelated,
      is_confidential: form.isConfidential,
      first_instance_court_id: optionalText(form.firstInstanceCourtId),
      first_instance_case_number: optionalText(form.firstInstanceCaseNumber),
      first_instance_judgment_number: optionalText(form.firstInstanceJudgmentNumber),
      first_instance_judgment_date: optionalText(form.firstInstanceJudgmentDate),
      summary: optionalText(form.summary)
    },
    occurrence: form.acceptanceDate
      ? {
        occurrence_no: 1,
        acceptance_date: form.acceptanceDate,
        acceptance_type_code: "INITIAL_ACCEPTANCE"
      }
      : undefined
  };

  if (form.caseType === "criminal") {
    payload.criminalDetail = {
      procuracy_name: optionalText(criminalDetail.procuracyName),
      indictment_number: optionalText(criminalDetail.indictmentNumber),
      indictment_date: optionalText(criminalDetail.indictmentDate),
      investigation_agency: optionalText(criminalDetail.investigationAgency),
      dossier_received_date: optionalText(criminalDetail.dossierReceivedDate),
      trial_panel_type: optionalText(criminalDetail.trialPanelType)
    };
  } else if (form.caseType === "administrative") {
    payload.administrativeDetail = {
      lawsuit_type: optionalText(administrativeDetail.lawsuitType),
      defendant_agency_name: optionalText(administrativeDetail.defendantAgencyName),
      agency_representative: optionalText(administrativeDetail.agencyRepresentative),
      agency_level: optionalText(administrativeDetail.agencyLevel),
      compensation_amount: optionalNumber(administrativeDetail.compensationAmount),
      jurisdiction_basis: optionalText(administrativeDetail.jurisdictionBasis)
    };
  } else {
    payload.civilDetail = {
      civil_category: optionalText(civilDetail.civilCategory),
      dispute_type: optionalText(civilDetail.disputeType),
      claim_value: optionalNumber(civilDetail.claimValue),
      jurisdiction_basis: optionalText(civilDetail.jurisdictionBasis),
      mediation_result: optionalText(civilDetail.mediationResult),
      court_fee_advance_paid: civilDetail.courtFeeAdvancePaid
    };
  }

  return payload;
}

async function saveCaseChildren(caseId: string, caseType: CaseType, defendants: DefendantDraft[], assignments: AssignmentDraft[]) {
  const defendantPayloads: DefendantCreatePayload[] =
    caseType === "criminal"
      ? defendants
          .filter((item) => item.fullName.trim())
          .map((item) => ({
            case_id: caseId,
            full_name: item.fullName.trim(),
            date_of_birth: optionalText(item.dateOfBirth),
            gender: optionalText(item.gender),
            nationality: optionalText(item.nationality),
            ethnicity: optionalText(item.ethnicity),
            occupation: optionalText(item.occupation),
            residence: optionalText(item.residence),
            criminal_record_status: optionalText(item.criminalRecordStatus),
            is_minor: item.isMinor,
            is_detained: item.isDetained,
            detention_start_date: optionalText(item.detentionStartDate),
            detention_end_date: optionalText(item.detentionEndDate)
          }))
      : [];

  const assignmentPayloads: CaseAssignmentCreatePayload[] = assignments
    .filter((item) => item.userId)
    .map((item) => ({
      case_id: caseId,
      user_id: item.userId,
      assignment_role: item.assignmentRole,
      assigned_date: optionalText(item.assignedDate),
      is_primary: item.isPrimary,
      assignment_method: item.assignmentMethod,
      legal_basis: optionalText(item.legalBasis),
      designated_reason_code: optionalText(item.designatedReasonCode),
      status: "active"
    }));

  await Promise.all([
    ...defendantPayloads.map((payload) => createDefendant(payload)),
    ...assignmentPayloads.map((payload) => createCaseAssignment(payload))
  ]);
}

function optionalText(value: string) {
  const trimmed = value.trim();
  return trimmed ? trimmed : null;
}

function optionalNumber(value: string) {
  const trimmed = value.trim();
  if (!trimmed) return null;
  const parsed = Number(trimmed);
  return Number.isFinite(parsed) ? parsed : null;
}
