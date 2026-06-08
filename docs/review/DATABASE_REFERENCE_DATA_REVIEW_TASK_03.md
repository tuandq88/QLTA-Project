# DATABASE REFERENCE DATA REVIEW TASK 03

## Phạm vi

Đã rà soát `README.md`, `AGENTS.md`, rule AI Agent, schema hợp nhất, thư mục diagram, migration, skills và dữ liệu thống kê JSON. Task này chỉ xử lý database: thiết kế danh mục/reference data, migration, seed và test.

## Kết luận

Schema hiện có nhiều cột text/enum-like cần chuẩn hóa để dashboard, KPI, validation và phân công án không phụ thuộc text tự do. Task 03 tạo mô hình danh mục tổng quát gồm `dm_categories`, `dm_category_items`, `dm_table_reference_columns`, sau đó thêm các cột `*_id` nullable vào bảng nghiệp vụ để tham chiếu bằng khóa ngoại.

Không drop cột cũ và không ép NOT NULL trong giai đoạn này. Đây là migration nhiều giai đoạn, an toàn cho database đã có dữ liệu.

## Cột nên giữ PostgreSQL enum

Các cột sau nên giữ enum trong giai đoạn hiện tại vì giá trị ít thay đổi, đã nằm trong schema lõi và đang được index/constraint sử dụng:

- `courts.court_level`
- `users.role_code`
- `case_files.case_type`
- `case_files.case_status`
- `case_assignments.assignment_method`
- `case_assignments.status`
- `assignment_batches.assignment_method`
- `assignment_batches.status`
- `appellate_trackings.appeal_protest_type`
- `appeal_protest_items.item_type`
- `appellate_fault_assessments.fault_classification`
- `validation_results.severity`
- `case_risk_flags.severity`

Vẫn seed các giá trị này vào danh mục để phục vụ UI, báo cáo và mapping, nhưng chưa thay enum bằng FK.

## Cột nên chuyển dần sang danh mục

Ưu tiên cao:

- `case_files.case_group`, `procedure_law`, `current_stage`, `resolution_status`
- `participants.participant_type`
- `documents.document_type`
- `decisions.decision_type`, `result_code`
- `deadlines.deadline_type`, `deadline_status`, `warning_level`
- `validation_results.rule_code`, `validation_status`
- `kpi_metrics.metric_group`
- `statistics_periods.period_type`
- `statistics_snapshots.statistic_form_code`, `aggregation_level`, `case_group`
- `appellate_trackings.tracking_status`, `final_result_code`, `deadline_basis_code`
- `appellate_results.result_code`, `result_scope`
- `appellate_fault_assessments.fault_reason_group`, `responsible_level`
- `case_risk_flags.risk_type`, `status`
- `audit_logs.action`

Ưu tiên trung bình:

- `hearings.hearing_type`, `hearing_status`
- `appeals.appeal_type`, `appellant_type`, `appeal_status`
- `civil_case_details.civil_category`, `dispute_type`, `mediation_result`
- `civil_claims.claim_type`, `claim_status`
- `mediation_sessions.mediation_status`, `result`
- `criminal_case_details.trial_panel_type`
- `defendants.gender`, `criminal_record_status`
- `charges.crime_severity`
- `preventive_measures.measure_type`, `status`
- `sentences.sentence_type`
- `administrative_case_details.lawsuit_type`, `agency_level`
- `challenged_admin_objects.object_type`, `legality_review_result`
- `dialogue_sessions.dialogue_status`, `result`

## Cột nên giữ text tự do

Các cột mô tả, tên người, tên cơ quan, nội dung, căn cứ, ghi chú, tóm tắt, số văn bản và đường dẫn lưu trữ nên giữ text/varchar tự do:

- `summary`, `description`, `note`, `legal_basis`, `suggested_action`
- `full_name`, `organization_name`, `procuracy_name`, `defendant_agency_name`
- `document_number`, `case_number`, `decision_number`, `upper_court_case_number`
- `content_summary`, `result_summary`, `claim_content`, `object_summary`
- `storage_path`, `checksum`, `integrity_hash`

## Bảng danh mục đề xuất

- `dm_categories`: nhóm danh mục, unique `category_code`.
- `dm_category_items`: giá trị danh mục, unique `category_id + item_code`, có `is_active`, `sort_order`, `parent_item_id`, `metadata`.
- `dm_table_reference_columns`: tài liệu hóa mapping từ cột text/enum cũ sang cột `*_id`.

Seed tối thiểu đã tạo cho: loại án, nhóm án, luật tố tụng, giai đoạn/trạng thái hồ sơ, loại người tham gia tố tụng, loại tài liệu, loại quyết định, loại deadline, validation rule/status, nhóm KPI, loại kháng cáo/kháng nghị, kết quả cấp trên, phân loại lỗi, nhóm lý do lỗi, phân công, kỳ thống kê, cấp tổng hợp, hearing, risk và audit.

## Quan hệ khóa 1-n đã chuẩn hóa

Migration 003 thêm FK nullable từ nhiều bảng nghiệp vụ về `dm_category_items(item_id)`, tiêu biểu:

- `case_files.case_group_id`, `procedure_law_id`, `current_stage_id`, `resolution_status_id`
- `participants.participant_type_id`
- `documents.document_type_id`
- `decisions.decision_type_id`, `result_code_id`
- `deadlines.deadline_type_id`, `deadline_status_id`
- `validation_results.rule_id`, `validation_status_id`
- `statistics_periods.period_type_id`
- `statistics_snapshots.statistic_form_id`, `case_group_id`, `aggregation_level_id`
- `kpi_metrics.metric_group_id`
- `appellate_trackings.tracking_status_id`, `final_result_id`
- `appellate_results.result_code_id`
- `appellate_fault_assessments.fault_reason_group_id`
- `case_risk_flags.risk_type_id`
- `audit_logs.action_id`

## Index và constraint

- `dm_categories.category_code` unique.
- `dm_category_items(category_id, item_code)` unique.
- `dm_table_reference_columns(category_id, table_name, source_column_name, reference_column_name)` unique.
- Index cho `is_active`, `sort_order`, `category_id`, `parent_item_id`.
- Index cho từng cột `*_id` được thêm vào bảng nghiệp vụ.

## Rủi ro và phần cần xác nhận

- FK hiện chỉ bảo đảm giá trị tồn tại trong `dm_category_items`, chưa ép item thuộc đúng category cho từng cột. Cần trigger/check nâng cao ở task sau nếu muốn siết chặt ở DB.
- Seed `fault_reason_group`, `appellate_result`, `deadline_type`, `validation_rule` đang ở mức tối thiểu, cần đối chiếu tiếp PDF/JSON trước khi dùng làm chuẩn nghiệp vụ chính thức.
- Nếu dữ liệu thật đã có text khác seed, cần bước backfill có mapping và báo cáo giá trị chưa map được.
- Nếu backend ghi cả text cũ và `*_id`, cần rule đồng bộ để tránh lệch giữa hai cột.

## Bước tiếp theo trước khi viết backend

1. Chạy migration 003 và seed 003 trên database staging.
2. Xuất distinct value của các cột text cũ để lập bảng mapping backfill.
3. Bổ sung seed từ `knowledge_base/data/statistics/*/data_dictionary.json` và validation JSON sau khi rà soát.
4. Tạo script backfill `*_id` từ cột text/enum cũ.
5. Chỉ sau khi backfill sạch mới thiết kế API dùng `*_id` làm nguồn chính.
