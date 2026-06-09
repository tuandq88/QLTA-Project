# STATISTICAL REFERENCE DATA DESIGN TASK

## Phạm vi

Task database-only cho vai trò Database Architect Agent. Không viết backend/frontend, không sửa skill nghiệp vụ, không drop cột cũ và không tự tạo danh mục pháp lý chi tiết khi chưa có nguồn chuẩn trong repo.

Nguồn đã đọc: `README.md`, `AGENTS.md`, rule tổng AI Agent, `database/schema/unified_postgresql_schema.sql`, `database/schema/core_database_schema.sql`, migration/diagram hiện có và các file thống kê JSON trong `knowledge_base/data/statistics/`.

## Vấn đề hiện tại

Schema hiện có nhiều cột lưu text/code tự do hoặc enum-like nhưng lại là dữ liệu thống kê: loại người tham gia tố tụng, loại tài liệu, kết quả xét xử, tội danh, điều luật, đặc điểm bị cáo, quan hệ pháp luật, kết quả cấp trên, chỉ tiêu KPI và chỉ mục biểu mẫu. Nếu dashboard/KPI tính trực tiếp từ các cột này thì dễ phát sinh nhập sai chính tả, nhập nhiều biến thể, đếm trùng và khó đối chiếu biểu mẫu.

## Phân loại trường rà soát

| Trường | Phân loại | Hướng xử lý |
| --- | --- | --- |
| `case_files.case_type`, `case_group`, `procedure_law`, `current_stage`, `case_status` | A | Dùng danh mục; giữ enum/text cũ trong giai đoạn backfill. |
| `participants.participant_type` | A | Danh mục người tham gia tố tụng. |
| `documents.document_type` | A | Danh mục loại tài liệu. |
| `hearings.hearing_type`, `hearing_status` | A | Danh mục phiên/lịch. |
| `decisions.decision_type`, `result_code` | A | Danh mục loại quyết định và kết quả xét xử. |
| `case_assignments.assignment_role` | A | Danh mục vai trò phân công. |
| `deadlines.deadline_type`, `warning_level` | A | Danh mục thời hạn/cảnh báo. |
| `validation_results.rule_code`, `severity` | A/E | Rule/severity chuẩn hóa; kết quả validation là lịch sử. |
| `charges.crime_name`, `penal_code_article`, `clause_point`, `crime_severity` | A | Tạo `dm_crimes`, `dm_penal_code_articles`; giữ text snapshot. |
| `defendants.is_minor`, `is_detained` | C | Boolean thống kê; đồng thời map sang feature để báo cáo. |
| `defendants.criminal_record_status` | A/C | Radio/dropdown hoặc feature tùy biểu mẫu. |
| `defendant_features` cần nhiều giá trị | B | `defendant_statistical_features`. |
| `civil_case_details.dispute_type`, `civil_category` | A/B | `dm_legal_relationships` và bảng n-n. |
| `administrative_case_details.lawsuit_type`, `challenged_admin_objects.object_type` | A | Danh mục hành chính, cần bổ sung chi tiết sau rà soát nguồn. |
| `appellate_trackings.appeal_protest_type`, `final_result_code`, `fault_classification` | A | Danh mục chuyên biệt cấp trên. |
| `appellate_fault_assessments.fault_reason_group` | A | `dm_fault_reason_groups`. |
| `statistics_snapshots.statistic_form_code`, `metric_code` | E | Snapshot lịch sử, thêm FK metric/form item để truy xuất nguồn. |
| `kpi_metrics.metric_code` | A | `dm_statistical_metrics` là catalog chuẩn. |
| Các cột `summary`, `note`, `description`, số văn bản, tên người/cơ quan | D | Giữ text tự do. |

## Mô hình danh mục đề xuất

Migration 004 bổ sung hai lớp:

- Lớp tổng quát: `statistical_categories`, `statistical_indicators`, `statistical_indicator_options`, `statistical_indicator_applicability`, `entity_statistical_attributes`.
- Lớp chuyên biệt: `dm_penal_code_articles`, `dm_crimes`, `dm_defendant_statistical_features`, `dm_legal_relationships`, `dm_trial_result_types`, `dm_appellate_result_codes`, `dm_fault_classifications`, `dm_fault_reason_groups`, `dm_appeal_protest_types`, `dm_statistical_forms`, `dm_statistical_form_items`, `dm_statistical_metrics`.

Mô hình tổng quát phù hợp cho checkbox/radio/dropdown phát sinh theo biểu mẫu. Bảng chuyên biệt phù hợp với danh mục có ý nghĩa nghiệp vụ mạnh, cần FK rõ ràng, index riêng và truy vấn KPI thường xuyên.

## Quan hệ 1-n và n-n

- `statistical_categories` 1-n `statistical_indicators`.
- `statistical_indicators` 1-n `statistical_indicator_options`.
- `case_files` 1-n `entity_statistical_attributes`.
- `dm_penal_code_articles` 1-n `dm_crimes`; `charges` n-1 `dm_crimes`.
- `defendants` n-n `dm_defendant_statistical_features` qua `defendant_statistical_features`.
- `case_files` n-n `dm_legal_relationships` qua `case_legal_relationships`.
- `dm_trial_result_types` 1-n `decisions`.
- `dm_appellate_result_codes` 1-n `appellate_trackings`.
- `dm_fault_reason_groups` 1-n `appellate_fault_assessments`.
- `dm_statistical_forms` 1-n `dm_statistical_form_items`; `dm_statistical_metrics` 1-n snapshot/KPI.

## Mapping UI

File `tests/database/statistical_input_ui_mapping_checklist.md` liệt kê mapping UI. Quy tắc chính:

- Dropdown/radio ghi một khóa FK.
- Checkbox/multi-select ghi nhiều dòng liên kết.
- Không nối chuỗi nhiều giá trị vào text.
- Cột legacy chỉ phục vụ backfill hoặc snapshot, không dùng làm nguồn tính thống kê lâu dài.

## Migration plan an toàn

1. Tạo bảng danh mục và bảng liên kết mới bằng `CREATE TABLE IF NOT EXISTS`.
2. Thêm cột `*_id` nullable bằng `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`.
3. Tạo FK/index nhưng không ép `NOT NULL`.
4. Seed danh mục tối thiểu từ rule hiện có.
5. Backfill sau bằng mapping distinct value từ dữ liệu thật.
6. Sau khi backfill sạch mới chuyển backend/UI sang ghi FK là nguồn chính.
7. Chỉ cân nhắc deprecate cột text cũ trong migration sau; không drop trong task này.

## Ngăn trùng dữ liệu

- Unique code trên từng bảng danh mục: `feature_code`, `crime_code`, `relationship_code`, `result_code`, `metric_code`.
- Unique quan hệ n-n: `(defendant_id, feature_id)`, `(case_id, legal_relationship_id)`, `(decision_id, statistical_indicator_id, option_id)`.
- Partial unique: chỉ một `case_legal_relationships.is_primary = true` cho mỗi hồ sơ.
- Trigger `enforce_defendant_statistical_option_group` chặn radio group chọn nhiều giá trị khi `allow_multiple = false`.
- FK chặn nghiệp vụ tham chiếu option/catalog không tồn tại.

## Hỗ trợ dashboard/KPI

Các KPI bắt buộc trong rule tổng được seed vào `dm_statistical_metrics`, gồm thụ lý, giải quyết, tồn, quá hạn, tỷ lệ y án/sửa/hủy, tỷ lệ hủy/sửa khách quan/chủ quan, hòa giải/đối thoại và tuân thủ phân công ngẫu nhiên. `statistics_snapshots.metric_id` và `form_item_id` giúp snapshot truy xuất được catalog thay vì chỉ dựa vào text `metric_code`.

## Phần cần human/legal review

- Danh mục tội danh và điều luật đầy đủ theo Bộ luật Hình sự.
- Cây quan hệ pháp luật/tranh chấp chi tiết cho dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động.
- Đối tượng khởi kiện và loại quyết định/hành vi hành chính bị kiện.
- Mã biểu mẫu, chỉ tiêu biểu mẫu và công thức chính thức theo `Documents/huong_dan_bm.pdf` và JSON thống kê.
- Phân loại lỗi khách quan/chủ quan theo hồ sơ cụ thể; hệ thống không tự kết luận lỗi chủ quan.

## Rủi ro nếu không chuẩn hóa

- Dashboard/KPI sai do nhập khác chính tả hoặc khác mã.
- Đếm trùng bị cáo/đặc điểm/quan hệ pháp luật.
- Không truy xuất được nguồn chỉ tiêu khi lãnh đạo yêu cầu giải trình.
- AI khó xuất báo cáo chính xác vì phải suy luận từ text tự do.

## Rủi ro nếu chuẩn hóa quá mức

- Database quá nhiều bảng nhỏ, khó bảo trì.
- Backend/UI phải xử lý quá nhiều catalog khi chưa có dữ liệu nguồn.
- Seed danh mục chưa được duyệt có thể bị hiểu nhầm là căn cứ chính thức.
- Backfill phức tạp nếu ép FK/NOT NULL quá sớm.

## Bước tiếp theo trước khi viết backend

1. Chạy migration/seed 004 trên database staging.
2. Xuất distinct value từ các cột legacy để lập bảng mapping backfill.
3. Rà soát PDF/JSON để seed chính thức cho tội danh, quan hệ pháp luật và biểu mẫu.
4. Viết script backfill `*_id` từ text/code cũ.
5. Chạy test SQL trong `tests/database/`.
6. Cập nhật API/UI sau khi dữ liệu catalog đã được xác nhận.
