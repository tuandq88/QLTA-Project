# UI/UX Design Skill Pack

## Skill ID

`UI_UX_DESIGN_SKILL_PACK`

## Dùng khi nào

Dùng cùng `UI_UX_DESIGN_AGENT` khi cần thiết kế màn hình, component, dashboard, form nhập liệu, bảng dữ liệu, bộ lọc, prototype hoặc đặc tả handoff frontend cho QLTA-Project.

## Skill con đã cài

- `skills/design_system_skill.md`: design system, token, component inventory.
- `skills/form_design_skill.md`: form nhập liệu và validation theo field.
- `skills/dashboard_design_skill.md`: dashboard, KPI, biểu đồ và cảnh báo.
- `skills/data_table_design_skill.md`: bảng dữ liệu có search/filter/sort/pagination.
- `skills/validation_ui_skill.md`: UI hiển thị validation, cảnh báo, suggested action.

## Nguồn phải đối chiếu

- Data Dictionary: `database/schema/DATABASE_TABLES_DATA_DICTIONARY_VI.md` hoặc file data dictionary liên quan trong `knowledge_base/data/`.
- Formula Catalog: các file `formula_catalog.json` hoặc skill thống kê liên quan.
- Validation Rules: các file `validation_rules.json` và `knowledge_base/skills/system/frontend_design_rules.md`.
- Skill nghiệp vụ theo loại án hoặc phân hệ: thống kê, phân công án, kháng cáo/kháng nghị, deadline, KPI.

## Quy tắc thiết kế

- Thiết kế UI theo hướng miễn phí, ưu tiên React, Tailwind CSS, shadcn/ui.
- Thư viện cộng đồng ưu tiên khi frontend đã chọn React/TypeScript: Radix UI, Lucide React, TanStack Table, React Hook Form hoặc TanStack Form, Zod, Recharts; Storybook chỉ dùng nếu cần quản lý component nhiều màn hình.
- Không yêu cầu API trả phí, SDK thương mại hoặc dịch vụ bắt buộc ngoài repo.
- Không cài dependency khi repo chưa có framework/frontend package rõ ràng.
- Technical names dùng tiếng Anh; nhãn hiển thị dùng tiếng Việt UTF-8.
- Không tự tạo nghiệp vụ mới; nếu thiếu field, rule hoặc công thức, ghi `needs_business_confirmation`.
- Không dùng text tự do để thay thế enum/danh mục đã chuẩn hóa.
- Không gộp dữ liệu theo `case_id` nếu skill yêu cầu thống kê theo occurrence, event hoặc defendant.
- Không hiển thị số tổng/KPI nếu chưa có Formula Catalog hoặc nguồn dữ liệu rõ ràng.

## Checklist màn hình

- Có tiêu đề, mục đích và đối tượng sử dụng rõ.
- Có bộ lọc thời gian, đơn vị, loại án hoặc trạng thái nếu nghiệp vụ cần.
- Có trạng thái `loading`, `empty`, `error`, `readonly`, `permission_denied`.
- Có vùng validation theo field, severity, message, legal_basis nếu có và suggested_action.
- Có hiển thị cảnh báo sắp hết hạn/quá hạn, dữ liệu thiếu, dữ liệu bất thường.
- Có phân quyền xem/sửa/xuất/duyệt theo vai trò.
- Có cơ chế chống đếm trùng trong table/dashboard/report.
- Có ghi chú nguồn dữ liệu, API cần gọi và edge cases.

## Component ưu tiên

- Form nhập liệu hồ sơ vụ án.
- Case lifecycle timeline.
- Table danh sách có filter, sort, pagination và column visibility.
- Validation panel.
- Deadline alert banner.
- Permission-aware action bar.
- Dashboard KPI cards, chart layout và drill-down table.
- Readonly detail view cho lãnh đạo.

## Output mẫu

```yaml
Screen/Component:
Purpose:
Route:
Inputs:
Layout:
States:
Validation:
Permissions:
Anti-duplication:
Implementation notes:
Open questions:
```
