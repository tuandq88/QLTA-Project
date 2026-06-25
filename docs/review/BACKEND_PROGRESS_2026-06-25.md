# Báo cáo tiến độ backend ngày 25/06/2026

## Phạm vi đã hoàn thành

- Bổ sung API danh sách hồ sơ cho màn hình quản lý: `GET /api/cases/worklist`.
- Bổ sung API tổng hợp chi tiết hồ sơ: `GET /api/cases/:id/overview`.
- Cập nhật request mẫu trong `backend/api-samples.http`.
- Cập nhật Postman collection local tại `postman/collections/qlta_backend_local_collection.json`.
- Mở rộng smoke test backend local trong `tests/backend/run_local_case_flow_smoke.ps1`.
- Cập nhật tài liệu backend và tổng quan API.

## API đã có thể kiểm thử local

- `GET /api/cases/worklist`: lọc hồ sơ theo Tòa án, loại án, cấp xét xử, trạng thái, giai đoạn, khoảng ngày thụ lý và từ khóa.
- `GET /api/cases/:id/overview`: đọc một lần hồ sơ, occurrence, sự kiện giải quyết, người tham gia, phiên tòa, thành phần phiên tòa, validation và audit liên quan.

## Kiểm thử đã chạy

```powershell
.\tests\backend\run_local_case_flow_smoke.ps1
cd backend
npm audit
npm test
npm run build
```

Kết quả tại thời điểm cập nhật: tất cả đều pass, `npm audit` báo `0 vulnerabilities`.

## Ghi chú nghiệp vụ

- Các API mới chỉ đọc hoặc tổng hợp dữ liệu từ bảng hiện có, không tạo công thức thống kê mới.
- Worklist chỉ đếm số bản ghi liên quan theo bảng nguồn, không thay thế Formula Catalog hoặc dashboard thống kê.
- Giai đoạn hiện tại vẫn dùng `AUTH_REQUIRED=false`, chưa yêu cầu đăng nhập/phân quyền.

## Bước tiếp theo đề xuất

- Tạo frontend màn hình danh sách hồ sơ sử dụng `GET /api/cases/worklist`.
- Tạo frontend màn hình chi tiết hồ sơ sử dụng `GET /api/cases/:id/overview`.
