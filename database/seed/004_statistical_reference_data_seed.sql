-- Seed 004: minimal statistical reference data.
-- Scope: conservative seed only. Detailed penal-code crimes, legal
-- relationship trees and official form items require human/legal review.

INSERT INTO statistical_categories (category_code, category_name, description, case_type_scope, sort_order)
VALUES
    ('case_classification', 'Phan loai ho so', 'Chi muc thong ke phan loai theo loai an, nhom an, giai doan.', NULL, 10),
    ('defendant_features', 'Dac diem bi cao', 'Dac diem thong ke cua bi cao dung cho checkbox/radio.', 'criminal', 20),
    ('legal_relationships', 'Quan he phap luat', 'Quan he phap luat va loai tranh chap can chuan hoa bang danh muc.', NULL, 30),
    ('trial_results', 'Ket qua xet xu', 'Ket qua giai quyet/xet xu dung cho KPI chat luong.', NULL, 40),
    ('appellate_results', 'Ket qua cap tren', 'Ket qua phuc tham, giam doc tham, tai tham va phan loai huy/sua.', NULL, 50),
    ('kpi_statistics', 'Chi tieu KPI va thong ke', 'Chi tieu dashboard/KPI can tinh tu du lieu chuan hoa.', NULL, 60)
ON CONFLICT (category_code) DO UPDATE SET
    category_name = EXCLUDED.category_name,
    description = EXCLUDED.description,
    case_type_scope = EXCLUDED.case_type_scope,
    sort_order = EXCLUDED.sort_order,
    updated_at = CURRENT_TIMESTAMP;

WITH indicators(category_code, indicator_code, indicator_name, input_control_type, value_type, allow_multiple, applies_to_entity, case_type_scope, sort_order) AS (
    VALUES
        ('defendant_features', 'defendant_feature_flags', 'Dac diem thong ke dang checkbox cua bi cao', 'checkbox_group', 'option', TRUE, 'defendant', 'criminal', 10),
        ('defendant_features', 'recidivism_status', 'Tinh trang tai pham', 'radio', 'option', FALSE, 'defendant', 'criminal', 20),
        ('legal_relationships', 'case_legal_relationship', 'Quan he phap luat cua ho so', 'dropdown', 'option', TRUE, 'case', NULL, 30),
        ('trial_results', 'trial_result_type', 'Loai ket qua xet xu/giai quyet', 'dropdown', 'option', FALSE, 'decision', NULL, 40),
        ('appellate_results', 'upper_court_result', 'Ket qua Toa an cap tren', 'dropdown', 'option', FALSE, 'appellate_tracking', NULL, 50),
        ('kpi_statistics', 'kpi_metric_selector', 'Chi tieu KPI bao cao', 'dropdown', 'option', FALSE, 'kpi_metric', NULL, 60)
)
INSERT INTO statistical_indicators (
    statistical_category_id,
    indicator_code,
    indicator_name,
    input_control_type,
    value_type,
    allow_multiple,
    applies_to_entity,
    case_type_scope,
    sort_order
)
SELECT c.statistical_category_id, i.indicator_code, i.indicator_name, i.input_control_type,
       i.value_type, i.allow_multiple, i.applies_to_entity, i.case_type_scope, i.sort_order
FROM indicators i
JOIN statistical_categories c ON c.category_code = i.category_code
ON CONFLICT (indicator_code) DO UPDATE SET
    indicator_name = EXCLUDED.indicator_name,
    input_control_type = EXCLUDED.input_control_type,
    value_type = EXCLUDED.value_type,
    allow_multiple = EXCLUDED.allow_multiple,
    applies_to_entity = EXCLUDED.applies_to_entity,
    case_type_scope = EXCLUDED.case_type_scope,
    sort_order = EXCLUDED.sort_order,
    updated_at = CURRENT_TIMESTAMP;

WITH feature_seed(feature_code, feature_name, sort_order) AS (
    VALUES
        ('minor', 'Nguoi chua thanh nien/vi thanh nien', 10),
        ('party_member', 'Dang vien', 20),
        ('female', 'Nu', 30),
        ('ethnic_minority', 'Nguoi dan toc thieu so', 40),
        ('foreigner', 'Nguoi nuoc ngoai', 50),
        ('detained', 'Bi tam giam', 60),
        ('legal_aid', 'Duoc tro giup phap ly', 70),
        ('prior_conviction', 'Co tien an', 80),
        ('prior_administrative_record', 'Co tien su', 90),
        ('policy_beneficiary', 'Thuoc dien chinh sach can xac nhan', 100)
)
INSERT INTO dm_defendant_statistical_features (feature_code, feature_name, sort_order)
SELECT feature_code, feature_name, sort_order
FROM feature_seed
ON CONFLICT (feature_code) DO UPDATE SET
    feature_name = EXCLUDED.feature_name,
    sort_order = EXCLUDED.sort_order;

WITH indicator AS (
    SELECT statistical_indicator_id FROM statistical_indicators WHERE indicator_code = 'defendant_feature_flags'
), option_seed(option_code, option_name, sort_order) AS (
    VALUES
        ('minor', 'Nguoi chua thanh nien/vi thanh nien', 10),
        ('party_member', 'Dang vien', 20),
        ('female', 'Nu', 30),
        ('ethnic_minority', 'Nguoi dan toc thieu so', 40),
        ('foreigner', 'Nguoi nuoc ngoai', 50),
        ('detained', 'Bi tam giam', 60),
        ('legal_aid', 'Duoc tro giup phap ly', 70)
)
INSERT INTO statistical_indicator_options (statistical_indicator_id, option_code, option_name, sort_order)
SELECT i.statistical_indicator_id, o.option_code, o.option_name, o.sort_order
FROM option_seed o CROSS JOIN indicator i
ON CONFLICT (statistical_indicator_id, option_code) DO UPDATE SET
    option_name = EXCLUDED.option_name,
    sort_order = EXCLUDED.sort_order,
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO dm_statistical_option_groups (group_code, group_name, allow_multiple, applies_to_entity, sort_order)
VALUES
    ('recidivism_status', 'Tinh trang tai pham', FALSE, 'defendant', 10),
    ('detention_status', 'Tinh trang tam giam/bien phap ngan chan', FALSE, 'defendant', 20)
ON CONFLICT (group_code) DO UPDATE SET
    group_name = EXCLUDED.group_name,
    allow_multiple = EXCLUDED.allow_multiple,
    applies_to_entity = EXCLUDED.applies_to_entity,
    sort_order = EXCLUDED.sort_order;

WITH option_seed(group_code, option_code, option_name, sort_order) AS (
    VALUES
        ('recidivism_status', 'none_or_unknown', 'Khong co hoac chua xac dinh', 10),
        ('recidivism_status', 'recidivism', 'Tai pham', 20),
        ('recidivism_status', 'dangerous_recidivism', 'Tai pham nguy hiem', 30),
        ('detention_status', 'not_detained', 'Khong bi tam giam', 10),
        ('detention_status', 'detained', 'Bi tam giam', 20),
        ('detention_status', 'other_preventive_measure', 'Ap dung bien phap ngan chan khac', 30)
)
INSERT INTO dm_statistical_options (group_id, option_code, option_name, sort_order)
SELECT g.group_id, o.option_code, o.option_name, o.sort_order
FROM option_seed o
JOIN dm_statistical_option_groups g ON g.group_code = o.group_code
ON CONFLICT (group_id, option_code) DO UPDATE SET
    option_name = EXCLUDED.option_name,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_legal_relationships (relationship_code, relationship_name, case_type_scope, sort_order)
VALUES
    ('civil_general_review_required', 'Dan su - can bo sung danh muc chi tiet tu bieu mau/nguon phap ly', 'civil', 10),
    ('marriage_family_general_review_required', 'Hon nhan gia dinh - can bo sung danh muc chi tiet tu bieu mau/nguon phap ly', 'marriage_family', 20),
    ('business_commercial_general_review_required', 'Kinh doanh thuong mai - can bo sung danh muc chi tiet tu bieu mau/nguon phap ly', 'business_commercial', 30),
    ('labor_general_review_required', 'Lao dong - can bo sung danh muc chi tiet tu bieu mau/nguon phap ly', 'labor', 40)
ON CONFLICT (relationship_code) DO UPDATE SET
    relationship_name = EXCLUDED.relationship_name,
    case_type_scope = EXCLUDED.case_type_scope,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_trial_result_types (result_code, result_name, affects_kpi, is_final_result, sort_order)
VALUES
    ('accepted_claim', 'Chap nhan yeu cau/khoi kien', TRUE, TRUE, 10),
    ('partially_accepted_claim', 'Chap nhan mot phan yeu cau/khoi kien', TRUE, TRUE, 20),
    ('rejected_claim', 'Khong chap nhan yeu cau/khoi kien', TRUE, TRUE, 30),
    ('suspended', 'Dinh chi', TRUE, TRUE, 40),
    ('temporarily_suspended', 'Tam dinh chi', TRUE, FALSE, 50),
    ('transferred_or_returned', 'Chuyen/tra ho so theo thu tuc', TRUE, FALSE, 60),
    ('other_review_required', 'Ket qua khac - can xac nhan nghiep vu', TRUE, TRUE, 100)
ON CONFLICT (result_code) DO UPDATE SET
    result_name = EXCLUDED.result_name,
    affects_kpi = EXCLUDED.affects_kpi,
    is_final_result = EXCLUDED.is_final_result,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_appellate_result_codes (
    result_code,
    result_name,
    is_cancelled,
    is_modified,
    is_upheld,
    is_withdrawn,
    requires_fault_classification,
    affects_quality_kpi,
    sort_order
)
VALUES
    ('upheld', 'Y an/giu nguyen', FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, 10),
    ('modified', 'Sua', FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, 20),
    ('cancelled', 'Huy', TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, 30),
    ('cancelled_and_remanded', 'Huy va giao xet xu/giai quyet lai', TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, 40),
    ('withdrawn', 'Rut khang cao/khang nghi', FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, 50),
    ('terminated', 'Dinh chi xet xu/giai quyet o cap tren', FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 60),
    ('other_review_required', 'Ket qua khac - can xac nhan nghiep vu', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 100)
ON CONFLICT (result_code) DO UPDATE SET
    result_name = EXCLUDED.result_name,
    is_cancelled = EXCLUDED.is_cancelled,
    is_modified = EXCLUDED.is_modified,
    is_upheld = EXCLUDED.is_upheld,
    is_withdrawn = EXCLUDED.is_withdrawn,
    requires_fault_classification = EXCLUDED.requires_fault_classification,
    affects_quality_kpi = EXCLUDED.affects_quality_kpi,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_fault_classifications (classification_code, classification_name, sort_order)
VALUES
    ('objective', 'Khach quan', 10),
    ('subjective', 'Chu quan', 20),
    ('mixed', 'Hon hop', 30),
    ('unknown', 'Chua xac dinh', 40)
ON CONFLICT (classification_code) DO UPDATE SET
    classification_name = EXCLUDED.classification_name,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_fault_reason_groups (reason_code, reason_name, classification_scope, sort_order)
VALUES
    ('procedure', 'Thu tuc to tung', NULL, 10),
    ('evidence_assessment', 'Danh gia chung cu', NULL, 20),
    ('law_application', 'Ap dung phap luat', NULL, 30),
    ('objective_change', 'Tinh tiet khach quan thay doi', 'objective', 40),
    ('unknown', 'Chua xac dinh', 'unknown', 50)
ON CONFLICT (reason_code) DO UPDATE SET
    reason_name = EXCLUDED.reason_name,
    classification_scope = EXCLUDED.classification_scope,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_appeal_protest_types (type_code, type_name, sort_order)
VALUES
    ('APPEAL', 'Khang cao', 10),
    ('PROTEST', 'Khang nghi', 20),
    ('BOTH', 'Co ca khang cao va khang nghi', 30)
ON CONFLICT (type_code) DO UPDATE SET
    type_name = EXCLUDED.type_name,
    sort_order = EXCLUDED.sort_order;

INSERT INTO dm_statistical_forms (form_code, form_name, case_type_scope, report_period_type, legal_basis)
VALUES
    ('FORM_REVIEW_REQUIRED', 'Bieu mau thong ke can doi chieu Quyết định 287/QĐ-TANDTC va JSON trong knowledge_base', NULL, NULL, 'Documents/huong_dan_bm.pdf'),
    ('HS_ST_1A', 'Hình sự sơ thẩm - Mẫu 1A', 'criminal', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('HS_PT_1B', 'Hình sự phúc thẩm - Mẫu 1B', 'criminal', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('DS_ST_2A', 'Dân sự sơ thẩm - Mẫu 2A', 'civil', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('DS_PT_2B', 'Dân sự phúc thẩm - Mẫu 2B', 'civil', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('HNGD_ST_3A', 'Hôn nhân gia đình sơ thẩm - Mẫu 3A', 'marriage_family', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('HNGD_PT_3B', 'Hôn nhân gia đình phúc thẩm - Mẫu 3B', 'marriage_family', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('KDTM_ST_4A', 'Kinh doanh thương mại sơ thẩm - Mẫu 4A', 'business_commercial', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('KDTM_PT_4B', 'Kinh doanh thương mại phúc thẩm - Mẫu 4B', 'business_commercial', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('LD_ST_5A', 'Lao động sơ thẩm - Mẫu 5A', 'labor', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('LD_PT_5B', 'Lao động phúc thẩm - Mẫu 5B', 'labor', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('HC_ST_6A', 'Hành chính sơ thẩm - Mẫu 6A', 'administrative', 'date_range', 'Documents/huong_dan_bm.pdf'),
    ('HC_PT_6B', 'Hành chính phúc thẩm - Mẫu 6B', 'administrative', 'date_range', 'Documents/huong_dan_bm.pdf')
ON CONFLICT (form_code) DO UPDATE SET
    form_name = EXCLUDED.form_name,
    case_type_scope = EXCLUDED.case_type_scope,
    report_period_type = EXCLUDED.report_period_type,
    legal_basis = EXCLUDED.legal_basis;

-- Cấu trúc cột của 12 mẫu A/B. Tên nghiệp vụ chi tiết và nguồn join phức tạp
-- được version hóa tại knowledge_base/data/statistics/report_mapping_ab.json.
WITH form_columns(form_code, column_count) AS (
    VALUES
        ('HS_ST_1A', 91), ('HS_PT_1B', 77),
        ('DS_ST_2A', 34), ('DS_PT_2B', 49),
        ('HNGD_ST_3A', 36), ('HNGD_PT_3B', 49),
        ('KDTM_ST_4A', 32), ('KDTM_PT_4B', 49),
        ('LD_ST_5A', 35), ('LD_PT_5B', 49),
        ('HC_ST_6A', 37), ('HC_PT_6B', 47)
), items AS (
    SELECT f.form_id,
           series.column_no,
           'C' || series.column_no::text AS item_code,
           'Cột ' || series.column_no::text AS item_name
    FROM form_columns fc
    JOIN dm_statistical_forms f ON f.form_code = fc.form_code
    CROSS JOIN LATERAL generate_series(1, fc.column_count) AS series(column_no)
)
INSERT INTO dm_statistical_form_items (form_id, item_code, item_name, input_control_type, sort_order)
SELECT form_id, item_code, item_name,
       CASE WHEN column_no = 1 THEN 'label' ELSE 'number' END,
       column_no
FROM items
ON CONFLICT (form_id, item_code) DO UPDATE SET
    item_name = EXCLUDED.item_name,
    input_control_type = EXCLUDED.input_control_type,
    sort_order = EXCLUDED.sort_order;

WITH formula_targets(form_code, column_no) AS (
    VALUES
        ('HS_ST_1A', 9), ('HS_ST_1A', 10), ('HS_ST_1A', 37), ('HS_ST_1A', 38), ('HS_ST_1A', 39), ('HS_ST_1A', 40),
        ('HS_PT_1B', 11), ('HS_PT_1B', 12), ('HS_PT_1B', 13), ('HS_PT_1B', 14), ('HS_PT_1B', 28), ('HS_PT_1B', 29), ('HS_PT_1B', 30), ('HS_PT_1B', 31), ('HS_PT_1B', 32), ('HS_PT_1B', 33), ('HS_PT_1B', 34), ('HS_PT_1B', 35),
        ('DS_ST_2A', 6), ('DS_ST_2A', 10), ('DS_ST_2A', 11), ('DS_ST_2A', 14),
        ('HNGD_ST_3A', 6), ('HNGD_ST_3A', 15), ('HNGD_ST_3A', 16),
        ('KDTM_ST_4A', 6), ('KDTM_ST_4A', 12), ('KDTM_ST_4A', 13), ('KDTM_ST_4A', 14),
        ('LD_ST_5A', 6), ('LD_ST_5A', 12), ('LD_ST_5A', 13), ('LD_ST_5A', 14),
        ('HC_ST_6A', 6), ('HC_ST_6A', 9), ('HC_ST_6A', 13), ('HC_ST_6A', 15), ('HC_ST_6A', 17),
        ('DS_PT_2B', 6), ('DS_PT_2B', 7), ('DS_PT_2B', 8), ('DS_PT_2B', 13), ('DS_PT_2B', 16), ('DS_PT_2B', 17), ('DS_PT_2B', 18), ('DS_PT_2B', 19), ('DS_PT_2B', 20), ('DS_PT_2B', 21), ('DS_PT_2B', 22),
        ('HNGD_PT_3B', 6), ('HNGD_PT_3B', 7), ('HNGD_PT_3B', 8), ('HNGD_PT_3B', 13), ('HNGD_PT_3B', 16), ('HNGD_PT_3B', 17), ('HNGD_PT_3B', 18), ('HNGD_PT_3B', 19), ('HNGD_PT_3B', 20), ('HNGD_PT_3B', 21), ('HNGD_PT_3B', 22),
        ('KDTM_PT_4B', 6), ('KDTM_PT_4B', 7), ('KDTM_PT_4B', 8), ('KDTM_PT_4B', 13), ('KDTM_PT_4B', 16), ('KDTM_PT_4B', 17), ('KDTM_PT_4B', 18), ('KDTM_PT_4B', 19), ('KDTM_PT_4B', 20), ('KDTM_PT_4B', 21), ('KDTM_PT_4B', 22),
        ('LD_PT_5B', 6), ('LD_PT_5B', 7), ('LD_PT_5B', 8), ('LD_PT_5B', 13), ('LD_PT_5B', 16), ('LD_PT_5B', 17), ('LD_PT_5B', 18), ('LD_PT_5B', 19), ('LD_PT_5B', 20), ('LD_PT_5B', 21), ('LD_PT_5B', 22),
        ('HC_PT_6B', 6), ('HC_PT_6B', 7), ('HC_PT_6B', 8), ('HC_PT_6B', 13), ('HC_PT_6B', 16), ('HC_PT_6B', 17), ('HC_PT_6B', 18), ('HC_PT_6B', 19), ('HC_PT_6B', 20), ('HC_PT_6B', 21), ('HC_PT_6B', 22)
)
UPDATE dm_statistical_form_items item
SET formula_ref = 'knowledge_base/data/statistics/report_mapping_ab.json#' || target.form_code || '.C' || target.column_no::text,
    input_control_type = 'formula'
FROM formula_targets target
JOIN dm_statistical_forms form_ref ON form_ref.form_code = target.form_code
WHERE item.form_id = form_ref.form_id
  AND item.item_code = 'C' || target.column_no::text;

-- Nguồn trực tiếp chung; nguồn kết quả và grain đặc thù nằm trong mapping/service.
UPDATE dm_statistical_form_items item
SET source_table = CASE WHEN form_ref.form_code LIKE '%_ST_%' THEN 'case_files' ELSE 'appellate_trackings' END,
    source_field = CASE WHEN form_ref.form_code LIKE '%_ST_%' THEN 'acceptance_date' ELSE 'upper_court_acceptance_date' END
FROM dm_statistical_forms form_ref
WHERE item.form_id = form_ref.form_id
  AND (
      (form_ref.form_code LIKE '%_ST_%' AND item.item_code IN ('C2', 'C3'))
      OR (form_ref.form_code LIKE '%_PT_%' AND item.item_code IN ('C2', 'C3', 'C4', 'C5'))
  );

WITH metrics(metric_code, metric_name, metric_group, aggregation_method, sort_hint) AS (
    VALUES
        ('total_accepted_cases', 'Tong so an thu ly', 'case_volume', 'sum', 10),
        ('resolved_cases', 'So an da giai quyet', 'case_volume', 'sum', 20),
        ('pending_cases', 'So an con ton', 'case_volume', 'sum', 30),
        ('overdue_cases', 'So an qua han', 'deadline', 'sum', 40),
        ('clearance_rate', 'Ty le giai quyet', 'case_quality', 'ratio', 50),
        ('appeal_rate', 'Ty le khang cao', 'appeal_protest', 'ratio', 60),
        ('protest_rate', 'Ty le khang nghi', 'appeal_protest', 'ratio', 70),
        ('upheld_rate', 'Ty le y an', 'appeal_protest', 'ratio', 80),
        ('modified_rate', 'Ty le sua', 'appeal_protest', 'ratio', 90),
        ('cancelled_rate', 'Ty le huy', 'appeal_protest', 'ratio', 100),
        ('subjective_modified_cancelled_rate', 'Ty le huy/sua do chu quan', 'case_quality', 'ratio', 110),
        ('objective_modified_cancelled_rate', 'Ty le huy/sua do khach quan', 'case_quality', 'ratio', 120),
        ('withdrawn_appeal_protest_rate', 'Ty le rut khang cao/khang nghi', 'appeal_protest', 'ratio', 130),
        ('returned_investigation_rate', 'Ty le tra ho so dieu tra bo sung', 'criminal', 'ratio', 140),
        ('mediation_success_rate', 'Ty le hoa giai thanh', 'civil', 'ratio', 150),
        ('dialogue_success_rate', 'Ty le doi thoai thanh', 'administrative', 'ratio', 160),
        ('random_assignment_compliance_rate', 'Ty le tuan thu phan cong ngau nhien', 'random_assignment', 'ratio', 170)
)
INSERT INTO dm_statistical_metrics (metric_code, metric_name, metric_group, aggregation_method)
SELECT metric_code, metric_name, metric_group, aggregation_method
FROM metrics
ON CONFLICT (metric_code) DO UPDATE SET
    metric_name = EXCLUDED.metric_name,
    metric_group = EXCLUDED.metric_group,
    aggregation_method = EXCLUDED.aggregation_method;

WITH form_ref AS (
    SELECT form_id FROM dm_statistical_forms WHERE form_code = 'FORM_REVIEW_REQUIRED'
), item_seed(item_code, item_name, metric_code, sort_order) AS (
    VALUES
        ('total_accepted_cases', 'Tong so an thu ly', 'total_accepted_cases', 10),
        ('resolved_cases', 'So an da giai quyet', 'resolved_cases', 20),
        ('pending_cases', 'So an con ton', 'pending_cases', 30),
        ('overdue_cases', 'So an qua han', 'overdue_cases', 40)
)
INSERT INTO dm_statistical_form_items (form_id, item_code, item_name, metric_code, metric_id, input_control_type, sort_order)
SELECT f.form_id, i.item_code, i.item_name, i.metric_code, m.metric_id, 'number', i.sort_order
FROM item_seed i
CROSS JOIN form_ref f
LEFT JOIN dm_statistical_metrics m ON m.metric_code = i.metric_code
ON CONFLICT (form_id, item_code) DO UPDATE SET
    item_name = EXCLUDED.item_name,
    metric_code = EXCLUDED.metric_code,
    metric_id = EXCLUDED.metric_id,
    input_control_type = EXCLUDED.input_control_type,
    sort_order = EXCLUDED.sort_order;

-- TODO: seed dm_penal_code_articles and dm_crimes from an official Penal Code
-- catalog after human/legal review. Do not generate a full crime list here.
