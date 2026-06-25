# Backend QLTA

Backend nền tảng cho hệ thống quản lý, điều hành TAND hai cấp tỉnh Quảng Ngãi.

## Stack

- Node.js + TypeScript.
- Fastify cho HTTP API.
- PostgreSQL qua `pg`, dùng schema hiện có trong `database/schema/unified_postgresql_schema.sql`.
- Zod cho validation DTO.
- JWT nội bộ cho guard xác thực.

Lý do chọn Fastify thay vì NestJS ở giai đoạn này: repo chưa có backend framework, Fastify nhẹ, miễn phí, ít scaffold, dễ chạy local và vẫn đủ plugin để mở rộng sau này.

## Cấu hình

Tạo biến môi trường theo `backend/.env.example`. Backend đọc `DATABASE_URL` hoặc nhóm biến `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`.

Không commit `.env.local` hoặc secret.

```powershell
cd backend
npm install
npm run dev
```

Ở giai đoạn hiện tại, `AUTH_REQUIRED=false` là mặc định để chạy nội bộ/local chưa cần đăng nhập và phân quyền. Khi tắt auth, mutation vẫn ghi `audit_logs` nhưng `actor_id` để `NULL`, tránh tạo tài khoản giả hoặc hard-code tài khoản.

## Endpoint chính

- `GET /health`
- `GET /health/db`
- `POST /auth/login`
- `POST /auth/logout`
- `GET /auth/me`
- `GET|POST /api/users`
- `GET|PATCH|DELETE /api/users/:id` (`DELETE` chỉ khóa `is_active=false`)
- `GET /api/courts`
- `GET /api/categories`
- `GET /api/category-items`
- `GET /api/categories/:categoryCode/items`
- `GET|POST|PATCH /api/cases`
- `GET|POST|PATCH /api/case-occurrences`
- `GET|POST|PATCH /api/case-resolution-events`
- `GET|POST|PATCH /api/participants`
- `GET|POST|PATCH /api/hearings`
- `GET|POST|PATCH /api/hearing-members`
- `GET /api/statistics/snapshots`
- `GET /api/statistics/kpi-values`
- `GET|POST|PATCH /api/validation-results`
- `GET /api/audit-logs`

File request mẫu:

- `backend/api-samples.http`
- `postman/collections/qlta_backend_local_collection.json`

Smoke test API local:

```powershell
.\tests\backend\run_local_case_flow_smoke.ps1
```

## Response chuẩn

```json
{
  "success": true,
  "data": {},
  "meta": {}
}
```

```json
{
  "success": false,
  "error": {
    "code": "STRING_CODE",
    "message": "Thong bao tieng Viet",
    "details": {}
  }
}
```

## Ghi chú nghiệp vụ

- API thống kê chỉ đọc từ `statistics_snapshots` và `kpi_values`; không tự tạo công thức mới.
- Mutation dùng allow-list cột theo schema, validation Zod, permission check và ghi `audit_logs`.
- AI chỉ nên ghi cảnh báo/gợi ý/validation qua `validation_results` hoặc bảng AI/risk về sau; không tự ghi đè dữ liệu chính.
- `POST /auth/login` không hard-code tài khoản. Schema hiện tại chưa có cột `password_hash`; endpoint sẽ trả lỗi cấu hình cho tới khi schema auth được bổ sung an toàn.
