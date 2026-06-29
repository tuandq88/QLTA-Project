---
name: appellate_case_list_by_period
description: Quy tắc lập danh sách án phúc thẩm theo kỳ, nhóm/sắp xếp theo tòa án xét xử sơ thẩm và loại án từ unified PostgreSQL schema.
version: 1.2
domain: judicial_statistics
---

# Skill: Danh sách án phúc thẩm theo kỳ

## Mục đích

Dùng khi cần lập danh sách chi tiết án phúc thẩm có liên quan đến một kỳ thống kê, gồm án thụ lý trong kỳ, án giải quyết trong kỳ và án còn lại đến ngày cuối kỳ.

## Bảng và cột chuẩn

- Hồ sơ chính: `case_files`.
- Cấp xét xử phúc thẩm: `case_files.case_group = 'PHUC_THAM'` hoặc `case_files.case_group_id -> dm_category_items.item_code = 'PHUC_THAM'`.
- Tòa án xét xử sơ thẩm: dùng `case_files.first_instance_court_id -> courts.court_id`.
- Tòa án đang quản lý/xét xử phúc thẩm: `case_files.court_id`.
- Không dùng `case_files.court_id` thay cho `first_instance_court_id` nếu `court_id` là tòa phúc thẩm/current court.
- Nếu thiếu `first_instance_court_id`, hiển thị `Chưa xác định` và gắn cảnh báo `MISSING_FIRST_INSTANCE_COURT`.
- Lần thụ lý: `case_occurrences`.
- Sự kiện giải quyết: `case_resolution_events`.
- Người tiến hành tố tụng: `case_hearing_members` + `court_staff`.
- Nội dung hình sự: `criminal_case_details`, `defendants`, `charges`.
- Kết quả hình sự phúc thẩm theo bị cáo: `criminal_appellate_defendant_results`.
- Nội dung án dân sự/hôn nhân/KDTM/lao động/hành chính: `participants`, `civil_case_details`, `case_legal_relationships`, `dm_legal_relationships`.

Không dùng tên cũ hoặc suy đoán như `cf.id`, `case_title`, `resolved_date`, `trial_level_code`.

## Nguyên tắc dòng dữ liệu

1. Khi người dùng yêu cầu nhóm theo tòa án sơ thẩm và loại án, không tách thêm theo `Nhóm danh sách`.
2. Mỗi `case_occurrences.occurrence_id` là một dòng thống kê.
3. Nếu hồ sơ chưa có occurrence, fallback một dòng theo `case_files.case_id`.
4. Dùng cột cờ trên cùng một dòng:
   - `Thụ lý trong kỳ` = `x` nếu `acceptance_date BETWEEN from_date AND to_date`;
   - `Giải quyết trong kỳ` = `x` nếu `resolution_date BETWEEN from_date AND to_date`;
   - `Còn lại cuối kỳ` = `x` nếu `acceptance_date <= to_date` và `resolution_date IS NULL OR resolution_date > to_date`.
5. Không tính còn lại bằng công thức `accepted - resolved`; phải xét trạng thái từng case/occurrence tại `to_date`.
6. Khi nhóm theo tòa án sơ thẩm, `STT` reset theo `first_instance_court_display + case_type_display`.
7. Kết quả có ngày sau `to_date` không được tính hoặc hiển thị như kết quả trong kỳ; giữ hồ sơ trong danh sách tồn phù hợp và đưa ngày kết quả sau kỳ vào cảnh báo/ghi chú riêng.

## Hình sự phúc thẩm theo bị cáo

Nếu case có dữ liệu trong `criminal_appellate_defendant_results`:

- Không gán một kết quả chung cho toàn vụ án khi chưa đủ kết quả từng bị cáo.
- Vụ án chỉ coi là giải quyết khi toàn bộ bị cáo thuộc phạm vi phúc thẩm đã có `is_final_result IS TRUE` và `counted_as_defendant_resolved IS TRUE`.
- Ngày giải quyết vụ án là ngày muộn nhất trong các kết quả bị cáo khi toàn bộ bị cáo đã có kết quả.
- Kết quả hiển thị có thể tổng hợp dạng `Kết quả A: n bị cáo; Kết quả B: m bị cáo`.
- Nếu còn bị cáo chưa có kết quả đến `to_date`, cột `Còn lại cuối kỳ` phải là `x`.

Nếu case chưa có dữ liệu kết quả bị cáo, fallback theo `case_resolution_events` hoặc `case_files.closed_date`.

Nếu Excel/import đã có `Kết quả XXPT` ở `decisions.result_summary` hoặc `appellate_results.summary`, cột `Kết quả giải quyết` phải hiển thị result text đó; không fallback thành `Chưa giải quyết`. Nếu có result text nhưng thiếu ngày giải quyết hợp lệ, hiển thị result text và cảnh báo `XXPT_RESULT_WITHOUT_DATE`; chỉ tính `Giải quyết trong kỳ` khi có ngày nằm trong kỳ.

## Cột xuất danh sách chuẩn

Giữ thứ tự cột:

1. `STT`
2. `Tòa án xét xử sơ thẩm`
3. `Loại án`
4. `Số/ngày thụ lý phúc thẩm`
5. `Nội dung vụ án`
6. `Cấp xét xử`
7. `Thẩm phán chủ tọa`
8. `Hội đồng`
9. `Thư ký`
10. `Thụ lý trong kỳ`
11. `Giải quyết trong kỳ`
12. `Còn lại cuối kỳ`
13. `Kết quả giải quyết`
14. `Số/ngày giải quyết`
15. `Cảnh báo dữ liệu` nếu cần báo thiếu `first_instance_court_id`

`STT` phải reset theo tòa án sơ thẩm và loại án:

```sql
ROW_NUMBER() OVER (
    PARTITION BY first_instance_court_display, case_type_display
    ORDER BY acceptance_date, case_number, case_code, case_id, occurrence_id
)
```

## Validation bắt buộc

- Output chỉ lấy án `PHUC_THAM`.
- Output không có cột `Nhóm danh sách` nếu yêu cầu là nhóm theo tòa án sơ thẩm và loại án.
- Báo cáo tổng số dòng, số tòa án sơ thẩm, số loại án.
- Báo cáo số dòng có từng cờ thụ lý/giải quyết/còn lại.
- Kiểm tra không có duplicate không mong muốn theo `case_id/occurrence_id`.
- Báo cáo số dòng thiếu `first_instance_court_id` hoặc không join được `courts`.
- Không chấp nhận fallback im lặng từ `case_files.court_id` sang tòa sơ thẩm.
- Nếu dữ liệu phúc thẩm được seed từ Excel, áp dụng thêm `knowledge_base/skills/core/skill_excel_case_import.md` để kiểm tra cột `Tòa án xét xử sơ thẩm` đã map vào `case_files.first_instance_court_id`.
- Nếu dữ liệu phúc thẩm được seed từ Excel, kiểm tra cột `Kết quả XXPT` đã map vào result schema và query list không đổi thành `Chưa giải quyết`.
