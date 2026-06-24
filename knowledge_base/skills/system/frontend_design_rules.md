# Skill: Frontend Design Rules

## 1. Mục đích

Hướng dẫn thiết kế UI nhập liệu, danh sách, chi tiết, report và dashboard cho QLTA-Project.

## 2. Quy tắc đặt tên

- Component, file, variable, hook và route kỹ thuật dùng tiếng Anh.
- UI label, thông báo, tên biểu mẫu và mô tả nghiệp vụ dùng tiếng Việt UTF-8.
- Không dùng tiếng Việt có dấu trong tên file/component/variable.

## 3. Form nhập liệu

- Form phải lấy danh mục từ API, không hard-code text lặp lại.
- Field phải bám schema và data dictionary.
- Với field ngày, UI phải phân biệt rõ `from_date`, `to_date`, `as_of_date`, `acceptance_date`, `result_date`.
- Không cho AI hoặc UI tự ghi đè dữ liệu chính nếu workflow chưa xác nhận.

## 4. List/Report

- List/report phải bám skill nghiệp vụ tương ứng.
- Nếu skill yêu cầu occurrence-level, UI phải hiển thị từng occurrence/event.
- Nếu skill yêu cầu defendant-level, UI phải hiển thị từng bị cáo.
- Không gộp theo `case_id` khi việc gộp làm mất chi tiết bị cáo hoặc vòng đời thống kê.

## 5. Hình sự phúc thẩm

- Màn hình án hình sự phúc thẩm phải hiển thị kết quả theo từng bị cáo khi vụ án có nhiều bị cáo.
- Mỗi bị cáo chỉ có một final result trong cùng một vụ phúc thẩm.
- Sửa án phải cho phép nhập nhiều tiêu chí sửa án.
- Trạng thái vụ án đã giải quyết chỉ bật khi toàn bộ bị cáo có final result đến ngày chốt.

## 6. Validation UI

- Hiển thị lỗi validation theo field, severity và suggested action.
- Không che lỗi bằng tính toán tổng trực tiếp từ text tự do.
- Với dữ liệu thiếu căn cứ pháp lý, hiển thị cảnh báo cần rà soát.

## 7. Output tối thiểu khi thiết kế màn hình

- Mục đích màn hình.
- Route/component.
- API cần gọi.
- Field hiển thị/nhập liệu.
- Bộ lọc.
- Validation.
- Edge cases.
- Test UI.

## 8. UI/UX Design Agent

Khi cần thiết kế màn hình, component, layout, form, dashboard hoặc prototype, có thể gọi `UI_UX_DESIGN_AGENT` theo cấu hình:

```text
agents/UI_UX_DESIGN_AGENT.md
skills/ui_ux_design_skill_pack.md
prompts/ui_screen_generation_prompt.md
```

Agent này chỉ thiết kế UI/UX, không sửa backend, database, schema, seed, công thức thống kê hoặc logic nghiệp vụ nếu task không yêu cầu rõ.

Bộ skill UI/UX miễn phí đi kèm:

```text
skills/design_system_skill.md
skills/form_design_skill.md
skills/dashboard_design_skill.md
skills/data_table_design_skill.md
skills/validation_ui_skill.md
```
