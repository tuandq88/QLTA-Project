# Expected Database Objects

Danh sách này dùng để đối chiếu với `database/schema/unified_postgresql_schema.sql` và `tests/database/schema_smoke_test.sql`.

## Enum Types

| Enum | Vai trò |
|---|---|
| `court_level_enum` | Cấp Tòa án |
| `user_role_enum` | Vai trò người dùng |
| `case_type_enum` | Loại án/vụ việc |
| `case_status_enum` | Trạng thái hồ sơ |
| `assignment_method_enum` | Phương thức phân công án |
| `assignment_status_enum` | Trạng thái phiên/kết quả phân công |
| `appeal_protest_type_enum` | Kháng cáo/kháng nghị |
| `fault_classification_enum` | Phân loại nguyên nhân hủy/sửa |
| `validation_severity_enum` | Mức độ cảnh báo/validation |

## Master Data

| Table | Ghi chú |
|---|---|
| `courts` | Danh mục Tòa án |
| `users` | Người dùng, Thẩm phán, Thư ký, lãnh đạo |
| `judge_profiles` | Hồ sơ nghiệp vụ Thẩm phán |

## Case Core

| Table | Ghi chú |
|---|---|
| `case_files` | Hồ sơ vụ án/vụ việc trung tâm |
| `participants` | Người tham gia tố tụng |
| `documents` | Tài liệu, văn bản, bản án/quyết định |
| `case_events` | Nhật ký vòng đời hồ sơ |
| `case_assignments` | Kết quả phân công người xử lý hồ sơ |
| `hearings` | Phiên tòa/phiên họp |
| `decisions` | Bản án/quyết định |
| `appeals` | Ghi nhận kháng cáo/kháng nghị cơ bản |

## Specialized Modules

| Table | Nhóm |
|---|---|
| `civil_case_details` | Dân sự, HNGĐ, KDTM, lao động |
| `civil_claims` | Dân sự |
| `mediation_sessions` | Hòa giải |
| `criminal_case_details` | Hình sự |
| `defendants` | Hình sự |
| `charges` | Hình sự |
| `preventive_measures` | Hình sự |
| `sentences` | Hình sự |
| `victims` | Hình sự |
| `investigation_returns` | Hình sự |
| `administrative_case_details` | Hành chính |
| `challenged_admin_objects` | Hành chính |
| `dialogue_sessions` | Hành chính |
| `admin_enforcement_tracking` | Thi hành án hành chính |

## Random Assignment

| Table | Ghi chú |
|---|---|
| `assignment_batches` | Phiên phân công |
| `assignment_batch_cases` | Danh sách vụ việc tại thời điểm phân công |
| `assignment_batch_judges` | Danh sách Thẩm phán tại thời điểm phân công |
| `judge_status_periods` | Thời gian Thẩm phán không đủ điều kiện/giảm chỉ tiêu |
| `judge_workload_snapshots` | Snapshot tải án |
| `judge_case_conflicts` | Xung đột vụ việc cụ thể |
| `judge_replacement_history` | Lịch sử thay đổi Thẩm phán |
| `assignment_audit_logs` | Audit log phân công án |

## Appeal/Protest Tracking

| Table | Ghi chú |
|---|---|
| `appellate_trackings` | Hồ sơ theo dõi kháng cáo/kháng nghị |
| `appeal_protest_items` | Từng đơn kháng cáo/quyết định kháng nghị |
| `appellate_results` | Kết quả Tòa án cấp trên |
| `appellate_fault_assessments` | Đánh giá nguyên nhân hủy/sửa |
| `appellate_followup_actions` | Việc cần làm sau kết quả cấp trên |
| `appellate_status_history` | Lịch sử trạng thái |

## Analytics

| Table | Ghi chú |
|---|---|
| `statistics_periods` | Kỳ thống kê |
| `statistics_snapshots` | Snapshot số liệu thống kê |
| `kpi_metrics` | Định nghĩa KPI |
| `kpi_values` | Giá trị KPI |

## AI/Rule Layer

| Table | Ghi chú |
|---|---|
| `deadlines` | Thời hạn tố tụng |
| `validation_results` | Kết quả kiểm tra rule |
| `ai_suggestions` | Gợi ý của AI, chưa ghi vào dữ liệu chính |
| `case_risk_flags` | Cờ rủi ro hồ sơ |
| `audit_logs` | Audit log tổng quát |
