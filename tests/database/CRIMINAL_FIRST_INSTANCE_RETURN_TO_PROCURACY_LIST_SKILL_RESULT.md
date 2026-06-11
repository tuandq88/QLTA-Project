# CRIMINAL_FIRST_INSTANCE_RETURN_TO_PROCURACY_LIST_SKILL_RESULT

- Thoi diem kiem tra: 2026-06-11 09:34:35 +07:00
- Database: qlta_schema_merge_test
- Ket qua: PASSED
- Skill da tao/cap nhat: knowledge_base/skills/statistics/skill_criminal_first_instance_return_to_procuracy_list.md
- Schema hien tai co occurrence/event day du: Co sau migration 007_case_occurrences_and_resolution_events.sql
- Migration da tao: database/migrations/007_case_occurrences_and_resolution_events.sql
- Danh muc can co: HINH_SU/criminal, SO_THAM, INITIAL_ACCEPTANCE, RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION, RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION, TRIAL_JUDGMENT, PROCURACY/VIEN_KIEM_SAT, OCCURRENCE.
- Test da tao: tests/database/criminal_return_to_procuracy_occurrence_logic_test.sql

## Giai thich vi du vu an A

- Ky 2026-03-01 den 2026-06-30: accepted_count = 2, resolved_count = 2, remaining_count = 0, return_to_procuracy_list_count = 1.
- Ky 2026-03-01 den 2026-05-31: accepted_count = 2, resolved_count = 1, remaining_count = 1, return_to_procuracy_list_count = 1.
- Test dung bang tam de chung minh don vi dung la occurrence/event, khong phai distinct case_id.

## Lenh chay lai

```powershell
.\tests\database\run_criminal_return_to_procuracy_occurrence_logic_check.ps1 -DatabaseName qlta_schema_merge_test
```

## Diem con thieu

- Test nay dung bang tam de bao ve logic toi thieu; test lifecycle nhieu ky dung bang that nam trong tests/database/run_criminal_return_lifecycle_skill_check.ps1.
- case_files.acceptance_date va case_files.closed_date chi du cho timeline don, khong du thay the occurrence/event.

## Log
```text
BEGIN
CREATE TABLE
CREATE TABLE
CREATE TABLE
INSERT 0 1
INSERT 0 2
INSERT 0 2
DO
DO
ROLLBACK
DO
psql:D:/QLTA-Project/tests/database/criminal_return_to_procuracy_occurrence_logic_test.sql:277: NOTICE:  PASSED: criminal_return_to_procuracy_occurrence_logic_test.sql
```
