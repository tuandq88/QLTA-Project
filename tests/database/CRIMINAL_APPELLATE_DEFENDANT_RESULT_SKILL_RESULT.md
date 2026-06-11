# CRIMINAL_APPELLATE_DEFENDANT_RESULT_SKILL_RESULT

- Thoi diem kiem tra: 2026-06-11 14:58:44 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- Migration: database/migrations/008_criminal_appellate_defendant_results.sql
- Bang bi cao: defendants
- Bang ket qua phuc tham theo bi cao: criminal_appellate_defendant_results
- Bang tieu chi sua an: criminal_appellate_modify_criteria
- Seed danh muc: database/seed/003_reference_data_seed.sql
- Seed test: database/seed/test/050_test_criminal_appellate_defendant_results.sql
- Skill: knowledge_base/skills/statistics/skill_criminal_appellate_defendant_result_rules.md
- Test SQL: tests/database/test_criminal_appellate_defendant_result_skill.sql

## Ky kiem tra

| Ky | Tu ngay | Den ngay | Ghi chu |
|---|---:|---:|---|
| A | 2026-06-01 | 2026-06-10 | HSPT-001 rut khang cao mot bi cao truoc phien toa, vu van con lai |
| B | 2026-06-01 | 2026-06-30 | HSPT-002, HSPT-004 giai quyet het; HSPT-005 van con lai |
| C | 2026-07-01 | 2026-07-31 | HSPT-003 giai quyet trong thang 7 |
| D | 2026-06-01 | 2026-07-31 | Kiem tra tong hop hai thang |

## Expected vs actual chinh

| Ho so | Ky | Expected |
|---|---|---|
| HSPT-001 | A | defendant_resolved=1, defendant_remaining=2, case_resolved=0, case_remaining=1 |
| HSPT-002 | B | termination=2, uphold=1, modify=1, case_resolved=1, case_remaining=0 |
| HSPT-003 | B/C | B con lai=1; C resolved=1, cancel=1, modify=1 |
| HSPT-004 | B | termination_at_hearing=1, case_resolved=1 |
| HSPT-005 | B | uphold=1, modify=1, case_resolved=0, case_remaining=1 |

## Nguyen tac da kiem tra

- Ket qua phuc tham duoc ghi theo tung defendant_id, khong gan chung cho case_id.
- Vu an chi duoc tinh da giai quyet khi tat ca bi cao trong pham vi phuc tham co final result den ngay chot.
- Bi cao rut khang cao/khang nghi truoc phien toa duoc tinh la bi cao da giai quyet nhom dinh chi nhung khong lam ca vu an giai quyet neu con bi cao chua co ket qua.
- Mot bi cao khong duoc co hon mot final result trong cung case_id.
- Ket qua sua an phai luu duoc tieu chi sua an trong criminal_appellate_modify_criteria.

## Lenh chay lai

```powershell
.\tests\database\run_criminal_appellate_defendant_result_skill_check.ps1 -DatabaseName qlta_schema_merge_test
```

## Log chi tiet

### migration 008

- Exit code: 0

```text
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:4: NOTICE:  extension "uuid-ossp" already exists, skipping
CREATE EXTENSION
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:52: NOTICE:  relation "criminal_appellate_defendant_results" already exists, skipping
CREATE TABLE
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:56: NOTICE:  relation "uq_criminal_appellate_defendant_final_result" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:77: NOTICE:  relation "criminal_appellate_modify_criteria" already exists, skipping
CREATE TABLE
DO
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:107: NOTICE:  relation "idx_criminal_appellate_results_case_date" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:109: NOTICE:  relation "idx_criminal_appellate_results_defendant" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:111: NOTICE:  relation "idx_criminal_appellate_results_type_date" already exists, skipping
CREATE INDEX
psql:D:/QLTA-Project/database/migrations/008_criminal_appellate_defendant_results.sql:113: NOTICE:  relation "idx_criminal_appellate_modify_criteria_result" already exists, skipping
CREATE INDEX
```

### seed 003 reference data

- Exit code: 0

```text
INSERT 0 45
INSERT 0 216
INSERT 0 43
```

### seed 050 test appellate defendant results

- Exit code: 0

```text
INSERT 0 1
INSERT 0 5
INSERT 0 5
INSERT 0 13
INSERT 0 10
INSERT 0 6
UPDATE 10
UPDATE 10
UPDATE 10
UPDATE 6
```

### test appellate defendant result skill

- Exit code: 0

```text
psql:D:/QLTA-Project/tests/database/test_criminal_appellate_defendant_result_skill.sql:7: NOTICE:  table "tmp_hspt_periods" does not exist, skipping
DROP TABLE
CREATE TABLE
INSERT 0 4
psql:D:/QLTA-Project/tests/database/test_criminal_appellate_defendant_result_skill.sql:21: NOTICE:  table "tmp_hspt_cases" does not exist, skipping
DROP TABLE
SELECT 5
psql:D:/QLTA-Project/tests/database/test_criminal_appellate_defendant_result_skill.sql:29: NOTICE:  table "tmp_hspt_defendants" does not exist, skipping
DROP TABLE
SELECT 13
psql:D:/QLTA-Project/tests/database/test_criminal_appellate_defendant_result_skill.sql:40: NOTICE:  table "tmp_hspt_case_status" does not exist, skipping
DROP TABLE
SELECT 20
DROP TABLE
psql:D:/QLTA-Project/tests/database/test_criminal_appellate_defendant_result_skill.sql:79: NOTICE:  table "tmp_hspt_case_result_counts" does not exist, skipping
SELECT 12
DROP TABLE
psql:D:/QLTA-Project/tests/database/test_criminal_appellate_defendant_result_skill.sql:97: NOTICE:  table "tmp_hspt_expected" does not exist, skipping
CREATE TABLE
INSERT 0 19
DO
      section       |               check_name                | expected_value | actual_value | result 
--------------------+-----------------------------------------+----------------+--------------+--------
 EXPECTED_VS_ACTUAL | A_HSPT_001_case_remaining_count         |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | A_HSPT_001_case_resolved_count          |              0 |            0 | PASS
 EXPECTED_VS_ACTUAL | A_HSPT_001_defendant_remaining_count    |              2 |            2 | PASS
 EXPECTED_VS_ACTUAL | A_HSPT_001_defendant_resolved_count     |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_002_case_remaining_count         |              0 |            0 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_002_case_resolved_count          |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_002_modify_defendant_count       |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_002_termination_defendant_count  |              2 |            2 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_002_uphold_defendant_count       |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_003_case_remaining_count         |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_004_case_resolved_count          |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_004_termination_at_hearing_count |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_005_case_remaining_count         |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_005_case_resolved_count          |              0 |            0 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_005_modify_defendant_count       |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | B_HSPT_005_uphold_defendant_count       |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | C_HSPT_003_cancel_defendant_count       |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | C_HSPT_003_case_resolved_count          |              1 |            1 | PASS
 EXPECTED_VS_ACTUAL | C_HSPT_003_modify_defendant_count       |              1 |            1 | PASS
(19 rows)

      section      | period_code | case_code | total_defendant_count | defendant_resolved_count | defendant_remaining_count | case_resolved_count | case_remaining_count 
-------------------+-------------+-----------+-----------------------+--------------------------+---------------------------+---------------------+----------------------
 CASE_STATUS_AS_OF | A           | HSPT-001  |                     3 |                        1 |                         2 |                   0 |                    1
 CASE_STATUS_AS_OF | A           | HSPT-002  |                     4 |                        1 |                         3 |                   0 |                    1
 CASE_STATUS_AS_OF | A           | HSPT-003  |                     2 |                        0 |                         2 |                   0 |                    1
 CASE_STATUS_AS_OF | A           | HSPT-004  |                     1 |                        0 |                         1 |                   0 |                    1
 CASE_STATUS_AS_OF | A           | HSPT-005  |                     3 |                        0 |                         3 |                   0 |                    1
 CASE_STATUS_AS_OF | B           | HSPT-001  |                     3 |                        1 |                         2 |                   0 |                    1
 CASE_STATUS_AS_OF | B           | HSPT-002  |                     4 |                        4 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | B           | HSPT-003  |                     2 |                        0 |                         2 |                   0 |                    1
 CASE_STATUS_AS_OF | B           | HSPT-004  |                     1 |                        1 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | B           | HSPT-005  |                     3 |                        2 |                         1 |                   0 |                    1
 CASE_STATUS_AS_OF | C           | HSPT-001  |                     3 |                        1 |                         2 |                   0 |                    1
 CASE_STATUS_AS_OF | C           | HSPT-002  |                     4 |                        4 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | C           | HSPT-003  |                     2 |                        2 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | C           | HSPT-004  |                     1 |                        1 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | C           | HSPT-005  |                     3 |                        2 |                         1 |                   0 |                    1
 CASE_STATUS_AS_OF | D           | HSPT-001  |                     3 |                        1 |                         2 |                   0 |                    1
 CASE_STATUS_AS_OF | D           | HSPT-002  |                     4 |                        4 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | D           | HSPT-003  |                     2 |                        2 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | D           | HSPT-004  |                     1 |                        1 |                         0 |                   1 |                    0
 CASE_STATUS_AS_OF | D           | HSPT-005  |                     3 |                        2 |                         1 |                   0 |                    1
(20 rows)

      section      | case_code |     full_name     | decision_stage_code | result_group_code |         result_type_code         | result_date |               modify_criteria               
-------------------+-----------+-------------------+---------------------+-------------------+----------------------------------+-------------+---------------------------------------------
 DEFENDANT_RESULTS | HSPT-001  | HSPT 001 Bi cao 1 | BEFORE_HEARING      | TERMINATION       | WITHDRAWAL_BEFORE_HEARING        | 2026-06-05  | 
 DEFENDANT_RESULTS | HSPT-001  | HSPT 001 Bi cao 2 |                     |                   |                                  |             | 
 DEFENDANT_RESULTS | HSPT-001  | HSPT 001 Bi cao 3 |                     |                   |                                  |             | 
 DEFENDANT_RESULTS | HSPT-002  | HSPT 002 Bi cao 1 | BEFORE_HEARING      | TERMINATION       | WITHDRAWAL_BEFORE_HEARING        | 2026-06-03  | 
 DEFENDANT_RESULTS | HSPT-002  | HSPT 002 Bi cao 2 | AT_HEARING          | TERMINATION       | WITHDRAWAL_AT_HEARING            | 2026-06-12  | 
 DEFENDANT_RESULTS | HSPT-002  | HSPT 002 Bi cao 3 | AT_HEARING          | TRIAL             | UPHOLD_FIRST_INSTANCE            | 2026-06-12  | 
 DEFENDANT_RESULTS | HSPT-002  | HSPT 002 Bi cao 4 | AT_HEARING          | TRIAL             | MODIFY_FIRST_INSTANCE_SUBJECTIVE | 2026-06-12  | REDUCE_PENALTY, SUSPENDED_SENTENCE_GRANTED
 DEFENDANT_RESULTS | HSPT-003  | HSPT 003 Bi cao 1 | AT_HEARING          | TRIAL             | CANCEL_FIRST_INSTANCE_OBJECTIVE  | 2026-07-05  | 
 DEFENDANT_RESULTS | HSPT-003  | HSPT 003 Bi cao 2 | AT_HEARING          | TRIAL             | MODIFY_FIRST_INSTANCE_OBJECTIVE  | 2026-07-05  | CHANGE_CHARGE, CHANGE_TO_LIGHTER_PENALTY
 DEFENDANT_RESULTS | HSPT-004  | HSPT 004 Bi cao 1 | AT_HEARING          | TERMINATION       | OTHER_TERMINATION                | 2026-06-20  | 
 DEFENDANT_RESULTS | HSPT-005  | HSPT 005 Bi cao 1 | AT_HEARING          | TRIAL             | UPHOLD_FIRST_INSTANCE            | 2026-06-18  | 
 DEFENDANT_RESULTS | HSPT-005  | HSPT 005 Bi cao 2 | AT_HEARING          | TRIAL             | MODIFY_FIRST_INSTANCE_SUBJECTIVE | 2026-06-18  | CHANGE_TO_HEAVIER_PENALTY, INCREASE_PENALTY
 DEFENDANT_RESULTS | HSPT-005  | HSPT 005 Bi cao 3 |                     |                   |                                  |             | 
(13 rows)

 result |                      test_name                       
--------+------------------------------------------------------
 PASS   | criminal appellate defendant-level result skill test
(1 row)

```

