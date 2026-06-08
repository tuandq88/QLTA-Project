# Deadline Engine

## Nguyên tắc
Mỗi hồ sơ có nhiều mốc thời hạn, tính từ ngày phát sinh tố tụng tương ứng.

## Schema
```yaml
deadline_type: prepare_trial|detention|appeal|evidence_submission|enforcement
start_date: date
duration_days: integer
due_date: date
extension_allowed: boolean
extended_due_date: date
```

## Output
normal, near_due, overdue, missing_data.
