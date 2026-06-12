---
name: excel_case_import
description: Quy tắc import hồ sơ vụ án từ Excel nguồn vào seed/database, bảo vệ các cột nghiệp vụ quan trọng không bị đọc rồi bỏ qua.
version: 1.0
domain: database_seed
---

# Skill: Import hồ sơ vụ án từ Excel

## Mục đích

Dùng khi đọc, sửa hoặc sinh lại seed từ các file Excel trong `database/seed/danh_sach/`.

## Quy tắc bắt buộc

- Trước khi sửa generator, audit trực tiếp header và số dòng có giá trị trong Excel nguồn.
- Cột nghiệp vụ quan trọng không được chỉ đọc vào object trung gian rồi bỏ qua khi ghi SQL.
- Nếu Excel có cột nhưng schema chưa có nơi lưu, phải báo rõ thiếu schema và bổ sung migration/schema trước khi seed.
- Seed sinh từ Excel phải idempotent và không hard-code mật khẩu/kết nối database.
- Không tự sửa nghĩa dữ liệu Excel. Nếu tên tòa, tội danh, quan hệ pháp luật chưa chuẩn hóa được thì lưu alias nguồn và ghi cảnh báo/human review khi cần.

## Án phúc thẩm

- `case_files.court_id` là tòa đang quản lý/xét xử phúc thẩm.
- Cột Excel `Tòa án xét xử sơ thẩm` hoặc biến thể hoa/thường phải map vào `case_files.first_instance_court_id`.
- Cột Excel `Kết quả XXPT` hoặc biến thể như `KQ XXPT`, `Kết quả phúc thẩm`, `appellate_result` là cột nghiệp vụ quan trọng, không được bỏ qua.
- `Kết quả XXPT` phải được map tối thiểu vào `decisions.result_summary` và `decisions.result_code`; nếu có tracking/result appellate thì đồng thời map vào `appellate_trackings.final_result_code` và `appellate_results.summary/result_code`.
- Nếu Excel có ngày tương ứng như `Ngày BA/QĐ PT` hoặc `Ngày xử`, map vào `decisions.decision_date`, `case_files.closed_date` và result date tương ứng.
- Nếu Excel có `Kết quả XXPT` nhưng thiếu ngày hợp lệ, không tự bịa ngày; phải giữ result text và cảnh báo `XXPT_RESULT_WITHOUT_DATE`.
- Nếu tòa sơ thẩm từ Excel chưa có trong `courts`, generator được tạo court alias từ Excel bằng mã deterministic, nhưng không được gán nhầm thành tòa phúc thẩm/current court.
- Tên chứa `khu vực` map `courts.court_level = 'regional'`.
- Tên chứa `huyện`, `thành phố`, `thị xã` map `courts.court_level = 'district'` nếu chưa có danh mục cấp huyện cũ riêng.
- Query thống kê phúc thẩm theo tòa sơ thẩm phải join `case_files.first_instance_court_id -> courts.court_id`; nếu thiếu thì hiển thị cảnh báo thay vì fallback sang `case_files.court_id`.

## Validation

- Có test kiểm tra số dòng Excel phúc thẩm đã import.
- Có test kiểm tra `first_instance_court_id IS NOT NULL` với các dòng Excel có cột `Tòa án xét xử sơ thẩm`.
- Có test kiểm tra `first_instance_court_id` join được `courts`.
- Có test kiểm tra không collapse `first_instance_court_id = court_id` cho án phúc thẩm Excel.
- Có test kiểm tra mọi dòng Excel có `Kết quả XXPT` không rỗng đều có result tương ứng trong database hoặc cảnh báo thiếu ngày.
- Query list không được hiển thị `Chưa giải quyết` cho dòng đã import `Kết quả XXPT`.
- Sau khi regenerate seed, chạy lại wrapper database liên quan và cập nhật báo cáo trong `tests/database/` hoặc `tests/sql_checks/`.
