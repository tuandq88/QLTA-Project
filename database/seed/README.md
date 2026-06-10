# Seed database

Thư mục này chứa seed danh mục và dữ liệu chuẩn hóa phục vụ kiểm thử schema/database. Đây không phải nơi seed hồ sơ vụ án thật hoặc dữ liệu cá nhân thật.

## Thứ tự chạy seed

Thứ tự chạy mặc định theo tên file:

1. `003_reference_data_seed.sql`
2. `004_statistical_reference_data_seed.sql`
3. `010_legal_seed_data_tand_vietnam.sql`
4. `020_excel_seed_case_categories.sql`
5. `021_excel_seed_criminal_categories.sql`
6. `022_excel_seed_civil_categories.sql`
7. `023_excel_seed_administrative_categories.sql`
8. `024_excel_seed_labor_business_marriage_categories.sql`
9. `025_excel_seed_statistical_indicators.sql`
10. `030_excel_seed_case_files.sql`
11. `031_excel_seed_case_details.sql`
12. `032_excel_seed_case_parties.sql`
13. `033_excel_seed_case_events_and_resolutions.sql`
14. `034_excel_seed_hearing_members.sql`

`999_seed_all.sql` chỉ là file ghi chú thứ tự chạy, không được dùng để chạy trùng seed.

## Nguồn dữ liệu seed

- `003_reference_data_seed.sql`: danh mục nền tối thiểu cho schema.
- `004_statistical_reference_data_seed.sql`: danh mục thống kê/KPI tối thiểu.
- `010_legal_seed_data_tand_vietnam.sql`: dữ liệu từ `database/seed/legal_seed_data_tand_vietnam/all_legal_seed_master.csv`.
- `020` đến `025`: dữ liệu trích từ Excel trong `database/seed/danh_sach/` và các file preview trong `docs/review/`.
- `030`: hồ sơ `case_files` seed từ từng dòng Excel có ngày thụ lý đọc được.
- `031`: detail theo loại án (`civil_case_details`, `administrative_case_details`, `criminal_case_details`) và bảng con phù hợp.
- `032`: đương sự/bị cáo/người tham gia tố tụng từ Excel khi có tên rõ.
- `033`: event, hearing, decision, appeal và appellate tracking/result khi Excel có dữ liệu tương ứng.
- `034`: danh sach can bo va thanh phan phien toa tu cac cot Tham phan/Chu toa, Hoi dong/Thanh vien, Thu ky trong Excel; o trong duoc bao cao la thieu du lieu, khong tao placeholder.

## Sinh lại seed hồ sơ từ Excel

Khi Excel nguồn trong `database/seed/danh_sach/` thay đổi, chạy:

```powershell
$env:PYTHONIOENCODING='utf-8'
python database\seed\generate_excel_case_full_import.py
```

Script này sinh lại:

- `database/seed/030_excel_seed_case_files.sql`
- `database/seed/031_excel_seed_case_details.sql`
- `database/seed/032_excel_seed_case_parties.sql`
- `database/seed/033_excel_seed_case_events_and_resolutions.sql`
- `database/seed/034_excel_seed_hearing_members.sql`
- `tests/database/EXCEL_CASE_FULL_IMPORT_MAPPING_RESULT.md`
- `tests/database/EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT.md`
- `docs/review/excel_case_full_import_records.csv`

## Quy tắc tiếng Việt

- Tên hiển thị phải dùng tiếng Việt có dấu khi nguồn đã có tiếng Việt.
- Nếu nguồn bị lỗi mã hóa hoặc chưa chắc nghiệp vụ, không tự sửa nghĩa; ghi chú `requires_human_review` trong metadata hoặc cột tương ứng.
- Không được tự bịa tội danh, quan hệ pháp luật, chỉ tiêu thống kê hoặc biểu mẫu.

## Quy tắc ngày tháng

- Tài liệu nguồn và ghi chú nghiệp vụ dùng định dạng `dd/MM/yyyy` khi mô tả ngày.
- Cột kiểu `DATE` trong SQL dùng literal chuẩn PostgreSQL như `DATE '2026-06-09'`.
- Không dùng giờ phút giây nếu dữ liệu chỉ là ngày.
- Chỉ dùng `TIMESTAMP` cho metadata kỹ thuật như `created_at`, `updated_at`, `calculated_at`, `checked_at`.

## Quy tắc idempotent

- Seed phải chạy lại được nhiều lần.
- Ưu tiên khóa tự nhiên như `category_code`, `item_code`, `indicator_code`, `metric_code`, `form_code`.
- File seed SQL phải dùng `ON CONFLICT DO UPDATE` hoặc cơ chế tương đương.
- Không xóa constraint/index để seed pass.

## Quy tắc human review

Đánh dấu hoặc ghi chú cần human review khi:

- dữ liệu được trích từ OCR/Excel và có nguy cơ sai mã hóa;
- dữ liệu pháp lý chưa đối chiếu trực tiếp với tài liệu nguồn trong `Documents/` hoặc `docs/legal/`;
- tên danh mục là alias từ Excel, chưa map về mã chuẩn;
- chỉ tiêu thống kê/form item chưa đối chiếu Quyết định 287/QĐ-TANDTC và `Documents/huong_dan_bm.pdf`.

## Cách thêm seed mới

1. Xác định bảng đích đã có trong `database/schema/unified_postgresql_schema.sql`.
2. Xác định nguồn dữ liệu và ghi vào comment đầu file.
3. Đặt tên file có số thứ tự rõ ràng.
4. Dùng `ON CONFLICT` để seed idempotent.
5. Không đưa dữ liệu cá nhân thật hoặc hồ sơ thật vào seed.
6. Cập nhật README này nếu thứ tự chạy thay đổi.
7. Bổ sung test trong `tests/database/` nếu seed tạo bảng/danh mục quan trọng mới.
