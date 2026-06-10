# Ket qua kiem tra cap xet xu va thanh phan phien toa

- Thoi diem kiem tra: 2026-06-10 16:12:40 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- PGHOST: localhost
- PGPORT: 5432
- PGUSER: postgres

## Log
```text
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
