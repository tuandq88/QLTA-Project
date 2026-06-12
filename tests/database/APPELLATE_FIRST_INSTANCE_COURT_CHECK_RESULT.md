# APPELLATE_FIRST_INSTANCE_COURT_CHECK_RESULT

- Thoi diem kiem tra: 2026-06-12 14:20:12 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- Migration: database/migrations/009_appellate_first_instance_court.sql
- Seed courts: database/seed/011_courts_quang_ngai.sql
- Seed test: database/seed/test/060_test_appellate_first_instance_courts.sql
- Test SQL: tests/database/appellate_first_instance_court_integrity_test.sql

## Lenh chay lai

```powershell
.\tests\database\run_appellate_first_instance_court_check.ps1 -DatabaseName qlta_schema_merge_test
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
CREATE INDEX
```

### seed 011 courts

- Exit code: 0

```text
CREATE EXTENSION
psql:D:/QLTA-Project/database/seed/011_courts_quang_ngai.sql:4: NOTICE:  extension "uuid-ossp" already exists, skipping
INSERT 0 3
```

### seed 060 test appellate first-instance courts

- Exit code: 0

```text
psql:D:/QLTA-Project/database/seed/test/060_test_appellate_first_instance_courts.sql:4: NOTICE:  extension "uuid-ossp" already exists, skipping
CREATE EXTENSION
INSERT 0 3
```

### test appellate first-instance court integrity

- Exit code: 0

```text
psql:D:/QLTA-Project/tests/database/appellate_first_instance_court_integrity_test.sql:112: NOTICE:  Appellate first-instance court integrity passed. Missing/invalid first-instance court rows currently requiring warning: 0
DO
```

