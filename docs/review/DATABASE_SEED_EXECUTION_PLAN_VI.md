# Kế hoạch chạy kiểm tra database và seed

## Bước 1: Cấu hình biến môi trường PostgreSQL

Thiết lập trong Windows PowerShell:

```powershell
$env:PGHOST = "localhost"
$env:PGPORT = "5432"
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<mat_khau_postgres>"
```

Không hard-code mật khẩu trong script hoặc commit mật khẩu vào repo.

## Bước 2: Chạy empty postgres check

Chế độ khuyến nghị cho database mới:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Chế độ kiểm tra chuỗi migration đánh số:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode MigrationsOnly
```

Không chạy unified schema và migrations cùng lúc trên cùng database.

## Bước 3: Chạy seed validation check

Chạy trên database đã có schema:

```powershell
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_empty_test
```

Nếu muốn reset database test rồi chạy lại schema trước khi seed:

```powershell
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_empty_test -ResetDatabase
```

Script chạy seed hai lần để kiểm tra idempotent.

## Bước 4: Chạy statistics precheck

```powershell
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_empty_test
```

Precheck chỉ kiểm tra điều kiện nền: bảng thống kê, danh mục chỉ tiêu, form, metric, dữ liệu danh mục và insert mẫu trong transaction rollback.

## Bước 5: Đọc file kết quả

Đọc các file:

- `tests/database/EMPTY_POSTGRES_CHECK_RESULT.md`
- `tests/database/DATABASE_SEED_CHECK_RESULT.md`
- `tests/database/STATISTICS_PRECHECK_RESULT.md`

Chỉ tiếp tục khi tất cả có `PASSED`.

## Bước 6: Xử lý lỗi thường gặp

Lỗi đăng nhập:

- Kiểm tra `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`.
- Không dùng Windows username thay cho PostgreSQL user.

Lỗi `psql` không tồn tại:

- Cài PostgreSQL client tools.
- Thêm thư mục chứa `psql.exe` vào PATH.

Lỗi bảng không tồn tại khi chạy seed:

- Chạy lại `run_empty_postgres_check.ps1 -Mode UnifiedOnly`.
- Kiểm tra seed có phụ thuộc bảng chưa có trong unified schema không.

Lỗi duplicate key khi chạy seed lần 2:

- Seed chưa idempotent.
- Bổ sung `ON CONFLICT DO UPDATE` hoặc khóa tự nhiên phù hợp.

Lỗi FK:

- Kiểm tra thứ tự seed.
- Kiểm tra dữ liệu cha đã tồn tại chưa.

Lỗi trùng bảng/constraint khi chạy schema:

- Không chạy unified schema và migrations cùng lúc.
- Không chạy hai migration legacy module nếu nội dung đã được gộp.

## Bước 7: Điều kiện chuyển sang kiểm thử thuật toán thống kê

Chỉ chuyển sang kiểm thử thuật toán thống kê khi:

- Empty postgres check: `PASSED`.
- Seed validation check: `PASSED`.
- Statistics precheck: `PASSED`.
- Dữ liệu có `requires_human_review` đã được rà soát nếu dùng cho kết luận nghiệp vụ.

Không dùng dữ liệu seed hiện tại để kết luận pháp lý cuối cùng khi chưa có human review.
