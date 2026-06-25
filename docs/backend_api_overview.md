# Tổng quan Backend/API

## Mục tiêu

Backend hiện thực lớp API nền cho các bảng đã có trong `database/schema/unified_postgresql_schema.sql`, không thay đổi schema, seed hoặc công thức thống kê.

## Module đã scaffold

| Module | Route | Ghi chú |
|---|---|---|
| Health | `/health`, `/health/db` | Kiểm tra server và PostgreSQL. |
| Auth | `/auth/login`, `/auth/logout`, `/auth/me` | JWT nội bộ; không hard-code tài khoản. |
| Users | `/api/users` | CRUD an toàn, không trả password/hash. `DELETE` chỉ khóa tài khoản. |
| Courts | `/api/courts` | Danh mục Tòa án chỉ đọc. |
| Categories | `/api/categories`, `/api/category-items` | Danh mục dùng chung chỉ đọc. |
| Cases | `/api/cases` | Quản lý `case_files` theo schema hiện có. |
| Case occurrences | `/api/case-occurrences`, `/api/case-resolution-events` | Theo dõi vòng đời thụ lý/giải quyết, chống gộp sai occurrence. |
| Participants | `/api/participants` | Người tham gia tố tụng theo schema. |
| Hearings | `/api/hearings`, `/api/hearing-members` | Phiên tòa và thành phần phiên tòa, dùng role code chuẩn. |
| Statistics readonly | `/api/statistics/snapshots`, `/api/statistics/kpi-values` | Chỉ đọc snapshot/KPI đã tính, có trace nguồn dữ liệu. |
| Validation results | `/api/validation-results` | Ghi/đọc cảnh báo, validation, gợi ý kiểm tra. |
| Audit logs | `/api/audit-logs` | Chỉ đọc theo quyền lãnh đạo/admin khi bật auth. |

## Chế độ local hiện tại

Giai đoạn này chưa dùng đăng nhập/phân quyền. Backend mặc định `AUTH_REQUIRED=false` để kiểm thử API nội bộ/local.

- Mutation không yêu cầu Bearer token.
- Audit vẫn ghi `audit_logs`, nhưng `actor_id = NULL`.
- Không tạo tài khoản giả và không hard-code tài khoản.
- Khi cần bật phân quyền, đặt `AUTH_REQUIRED=true` và bổ sung schema password hash/workflow tài khoản.

## Permission mặc định khi bật auth

- Mutation: `admin`, `chief_judge`, `deputy_chief_judge`.
- Audit log: `admin`, `chief_judge`, `deputy_chief_judge`.
- Danh mục và thống kê readonly: đọc không yêu cầu guard ở scaffold ban đầu để dễ kiểm thử local; khi tích hợp UI nên bật guard theo yêu cầu triển khai nội bộ.

## Validation và audit

- DTO dùng Zod.
- Repository chỉ ghi các cột nằm trong allow-list theo schema.
- Mutation ghi `audit_logs` cùng transaction.
- Không xóa vật lý `users`; thao tác khóa tài khoản cập nhật `is_active=false`.

## Request mẫu

- `backend/api-samples.http`
- `postman/collections/qlta_backend_local_collection.json`

## Smoke test

Script `tests/backend/run_local_case_flow_smoke.ps1` kiểm thử flow nền: health DB, local-no-auth, tạo hồ sơ, occurrence, participant, hearing, validation result và kiểm tra audit log.

## Rủi ro cần kiểm tra

- Schema `users` chưa có cột password hash nên login chưa thể xác thực mật khẩu thật.
- Cần chốt chính sách RBAC chi tiết theo vai trò nghiệp vụ trước khi dùng production.
- Các API quản lý hồ sơ mới là CRUD an toàn theo schema, chưa chứa workflow duyệt/chốt nghiệp vụ chuyên sâu.
- API thống kê không tính mới công thức; cần module riêng đọc Formula Catalog khi triển khai dashboard.
