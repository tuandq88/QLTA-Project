# Checklist đọc/ghi nhiều session PostgreSQL

Checklist này dùng cho Task 02 database-only. Mục tiêu là giảm trùng dữ liệu và giữ dashboard đọc nhanh khi nhiều người dùng cùng nhập hồ sơ, phân công án, cập nhật KPI hoặc kiểm tra phúc thẩm/kháng nghị.

## Nguyên tắc giao dịch

- Mỗi thao tác ghi nghiệp vụ lớn phải chạy trong transaction ngắn: tạo hồ sơ, phân công án, cập nhật kết quả phúc thẩm, ghi validation/risk.
- Không giữ transaction mở trong lúc người dùng chờ AI sinh nội dung. AI chỉ ghi kết quả sau khi đã có dữ liệu đầu ra.
- Các bước phân công án nên dùng `SELECT ... FOR UPDATE SKIP LOCKED` trên danh sách án chờ và thẩm phán hợp lệ để tránh hai phiên lấy cùng một hồ sơ.
- Với bảng snapshot/KPI, dùng `INSERT ... ON CONFLICT ... DO UPDATE` dựa trên unique index đã bổ sung, thay vì kiểm tra rồi insert thủ công.

## Khóa và chống đua dữ liệu

- `case_assignments`: unique index `uq_case_assignments_active_primary` đảm bảo một hồ sơ chỉ có một thẩm phán chính đang active.
- `assignment_batches`: nên khóa batch theo `assignment_batch_id` khi chốt kết quả phân công để tránh hai phiên cùng quyết định một batch.
- `appellate_trackings`: unique index theo hồ sơ/quyết định/loại kháng cáo-kháng nghị giúp tránh mở hai luồng theo dõi cho cùng một phạm vi.
- `validation_results` và `case_risk_flags`: unique index dạng partial chỉ chặn bản ghi đang mở, vẫn cho phép lưu lịch sử sau khi đóng.

## Optimistic locking

- Đề xuất bổ sung ở task sau: cột `row_version integer NOT NULL DEFAULT 1` cho các bảng ghi thường xuyên như `case_files`, `case_assignments`, `appellate_trackings`, `statistics_snapshots`, `kpi_values`.
- Khi cập nhật, điều kiện nên có `WHERE id = :id AND row_version = :old_row_version`; nếu không update được dòng nào thì yêu cầu tải lại dữ liệu.
- Không đưa `row_version` vào migration 002 vì migration này chỉ bổ sung constraint/index.

## Dashboard và báo cáo

- Với dashboard lãnh đạo, ưu tiên đọc từ `statistics_snapshots` và `kpi_values`, không quét trực tiếp toàn bộ hồ sơ nếu đã có kỳ báo cáo.
- Đề xuất task sau tạo materialized view cho tổng hợp theo tòa, thẩm phán, loại án, trạng thái và kỳ thống kê.
- Nếu materialized view được dùng, cần unique index trên khóa refresh và dùng `REFRESH MATERIALIZED VIEW CONCURRENTLY`.

## Partitioning

- Chưa partition trong migration 002 để không phá schema.
- Khi dữ liệu lớn, cân nhắc partition theo thời gian cho `audit_logs`, `assignment_audit_logs`, `case_events`, `validation_results`, `statistics_snapshots`.
- Với hồ sơ vụ án, chỉ partition nếu đã xác nhận quy tắc truy vấn chính là theo `acceptance_date` hoặc `court_id`.

## Kiểm tra trước môi trường thật

- Chạy migration trên database staging có dữ liệu thật.
- Nếu migration tạo unique index báo lỗi duplicate, phải xuất danh sách bản ghi trùng và xử lý nghiệp vụ trước khi chạy lại.
- Với production lớn, cân nhắc đổi `CREATE INDEX` sang `CREATE INDEX CONCURRENTLY` và chạy ngoài transaction.
