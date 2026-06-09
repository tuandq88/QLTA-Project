# Rà soát tương thích migrations

Ngày rà soát: 09/06/2026

## Kết luận

`database/schema/unified_postgresql_schema.sql` tiếp tục là source of truth cho database mới.

Các phần migration ổn định, additive và an toàn đã được đồng bộ vào unified schema. Hai migration legacy tạo bảng trùng không được gộp lại theo dạng chạy trực tiếp vì không idempotent. Chuỗi `MigrationsOnly` hiện chưa được coi là đường khởi tạo database mới hoàn chỉnh.

## Kết quả theo file migration

| Migration | Trạng thái | Kết luận |
|---|---|---|
| `001_core_database_schema.sql` | Tương thích một phần | Tạo core schema độc lập nhưng không đủ toàn bộ bảng unified. Nội dung lõi đã có trong unified schema. |
| `002_database_constraints_and_indexes.sql` | Tương thích sau unified schema | Chứa constraint/index ổn định. Các phần additive còn thiếu đã được gộp vào unified schema. Không dùng riêng sau `001_core` vì migration này tham chiếu bảng chưa có trong `001_core`, ví dụ `appeals`. |
| `003_reference_data_and_foreign_keys.sql` | Tương thích | Bảng danh mục, cột tham chiếu và FK danh mục đã có trong unified schema. |
| `004_statistical_reference_data.sql` | Tương thích | Bảng thống kê, danh mục pháp lý hỗ trợ seed và FK liên quan đã có trong unified schema. Các FK catalog còn thiếu đã được đồng bộ. |
| `005_legal_seed_data_normalization.sql` | Tương thích | Kiểu cột TEXT, cột `requires_human_review`, source metadata và index hỗ trợ seed pháp lý đã có hoặc đã được đồng bộ vào unified schema. |
| `random_assignment_schema_extension.sql` | Legacy, không gộp trực tiếp | Tạo bảng trùng `judge_profiles`, `assignment_batches`, `assignment_batch_cases`, `assignment_batch_judges`, `judge_status_periods`, `judge_workload_snapshots`, `judge_case_conflicts`, `judge_replacement_history`, `assignment_audit_logs`; không dùng `IF NOT EXISTS`. Nội dung nghiệp vụ đã nằm trong unified schema. |
| `appeal_protest_tracking_schema_extension.sql` | Legacy, không gộp trực tiếp | Tạo bảng trùng nhóm appellate tracking; không dùng `IF NOT EXISTS`. Nội dung nghiệp vụ đã nằm trong unified schema. |

## Phần đã đồng bộ thêm vào unified schema

Đã bổ sung các phần ổn định từ migration 002/004/005:

- FK catalog cho `appellate_trackings` và `appellate_fault_assessments`.
- Check constraint: `chk_kpi_values_target_nonnegative`, `chk_admin_enforcement_compliance_after_due`, `chk_assignment_batch_judges_order_positive`, `chk_assignment_batch_judges_counts_nonnegative`, `chk_judge_workload_counts_nonnegative`, `chk_appellate_tracking_resolved_has_result`.
- Unique index cho email user, mã thẩm phán, participant identity, document/decision/hearing/appeal/deadline business keys, các bảng chi tiết dân sự/hình sự/hành chính, assignment, appellate result/fault/follow-up/status.
- Index phục vụ dashboard, phân công án, appellate tracking, KPI, AI suggestion, risk flag và seed legal catalog.

## Kết quả kiểm tra thực tế

- `UnifiedOnly` schema-only: `PASSED`.
- `UnifiedOnly` full schema + seed + SQL test: `PASSED`.
- `MigrationsOnly` với chuỗi migration đánh số hiện tại: `FAILED` tại `002_database_constraints_and_indexes.sql` vì bảng `appeals` chưa tồn tại sau `001_core_database_schema.sql`.

## Quyết định kiến trúc

- Database mới dùng `database/schema/unified_postgresql_schema.sql`.
- Migration đánh số dùng cho lịch sử thay đổi hoặc nâng cấp khi đã xác định đúng baseline.
- Không chạy unified schema và migrations trong cùng một mode kiểm tra.
- Không xóa constraint/index để làm test pass.
- Không gộp migration legacy dạng raw vì có nguy cơ trùng bảng.

## Việc cần review sau

- Nếu muốn hỗ trợ `MigrationsOnly` như đường khởi tạo database mới, cần thiết kế lại baseline migration đầy đủ hoặc tách migration 002 thành các đoạn có guard theo `to_regclass`.
- Cần quyết định có chuyển hai migration legacy vào thư mục `_legacy` ở bước quản trị repo sau hay chỉ giữ nguyên và ghi chú.
