# Kết quả kiểm tra SQL danh sách án sơ thẩm 01/06/2026 - 12/06/2026

## File SQL

- `tests/sql_checks/list_first_instance_cases_2026_06_01_to_2026_06_12.sql`

## Database kiểm tra

- Database: `qlta_schema_merge_test`
- Lệnh chạy:

```powershell
$env:PGCLIENTENCODING='UTF8'
psql -X --csv -w -d qlta_schema_merge_test -f .\tests\sql_checks\list_first_instance_cases_2026_06_01_to_2026_06_12.sql
```

## Kết quả sau khi bỏ "Nhóm danh sách"

- Tổng số dòng trước khi sửa: `61`
- Tổng số dòng sau khi sửa: `55`
- Output không còn cột `Nhóm danh sách`.
- `STT` chỉ reset theo `Loại án`.
- Kiểm tra duplicate theo `case_id/occurrence_id`: `NO_DUPLICATE`.

Theo loại án:

| Loại án | Số dòng |
|---|---:|
| criminal | 4 |
| Dan su | 15 |
| Hanh chinh | 5 |
| Hinh su | 31 |

Theo cột cờ:

| Cột cờ | Số dòng có `x` |
|---|---:|
| Thụ lý trong kỳ | 6 |
| Giải quyết trong kỳ | 3 |
| Còn lại cuối kỳ | 52 |

## Logic đã thay đổi

Đã bỏ logic tạo ba tập dòng riêng:

- `accepted_rows`
- `resolved_rows`
- `remaining_rows`
- `all_rows` bằng `UNION ALL`

Thay bằng CTE `stat_rows`, trong đó mỗi dòng là một `case_id/occurrence_id` và có ba cột boolean:

- `is_accepted_in_period`
- `is_resolved_in_period`
- `is_remaining_as_of_date`

Output chuyển ba boolean này thành các cột cờ `x`/`NULL`:

- `Thụ lý trong kỳ`
- `Giải quyết trong kỳ`
- `Còn lại cuối kỳ`

## Bảng thực tế đã dùng

- `case_files`
- `case_occurrences`
- `case_resolution_events`
- `dm_category_items`
- `decisions`
- `case_hearing_members`
- `court_staff`
- `criminal_case_details`
- `defendants`
- `charges`
- `participants`
- `civil_case_details`
- `case_legal_relationships`
- `dm_legal_relationships`

## Skill cập nhật

Đã cập nhật:

- `knowledge_base/skills/statistics/skill_first_instance_case_list_by_period.md`

Quy tắc mới: khi yêu cầu gom theo `Loại án`, không tách dòng theo `Nhóm danh sách`; dùng cột cờ để biểu thị thụ lý/giải quyết/còn lại trên cùng một dòng.
