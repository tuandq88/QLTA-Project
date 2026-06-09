# Kết quả kiểm tra đồng bộ schema và migration

Thời điểm kiểm tra: 09/06/2026

## Kết luận nhanh

- `UnifiedOnly`: `PASSED`.
- Seed validation: `PASSED`.
- Statistics precheck: `PASSED`.
- Script đã tự đọc `.env.local` khi environment variables chưa được set.
- `MigrationsOnly`: chưa đạt tiêu chuẩn làm đường khởi tạo database mới hoàn chỉnh; lỗi đã được ghi trong compatibility review.

## Lệnh đã chạy

```powershell
Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
Remove-Item Env:PGHOST -ErrorAction SilentlyContinue
Remove-Item Env:PGPORT -ErrorAction SilentlyContinue
Remove-Item Env:PGUSER -ErrorAction SilentlyContinue
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly
```

Kết quả: `PASSED`.

File kết quả chi tiết:

- `tests/database/EMPTY_POSTGRES_CHECK_RESULT.md`

Đã chạy tiếp:

```powershell
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test
```

Kết quả:

- `tests/database/DATABASE_SEED_CHECK_RESULT.md`: `PASSED`.
- `tests/database/STATISTICS_PRECHECK_RESULT.md`: `PASSED`.

## Kiểm tra MigrationsOnly

Đã kiểm tra chế độ:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_migrations_merge_test -Mode MigrationsOnly -SkipSeed -SkipTests
```

Kết quả: `FAILED` tại `database/migrations/002_database_constraints_and_indexes.sql` do bảng `appeals` chưa tồn tại sau `001_core_database_schema.sql`.

Kết luận: không dùng `MigrationsOnly` làm đường khởi tạo database mới cho đến khi có baseline migration đầy đủ hoặc guard theo bảng tồn tại.

## Phạm vi đã xác nhận

- Unified schema tạo được database mới.
- Seed chạy được sau unified schema.
- Seed chạy lại lần 2 không lỗi duplicate key/FK trong kiểm tra hiện tại.
- SQL test kiểm tra bảng, FK, index/unique constraint và check constraint quan trọng đã PASS.
- Precheck thống kê insert dữ liệu mẫu tối thiểu trong transaction và rollback thành công.

## Lưu ý bảo mật

- Script đọc `.env.local` hoặc environment variables.
- Báo cáo không ghi `PGPASSWORD` hoặc `DATABASE_URL`.
- `.env.local` đã nằm trong `.gitignore`.
