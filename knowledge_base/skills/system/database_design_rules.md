# Skill: Database Design Rules

## 1. Mục đích

Hướng dẫn thiết kế schema, migration, seed và test database cho QLTA-Project.

## 2. Quy tắc đặt tên

- Technical object names dùng tiếng Anh: table, column, enum, index, constraint, function, view, trigger.
- Không dùng tiếng Việt có dấu trong object kỹ thuật.
- Code danh mục dùng ASCII/English hoặc tiếng Việt không dấu dạng code ổn định.
- Dữ liệu hiển thị/mô tả nghiệp vụ được dùng tiếng Việt UTF-8.

## 3. Source of Truth

- Database mới dùng `database/schema/unified_postgresql_schema.sql`.
- Database đã tồn tại dùng migration phù hợp với baseline thực tế.
- Không chạy unified schema và migration chain trên cùng database test nếu migration đã được merge.

## 4. Schema Change Checklist

- Có bảng/cột đã tồn tại chưa?
- Có tạo trùng chức năng với module khác không?
- Có cần danh mục trong `dm_categories/dm_category_items` không?
- Có cần data dictionary không?
- Có cần seed reference hoặc seed test không?
- Có cần wrapper test PowerShell không?
- Có cần cập nhật README/rule/skill không?

## 5. Migration Rule

- Migration nên additive và idempotent nếu phù hợp.
- Không drop/rename dữ liệu khi chưa có yêu cầu rõ.
- Không xóa constraint/index để làm test pass.
- Migration đã merge vào unified schema vẫn có thể là active upgrade migration, không xóa tùy tiện.

## 6. Seed/Test Rule

- Seed reference nằm trong `database/seed/*.sql`.
- Seed test-only nằm trong `database/seed/test/`.
- Test phải chứng minh edge case nghiệp vụ, không chỉ kiểm tra insert thành công.
- Test database phải chạy được trên Windows PowerShell và đọc cấu hình PostgreSQL từ `.env.local` hoặc environment variables.

## 7. Statistics Rule

- Không đếm trùng.
- Không group theo `case_id` nếu nghiệp vụ yêu cầu occurrence-level hoặc defendant-level.
- Formula/validation phải truy xuất được nguồn từ skill, data dictionary hoặc tài liệu pháp lý.

## 8. Skill Follow-up

Nếu schema change tạo ra logic dùng lại được, phải cập nhật hoặc tạo skill cho:

- database;
- backend/API;
- frontend;
- validation;
- seed/test data;
- statistics/list report.
