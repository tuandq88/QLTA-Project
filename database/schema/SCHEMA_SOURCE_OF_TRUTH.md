# Source of truth cho schema database

## Kết luận

`database/schema/unified_postgresql_schema.sql` là source of truth mặc định để khởi tạo database PostgreSQL mới của QLTA-Project.

`database/migrations/*.sql` là lịch sử thay đổi và dùng cho nâng cấp database đã có. Không chạy unified schema và migrations lên cùng một database nếu các migration đã được gộp vào unified schema.

## Vai trò từng nhóm file

### `database/schema/unified_postgresql_schema.sql`

- Dùng để tạo database mới từ đầu.
- Phải chứa đầy đủ bảng lõi, bảng module phân công ngẫu nhiên, bảng theo dõi kháng cáo/kháng nghị, bảng danh mục và bảng thống kê/KPI cần cho seed hiện có.
- Seed trong `database/seed/*.sql` phải chạy được sau file này.

### `database/migrations/*.sql`

- Dùng để nâng cấp database đã tồn tại theo thứ tự tên file.
- Chuỗi migration chuẩn hiện là các file đánh số `001_*.sql` đến `005_*.sql`.
- Hai file `random_assignment_schema_extension.sql` và `appeal_protest_tracking_schema_extension.sql` là migration mở rộng legacy. Nội dung đã được gộp vào schema/migration mới và có câu lệnh `CREATE TABLE` không dùng `IF NOT EXISTS`, nên không chạy mặc định cùng chuỗi migration đánh số.

### `database/seed/*.sql`

- Là dữ liệu danh mục, dữ liệu chuẩn hóa từ nguồn được dự án lưu.
- Chạy sau schema.
- Seed phải idempotent, ưu tiên `ON CONFLICT DO UPDATE`.
- Không được seed hồ sơ vụ án thật, dữ liệu cá nhân thật hoặc dữ liệu pháp lý tự bịa.

### `tests/database/*.sql`

- Dùng để kiểm tra schema, seed và điều kiện precheck trước khi kiểm thử thuật toán thống kê.
- Không thay thế migration và không dùng để sửa dữ liệu.

## Chế độ chạy đề xuất

### UnifiedOnly

Chạy:

1. Drop/recreate database test.
2. `database/schema/unified_postgresql_schema.sql`.
3. Các file seed trong `database/seed/*.sql` theo thứ tự tên file, bỏ qua `999_seed_all.sql`.
4. SQL test trong `tests/database/`.

Không chạy migrations trong chế độ này.

### MigrationsOnly

Chạy:

1. Drop/recreate database test.
2. Các migration đánh số trong `database/migrations/*.sql` theo thứ tự tên file nếu migration đó đã được đánh dấu tương thích.
3. Các file seed trong `database/seed/*.sql` theo thứ tự tên file, bỏ qua `999_seed_all.sql`.
4. SQL test trong `tests/database/`.

Không chạy unified schema trong chế độ này.

Trạng thái hiện tại: `MigrationsOnly` chưa được coi là đường khởi tạo database mới hoàn chỉnh vì một số migration đang là migration bổ sung sau unified schema hoặc cần review thêm. Kết quả chi tiết xem `database/schema/MIGRATION_COMPATIBILITY_REVIEW.md`.

## Quy tắc không chạy trùng

Không chạy `database/schema/unified_postgresql_schema.sql` và chuỗi migrations lên cùng database nếu migration đó đã được đồng bộ vào unified schema. Việc chạy trùng có thể gây lỗi bảng, constraint hoặc index đã tồn tại.

## Quy tắc cập nhật sau này

- Mọi thay đổi schema phải có migration mới.
- Khi migration ổn định, đồng bộ lại `database/schema/unified_postgresql_schema.sql`.
- Khi thay đổi schema, cập nhật tài liệu trong `database/` và README liên quan.
- Seed mới phải chạy được sau unified schema.
- Seed mới phải có căn cứ nguồn hoặc ghi rõ `requires_human_review`.
- Test mới phải fail thật khi phát hiện thiếu bảng, lỗi FK, duplicate key hoặc seed không idempotent.
- Script kiểm tra database phải đọc `.env.local` hoặc environment variables, không hard-code secret.
- Báo cáo và tài liệu phải viết bằng tiếng Việt UTF-8; tài liệu xuất định dạng có font dùng Tahoma.
