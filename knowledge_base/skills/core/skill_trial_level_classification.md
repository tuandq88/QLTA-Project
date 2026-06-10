# Skill: Phân loại cấp xét xử hồ sơ

## Mục đích

Dùng khi chuẩn hóa, import, thống kê hoặc kiểm tra hồ sơ có thông tin sơ thẩm/phúc thẩm.

## Quy tắc bắt buộc

- Cấp xét xử chỉ lưu tại `case_files.case_group` và `case_files.case_group_id`.
- Mã cấp xét xử chuẩn:
  - `SO_THAM`: hồ sơ sơ thẩm.
  - `PHUC_THAM`: hồ sơ phúc thẩm.
- `case_type` và `case_type_id` chỉ dùng cho loại án: hình sự, dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động, hành chính.
- `procedure_law` và `procedure_law_id` chỉ dùng cho luật tố tụng áp dụng.
- `current_stage` và `current_stage_id` chỉ dùng cho giai đoạn vòng đời hồ sơ.
- Không ghi `SO_THAM`, `PHUC_THAM`, "sơ thẩm", "phúc thẩm" vào `case_type`, `procedure_law` hoặc `current_stage`.

## Khi import Excel

- Nếu workbook/sheet thể hiện cấp sơ thẩm hoặc phúc thẩm, map sang `case_group`.
- Sau khi import phải có `case_group_id` trỏ đến danh mục `case_group`.
- Nếu không xác định được cấp xét xử, ghi cảnh báo validation; không tự suy diễn bằng cách đổi loại án hoặc giai đoạn.

## Kiểm tra

- Chạy `tests/database/trial_level_and_hearing_members_integrity_test.sql` hoặc runner PowerShell tương ứng.
- Kiểm tra tối thiểu: hồ sơ Excel có `case_group/case_group_id`, giá trị nằm trong `SO_THAM`/`PHUC_THAM`, và không có cấp xét xử trong `case_type/procedure_law/current_stage`.
