# APPELLATE_FIRST_INSTANCE_COURT_SCHEMA_SEED_RESULT

## 1. Vấn đề phát hiện

SQL list án phúc thẩm trước đây phải fallback `case_files.court_id` để hiển thị "Tòa án xét xử sơ thẩm". Với án phúc thẩm, `case_files.court_id` là tòa án đang quản lý/xét xử phúc thẩm, nên fallback này làm dữ liệu bị gom chung về TAND tỉnh Quảng Ngãi hoặc court seed chung, không phản ánh tòa sơ thẩm thật.

## 2. Schema trước khi sửa

- `case_files.court_id`: liên kết `courts`, dùng cho tòa án quản lý hồ sơ hiện tại.
- Chưa có cột riêng trên `case_files` để lưu tòa án đã xét xử sơ thẩm của án phúc thẩm.
- `appellate_trackings.original_court_id` có thể lưu tòa gốc trong module tracking, nhưng không gắn trực tiếp với mọi hồ sơ phúc thẩm seed từ Excel.

## 3. Schema sau khi sửa

Đã bổ sung vào `case_files`:

- `first_instance_court_id UUID REFERENCES courts(court_id)`
- `first_instance_case_number VARCHAR(100)`
- `first_instance_judgment_number VARCHAR(100)`
- `first_instance_judgment_date DATE`

Ý nghĩa:

- `court_id`: tòa án hiện đang quản lý/xét xử hồ sơ; với phúc thẩm là tòa phúc thẩm/current court.
- `first_instance_court_id`: tòa án đã xét xử sơ thẩm, có bản án/quyết định bị kháng cáo/kháng nghị.

## 4. Lý do cần trường riêng

Không thể dùng `case_files.court_id` cho cả tòa phúc thẩm và tòa sơ thẩm vì hai ý nghĩa này khác nhau. Danh sách án phúc thẩm theo tòa sơ thẩm phải dùng `first_instance_court_id`; nếu thiếu thì phải cảnh báo dữ liệu thiếu, không fallback im lặng thành TAND tỉnh.

## 5. Migration

- `database/migrations/009_appellate_first_instance_court.sql`

Migration additive/idempotent:

- thêm 4 cột trên `case_files`;
- thêm FK `fk_case_files_first_instance_court`;
- thêm index `idx_case_files_first_instance_court_id`;
- thêm index phục vụ truy vấn phúc thẩm theo tòa sơ thẩm.

## 6. Seed courts

- `database/seed/011_courts_quang_ngai.sql`

Seed bổ sung:

- `TAND_QUANG_NGAI_PROVINCE`
- `TAND_KHU_VUC_01_QUANG_NGAI`
- `TAND_KHU_VUC_02_QUANG_NGAI`
- `TAND_KHU_VUC_03_QUANG_NGAI`

Ghi chú: các tòa khu vực là placeholder có kiểm soát để test grouping; cần xác minh bằng nguồn chính thức trước khi dùng production.

## 7. Seed test án phúc thẩm

- `database/seed/test/060_test_appellate_first_instance_courts.sql`

Seed tạo 3 vụ:

- `HSPT-FIRSTCOURT-001` -> `TAND khu vực 01 - Quảng Ngãi`
- `DSPT-FIRSTCOURT-001` -> `TAND khu vực 02 - Quảng Ngãi`
- `HCPT-FIRSTCOURT-001` -> `TAND khu vực 03 - Quảng Ngãi`

## 8. Skill đã cập nhật/tạo

- `knowledge_base/skills/system/database_design_rules.md`
- `knowledge_base/skills/core/skill_trial_level_classification.md`
- `knowledge_base/skills/statistics/skill_appellate_case_list_by_period.md`

Quy tắc chính: án phúc thẩm phải phân biệt `court_id` và `first_instance_court_id`; list theo tòa sơ thẩm không được fallback im lặng sang current court.

## 9. SQL list án phúc thẩm

- `tests/sql_checks/list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql`
- `tests/sql_checks/LIST_APPELLATE_CASES_BY_FIRST_INSTANCE_COURT_AND_CASE_TYPE_2026_06_01_TO_2026_06_12_RESULT.md`

SQL hiện dùng `case_files.first_instance_court_id -> courts`. Nếu thiếu, output:

- `Tòa án xét xử sơ thẩm` = `Chưa xác định`
- `Cảnh báo dữ liệu` = `MISSING_FIRST_INSTANCE_COURT`

## 10. Test đã chạy

- `tests/database/run_appellate_first_instance_court_check.ps1 -DatabaseName qlta_schema_merge_test`: `PASSED`
- `tests/database/run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly`: `PASSED`
- `tests/database/run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test`: `PASSED`
- `tests/database/run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test`: `PASSED`
- SQL list án phúc thẩm: `PASSED`, trả `577` dòng sau khi chạy lại seed/test cuối cùng.

## 11. Kết quả test chính

SQL list phúc thẩm sau seed test:

- Tổng số dòng: `577`
- Nhóm tòa án sơ thẩm hiển thị: `4`
- Dòng thiếu `first_instance_court_id`: `574`
- Nhóm test hợp lệ:
  - `TAND khu vực 01 - Quảng Ngãi`: `1`
  - `TAND khu vực 02 - Quảng Ngãi`: `1`
  - `TAND khu vực 03 - Quảng Ngãi`: `1`

## 12. Dữ liệu còn thiếu/cần xác minh

- `574` dòng seed Excel cũ chưa có `first_instance_court_id`, đang được cảnh báo `MISSING_FIRST_INSTANCE_COURT`.
- Danh sách chính thức các TAND khu vực thuộc Quảng Ngãi cần nguồn xác minh; seed hiện chỉ là placeholder test có kiểm soát.
- Nếu Excel nguồn có cột "Tòa án xét xử sơ thẩm", cần chạy lại generator để map vào `first_instance_court_id`.

## 13. Lệnh chạy lại

```powershell
psql -d qlta_schema_merge_test -f .\database\migrations\009_appellate_first_instance_court.sql
psql -d qlta_schema_merge_test -f .\database\seed\011_courts_quang_ngai.sql
psql -d qlta_schema_merge_test -f .\database\seed\test\060_test_appellate_first_instance_courts.sql
psql -d qlta_schema_merge_test -f .\tests\database\appellate_first_instance_court_integrity_test.sql
psql -d qlta_schema_merge_test -f .\tests\sql_checks\list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql

.\tests\database\run_appellate_first_instance_court_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test
```
