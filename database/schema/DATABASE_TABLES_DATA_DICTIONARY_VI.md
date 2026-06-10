# Từ điển bảng dữ liệu database QLTA

Ngày cập nhật: 09/06/2026

Tài liệu này mô tả công dụng các bảng trong `database/schema/unified_postgresql_schema.sql` và các cột liên kết quan trọng. Đây là tài liệu kỹ thuật, không tự tạo thêm dữ liệu nghiệp vụ, chỉ mô tả cấu trúc hiện có.

## 1. Master Data

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `courts` | Danh sách Tòa án/đơn vị trong hệ thống. | `court_id` | `parent_court_id -> courts.court_id`, `court_level_id -> dm_category_items.item_id` |
| `court_staff` | Danh sách cán bộ xét xử/thư ký trích từ Excel hoặc danh mục đơn vị, dùng cho thành phần phiên tòa khi chưa có tài khoản `users`. | `staff_id` | `court_id -> courts.court_id` |
| `users` | Người dùng hệ thống: lãnh đạo, thẩm phán, thư ký, admin, viewer. | `user_id` | `court_id -> courts.court_id`, `role_id -> dm_category_items.item_id` |
| `judge_profiles` | Hồ sơ nghiệp vụ phục vụ phân công án của thẩm phán. | `judge_profile_id` | `user_id -> users.user_id` |
| `dm_categories` | Nhóm danh mục dùng chung. | `category_id` | Không có FK bắt buộc ra bảng khác |
| `dm_category_items` | Giá trị chi tiết trong từng nhóm danh mục. | `item_id` | `category_id -> dm_categories.category_id`, `parent_item_id -> dm_category_items.item_id` |
| `dm_table_reference_columns` | Mapping cột text/enum cũ sang cột danh mục UUID. | `binding_id` | `category_id -> dm_categories.category_id` |

## 2. Case Core

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `case_files` | Hồ sơ vụ án/vụ việc trung tâm. `case_group/case_group_id` dùng cho cấp xét xử `SO_THAM`/`PHUC_THAM`; không dùng `case_type`, `procedure_law` hoặc `current_stage` để chứa cấp xét xử. | `case_id` | `court_id -> courts.court_id`, `created_by/updated_by -> users.user_id`, các cột danh mục `case_type_id`, `case_status_id`, `case_group_id`, `procedure_law_id`, `current_stage_id`, `resolution_status_id` |
| `participants` | Cá nhân/tổ chức tham gia tố tụng. | `participant_id` | `case_id -> case_files.case_id`, `participant_type_id -> dm_category_items.item_id` |
| `documents` | Tài liệu, văn bản, chứng cứ trong hồ sơ. | `document_id` | `case_id -> case_files.case_id`, `uploaded_by -> users.user_id`, `document_type_id -> dm_category_items.item_id` |
| `case_events` | Dòng sự kiện vòng đời hồ sơ. | `event_id` | `case_id -> case_files.case_id`, `performed_by -> users.user_id`, `source_document_id -> documents.document_id` |
| `case_assignments` | Phân công người xử lý hồ sơ. | `assignment_id` | `case_id -> case_files.case_id`, `user_id -> users.user_id`, `assigned_by -> users.user_id` |
| `hearings` | Phiên tòa/phiên họp. | `hearing_id` | `case_id -> case_files.case_id` |
| `case_hearing_members` | Thành phần xét xử/thư ký của hồ sơ từ Excel: `PRESIDING_JUDGE`, `PANEL_JUDGE`, `HEARING_CLERK`. | `case_hearing_member_id` | `case_id -> case_files.case_id`, `staff_id -> court_staff.staff_id`, `role_id -> dm_category_items.item_id` |
| `decisions` | Bản án/quyết định của Tòa án. | `decision_id` | `case_id -> case_files.case_id`, `document_id -> documents.document_id`, `trial_result_type_id -> dm_trial_result_types.trial_result_type_id` |
| `appeals` | Thông tin kháng cáo ở lớp core cũ. | `appeal_id` | `case_id -> case_files.case_id`, `appellate_case_id -> case_files.case_id` |
| `deadlines` | Thời hạn xử lý, cảnh báo sắp hết hạn/quá hạn. | `deadline_id` | `case_id -> case_files.case_id`, các cột danh mục `deadline_type_id`, `deadline_status_id`, `warning_level_id` |
| `validation_results` | Kết quả kiểm tra dữ liệu/rule. | `validation_id` | `case_id -> case_files.case_id`, `rule_id/severity_id/validation_status_id -> dm_category_items.item_id` |
| `audit_logs` | Nhật ký thao tác dữ liệu. | `audit_id` | `actor_id -> users.user_id`, `action_id -> dm_category_items.item_id` |

## 3. Module dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `civil_case_details` | Thông tin chi tiết nhóm án dân sự và các nhóm tương tự. | `civil_detail_id` | `case_id -> case_files.case_id`, các cột danh mục `civil_category_id`, `dispute_type_id`, `mediation_result_id` |
| `civil_claims` | Yêu cầu/đòi hỏi trong vụ án dân sự. | `claim_id` | `civil_detail_id -> civil_case_details.civil_detail_id` |
| `mediation_sessions` | Phiên hòa giải. | `mediation_id` | `civil_detail_id -> civil_case_details.civil_detail_id` |

## 4. Module hình sự

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `criminal_case_details` | Thông tin chi tiết vụ án hình sự. | `criminal_detail_id` | `case_id -> case_files.case_id` |
| `defendants` | Bị cáo trong vụ án hình sự. | `defendant_id` | `criminal_detail_id -> criminal_case_details.criminal_detail_id`, `gender_id`, `criminal_record_status_id -> dm_category_items.item_id` |
| `charges` | Tội danh/truy tố/gắn điều luật. | `charge_id` | `defendant_id -> defendants.defendant_id`, `crime_id -> dm_crimes.crime_id`, `article_id -> dm_penal_code_articles.article_id`, `crime_severity_id -> dm_category_items.item_id` |
| `preventive_measures` | Biện pháp ngăn chặn. | `measure_id` | `defendant_id -> defendants.defendant_id` |
| `sentences` | Hình phạt/trách nhiệm dân sự trong án hình sự. | `sentence_id` | `defendant_id -> defendants.defendant_id` |
| `victims` | Bị hại/tổ chức bị thiệt hại. | `victim_id` | `criminal_detail_id -> criminal_case_details.criminal_detail_id` |
| `investigation_returns` | Trả hồ sơ điều tra bổ sung. | `return_id` | `criminal_detail_id -> criminal_case_details.criminal_detail_id` |

## 5. Module hành chính

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `administrative_case_details` | Thông tin chi tiết vụ án hành chính. | `admin_detail_id` | `case_id -> case_files.case_id` |
| `challenged_admin_objects` | Quyết định/hành vi hành chính bị kiện. | `object_id` | `admin_detail_id -> administrative_case_details.admin_detail_id` |
| `dialogue_sessions` | Phiên đối thoại trong vụ án hành chính. | `dialogue_id` | `admin_detail_id -> administrative_case_details.admin_detail_id` |
| `admin_enforcement_tracking` | Theo dõi thi hành quyết định hành chính. | `enforcement_id` | `admin_detail_id -> administrative_case_details.admin_detail_id`, `decision_id -> decisions.decision_id` |

## 6. Phân công án ngẫu nhiên

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `assignment_batches` | Một đợt/chạy phân công án. | `assignment_batch_id` | `court_id -> courts.court_id`, `created_by/approved_by -> users.user_id` |
| `assignment_batch_cases` | Danh sách hồ sơ tham gia một đợt phân công. | `assignment_batch_case_id` | `assignment_batch_id -> assignment_batches.assignment_batch_id`, `case_id -> case_files.case_id`, `assigned_judge_id -> users.user_id` |
| `assignment_batch_judges` | Danh sách thẩm phán tham gia bốc/phân công. | `assignment_batch_judge_id` | `assignment_batch_id -> assignment_batches.assignment_batch_id`, `judge_id -> users.user_id` |
| `judge_status_periods` | Khoảng thời gian thẩm phán nghỉ, biệt phái, không tham gia phân công. | `status_period_id` | `judge_id -> users.user_id` |
| `judge_workload_snapshots` | Snapshot tải việc của thẩm phán tại thời điểm phân công. | `snapshot_id` | `judge_id -> users.user_id` |
| `judge_case_conflicts` | Xung đột/lý do loại trừ thẩm phán khỏi hồ sơ. | `conflict_id` | `case_id -> case_files.case_id`, `judge_id -> users.user_id` |
| `judge_replacement_history` | Lịch sử thay thế thẩm phán được phân công. | `replacement_id` | `assignment_id -> case_assignments.assignment_id`, `old_judge_id/new_judge_id/replaced_by -> users.user_id` |
| `assignment_audit_logs` | Nhật ký thuật toán/luồng phân công. | `assignment_audit_id` | `assignment_batch_id -> assignment_batches.assignment_batch_id`, `case_id -> case_files.case_id`, `judge_id -> users.user_id` |

## 7. Theo dõi kháng cáo, kháng nghị và kết quả cấp trên

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `appellate_trackings` | Hồ sơ theo dõi kết quả phúc thẩm/giám đốc thẩm/tái thẩm. | `appellate_tracking_id` | `original_case_id -> case_files.case_id`, `original_decision_id -> decisions.decision_id`, `original_court_id/upper_court_id -> courts.court_id`, `final_result_code_id -> dm_appellate_result_codes.appellate_result_code_id`, `appeal_protest_type_catalog_id -> dm_appeal_protest_types.appeal_protest_type_id`, `fault_classification_catalog_id -> dm_fault_classifications.fault_classification_id` |
| `appeal_protest_items` | Từng đơn kháng cáo/quyết định kháng nghị. | `appeal_protest_item_id` | `appellate_tracking_id -> appellate_trackings.appellate_tracking_id`, `appellant_participant_id -> participants.participant_id`, `document_id -> documents.document_id` |
| `appellate_results` | Kết quả giải quyết của Tòa án cấp trên. | `appellate_result_id` | `appellate_tracking_id -> appellate_trackings.appellate_tracking_id`, `result_document_id -> documents.document_id`, `result_code_id -> dm_appellate_result_codes.appellate_result_code_id` |
| `appellate_fault_assessments` | Đánh giá lỗi khách quan/chủ quan khi án bị hủy/sửa. | `fault_assessment_id` | `appellate_result_id -> appellate_results.appellate_result_id`, `responsible_judge_id -> users.user_id`, `fault_classification_catalog_id -> dm_fault_classifications.fault_classification_id`, `fault_reason_group_id -> dm_fault_reason_groups.fault_reason_group_id` |
| `appellate_followup_actions` | Việc cần làm sau kết quả cấp trên. | `followup_action_id` | `appellate_tracking_id -> appellate_trackings.appellate_tracking_id`, `assigned_to -> users.user_id` |
| `appellate_status_history` | Lịch sử trạng thái theo dõi cấp trên. | `status_history_id` | `appellate_tracking_id -> appellate_trackings.appellate_tracking_id`, `changed_by -> users.user_id` |

## 8. AI, cảnh báo và validation

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `ai_suggestions` | Đề xuất/cảnh báo do AI tạo, chỉ là gợi ý. | `suggestion_id` | `case_id -> case_files.case_id`, `created_by -> users.user_id`, `reviewed_by -> users.user_id` |
| `case_risk_flags` | Cờ rủi ro của hồ sơ. | `risk_flag_id` | `case_id -> case_files.case_id`, `risk_type_id -> dm_category_items.item_id` |

## 9. Thống kê, KPI và dữ liệu tham chiếu thống kê

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `statistics_periods` | Kỳ thống kê tháng/quý/năm/tùy chọn. | `period_id` | `period_type_id -> dm_category_items.item_id` |
| `statistics_snapshots` | Số liệu thống kê đã tính/chụp tại thời điểm. | `snapshot_id` | `period_id -> statistics_periods.period_id`, `court_id -> courts.court_id`, `case_id -> case_files.case_id`, `metric_id -> dm_statistical_metrics.metric_id`, `form_item_id -> dm_statistical_form_items.form_item_id` |
| `kpi_metrics` | Định nghĩa chỉ tiêu KPI. | `metric_id` | `metric_group_id -> dm_category_items.item_id`, `statistical_metric_id -> dm_statistical_metrics.metric_id` |
| `kpi_values` | Giá trị KPI theo kỳ, đơn vị, thẩm phán. | `kpi_value_id` | `metric_id -> kpi_metrics.metric_id`, `period_id -> statistics_periods.period_id`, `court_id -> courts.court_id`, `judge_id -> users.user_id` |
| `statistical_categories` | Nhóm chỉ tiêu thống kê. | `statistical_category_id` | Không có FK ra bảng khác |
| `statistical_indicators` | Chỉ tiêu/thuộc tính thống kê dùng cho UI nhập liệu và phân loại. | `statistical_indicator_id` | `statistical_category_id -> statistical_categories.statistical_category_id` |
| `statistical_indicator_options` | Lựa chọn của chỉ tiêu thống kê. | `option_id` | `statistical_indicator_id -> statistical_indicators.statistical_indicator_id`, `parent_option_id -> statistical_indicator_options.option_id` |
| `statistical_indicator_applicability` | Phạm vi áp dụng chỉ tiêu theo loại án, entity, cấp tòa. | `applicability_id` | `statistical_indicator_id -> statistical_indicators.statistical_indicator_id` |
| `entity_statistical_attributes` | Giá trị thuộc tính thống kê gắn với case/defendant/decision/entity. | `attribute_id` | `case_id -> case_files.case_id`, `statistical_indicator_id -> statistical_indicators.statistical_indicator_id`, `option_id -> statistical_indicator_options.option_id`, `created_by -> users.user_id` |
| `dm_statistical_forms` | Danh mục biểu mẫu thống kê. | `form_id` | Không có FK bắt buộc ra bảng khác |
| `dm_statistical_metrics` | Metric thống kê chuẩn. | `metric_id` | Không có FK bắt buộc ra bảng khác |
| `dm_statistical_form_items` | Dòng/chỉ tiêu trong biểu mẫu thống kê. | `form_item_id` | `form_id -> dm_statistical_forms.form_id`, `parent_item_id -> dm_statistical_form_items.form_item_id`, `metric_id -> dm_statistical_metrics.metric_id` |

## 10. Danh mục pháp lý và danh mục nghiệp vụ chuyên sâu

| Bảng | Công dụng | Khóa chính | Cột liên kết chính |
|---|---|---|---|
| `dm_penal_code_articles` | Điều luật hình sự. | `article_id` | Không có FK ra bảng khác |
| `dm_crimes` | Tội danh/danh mục tội phạm. | `crime_id` | `article_id -> dm_penal_code_articles.article_id` |
| `dm_defendant_statistical_features` | Đặc điểm thống kê của bị cáo. | `feature_id` | Không có FK ra bảng khác |
| `defendant_statistical_features` | Gán đặc điểm thống kê cho bị cáo. | `id` | `defendant_id -> defendants.defendant_id`, `feature_id -> dm_defendant_statistical_features.feature_id`, `case_id -> case_files.case_id` |
| `dm_statistical_option_groups` | Nhóm lựa chọn thống kê theo entity. | `group_id` | Không có FK ra bảng khác |
| `dm_statistical_options` | Lựa chọn trong nhóm thống kê. | `option_id` | `group_id -> dm_statistical_option_groups.group_id` |
| `defendant_statistical_option_values` | Giá trị lựa chọn thống kê của bị cáo. | `id` | `defendant_id -> defendants.defendant_id`, `group_id -> dm_statistical_option_groups.group_id`, `option_id -> dm_statistical_options.option_id`, `case_id -> case_files.case_id` |
| `dm_legal_relationships` | Quan hệ pháp luật/loại tranh chấp. | `legal_relationship_id` | `parent_id -> dm_legal_relationships.legal_relationship_id` |
| `case_legal_relationships` | Gán quan hệ pháp luật cho hồ sơ. | `id` | `case_id -> case_files.case_id`, `legal_relationship_id -> dm_legal_relationships.legal_relationship_id` |
| `dm_trial_result_types` | Loại kết quả xét xử/giải quyết. | `trial_result_type_id` | Không có FK ra bảng khác |
| `decision_result_attributes` | Thuộc tính thống kê bổ sung của quyết định. | `id` | `decision_id -> decisions.decision_id`, `statistical_indicator_id -> statistical_indicators.statistical_indicator_id`, `option_id -> statistical_indicator_options.option_id` |
| `dm_appellate_result_codes` | Mã kết quả cấp trên. | `appellate_result_code_id` | Không có FK ra bảng khác |
| `dm_fault_classifications` | Phân loại lỗi khách quan/chủ quan/hỗn hợp/chưa xác định. | `fault_classification_id` | Không có FK ra bảng khác |
| `dm_fault_reason_groups` | Nhóm lý do lỗi khi án bị hủy/sửa. | `fault_reason_group_id` | Không có FK ra bảng khác |
| `dm_appeal_protest_types` | Danh mục loại kháng cáo/kháng nghị. | `appeal_protest_type_id` | Không có FK ra bảng khác |

## 11. Quan hệ liên kết trung tâm

- `courts` là bảng đơn vị gốc, liên kết với `users`, `court_staff`, `case_files`, `assignment_batches`, `statistics_snapshots`, `kpi_values`, `appellate_trackings`.
- `users` liên kết với `judge_profiles`, `case_assignments`, các bảng phân công, audit, KPI và appellate follow-up.
- `case_files` là bảng trung tâm liên kết hầu hết module: participants, documents, hearings, case_hearing_members, decisions, deadlines, validation, module chi tiết, assignment, appellate, statistics, AI/risk.
- `decisions` liên kết `appellate_trackings` và `appellate_results` để theo dõi kết quả cấp trên.
- `dm_categories` và `dm_category_items` là lớp danh mục dùng chung, được map qua các cột `*_id`.
- `statistical_*` và `dm_statistical_*` là lớp cấu hình thống kê, không chứa số liệu vụ án thật.
- `statistics_periods`, `statistics_snapshots`, `kpi_metrics`, `kpi_values` là lớp số liệu/KPI, dùng cho dashboard và báo cáo.

## 12. Nguyên tắc sử dụng dữ liệu

- Không ghi dữ liệu thật vào các bảng nghiệp vụ nếu chưa đến giai đoạn seed dữ liệu thật.
- AI chỉ ghi đề xuất/cảnh báo/validation, không tự ghi đè dữ liệu chính.
- Các seed có `requires_human_review` phải được người có thẩm quyền rà soát trước khi dùng làm căn cứ nghiệp vụ.
- Không đếm trùng số liệu thống kê; mọi thuật toán thống kê phải truy xuất được nguồn từ bảng/cột liên quan.
