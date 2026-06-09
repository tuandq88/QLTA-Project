# Rà soát database và seed trước kiểm thử thuật toán thống kê

Ngày rà soát: 09/06/2026

## 1. Mục tiêu rà soát

Rà soát cấu trúc database, migrations, seed và bộ script kiểm tra trước khi bước sang giai đoạn seed dữ liệu thật và kiểm thử thuật toán thống kê. Phạm vi chỉ gồm database/seed/test, không viết backend, frontend, API hoặc UI.

## 2. File đã đọc

Đã đọc/rà soát các nhóm file chính:

- `README.md`
- `AGENTS.md`
- `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md`
- `knowledge_base/skills/`
- `knowledge_base/data/statistics/`
- `database/schema/`
- `database/schema/unified_postgresql_schema.sql`
- `database/migrations/`
- `database/seed/`
- `database/seed/legal_seed_data_tand_vietnam/`
- `database/seed/danh sach/`
- `database/diagrams/`
- `tests/database/`
- `docs/review/`

## 3. Trạng thái unified schema

`database/schema/unified_postgresql_schema.sql` đủ điều kiện làm source of truth cho database mới.

Các nhóm bảng bắt buộc đã có:

- Master Data: `courts`, `users`, `judge_profiles`, `dm_categories`, `dm_category_items` và nhiều bảng `dm_*`.
- Case Core: `case_files`, `participants`, `documents`, `hearings`, `decisions`, `case_assignments`, `case_events`, `deadlines`, `validation_results`, `audit_logs`.
- Specialized Case Modules: `civil_case_details`, `criminal_case_details`, `defendants`, `charges`, `administrative_case_details` và các bảng chi tiết liên quan.
- Random Assignment Module: `assignment_batches`, `assignment_batch_cases`, `assignment_batch_judges`, `judge_status_periods`, `judge_case_conflicts`, `judge_workload_snapshots`, `judge_replacement_history`, `assignment_audit_logs`.
- Appeal/Protest Tracking Module: `appellate_trackings`, `appeal_protest_items`, `appellate_results`, `appellate_fault_assessments`, `appellate_followup_actions`, `appellate_status_history`.
- Statistical Reference Data: `statistical_categories`, `statistical_indicators`, `statistical_indicator_options`, `statistical_indicator_applicability`, `entity_statistical_attributes`, `dm_statistical_forms`, `dm_statistical_form_items`, `dm_statistical_metrics`.
- Analytics/KPI: `statistics_periods`, `statistics_snapshots`, `kpi_metrics`, `kpi_values`.

Ghi chú: `dm_kpi_metrics` chưa có, nhưng yêu cầu cho phép dùng `kpi_metrics` hoặc `dm_kpi_metrics`. Hiện unified schema dùng `kpi_metrics`.

## 4. Trạng thái migrations

Chuỗi migration đánh số gồm:

- `001_core_database_schema.sql`
- `002_database_constraints_and_indexes.sql`
- `003_reference_data_and_foreign_keys.sql`
- `004_statistical_reference_data.sql`
- `005_legal_seed_data_normalization.sql`

Hai file legacy:

- `random_assignment_schema_extension.sql`
- `appeal_protest_tracking_schema_extension.sql`

Hai file legacy này có bảng trùng với schema/migration mới và dùng `CREATE TABLE` không có `IF NOT EXISTS`, nên không chạy mặc định trong script `MigrationsOnly`.

## 5. Trạng thái seed

Các seed SQL chính đã chạy thành công theo thứ tự:

- `003_reference_data_seed.sql`
- `004_statistical_reference_data_seed.sql`
- `010_legal_seed_data_tand_vietnam.sql`
- `020_excel_seed_case_categories.sql`
- `021_excel_seed_criminal_categories.sql`
- `022_excel_seed_civil_categories.sql`
- `023_excel_seed_administrative_categories.sql`
- `024_excel_seed_labor_business_marriage_categories.sql`
- `025_excel_seed_statistical_indicators.sql`

Seed đã được kiểm tra chạy lại lần 2 thành công, không phát hiện lỗi duplicate key hoặc FK trong lần chạy hiện tại.

## 6. Trạng thái script kiểm tra

Đã viết lại/tạo mới:

- `tests/database/run_empty_postgres_check.ps1`
- `tests/database/run_seed_validation_check.ps1`
- `tests/database/run_statistics_precheck.ps1`

Các script dùng `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, không hard-code password, không dùng Windows username làm PostgreSQL user, không dùng `psql -i`, chạy SQL inline bằng `-c`, chạy file bằng `-f`, và chỉ fail theo exit code khác 0.

## 7. Lỗi đã phát hiện

- Rủi ro chạy trùng unified schema và migrations.
- Hai migration legacy có bảng trùng và không idempotent.
- Script cũ chưa có đủ `SkipSeed`, `SkipTests`.
- Một số seed Excel/legal có trường/metadata `requires_human_review`.
- Một số nội dung nguồn/console có nguy cơ mojibake khi hiển thị trên PowerShell, cần tiếp tục kiểm soát encoding.

## 8. Lỗi đã sửa

- Chuẩn hóa source of truth tại `database/schema/SCHEMA_SOURCE_OF_TRUTH.md`.
- Bổ sung README seed và thứ tự seed.
- Viết lại script empty check.
- Tạo script seed validation riêng.
- Tạo script statistics precheck riêng.
- Tạo SQL test tổng hợp cho cấu trúc, seed và precheck thống kê.
- Chạy kiểm tra thực tế và ghi kết quả vào file result.

## 9. Lỗi còn lại

- Chưa chạy `MigrationsOnly` trong báo cáo này; chế độ này đã được script hỗ trợ nhưng cần kiểm tra riêng khi muốn xác nhận chuỗi migration nâng cấp.
- Một số seed có `requires_human_review = true`, chưa thể coi là dữ liệu pháp lý cuối cùng.
- Một số tên/ghi chú trong seed sinh từ Excel có dấu hiệu lỗi mã hóa ở mô tả, cần human review trước khi dùng chính thức.

## 10. Bảng đang thiếu

Không phát hiện thiếu bảng bắt buộc đối với chế độ `UnifiedOnly`.

`dm_kpi_metrics` không có, nhưng không bắt buộc vì schema hiện có `kpi_metrics`.

## 11. Seed đang thiếu

Chưa có seed dữ liệu vụ án thật, dữ liệu cá nhân thật hoặc hồ sơ thật. Đây là đúng phạm vi task hiện tại.

Seed biểu mẫu/chỉ tiêu thống kê vẫn cần tiếp tục đối chiếu `Documents/huong_dan_bm.pdf` và các JSON trong `knowledge_base/data/statistics/` trước khi dùng như dữ liệu nghiệp vụ cuối cùng.

## 12. Dữ liệu cần human review

- Dữ liệu trong `010_legal_seed_data_tand_vietnam.sql` có cờ `requires_human_review`.
- Dữ liệu alias từ Excel trong `020_excel_seed_case_categories.sql`.
- Dữ liệu quan hệ pháp luật/tội danh từ các file `021` đến `024`.
- Chỉ tiêu thống kê trong `025_excel_seed_statistical_indicators.sql`.

## 13. Quy trình chạy đề xuất

1. Kiểm tra schema bằng `run_empty_postgres_check.ps1`.
2. Chạy và kiểm tra seed bằng `run_seed_validation_check.ps1`.
3. Chạy precheck thống kê bằng `run_statistics_precheck.ps1`.
4. Chỉ khi tất cả kết quả là `PASSED` mới chuyển sang kiểm thử thuật toán thống kê.

## 14. Lệnh PowerShell cụ thể

Thiết lập môi trường:

```powershell
$env:PGHOST = "localhost"
$env:PGPORT = "5432"
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<mat_khau_postgres>"
```

Kiểm tra database trống theo unified schema:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Kiểm tra seed:

```powershell
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_empty_test
```

Precheck thống kê:

```powershell
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_empty_test
```

## 15. Kết quả chạy thực tế

Đã chạy trên môi trường hiện tại có PostgreSQL/psql:

- `run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly`: `PASSED`.
- `run_seed_validation_check.ps1 -DatabaseName qlta_empty_test`: `PASSED`.
- `run_statistics_precheck.ps1 -DatabaseName qlta_empty_test`: `PASSED`.

File kết quả:

- `tests/database/EMPTY_POSTGRES_CHECK_RESULT.md`
- `tests/database/DATABASE_SEED_CHECK_RESULT.md`
- `tests/database/STATISTICS_PRECHECK_RESULT.md`

## 16. Kết luận

Đã sẵn sàng cho bước seed dữ liệu danh mục tiếp theo và precheck thống kê ở mức kỹ thuật.

Chưa nên seed dữ liệu vụ án thật hoặc kiểm thử thuật toán thống kê chi tiết cho đến khi các dữ liệu có `requires_human_review` được người có thẩm quyền rà soát và xác nhận.
