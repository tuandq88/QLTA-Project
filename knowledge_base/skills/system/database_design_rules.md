# Skill: Database Design Rules

## 1. Mục đích

Hướng dẫn thiết kế schema, migration, seed và test database cho QLTA-Project.

## 2. Quy tắc đặt tên

- Technical object names dùng tiếng Anh: table, column, enum, index, constraint, function, view, trigger.
- Không dùng tiếng Việt có dấu trong object kỹ thuật.
- Code danh mục dùng ASCII/English hoặc tiếng Việt không dấu dạng code ổn định.
- Dữ liệu hiển thị/mô tả nghiệp vụ được dùng tiếng Việt UTF-8.

## 3. Source of Truth

- Database mới dùng `database/schema/unified_postgresql_schema.sql`.
- Database đã tồn tại dùng migration phù hợp với baseline thực tế.
- Không chạy unified schema và migration chain trên cùng database test nếu migration đã được merge.

## 4. Schema Change Checklist

- Có bảng/cột đã tồn tại chưa?
- Có tạo trùng chức năng với module khác không?
- Có cần danh mục trong `dm_categories/dm_category_items` không?
- Có cần data dictionary không?
- Có cần seed reference hoặc seed test không?
- Có cần wrapper test PowerShell không?
- Có cần cập nhật README/rule/skill không?

## 5. Migration Rule

- Migration nên additive và idempotent nếu phù hợp.
- Không drop/rename dữ liệu khi chưa có yêu cầu rõ.
- Không xóa constraint/index để làm test pass.
- Migration đã merge vào unified schema vẫn có thể là active upgrade migration, không xóa tùy tiện.

## 6. Seed/Test Rule

- Seed reference nằm trong `database/seed/*.sql`.
- Seed test-only nằm trong `database/seed/test/`.
- Test phải chứng minh edge case nghiệp vụ, không chỉ kiểm tra insert thành công.
- Test database phải chạy được trên Windows PowerShell và đọc cấu hình PostgreSQL từ `.env.local` hoặc environment variables.

## 7. Statistics Rule

- Không đếm trùng.
- Không group theo `case_id` nếu nghiệp vụ yêu cầu occurrence-level hoặc defendant-level.
- Formula/validation phải truy xuất được nguồn từ skill, data dictionary hoặc tài liệu pháp lý.

## 8. Appellate Court Metadata Rule

- Với án phúc thẩm phải phân biệt:
  - `case_files.court_id`: tòa án đang quản lý/xét xử hồ sơ hiện tại, với án phúc thẩm là tòa phúc thẩm/current court.
  - `case_files.first_instance_court_id`: tòa án đã xét xử sơ thẩm, tức tòa có bản án/quyết định bị kháng cáo/kháng nghị.
- Không dùng một `court_id` để biểu thị đồng thời cả tòa phúc thẩm và tòa sơ thẩm.
- Query group/list án phúc thẩm theo tòa sơ thẩm phải join `courts` qua `case_files.first_instance_court_id`.
- Nếu thiếu `first_instance_court_id`, query phải hiển thị/cảnh báo `MISSING_FIRST_INSTANCE_COURT`; không fallback im lặng thành TAND tỉnh.
- Validation cần kiểm tra:
  - án `PHUC_THAM` phải có `first_instance_court_id` khi dữ liệu đầu vào có thể xác định;
  - `first_instance_court_id` join được `courts`;
  - `first_instance_court_id` phải khác `court_id` khi `court_id` là tòa phúc thẩm/current court cấp tỉnh;

## 9. Appellate Result Metadata Rule

- Kết quả xét xử phúc thẩm từ Excel như `Kết quả XXPT` phải có nơi lưu rõ ràng, tối thiểu `decisions.result_summary/result_code` hoặc bảng appellate result tương ứng.
- Không dùng `resolution_status` chung chung nếu không đủ biểu diễn nghiệp vụ hủy/sửa/giữ nguyên/đình chỉ.
- Chỉ set `case_files.closed_date`, `decisions.decision_date`, `appellate_results.result_date` khi có ngày nguồn hợp lệ như `Ngày BA/QĐ PT` hoặc `Ngày xử`; không tự bịa ngày.
- Nếu có result text nhưng thiếu ngày hợp lệ, phải lưu result text và gắn cảnh báo validation/list như `XXPT_RESULT_WITHOUT_DATE`.
  - nếu có `court_level`, tòa sơ thẩm nên thuộc cấp khu vực/huyện hoặc cấp sơ thẩm tương ứng.

## 9. Skill Follow-up

Nếu schema change tạo ra logic dùng lại được, phải cập nhật hoặc tạo skill cho:

- database;
- backend/API;
- frontend;
- validation;
- seed/test data;
- statistics/list report.
