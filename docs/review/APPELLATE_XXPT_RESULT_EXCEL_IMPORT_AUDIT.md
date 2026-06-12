# Audit import cột "Kết quả XXPT" của án phúc thẩm

## Phạm vi

- `database/seed/danh_sach/Dân sự mở rộng - Phúc thẩm.xlsx`
- `database/seed/danh_sach/Hình sự - Phúc thẩm.xlsx`
- `database/seed/generate_excel_case_full_import.py`
- `database/seed/030_excel_seed_case_files.sql`
- `database/seed/033_excel_seed_case_events_and_resolutions.sql`
- `tests/sql_checks/list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql`

## Kết luận

Cột `Kết quả XXPT` có tồn tại và có dữ liệu trong cả hai file Excel phúc thẩm. Generator trước khi sửa đã đọc cột này vào `SourceRow.result_text` và seed vào `decisions.result_summary`/`appellate_results.summary`, nhưng lỗi phát sinh ở hai điểm:

1. Với `Dân sự mở rộng - Phúc thẩm.xlsx`, generator không dùng cột `Ngày xử` làm `decision_date/closed_date` dù dòng đã có `Kết quả XXPT`. Vì vậy nhiều vụ có kết quả nhưng `case_files.closed_date` vẫn `NULL`.
2. SQL list chỉ hiển thị `Kết quả giải quyết` khi vụ án được tính là `is_resolved_in_period`; nếu vụ còn lại cuối kỳ hoặc thiếu ngày, SQL ép thành `Chưa giải quyết` dù `decisions.result_summary` đã có `Kết quả XXPT`.

Đã sửa generator và SQL list để kết quả XXPT được lưu/hiển thị đúng, đồng thời cảnh báo các dòng có result text nhưng thiếu ngày hợp lệ.

## Audit trực tiếp Excel

| File | Sheet | Header row | Cột match | Dòng dữ liệu | Dòng có `Kết quả XXPT` | Distinct |
|---|---|---:|---|---:|---:|---:|
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 3 | Cột 15 - `Kết quả XXPT` | 552 | 505 | 13 |
| `Hình sự - Phúc thẩm.xlsx` | `Projects 3` | 3 | Cột 15 - `Kết quả XXPT` | 575 | 338 | 6 |

Tổng dòng Excel phúc thẩm có `Kết quả XXPT`: `843`.

Distinct values chính:

- `Giữ nguyên bản án, quyết định sơ thẩm`
- `Giữ nguyên bản án, quyết định sơ thẩm;`
- `Giữ nguyên quyết định của Tòa án cấp sơ thẩm`
- `Sửa một phần bản án, quyết định sơ thẩm`
- `Sửa toàn bộ bản án, quyết định sơ thẩm`
- `Sửa quyết định của Tòa án cấp sơ thẩm`
- `Hủy bản án, quyết định sơ thẩm và đình chỉ giải quyết vụ án`
- `Hủy bản án, quyết định sơ thẩm để điều tra lại`
- `Hủy một phần bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm`
- `Hủy toàn bộ bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm`
- `Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án`
- `Quyết định huỷ bản án sơ thẩm và đình chỉ giải quyết vụ án dân sự`
- `Quyết định huỷ bản án sơ thẩm và đình chỉ giải quyết vụ án hành chính`
- `Quyết định phúc thẩm giải quyết việc dân sự`
- `QĐ đình chỉ`
- `QĐ đình chỉ;`

Header ngày liên quan:

- Dân sự mở rộng phúc thẩm: `Ngày xử`, `Số/Ngày TL`, `Số BA/QĐ ST`, `Ngày BA/QĐ ST`.
- Hình sự phúc thẩm: `Số BA/QĐ PT`, `Ngày BA/QĐ PT`, `Số/Ngày TL`.

## Đối chiếu generator trước khi sửa

Generator có đọc cột:

- Hình sự phúc thẩm: `result = values.get("Kết quả XXPT")`
- Dân sự mở rộng phúc thẩm: `result = values.get("Kết quả XXPT")`

Generator map vào:

- `SourceRow.result_text`
- `decisions.result_summary`
- `decisions.result_code` qua `appellate_result_code`
- `appellate_trackings.final_result_code`
- `appellate_results.summary/result_code`

Điểm sai:

- Dân sự phúc thẩm đặt `decision_date = None`, chỉ lưu `Ngày xử` vào `hearing_date`.
- `case_files.closed_date` chỉ lấy `r.decision_date`, nên dân sự phúc thẩm có result nhưng vẫn chưa có ngày giải quyết.
- Seed `033` trước đó chỉ insert decision nếu chưa tồn tại, không update decision cũ khi generator đã có ngày/kết quả mới.
- SQL list ưu tiên logic resolved-in-period; với dòng còn lại cuối kỳ thì hiển thị `Chưa giải quyết` thay vì result text đã import.

## Schema đích

Schema hiện tại đã đủ nơi lưu kết quả XXPT ở mức tối thiểu:

- `decisions.result_summary`
- `decisions.result_code`
- `decisions.decision_date`
- `case_files.closed_date`
- `appellate_results.summary`
- `appellate_results.result_code`
- `appellate_results.result_date`

Với hình sự phúc thẩm, schema còn có `criminal_appellate_defendant_results` để lưu kết quả theo từng bị cáo. File Excel hiện đang có `Kết quả XXPT` ở mức dòng/vụ án; không đủ để tự tách kết quả theo từng bị cáo nếu một vụ có nhiều bị cáo và kết quả khác nhau. Vì vậy import tối thiểu dùng case-level result text; defendant-level chỉ dùng khi có dữ liệu rõ theo bị cáo.

## Thay đổi đã thực hiện

- `database/seed/generate_excel_case_full_import.py`
  - Thêm `resolved_date_for_case`.
  - Với dân sự mở rộng phúc thẩm, nếu có `Kết quả XXPT` thì dùng `Ngày xử` làm `decision_date`.
  - `case_files.closed_date` lấy từ ngày giải quyết hợp lệ thay vì chỉ `decision_date` cũ.
  - `033` update các `decisions` đã tồn tại để không giữ bản seed cũ thiếu ngày.
- `database/seed/030_excel_seed_case_files.sql`
  - Regenerate để cập nhật `closed_date`.
- `database/seed/033_excel_seed_case_events_and_resolutions.sql`
  - Regenerate để cập nhật `decisions`, `appellate_trackings`, `appellate_results`.
- `tests/sql_checks/list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql`
  - Thêm `imported_result_text`.
  - Hiển thị result text đã import trước khi fallback `Chưa giải quyết`.
  - Gắn cảnh báo `XXPT_RESULT_WITHOUT_DATE` nếu có result text nhưng thiếu ngày hợp lệ.
- Thêm test:
  - `tests/database/appellate_xxpt_result_excel_import_test.sql`
  - `tests/database/run_appellate_xxpt_result_excel_import_check.ps1`

## Kết quả sau khi sửa

| Chỉ tiêu | Kết quả |
|---|---:|
| Dòng phúc thẩm Excel | 1127 |
| Dòng Excel có `Kết quả XXPT` | 843 |
| Dòng đã map vào `decisions.result_summary` | 843 |
| Dòng có result và ngày/closed date hợp lệ | 840 |
| Dòng có result nhưng thiếu ngày hợp lệ | 3 |
| Dòng có result chưa map vào database | 0 |

Theo loại án:

| Loại án | Dòng có result | Có ngày hợp lệ | Thiếu ngày |
|---|---:|---:|---:|
| Dân sự | 407 | 406 | 1 |
| Hôn nhân gia đình | 59 | 59 | 0 |
| Kinh doanh thương mại | 26 | 25 | 1 |
| Lao động | 2 | 2 | 0 |
| Hình sự | 338 | 337 | 1 |
| Hành chính | 11 | 11 | 0 |

## Kết quả query danh sách kỳ 01/06/2026 - 12/06/2026

| Chỉ tiêu | Kết quả |
|---|---:|
| Tổng số dòng | 291 |
| Thụ lý trong kỳ | 10 |
| Giải quyết trong kỳ | 4 |
| Còn lại cuối kỳ | 287 |
| Dòng trong danh sách kỳ có result XXPT import | 7 |
| Result XXPT giải quyết trong kỳ | 4 |
| Result XXPT thiếu ngày hợp lệ | 3 |
| Dòng có result XXPT bị hiển thị `Chưa giải quyết` | 0 |

Tổng dòng giảm so với trước vì các vụ có `Kết quả XXPT` và ngày giải quyết trước 01/06/2026 không còn bị tính nhầm là còn lại cuối kỳ.

## Test đã chạy

```powershell
python .\database\seed\generate_excel_case_full_import.py
.\tests\database\run_appellate_xxpt_result_excel_import_check.ps1 -DatabaseName qlta_schema_merge_test
psql -d qlta_schema_merge_test -f .\tests\sql_checks\list_appellate_cases_by_first_instance_court_and_case_type_2026_06_01_to_2026_06_12.sql
```

Kết quả wrapper XXPT: `PASSED`.

## Cần xác nhận thêm

Hiện còn `3` dòng có `Kết quả XXPT` nhưng thiếu ngày giải quyết hợp lệ. Hệ thống đang lưu result text và cảnh báo `XXPT_RESULT_WITHOUT_DATE`, không tự bịa ngày. Cần người dùng xác nhận quy tắc nghiệp vụ: nếu Excel có `Kết quả XXPT` nhưng không có ngày thì có được coi là đã giải quyết thống kê hay chỉ hiển thị cảnh báo chờ bổ sung ngày.
