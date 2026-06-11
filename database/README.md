# Database

Thư mục chứa tài liệu và file triển khai database.

```text
database/
├── diagrams/      ERD và tài liệu thiết kế dữ liệu
├── schema/        Schema có thể dùng để tạo database
└── migrations/    Các phần mở rộng hoặc migration theo module
```

File chính để tạo database PostgreSQL:

```text
database/schema/unified_postgresql_schema.sql
```

Migration bổ sung mới nhất:

- `database/migrations/008_criminal_appellate_defendant_results.sql`: thêm bảng kết quả phúc thẩm hình sự theo từng bị cáo và bảng tiêu chí sửa án.
