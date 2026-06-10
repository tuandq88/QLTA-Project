# EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT

## A. Sơ thẩm/phúc thẩm

- Trường dùng để phân biệt cấp xét xử: `case_files.case_group` và `case_files.case_group_id`.
- Lý do chọn: `case_type` chỉ lưu loại án; `procedure_law` chỉ lưu luật tố tụng; `current_stage` chỉ lưu giai đoạn vòng đời hồ sơ.
- Không tạo cột `trial_level` mới vì schema đã có `case_group/case_group_id` và danh mục `dm_categories`.
- Danh mục: `dm_categories.category_code = 'case_group'`.
- Mã sơ thẩm: `SO_THAM`.
- Mã phúc thẩm: `PHUC_THAM`.
- Số lượng `case_files` sơ thẩm: 1182.
- Số lượng `case_files` phúc thẩm: 1127.
- Số dòng thiếu cấp xét xử: 0.

## B. Thẩm phán/Hội đồng/Thư ký

| File Excel | Sheet | Dòng đọc | Có chủ tọa | Thiếu chủ tọa | Có hội đồng | Thiếu hội đồng | Phúc thẩm không đủ 2 PANEL_JUDGE | Có thư ký | Thiếu thư ký |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 552 | 552 | 0 | 291 | 261 | 288 | 232 | 320 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 673 | 673 | 0 | 1 | 672 | 0 | 191 | 482 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 575 | 575 | 0 | 345 | 230 | 235 | 314 | 261 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 509 | 509 | 0 | 206 | 303 | 0 | 344 | 165 |

- Số nhân sự tạo/cập nhật trong `court_staff`: 98.
- Số thành phần phiên tòa tạo/cập nhật trong `case_hearing_members`: 4954.

### Dòng lỗi/warning

| File | Sheet | Row | Warning |
| --- | --- | ---: | --- |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 4 | Phúc thẩm có 5 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 5 | Phúc thẩm có 7 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 7 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 8 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 9 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 9 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 13 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 15 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 16 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 19 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 20 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 20 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 21 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 21 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 22 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 22 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 23 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 23 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 24 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 24 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 25 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 25 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 26 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 26 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 27 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 27 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 28 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 28 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 29 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 29 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 30 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 30 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 31 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 31 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 32 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 32 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 33 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 33 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 34 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 34 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 35 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 35 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 36 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 36 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 37 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 37 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 38 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 38 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 39 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 39 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 40 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 40 | Phúc thẩm có 4 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 41 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 41 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 43 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 43 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 44 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 44 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 48 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 48 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 50 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 50 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 52 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 55 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 55 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 57 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 58 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 59 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 60 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 60 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 66 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 66 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 68 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 69 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 69 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 70 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 70 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 72 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 72 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 74 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 76 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 76 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 77 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 77 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 79 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 79 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 81 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 81 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 82 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 86 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 86 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 88 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 88 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 89 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 89 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 90 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 90 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 91 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 92 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 94 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 94 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 95 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 95 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 96 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 96 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 100 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 100 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 101 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 102 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 103 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 106 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 106 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 107 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 108 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 109 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 109 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 110 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 113 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 113 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 117 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 117 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 119 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 120 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 120 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 121 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 122 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 124 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 124 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 125 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 126 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 126 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 127 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 127 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 128 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 128 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 130 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 130 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 131 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 131 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 132 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 132 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 135 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 135 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 136 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 136 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 137 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 138 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 138 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 140 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 141 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 141 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 143 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 143 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 144 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 145 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 146 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 146 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 147 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 149 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 149 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 153 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 153 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 154 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 154 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 155 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 155 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 158 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 159 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 159 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 160 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 160 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 161 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 161 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 162 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 163 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 163 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 164 | Phúc thẩm có 1 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 165 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 165 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 166 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 166 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 167 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 168 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 170 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 170 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 174 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 175 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 176 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 177 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 177 | Phúc thẩm có 4 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 179 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 179 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 180 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 181 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 181 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 182 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 184 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 185 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 185 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 186 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 187 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 187 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 188 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 189 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 189 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 190 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 190 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 192 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 192 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 193 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 193 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 195 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 195 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 196 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 196 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 197 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 198 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 198 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 201 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 202 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 202 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 203 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 203 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 205 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 206 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 207 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 207 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 213 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 213 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 214 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 214 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 215 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 215 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 216 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 217 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 218 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 218 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 219 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 224 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 224 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 226 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 226 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 227 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 227 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 228 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 228 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 229 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 230 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 230 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 231 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 231 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 233 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 233 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 234 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 234 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 235 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 236 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 236 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 237 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 237 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 238 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 239 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 240 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 241 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 241 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 242 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 243 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 243 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 244 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 244 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 245 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 245 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 246 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 246 | Phúc thẩm có 4 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 248 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 248 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 250 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 253 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 253 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 254 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 254 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 255 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 255 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 256 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 256 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 258 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 259 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 259 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 262 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 262 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 265 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 266 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 266 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 268 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 268 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 270 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 270 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 274 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 274 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 276 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 276 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 279 | Phúc thẩm có 1 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 280 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 280 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 282 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 283 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 286 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 287 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 288 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 290 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 290 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 293 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 293 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 294 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 294 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 296 | Phúc thẩm có 4 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 299 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 302 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 303 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 303 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 304 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 304 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 305 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 305 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 306 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 306 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 307 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 308 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 308 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 309 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 309 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 310 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 310 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 311 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 311 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 312 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 313 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 313 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 314 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 314 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 315 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 316 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 317 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 318 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 319 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 320 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 320 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 321 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 321 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 323 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 323 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 326 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 326 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 327 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 328 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 329 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 330 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 330 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 332 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 334 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 334 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 335 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 335 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 336 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 336 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 337 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 337 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 338 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 338 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 339 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 339 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 340 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 341 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 343 | Phúc thẩm có 4 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 344 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 345 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 345 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 346 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 346 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 347 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 347 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 350 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 350 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 351 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 351 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 353 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 353 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 354 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 354 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 355 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 355 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 357 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 358 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 359 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 359 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 360 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 360 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 361 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 361 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 363 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 363 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 364 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 365 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 366 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 366 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 368 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 369 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 369 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 370 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 370 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 371 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 375 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 375 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 377 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 377 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 379 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 379 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 380 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 380 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 381 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 381 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 382 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 382 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 384 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 385 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 385 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 386 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 386 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 388 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 388 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 391 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 391 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 392 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 392 | Phúc thẩm có 4 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 393 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 395 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 395 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 397 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 397 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 399 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 400 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 400 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 401 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 401 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 402 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 402 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 405 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 407 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 408 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 408 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 409 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 409 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 411 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 411 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 412 | Có 3 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 414 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 421 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 421 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 423 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 424 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 425 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 426 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 428 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 429 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 432 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 432 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 433 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 433 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 434 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 436 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 436 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 437 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 437 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 438 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 438 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 439 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 441 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 441 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 442 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 442 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 443 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 443 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 444 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 444 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 445 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 446 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 446 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 447 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 448 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 449 | Phúc thẩm có 5 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 450 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 450 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 451 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 451 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 452 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 452 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 453 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 453 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 455 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 455 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 456 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 458 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 458 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 459 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 459 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 460 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 460 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 462 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 463 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 463 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 466 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 466 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 467 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 469 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 470 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 470 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 471 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 472 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 473 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 473 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 474 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 474 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 477 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 477 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 480 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 480 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 481 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 482 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 482 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 483 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 483 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 484 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 484 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 485 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 485 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 486 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 486 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 487 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 487 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 488 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 489 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 491 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 491 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 492 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 492 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 493 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 494 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 497 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 498 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 500 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 500 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 501 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 501 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 502 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 506 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 506 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 507 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 507 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 508 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 508 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 511 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 511 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 513 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 515 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 515 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 516 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 516 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 517 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 517 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 518 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 520 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 520 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 521 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 521 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 522 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 522 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 523 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 526 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 527 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 527 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 530 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 530 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 531 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 531 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 534 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 534 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 536 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 536 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 537 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 537 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 538 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 539 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 540 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 540 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 542 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 543 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 544 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 546 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 546 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 547 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 547 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 548 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 548 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 549 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 549 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 550 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 550 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 554 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 554 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | 555 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 4 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 5 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 6 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 7 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 8 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 10 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 11 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 12 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 14 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 15 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 16 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 17 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 18 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 20 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 21 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 22 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 23 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 24 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 25 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 27 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 28 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 30 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 31 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 34 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 35 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 36 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 38 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 39 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 40 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 41 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 44 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 45 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 47 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 49 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 50 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 51 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 52 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 54 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 55 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 56 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 57 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 58 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 59 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 60 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 61 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 63 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 66 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 67 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 68 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 69 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 70 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 72 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 72 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 75 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 77 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 78 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 79 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 80 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 81 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 82 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 83 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 84 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 84 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 85 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 86 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 86 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 87 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 87 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 89 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 90 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 90 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 91 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 92 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 94 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 95 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 96 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 97 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 99 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 103 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 104 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 106 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 107 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 109 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 110 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 113 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 114 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 115 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 116 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 119 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 120 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 121 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 124 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 125 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 126 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 127 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 128 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 129 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 130 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 131 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 132 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 135 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 135 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 136 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 138 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 139 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 140 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 142 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 143 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 147 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 149 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 150 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 152 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 153 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 154 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 155 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 157 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 157 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 158 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 161 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 162 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 163 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 164 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 165 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 166 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 167 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 168 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 169 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 170 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 172 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 174 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 175 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 176 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 177 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 179 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 180 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 181 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 182 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 184 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 185 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 186 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 187 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 188 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 189 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 190 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 191 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 192 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 195 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 197 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 198 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 199 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 200 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 201 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 202 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 203 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 204 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 205 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 206 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 210 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 211 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 212 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 213 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 214 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 215 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 216 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 216 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 217 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 218 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 219 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 220 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 221 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 222 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 223 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 224 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 225 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 226 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 227 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 228 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 229 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 230 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 231 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 232 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 233 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 234 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 235 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 237 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 238 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 239 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 240 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 241 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 244 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 245 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 247 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 248 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 251 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 252 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 253 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 254 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 256 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 257 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 258 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 259 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 262 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 263 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 264 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 265 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 267 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 268 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 269 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 270 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 271 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 273 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 274 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 275 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 277 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 278 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 279 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 280 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 281 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 284 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 285 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 288 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 289 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 290 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 291 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 292 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 293 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 294 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 295 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 296 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 297 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 298 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 299 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 300 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 301 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 303 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 304 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 305 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 306 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 307 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 311 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 312 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 313 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 314 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 316 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 317 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 320 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 321 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 322 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 323 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 324 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 325 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 326 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 327 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 328 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 330 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 331 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 332 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 333 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 335 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 338 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 338 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 341 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 342 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 346 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 347 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 348 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 349 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 350 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 351 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 352 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 353 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 354 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 355 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 356 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 357 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 358 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 360 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 361 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 362 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 363 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 364 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 365 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 366 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 367 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 369 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 370 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 371 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 372 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 373 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 375 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 378 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 379 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 380 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 381 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 382 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 383 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 384 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 385 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 386 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 387 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 388 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 389 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 390 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 391 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 392 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 394 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 394 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 395 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 396 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 398 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 400 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 402 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 404 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 405 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 407 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 409 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 410 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 411 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 413 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 415 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 416 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 418 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 420 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 421 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 422 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 423 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 425 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 426 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 427 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 428 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 430 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 431 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 432 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 433 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 434 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 435 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 436 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 437 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 438 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 439 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 440 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 442 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 444 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 445 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 446 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 447 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 448 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 449 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 450 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 452 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 454 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 456 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 457 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 458 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 459 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 460 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 461 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 462 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 464 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 466 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 467 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 468 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 469 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 471 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 473 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 474 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 475 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 476 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 477 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 478 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 479 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 480 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 481 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 482 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 485 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 487 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 488 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 489 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 490 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 492 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 494 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 496 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 497 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 498 | Có 3 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 500 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 501 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 502 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 503 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 504 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 505 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 506 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 508 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 511 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 513 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 515 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 517 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 518 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 519 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 521 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 522 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 522 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 525 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 526 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 527 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 528 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 530 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 531 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 532 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 533 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 534 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 536 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 536 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 538 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 539 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 541 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 541 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 542 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 543 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 544 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 548 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 549 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 550 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 551 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 554 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 555 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 556 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 557 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 558 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 559 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 561 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 562 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 563 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 566 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 568 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 569 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 571 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 573 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 575 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 576 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 577 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 579 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 580 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 580 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 581 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 582 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 583 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 584 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 585 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 586 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 588 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 589 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 590 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 591 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 592 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 594 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 595 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 596 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 599 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 601 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 603 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 605 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 608 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 610 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 611 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 612 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 613 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 614 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 616 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 617 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 620 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 621 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 623 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 624 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 627 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 631 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 632 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 633 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 634 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 635 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 636 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 637 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 638 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 639 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 642 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 643 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 644 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 645 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 647 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 649 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 650 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 651 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 652 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 656 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 658 | Có 2 thẩm phán chủ tọa, yêu cầu đúng 1 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 658 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 659 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 660 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 663 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 664 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 666 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 672 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 674 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 675 | Thiếu thư ký phiên tòa |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | 676 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 4 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 5 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 5 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 6 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 7 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 8 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 8 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 9 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 9 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 10 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 11 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 12 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 13 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 14 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 14 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 15 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 16 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 16 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 17 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 17 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 18 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 19 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 19 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 20 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 20 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 21 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 21 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 22 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 22 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 23 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 23 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 24 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 24 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 26 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 26 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 27 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 27 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 28 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 28 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 29 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 29 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 30 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 30 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 31 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 31 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 32 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 32 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 33 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 33 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 34 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 34 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 35 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 35 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 36 | Phúc thẩm có 1 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 37 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 37 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 40 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 42 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 42 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 43 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 43 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 45 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 45 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 46 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 46 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 47 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 47 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 49 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 49 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 50 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 50 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 52 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 53 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 54 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 54 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 55 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 55 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 56 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 58 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 58 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 59 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 59 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 61 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 61 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 64 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 64 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 66 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 66 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 67 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 67 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 68 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 68 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 69 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 69 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 70 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 70 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 71 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 71 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 72 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 72 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 73 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 73 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 75 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 75 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 80 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 80 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 81 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 81 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 82 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 82 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 84 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 84 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 87 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 87 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 88 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 88 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 89 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 89 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 92 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 92 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 93 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 93 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 94 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 94 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 95 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 95 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 96 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 96 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 98 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 98 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 99 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 99 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 100 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 100 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 102 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 102 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 104 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 104 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 105 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 105 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 106 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 106 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 107 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 107 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 108 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 110 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 110 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 112 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 112 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 113 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 115 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 115 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 117 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 117 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 121 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 121 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 122 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 122 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 123 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 123 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 124 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 124 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 125 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 125 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 127 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 127 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 128 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 128 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 129 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 129 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 130 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 130 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 132 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 132 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 134 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 134 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 135 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 135 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 137 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 137 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 138 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 138 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 140 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 140 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 142 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 142 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 143 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 143 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 144 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 144 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 146 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 146 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 147 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 147 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 148 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 148 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 149 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 149 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 151 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 151 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 152 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 152 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 153 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 153 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 155 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 155 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 160 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 160 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 161 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 161 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 162 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 162 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 164 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 164 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 165 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 168 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 168 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 170 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 171 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 171 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 172 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 172 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 173 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 173 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 175 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 175 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 176 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 176 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 178 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 178 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 180 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 180 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 182 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 182 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 183 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 183 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 187 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 187 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 189 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 189 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 190 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 192 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 192 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 194 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 194 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 195 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 196 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 196 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 198 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 199 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 199 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 200 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 200 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 202 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 202 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 203 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 203 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 204 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 206 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 206 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 209 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 209 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 210 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 212 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 214 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 214 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 215 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 215 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 220 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 220 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 222 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 222 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 226 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 226 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 228 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 228 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 233 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 235 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 236 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 237 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 237 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 239 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 240 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 240 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 241 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 241 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 244 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 246 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 246 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 247 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 247 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 248 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 248 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 251 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 251 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 254 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 254 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 256 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 256 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 262 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 266 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 266 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 269 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 269 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 272 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 272 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 278 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 278 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 279 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 292 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 292 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 294 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 294 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 295 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 300 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 302 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 302 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 303 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 303 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 305 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 312 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 312 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 313 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 313 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 322 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 322 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 327 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 327 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 329 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 329 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 331 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 339 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 342 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 343 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 345 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 346 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 350 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 354 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 364 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 365 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 365 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 366 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 366 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 368 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 369 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 369 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 370 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 370 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 373 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 373 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 374 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 374 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 375 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 375 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 378 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 379 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 383 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 389 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 389 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 390 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 390 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 393 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 393 | Phúc thẩm có 1 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 397 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 398 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 400 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 400 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 404 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 405 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 410 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 411 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 412 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 413 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 416 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 417 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 419 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 422 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 423 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 429 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 429 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 430 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 432 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 433 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 435 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 437 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 439 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 440 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 442 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 451 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 454 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 456 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 457 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 457 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 458 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 464 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 465 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 465 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 468 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 468 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 469 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 471 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 471 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 473 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 474 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 477 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 482 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 484 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 485 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 485 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 486 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 486 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 487 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 487 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 489 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 490 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 490 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 491 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 491 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 492 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 494 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 495 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 495 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 497 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 498 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 499 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 499 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 500 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 500 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 502 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 502 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 504 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 506 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 507 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 509 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 509 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 510 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 510 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 511 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 511 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 512 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 513 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 513 | Phúc thẩm có 1 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 517 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 518 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 518 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 520 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 522 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 523 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 526 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 528 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 529 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 529 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 532 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 534 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 535 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 535 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 536 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 536 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 537 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 537 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 538 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 538 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 539 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 539 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 541 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 542 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 543 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 543 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 544 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 544 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 546 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 546 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 547 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 551 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 551 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 554 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 556 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 557 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 557 | Phúc thẩm có 3 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 560 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 562 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 562 | Phúc thẩm có 0 PANEL_JUDGE, yêu cầu đúng 2 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 565 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 566 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 567 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 568 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 569 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 570 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 571 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 572 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 573 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 574 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 575 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 576 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 577 | Thiếu thư ký phiên tòa |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | 578 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 4 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 6 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 9 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 10 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 11 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 12 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 13 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 14 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 16 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 19 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 20 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 21 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 22 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 23 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 25 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 26 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 28 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 29 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 31 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 33 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 35 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 36 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 37 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 39 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 40 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 41 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 43 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 44 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 45 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 46 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 47 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 51 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 52 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 53 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 55 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 58 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 63 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 66 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 69 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 71 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 72 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 75 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 80 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 81 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 83 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 84 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 85 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 86 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 90 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 92 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 94 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 96 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 97 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 101 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 102 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 104 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 105 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 107 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 109 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 111 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 113 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 114 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 115 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 118 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 119 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 121 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 122 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 123 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 126 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 128 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 129 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 130 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 132 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 133 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 135 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 136 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 139 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 140 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 141 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 143 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 145 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 148 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 149 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 151 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 156 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 160 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 164 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 166 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 169 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 171 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 172 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 174 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 182 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 185 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 186 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 200 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 203 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 206 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 207 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 209 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 212 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 213 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 217 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 220 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 222 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 225 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 228 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 235 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 251 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 255 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 256 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 260 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 263 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 267 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 269 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 272 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 274 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 296 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 297 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 316 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 326 | Sơ thẩm có 3 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 327 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 336 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 360 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 362 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 363 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 364 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 365 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 366 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 367 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 368 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 370 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 370 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 374 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 376 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 377 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 387 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 390 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 394 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 398 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 401 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 409 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 411 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 411 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 414 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 415 | Sơ thẩm có 3 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 416 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 422 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 427 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 435 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 438 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 447 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 449 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 456 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 465 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 466 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 467 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 473 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 475 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 478 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 479 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 483 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 486 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 488 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 489 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 492 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 493 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 494 | Sơ thẩm có 3 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 495 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 496 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 499 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 503 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 504 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 504 | Sơ thẩm có 2 PANEL_JUDGE, yêu cầu 0 hoặc 1 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 506 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 507 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 508 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 509 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 511 | Thiếu thư ký phiên tòa |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | 512 | Thiếu thư ký phiên tòa |

## C. Bảng dữ liệu

- Bảng nhân sự dùng: `court_staff`.
- Bảng thành phần phiên tòa dùng: `case_hearing_members`.
- Bảng danh mục role dùng: `dm_categories/dm_category_items` với `category_code = 'hearing_member_role'`.
- Sau seed dự kiến `court_staff`: 98 dòng.
- Sau seed dự kiến `case_hearing_members`: 4954 dòng.

## D. Kết luận

Seed không tạo nhân sự giả cho ô trống. Các ô trống hoặc sai số lượng thành viên hội đồng được ghi warning để test/report phát hiện.
