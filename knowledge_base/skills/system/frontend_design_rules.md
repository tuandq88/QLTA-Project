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
- Bộ lọc kỳ phải ghi rõ ngày đầu và ngày cuối đều được tính.
- Với hồ sơ giải quyết sau `to_date`, không hiển thị kết quả đó như kết quả chính của kỳ; dùng badge `Sau kỳ báo cáo`, highlight nhẹ và ghi ngày sau kỳ trong cột ghi chú.
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
- Nếu dùng toast message cho validation, toast phải có severity rõ, không tự ghi đè dữ liệu chính, không che form/action chính, và lỗi chỉ tự mất khi dữ liệu đã được sửa hoặc nguồn validation thay đổi.

## 7. Output tối thiểu khi thiết kế màn hình

- Mục đích màn hình.
- Design Read: loại màn hình, người dùng chính, mức trang trọng, density, motion.
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
skills/design_taste_frontend_skill.md
skills/design_system_skill.md
skills/form_design_skill.md
skills/dashboard_design_skill.md
skills/data_table_design_skill.md
skills/validation_ui_skill.md
```

## 9. TasteSkill Integration

TasteSkill đã được cài vào `.agents/skills/design-taste-frontend/SKILL.md` và được ràng buộc cho QLTA-Project qua `skills/design_taste_frontend_skill.md`.

Quy tắc dùng:

- Chỉ dùng TasteSkill để cải thiện layout, component composition, visual hierarchy, spacing, typography, motion và design review.
- Trước khi tạo UI mới, phải đọc brief nghiệp vụ và xác định người dùng chính: lãnh đạo, Thẩm phán, Thư ký, thống kê viên hoặc quản trị.
- Thiết kế phải phù hợp hệ thống hành chính nhà nước: nghiêm túc, rõ ràng, ưu tiên độ tin cậy và khả năng rà soát dữ liệu.
- Ưu tiên data table, form nhập liệu, detail view, dashboard, cảnh báo nghiệp vụ và report workflow.
- Tránh landing-page hero, giao diện generic, card rỗng, placeholder giả, hiệu ứng thừa, gradient/trang trí quá đà hoặc phong cách giải trí.
- Kiểm tra responsive desktop/tablet, accessibility, contrast, spacing, typography và trạng thái focus.
- Nếu frontend dùng React/Next.js/Tailwind/shadcn/ui, TasteSkill chỉ phối hợp với design system hiện có; không thay thế hoặc cài lại Tailwind/shadcn nếu đã có.
- Nếu frontend chưa hỗ trợ dark mode thì không ép thêm; nếu đã hỗ trợ thì component mới phải tương thích dark mode.

## 10. Gom nhóm chức năng theo phân hệ

Khi số lượng màn hình tăng, điều hướng phải gom theo logic hệ thống thay vì liệt kê phẳng:

- `Điều hành`: dashboard, KPI, cảnh báo, drill-down và báo cáo phục vụ lãnh đạo.
- `Danh sách`: worklist, list/report, tra cứu, lọc, phân trang và mở chi tiết.
- `Nhập liệu`: form tạo mới, form bổ sung dữ liệu vòng đời, validation và submit theo quyền.

Mỗi mục điều hướng nên có `label`, `description`, nhóm nghiệp vụ và route/component kỹ thuật. Nhãn hiển thị dùng tiếng Việt UTF-8; id, route và component dùng tiếng Anh. Không đặt dashboard vào nhóm nhập liệu, không đặt form ghi dữ liệu vào nhóm dashboard, và không tạo KPI mới chỉ để lấp chỗ trong menu.

## 11. Render biểu mẫu thống kê từ workbook

- Workbook trong `bieu_mau/` là nguồn trình bày; không dựng lại thủ công từng header vì dễ sai merge, độ rộng và thứ tự cột.
- Metadata frontend phải giữ tối thiểu: sheet, số hàng/cột, merge, kích thước hàng/cột, font, fill, alignment và border.
- Số liệu mẫu dưới dòng đánh số cột không được đóng gói làm dữ liệu thật. Ô chưa có mapping phải để trống, không thay bằng `0`.
- Giá trị API chỉ được đổ vào đúng cột và dòng tổng theo mapping đã duyệt; trạng thái `source`, `formula`, `unmapped`, `deferred` phải phân biệt được và có truy vết.
- Mẫu chưa có API vẫn được hiển thị ở chế độ khung chỉ đọc, đồng thời vô hiệu hóa thao tác tính/xuất để tránh tạo báo cáo không có căn cứ.
- Bảng rộng phải cuộn hai chiều và có zoom; không co ép làm thay đổi tỷ lệ cột của workbook.
