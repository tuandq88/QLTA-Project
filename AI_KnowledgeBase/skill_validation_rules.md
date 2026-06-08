# Validation Rules tổng

## Nhóm bắt buộc
- case_number không rỗng
- acceptance_date không rỗng khi status >= thụ lý
- judge không rỗng khi đã phân công

## Nhóm thời hạn
- due_date < today và status chưa giải quyết => overdue=true
- remaining_days <= 7 => warning

## Nhóm thống kê
- Một vụ án chỉ tính một lần trong kỳ báo cáo
- Đã giải quyết phải có resolved_date và resolution_type
