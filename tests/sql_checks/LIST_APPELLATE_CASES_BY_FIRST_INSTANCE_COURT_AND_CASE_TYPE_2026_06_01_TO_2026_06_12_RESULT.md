# Kết quả kiểm tra SQL danh sách án phúc thẩm 01/06/2026 - 12/06/2026

## File SQL

- `tests/sql_checks/list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql`

## Database kiểm tra

- Database: `qlta_schema_merge_test`
- Lệnh chạy:

```powershell
$env:PGCLIENTENCODING='UTF8'
psql -X -w -d qlta_schema_merge_test -f .\tests\sql_checks\list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql
```

## Kết quả sau khi import kết quả XXPT từ Excel

- Test: `PASS`
- Tổng số dòng: `291`
- Số nhóm tòa án sơ thẩm hiển thị: `18`
- Số loại án có dữ liệu: `5`
- Số dòng có cảnh báo dữ liệu: `3`
- Cảnh báo dữ liệu: `XXPT_RESULT_WITHOUT_DATE`
- Duplicate theo `case_id/occurrence_id`: `0`

Theo cột cờ:

| Cột cờ | Số dòng có `x` |
|---|---:|
| Thụ lý trong kỳ | 10 |
| Giải quyết trong kỳ | 4 |
| Còn lại cuối kỳ | 287 |

Theo kết quả XXPT đã import:

| Chỉ tiêu | Số dòng |
|---|---:|
| Dòng trong danh sách kỳ có `Kết quả XXPT` từ Excel | 7 |
| Dòng có `Kết quả XXPT` và ngày giải quyết trong kỳ | 4 |
| Dòng có `Kết quả XXPT` nhưng thiếu ngày hợp lệ | 3 |
| Dòng có `Kết quả XXPT` bị hiển thị thành `Chưa giải quyết` | 0 |

Theo tòa án xét xử sơ thẩm trong danh sách kỳ:

| Tòa án xét xử sơ thẩm | Số dòng |
|---|---:|
| Tòa án nhân dân khu vực 1 - Quảng Ngãi | 54 |
| Tòa án nhân dân khu vực 6 - Quảng Ngãi | 39 |
| Thành phố Quảng Ngãi | 37 |
| Tòa án nhân dân khu vực 2 - Quảng Ngãi | 36 |
| Tòa án nhân dân huyện Bình Sơn | 29 |
| Tòa án nhân dân khu vực 4 - Quảng Ngãi | 25 |
| Tòa án nhân dân khu vực 5 - Quảng Ngãi | 14 |
| Tòa án nhân dân khu vực 9 - Quảng Ngãi | 13 |
| Tòa án nhân dân khu vực 7 - Quảng Ngãi | 12 |
| Tòa án nhân dân huyện Sơn Tịnh | 11 |
| Tòa án nhân dân khu vực 3 - Quảng Ngãi | 7 |
| Thị xã Đức Phổ | 3 |
| Tòa án nhân dân khu vực 11 - Quảng Ngãi | 3 |
| Tòa án nhân dân huyện Sơn Hà | 2 |
| Tòa án nhân dân huyện Trà Bồng | 2 |
| Tòa án nhân dân khu vực 8 - Quảng Ngãi | 2 |
| Tòa án nhân dân huyện Nghĩa Hành | 1 |
| Tòa án nhân dân huyện Tư Nghĩa | 1 |

Theo loại án:

| Loại án | Số dòng |
|---|---:|
| Dân sự | 38 |
| Hôn nhân gia đình | 5 |
| Kinh doanh thương mại | 8 |
| Hình sự | 239 |
| Hành chính | 1 |

## Bảng/cột thực tế đã dùng

- Hồ sơ chính: `case_files.case_id`, `case_code`, `case_number`, `case_type`, `case_type_id`, `case_group`, `case_group_id`, `court_id`, `first_instance_court_id`, `acceptance_date`, `closed_date`, `resolution_status`, `case_status`, `summary`.
- Kết quả XXPT từ Excel: `decisions.result_summary`, `decisions.result_code`, `decisions.decision_date`; khi có tracking thì thêm `appellate_results.summary`, `appellate_results.result_code`, `appellate_results.result_date`.
- Cấp phúc thẩm: `case_files.case_group = 'PHUC_THAM'` hoặc `case_group_id -> dm_category_items.item_code = 'PHUC_THAM'`.
- Tòa án sơ thẩm: `case_files.first_instance_court_id -> courts.court_id`.
- Kết quả hình sự phúc thẩm theo bị cáo: `criminal_appellate_defendant_results`, nếu có dữ liệu đầy đủ.

## Thay đổi quan trọng

SQL không hiển thị `Chưa giải quyết` nếu dòng đã import được `Kết quả XXPT` từ Excel. Nếu có result text nhưng thiếu ngày giải quyết hợp lệ, SQL hiển thị result text và gắn cảnh báo `XXPT_RESULT_WITHOUT_DATE`.

Các vụ đã có `Kết quả XXPT` và ngày giải quyết trước 01/06/2026 không còn bị tính là `Còn lại cuối kỳ`, nên tổng dòng danh sách kỳ giảm từ kết quả cũ xuống `291`.
