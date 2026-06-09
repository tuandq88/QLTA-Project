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
    ('FORM_REVIEW_REQUIRED', 'Bieu mau thong ke can doi chieu Quyết định 287/QĐ-TANDTC va JSON trong knowledge_base', NULL, NULL, 'Documents/huong_dan_bm.pdf')
ON CONFLICT (form_code) DO UPDATE SET
    form_name = EXCLUDED.form_name,
    legal_basis = EXCLUDED.legal_basis;

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
