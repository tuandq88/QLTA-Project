# Design System Skill

## Skill ID

`DESIGN_SYSTEM_SKILL`

## Mục đích

Thiết kế hệ thống giao diện nhất quán cho QLTA-Project theo hướng miễn phí, mã nguồn mở, nghiêm túc và phù hợp cơ quan nhà nước.

## Stack ưu tiên khi frontend đã sẵn sàng

- React hoặc Next.js/Vite React nếu dự án chọn frontend JavaScript/TypeScript.
- Tailwind CSS cho utility styling.
- shadcn/ui để copy component source vào repo, không dùng như dịch vụ trả phí.
- Radix UI cho primitive accessible.
- Lucide React cho icon.

Chỉ cài dependency khi repo đã có `package.json`, framework rõ ràng và có nhu cầu component cụ thể. Không cài tràn lan.

## Nguyên tắc thiết kế

- Giao diện rõ ràng, tiết chế, ưu tiên đọc số liệu và nhập liệu chính xác.
- Không dùng palette một màu đơn điệu hoặc hiệu ứng trang trí nặng.
- Dùng token cho màu, spacing, radius, typography và trạng thái.
- Card chỉ dùng cho nhóm thông tin có ranh giới rõ; không lồng card nhiều tầng.
- Component phải có trạng thái `loading`, `empty`, `error`, `readonly`, `permission_denied`.
- Mọi nhãn nghiệp vụ dùng tiếng Việt UTF-8; tên component/file/route dùng tiếng Anh.

## Token đề xuất

- `background`, `foreground`, `card`, `border`, `muted`, `primary`, `destructive`, `warning`, `success`.
- `case_status`, `deadline_status`, `validation_severity`, `permission_state`.
- Radius mặc định 6-8px cho công cụ nghiệp vụ.
- Bảng và form ưu tiên density vừa phải, không dùng hero/marketing layout.

## Không được làm

- Không tạo brand guideline, màu trạng thái hoặc biểu tượng làm sai nghĩa nghiệp vụ.
- Không tự đặt KPI/chỉ tiêu mới.
- Không hard-code danh mục án, trạng thái hồ sơ hoặc vai trò nếu đã có nguồn chuẩn.
- Không thêm Figma, Uizard, v0 API hoặc dịch vụ thiết kế trả phí vào source code.

## Output

```yaml
Design tokens:
Component inventory:
Layout rules:
State rules:
Accessibility notes:
Implementation notes:
Open questions:
```

