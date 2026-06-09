# Migration pending review

Thư mục này dùng để ghi chú các migration cần review thêm trước khi coi là chuỗi `MigrationsOnly` hoàn chỉnh.

Trạng thái hiện tại:

- `001_core_database_schema.sql` chỉ tạo core schema, chưa đủ toàn bộ bảng unified.
- `002_database_constraints_and_indexes.sql` giả định nhiều bảng đã tồn tại từ unified schema, nên chạy sau `001_core_database_schema.sql` sẽ lỗi tại bảng `appeals`.
- `003`, `004`, `005` tương thích hơn nhưng vẫn cần một baseline đầy đủ nếu muốn dùng `MigrationsOnly` để khởi tạo database mới.

Khuyến nghị:

- Database mới dùng `database/schema/unified_postgresql_schema.sql`.
- Chỉ dùng migration cho nâng cấp database đã có đúng baseline.
- Không sửa/xóa constraint để ép test pass.
