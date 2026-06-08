# Rà soát quan hệ database Task 02

## Luồng quan hệ chính

```mermaid
erDiagram
    courts ||--o{ users : manages
    courts ||--o{ case_files : owns
    users ||--o| judge_profiles : has
    case_files ||--o{ participants : has
    case_files ||--o{ documents : stores
    case_files ||--o{ case_events : records
    case_files ||--o{ case_assignments : assigned
    users ||--o{ case_assignments : receives
    case_files ||--o{ hearings : schedules
    case_files ||--o{ decisions : resolves
    case_files ||--o{ deadlines : tracks
    case_files ||--o{ validation_results : validates
```

Core case đã có quan hệ nền tảng hợp lý: hồ sơ thuộc tòa, người dùng thuộc tòa, hồ sơ có đương sự, tài liệu, sự kiện, phân công, phiên xử, quyết định, hạn và kết quả kiểm tra rule. Migration 002 bổ sung khóa chống trùng cho số vụ án theo tòa/loại án, phân công thẩm phán chính active, tài liệu cùng số văn bản và validation đang mở.

## Module án chuyên biệt

```mermaid
erDiagram
    case_files ||--o| civil_case_details : civil
    civil_case_details ||--o{ civil_claims : has
    civil_case_details ||--o{ mediation_sessions : has
    case_files ||--o| criminal_case_details : criminal
    criminal_case_details ||--o{ defendants : has
    defendants ||--o{ charges : charged
    defendants ||--o{ preventive_measures : constrained
    defendants ||--o{ sentences : sentenced
    criminal_case_details ||--o{ victims : has
    criminal_case_details ||--o{ investigation_returns : returned
    case_files ||--o| administrative_case_details : administrative
    administrative_case_details ||--o{ challenged_admin_objects : challenges
    administrative_case_details ||--o{ dialogue_sessions : has
    administrative_case_details ||--o{ admin_enforcement_tracking : tracks
```

Mỗi loại án chuyên biệt đang dùng quan hệ 1-1 với `case_files` qua bảng detail, sau đó tách các danh sách con. Đây là thiết kế phù hợp để tránh nhồi mọi trường vào bảng hồ sơ lõi. Migration 002 thêm chống trùng ở các danh sách con có định danh rõ: yêu cầu dân sự theo bên, phiên hòa giải theo ngày, bị cáo theo họ tên/ngày sinh, tội danh theo điều khoản, đối tượng hành chính theo số văn bản.

## Phân công án ngẫu nhiên

```mermaid
erDiagram
    courts ||--o{ assignment_batches : creates
    assignment_batches ||--o{ assignment_batch_cases : contains
    case_files ||--o{ assignment_batch_cases : candidate
    assignment_batches ||--o{ assignment_batch_judges : includes
    users ||--o{ assignment_batch_judges : candidate
    users ||--o{ judge_status_periods : status
    users ||--o{ judge_workload_snapshots : workload
    case_files ||--o{ judge_case_conflicts : conflict
    users ||--o{ judge_case_conflicts : conflicted
    case_assignments ||--o{ judge_replacement_history : replaced
    assignment_batches ||--o{ assignment_audit_logs : audited
```

Thiết kế đã tách batch, danh sách án, danh sách thẩm phán, trạng thái, tải công việc, xung đột và audit. Migration 002 bổ sung khóa chống trùng integrity hash, thứ tự thẩm phán trong batch, trạng thái bắt đầu của thẩm phán, workload snapshot có `case_group` NULL, conflict type NULL và lịch sử thay thế.

## Phúc thẩm, kháng cáo, kháng nghị

```mermaid
erDiagram
    case_files ||--o{ appellate_trackings : tracked
    courts ||--o{ appellate_trackings : original_court
    courts ||--o{ appellate_trackings : upper_court
    decisions ||--o{ appellate_trackings : original_decision
    appellate_trackings ||--o{ appeal_protest_items : has
    appellate_trackings ||--o{ appellate_results : resulted
    appellate_results ||--o{ appellate_fault_assessments : assessed
    appellate_trackings ||--o{ appellate_followup_actions : follows
    appellate_trackings ||--o{ appellate_status_history : histories
```

Quan hệ module phúc thẩm đã đủ để theo dõi từ hồ sơ gốc, quyết định gốc, nội dung kháng cáo/kháng nghị, kết quả cấp trên, đánh giá lỗi, hành động theo dõi và lịch sử trạng thái. Migration 002 chặn `appeal_protest_items.item_type = BOTH` ở từng item, vì `BOTH` chỉ phù hợp ở tracking tổng hợp; item cụ thể phải là kháng cáo hoặc kháng nghị. Ràng buộc lỗi chủ quan phải có nhóm lý do được thêm ở cấp database.

## Thống kê, KPI, AI và audit

```mermaid
erDiagram
    statistics_periods ||--o{ statistics_snapshots : period
    courts ||--o{ statistics_snapshots : scope
    case_files ||--o{ statistics_snapshots : optional_case
    kpi_metrics ||--o{ kpi_values : metric
    statistics_periods ||--o{ kpi_values : period
    courts ||--o{ kpi_values : court_scope
    users ||--o{ kpi_values : judge_scope
    case_files ||--o{ ai_suggestions : suggested
    case_files ||--o{ case_risk_flags : flagged
    users ||--o{ audit_logs : actor
```

Các bảng thống kê/KPI đang tách kỳ, chỉ tiêu và giá trị. Migration 002 thêm khóa chống trùng theo scope để ngăn một chỉ tiêu bị ghi lặp trong cùng kỳ/tòa/thẩm phán/hồ sơ. Lớp AI/rule giữ vai trò gợi ý, cảnh báo và audit; không thay thế quyết định nghiệp vụ.

## Quan hệ cần cân nhắc ở task sau

- `judge_status_periods` nên có exclusion constraint theo khoảng thời gian để chặn hai trạng thái active chồng lấn của cùng thẩm phán.
- `statistics_snapshots` nếu cần lưu lịch sử nhiều lần tính lại thì cần thêm version hoặc trạng thái hiệu lực.
- Các cột trạng thái dạng text nên chuyển dần sang enum/bảng danh mục sau khi chốt bộ giá trị chuẩn.
