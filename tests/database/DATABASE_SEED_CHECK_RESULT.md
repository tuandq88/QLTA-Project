# Ket qua kiem tra seed database

- Thoi diem kiem tra: 2026-06-10 16:12:32 +07:00
- Database: qlta_schema_merge_test
- ResetDatabase: False
- SeedOnly: False
- PGHOST: localhost
- PGPORT: 5432
- PGUSER: postgres
- Ket qua cuoi: PASSED

## Trang thai tung buoc
- Kiem tra moi truong: PASSED
- Reset database neu duoc yeu cau: SKIPPED
- Chay schema khi reset: SKIPPED
- Chay seed lan 1: PASSED
- Chay seed lan 2: PASSED
- Chay seed test: PASSED

## File da chay
- database/seed/003_reference_data_seed.sql
- database/seed/004_statistical_reference_data_seed.sql
- database/seed/010_legal_seed_data_tand_vietnam.sql
- database/seed/020_excel_seed_case_categories.sql
- database/seed/021_excel_seed_criminal_categories.sql
- database/seed/022_excel_seed_civil_categories.sql
- database/seed/023_excel_seed_administrative_categories.sql
- database/seed/024_excel_seed_labor_business_marriage_categories.sql
- database/seed/025_excel_seed_statistical_indicators.sql
- database/seed/030_excel_seed_case_files.sql
- database/seed/031_excel_seed_case_details.sql
- database/seed/032_excel_seed_case_parties.sql
- database/seed/033_excel_seed_case_events_and_resolutions.sql
- database/seed/034_excel_seed_hearing_members.sql
- database/seed/003_reference_data_seed.sql
- database/seed/004_statistical_reference_data_seed.sql
- database/seed/010_legal_seed_data_tand_vietnam.sql
- database/seed/020_excel_seed_case_categories.sql
- database/seed/021_excel_seed_criminal_categories.sql
- database/seed/022_excel_seed_civil_categories.sql
- database/seed/023_excel_seed_administrative_categories.sql
- database/seed/024_excel_seed_labor_business_marriage_categories.sql
- database/seed/025_excel_seed_statistical_indicators.sql
- database/seed/030_excel_seed_case_files.sql
- database/seed/031_excel_seed_case_details.sql
- database/seed/032_excel_seed_case_parties.sql
- database/seed/033_excel_seed_case_events_and_resolutions.sql
- database/seed/034_excel_seed_hearing_members.sql
- tests/database/seed_data_integrity_test.sql
- tests/database/excel_seed_integrity_test.sql
- tests/database/excel_seed_duplicate_prevention_test.sql
- tests/database/case_file_excel_seed_integrity_test.sql
- tests/database/excel_case_full_import_integrity_test.sql
- tests/database/trial_level_and_hearing_members_integrity_test.sql

## Log PostgreSQL
```text
[Chay seed lan 1 / database/seed/003_reference_data_seed.sql]
INSERT 0 37
INSERT 0 189
INSERT 0 36
[Chay seed lan 1 / database/seed/004_statistical_reference_data_seed.sql]
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
[Chay seed lan 1 / database/seed/010_legal_seed_data_tand_vietnam.sql]
CREATE TABLE
COPY 391
INSERT 0 1
INSERT 0 1
INSERT 0 312
INSERT 0 312
INSERT 0 79
DROP TABLE
[Chay seed lan 1 / database/seed/020_excel_seed_case_categories.sql]
INSERT 0 2
INSERT 0 11
[Chay seed lan 1 / database/seed/021_excel_seed_criminal_categories.sql]
INSERT 0 0
[Chay seed lan 1 / database/seed/022_excel_seed_civil_categories.sql]
INSERT 0 4
[Chay seed lan 1 / database/seed/023_excel_seed_administrative_categories.sql]
INSERT 0 0
[Chay seed lan 1 / database/seed/024_excel_seed_labor_business_marriage_categories.sql]
INSERT 0 4
[Chay seed lan 1 / database/seed/025_excel_seed_statistical_indicators.sql]
INSERT 0 1
INSERT 0 2
INSERT 0 18
[Chay seed lan 1 / database/seed/030_excel_seed_case_files.sql]
BEGIN
INSERT 0 1
INSERT 0 2309
COMMIT
[Chay seed lan 1 / database/seed/031_excel_seed_case_details.sql]
BEGIN
INSERT 0 837
INSERT 0 0
INSERT 0 388
INSERT 0 0
INSERT 0 1084
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
COMMIT
[Chay seed lan 1 / database/seed/032_excel_seed_case_parties.sql]
BEGIN
INSERT 0 0
COMMIT
[Chay seed lan 1 / database/seed/033_excel_seed_case_events_and_resolutions.sql]
BEGIN
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
COMMIT
[Chay seed lan 1 / database/seed/034_excel_seed_hearing_members.sql]
BEGIN
INSERT 0 98
INSERT 0 4954
COMMIT
[Chay seed lan 2 / database/seed/003_reference_data_seed.sql]
INSERT 0 37
INSERT 0 189
INSERT 0 36
[Chay seed lan 2 / database/seed/004_statistical_reference_data_seed.sql]
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
[Chay seed lan 2 / database/seed/010_legal_seed_data_tand_vietnam.sql]
CREATE TABLE
COPY 391
INSERT 0 1
INSERT 0 1
INSERT 0 312
INSERT 0 312
INSERT 0 79
DROP TABLE
[Chay seed lan 2 / database/seed/020_excel_seed_case_categories.sql]
INSERT 0 2
INSERT 0 11
[Chay seed lan 2 / database/seed/021_excel_seed_criminal_categories.sql]
INSERT 0 0
[Chay seed lan 2 / database/seed/022_excel_seed_civil_categories.sql]
INSERT 0 4
[Chay seed lan 2 / database/seed/023_excel_seed_administrative_categories.sql]
INSERT 0 0
[Chay seed lan 2 / database/seed/024_excel_seed_labor_business_marriage_categories.sql]
INSERT 0 4
[Chay seed lan 2 / database/seed/025_excel_seed_statistical_indicators.sql]
INSERT 0 1
INSERT 0 2
INSERT 0 18
[Chay seed lan 2 / database/seed/030_excel_seed_case_files.sql]
BEGIN
INSERT 0 1
INSERT 0 2309
COMMIT
[Chay seed lan 2 / database/seed/031_excel_seed_case_details.sql]
BEGIN
INSERT 0 837
INSERT 0 0
INSERT 0 388
INSERT 0 0
INSERT 0 1084
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
COMMIT
[Chay seed lan 2 / database/seed/032_excel_seed_case_parties.sql]
BEGIN
INSERT 0 0
COMMIT
[Chay seed lan 2 / database/seed/033_excel_seed_case_events_and_resolutions.sql]
BEGIN
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
INSERT 0 0
COMMIT
[Chay seed lan 2 / database/seed/034_excel_seed_hearing_members.sql]
BEGIN
INSERT 0 98
INSERT 0 4954
COMMIT
[Chay seed test / tests/database/seed_data_integrity_test.sql]
BEGIN
DO
DO
DO
DO
DO
ROLLBACK
psql:D:/QLTA-Project/tests/database/seed_data_integrity_test.sql:122: NOTICE:  PASSED: seed_data_integrity_test.sql
DO
[Chay seed test / tests/database/excel_seed_integrity_test.sql]
BEGIN
DO
DO
ROLLBACK
              result              
----------------------------------
 excel_seed_integrity_test passed
(1 row)

[Chay seed test / tests/database/excel_seed_duplicate_prevention_test.sql]
BEGIN
DO
ROLLBACK
                   result                    
---------------------------------------------
 excel_seed_duplicate_prevention_test passed
(1 row)

[Chay seed test / tests/database/case_file_excel_seed_integrity_test.sql]
BEGIN
DO
DO
DO
DO
DO
DO
DO
DO
ROLLBACK
DO
psql:D:/QLTA-Project/tests/database/case_file_excel_seed_integrity_test.sql:179: NOTICE:  PASSED: case_file_excel_seed_integrity_test.sql
[Chay seed test / tests/database/excel_case_full_import_integrity_test.sql]
BEGIN
DO
DO
DO
DO
ROLLBACK
psql:D:/QLTA-Project/tests/database/excel_case_full_import_integrity_test.sql:149: NOTICE:  PASSED: excel_case_full_import_integrity_test.sql
DO
[Chay seed test / tests/database/trial_level_and_hearing_members_integrity_test.sql]
BEGIN
DO
DO
DO
psql:D:/QLTA-Project/tests/database/trial_level_and_hearing_members_integrity_test.sql:198: NOTICE:  CANH BAO DU LIEU NGUON: ho so Excel thieu thu ky: 1228
psql:D:/QLTA-Project/tests/database/trial_level_and_hearing_members_integrity_test.sql:198: NOTICE:  CANH BAO DU LIEU NGUON: so tham co hon 1 PANEL_JUDGE: 15
psql:D:/QLTA-Project/tests/database/trial_level_and_hearing_members_integrity_test.sql:198: NOTICE:  CANH BAO DU LIEU NGUON: phuc tham khong co dung 2 PANEL_JUDGE: 523
psql:D:/QLTA-Project/tests/database/trial_level_and_hearing_members_integrity_test.sql:198: NOTICE:  Chi tiet file/sheet/row nam trong tests/database/EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT.md
DO
ROLLBACK
psql:D:/QLTA-Project/tests/database/trial_level_and_hearing_members_integrity_test.sql:205: NOTICE:  PASSED: trial_level_and_hearing_members_integrity_test.sql
DO
```
