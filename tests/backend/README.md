# Backend smoke tests

Các script trong thư mục này kiểm thử API backend đang chạy local, không thay đổi schema và không dùng dữ liệu cá nhân thật.

## Local case flow

Điều kiện:

- Backend đang chạy tại `http://127.0.0.1:3000`.
- `.env.local` trỏ tới database đã chạy `database/schema/unified_postgresql_schema.sql`.
- `AUTH_REQUIRED=false` cho giai đoạn local hiện tại.

Chạy:

```powershell
.\tests\backend\run_local_case_flow_smoke.ps1
```

Script sẽ:

- kiểm tra `/health/db`;
- xác nhận `/auth/me` trả `local_no_auth`;
- lấy một Tòa án từ `/api/courts`;
- tạo hồ sơ local mẫu trong `/api/cases`;
- tạo occurrence, participant, hearing và validation result;
- đọc lại dữ liệu liên quan;
- kiểm tra audit log của thao tác tạo hồ sơ.
