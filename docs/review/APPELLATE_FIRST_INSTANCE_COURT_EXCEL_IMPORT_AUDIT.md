# Audit import cột "Tòa án xét xử sơ thẩm" của án phúc thẩm

## Phạm vi

- Nguồn Excel: `database/seed/danh_sach/Hình sự - Phúc thẩm.xlsx`
- Nguồn Excel: `database/seed/danh_sach/Dân sự mở rộng - Phúc thẩm.xlsx`
- Generator: `database/seed/generate_excel_case_full_import.py`
- Seed sinh ra: `database/seed/030_excel_seed_case_files.sql`
- Schema: `case_files`, `courts`
- Query kiểm chứng: `tests/sql_checks/list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql`

## Kết luận ngắn

Cột Excel không bị thiếu trong file nguồn. Nguyên nhân là luồng seed cũ đã đọc được cột `Tòa án xét xử sơ thẩm` vào `SourceRow.first_instance_court` nhưng seed `030_excel_seed_case_files.sql` chưa ghi giá trị này vào database vì schema/generator trước đó chưa có đích `case_files.first_instance_court_id`. Kết quả cũ là án phúc thẩm chỉ có `case_files.court_id` trỏ về tòa phúc thẩm/current court `EXCEL_SEED_TAND_QNG`, làm query không thể group đúng theo tòa sơ thẩm.

Đã sửa bằng cách bổ sung schema, generator, seed và test để cột Excel đi tới `case_files.first_instance_court_id`.

## Bằng chứng từ Excel

Audit đọc trực tiếp bằng `openpyxl`, `data_only=True`.

| File | Sheet | Header row | Cột | Dòng có giá trị | Số giá trị khác nhau |
|---|---|---:|---:|---:|---:|
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 3 | 13 - `Tòa án xét xử sơ thẩm` | 552 | 22 |
| `Hình sự - Phúc thẩm.xlsx` | `Projects 3` | 3 | 14 - `Tòa án xét xử Sơ thẩm` | 575 | 26 |

Giá trị mẫu có trong Excel:

- `Tòa án nhân dân khu vực 1 - Quảng Ngãi`
- `Tòa án nhân dân khu vực 10 - Quảng Ngãi`
- `Tòa án nhân dân khu vực 11 - Quảng Ngãi`
- `Tòa án nhân dân khu vực 2 - Quảng Ngãi`
- `Tòa án nhân dân khu vực 3 - Quảng Ngãi`
- `Tòa án nhân dân huyện Bình Sơn`
- `Tòa án nhân dân huyện Sơn Tịnh`
- `Thành phố Quảng Ngãi`
- `Thành phố Kon Tum`
- `Thị xã Đức Phổ`

Tổng số dòng phúc thẩm Excel có giá trị tòa sơ thẩm: `1127`.

## Nguyên nhân kỹ thuật

Trước khi sửa:

- `SourceRow` có trường `first_instance_court`.
- `read_source_row` đã đọc `values.get("Tòa án xét xử sơ thẩm")` hoặc `values.get("Tòa án xét xử Sơ thẩm")`.
- Seed cũ `030_excel_seed_case_files.sql` không có cột `first_instance_court_id`.
- Seed cũ chỉ insert court `EXCEL_SEED_TAND_QNG` và dùng court này cho `case_files.court_id`.
- Vì không có `first_instance_court_id`, query thống kê phúc thẩm không có dữ liệu thật để group theo tòa sơ thẩm; nếu fallback sang `court_id` sẽ đếm sai thành tòa phúc thẩm/current court.

## Thay đổi đã thực hiện

- Thêm migration `database/migrations/009_appellate_first_instance_court.sql`.
- Cập nhật `database/schema/unified_postgresql_schema.sql` với:
  - `case_files.first_instance_court_id`
  - `case_files.first_instance_case_number`
  - `case_files.first_instance_judgment_number`
  - `case_files.first_instance_judgment_date`
  - FK `case_files.first_instance_court_id -> courts.court_id`
- Cập nhật `database/seed/generate_excel_case_full_import.py`:
  - ghi `first_instance_court_code`, `first_instance_court_name`, `first_instance_court_level` vào `source_rows`;
  - tạo court alias deterministic `EXCEL_FIRST_INSTANCE_*` khi Excel có tòa sơ thẩm chưa tồn tại;
  - map `khu vực` thành `regional`;
  - map `huyện`, `thành phố`, `thị xã` thành `district`;
  - giới hạn `court_code` tối đa 50 ký tự kèm hash để phù hợp schema;
  - insert/update `case_files.first_instance_court_id`.
- Regenerate `database/seed/030_excel_seed_case_files.sql`.
- Cập nhật query danh sách phúc thẩm để chỉ dùng `case_files.first_instance_court_id` cho tòa sơ thẩm và cảnh báo nếu thiếu.
- Thêm skill `knowledge_base/skills/core/skill_excel_case_import.md`.

## Kết quả seed kiểm chứng

Sau khi chạy lại seed trên `qlta_schema_merge_test`:

| Chỉ tiêu | Kết quả |
|---|---:|
| Dòng phúc thẩm Excel | 1127 |
| Dòng phúc thẩm Excel thiếu `first_instance_court_id` | 0 |
| Số tòa sơ thẩm khác nhau từ Excel | 27 |
| Số tòa `regional` khác nhau | 11 |
| Số tòa `district` khác nhau | 16 |
| Tổng án phúc thẩm trong DB thiếu `first_instance_court_id` sau seed/check hiện tại | 0 |

Nhóm lớn nhất từ Excel:

| Tòa án sơ thẩm | Level | Số dòng |
|---|---|---:|
| Tòa án nhân dân khu vực 1 - Quảng Ngãi | regional | 263 |
| Tòa án nhân dân khu vực 6 - Quảng Ngãi | regional | 138 |
| Tòa án nhân dân khu vực 4 - Quảng Ngãi | regional | 131 |
| Tòa án nhân dân huyện Bình Sơn | district | 97 |
| Thành phố Quảng Ngãi | district | 90 |

## Kết quả query danh sách kỳ 01/06/2026 - 12/06/2026

File result đã cập nhật: `tests/sql_checks/LIST_APPELLATE_CASES_BY_FIRST_INSTANCE_COURT_AND_CASE_TYPE_2026_06_01_TO_2026_06_12_RESULT.md`.

| Chỉ tiêu | Kết quả |
|---|---:|
| Tổng số dòng | 577 |
| Số nhóm tòa sơ thẩm | 25 |
| Số loại án | 6 |
| Dòng thiếu/cảnh báo tòa sơ thẩm | 0 |
| Thụ lý trong kỳ | 11 |
| Giải quyết trong kỳ | 2 |
| Còn lại cuối kỳ | 575 |

## Test đã thêm

- `tests/database/appellate_first_instance_court_excel_import_test.sql`
- `tests/database/run_appellate_first_instance_court_excel_import_check.ps1`

Test kiểm tra:

- có đúng `1127` dòng phúc thẩm Excel;
- không dòng nào thiếu `first_instance_court_id`;
- `first_instance_court_id` join được `courts`;
- có tối thiểu 26 tòa sơ thẩm khác nhau;
- có cả `regional` và `district`;
- không collapse `first_instance_court_id = court_id`.

Kết quả chạy:

```powershell
.\tests\database\run_appellate_first_instance_court_excel_import_check.ps1 -DatabaseName qlta_schema_merge_test
```

Kết quả: `PASSED`.

## Ghi chú cần kiểm tra nghiệp vụ

Các court alias lấy trực tiếp từ Excel là dữ liệu nguồn phục vụ seed/test. Tên `Thành phố Kon Tum`, `Tòa án nhân dân huyện Đắk Tô`, `Tòa án nhân dân huyện Ia H'Drai`, `Tòa án nhân dân huyện Kon Rẫy`, `Tòa án nhân dân huyện Ngọc Hồi`, `Tòa án nhân dân huyện Sa Thầy` xuất hiện trong Excel nên được giữ nguyên, không tự sửa. Khi đưa vào production cần map alias này với danh mục tòa án chính thức nếu có bảng chuẩn.
