# Statistical Input UI Mapping Checklist

Checklist này mô tả nguồn danh mục, kiểu điều khiển UI và bảng đích cho các trường thống kê không được nhập text tự do.

| Input | UI khuyến nghị | Source | Target | Ghi chú |
| --- | --- | --- | --- | --- |
| `case_files.case_type` | Dropdown | `dm_category_items` category `case_type` | `case_files.case_type_id` | Enum/text cũ giữ để migration an toàn. |
| `case_files.case_group` | Dropdown | `dm_category_items` category `case_group` | `case_files.case_group_id` | Dùng cho dashboard/KPI. |
| `case_files.procedure_law` | Radio/dropdown | `dm_category_items` category `procedure_law` | `case_files.procedure_law_id` | Không nhập tay BLTTDS/BLTTHS/LTTHC. |
| `case_files.current_stage` | Dropdown | `dm_category_items` category `case_stage` | `case_files.current_stage_id` | Theo dõi vòng đời hồ sơ. |
| `participants.participant_type` | Dropdown | `dm_category_items` category `participant_type` | `participants.participant_type_id` | Vai trò tố tụng. |
| `documents.document_type` | Dropdown | `dm_category_items` category `document_type` | `documents.document_type_id` | Loại tài liệu hồ sơ. |
| `hearings.hearing_type` | Dropdown | `dm_category_items` category `hearing_type` | `hearings.hearing_type_id` | Phiên tòa/phiên họp/hòa giải/đối thoại. |
| `hearings.hearing_status` | Dropdown/radio | `dm_category_items` category `hearing_status` | `hearings.hearing_status_id` | Trạng thái lịch/phien. |
| `decisions.decision_type` | Dropdown | `dm_category_items` category `decision_type` | `decisions.decision_type_id` | Loại bản án/quyết định. |
| `decisions.trial_result_type_id` | Radio/dropdown | `dm_trial_result_types` | `decisions.trial_result_type_id` | Kết quả chính, ảnh hưởng KPI. |
| `decision_result_attributes.option_id` | Checkbox/radio theo indicator | `statistical_indicator_options` | `decision_result_attributes` | Kết quả chi tiết nhiều lựa chọn. |
| `charges.crime_id` | Searchable dropdown | `dm_crimes` | `charges.crime_id` | Chỉ seed sau khi có danh mục tội danh được duyệt. |
| `charges.article_id` | Searchable dropdown | `dm_penal_code_articles` | `charges.article_id` | Điều luật theo catalog chính thức. |
| `defendants.feature_ids` | Checkbox group | `dm_defendant_statistical_features` | `defendant_statistical_features` | Cho phép nhiều đặc điểm cùng lúc. |
| `defendants.recidivism_status` | Radio group | `dm_statistical_option_groups` + `dm_statistical_options` | `defendant_statistical_option_values` | Trigger chặn chọn trùng nhóm single-select. |
| `case_legal_relationships.legal_relationship_id` | Dropdown/tree select hoặc checkbox tree | `dm_legal_relationships` | `case_legal_relationships` | Có partial unique cho một quan hệ chính. |
| `appellate_trackings.appeal_protest_type_catalog_id` | Radio/dropdown | `dm_appeal_protest_types` | `appellate_trackings.appeal_protest_type_catalog_id` | Cột enum cũ vẫn giữ. |
| `appellate_trackings.final_result_code_id` | Dropdown/radio | `dm_appellate_result_codes` | `appellate_trackings.final_result_code_id` | Không nhập text tự do cho y án/sửa/hủy. |
| `appellate_fault_assessments.fault_classification_catalog_id` | Radio | `dm_fault_classifications` | `appellate_fault_assessments.fault_classification_catalog_id` | Không tự kết luận lỗi chủ quan nếu chưa có căn cứ. |
| `appellate_fault_assessments.fault_reason_group_catalog_id` | Dropdown | `dm_fault_reason_groups` | `appellate_fault_assessments.fault_reason_group_catalog_id` | Nhóm lý do hủy/sửa. |
| `statistics_snapshots.metric_id` | Dropdown hệ thống/job | `dm_statistical_metrics` | `statistics_snapshots.metric_id` | Snapshot không là nguồn nhập tay chính. |
| `statistics_snapshots.form_item_id` | Dropdown hệ thống/job | `dm_statistical_form_items` | `statistics_snapshots.form_item_id` | Mapping chỉ tiêu biểu mẫu. |
| `kpi_metrics.statistical_metric_id` | Dropdown hệ thống | `dm_statistical_metrics` | `kpi_metrics.statistical_metric_id` | Đồng bộ mã KPI với metric catalog. |

## Kiểm tra bắt buộc trước khi làm UI

- Không render ô nhập text tự do cho các trường có source danh mục ở trên.
- Checkbox tạo nhiều dòng liên kết, không nối chuỗi nhiều giá trị vào một cột.
- Radio/dropdown chỉ ghi một khóa danh mục.
- Trường legacy text/code chỉ dùng giai đoạn backfill hoặc hiển thị snapshot, không dùng làm nguồn tính thống kê lâu dài.
- Các danh mục chi tiết chưa được duyệt pháp lý phải hiển thị trạng thái cần rà soát, không coi là catalog chính thức.
