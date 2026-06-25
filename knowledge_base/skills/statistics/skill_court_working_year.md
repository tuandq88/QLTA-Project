---
name: court_working_year
description: Quy tắc xác định năm công tác của Tòa án cho báo cáo, dashboard, KPI, API filter và truy vấn AI.
version: 1.0
domain: judicial_statistics
---

# Skill: Năm công tác Tòa án

## Mục đích

Dùng khi cần quy đổi năm công tác Tòa án sang khoảng ngày cụ thể cho báo cáo thống kê, dashboard KPI, API filter, truy vấn AI hoặc kiểm tra dữ liệu.

## Quy tắc bắt buộc

- Năm công tác của Tòa án được tính từ ngày 01/10 của năm trước đến ngày 30/09 của năm công tác.
- Ví dụ: năm công tác 2026 được tính từ ngày 01/10/2025 đến hết ngày 30/09/2026.
- Khi nhận `working_year = Y`, phải quy đổi:

```text
from_date = (Y - 1)-10-01
to_date   = Y-09-30
```

## Nguyên tắc áp dụng

1. Báo cáo năm, dashboard KPI và thống kê theo năm công tác phải dùng `from_date` và `to_date` đã quy đổi từ `working_year`.
2. Không dùng mặc định năm dương lịch 01/01-31/12 cho năm công tác Tòa án nếu người dùng không yêu cầu rõ.
3. API hoặc truy vấn AI trả kết quả theo năm công tác phải hiển thị/ghi trace kỳ dữ liệu đã dùng.
4. Nếu người dùng nhập cả `working_year` và `from_date`/`to_date`, phải ưu tiên khoảng ngày cụ thể hoặc yêu cầu xác nhận nếu hai nguồn mâu thuẫn.
5. Khi kiểm thử báo cáo theo năm công tác, cần có case kiểm tra ranh giới ngày 01/10 và 30/09.

## Ví dụ

```yaml
working_year: 2026
from_date: 2025-10-01
to_date: 2026-09-30
```

Không diễn giải năm công tác 2026 thành `2026-01-01` đến `2026-12-31`.
