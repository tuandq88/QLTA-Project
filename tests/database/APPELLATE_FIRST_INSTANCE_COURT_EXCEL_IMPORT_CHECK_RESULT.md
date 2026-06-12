# APPELLATE_FIRST_INSTANCE_COURT_EXCEL_IMPORT_CHECK_RESULT

- Thoi diem kiem tra: 2026-06-12 14:20:14 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- Test SQL: tests/database/appellate_first_instance_court_excel_import_test.sql

## Lenh chay lai

```powershell
.\tests\database\run_appellate_first_instance_court_excel_import_check.ps1 -DatabaseName qlta_schema_merge_test
```

## Log chi tiet

### migration 009

- Exit code: 0

```text
psql:D:/QLTA-Project/database/migrations/009_appellate_first_instance_court.sql:9: NOTICE:  column "first_instance_court_id" of relation "case_files" already exists, skipping
psql:D:/QLTA-Project/database/migrations/009_appellate_first_instance_court.sql:9: NOTICE:  column "first_instance_case_number" of relation "case_files" already exists, skipping
psql:D:/QLTA-Project/database/migrations/009_appellate_first_instance_court.sql:9: NOTICE:  column "first_instance_judgment_number" of relation "case_files" already exists, skipping
psql:D:/QLTA-Project/database/migrations/009_appellate_first_instance_court.sql:9: NOTICE:  column "first_instance_judgment_date" of relation "case_files" already exists, skipping
ALTER TABLE
DO
psql:D:/QLTA-Project/database/migrations/009_appellate_first_instance_court.sql:21: NOTICE:  relation "idx_case_files_first_instance_court_id" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/009_appellate_first_instance_court.sql:25: NOTICE:  relation "idx_case_files_appellate_first_instance_group" already exists, skipping
CREATE INDEX
```

### seed 003 reference data

- Exit code: 0

```text
INSERT 0 45
INSERT 0 216
INSERT 0 43
```

### seed 004 statistical reference data

- Exit code: 0

```text
INSERT 0 6
INSERT 0 6
INSERT 0 10
INSERT 0 7
INSERT 0 2
INSERT 0 6
INSERT 0 4
INSERT 0 7
INSERT 0 7
INSERT 0 4
INSERT 0 5
INSERT 0 3
INSERT 0 1
INSERT 0 17
INSERT 0 4
```

### seed 011 courts

- Exit code: 0

```text
CREATE EXTENSION
psql:D:/QLTA-Project/database/seed/011_courts_quang_ngai.sql:4: NOTICE:  extension "uuid-ossp" already exists, skipping
INSERT 0 3
```

### seed 020 excel categories

- Exit code: 0

```text
INSERT 0 2
INSERT 0 11
```

### seed 021 criminal categories

- Exit code: 0

```text
INSERT 0 0
```

### seed 022 civil categories

- Exit code: 0

```text
INSERT 0 4
```

### seed 023 administrative categories

- Exit code: 0

```text
INSERT 0 0
```

### seed 024 other categories

- Exit code: 0

```text
INSERT 0 4
```

### seed 025 statistical indicators

- Exit code: 0

```text
INSERT 0 1
INSERT 0 2
INSERT 0 18
```

### seed 030 excel case files

- Exit code: 0

```text
BEGIN
INSERT 0 1
INSERT 0 2309
COMMIT
```

### test excel appellate first-instance court import

- Exit code: 0

```text
psql:D:/QLTA-Project/tests/database/appellate_first_instance_court_excel_import_test.sql:88: NOTICE:  Excel appellate first-instance court import passed: rows=1127, distinct_courts=27, regional=11, district=16
DO
```

