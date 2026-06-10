# EXCEL_CASE_FULL_IMPORT_MAPPING_RESULT

## 1. Tổng quan

- Mục tiêu: import dữ liệu danh sách án giả từ Excel vào `case_files` và các bảng detail/liên quan để test thống kê.
- Danh sách file Excel: Dân sự mở rộng - Phúc thẩm.xlsx, Dân sự mở rộng - Sơ thẩm.xlsx, Hình sự - Phúc thẩm.xlsx, Hình sự - Sơ thẩm.xlsx.
- Tổng số dòng dữ liệu đọc được: 2309.
- Tổng số hồ sơ vụ án import: 2309.
- Tổng số dòng detail import dự kiến: 2309.
- Tổng số dòng danh mục bổ sung: 0 trong task này; seed 020-025 hiện có tiếp tục giữ vai trò danh mục/alias.

## 2. Phân tích từng Excel

| File | Sheet | Cấp xét xử | Cột | Dòng dữ liệu | Dòng hợp lệ | Dòng bỏ qua |
| --- | --- | --- | --- | ---: | ---: | ---: |
| Dân sự mở rộng - Phúc thẩm.xlsx | Projects 3  | Phúc thẩm | Chủ toạ, Thành viên, Thư ký, Loại án, Số án, Ngày xử, Số/Ngày TL, Nguyên đơn, Bị đơn, Vụ việc, Số BA/QĐ ST, Ngày BA/QĐ ST, Tòa án xét xử sơ thẩm, KC/KN, Kết quả XXPT | 552 | 552 | 0 |
| Dân sự mở rộng - Sơ thẩm.xlsx | Projects 3  | Sơ thẩm | STT, Loại án, Số/ngày thụ lý, Nguyên đơn/NKK, Bị đơn/NBK, Quan hệ pháp luật, Thẩm phán, Hội đồng, Thư ký, Số/Ngày BA/QD, Kháng cáo/Kháng nghị, Hình thức xét xử, Ghi chú | 673 | 673 | 0 |
| Hình sự - Phúc thẩm.xlsx | Projects 3  | Phúc thẩm | Chủ toạ, Thành viên, Thư ký, Số BA/QĐ PT, Ngày BA/QĐ PT, Số/Ngày TL, Họ và tên, Số BC, KC/KN, Tội danh, Mức án ST, Số BA/QĐ ST, Ngày BA/QĐ ST, Tòa án xét xử Sơ thẩm, Kết quả XXPT | 575 | 575 | 0 |
| Hình sự - Sơ thẩm.xlsx | Projects 3  | Sơ thẩm | STT, Số/ngày thụ lý, Họ và tên bị cáo, Năm sinh, Tội danh, Thẩm phán, Hội đồng, Thư ký, Số/Ngày BA/QD, Kết quả XXST, Kháng cáo/Kháng nghị, Hình thức xét xử, Ghi chú | 509 | 509 | 0 |

## 3. Mapping Excel

| Cột/nguồn Excel | Ý nghĩa | Bảng đích | Cột đích | Quy tắc chuyển đổi | Bắt buộc |
| --- | --- | --- | --- | --- | --- |
| Số/ngày thụ lý, Số/Ngày TL | Số và ngày thụ lý | case_files | case_number, acceptance_date, filing_date | tách ngày dd/MM/yyyy; số thụ lý giữ trong summary/case_number kỹ thuật | Có |
| Loại án/tên file | Loại án, nhóm án, luật tố tụng | case_files | case_type, case_group, procedure_law và *_id | map Hình sự/Hành chính/Dân sự/HNGĐ/KDTM/Lao động theo alias Excel | Có |
| Nguyên đơn/NKK, Bị đơn/NBK, Họ và tên bị cáo | Người tham gia tố tụng | participants, defendants | participant_type, full_name, organization_name | tách theo dòng, dấu chấm phẩy và ký tự phân cách rõ ràng | Không |
| Quan hệ pháp luật, Vụ việc | Quan hệ tranh chấp | civil_case_details, administrative_case_details, case_legal_relationships | dispute_type, lawsuit_type, relationship_id | dùng text nguồn; FK legal_relationship chỉ gắn khi danh mục 022 đã có tên tương ứng | Không |
| Tội danh | Tội danh bị truy tố/xét xử | charges, dm_crimes | crime_name, crime_id | tách song song theo bị cáo khi dữ liệu đủ rõ | Không |
| Số/Ngày BA/QĐ, Số BA/QĐ PT/ST | Bản án/quyết định | decisions | decision_number, decision_date | tách số và ngày; serial Excel được đổi sang DATE | Không |
| Kết quả XXST/XXPT | Kết quả giải quyết | decisions, appellate_results | result_summary, result_code | phân loại cơ bản: giữ nguyên/sửa/hủy/đình chỉ/khác | Không |
| KC/KN, Kháng cáo/Kháng nghị | Kháng cáo/kháng nghị | appeals, appellate_trackings | appeal_type, appeal_scope | phát hiện k/c, k/n, VKS; không tự tạo người kháng cáo nếu không tách chắc chắn | Không |
| Hình thức xét xử, Ngày xử | Phiên tòa/phiên họp | hearings | hearing_type, scheduled_date, note | tạo hearing khi có ngày xử hoặc hình thức xét xử | Không |

## 4. Mapping bảng

- `case_files`: một dòng Excel hợp lệ tạo một hồ sơ; khóa tự nhiên `case_code = EXCEL-...-<dòng>`.
- `civil_case_details`: dùng cho dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động theo thiết kế schema hiện tại.
- `administrative_case_details` và `challenged_admin_objects`: dùng cho án hành chính trong file dân sự mở rộng sơ thẩm.
- `criminal_case_details`, `defendants`, `charges`, `sentences`: dùng cho án hình sự.
- `participants`: nhập đương sự/bị cáo khi Excel có tên; không tạo người giả.
- `case_events`, `hearings`, `decisions`, `appeals`, `appellate_trackings`, `appellate_results`: tạo khi Excel có dữ liệu tương ứng.
- `statistics_snapshots`: không seed trực tiếp vì có thể tính từ dữ liệu gốc case/detail.

## 5. Số dòng sau seed dự kiến

| Bảng | Số dòng seed từ Excel |
| --- | ---: |
| case_files | 2309 |
| civil_case_details | 837 |
| administrative_case_details | 388 |
| criminal_case_details | 1084 |
| participants | 6259 |
| decisions | 2221 |
| appeals | 1138 |
| appellate_trackings | 1053 |
| case_events | 2309 |

## 6. Kiểm tra thống kê dự kiến

- Tổng thụ lý: 2309.
- Tổng đã giải quyết: 2220.
- Tổng tồn: 89.
- Sơ thẩm: 1182.
- Phúc thẩm: 1127.
- administrative: 388.
- business_commercial: 37.
- civil: 735.
- criminal: 1084.
- labor: 2.
- marriage_family: 63.

## 7. Các dòng bỏ qua

| File | Sheet | Dòng | Lý do bỏ qua |
| --- | --- | ---: | --- |
| Không có | | | |

## 8. Kết luận

PASSED nếu chạy seed và test thành công: seed không chỉ có `case_files`, mà có detail, participants, events/decisions/appeals/appellate tracking. Nếu sau khi chạy database mà các bảng detail bằng 0 thì kết luận phải xem là FAILED.
