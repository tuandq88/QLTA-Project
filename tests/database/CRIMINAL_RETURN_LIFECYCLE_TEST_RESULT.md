# CRIMINAL_RETURN_LIFECYCLE_TEST_RESULT

- Thoi diem kiem tra: 2026-06-11 09:36:14 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- Migration: database/migrations/007_case_occurrences_and_resolution_events.sql
- Seed danh muc: database/seed/003_reference_data_seed.sql
- Seed test: database/seed/test/040_test_criminal_first_instance_return_lifecycle.sql
- Test SQL: tests/database/test_criminal_first_instance_return_lifecycle_skill.sql

## Ky kiem tra

| Ky | Tu ngay | Den ngay | Thu ly | Giai quyet | Tra VKS | Xet xu | Ton cuoi ky |
|---|---:|---:|---:|---:|---:|---:|---:|
| A | 2026-03-01 | 2026-05-31 | 6 | 4 | 4 | 0 | 2 |
| B | 2026-03-01 | 2026-06-30 | 8 | 6 | 4 | 2 | 2 |
| C | 2026-06-01 | 2026-06-30 | 2 | 2 | 0 | 2 | 2 |
| D | 2026-01-01 | 2026-12-31 | 10 | 9 | 7 | 2 | 1 |
| E | 2026-07-01 | 2026-07-31 | 0 | 1 | 1 | 0 | 1 |

## Nguyen tac da kiem tra

- Don vi dem la occurrence/vong doi thong ke, khong phai distinct case_id.
- Moi lan tra ho so cho VKS la mot su kien giai quyet rieng cua occurrence.
- Moi lan thu ly lai sau dieu tra bo sung la mot occurrence moi.
- Ho so HSST-RETURN-003 occurrence 4 van ton den het nam 2026.

## Lenh chay lai

```powershell
.\tests\database\run_criminal_return_lifecycle_skill_check.ps1 -DatabaseName qlta_schema_merge_test
```

## Log chi tiet

### migration 007

- Exit code: 0

```text
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:5: NOTICE:  extension "uuid-ossp" already exists, skipping
CREATE EXTENSION
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:26: NOTICE:  relation "case_occurrences" already exists, skipping
CREATE TABLE
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:48: NOTICE:  relation "case_resolution_events" already exists, skipping
CREATE TABLE
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:51: NOTICE:  column "acceptance_type_id" of relation "case_occurrences" already exists, skipping
ALTER TABLE
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:56: NOTICE:  column "event_type_code" of relation "case_resolution_events" already exists, skipping
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:56: NOTICE:  column "resolution_type_id" of relation "case_resolution_events" already exists, skipping
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:56: NOTICE:  column "return_to_agency_id" of relation "case_resolution_events" already exists, skipping
ALTER TABLE
DO
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:80: NOTICE:  relation "idx_case_occurrences_case_acceptance" already exists, skipping
CREATE INDEX
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:83: NOTICE:  relation "idx_case_occurrences_acceptance_type" already exists, skipping
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:86: NOTICE:  relation "idx_case_resolution_events_case_date" already exists, skipping
CREATE INDEX
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:89: NOTICE:  relation "idx_case_resolution_events_occurrence_date" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:92: NOTICE:  relation "idx_case_resolution_events_type_date" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/007_case_occurrences_and_resolution_events.sql:95: NOTICE:  relation "uq_case_resolution_events_occurrence_type_date_decision" already exists, skipping
```

### seed 003 reference data

- Exit code: 0

```text
INSERT 0 41
INSERT 0 195
INSERT 0 39
```

### seed 040 test lifecycle

- Exit code: 0

```text
INSERT 0 1
INSERT 0 4
INSERT 0 4
INSERT 0 4
INSERT 0 4
INSERT 0 10
UPDATE 10
INSERT 0 9
UPDATE 9
UPDATE 7
```

### test lifecycle skill

- Exit code: 0

```text
psql:D:/QLTA-Project/tests/database/test_criminal_first_instance_return_lifecycle_skill.sql:7: NOTICE:  table "tmp_return_periods" does not exist, skipping
DROP TABLE
CREATE TABLE
INSERT 0 5
psql:D:/QLTA-Project/tests/database/test_criminal_first_instance_return_lifecycle_skill.sql:36: NOTICE:  table "tmp_return_cases" does not exist, skipping
DROP TABLE
SELECT 4
psql:D:/QLTA-Project/tests/database/test_criminal_first_instance_return_lifecycle_skill.sql:44: NOTICE:  table "tmp_return_actual_summary" does not exist, skipping
DROP TABLE
SELECT 5
DO
         section         | period_code | from_date  |  to_date   | expected_accepted | actual_accepted | expected_resolved | actual_resolved | expected_return | actual_return | expected_judgment | actual_judgment | expected_remaining | actual_remaining 
-------------------------+-------------+------------+------------+-------------------+-----------------+-------------------+-----------------+-----------------+---------------+-------------------+-----------------+--------------------+------------------
 SUMMARY_EXPECTED_ACTUAL | A           | 2026-03-01 | 2026-05-31 |                 6 |               6 |                 4 |               4 |               4 |             4 |                 0 |               0 |                  2 |                2
 SUMMARY_EXPECTED_ACTUAL | B           | 2026-03-01 | 2026-06-30 |                 8 |               8 |                 6 |               6 |               4 |             4 |                 2 |               2 |                  2 |                2
 SUMMARY_EXPECTED_ACTUAL | C           | 2026-06-01 | 2026-06-30 |                 2 |               2 |                 2 |               2 |               0 |             0 |                 2 |               2 |                  2 |                2
 SUMMARY_EXPECTED_ACTUAL | D           | 2026-01-01 | 2026-12-31 |                10 |              10 |                 9 |               9 |               7 |             7 |                 2 |               2 |                  1 |                1
 SUMMARY_EXPECTED_ACTUAL | E           | 2026-07-01 | 2026-07-31 |                 0 |               0 |                 1 |               1 |               1 |             1 |                 0 |               0 |                  1 |                1
(5 rows)

      section       | period_code |    case_code    | occurrence_no | acceptance_date |              acceptance_type_code              
--------------------+-------------+-----------------+---------------+-----------------+------------------------------------------------
 ACCEPTED_BY_PERIOD | A           | HSST-RETURN-002 |             2 | 2026-03-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | A           | HSST-RETURN-001 |             1 | 2026-03-10      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | A           | HSST-RETURN-003 |             2 | 2026-03-15      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | A           | HSST-RETURN-003 |             3 | 2026-04-22      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | A           | HSST-RETURN-001 |             2 | 2026-05-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | A           | HSST-RETURN-002 |             3 | 2026-05-20      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-002 |             2 | 2026-03-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-001 |             1 | 2026-03-10      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-003 |             2 | 2026-03-15      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-003 |             3 | 2026-04-22      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-001 |             2 | 2026-05-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-002 |             3 | 2026-05-20      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-004 |             1 | 2026-06-05      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | B           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | C           | HSST-RETURN-004 |             1 | 2026-06-05      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | C           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-002 |             1 | 2026-01-12      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-003 |             1 | 2026-02-01      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-002 |             2 | 2026-03-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-001 |             1 | 2026-03-10      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-003 |             2 | 2026-03-15      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-003 |             3 | 2026-04-22      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-001 |             2 | 2026-05-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-002 |             3 | 2026-05-20      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-004 |             1 | 2026-06-05      | INITIAL_ACCEPTANCE
 ACCEPTED_BY_PERIOD | D           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
(26 rows)

      section       | period_code |    case_code    | occurrence_no | event_date |                resolution_type_code                | return_to_agency_code | decision_number 
--------------------+-------------+-----------------+---------------+------------+----------------------------------------------------+-----------------------+-----------------
 RESOLVED_BY_PERIOD | A           | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RESOLVED_BY_PERIOD | A           | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RESOLVED_BY_PERIOD | A           | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RESOLVED_BY_PERIOD | A           | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RESOLVED_BY_PERIOD | B           | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RESOLVED_BY_PERIOD | B           | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RESOLVED_BY_PERIOD | B           | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RESOLVED_BY_PERIOD | B           | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RESOLVED_BY_PERIOD | B           | HSST-RETURN-001 |             2 | 2026-06-20 | TRIAL_JUDGMENT                                     |                       | BA-001-2
 RESOLVED_BY_PERIOD | B           | HSST-RETURN-002 |             3 | 2026-06-28 | TRIAL_JUDGMENT                                     |                       | BA-002-3
 RESOLVED_BY_PERIOD | C           | HSST-RETURN-001 |             2 | 2026-06-20 | TRIAL_JUDGMENT                                     |                       | BA-001-2
 RESOLVED_BY_PERIOD | C           | HSST-RETURN-002 |             3 | 2026-06-28 | TRIAL_JUDGMENT                                     |                       | BA-002-3
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-002 |             1 | 2026-02-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-1
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-003 |             1 | 2026-02-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-1
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-001 |             2 | 2026-06-20 | TRIAL_JUDGMENT                                     |                       | BA-001-2
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-002 |             3 | 2026-06-28 | TRIAL_JUDGMENT                                     |                       | BA-002-3
 RESOLVED_BY_PERIOD | D           | HSST-RETURN-004 |             1 | 2026-07-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-004-1
 RESOLVED_BY_PERIOD | E           | HSST-RETURN-004 |             1 | 2026-07-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-004-1
(22 rows)

            section            | period_code |    case_code    | occurrence_no | event_date |                resolution_type_code                | return_to_agency_code | decision_number 
-------------------------------+-------------+-----------------+---------------+------------+----------------------------------------------------+-----------------------+-----------------
 RETURN_TO_PROCURACY_BY_PERIOD | A           | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RETURN_TO_PROCURACY_BY_PERIOD | A           | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RETURN_TO_PROCURACY_BY_PERIOD | A           | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RETURN_TO_PROCURACY_BY_PERIOD | A           | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RETURN_TO_PROCURACY_BY_PERIOD | B           | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RETURN_TO_PROCURACY_BY_PERIOD | B           | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RETURN_TO_PROCURACY_BY_PERIOD | B           | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RETURN_TO_PROCURACY_BY_PERIOD | B           | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-002 |             1 | 2026-02-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-1
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-003 |             1 | 2026-02-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-1
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RETURN_TO_PROCURACY_BY_PERIOD | D           | HSST-RETURN-004 |             1 | 2026-07-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-004-1
 RETURN_TO_PROCURACY_BY_PERIOD | E           | HSST-RETURN-004 |             1 | 2026-07-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-004-1
(16 rows)

       section        |    case_code    | occurrence_no | acceptance_date |              acceptance_type_code              
----------------------+-----------------+---------------+-----------------+------------------------------------------------
 ACCEPTED_OCCURRENCES | HSST-RETURN-001 |             1 | 2026-03-10      | INITIAL_ACCEPTANCE
 ACCEPTED_OCCURRENCES | HSST-RETURN-001 |             2 | 2026-05-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_OCCURRENCES | HSST-RETURN-002 |             1 | 2026-01-12      | INITIAL_ACCEPTANCE
 ACCEPTED_OCCURRENCES | HSST-RETURN-002 |             2 | 2026-03-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_OCCURRENCES | HSST-RETURN-002 |             3 | 2026-05-20      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_OCCURRENCES | HSST-RETURN-003 |             1 | 2026-02-01      | INITIAL_ACCEPTANCE
 ACCEPTED_OCCURRENCES | HSST-RETURN-003 |             2 | 2026-03-15      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_OCCURRENCES | HSST-RETURN-003 |             3 | 2026-04-22      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_OCCURRENCES | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 ACCEPTED_OCCURRENCES | HSST-RETURN-004 |             1 | 2026-06-05      | INITIAL_ACCEPTANCE
(10 rows)

      section      |    case_code    | occurrence_no | event_date |                resolution_type_code                | return_to_agency_code | decision_number 
-------------------+-----------------+---------------+------------+----------------------------------------------------+-----------------------+-----------------
 RESOLUTION_EVENTS | HSST-RETURN-001 |             1 | 2026-04-15 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-001-1
 RESOLUTION_EVENTS | HSST-RETURN-001 |             2 | 2026-06-20 | TRIAL_JUDGMENT                                     |                       | BA-001-2
 RESOLUTION_EVENTS | HSST-RETURN-002 |             1 | 2026-02-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-1
 RESOLUTION_EVENTS | HSST-RETURN-002 |             2 | 2026-04-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-002-2
 RESOLUTION_EVENTS | HSST-RETURN-002 |             3 | 2026-06-28 | TRIAL_JUDGMENT                                     |                       | BA-002-3
 RESOLUTION_EVENTS | HSST-RETURN-003 |             1 | 2026-02-25 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-1
 RESOLUTION_EVENTS | HSST-RETURN-003 |             2 | 2026-04-05 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-2
 RESOLUTION_EVENTS | HSST-RETURN-003 |             3 | 2026-05-30 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-003-3
 RESOLUTION_EVENTS | HSST-RETURN-004 |             1 | 2026-07-10 | RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION | PROCURACY             | QDT-004-1
(9 rows)

       section       | period_code |    case_code    | occurrence_no | acceptance_date |              acceptance_type_code              
---------------------+-------------+-----------------+---------------+-----------------+------------------------------------------------
 REMAINING_BY_PERIOD | A           | HSST-RETURN-001 |             2 | 2026-05-05      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 REMAINING_BY_PERIOD | A           | HSST-RETURN-002 |             3 | 2026-05-20      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 REMAINING_BY_PERIOD | B           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 REMAINING_BY_PERIOD | B           | HSST-RETURN-004 |             1 | 2026-06-05      | INITIAL_ACCEPTANCE
 REMAINING_BY_PERIOD | C           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 REMAINING_BY_PERIOD | C           | HSST-RETURN-004 |             1 | 2026-06-05      | INITIAL_ACCEPTANCE
 REMAINING_BY_PERIOD | D           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
 REMAINING_BY_PERIOD | E           | HSST-RETURN-003 |             4 | 2026-06-12      | RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION
(8 rows)

 result |                           test_name                            
--------+----------------------------------------------------------------
 PASS   | criminal first-instance return lifecycle occurrence skill test
(1 row)

```

