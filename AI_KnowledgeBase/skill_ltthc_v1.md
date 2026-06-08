# Skill LTTHC v1 - Tố tụng hành chính

## Phạm vi
Vụ án hành chính về quyết định hành chính, hành vi hành chính, quyết định kỷ luật buộc thôi việc, danh sách cử tri.

## Schema lõi
```yaml
case_type: administrative
case_number: string
acceptance_date: date
plaintiff: party[]
defendant_agency: agency
challenged_object_type: decision|act|dismissal|voter_list
challenged_decision_number: string
issuing_agency: string
issue_date: date
status: pending|resolved|suspended|appealed
```

## Workflow
Khởi kiện -> thụ lý -> đối thoại -> chuẩn bị xét xử -> xét xử sơ thẩm -> phúc thẩm -> thi hành án hành chính.

## Validation
- Thiếu đối tượng bị kiện: ERROR
- Thiếu cơ quan/người bị kiện: ERROR
- Có yêu cầu bồi thường nhưng thiếu số tiền/căn cứ: WARNING

## KPI
Tỷ lệ hủy/sửa quyết định, đối thoại thành, quá hạn, thi hành án hành chính.
