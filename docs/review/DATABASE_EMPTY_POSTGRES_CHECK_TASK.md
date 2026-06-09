# DATABASE EMPTY POSTGRES CHECK TASK

## Mục tiêu kiểm tra

Kiểm tra toàn bộ database của QLTA-Project trên một PostgreSQL database trống để xác nhận:

- schema hợp nhất có thể khởi tạo sạch;
- migration chạy đúng thứ tự;
- seed data chạy được;
- test SQL chạy được;
- constraint, foreign key và unique index hoạt động đúng;
- database đủ điều kiện kỹ thuật trước khi bắt đầu viết backend.

Task này chỉ kiểm tra database. Không viết backend, frontend, API hoặc sửa skill nghiệp vụ.

## Môi trường yêu cầu

- Windows PowerShell.
- PostgreSQL server đang chạy.
- PostgreSQL client tools có `psql.exe` trong `PATH`.
- Tài khoản PostgreSQL có quyền tạo/drop database test.
- Script đọc biến môi trường PostgreSQL chuẩn:
  - `PGHOST`, mặc định `localhost`;
  - `PGPORT`, mặc định `5432`;
  - `PGUSER`, mặc định `postgres`;
  - `PGPASSWORD`, bắt buộc set trước khi chạy để tránh prompt mật khẩu lặp lại.

Database test mặc định: `qlta_empty_test`.

## Script kiểm tra

Script chính:

```powershell
tests/database/run_empty_postgres_check.ps1
```

Script hỗ trợ hai mode loại trừ nhau:

- `UnifiedOnly` mặc định: chạy `database/schema/unified_postgresql_schema.sql`, không chạy `database/migrations/*.sql`.
- `MigrationsOnly`: chạy `database/migrations/*.sql`, không chạy `database/schema/unified_postgresql_schema.sql`.

Không chạy unified schema và migration chain trong cùng một lần kiểm tra vì nhiều migration đã được gom vào schema hợp nhất.

SQL helper tổng hợp:

```text
tests/database/run_empty_postgres_check.sql
```

Result file:

```text
tests/database/EMPTY_POSTGRES_CHECK_RESULT.md
```

## Cách chạy trên Windows PowerShell

Chạy mặc định sau khi set user/password:

```powershell
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<password>"
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Chạy với database test khác:

```powershell
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<password>"
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test_02 -Mode UnifiedOnly
```

Nếu PostgreSQL yêu cầu thông tin kết nối:

```powershell
$env:PGHOST = "localhost"
$env:PGPORT = "5432"
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<password>"
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Không hard-code password vào script.

Mọi lệnh `psql` trong script đều truyền rõ:

```text
psql -h $PGHOST -p $PGPORT -U $PGUSER -d <database> -v ON_ERROR_STOP=1 -c "<SQL>"
psql -h $PGHOST -p $PGPORT -U $PGUSER -d <database> -v ON_ERROR_STOP=1 -f "<path-to-file.sql>"
```

Nếu thiếu `PGUSER`, script dùng `postgres`, không dùng Windows username như `Administrator`.

Nếu thiếu `PGPASSWORD`, script dừng sớm và ghi hướng dẫn set:

```powershell
$env:PGPASSWORD = "<password>"
```

## Thứ tự script dự kiến chạy

### 1. Tạo database test

- Kiểm tra `psql`.
- Kiểm tra kết nối database bảo trì, mặc định `postgres`.
- Chạy `DROP DATABASE IF EXISTS qlta_empty_test WITH (FORCE)`.
- Nếu PostgreSQL không hỗ trợ `WITH (FORCE)`, fallback sang terminate session bằng `pg_terminate_backend`, rồi chạy `DROP DATABASE IF EXISTS qlta_empty_test`.
- `CREATE DATABASE qlta_empty_test`.

Script từ chối drop các database bảo vệ: `postgres`, `template0`, `template1`.

### 2. Mode UnifiedOnly

```text
database/schema/unified_postgresql_schema.sql
```

Trong mode này, script không chạy bất kỳ file nào trong `database/migrations/`, bao gồm `database/migrations/001_core_database_schema.sql`.

### 3. Mode MigrationsOnly

Mode này không chạy `database/schema/unified_postgresql_schema.sql`.

Migration chạy theo tên tăng dần:

```text
database/migrations/001_core_database_schema.sql
database/migrations/002_database_constraints_and_indexes.sql
database/migrations/003_reference_data_and_foreign_keys.sql
database/migrations/004_statistical_reference_data.sql
```

Các file sau được skip mặc định:

```text
database/migrations/appeal_protest_tracking_schema_extension.sql
database/migrations/random_assignment_schema_extension.sql
```

Lý do: hai migration module này đã được gom vào `unified_postgresql_schema.sql` và hiện không idempotent vì dùng `CREATE TABLE` không có `IF NOT EXISTS`. Chạy lại sau unified schema sẽ tạo lỗi trùng bảng. Nếu cần kiểm tra riêng migration chain cũ, chạy trên database khác và dùng cờ `-IncludeLegacyExtensionMigrations`.

### 4. Seed theo tên tăng dần

```text
database/seed/003_reference_data_seed.sql
database/seed/004_statistical_reference_data_seed.sql
```

### 5. Test SQL theo nhóm

Script chạy `tests/database/run_empty_postgres_check.sql` trước, sau đó nhóm `*integrity*.sql`, `*duplicate*.sql`, `*schema*.sql`, rồi các SQL còn lại.

Các test `core_schema_*.sql` được skip mặc định vì ghi rõ chỉ dành cho core schema độc lập, không phải full unified database. Không xóa các test này.

## Cách đọc kết quả

Mở:

```text
tests/database/EMPTY_POSTGRES_CHECK_RESULT.md
```

Các trạng thái:

- `PASSED`: toàn bộ bước đã chạy thành công.
- `FAILED`: có lỗi PostgreSQL, script dừng tại file lỗi đầu tiên.
- `NOT_RUN_ENVIRONMENT_LIMITATION`: chưa chạy được do thiếu môi trường như `psql`.

Script dùng `ON_ERROR_STOP=1`, nên lỗi đầu tiên trong output là lỗi gốc cần sửa trước.

PostgreSQL `NOTICE` và `WARNING` không tự động được coi là lỗi. Script ghi các thông báo này vào mục `PostgreSQL Output` trong result file để theo dõi, nhưng chỉ fail khi lệnh `psql` trả exit code khác `0`.

Script không dùng option `-i`; `psql` không hỗ trợ option này. Inline SQL luôn dùng `-c`, file SQL luôn dùng `-f`.

Ví dụ thông báo bình thường khi database test chưa tồn tại:

```text
NOTICE: database "qlta_empty_test" does not exist, skipping
```

Thông báo này không làm script fail.

## Lỗi thường gặp và cách xử lý

### `psql` chưa có trong PATH

Biểu hiện: `psql was not found in PATH`.

Cách xử lý:

- Cài PostgreSQL client tools.
- Thêm thư mục chứa `psql.exe` vào `PATH`, ví dụ `C:\Program Files\PostgreSQL\16\bin`.
- Mở PowerShell mới và chạy lại.

### Chưa tạo user PostgreSQL hoặc user thiếu quyền

Biểu hiện: lỗi authentication hoặc permission denied khi `CREATE DATABASE`.

Cách xử lý:

- Dùng user có quyền tạo database.
- Kiểm tra `$env:PGUSER`.
- Cấp quyền `CREATEDB` nếu cần.

### Sai password

Biểu hiện: `password authentication failed`.

Cách xử lý:

- Cập nhật `$env:PGPASSWORD`.
- Đảm bảo `$env:PGUSER` đúng, mặc định nên là `postgres` khi kiểm tra local.
- Kiểm tra file `pg_hba.conf` nếu dùng local PostgreSQL.

### Database đang có session kết nối

Script đã gọi `pg_terminate_backend` trước khi drop database test. Nếu vẫn lỗi:

- Đóng kết nối từ pgAdmin, DBeaver hoặc terminal khác.
- Đổi `-DatabaseName` sang database test mới.

### PostgreSQL NOTICE khi drop database

Biểu hiện:

```text
NOTICE: database "qlta_empty_test" does not exist, skipping
```

Cách xử lý:

- Không cần xử lý. Đây là kết quả bình thường của `DROP DATABASE IF EXISTS`.
- Script chỉ dừng nếu `psql` trả exit code khác `0`.
- NOTICE/WARNING được ghi vào `EMPTY_POSTGRES_CHECK_RESULT.md` để audit.

### `psql.exe: illegal option -- i`

Biểu hiện: PowerShell hoặc script truyền sai option cho `psql`.

Cách xử lý:

- Dùng phiên bản script hiện tại, trong đó inline SQL dùng `-c` và file SQL dùng `-f`.
- Kiểm tra không tự thêm option `-i` khi gọi thủ công.
- Lệnh tạo database đúng dạng:

```powershell
psql -h $env:PGHOST -p $env:PGPORT -U $env:PGUSER -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE qlta_empty_test;"
```

### Migration chạy trùng với unified schema

Biểu hiện: lỗi relation already exists ở các module cũ.

Cách xử lý:

- Dùng `-Mode UnifiedOnly` để kiểm tra schema hợp nhất.
- Dùng `-Mode MigrationsOnly` để kiểm tra migration chain riêng.
- Không chạy cả hai trong cùng một lần kiểm tra.

### Constraint fail do seed trùng

Biểu hiện: unique violation trong seed.

Cách xử lý:

- Kiểm tra seed có `ON CONFLICT` đúng key chưa.
- Nếu seed phụ thuộc dữ liệu cũ, chạy trên database trống để xác nhận lại.

### Thứ tự migration sai

Biểu hiện: relation/column/type does not exist.

Cách xử lý:

- Giữ tên migration dạng `001_`, `002_`, `003_`, `004_`.
- Không đặt migration phụ thuộc schema thống kê trước migration tạo bảng thống kê.

## Kết quả kiểm tra trong môi trường Codex

Codex chưa chạy được PostgreSQL thật vì môi trường hiện tại không có `psql` trong `PATH`.

Result hiện tại:

```text
NOT_RUN_ENVIRONMENT_LIMITATION
```

Chi tiết được ghi tại:

```text
tests/database/EMPTY_POSTGRES_CHECK_RESULT.md
```

## Sửa đổi đã thực hiện khi rà lỗi rõ ràng

Đã sửa tối thiểu các tham chiếu cột không tồn tại để empty check không fail do lỗi kỹ thuật cũ:

- `database/migrations/002_database_constraints_and_indexes.sql`
  - `case_events.event_time` -> `case_events.created_at`
  - `hearings.court_id` -> `hearings.case_id`
  - `appellate_trackings.final_result_date` -> `appellate_trackings.resolved_date`
- `tests/database/duplicate_prevention_test.sql`
  - bỏ `statistics_snapshots.metric_name`;
  - bỏ `kpi_metrics.unit`;
  - bỏ `appellate_results.result_name`.

Các sửa đổi này không thay đổi nghiệp vụ, chỉ đồng bộ test/index với schema hợp nhất hiện tại.

## Việc người dùng cần chạy local

Sau khi có PostgreSQL/psql:

```powershell
cd D:\QLTA-Project
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<password>"
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Kiểm tra migration chain riêng:

```powershell
cd D:\QLTA-Project
$env:PGUSER = "postgres"
$env:PGPASSWORD = "<password>"
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode MigrationsOnly
```

Nếu kết quả là `PASSED`, bước tiếp theo là bắt đầu thiết kế backend CRUD đọc/ghi theo FK danh mục mới, nhưng vẫn phải có kế hoạch backfill từ cột legacy text/code trước khi dùng dữ liệu thật.
