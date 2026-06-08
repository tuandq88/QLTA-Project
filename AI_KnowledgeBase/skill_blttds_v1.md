# Skill BLTTDS v1 - Tố tụng dân sự

## Phạm vi
Dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động, việc dân sự.

## Mục tiêu AI
Đọc hiểu hồ sơ, phân loại loại việc, sinh trường nhập liệu, kiểm tra quá hạn, thống kê thụ lý - giải quyết - tồn.

## Schema lõi
```yaml
case_type: civil|family|business|labor|civil_matter
case_number: string
acceptance_date: date
dispute_type: string
plaintiff: party[]
defendant: party[]
judge: string
status: pending|resolved|suspended|temporarily_suspended|appealed
```

## Workflow
Tiếp nhận đơn -> xem xét đơn -> thụ lý -> hòa giải/đối thoại -> chuẩn bị xét xử -> xét xử sơ thẩm -> phúc thẩm -> giám đốc thẩm/tái thẩm.

## Validation
- Thiếu ngày thụ lý: ERROR
- Thiếu loại tranh chấp: ERROR
- Quá hạn chuẩn bị xét xử: WARNING
- Hòa giải thành nhưng chưa có quyết định công nhận: WARNING

## KPI
Thụ lý, giải quyết, tồn, quá hạn, hòa giải thành, hủy/sửa, án tạm đình chỉ.
