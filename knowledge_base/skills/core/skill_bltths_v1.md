# Skill BLTTHS v1 - Tố tụng hình sự

## Phạm vi
Án hình sự sơ thẩm, phúc thẩm, vụ án có bị cáo chưa thành niên, quản lý biện pháp ngăn chặn.

## Schema lõi
```yaml
case_type: criminal
case_number: string
acceptance_date: date
offense: string
penal_code_article: string
indictment_number: string
procuracy: string
defendants: defendant[]
preventive_measures: measure[]
status: pending|tried|returned_for_additional_investigation|appealed
```

## Workflow
Thụ lý -> nghiên cứu hồ sơ -> quyết định đưa vụ án ra xét xử/trả hồ sơ/tạm đình chỉ -> xét xử sơ thẩm -> phúc thẩm -> giám đốc thẩm/tái thẩm.

## Validation
- Thiếu điều luật truy tố: ERROR
- Bị cáo đang tạm giam nhưng thiếu ngày hết hạn: ERROR
- Sắp hết hạn tạm giam: WARNING
- Trả hồ sơ nhiều lần: WARNING

## KPI
Tỷ lệ xử đúng hạn, trả hồ sơ, án hủy/sửa, án treo, cảnh báo tạm giam, số bị cáo.
