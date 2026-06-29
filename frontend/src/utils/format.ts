export function formatDate(value?: string | null) {
  if (!value) return "Chưa có dữ liệu";

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;

  return new Intl.DateTimeFormat("vi-VN", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric"
  }).format(date);
}

export function displayText(value?: string | number | boolean | null) {
  if (value === undefined || value === null || value === "") return "Chưa có dữ liệu";
  if (typeof value === "boolean") return value ? "Có" : "Không";
  return String(value);
}

export function courtNameLabel(value?: string | null) {
  if (!value) return "Chưa có dữ liệu";
  return value.replace(/\s*-\s*nguồn seed Excel\s*$/iu, "").trim();
}

export function caseTypeLabel(value: string | null | undefined) {
  const labels: Record<string, string> = {
    criminal: "Hình sự",
    civil: "Dân sự",
    administrative: "Hành chính",
    marriage_family: "Hôn nhân gia đình",
    business_commercial: "Kinh doanh thương mại",
    labor: "Lao động",
    civil_matter: "Việc dân sự",
    bankruptcy: "Phá sản",
    administrative_measure: "Biện pháp xử lý hành chính",
    other: "Khác"
  };

  return value ? labels[value] ?? value : "Chưa có dữ liệu";
}

export function statusLabel(value: string | null | undefined) {
  const labels: Record<string, string> = {
    draft: "Dự thảo",
    received: "Đã tiếp nhận",
    accepted: "Đã thụ lý",
    in_progress: "Đang xử lý",
    preparing: "Đang chuẩn bị",
    trial_scheduled: "Đã lên lịch xét xử",
    resolved: "Đã giải quyết",
    appealed: "Có kháng cáo/kháng nghị",
    effective: "Có hiệu lực",
    temporarily_suspended: "Tạm đình chỉ",
    suspended: "Đình chỉ",
    overdue: "Quá hạn",
    closed: "Đã đóng"
  };

  return value ? labels[value] ?? value : "Chưa có dữ liệu";
}

export function courtLevelLabel(value: string | null | undefined) {
  const labels: Record<string, string> = {
    province: "Tòa án cấp tỉnh",
    district: "Tòa án cấp huyện",
    regional: "Tòa án khu vực",
    military: "Tòa án quân sự",
    upper: "Tòa án cấp cao",
    supreme: "Tòa án nhân dân tối cao"
  };

  return value ? labels[value] ?? value : "Chưa có dữ liệu";
}

export function roleLabel(value: string | null | undefined) {
  const labels: Record<string, string> = {
    PRESIDING_JUDGE: "Chủ tọa phiên tòa",
    PANEL_JUDGE: "Thành viên hội đồng",
    HEARING_CLERK: "Thư ký phiên tòa"
  };

  return value ? labels[value] ?? value : "Chưa có dữ liệu";
}
