# Frontend

Thư mục dành cho mã nguồn frontend của ứng dụng.

Chưa chọn framework ở giai đoạn chuẩn hóa repo. Giao diện cần ưu tiên các luồng nhập liệu hồ sơ, dashboard lãnh đạo, phân công án và theo dõi kháng cáo/kháng nghị.

Khi bắt đầu triển khai frontend React/TypeScript, ưu tiên bộ công cụ miễn phí, mã nguồn mở:

- Tailwind CSS.
- shadcn/ui với Radix UI.
- Lucide React.
- TanStack Table cho bảng dữ liệu phức tạp.
- React Hook Form hoặc TanStack Form, chọn một theo stack thực tế.
- Zod nếu dự án dùng validation TypeScript.
- Recharts cho dashboard/chart.
- Storybook chỉ khi cần quản lý nhiều component dùng chung.

Chưa cài các dependency trên ở giai đoạn này vì repo chưa có `package.json` hoặc framework frontend được chọn. Khi cài, phải kiểm tra build/lint/typecheck và không đổi UI framework chính nếu đã ổn định.
