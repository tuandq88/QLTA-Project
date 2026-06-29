# Skill: Backend/API Design Rules

## 1. Mục đích

Hướng dẫn thiết kế backend/API dựa trên schema đã chuẩn hóa của QLTA-Project. Skill này dùng khi tạo entity, DTO, service, repository, API route hoặc API report/statistics.

## 2. Nguyên tắc đặt tên

- Entity, DTO, service, repository, route và biến kỹ thuật dùng tiếng Anh.
- API route dùng tiếng Anh, ví dụ `/api/criminal-appellate-defendant-results`.
- Response có thể chứa label tiếng Việt UTF-8 cho UI.
- Không tự tạo field trái với `database/schema/unified_postgresql_schema.sql`.

## 3. Quy tắc bám schema

- Đọc `database/schema/unified_postgresql_schema.sql` và `database/schema/DATABASE_TABLES_DATA_DICTIONARY_VI.md` trước khi thiết kế API.
- Khi bảng có danh mục, API nên trả đủ `id`, `code`, `name`.
- Không dùng text tự do nếu schema đã có code/danh mục.
- Không đổi ý nghĩa bảng/cột để tiện API.

## 4. Quy tắc list/statistics API

- API list thống kê phải hỗ trợ `from_date`, `to_date`, `as_of_date` khi nghiệp vụ cần.
- Với báo cáo theo khoảng ngày, áp dụng `knowledge_base/skills/statistics/skill_case_period_reporting.md`: hai biên đều bao gồm và trạng thái phải được xác định tại `to_date`, không theo `case_status` hiện tại.
- Hồ sơ có ngày giải quyết sau `to_date` không được tính đã giải quyết; API danh sách tồn phải trả `report_resolution_status = null` và ghi chú sau kỳ riêng.
- Không group sai theo `case_id` nếu skill yêu cầu occurrence-level hoặc defendant-level.
- Với hình sự sơ thẩm trả hồ sơ VKS, dùng occurrence/event theo skill `skill_criminal_first_instance_return_to_procuracy_list.md`.
- Với hình sự phúc thẩm, kết quả phải theo `defendant_id` theo skill `skill_criminal_appellate_defendant_result_rules.md`.

## 5. Quy tắc ghi dữ liệu

- Ghi dữ liệu chính phải qua transaction, permission và audit nếu là hành động nghiệp vụ quan trọng.
- AI chỉ ghi đề xuất/cảnh báo/validation, không tự ghi đè dữ liệu chính.
- API update phải kiểm tra optimistic/validation nếu workflow có lịch sử hoặc final result.

## 6. Output tối thiểu khi thiết kế API

- Route.
- Request DTO.
- Response DTO.
- Bảng/cột nguồn.
- Validation.
- Permission.
- Audit requirement.
- Test case.
