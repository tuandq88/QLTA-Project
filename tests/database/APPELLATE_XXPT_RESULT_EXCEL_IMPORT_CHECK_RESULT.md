# APPELLATE_XXPT_RESULT_EXCEL_IMPORT_CHECK_RESULT

- Thoi diem kiem tra: 2026-06-12 15:19:16 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- Test SQL: tests/database/appellate_xxpt_result_excel_import_test.sql

## Lenh chay lai

```powershell
.\tests\database\run_appellate_xxpt_result_excel_import_check.ps1 -DatabaseName qlta_schema_merge_test
```

## Log chi tiet

### seed 030 excel case files

- Exit code: 0

```text
BEGIN
INSERT 0 1
INSERT 0 2309
COMMIT
```

### seed 033 excel events decisions appellate results

- Exit code: 0

```text
BEGIN
INSERT 0 0
INSERT 0 0
INSERT 0 0
UPDATE 2221
INSERT 0 0
INSERT 0 0
INSERT 0 0
COMMIT
```

### test appellate XXPT result import

- Exit code: 0

```text
psql:D:/QLTA-Project/tests/database/appellate_xxpt_result_excel_import_test.sql:132: NOTICE:  Excel XXPT result import passed: result_rows=843, with_date=840, without_date_warning=3, period_result_rows=7
DO
```

