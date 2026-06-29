---
name: case_period_reporting
description: Quy tắc thống kê, API, Excel/PDF và giao diện danh sách vụ án theo khoảng thời gian đóng, bao gồm ngày đầu và ngày cuối.
version: 1.0
domain: judicial_statistics
---

# Skill: Báo cáo vụ án theo kỳ và trạng thái tại ngày cuối kỳ

## Tham số bắt buộc

- `from_date`: ngày đầu kỳ báo cáo.
- `to_date`: ngày cuối kỳ báo cáo.
- Điều kiện ngày là khoảng đóng: cả `from_date` và `to_date` đều được tính.
- Validation bắt buộc: `from_date <= to_date` và ngày có định dạng ISO `YYYY-MM-DD` tại API/database.

## Ba danh sách chuẩn

```sql
-- Thụ lý mới trong kỳ
acceptance_date >= from_date AND acceptance_date <= to_date

-- Thụ lý trước kỳ nhưng chưa giải quyết đến cuối kỳ
acceptance_date < from_date
AND (resolution_date IS NULL OR resolution_date > to_date)

-- Có kết quả giải quyết trong kỳ
resolution_date >= from_date AND resolution_date <= to_date
```

`BETWEEN from_date AND to_date` được phép dùng vì PostgreSQL tính cả hai biên.

## Trạng thái tại cuối kỳ

- Không dùng `case_status` hiện tại để quyết định một hồ sơ đã giải quyết trong kỳ.
- Hồ sơ có `resolution_date > to_date` không thuộc danh sách đã giải quyết trong kỳ.
- Hồ sơ đó không được loại khỏi danh sách tồn/chưa giải quyết nếu thỏa điều kiện của danh sách.
- Trong danh sách tồn, Excel, PDF và UI: đặt kết quả/ngày giải quyết chính thành `NULL` hoặc trống; ghi chú `Giải quyết sau kỳ báo cáo: dd/mm/yyyy`.
- UI phải highlight nhẹ hoặc hiển thị badge `Sau kỳ báo cáo`.

## Nguồn ngày

- Báo cáo case-level dùng `case_files.acceptance_date` và `case_files.closed_date`.
- Báo cáo occurrence-level dùng `case_occurrences.acceptance_date` và `case_resolution_events.event_date` có `counted_as_resolved IS TRUE`, theo skill chuyên biệt.
- Không dùng ngày nhập liệu, `created_at`, `updated_at` hoặc trạng thái hiện tại thay cho ngày nghiệp vụ.

## Chống đếm trùng

- Mỗi chỉ tiêu phải đếm đúng grain của báo cáo: `case_id`, `occurrence_id` hoặc `defendant_id`.
- Ba danh sách là ba lát cắt nghiệp vụ độc lập; không cộng cơ học số dòng của ba danh sách để tạo tổng vì một hồ sơ có thể xuất hiện ở nhiều danh sách hợp lệ.
- Biểu đồ tháng phải nhóm thụ lý theo `acceptance_date` và giải quyết theo `resolution_date`; không gán giải quyết vào tháng thụ lý.

## API và xuất báo cáo

- API danh sách: `GET /api/statistics/case-period` với `category` là `accepted_in_period`, `opening_pending` hoặc `resolved_in_period`.
- API xuất: `GET /api/statistics/case-period/export?format=xlsx|pdf`.
- API chấp nhận cả `from_date`/`to_date` (chuẩn nội bộ) và alias `fromDate`/`toDate`; service phải chuẩn hóa về một cặp giá trị trước khi tạo SQL.
- API/dashboard/export phải dùng cùng một truy vấn phân loại hoặc cùng service để tránh lệch số liệu.
- Excel/PDF dùng font Tahoma; giữ cột ghi chú sau kỳ và không đưa kết quả sau kỳ vào cột kết quả chính.

## Test biên bắt buộc

1. Thụ lý đúng `from_date` và đúng `to_date` đều thuộc kỳ.
2. Giải quyết đúng `from_date` và đúng `to_date` đều thuộc kỳ.
3. Giải quyết sau `to_date` đúng một ngày không được tính đã giải quyết và vẫn được nhận diện là tồn tại cuối kỳ.
4. Hồ sơ chưa có ngày giải quyết được nhận diện theo điều kiện tồn.
5. `from_date > to_date` bị từ chối.
