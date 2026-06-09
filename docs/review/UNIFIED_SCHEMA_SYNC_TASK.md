# UNIFIED SCHEMA SYNC TASK

## Mục tiêu

Đồng bộ `database/schema/unified_postgresql_schema.sql` để mode `UnifiedOnly` của `tests/database/run_empty_postgres_check.ps1` có thể chạy từ database trống, sau đó chạy được `database/seed/*.sql` mà không cần chạy `database/migrations/*.sql`.

## Bảng seed đang dùng

`database/seed/003_reference_data_seed.sql` insert vào:

- `dm_categories`
- `dm_category_items`
- `dm_table_reference_columns`

`database/seed/004_statistical_reference_data_seed.sql` insert vào:

- `statistical_categories`
- `statistical_indicators`
- `statistical_indicator_options`
- `dm_defendant_statistical_features`
- `dm_statistical_option_groups`
- `dm_statistical_options`
- `dm_legal_relationships`
- `dm_trial_result_types`
- `dm_appellate_result_codes`
- `dm_fault_classifications`
- `dm_fault_reason_groups`
- `dm_appeal_protest_types`
- `dm_statistical_forms`
- `dm_statistical_metrics`
- `dm_statistical_form_items`

## Bảng thiếu trong unified schema

Trước task này, `unified_postgresql_schema.sql` chưa có:

- `dm_categories`
- `dm_category_items`
- `dm_table_reference_columns`
- toàn bộ nhóm `statistical_*`
- các bảng danh mục chuyên biệt `dm_penal_code_articles`, `dm_crimes`, `dm_defendant_statistical_features`, `dm_legal_relationships`, `dm_trial_result_types`, `dm_appellate_result_codes`, `dm_fault_classifications`, `dm_fault_reason_groups`, `dm_appeal_protest_types`, `dm_statistical_forms`, `dm_statistical_metrics`, `dm_statistical_form_items`
- các bảng liên kết thống kê: `entity_statistical_attributes`, `defendant_statistical_features`, `defendant_statistical_option_values`, `case_legal_relationships`, `decision_result_attributes`

## Migration nguồn

- `database/migrations/003_reference_data_and_foreign_keys.sql`: định nghĩa `dm_categories`, `dm_category_items`, `dm_table_reference_columns`, các cột `*_id` nullable và một phần FK về `dm_category_items`.
- `database/migrations/004_statistical_reference_data.sql`: định nghĩa lớp danh mục thống kê tổng quát, bảng danh mục chuyên biệt và FK thống kê.
- `database/migrations/002_database_constraints_and_indexes.sql`: có một số constraint/index ổn định mà test SQL hiện kiểm tra trong UnifiedOnly.

## Nội dung đã gộp vào unified schema

Đã bổ sung vào `database/schema/unified_postgresql_schema.sql`:

- Bảng reference data cho seed 003:
  - `dm_categories`
  - `dm_category_items`
  - `dm_table_reference_columns`
- Bảng thống kê/danh mục cho seed 004:
  - `statistical_categories`
  - `statistical_indicators`
  - `statistical_indicator_options`
  - `statistical_indicator_applicability`
  - `entity_statistical_attributes`
  - các bảng `dm_*` chuyên biệt về tội danh, đặc điểm bị cáo, quan hệ pháp luật, kết quả xét xử, kết quả cấp trên, lỗi, loại kháng cáo/kháng nghị, biểu mẫu và metric thống kê
- Các bảng liên kết n-n:
  - `defendant_statistical_features`
  - `defendant_statistical_option_values`
  - `case_legal_relationships`
  - `decision_result_attributes`
- Cột FK nullable cần cho danh mục:
  - tiêu biểu: `case_files.case_group_id`, `participants.participant_type_id`, `documents.document_type_id`, `decisions.trial_result_type_id`, `charges.crime_id`, `charges.article_id`, `statistics_snapshots.metric_id`, `statistics_snapshots.form_item_id`
- Constraint/FK/index tối thiểu:
  - FK về `dm_category_items`
  - FK `charges -> dm_crimes/dm_penal_code_articles`
  - FK `decisions -> dm_trial_result_types`
  - FK `statistics_snapshots -> dm_statistical_metrics/dm_statistical_form_items`
  - unique/index phục vụ seed và test duplicate/integrity
  - trigger `trg_defendant_statistical_option_group` để chặn radio group chọn nhiều giá trị

## Nội dung không gộp và lý do

- Không gộp toàn bộ migration chain theo kiểu chạy lại trong `UnifiedOnly`; script đã tách mode để tránh chạy trùng.
- Không gộp lại hai migration module cũ `random_assignment_schema_extension.sql` và `appeal_protest_tracking_schema_extension.sql` như file độc lập vì các cấu trúc chính đã có trong unified schema, còn các file này không idempotent.
- Không seed danh mục tội danh đầy đủ, quan hệ pháp luật chi tiết hoặc chỉ tiêu biểu mẫu chính thức vì cần nguồn/human legal review.

## Kết quả chạy trong Codex

Môi trường Codex hiện không có `psql` trong `PATH`, nên chưa chạy được PostgreSQL thực tế sau khi sửa. Result hiện tại:

```text
NOT_RUN_ENVIRONMENT_LIMITATION
```

Chi tiết tại:

```text
tests/database/EMPTY_POSTGRES_CHECK_RESULT.md
```

Trước khi sửa, result local cho thấy:

```text
ERROR: relation "dm_categories" does not exist
```

Lỗi này được xử lý bằng cách bổ sung `dm_categories` và các bảng danh mục liên quan vào unified schema.

## Cách chạy lại

```powershell
cd D:\QLTA-Project
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<password>"
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Mode `UnifiedOnly` không chạy `database/migrations/*.sql`; vì vậy sẽ không chạy `database/migrations/001_core_database_schema.sql`.

## Rủi ro còn lại

- Chưa xác thực được bằng PostgreSQL trong môi trường Codex do thiếu `psql`.
- Unified schema đã được bổ sung cấu trúc từ migration 002-004, nhưng migration chain và unified schema vẫn cần được xem là hai đường kiểm tra riêng.
- Một số danh mục seed là placeholder/review-required, chưa phải danh mục pháp lý chính thức.
- Cần tiếp tục chuẩn hóa source of truth để tránh sửa migration mà quên cập nhật unified schema.

## Đề xuất source of truth

- `database/schema/unified_postgresql_schema.sql` nên là source of truth để khởi tạo database mới trong mode `UnifiedOnly`.
- `database/migrations/*.sql` nên là lịch sử thay đổi additive và kiểm tra riêng bằng `-Mode MigrationsOnly`.
- Khi migration mới ổn định và cần seed/test trong UnifiedOnly, phải cập nhật lại unified schema và report liên quan.
