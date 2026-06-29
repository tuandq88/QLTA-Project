# Lệnh cho Vercel Agent: Thiết kế frontend danh sách hồ sơ án

Bạn là Vercel/Frontend Agent trong repo `QLTA-Project`.

## Objective

Thiết kế và triển khai frontend màn hình **Danh sách hồ sơ án** cho hệ thống quản lý, điều hành TAND hai cấp tỉnh Quảng Ngãi, liên kết với dữ liệu thật từ backend/schema hiện có.

Không tạo landing page. Không dùng mock data nghiệp vụ làm dữ liệu chính.

## Bắt buộc đọc trước

1. `AGENTS.md`
2. `README.md`
3. `docs/AI_AGENT_RULES.md`
4. `agents/UI_UX_DESIGN_AGENT.md`
5. `skills/ui_ux_design_skill_pack.md`
6. `skills/design_taste_frontend_skill.md`
7. `knowledge_base/skills/system/frontend_design_rules.md`
8. `docs/plans/CASE_MANAGEMENT_SCREEN_DESIGN_V1.md`
9. `database/schema/unified_postgresql_schema.sql`
10. `database/schema/DATABASE_TABLES_DATA_DICTIONARY_VI.md`
11. `docs/backend_api_overview.md`
12. `backend/api-samples.http`
13. Skill nghiệp vụ liên quan:
    - `knowledge_base/skills/statistics/skill_first_instance_case_list_by_period.md`
    - `knowledge_base/skills/statistics/skill_appellate_case_list_by_period.md`
    - `knowledge_base/skills/core/skill_trial_level_classification.md`
    - `knowledge_base/skills/core/skill_hearing_members.md`
    - `knowledge_base/skills/core/skill_deadline_engine.md`
    - `knowledge_base/skills/core/skill_validation_rules.md`

## Phạm vi được làm

- Chỉ tạo/sửa frontend.
- Có thể scaffold frontend nếu `frontend/` chưa có app chạy được.
- Ưu tiên React + TypeScript.
- Nếu chọn Next.js/Vercel stack thì dùng App Router, Server Components cho data fetching và Client Components cho filter/table interactivity.
- Nếu chọn Vite React thì giữ cấu trúc đơn giản, dễ bảo trì.
- Có thể dùng Tailwind/shadcn/ui nếu scaffold mới và thật sự cần; không cài lại nếu repo đã có.
- Có thể dùng Lucide React cho icon.

## Không được làm

- Không sửa backend, database, schema, migration, seed hoặc logic thống kê.
- Không tự bịa nghiệp vụ Tòa án, loại án, chỉ tiêu, công thức, biểu mẫu hoặc căn cứ pháp lý.
- Không hard-code dữ liệu nghiệp vụ thật.
- Không tạo tài khoản/login/phân quyền mới.
- Không thêm API trả phí, SaaS bắt buộc hoặc dependency thương mại.
- Không dùng `case_title`, `resolved_date`, `trial_level_code`, `status_code` vì schema hiện không có các tên đó.

## Backend/API hiện có phải dùng

Base local:

```text
http://127.0.0.1:3000
```

Endpoint danh sách:

```text
GET /api/cases/worklist?page=1&pageSize=20&case_type=&case_group=&case_status=&from_date=&to_date=&search=
```

Endpoint chi tiết:

```text
GET /api/cases/{case_id}/overview
```

Danh mục hỗ trợ:

```text
GET /api/courts
GET /api/categories
GET /api/category-items
GET /api/categories/{categoryCode}/items
```

Health:

```text
GET /health
GET /health/db
```

Response chuẩn:

```json
{
  "success": true,
  "data": {},
  "meta": {}
}
```

Nếu backend chưa chạy hoặc API lỗi, UI phải hiển thị `error` state rõ ràng, không thay bằng mock data.

## Mapping dữ liệu bắt buộc

Danh sách hồ sơ phải bám schema:

- Hồ sơ trung tâm: `case_files`.
- Tòa án: `case_files.court_id -> courts.court_name`.
- Tòa án sơ thẩm của án phúc thẩm: `case_files.first_instance_court_id -> courts.court_id`.
- Loại án: `case_files.case_type` hoặc danh mục join tương ứng.
- Cấp xét xử: `case_files.case_group` (`SO_THAM`, `PHUC_THAM`).
- Trạng thái: `case_files.case_status`, `case_files.resolution_status`.
- Ngày thụ lý: ưu tiên `case_occurrences.acceptance_date`, fallback `case_files.acceptance_date`.
- Ngày giải quyết: ưu tiên `case_resolution_events.event_date` với `counted_as_resolved = TRUE`, fallback `case_files.closed_date`.
- Tóm tắt/tên hiển thị: `case_files.summary`; schema hiện chưa có `case_title`.
- Cảnh báo: `deadlines`, `validation_results`, `case_risk_flags` nếu API trả về.

## UI bắt buộc

Tên màn hình hiển thị:

```text
Danh sách hồ sơ án
```

Bố cục:

- Header ngắn, không hero marketing.
- Thanh filter cố định phía trên bảng.
- Bảng dữ liệu là vùng chính.
- Chi tiết hồ sơ mở bằng drawer/sheet hoặc route detail tùy framework.

Cột bảng tối thiểu:

- STT
- Số/mã hồ sơ
- Tóm tắt/tên hiển thị
- Loại án
- Cấp xét xử
- Tòa án
- Ngày thụ lý
- Ngày giải quyết
- Trạng thái
- Cảnh báo
- Thao tác xem chi tiết

Bộ lọc:

- Tìm kiếm
- Tòa án
- Loại án
- Cấp xét xử
- Trạng thái
- Từ ngày/đến ngày thụ lý hoặc kỳ dữ liệu
- Cảnh báo

Trạng thái UI:

- `loading`
- `empty`
- `error`
- `readonly`
- `permission_denied`

## Chi tiết hồ sơ

Khi bấm xem chi tiết, gọi:

```text
GET /api/cases/{case_id}/overview
```

Hiển thị theo nhóm:

- Thông tin chung
- Thông tin thụ lý/vòng đời
- Tòa án và cấp xét xử
- Người tiến hành tố tụng
- Người tham gia tố tụng / đương sự / bị cáo
- Diễn biến xử lý hồ sơ
- Phiên tòa
- Quyết định / kết quả giải quyết
- Kháng cáo / kháng nghị nếu có
- Thời hạn / cảnh báo
- Validation
- AI tham khảo nếu có
- Audit nếu API trả về và có quyền

Trường thiếu dữ liệu hiển thị:

```text
Chưa có dữ liệu
```

AI suggestion chỉ hiển thị tham khảo, không ghi đè dữ liệu chính.

## Thiết kế giao diện

Áp dụng TasteSkill theo wrapper QLTA:

- nghiêm túc, rõ ràng, phù hợp cơ quan nhà nước;
- ưu tiên table/form/detail/report;
- density trung bình-cao;
- motion thấp;
- contrast tốt;
- spacing nhất quán;
- không gradient trang trí, không card rỗng, không placeholder giả;
- không dùng phong cách giải trí.

Nếu dùng shadcn/ui:

- Ưu tiên `Table`, `Button`, `Input`, `Select`, `Badge`, `Sheet`, `Tabs`, `Alert`, `Skeleton`.
- Không lồng card nhiều tầng.
- Không đổi design system ngoài phạm vi màn này.

## Quy tắc chống đếm trùng

- Màn danh sách quản lý có thể hiển thị một dòng theo `case_files.case_id`.
- Nếu API worklist trả occurrence-level, phải hiển thị rõ `occurrence_id` hoặc dấu hiệu lần thụ lý.
- Không tự gom theo `case_id` nếu dữ liệu đang phục vụ báo cáo theo occurrence/event.
- Với án hình sự phúc thẩm nhiều bị cáo, không gán một kết quả chung nếu API trả dữ liệu theo `criminal_appellate_defendant_results`.

## File gợi ý

Nếu frontend chưa có quy ước:

```text
frontend/src/pages/cases/CaseWorklistPage.tsx
frontend/src/components/cases/CaseWorklistTable.tsx
frontend/src/components/cases/CaseWorklistFilters.tsx
frontend/src/components/cases/CaseOverviewPanel.tsx
frontend/src/components/cases/CaseStatusBadge.tsx
frontend/src/components/common/DataState.tsx
frontend/src/api/cases.ts
frontend/src/types/cases.ts
```

Nếu dùng Next.js App Router:

```text
frontend/src/app/cases/page.tsx
frontend/src/app/cases/loading.tsx
frontend/src/app/cases/error.tsx
frontend/src/components/cases/*
frontend/src/lib/api/cases.ts
```

## Validation sau khi làm

Chạy các lệnh phù hợp với frontend đã chọn:

```powershell
npm run typecheck
npm run build
```

Nếu có lint script:

```powershell
npm run lint
```

Không sửa vượt phạm vi để làm build xanh.

## Báo cáo cuối

Báo cáo bằng tiếng Việt:

- Đã dùng framework nào.
- File tạo/sửa.
- Endpoint đã nối.
- Mapping field từ UI sang schema.
- Dependency đã thêm.
- Test/build đã chạy và kết quả.
- Những field/chức năng chưa xác định trong nguồn hiện có.
- URL local để kiểm tra nếu có dev server.
