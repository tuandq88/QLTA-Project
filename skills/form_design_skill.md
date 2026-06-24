# Form Design Skill

## Skill ID

`FORM_DESIGN_SKILL`

## Mục đích

Thiết kế form nhập liệu hồ sơ, sự kiện, thời hạn, phân công án và kết quả giải quyết theo Data Dictionary và Validation Rules hiện có.

## Stack ưu tiên khi frontend đã sẵn sàng

- React Hook Form hoặc TanStack Form; ưu tiên thư viện dự án đang dùng.
- Zod chỉ dùng khi dự án đã chọn validation TypeScript hoặc cần schema UI rõ ràng.
- shadcn/ui: `form`, `input`, `textarea`, `select`, `checkbox`, `radio-group`, `date-picker`, `calendar`, `popover`, `alert`.

Không cài cả React Hook Form và TanStack Form cùng lúc nếu chưa có lý do rõ.

## Quy tắc thiết kế form

- Field phải bám Data Dictionary, schema hoặc API contract.
- Danh mục lấy từ API/reference data; không hard-code danh mục nghiệp vụ lặp lại.
- Phân biệt rõ ngày nghiệp vụ: `acceptance_date`, `result_date`, `from_date`, `to_date`, `as_of_date`.
- Field readonly phải vẫn hiển thị nguồn dữ liệu và lý do không cho sửa.
- Submit phải có xác nhận với thao tác nhạy cảm; AI không tự ghi đè dữ liệu chính.
- Validation hiển thị theo field, severity, message, legal_basis nếu có và suggested_action.

## Trạng thái bắt buộc

- `loading`: skeleton hoặc disabled form.
- `empty`: chưa có dữ liệu, có hướng dẫn nguồn dữ liệu cần nhập.
- `error`: lỗi tải dữ liệu hoặc lỗi validation tổng.
- `readonly`: xem dữ liệu không cho sửa, vẫn có audit/context.
- `permission_denied`: nêu quyền cần có, không hiện action bị cấm.

## Không được làm

- Không tạo field nghiệp vụ mới khi chưa có Data Dictionary hoặc yêu cầu rõ.
- Không dùng text tự do thay enum/danh mục chuẩn.
- Không bỏ qua kiểm tra trùng hồ sơ, trùng sự kiện hoặc trùng bị cáo nếu skill nghiệp vụ yêu cầu.

## Output

```yaml
Form name:
Purpose:
Fields:
Reference data:
Validation:
States:
Permissions:
Submit behavior:
Anti-duplication:
Implementation notes:
```

