# Kết quả triển khai giao diện workbook thống kê ngày 29/06/2026

## Phạm vi

- Render 24 workbook trong `bieu_mau/`, mỗi workbook là một trang thống kê.
- Giữ cấu trúc sheet nguồn: merge, kích thước hàng/cột, font, màu nền, căn lề, xoay chữ và đường viền.
- Kết nối 12 mẫu sơ thẩm/phúc thẩm 1A-6B với API báo cáo hiện có.
- Giữ 12 mẫu giám đốc thẩm/tái thẩm ở chế độ khung chỉ đọc vì chưa có mapping nguồn/công thức được duyệt.

## File chính

- `tools/generate_statistics_workbooks.py`: sinh metadata từ workbook, không sửa nguồn.
- `frontend/src/data/statistics-workbooks.json`: metadata của 24 workbook.
- `frontend/src/pages/statistics/StatisticsWorkbookPage.tsx`: trang danh mục, bộ lọc kỳ/đơn vị, trạng thái và xuất Excel.
- `frontend/src/components/statistics/WorkbookGrid.tsx`: renderer workbook dùng chung.
- `frontend/src/api/statistics.ts`, `frontend/src/types/statistics.ts`: contract frontend với API thống kê.

## An toàn dữ liệu

- Không sửa hoặc xóa file trong `bieu_mau/`.
- Số liệu mẫu trong vùng dữ liệu không được đưa vào giao diện như dữ liệu chính.
- Ô thiếu nguồn giữ trống, không tự điền `0`.
- AI/UI không ghi đè dữ liệu hồ sơ; trang thống kê chỉ đọc.

## Validation đã chạy

```powershell
cd frontend
npm run typecheck
npm run build
```

Kết quả: pass. Playwright xác nhận trang tải, chuyển được giữa mẫu có API và mẫu chưa mapping, không có lỗi console. Đã kiểm tra trực quan mẫu Hình sự sơ thẩm 94 cột và Hình sự giám đốc thẩm.

## Trạng thái

- [x] 24 workbook có trang tương ứng.
- [x] 12 mẫu 1A-6B nhận số liệu API và hỗ trợ xuất Excel.
- [x] Có loading, empty, error và readonly.
- [x] Có chú thích source/formula/unmapped và không đếm thiếu nguồn thành 0.
- [ ] Mapping nghiệp vụ cho giám đốc thẩm/tái thẩm cần task backend/database riêng có căn cứ tài liệu nguồn.
