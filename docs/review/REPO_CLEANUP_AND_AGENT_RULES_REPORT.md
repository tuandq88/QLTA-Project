# Báo cáo cleanup repo và cập nhật AI Agent rules

Ngày thực hiện: 11/06/2026

## 1. Mục tiêu cleanup

Rà soát cấu trúc QLTA-Project sau các vòng chuẩn hóa schema, seed, migration, skill thống kê và test database; dọn file tạm an toàn; cập nhật README, AI Agent rules, naming convention và skill nền tảng cho database/backend/frontend.

## 2. Những việc đã kiểm tra

- Rà soát cấu trúc thư mục: `database/schema`, `database/migrations`, `database/seed`, `database/seed/test`, `tests/database`, `tests/sql_checks`, `docs/review`, `knowledge_base/skills`, `backend`, `frontend`, `tools`.
- Tìm tham chiếu bằng `rg` cho migration/test/skill mới: `006`, `007`, `008`, seed `040`, seed `050`, wrapper criminal lifecycle/appellate/hearing members.
- Đối chiếu `README.md`, `database/seed/README.md`, `tests/README.md`, migration review và skill hình sự tổng.
- Kiểm tra file tạm Excel `tests/~$criminal_first_instance_cases_2026_06_01_to_2026_06_10.xlsx`.

## 3. File đã xóa

| File | Lý do |
|---|---|
| `tests/~$criminal_first_instance_cases_2026_06_01_to_2026_06_10.xlsx` | Lock file Excel tạm, 165 byte, không được tham chiếu trong repo. File report thật `tests/criminal_first_instance_cases_2026_06_01_to_2026_06_10.xlsx` được giữ. |

## 4. File đã archive

Không archive file trong lượt này.

Lý do: các migration, seed test, wrapper test và report hiện còn được README, skill hoặc wrapper tham chiếu. Các file chưa chắc chắn không bị di chuyển để tránh phá workflow đang pass.

## 5. File đã cập nhật

- `README.md`: viết lại theo cấu trúc project overview, repo structure, database architecture, seed workflow, test workflow, AI Agent rules, naming convention, active skills, development workflow, cleanup policy, checklist và plans.
- `docs/AI_AGENT_RULES.md`: tạo mới rule workflow tổng cho AI Agent.
- `docs/README.md`: cập nhật vị trí AI Agent rules và cấu trúc docs thực tế.
- `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md`: bổ sung quy tắc naming English, dữ liệu tiếng Việt UTF-8 và cập nhật skill sau task.
- `knowledge_base/skills/system/database_design_rules.md`: tạo skill nền tảng database.
- `knowledge_base/skills/system/backend_api_design_rules.md`: tạo skill nền tảng backend/API.
- `knowledge_base/skills/system/frontend_design_rules.md`: tạo skill nền tảng frontend.
- `knowledge_base/skills/statistics/skill_thong_ke_hinh_su.md`: bổ sung trỏ sang skill hình sự phúc thẩm theo từng bị cáo.
- `database/schema/MIGRATION_COMPATIBILITY_REVIEW.md`: cập nhật trạng thái migration `006`, `007`, `008`.
- Các report test database được cập nhật khi chạy test.

## 6. File giữ lại và lý do

| File/nhóm file | Trạng thái | Lý do giữ |
|---|---|---|
| `database/migrations/006_trial_level_and_hearing_members.sql` | Active upgrade, merged unified | Vẫn cần cho database đã tồn tại và wrapper hearing members. |
| `database/migrations/007_case_occurrences_and_resolution_events.sql` | Active upgrade, merged unified | Được `run_criminal_return_lifecycle_skill_check.ps1` gọi trực tiếp. |
| `database/migrations/008_criminal_appellate_defendant_results.sql` | Active upgrade, merged unified | Được `run_criminal_appellate_defendant_result_skill_check.ps1` gọi trực tiếp. |
| `database/migrations/001_core_database_schema.sql` | Core baseline riêng | Dùng cho core schema độc lập, không đủ unified database. |
| `database/migrations/002` đến `005` | Merged/pending baseline review | Có giá trị lịch sử/nâng cấp; không xóa migration production history. |
| `database/migrations/random_assignment_schema_extension.sql` | Legacy | Nội dung đã có trong unified schema nhưng giữ để tham chiếu lịch sử. |
| `database/migrations/appeal_protest_tracking_schema_extension.sql` | Legacy | Nội dung đã có trong unified schema nhưng giữ để tham chiếu lịch sử. |
| `database/seed/test/040_test_criminal_first_instance_return_lifecycle.sql` | Test-only active | Dùng cho lifecycle test. |
| `database/seed/test/050_test_criminal_appellate_defendant_results.sql` | Test-only active | Dùng cho appellate defendant-level test. |
| `tests/database/*RESULT.md` | Test reports | Là bằng chứng chạy test, giữ lại. |
| `docs/review/*.md`, `docs/review/*.csv/json` | Review/audit trail | Chưa đủ căn cứ để archive; nhiều file là lịch sử thiết kế. |
| `Documents/`, `bieu_mau/`, `knowledge_base/data/statistics/` | Source data | File nguồn nghiệp vụ/pháp lý/thống kê, không cleanup. |

## 7. Migration status

| Migration | Status | Ghi chú |
|---|---|---|
| `001_core_database_schema.sql` | active core baseline | Không dùng làm unified baseline. |
| `002_database_constraints_and_indexes.sql` | merged/pending review | Phù hợp sau unified schema, chưa là migration chain độc lập. |
| `003_reference_data_and_foreign_keys.sql` | merged | Nội dung ổn định đã có trong unified schema. |
| `004_statistical_reference_data.sql` | merged | Nội dung ổn định đã có trong unified schema. |
| `005_legal_seed_data_normalization.sql` | merged | Nội dung ổn định đã có trong unified schema. |
| `006_trial_level_and_hearing_members.sql` | active upgrade, merged | Giữ cho nâng cấp DB đã tồn tại. |
| `007_case_occurrences_and_resolution_events.sql` | active upgrade, merged | Giữ cho test/upgrade occurrence lifecycle. |
| `008_criminal_appellate_defendant_results.sql` | active upgrade, merged | Giữ cho test/upgrade phúc thẩm theo bị cáo. |
| `random_assignment_schema_extension.sql` | legacy | Không chạy mặc định. |
| `appeal_protest_tracking_schema_extension.sql` | legacy | Không chạy mặc định. |

## 8. Skill status

| Skill | Status | Ghi chú |
|---|---|---|
| `skill_thong_ke_hinh_su.md` | active | Skill tổng; đã trỏ sang skill chi tiết sơ thẩm lifecycle và phúc thẩm theo bị cáo. |
| `skill_criminal_first_instance_return_to_procuracy_list.md` | active | Skill chuyên sâu occurrence/event. |
| `skill_criminal_appellate_defendant_result_rules.md` | active | Skill chuyên sâu defendant-level. |
| `skill_trial_level_classification.md` | active | Quy tắc cấp xét xử. |
| `skill_hearing_members.md` | active | Thành phần phiên tòa. |
| `database_design_rules.md` | active | Skill nền tảng mới. |
| `backend_api_design_rules.md` | active | Skill nền tảng mới. |
| `frontend_design_rules.md` | active | Skill nền tảng mới. |

Không phát hiện skill trùng lặp cần xóa ngay. Các skill tổng và skill chuyên sâu được phân vai bằng liên kết rõ ràng.

## 9. README updates

README đã cập nhật các mục:

- Project overview.
- Repository structure.
- Database architecture.
- Seed data workflow.
- Test workflow.
- AI Agent rules.
- Naming convention.
- Current active skills.
- Development workflow.
- Cleanup/archive policy.
- Current completed checklist.
- Approved plans.
- Suggested next plans.

## 10. AI Agent rules added

- Technical object names phải dùng tiếng Anh.
- Dữ liệu nghiệp vụ/label hiển thị dùng tiếng Việt UTF-8.
- Không dùng tiếng Việt có dấu trong table/column/constraint/index/function/API route.
- Sau mỗi task phải kiểm tra có cần cập nhật/tạo skill không.
- Sau mỗi database design task phải cân nhắc backend/API, frontend, validation, seed/test và statistics follow-up.
- Cleanup phải kiểm tra tham chiếu trước khi xóa; nếu chưa chắc thì giữ và báo cáo.

## 11. Tests đã chạy

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_criminal_return_lifecycle_skill_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_criminal_appellate_defendant_result_skill_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_trial_level_and_hearing_members_check.ps1 -DatabaseName qlta_schema_merge_test
```

## 12. Kết quả test

Kết quả sau cleanup:

- `EMPTY_POSTGRES_CHECK_RESULT.md`: `PASSED`.
- `DATABASE_SEED_CHECK_RESULT.md`: `PASSED`.
- `STATISTICS_PRECHECK_RESULT.md`: `PASSED`.
- `CRIMINAL_RETURN_LIFECYCLE_TEST_RESULT.md`: `PASSED`.
- `CRIMINAL_APPELLATE_DEFENDANT_RESULT_SKILL_RESULT.md`: `PASSED`.
- `TRIAL_LEVEL_AND_HEARING_MEMBERS_CHECK_RESULT.md`: `PASSED`.

## 13. Checklist hoàn thành

- [x] Rà soát schema.
- [x] Rà soát migration.
- [x] Rà soát seed.
- [x] Rà soát tests.
- [x] Rà soát skills.
- [x] Dọn file không còn dùng.
- [x] Archive file chưa chắc chắn: không thực hiện, ghi rõ lý do giữ.
- [x] Cập nhật README.
- [x] Cập nhật AI Agent rules.
- [x] Cập nhật naming convention.
- [x] Cập nhật/tạo skill database.
- [x] Cập nhật/tạo skill backend/API.
- [x] Cập nhật/tạo skill frontend.
- [x] Chạy test database sau cleanup.
- [x] Viết báo cáo cleanup.

## 14. Plans đã được phê duyệt

- [x] Chuẩn hóa schema thống kê theo occurrence/event cho hình sự sơ thẩm trả hồ sơ.
- [x] Chuẩn hóa hình sự phúc thẩm theo từng bị cáo.
- [x] Chuẩn hóa quy tắc thẩm phán chủ tọa/hội đồng/thư ký phiên tòa.
- [x] Chuẩn hóa case_group/case_group_id cho sơ thẩm/phúc thẩm.
- [x] Chuẩn hóa quy tắc đặt tên English cho technical objects.
- [x] Cập nhật skill sau mỗi task có logic tái sử dụng.

## 15. Gợi ý plans tiếp theo

- [ ] Sinh API contract từ schema hiện tại.
- [ ] Thiết kế backend modules theo bounded context.
- [ ] Thiết kế frontend nhập liệu hồ sơ vụ án.
- [ ] Thiết kế frontend list/report thống kê.
- [ ] Thiết kế validation engine cho biểu mẫu thống kê.
- [ ] Tạo seed/test data theo từng skill thống kê.
- [ ] Tạo dashboard KPI dựa trên Formula Catalog.
- [ ] Kiểm tra chéo giữa biểu mẫu thống kê theo Quyết định 287/QĐ-TANDTC.
