# Frontend

Thư mục frontend hiện dùng React, TypeScript và Vite để triển khai màn hình quản lý hồ sơ án.

## Màn hình hiện có

- `src/pages/cases/CaseWorklistPage.tsx`: trang Quản lý hồ sơ án.
- `src/components/cases/CaseWorklistFilters.tsx`: bộ lọc theo tên/mã/tóm tắt, loại án, tòa án, ngày thụ lý.
- `src/components/cases/CaseWorklistTable.tsx`: bảng danh sách hồ sơ án.
- `src/components/cases/CaseOverviewPanel.tsx`: khung chi tiết hồ sơ án lấy từ API overview.
- `src/components/common/DataState.tsx`: trạng thái loading, empty, error, readonly và permission denied.
- `src/pages/cases/CaseProgressDashboardPage.tsx`: dashboard và ba danh sách thụ lý mới, tồn trước kỳ, giải quyết trong kỳ; hỗ trợ xuất Excel/PDF.
- `src/pages/statistics/StatisticsWorkbookPage.tsx`: danh mục 24 trang biểu mẫu thống kê theo loại án và cấp xét xử.
- `src/components/statistics/WorkbookGrid.tsx`: renderer giữ cấu trúc ô gộp, kích thước hàng/cột, font, màu, căn lề và đường viền của workbook nguồn.

## Kết nối dữ liệu

Frontend gọi dữ liệu thật từ backend:

- `GET /api/cases/worklist`
- `GET /api/cases/:id/overview`
- `GET /api/courts`
- `GET /api/dashboard/case-progress`
- `GET /api/statistics/case-period`
- `GET /api/statistics/case-period/export`
- `GET /api/statistics/reports/:formCode`
- `GET /api/statistics/reports/:formCode/export?format=xlsx`

Mặc định frontend gọi `http://127.0.0.1:3000`. Có thể đổi bằng biến môi trường:

```bash
VITE_API_BASE_URL=http://127.0.0.1:3000
```

Màn hình không hard-code dữ liệu nghiệp vụ thật. Nếu backend chưa chạy hoặc chưa có dữ liệu, giao diện hiển thị trạng thái lỗi hoặc rỗng.

## Lệnh chạy

```bash
npm install
npm run dev
npm run typecheck
npm run build
```

Khi workbook trong `bieu_mau/` thay đổi, sinh lại metadata giao diện trước khi build:

```bash
npm run generate:statistics-workbooks
```

Script `tools/generate_statistics_workbooks.py` chỉ đọc file nguồn, không ghi đè workbook. Số liệu mẫu ở vùng dữ liệu được bỏ khỏi JSON; giao diện chỉ đổ giá trị do API thống kê trả về. Hiện 12 mẫu sơ thẩm/phúc thẩm 1A-6B có API tính số liệu. Các mẫu giám đốc thẩm/tái thẩm hiển thị đúng khung workbook nhưng để trống cho đến khi có mapping nguồn và công thức được duyệt.

## Nguyên tắc UI

- Giao diện nghiêm túc, rõ ràng, phù hợp hệ thống quản lý của cơ quan nhà nước.
- Không tự tạo chỉ tiêu, công thức, căn cứ pháp lý hoặc loại nghiệp vụ ngoài schema/API hiện có.
- Các dữ liệu chưa được endpoint trả về hiển thị “Chưa có dữ liệu” hoặc ghi rõ chưa có trong endpoint hiện tại.
- Khi bổ sung Tailwind/shadcn/ui sau này, không thay thế cấu trúc dữ liệu hoặc logic API hiện có nếu chưa có yêu cầu riêng.

## Nhóm chức năng giao diện

`src/main.tsx` gom các màn hình theo 03 nhóm logic thiết kế hệ thống:

- `Điều hành`: dashboard, KPI, cảnh báo và drill-down phục vụ lãnh đạo.
- `Danh sách`: tra cứu, lọc, rà soát và mở chi tiết hồ sơ từ nguồn dữ liệu chuẩn.
- `Nhập liệu`: tạo hồ sơ mới và bổ sung dữ liệu vòng đời theo đúng bảng nghiệp vụ.

Khi thêm màn hình mới, ưu tiên bổ sung metadata vào nhóm phù hợp thay vì thêm nút điều hướng rời rạc. Tên kỹ thuật vẫn dùng tiếng Anh, nhãn hiển thị dùng tiếng Việt UTF-8.
