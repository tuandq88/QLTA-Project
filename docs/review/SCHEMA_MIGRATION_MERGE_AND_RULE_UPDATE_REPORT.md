# Báo cáo đồng bộ schema, migration và cập nhật quy tắc AI

Ngày hoàn thành: 09/06/2026

## 1. Mục tiêu

Rà soát toàn bộ schema và migrations hiện có, đồng bộ các migration ổn định vào `database/schema/unified_postgresql_schema.sql`, cập nhật quy tắc AI về kết nối `psql` bằng `.env.local`, chuẩn tiếng Việt UTF-8 và font Tahoma khi xuất tài liệu. Đồng thời tạo tài liệu mô tả bảng dữ liệu và các quan hệ liên kết chính.

## 2. File đã đọc/rà soát

- `README.md`
- `AGENTS.md`
- `.gitignore`
- `.env.local` theo nguyên tắc chỉ đọc tên biến, không ghi secret
- `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md`
- `knowledge_base/skills/`
- `knowledge_base/data/statistics/`
- `database/schema/`
- `database/schema/unified_postgresql_schema.sql`
- `database/migrations/`
- `database/seed/`
- `database/diagrams/`
- `tests/database/`
- `docs/review/`

## 3. File đã cập nhật

- `database/schema/unified_postgresql_schema.sql`
- `database/schema/SCHEMA_SOURCE_OF_TRUTH.md`
- `AGENTS.md`
- `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md`
- `tests/database/run_empty_postgres_check.ps1`
- `tests/database/run_seed_validation_check.ps1`
- `tests/database/run_statistics_precheck.ps1`
- `tests/database/database_structure_integrity_test.sql`

## 4. File đã tạo

- `database/schema/MIGRATION_COMPATIBILITY_REVIEW.md`
- `database/schema/DATABASE_TABLES_DATA_DICTIONARY_VI.md`
- `database/migrations/_legacy/README.md`
- `database/migrations/_pending_review/README.md`
- `docs/review/ENCODING_UTF8_TAHOMA_GUIDELINES.md`
- `docs/review/SCHEMA_MIGRATION_MERGE_AND_RULE_UPDATE_REPORT.md`
- `tests/database/SCHEMA_MERGE_CHECK_RESULT.md`

## 5. Nội dung đã gộp vào unified schema

Đã gộp các phần additive, ổn định và idempotent từ migrations:

- FK catalog cho `appellate_trackings` và `appellate_fault_assessments`.
- Check constraint bổ sung cho KPI target, admin enforcement, assignment judge order/count, judge workload count, appellate tracking resolved status.
- Unique index cho các business key quan trọng của user, judge profile, participant, document, hearing, decision, appeal, deadline, civil/criminal/admin detail, assignment và appellate tracking.
- Read-path index cho dashboard, phân công án, appellate tracking, KPI, AI suggestion, risk flag và legal seed catalog.
- Index hỗ trợ `dm_crimes` và `dm_legal_relationships` từ migration 005.

Không gộp raw hai migration legacy vì có bảng trùng và không idempotent:

- `random_assignment_schema_extension.sql`
- `appeal_protest_tracking_schema_extension.sql`

## 6. Trạng thái migrations

Kết luận chi tiết nằm trong `database/schema/MIGRATION_COMPATIBILITY_REVIEW.md`.

Tóm tắt:

- `001_core_database_schema.sql`: core baseline, không đủ database mới hoàn chỉnh.
- `002_database_constraints_and_indexes.sql`: tương thích sau unified schema, không tương thích nếu chạy ngay sau `001_core`.
- `003_reference_data_and_foreign_keys.sql`: đã đồng bộ.
- `004_statistical_reference_data.sql`: đã đồng bộ.
- `005_legal_seed_data_normalization.sql`: đã đồng bộ.
- Hai migration extension legacy: chỉ giữ để tham khảo lịch sử, không chạy mặc định.

## 7. Cập nhật quy tắc AI

Đã cập nhật:

- AI Agent phải dùng `.env.local` hoặc environment variables để kết nối `psql`.
- Không hard-code hoặc ghi mật khẩu/secret vào log, báo cáo, README.
- Báo cáo, mô tả hoàn thành, README, checklist và tài liệu database phải viết bằng tiếng Việt UTF-8.
- Nếu xuất tài liệu có font, dùng Tahoma.
- Không chạy unified schema và migrations trong cùng một mode kiểm tra.
- Unified schema là source of truth cho database mới.

## 8. Kết quả kiểm tra

Đã chạy với PostgreSQL local và `psql`, script tự đọc `.env.local` sau khi xóa `PG*` khỏi process environment.

Kết quả:

- `UnifiedOnly`: `PASSED`.
- `run_seed_validation_check.ps1`: `PASSED`.
- `run_statistics_precheck.ps1`: `PASSED`.
- `MigrationsOnly`: `FAILED` có kiểm soát do migration chain chưa phải baseline đầy đủ; lỗi tại `002_database_constraints_and_indexes.sql` khi bảng `appeals` chưa tồn tại sau `001_core`.

File kết quả:

- `tests/database/EMPTY_POSTGRES_CHECK_RESULT.md`
- `tests/database/DATABASE_SEED_CHECK_RESULT.md`
- `tests/database/STATISTICS_PRECHECK_RESULT.md`
- `tests/database/SCHEMA_MERGE_CHECK_RESULT.md`

## 9. Lệnh chạy lại

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test
```

Script sẽ tự đọc `.env.local` nếu các biến `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD` chưa có trong environment.

## 10. Rủi ro còn lại

- `MigrationsOnly` chưa dùng được làm đường tạo database mới hoàn chỉnh.
- Một số seed vẫn có `requires_human_review`, không dùng để kết luận pháp lý cuối cùng nếu chưa được rà soát.
- PowerShell console hiện tại có thể hiển thị mojibake dù file được ghi UTF-8; khi cần kiểm tra nội dung tiếng Việt nên mở bằng editor hỗ trợ UTF-8.

## 11. Kết luận

Unified schema đã được đồng bộ thêm các migration ổn định và đã PASS kiểm tra tạo database mới, chạy seed và precheck thống kê.

Có thể tiếp tục dùng `database/schema/unified_postgresql_schema.sql` làm source of truth cho database mới. Chưa nên dùng `MigrationsOnly` làm baseline khởi tạo mới cho đến khi thiết kế lại chuỗi migration đầy đủ.
