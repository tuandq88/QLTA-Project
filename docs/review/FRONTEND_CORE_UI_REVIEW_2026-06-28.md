# Báo cáo tinh gọn giao diện nghiệp vụ

Ngày thực hiện: 28/06/2026

## Phạm vi

- Dashboard điều hành.
- Danh sách và chi tiết hồ sơ.
- Form tiếp nhận hồ sơ.
- Form bổ sung vòng đời hồ sơ.
- Thanh điều hướng và responsive toàn ứng dụng.

## Nội dung đã thực hiện

- Loại bỏ khỏi giao diện các endpoint, tên bảng, source chip, ghi chú backend, placeholder tên cột và mục mô tả chức năng chưa có.
- Giữ nguyên cấu trúc dữ liệu, API contract và logic nghiệp vụ hiện có.
- Đổi các nhãn kỹ thuật còn lộ ra thành nhãn nghiệp vụ tiếng Việt.
- Không hiển thị hậu tố nguồn seed trong tên Tòa án, không thay đổi dữ liệu gốc.
- Thu gọn thanh điều hướng, bảo đảm các nhóm chức năng rõ ràng và không chồng lấn.
- Cô lập cuộn ngang trong bảng dữ liệu; trang không cuộn ngang ở desktop, tablet và mobile.
- Giữ các trạng thái loading, empty, error, readonly và permission denied.

## Kiểm tra

- `npm run build`: đạt.
- TypeScript và Vite production build: đạt.
- Playwright tại 1440x900, 1200x800 và 390x844: không có overflow ngang toàn trang sau khi sửa.
- Console trình duyệt: không có lỗi.
- `git diff --check`: không phát hiện lỗi whitespace trong phần thay đổi.

## Trạng thái dữ liệu và schema

- Không thay đổi schema, migration, seed, backend hoặc dữ liệu nguồn.
- Không thay đổi đơn vị đếm hay công thức dashboard.
- Không tạo thêm chỉ tiêu hoặc quy tắc nghiệp vụ.
