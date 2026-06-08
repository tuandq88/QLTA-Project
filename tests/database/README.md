# Database Tests

Thư mục này chứa test kiểm chứng schema PostgreSQL hợp nhất.

## File test

```text
tests/database/schema_smoke_test.sql
```

Test này kiểm tra:

- enum bắt buộc;
- bảng theo từng nhóm nghiệp vụ;
- khóa ngoại quan trọng;
- khả năng insert dữ liệu liên kết tối thiểu cho các module chính.

Test chạy trong transaction và `ROLLBACK` ở cuối, nên không để lại dữ liệu test nếu chạy thành công.

## Cách chạy bằng psql

Tạo database test trống:

```bash
createdb tand_qng_schema_test
```

Apply schema:

```bash
psql -v ON_ERROR_STOP=1 -d tand_qng_schema_test -f database/schema/unified_postgresql_schema.sql
```

Chạy smoke test:

```bash
psql -v ON_ERROR_STOP=1 -d tand_qng_schema_test -f tests/database/schema_smoke_test.sql
```

Kết quả đạt khi psql in thông báo:

```text
NOTICE:  schema smoke test passed
```

Nếu có lỗi bảng, enum hoặc khóa ngoại, psql sẽ dừng tại lỗi đầu tiên.

## Dọn database test

```bash
dropdb tand_qng_schema_test
```
