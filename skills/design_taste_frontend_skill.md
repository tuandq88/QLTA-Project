# Design Taste Frontend Skill Wrapper

## Skill ID

`DESIGN_TASTE_FRONTEND_SKILL`

## Nguồn

- Website: `https://www.tasteskill.dev/`
- GitHub: `https://github.com/Leonxlnx/taste-skill`
- Skill đã cài: `.agents/skills/design-taste-frontend/SKILL.md`
- Install command: `npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"`
- License nguồn: MIT.

## Mục đích trong QLTA-Project

Wrapper này dùng TasteSkill như lớp nâng chất lượng thiết kế frontend cho hệ thống quản lý và điều hành TAND hai cấp tỉnh Quảng Ngãi. TasteSkill chỉ hỗ trợ quyết định về layout, component composition, visual hierarchy, spacing, typography, motion và design review.

Không dùng TasteSkill để tạo nghiệp vụ Tòa án, chỉ tiêu thống kê, công thức, biểu mẫu, schema, migration, seed, backend hoặc logic thống kê.

## Ngữ cảnh bắt buộc trước khi dùng

Trước khi tạo hoặc review UI, phải đọc:

1. Brief nghiệp vụ của màn hình.
2. `agents/UI_UX_DESIGN_AGENT.md`.
3. `skills/ui_ux_design_skill_pack.md`.
4. `knowledge_base/skills/system/frontend_design_rules.md`.
5. Data Dictionary, Formula Catalog, Validation Rules và skill nghiệp vụ liên quan.

## Design read cho QLTA

Khi áp dụng TasteSkill, đọc QLTA là:

```text
Ứng dụng quản lý nghiệp vụ Tòa án cho lãnh đạo, Thẩm phán, Thư ký, thống kê viên và quản trị;
ngôn ngữ thiết kế nghiêm túc, rõ ràng, hành chính nhà nước, ưu tiên độ tin cậy và khả năng rà soát dữ liệu.
```

Thiết lập mặc định:

```text
DESIGN_VARIANCE: 3-4
MOTION_INTENSITY: 1-2
VISUAL_DENSITY: 5-7
```

## Quy tắc tích hợp

- Ưu tiên data table, form nhập liệu, detail view, dashboard, cảnh báo nghiệp vụ và report workflow.
- Tránh landing-page hero, card rỗng, placeholder giả, gradient/trang trí quá đà, hiệu ứng thừa hoặc phong cách giải trí.
- Dùng typography rõ, khoảng cách nhất quán, contrast đủ, thông tin dễ quét trên desktop/tablet.
- Motion chỉ dùng để phản hồi trạng thái hoặc chuyển đổi nhẹ; phải tôn trọng `prefers-reduced-motion`.
- Không thêm API trả phí, SaaS bắt buộc hoặc dependency thương mại.
- Nếu frontend dùng React/Next.js/Tailwind/shadcn/ui, TasteSkill chỉ phối hợp với design system hiện có; không thay thế hoặc cài lại Tailwind/shadcn nếu đã có.
- Nếu frontend chưa có dark mode, không ép thêm dark mode. Nếu đã có, mọi component mới phải tương thích dark mode.

## Trạng thái UI bắt buộc

Mọi màn hình nghiệp vụ phải có:

- `loading`
- `empty`
- `error`
- `readonly`
- `permission_denied`

## Checklist review

- Đúng đối tượng sử dụng: lãnh đạo, Thẩm phán, Thư ký, thống kê viên hoặc quản trị.
- Bám Data Dictionary, Formula Catalog, Validation Rules và skill nghiệp vụ.
- Không bịa field, chỉ tiêu, công thức hoặc căn cứ pháp lý.
- Có responsive desktop/tablet; mobile nếu phạm vi màn hình yêu cầu.
- Có kiểm tra accessibility, contrast, spacing, typography và trạng thái focus.
- Có cảnh báo validation, cảnh báo dữ liệu bất thường, cảnh báo thời hạn và cơ chế tránh đếm trùng khi liên quan thống kê.
