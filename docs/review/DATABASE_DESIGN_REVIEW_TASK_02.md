# DATABASE DESIGN REVIEW TASK 02

## Phạm vi

Đã rà soát theo các tài liệu bắt buộc: `README.md`, `AGENTS.md`, rule AI Agent, schema hợp nhất, thư mục diagram, migration, skills và dữ liệu thống kê JSON. Phạm vi thực hiện chỉ là database: quan hệ, khóa, ràng buộc chống trùng, index, đọc/ghi nhiều session và test SQL.

## Kết luận ngắn

Schema hợp nhất có cấu trúc module hợp lý và đủ nền để triển khai PostgreSQL. Điểm yếu chính trước Task 02 là nhiều bảng dùng khóa ngoại tốt nhưng thiếu ràng buộc chống trùng ở cấp database, đặc biệt ở thống kê/KPI, phân công active, phúc thẩm/kháng nghị, validation/risk và các bảng con chuyên biệt.

Migration `database/migrations/002_database_constraints_and_indexes.sql` đã được tạo để bổ sung constraint/index theo hướng additive-only, không drop dữ liệu, không đổi tên bảng/cột lõi và không sửa nghiệp vụ skill.

## Quan hệ đã kiểm tra

### Core case

- `courts`, `users`, `judge_profiles`, `case_files` là trục master/core.
- `case_files` liên kết đúng với `participants`, `documents`, `case_events`, `case_assignments`, `hearings`, `decisions`, `appeals`, `deadlines`, `validation_results`.
- Đã bổ sung chống trùng số vụ án theo `court_id + case_number + case_type`.
- Đã bổ sung chống trùng một thẩm phán chính active cho mỗi hồ sơ.
- Đã bổ sung index dashboard theo tòa, loại án, trạng thái, ngày thụ lý và ngày giải quyết.

### Specialized modules

- Dân sự, hình sự, hành chính đều dùng bảng detail 1-1 với `case_files`, phù hợp để mở rộng theo từng loại án.
- Đã bổ sung chống trùng cho yêu cầu dân sự, phiên hòa giải, bị cáo, tội danh, bị hại, trả hồ sơ điều tra bổ sung, đối tượng hành chính bị khiếu kiện, phiên đối thoại và theo dõi thi hành án hành chính.
- Đã bổ sung check constraint ngày kết thúc biện pháp ngăn chặn và ngày tuân thủ hành chính.

### Random assignment

- Quan hệ batch, danh sách án, danh sách thẩm phán, trạng thái thẩm phán, workload, xung đột, thay thế và audit đã tách module rõ.
- Đã bổ sung chống trùng integrity hash, thứ tự thẩm phán trong batch, workload snapshot với `case_group` NULL, conflict type NULL và lịch sử thay thế.
- Đã bổ sung index cho batch theo tòa/trạng thái/ngày, danh sách án theo thứ tự và danh sách thẩm phán theo thứ tự.

### Appeal/protest

- `appellate_trackings` liên kết hồ sơ gốc, quyết định gốc, tòa gốc và tòa cấp trên.
- Các bảng `appeal_protest_items`, `appellate_results`, `appellate_fault_assessments`, `appellate_followup_actions`, `appellate_status_history` đủ để theo dõi vòng đời phúc thẩm/kháng cáo/kháng nghị.
- Đã bổ sung chống trùng tracking theo hồ sơ/quyết định/loại.
- Đã chặn item cụ thể có `item_type = BOTH`; tracking tổng vẫn có thể là `both`.
- Đã yêu cầu lỗi chủ quan phải có nhóm lý do để giảm rủi ro AI hoặc người dùng ghi nhận định chủ quan thiếu căn cứ.

### Statistics/KPI

- `statistics_periods`, `statistics_snapshots`, `kpi_metrics`, `kpi_values` đáp ứng mô hình kỳ thống kê và chỉ tiêu.
- Đã bổ sung unique index theo scope cho snapshot thống kê và KPI, xử lý cả trường hợp `court_id`, `case_id`, `judge_id`, `case_group` bị NULL.
- Đã bổ sung check số liệu không âm và index dashboard theo kỳ/tòa/chỉ tiêu.

### Validation/audit/AI

- `validation_results`, `ai_suggestions`, `case_risk_flags`, `audit_logs` giữ đúng nguyên tắc AI chỉ gợi ý, cảnh báo, audit.
- Đã bổ sung partial unique index để chặn một rule/risk đang mở bị ghi lặp vô hạn, nhưng vẫn giữ được lịch sử sau khi đóng.
- Đã bổ sung index cho validation theo trạng thái/mức độ và audit theo bảng/bản ghi/thời gian.

## Ràng buộc chống trùng dữ liệu đã đề xuất

- Hồ sơ: không trùng `court_id + case_number + case_type`.
- Đương sự: không trùng danh tính trong cùng hồ sơ theo loại đương sự.
- Tài liệu/quyết định/kháng cáo/hạn: không trùng các khóa nghiệp vụ có số văn bản hoặc ngày rõ ràng.
- Phân công: chỉ một thẩm phán chính active cho mỗi hồ sơ; không lặp cùng user/role active.
- Thống kê/KPI: không lặp cùng chỉ tiêu trong cùng kỳ và scope.
- Phúc thẩm/kháng nghị: không lặp tracking, item, kết quả, đánh giá lỗi, follow-up và lịch sử trạng thái trong cùng phạm vi.
- Validation/risk: không lặp rule/risk đang mở cho cùng hồ sơ.

## Index tối ưu đọc

- Dashboard hồ sơ: `idx_case_files_dashboard_status`, `idx_case_files_closed_dashboard`.
- Pool phân công án: `idx_case_files_assignment_pool`, `idx_assignment_batches_court_status_date`, `idx_assignment_batch_cases_batch_order`, `idx_assignment_batch_judges_batch_order`.
- Lịch/hạn/validation: `idx_hearings_schedule`, `idx_deadlines_status_due`, `idx_validation_results_status_severity`.
- Thống kê/KPI: `idx_statistics_snapshots_dashboard`, `idx_statistics_snapshots_metric_time`, `idx_kpi_values_dashboard`, `idx_kpi_values_metric_time`.
- Phúc thẩm/kháng nghị: `idx_appellate_trackings_upper_status`, `idx_appellate_trackings_original_received`, `idx_appellate_trackings_final_result`, `idx_appeal_protest_items_status`.
- AI/audit: `idx_ai_suggestions_pending`, `idx_case_risk_flags_open`, `idx_audit_logs_record_time`.

## Khuyến nghị đọc/ghi nhiều session

- Phân công án nên chạy trong transaction ngắn, khóa batch và dùng `FOR UPDATE SKIP LOCKED` khi lấy hồ sơ/thẩm phán ứng viên.
- Ghi thống kê/KPI nên dùng `INSERT ... ON CONFLICT ... DO UPDATE` theo unique index đã tạo.
- Nên bổ sung optimistic locking bằng `row_version` ở task sau cho các bảng ghi thường xuyên.
- Dashboard nên đọc từ snapshot/KPI hoặc materialized view sau khi đã chốt công thức nghiệp vụ.
- Với dữ liệu lớn, cân nhắc partition theo thời gian cho audit/event/validation/statistics.

## Nội dung cần xác nhận nghiệp vụ

- Một hồ sơ/quyết định có thể có nhiều tracking cùng loại kháng cáo hoặc kháng nghị hay không.
- Trùng đương sự theo họ tên/ngày sinh/số định danh cần xử lý thế nào khi thiếu số định danh.
- Một chỉ tiêu thống kê có cần lưu nhiều phiên bản tính lại trong cùng kỳ hay chỉ lưu một bản hiện hành.
- Danh sách giá trị chuẩn cho các cột trạng thái dạng text.
- Có cho phép KPI hoặc số liệu thống kê âm trong trường hợp đặc biệt hay không.

## Validation

- `tests/database/schema_integrity_test.sql` kiểm tra constraint/index/FK/enum quan trọng.
- `tests/database/duplicate_prevention_test.sql` tạo dữ liệu mẫu trong transaction, thử ghi trùng và rollback.
- Chưa chạy được bằng `psql` tại máy hiện tại nếu môi trường chưa có PostgreSQL client. Có thể kiểm tra cú pháp bằng PostgreSQL thật theo hướng dẫn trong từng file test.
