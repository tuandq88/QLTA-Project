# Káº¿t quáº£ kiá»ƒm tra PostgreSQL trá»‘ng

- Thá»i Ä‘iá»ƒm kiá»ƒm tra: 2026-06-09 18:45:19 +07:00
- Database test: qlta_schema_merge_test
- Cháº¿ Ä‘á»™: UnifiedOnly
- PGHOST: localhost
- PGPORT: 5432
- PGUSER: postgres
- SkipSeed: False
- SkipTests: False
- Káº¿t quáº£ cuá»‘i: PASSED

## Tráº¡ng thÃ¡i tá»«ng bÆ°á»›c
- Kiem tra moi truong: PASSED
- Tao lai database test: PASSED
- Chay unified schema: PASSED
- Chay migrations: SKIPPED
- Chay seed: PASSED
- Chay SQL test: PASSED

## File Ä‘Ã£ cháº¡y
- database/schema/unified_postgresql_schema.sql
- database/seed/003_reference_data_seed.sql
- database/seed/004_statistical_reference_data_seed.sql
- database/seed/010_legal_seed_data_tand_vietnam.sql
- database/seed/020_excel_seed_case_categories.sql
- database/seed/021_excel_seed_criminal_categories.sql
- database/seed/022_excel_seed_civil_categories.sql
- database/seed/023_excel_seed_administrative_categories.sql
- database/seed/024_excel_seed_labor_business_marriage_categories.sql
- database/seed/025_excel_seed_statistical_indicators.sql
- tests/database/database_structure_integrity_test.sql
- tests/database/seed_data_integrity_test.sql
- tests/database/statistics_algorithm_precheck.sql

## File Ä‘Ã£ bá» qua
- KhÃ´ng cÃ³

## Ghi chÃº cháº¡y psql
- CÃ¢u lá»‡nh SQL cháº¡y báº±ng -c.
- File SQL cháº¡y báº±ng -f.
- Script khÃ´ng dÃ¹ng tham sá»‘ -i.
- NOTICE/WARNING cá»§a PostgreSQL chá»‰ Ä‘Æ°á»£c ghi log; chá»‰ exit code khÃ¡c 0 má»›i lÃ m fail.

## Log PostgreSQL
```text
[Tao lai database test / postgres]
 ?column? 
----------
        1
(1 row)

[Tao lai database test / drop force]
DROP DATABASE
[Tao lai database test / postgres]
CREATE DATABASE
[Chay unified schema / database/schema/unified_postgresql_schema.sql]
CREATE EXTENSION
DO
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
ALTER TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE FUNCTION
DO
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
DO
DO
DO
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
[Chay seed / database/seed/003_reference_data_seed.sql]
INSERT 0 36
INSERT 0 184
INSERT 0 35
[Chay seed / database/seed/004_statistical_reference_data_seed.sql]
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
[Chay seed / database/seed/010_legal_seed_data_tand_vietnam.sql]
CREATE TABLE
COPY 391
INSERT 0 1
INSERT 0 1
INSERT 0 312
INSERT 0 312
INSERT 0 79
DROP TABLE
[Chay seed / database/seed/020_excel_seed_case_categories.sql]
INSERT 0 2
INSERT 0 11
[Chay seed / database/seed/021_excel_seed_criminal_categories.sql]
INSERT 0 10
[Chay seed / database/seed/022_excel_seed_civil_categories.sql]
INSERT 0 242
[Chay seed / database/seed/023_excel_seed_administrative_categories.sql]
INSERT 0 34
[Chay seed / database/seed/024_excel_seed_labor_business_marriage_categories.sql]
INSERT 0 63
[Chay seed / database/seed/025_excel_seed_statistical_indicators.sql]
INSERT 0 1
INSERT 0 2
INSERT 0 18
[Chay SQL test / tests/database/database_structure_integrity_test.sql]
BEGIN
DO
DO
DO
DO
ROLLBACK
psql:D:/QLTA-Project/tests/database/database_structure_integrity_test.sql:178: NOTICE:  PASSED: database_structure_integrity_test.sql
DO
[Chay SQL test / tests/database/seed_data_integrity_test.sql]
BEGIN
DO
DO
DO
DO
DO
ROLLBACK
DO
psql:D:/QLTA-Project/tests/database/seed_data_integrity_test.sql:122: NOTICE:  PASSED: seed_data_integrity_test.sql
[Chay SQL test / tests/database/statistics_algorithm_precheck.sql]
BEGIN
DO
DO
DO
DO
DO
DO
ROLLBACK
psql:D:/QLTA-Project/tests/database/statistics_algorithm_precheck.sql:167: NOTICE:  PASSED: statistics_algorithm_precheck.sql
DO
```
