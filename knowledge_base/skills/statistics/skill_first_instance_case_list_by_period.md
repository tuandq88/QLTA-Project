---
name: first_instance_case_list_by_period
description: Quy tắc lập danh sách án sơ thẩm thụ lý, giải quyết, còn lại theo một khoảng ngày từ unified PostgreSQL schema.
version: 1.2
domain: judicial_statistics
---

# Skill: Danh sách án sơ thẩm theo kỳ

## Mục đích

Dùng khi cần lập danh sách chi tiết án sơ thẩm theo kỳ thống kê, gồm án thụ lý trong kỳ, án giải quyết trong kỳ và án còn lại đến ngày cuối kỳ.

## Bảng và cột chuẩn

- Bảng hồ sơ: `case_files`.
- Cấp xét xử sơ thẩm: `case_files.case_group = 'SO_THAM'` hoặc `case_files.case_group_id -> dm_category_items.item_code = 'SO_THAM'`.
- Lần thụ lý: `case_occurrences`.
- Sự kiện giải quyết: `case_resolution_events`.
- Người tiến hành tố tụng tại phiên tòa: `case_hearing_members` + `court_staff`.
- Nội dung án hình sự: `criminal_case_details`, `defendants`, `charges`.
- Nội dung án dân sự/hành chính/khác: `participants`, `civil_case_details`, `case_legal_relationships`, `dm_legal_relationships`.
- Quyết định/kết quả fallback: `decisions`.

Không dùng tên cũ như `cf.id`, `case_title`, `resolved_date`, `case_type_code`, `trial_level_code`, `status_code`.

## Nguyên tắc dòng dữ liệu

1. Mặc định gom theo `Loại án`, không tách dòng theo `Nhóm danh sách`.
2. Mỗi `case_occurrences.occurrence_id` là một dòng thống kê.
3. Nếu hồ sơ chưa có occurrence, fallback một dòng theo `case_files.case_id`.
4. Không dùng `UNION ALL` để nhân một hồ sơ/occurrence thành ba dòng riêng cho thụ lý, giải quyết, còn lại.
5. Dùng các cột cờ để biểu thị trạng thái trên cùng một dòng:
   - `Thụ lý trong kỳ` = `x` nếu `acceptance_date BETWEEN from_date AND to_date`;
   - `Giải quyết trong kỳ` = `x` nếu `resolution_date BETWEEN from_date AND to_date`;
   - `Còn lại cuối kỳ` = `x` nếu `acceptance_date <= to_date` và `resolution_date IS NULL OR resolution_date > to_date`.
6. Chỉ dùng cột hoặc logic `Nhóm danh sách` khi người dùng yêu cầu tách riêng danh sách theo nhóm nghiệp vụ.
7. Khi tách danh sách tồn đầu kỳ/chưa giải quyết đến cuối kỳ, dùng `acceptance_date < from_date AND (resolution_date IS NULL OR resolution_date > to_date)`; hồ sơ giải quyết sau kỳ vẫn nằm trong danh sách và kết quả chính phải để trống, chỉ ghi chú ngày giải quyết sau kỳ.

## Nguyên tắc ngày và fallback

1. Án thụ lý:
   - lấy `case_occurrences.acceptance_date` nếu có occurrence;
   - fallback về `case_files.acceptance_date` khi hồ sơ chưa có occurrence.
2. Án giải quyết:
   - lấy `case_resolution_events.event_date` với `counted_as_resolved IS TRUE`;
   - fallback về `case_files.closed_date` khi hồ sơ chưa có occurrence/event tương ứng.
3. Án còn lại:
   - với occurrence: occurrence đã thụ lý đến `to_date` và chưa có event giải quyết cùng occurrence đến `to_date`;
   - fallback `case_files.acceptance_date <= to_date` và `closed_date IS NULL OR closed_date > to_date` khi chưa có occurrence.

## Cột xuất danh sách chuẩn khi gom theo loại án

Giữ thứ tự cột:

1. `STT`
2. `Loại án`
3. `Số/ngày thụ lý`
4. `Nội dung vụ án`
5. `Cấp xét xử`
6. `Thẩm phán chủ tọa`
7. `Hội đồng`
8. `Thư ký`
9. `Thụ lý trong kỳ`
10. `Giải quyết trong kỳ`
11. `Còn lại cuối kỳ`
12. `Kết quả giải quyết`
13. `Số/ngày giải quyết`

`STT` phải đánh lại theo từng loại án:

```sql
ROW_NUMBER() OVER (
    PARTITION BY case_type_display
    ORDER BY acceptance_date, case_number, case_code, case_id, occurrence_id
)
```

Không dùng:

```sql
PARTITION BY case_type_display, list_group
```

## Validation bắt buộc

- Output không có cột `Nhóm danh sách` nếu yêu cầu là gom theo `Loại án`.
- Báo cáo tổng số dòng theo loại án.
- Báo cáo số dòng có cờ `Thụ lý trong kỳ`, `Giải quyết trong kỳ`, `Còn lại cuối kỳ`.
- Kiểm tra không có duplicate không mong muốn theo cặp `case_id/occurrence_id`.
- Báo cáo số dòng thiếu `Thẩm phán chủ tọa`, `Hội đồng`, `Thư ký` nếu nhiệm vụ yêu cầu kiểm soát chất lượng dữ liệu.
