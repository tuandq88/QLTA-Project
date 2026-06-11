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
