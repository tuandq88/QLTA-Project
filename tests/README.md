# Tests

Thư mục dành cho test nghiệp vụ và kỹ thuật.

Nên có các nhóm test:

- test schema database;
- test công thức thống kê;
- test validation rule;
- test phân công án ngẫu nhiên;
- test theo dõi kháng cáo, kháng nghị;
- test API và UI khi có backend/frontend.

## Báo cáo Excel đã có

### Hình sự sơ thẩm từ 01/06/2026 đến 10/06/2026

Script:

- `tests/generate_criminal_first_instance_cases_report_2026_06_01_to_2026_06_10.py`
- `tests/run_criminal_first_instance_cases_report.ps1`

File đầu ra:

- `tests/criminal_first_instance_cases_2026_06_01_to_2026_06_10.xlsx`

Lệnh chạy lại:

```powershell
.\tests\run_criminal_first_instance_cases_report.ps1 -DatabaseName qlta_schema_merge_test -FromDate 2026-06-01 -ToDate 2026-06-10
```

Logic lọc dùng `case_files.case_type/case_type_id` cho loại án hình sự, `case_files.case_group/case_group_id` cho cấp sơ thẩm, `acceptance_date` cho ngày thụ lý và `closed_date` cho ngày giải quyết. Không dùng `current_stage` để lọc cấp xét xử.

### Test skill danh sách trả hồ sơ cho Viện kiểm sát

Skill:

- `knowledge_base/skills/statistics/skill_criminal_first_instance_return_to_procuracy_list.md`

Lệnh kiểm tra logic occurrence/event:

```powershell
.\tests\database\run_criminal_return_to_procuracy_occurrence_logic_check.ps1 -DatabaseName qlta_schema_merge_test
```

Test dùng dữ liệu mẫu vụ án A để bảo vệ quy tắc: trả hồ sơ cho Viện kiểm sát để điều tra bổ sung là một lần giải quyết, và thụ lý lại sau điều tra bổ sung là một lần thụ lý mới. Đơn vị đếm là `OCCURRENCE`, không phải distinct `case_id`.

### Test lifecycle nhiều kỳ cho án trả hồ sơ VKS

Seed/test:

- `database/seed/test/040_test_criminal_first_instance_return_lifecycle.sql`
- `tests/database/test_criminal_first_instance_return_lifecycle_skill.sql`
- `tests/database/run_criminal_return_lifecycle_skill_check.ps1`

Lệnh chạy:

```powershell
.\tests\database\run_criminal_return_lifecycle_skill_check.ps1 -DatabaseName qlta_schema_merge_test
```

Test tạo 4 hồ sơ `HSST-RETURN-001` đến `HSST-RETURN-004`, kiểm tra các kỳ A-E và ghi báo cáo tại `tests/database/CRIMINAL_RETURN_LIFECYCLE_TEST_RESULT.md`. Logic bắt buộc: mỗi lần thụ lý là một `case_occurrences`, mỗi lần trả hồ sơ/xét xử là một `case_resolution_events`, không group mất dữ liệu theo `case_id`.

### Test án hình sự phúc thẩm theo từng bị cáo

Skill:

- `knowledge_base/skills/statistics/skill_criminal_appellate_defendant_result_rules.md`

Seed/test:

- `database/seed/test/050_test_criminal_appellate_defendant_results.sql`
- `tests/database/test_criminal_appellate_defendant_result_skill.sql`
- `tests/database/run_criminal_appellate_defendant_result_skill_check.ps1`

Lệnh chạy:

```powershell
.\tests\database\run_criminal_appellate_defendant_result_skill_check.ps1 -DatabaseName qlta_schema_merge_test
```

Test tạo 5 vụ `HSPT-001` đến `HSPT-005`, kiểm tra expected vs actual cho các kỳ A-D và ghi báo cáo tại `tests/database/CRIMINAL_APPELLATE_DEFENDANT_RESULT_SKILL_RESULT.md`. Logic bắt buộc: kết quả phúc thẩm ghi theo từng `defendant_id`; vụ án chỉ được tính đã giải quyết khi toàn bộ bị cáo có final result đến ngày chốt.

### Test tòa án sơ thẩm của án phúc thẩm

Migration/seed/test:

- `database/migrations/009_appellate_first_instance_court.sql`
- `database/seed/011_courts_quang_ngai.sql`
- `database/seed/test/060_test_appellate_first_instance_courts.sql`
- `tests/database/appellate_first_instance_court_integrity_test.sql`
- `tests/database/run_appellate_first_instance_court_check.ps1`

Lệnh chạy:

```powershell
.\tests\database\run_appellate_first_instance_court_check.ps1 -DatabaseName qlta_schema_merge_test
```

Test bảo vệ quy tắc: án `PHUC_THAM` dùng `case_files.court_id` cho tòa phúc thẩm/current court và dùng `case_files.first_instance_court_id` cho tòa đã xét xử sơ thẩm; query danh sách phúc thẩm không được fallback im lặng thành TAND tỉnh khi thiếu tòa sơ thẩm.

### Test import Excel tòa án sơ thẩm của án phúc thẩm

Test/wrapper:

- `tests/database/appellate_first_instance_court_excel_import_test.sql`
- `tests/database/run_appellate_first_instance_court_excel_import_check.ps1`

Lệnh chạy:

```powershell
.\tests\database\run_appellate_first_instance_court_excel_import_check.ps1 -DatabaseName qlta_schema_merge_test
```

Test bảo vệ đường đi dữ liệu từ cột Excel `Tòa án xét xử sơ thẩm` trong hai file phúc thẩm đến `case_files.first_instance_court_id`, kiểm tra join được `courts`, có nhiều nhóm tòa sơ thẩm, có cả tòa `regional` và `district`, và không bị gán nhầm thành tòa phúc thẩm/current court.

### Test import Excel kết quả XXPT của án phúc thẩm

Test/wrapper:

- `tests/database/appellate_xxpt_result_excel_import_test.sql`
- `tests/database/run_appellate_xxpt_result_excel_import_check.ps1`

Lệnh chạy:

```powershell
.\tests\database\run_appellate_xxpt_result_excel_import_check.ps1 -DatabaseName qlta_schema_merge_test
```

Test bảo vệ đường đi dữ liệu từ cột Excel `Kết quả XXPT` đến `decisions.result_summary`, `decisions.result_code`, `case_files.closed_date` khi có ngày hợp lệ, và bảo đảm query list không hiển thị `Chưa giải quyết` cho dòng đã import kết quả XXPT.
