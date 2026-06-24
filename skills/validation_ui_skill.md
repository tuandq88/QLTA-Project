# Validation UI Skill

## Skill ID

`VALIDATION_UI_SKILL`

## Mục đích

Thiết kế giao diện hiển thị lỗi, cảnh báo, đề xuất xử lý và dữ liệu bất thường từ Validation Rules, không tự sửa dữ liệu chính.

## Stack ưu tiên khi frontend đã sẵn sàng

- shadcn/ui: `alert`, `badge`, `accordion`, `tooltip`, `dialog`, `sheet`, `toast`.
- Lucide React cho icon severity.
- Zod chỉ dùng cho validation phía client khi dự án đã có TypeScript schema phù hợp.

## Quy tắc hiển thị validation

- Hiển thị theo `rule_code`, `severity`, `message`, `field_name`, `case_id`, `checked_at`, `checked_by`, `legal_basis`, `suggested_action` nếu nguồn dữ liệu có.
- Severity phải rõ: `info`, `warning`, `error`, `critical`.
- Lỗi field đặt gần field; lỗi nghiệp vụ tổng đặt trong validation panel.
- Cảnh báo thiếu căn cứ pháp lý phải ghi cần rà soát, không tự kết luận.
- Với cảnh báo đếm trùng, phải chỉ ra nghi vấn entity/filter/aggregation nếu dữ liệu cung cấp đủ.

## Trạng thái bắt buộc

- `loading`: đang kiểm tra validation.
- `empty`: chưa có lỗi/cảnh báo.
- `error`: lỗi chạy validation.
- `readonly`: chỉ xem kết quả kiểm tra.
- `permission_denied`: không hiện chi tiết vượt quyền.

## Không được làm

- Không tự ghi đè dữ liệu chính để sửa lỗi.
- Không ẩn lỗi critical sau khi người dùng đổi filter.
- Không tự tạo legal_basis nếu tài liệu nguồn chưa có.

## Output

```yaml
Validation surface:
Rules shown:
Severity design:
Field-level behavior:
Summary behavior:
Suggested actions:
Permissions:
States:
Implementation notes:
```

