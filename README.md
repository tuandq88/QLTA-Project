# Hệ thống quản lý và điều hành TAND hai cấp tỉnh Quảng Ngãi

## 1. Project Overview

QLTA-Project là nền tảng tri thức, thiết kế dữ liệu, seed, test và rule nghiệp vụ để xây dựng ứng dụng miễn phí phục vụ lãnh đạo TAND hai cấp tỉnh Quảng Ngãi theo dõi thụ lý, giải quyết, tồn đọng, quá hạn, chất lượng xét xử, phân công án và báo cáo thống kê.

Repo hiện là bản thiết kế nghiệp vụ/kỹ thuật, chưa phải ứng dụng backend/frontend hoàn chỉnh. Backend và frontend sẽ được triển khai sau dựa trên schema, seed, skill và test đã chuẩn hóa trong repo.

## 2. Repository Structure

```text
knowledge_base/  Rule, skill, data dictionary, formula catalog, validation
database/        Schema, migration, seed, diagram, data dictionary database
backend/         Mã nguồn backend khi bắt đầu triển khai app
frontend/        Mã nguồn frontend khi bắt đầu triển khai app
tests/           Test nghiệp vụ, test database, wrapper PowerShell
docs/            Kế hoạch, review, rule AI Agent, báo cáo cleanup
Documents/       PDF nguồn pháp luật/biểu mẫu ban đầu
bieu_mau/        Biểu mẫu Excel gốc
tools/           Script hỗ trợ tạo/kiểm tra dữ liệu
postman/         Cấu hình API workspace khi triển khai
```

Không xóa dữ liệu nguồn trong `Documents/`, `bieu_mau/`, JSON mapping/formula/validation hoặc asset/diagram nếu chưa có bản chuẩn thay thế rõ ràng.

## 3. Database Architecture

Schema chính cho database mới:

```text
database/schema/unified_postgresql_schema.sql
```

`unified_postgresql_schema.sql` là source of truth cho database PostgreSQL mới. Không chạy unified schema và toàn bộ migrations lên cùng một database.

Các nhóm bảng chính:

- Master data: `courts`, `court_staff`, `users`, `judge_profiles`, `dm_categories`, `dm_category_items`.
- Case core: `case_files`, `case_occurrences`, `case_resolution_events`, `participants`, `documents`, `case_events`, `hearings`, `decisions`.
- Specialized modules: `criminal_case_details`, `defendants`, `criminal_appellate_defendant_results`, `civil_case_details`, `administrative_case_details`.
- Rule/AI layer: `deadlines`, `validation_results`, `assignment_*`, `appellate_*`, `ai_suggestions`, `case_risk_flags`, `audit_logs`.
- Analytics layer: `statistics_periods`, `statistics_snapshots`, `kpi_metrics`, `kpi_values`.

Migration status:

- Active upgrade migrations: `006_trial_level_and_hearing_members.sql`, `007_case_occurrences_and_resolution_events.sql`, `008_criminal_appellate_defendant_results.sql`.
- Merged/idempotent history: `002`, `003`, `004`, `005` đã được đồng bộ phần ổn định vào unified schema nhưng vẫn giữ để tham chiếu/nâng cấp theo baseline phù hợp.
- Core baseline riêng: `001_core_database_schema.sql` chỉ tạo core schema, không đại diện toàn bộ database.
- Legacy extension migrations: `random_assignment_schema_extension.sql`, `appeal_protest_tracking_schema_extension.sql`; không chạy mặc định vì đã được gộp vào unified schema và có nguy cơ trùng bảng.

## 4. Seed Data Workflow

Seed production/reference nằm trong `database/seed/*.sql`, chạy theo thứ tự số:

```text
003_reference_data_seed.sql
004_statistical_reference_data_seed.sql
010_legal_seed_data_tand_vietnam.sql
020_excel_seed_case_categories.sql
021_excel_seed_criminal_categories.sql
022_excel_seed_civil_categories.sql
023_excel_seed_administrative_categories.sql
024_excel_seed_labor_business_marriage_categories.sql
025_excel_seed_statistical_indicators.sql
030_excel_seed_case_files.sql
031_excel_seed_case_details.sql
032_excel_seed_case_parties.sql
033_excel_seed_case_events_and_resolutions.sql
034_excel_seed_hearing_members.sql
```

`database/seed/999_seed_all.sql` là ghi chú thứ tự, không dùng để chạy trùng seed.

Seed test-only:

- `database/seed/test/040_test_criminal_first_instance_return_lifecycle.sql`
- `database/seed/test/050_test_criminal_appellate_defendant_results.sql`

Seed phải idempotent, không chứa secret, không chứa dữ liệu cá nhân thật và không được đưa seed test vào luồng production.

## 5. Test Workflow

Sau thay đổi database, chạy tối thiểu:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test
```

Chạy thêm nếu các module liên quan tồn tại:

```powershell
.\tests\database\run_criminal_return_lifecycle_skill_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_criminal_appellate_defendant_result_skill_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_trial_level_and_hearing_members_check.ps1 -DatabaseName qlta_schema_merge_test
```

Các script database phải đọc cấu hình từ `.env.local` hoặc environment variables `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`, `DATABASE_URL`. Không hard-code mật khẩu.

## 6. AI Agent Rules

Rule tổng bắt buộc:

```text
knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md
docs/AI_AGENT_RULES.md
```

Nguyên tắc chính:

- Không bịa luật, biểu mẫu, chỉ tiêu, công thức hoặc căn cứ pháp lý.
- Không cho phép đếm trùng số liệu thống kê.
- AI chỉ được ghi đề xuất/cảnh báo/validation; không tự ghi đè dữ liệu chính.
- Khi thay đổi schema, phải cập nhật `database/`, README liên quan, data dictionary và test.
- Sau mỗi task, AI Agent phải kiểm tra có rule/logic/mapping/SQL/API/UI pattern nào cần ghi lại thành skill để tái sử dụng không.

## 7. Naming Convention

- Technical object names phải dùng tiếng Anh: table, column, enum, index, constraint, function, view, migration file, API route, DTO, service, repository, frontend component.
- Dữ liệu hiển thị cho người dùng, tên biểu mẫu, tên chỉ tiêu thống kê, tên tội danh, quan hệ pháp luật, mô tả nghiệp vụ được dùng tiếng Việt UTF-8.
- Code danh mục dùng ASCII/English hoặc tiếng Việt không dấu dạng code ổn định, ví dụ `HINH_SU`, `SO_THAM`, `PHUC_THAM`, `RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION`.
- Không dùng tiếng Việt có dấu trong tên bảng/cột/constraint/index/function/API route.
- SQL/script phải lưu UTF-8. PowerShell/psql nên ưu tiên code danh mục để tránh lỗi encoding runtime.

## 8. Current Active Skills

- Tổng quan thống kê: `knowledge_base/skills/statistics/skill_thong_ke_tat_ca_loai_an.md`
- Hình sự: `knowledge_base/skills/statistics/skill_thong_ke_hinh_su.md`
- Hình sự sơ thẩm trả hồ sơ VKS: `knowledge_base/skills/statistics/skill_criminal_first_instance_return_to_procuracy_list.md`
- Hình sự phúc thẩm theo từng bị cáo: `knowledge_base/skills/statistics/skill_criminal_appellate_defendant_result_rules.md`
- Cấp xét xử/thành phần phiên tòa: `knowledge_base/skills/core/skill_trial_level_classification.md`, `knowledge_base/skills/core/skill_hearing_members.md`
- Phân công án ngẫu nhiên: `knowledge_base/skills/random_assignment/SKILL_PHAN_CONG_AN_NGAU_NHIEN_V1.md`
- Theo dõi kháng cáo/kháng nghị: `knowledge_base/skills/appeal_protest_tracking/SKILL_THEO_DOI_AN_KHANG_CAO_KHANG_NGHI_V1.md`
- Backend/API nền tảng: `knowledge_base/skills/system/backend_api_design_rules.md`
- Frontend nền tảng: `knowledge_base/skills/system/frontend_design_rules.md`
- Database design nền tảng: `knowledge_base/skills/system/database_design_rules.md`

## 9. Development Workflow

1. Đọc `AGENTS.md`, README này và rule tổng AI Agent.
2. Nếu task liên quan nghiệp vụ, đọc skill tương ứng trong `knowledge_base/skills/`.
3. Nếu task liên quan database, đọc `database/schema/unified_postgresql_schema.sql`, `database/schema/DATABASE_TABLES_DATA_DICTIONARY_VI.md` và migration liên quan.
4. Nếu task liên quan pháp luật/biểu mẫu, đối chiếu `Documents/` hoặc `docs/legal/` nếu có.
5. Khi sửa schema, cập nhật migration, unified schema, data dictionary, seed/test và README liên quan.
6. Khi sửa logic tái sử dụng, cập nhật hoặc tạo skill.
7. Chạy test phù hợp và ghi báo cáo kết quả.

## 10. Cleanup/Archive Policy

- Trước khi xóa file, phải kiểm tra bằng `rg` xem file có được import/include/call/reference không.
- Không xóa migration chỉ vì đã merge vào unified schema; migration có thể vẫn cần cho nâng cấp database đã tồn tại.
- Nếu chưa chắc chắn, giữ nguyên và ghi trạng thái trong báo cáo cleanup; chỉ archive khi có convention rõ.
- File nguồn pháp luật, biểu mẫu Excel gốc, JSON thống kê, diagram và report kiểm chứng quan trọng phải giữ.
- File tạm rõ ràng như lock file Excel `~$...xlsx` có thể xóa nếu không được tham chiếu.

## 11. Current Completed Checklist

- [x] Chuẩn hóa unified PostgreSQL schema làm source of truth cho database mới.
- [x] Seed danh mục, seed Excel và seed pháp lý nền.
- [x] Test empty PostgreSQL, seed validation và statistics precheck.
- [x] Chuẩn hóa case_group/case_group_id cho sơ thẩm/phúc thẩm.
- [x] Chuẩn hóa thành phần phiên tòa.
- [x] Chuẩn hóa occurrence/event cho án hình sự sơ thẩm trả hồ sơ VKS.
- [x] Chuẩn hóa án hình sự phúc thẩm theo từng bị cáo.
- [x] Bổ sung quy tắc naming English cho technical objects.
- [x] Bổ sung rule AI Agent về cập nhật skill sau task.

## 12. Approved Plans

- [x] Chuẩn hóa schema thống kê theo occurrence/event cho hình sự sơ thẩm trả hồ sơ.
- [x] Chuẩn hóa hình sự phúc thẩm theo từng bị cáo.
- [x] Chuẩn hóa quy tắc Thẩm phán chủ tọa/Hội đồng/Thư ký phiên tòa.
- [x] Chuẩn hóa case_group/case_group_id cho sơ thẩm/phúc thẩm.
- [x] Chuẩn hóa quy tắc đặt tên English cho technical objects.
- [x] Cập nhật skill sau task có logic tái sử dụng.

## 13. Suggested Next Plans

- [ ] Sinh API contract từ schema hiện tại.
- [ ] Thiết kế backend modules theo bounded context.
- [ ] Thiết kế frontend nhập liệu hồ sơ vụ án.
- [ ] Thiết kế frontend list/report thống kê.
- [ ] Thiết kế validation engine cho biểu mẫu thống kê.
- [ ] Tạo seed/test data theo từng skill thống kê còn thiếu.
- [ ] Tạo dashboard KPI dựa trên Formula Catalog.
- [ ] Kiểm tra chéo biểu mẫu thống kê theo Quyết định 287/QĐ-TANDTC.

## 14. Task Format

```yaml
Task:
Objective:
Input:
Output:
Dependencies:
Validation:
Owner Agent:
Priority:
```
