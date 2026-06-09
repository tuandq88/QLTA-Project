# Migration legacy

Thư mục này dùng để ghi chú các migration legacy nếu sau này dự án quyết định di chuyển file.

Hiện tại không tự động di chuyển hoặc xóa file migration nguồn. Hai file cần coi là legacy:

- `database/migrations/random_assignment_schema_extension.sql`
- `database/migrations/appeal_protest_tracking_schema_extension.sql`

Lý do:

- Nội dung bảng đã được gộp vào `database/schema/unified_postgresql_schema.sql`.
- File dùng `CREATE TABLE` không có `IF NOT EXISTS`.
- Nếu chạy sau unified schema hoặc cùng chuỗi migration mới có thể gây lỗi trùng bảng.

Không chạy các file này trong kiểm tra mặc định.
