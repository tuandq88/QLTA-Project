# Ghi chú chuẩn hóa reference data

Task 03 không sửa trực tiếp `unified_postgresql_schema.sql`. Thay vào đó, migration `003_reference_data_and_foreign_keys.sql` tạo nền danh mục và bổ sung các cột tham chiếu nullable để chạy song song với cột text/enum cũ.

## Lý do không drop cột cũ

- Nhiều skill, JSON thống kê và tài liệu hiện vẫn nhắc đến các mã text như `case_group`, `metric_group`, `rule_code`, `result_code`.
- Một số enum PostgreSQL đang ổn định và phù hợp cho giá trị lõi ít thay đổi.
- Dữ liệu thật chưa có để backfill, nên ép NOT NULL hoặc drop text ở Task 03 sẽ rủi ro.

## Mô hình được thêm

- `dm_categories`: khóa 1 của từng nhóm danh mục.
- `dm_category_items`: các giá trị danh mục, unique theo `category_id + item_code`.
- `dm_table_reference_columns`: bảng mô tả mapping giữa cột text/enum cũ và cột `*_id` mới.

## Hướng chuyển đổi nhiều giai đoạn

1. Tạo danh mục, seed tối thiểu, thêm cột `*_id` nullable.
2. Backfill `*_id` từ cột text/enum cũ bằng mapping đã xác nhận nghiệp vụ.
3. Cho backend ghi đồng thời code cũ và `*_id`.
4. Khi dữ liệu sạch, thêm trigger/check hoặc NOT NULL cho các cột bắt buộc.
5. Chỉ cân nhắc bỏ cột text cũ khi toàn bộ skill, report và API đã chuyển sang danh mục.
