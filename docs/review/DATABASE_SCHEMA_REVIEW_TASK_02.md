# DATABASE_SCHEMA_REVIEW_TASK_02

Ngày thực hiện: 2026-06-08

## Phạm vi

Task 02 kiểm chứng và chuẩn hóa schema database hợp nhất:

- đọc `README.md`, `AGENTS.md`, `database/schema/unified_postgresql_schema.sql`;
- kiểm tra schema hợp nhất ở mức cú pháp PostgreSQL;
- tạo smoke test SQL để chạy bằng `psql`;
- tạo danh sách bảng/enum kỳ vọng;
- không viết backend/frontend;
- không xóa file nguồn trong `Documents/`, `bieu_mau/`, `knowledge_base/`.

## Kết quả

Schema `database/schema/unified_postgresql_schema.sql` parse thành công bằng `pglast` với 75 statement.

Không phát hiện lỗi schema thực sự ở mức cú pháp/tạo thứ tự object khi đọc tĩnh, nên không sửa `unified_postgresql_schema.sql` trong task này.

Đã tạo:

- `tests/database/README.md`
- `tests/database/schema_smoke_test.sql`
- `tests/database/expected_tables.md`
- `docs/review/DATABASE_SCHEMA_REVIEW_TASK_02.md`

## Nhóm test đã bao phủ

Smoke test kiểm tra đủ các nhóm:

- Master data: `courts`, `users`, `judge_profiles`.
- Case core: `case_files`, `participants`, `documents`, `case_events`, `case_assignments`, `hearings`, `decisions`, `appeals`.
- Specialized modules: dân sự, hình sự, hành chính.
- Random assignment: `assignment_batches`, `assignment_batch_cases`, `assignment_batch_judges`, `judge_*`, `assignment_audit_logs`.
- Appeal/protest: `appellate_trackings`, `appeal_protest_items`, `appellate_results`, `appellate_fault_assessments`, `appellate_followup_actions`, `appellate_status_history`.
- Analytics: `statistics_periods`, `statistics_snapshots`, `kpi_metrics`, `kpi_values`.
- AI/rule layer: `deadlines`, `validation_results`, `ai_suggestions`, `case_risk_flags`, `audit_logs`.

## Hướng dẫn chạy runtime

```bash
createdb tand_qng_schema_test
psql -v ON_ERROR_STOP=1 -d tand_qng_schema_test -f database/schema/unified_postgresql_schema.sql
psql -v ON_ERROR_STOP=1 -d tand_qng_schema_test -f tests/database/schema_smoke_test.sql
dropdb tand_qng_schema_test
```

Kỳ vọng:

```text
NOTICE:  schema smoke test passed
```

## Trạng thái đạt/chưa đạt

Đạt ở mức kiểm tra tĩnh:

- SQL parse OK.
- Thứ tự khai báo enum, bảng và khóa ngoại đọc tĩnh hợp lý.
- Smoke test đã được viết để kiểm tra bảng, enum, khóa ngoại và insert dữ liệu liên kết tối thiểu.

Chưa xác nhận runtime tại môi trường hiện tại:

- Máy hiện không có `psql`, nên chưa chạy được schema trên PostgreSQL thật trong phiên này.
- Cần chạy lệnh ở trên tại máy có PostgreSQL để xác nhận đầy đủ mục tiêu "chạy được trên database trống".

## Rủi ro còn lại

- Schema dùng `uuid-ossp`; PostgreSQL target phải cho phép `CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`.
- Một số cột nghiệp vụ vẫn đang là `VARCHAR` tự do, ví dụ trạng thái chi tiết của appellate/deadline/hearing. Điều này không làm schema lỗi, nhưng cần enum/danh mục ở giai đoạn migration sau nếu muốn kiểm soát dữ liệu chặt hơn.
- `appeal_protest_items.item_type` đang dùng chung `appeal_protest_type_enum`, nên về kỹ thuật có thể nhận giá trị `BOTH`. Nếu nghiệp vụ yêu cầu mỗi item chỉ là `APPEAL` hoặc `PROTEST`, nên thêm check constraint ở task sau.
- Smoke test là kiểm tra tối thiểu, chưa kiểm tra mọi constraint, index và rule nghiệp vụ thời hạn.
