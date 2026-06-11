-- Test seed 050: deterministic criminal appellate defendant-level results.
-- This file is for tests only. Do not include it in production seed bundles.

INSERT INTO courts (court_id, court_code, court_name, court_level, province, is_active)
VALUES (
    '97000000-0000-0000-0000-000000000001',
    'TEST_HSPT_QNG',
    'TAND test hinh su phuc tham',
    'province',
    'Quang Ngai',
    TRUE
)
ON CONFLICT (court_code) DO UPDATE SET
    court_name = EXCLUDED.court_name,
    court_level = EXCLUDED.court_level,
    province = EXCLUDED.province,
    is_active = TRUE,
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO case_files (
    case_id,
    court_id,
    case_code,
    case_number,
    case_type,
    case_group,
    procedure_law,
    filing_date,
    acceptance_date,
    current_stage,
    case_status,
    closed_date,
    summary
)
VALUES
    ('97100000-0000-0000-0000-000000000001', '97000000-0000-0000-0000-000000000001', 'HSPT-001', '01/2026/HSPT-TEST', 'criminal', 'PHUC_THAM', 'BLTTHS', DATE '2026-06-01', DATE '2026-06-01', 'appeal_tracking', 'preparing', NULL, '3 bi cao, 1 rut khang cao truoc phien toa, 2 chua co ket qua den 2026-06-10.'),
    ('97100000-0000-0000-0000-000000000002', '97000000-0000-0000-0000-000000000001', 'HSPT-002', '02/2026/HSPT-TEST', 'criminal', 'PHUC_THAM', 'BLTTHS', DATE '2026-06-01', DATE '2026-06-01', 'resolved', 'resolved', DATE '2026-06-12', '4 bi cao, co dinh chi truoc phien toa, dinh chi tai phien toa, y an va sua an.'),
    ('97100000-0000-0000-0000-000000000003', '97000000-0000-0000-0000-000000000001', 'HSPT-003', '03/2026/HSPT-TEST', 'criminal', 'PHUC_THAM', 'BLTTHS', DATE '2026-06-15', DATE '2026-06-15', 'resolved', 'resolved', DATE '2026-07-05', '2 bi cao, ket qua trong thang 7: huy an khach quan va sua an khach quan.'),
    ('97100000-0000-0000-0000-000000000004', '97000000-0000-0000-0000-000000000001', 'HSPT-004', '04/2026/HSPT-TEST', 'criminal', 'PHUC_THAM', 'BLTTHS', DATE '2026-06-10', DATE '2026-06-10', 'resolved', 'resolved', DATE '2026-06-20', '1 bi cao, dinh chi khac tai phien toa.'),
    ('97100000-0000-0000-0000-000000000005', '97000000-0000-0000-0000-000000000001', 'HSPT-005', '05/2026/HSPT-TEST', 'criminal', 'PHUC_THAM', 'BLTTHS', DATE '2026-06-11', DATE '2026-06-11', 'appeal_tracking', 'preparing', NULL, '3 bi cao, 2 da co ket qua thang 6, 1 chua co ket qua.')
ON CONFLICT (case_code) DO UPDATE SET
    case_number = EXCLUDED.case_number,
    case_type = EXCLUDED.case_type,
    case_group = EXCLUDED.case_group,
    procedure_law = EXCLUDED.procedure_law,
    filing_date = EXCLUDED.filing_date,
    acceptance_date = EXCLUDED.acceptance_date,
    current_stage = EXCLUDED.current_stage,
    case_status = EXCLUDED.case_status,
    closed_date = EXCLUDED.closed_date,
    summary = EXCLUDED.summary,
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO criminal_case_details (
    criminal_detail_id,
    case_id,
    procuracy_name,
    indictment_number,
    indictment_date,
    investigation_agency,
    dossier_received_date,
    trial_panel_type
)
VALUES
    ('97200000-0000-0000-0000-000000000001', '97100000-0000-0000-0000-000000000001', 'VKSND tinh Quang Ngai', 'HSPT-CT-001', DATE '2026-05-20', 'CQDT test', DATE '2026-06-01', 'HOI_DONG'),
    ('97200000-0000-0000-0000-000000000002', '97100000-0000-0000-0000-000000000002', 'VKSND tinh Quang Ngai', 'HSPT-CT-002', DATE '2026-05-22', 'CQDT test', DATE '2026-06-01', 'HOI_DONG'),
    ('97200000-0000-0000-0000-000000000003', '97100000-0000-0000-0000-000000000003', 'VKSND tinh Quang Ngai', 'HSPT-CT-003', DATE '2026-06-10', 'CQDT test', DATE '2026-06-15', 'HOI_DONG'),
    ('97200000-0000-0000-0000-000000000004', '97100000-0000-0000-0000-000000000004', 'VKSND tinh Quang Ngai', 'HSPT-CT-004', DATE '2026-06-05', 'CQDT test', DATE '2026-06-10', 'HOI_DONG'),
    ('97200000-0000-0000-0000-000000000005', '97100000-0000-0000-0000-000000000005', 'VKSND tinh Quang Ngai', 'HSPT-CT-005', DATE '2026-06-06', 'CQDT test', DATE '2026-06-11', 'HOI_DONG')
ON CONFLICT (case_id) DO UPDATE SET
    procuracy_name = EXCLUDED.procuracy_name,
    indictment_number = EXCLUDED.indictment_number,
    indictment_date = EXCLUDED.indictment_date,
    investigation_agency = EXCLUDED.investigation_agency,
    dossier_received_date = EXCLUDED.dossier_received_date,
    trial_panel_type = EXCLUDED.trial_panel_type;

INSERT INTO defendants (
    defendant_id,
    criminal_detail_id,
    full_name,
    date_of_birth,
    gender,
    nationality,
    residence,
    criminal_record_status,
    is_detained
)
VALUES
    ('97300000-0000-0000-0001-000000000001', '97200000-0000-0000-0000-000000000001', 'HSPT 001 Bi cao 1', DATE '1990-01-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0001-000000000002', '97200000-0000-0000-0000-000000000001', 'HSPT 001 Bi cao 2', DATE '1991-01-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0001-000000000003', '97200000-0000-0000-0000-000000000001', 'HSPT 001 Bi cao 3', DATE '1992-01-01', 'female', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0002-000000000001', '97200000-0000-0000-0000-000000000002', 'HSPT 002 Bi cao 1', DATE '1990-02-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0002-000000000002', '97200000-0000-0000-0000-000000000002', 'HSPT 002 Bi cao 2', DATE '1991-02-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0002-000000000003', '97200000-0000-0000-0000-000000000002', 'HSPT 002 Bi cao 3', DATE '1992-02-01', 'female', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0002-000000000004', '97200000-0000-0000-0000-000000000002', 'HSPT 002 Bi cao 4', DATE '1993-02-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0003-000000000001', '97200000-0000-0000-0000-000000000003', 'HSPT 003 Bi cao 1', DATE '1990-03-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0003-000000000002', '97200000-0000-0000-0000-000000000003', 'HSPT 003 Bi cao 2', DATE '1991-03-01', 'female', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0004-000000000001', '97200000-0000-0000-0000-000000000004', 'HSPT 004 Bi cao 1', DATE '1990-04-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0005-000000000001', '97200000-0000-0000-0000-000000000005', 'HSPT 005 Bi cao 1', DATE '1990-05-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0005-000000000002', '97200000-0000-0000-0000-000000000005', 'HSPT 005 Bi cao 2', DATE '1991-05-01', 'female', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('97300000-0000-0000-0005-000000000003', '97200000-0000-0000-0000-000000000005', 'HSPT 005 Bi cao 3', DATE '1992-05-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE)
ON CONFLICT (defendant_id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    date_of_birth = EXCLUDED.date_of_birth,
    gender = EXCLUDED.gender,
    nationality = EXCLUDED.nationality,
    residence = EXCLUDED.residence,
    criminal_record_status = EXCLUDED.criminal_record_status,
    is_detained = EXCLUDED.is_detained;

INSERT INTO criminal_appellate_defendant_results (
    appellate_result_id,
    case_id,
    defendant_id,
    appeal_protest_scope_code,
    decision_stage_code,
    result_group_code,
    result_type_code,
    result_date,
    decision_number,
    is_final_result,
    counted_as_defendant_resolved,
    counted_as_case_resolved,
    note
)
VALUES
    ('97400000-0000-0000-0001-000000000001', '97100000-0000-0000-0000-000000000001', '97300000-0000-0000-0001-000000000001', 'APPEAL', 'BEFORE_HEARING', 'TERMINATION', 'WITHDRAWAL_BEFORE_HEARING', DATE '2026-06-05', 'QD-HSPT-001-1', TRUE, TRUE, FALSE, 'Rut khang cao truoc phien toa.'),
    ('97400000-0000-0000-0002-000000000001', '97100000-0000-0000-0000-000000000002', '97300000-0000-0000-0002-000000000001', 'APPEAL', 'BEFORE_HEARING', 'TERMINATION', 'WITHDRAWAL_BEFORE_HEARING', DATE '2026-06-03', 'QD-HSPT-002-1', TRUE, TRUE, FALSE, 'Rut khang cao truoc phien toa.'),
    ('97400000-0000-0000-0002-000000000002', '97100000-0000-0000-0000-000000000002', '97300000-0000-0000-0002-000000000002', 'APPEAL', 'AT_HEARING', 'TERMINATION', 'WITHDRAWAL_AT_HEARING', DATE '2026-06-12', 'BA-HSPT-002', TRUE, TRUE, TRUE, 'Rut khang cao tai phien toa.'),
    ('97400000-0000-0000-0002-000000000003', '97100000-0000-0000-0000-000000000002', '97300000-0000-0000-0002-000000000003', 'APPEAL', 'AT_HEARING', 'TRIAL', 'UPHOLD_FIRST_INSTANCE', DATE '2026-06-12', 'BA-HSPT-002', TRUE, TRUE, TRUE, 'Y an so tham.'),
    ('97400000-0000-0000-0002-000000000004', '97100000-0000-0000-0000-000000000002', '97300000-0000-0000-0002-000000000004', 'APPEAL', 'AT_HEARING', 'TRIAL', 'MODIFY_FIRST_INSTANCE_SUBJECTIVE', DATE '2026-06-12', 'BA-HSPT-002', TRUE, TRUE, TRUE, 'Sua an do nguyen nhan chu quan.'),
    ('97400000-0000-0000-0003-000000000001', '97100000-0000-0000-0000-000000000003', '97300000-0000-0000-0003-000000000001', 'APPEAL', 'AT_HEARING', 'TRIAL', 'CANCEL_FIRST_INSTANCE_OBJECTIVE', DATE '2026-07-05', 'BA-HSPT-003', TRUE, TRUE, TRUE, 'Huy an do nguyen nhan khach quan.'),
    ('97400000-0000-0000-0003-000000000002', '97100000-0000-0000-0000-000000000003', '97300000-0000-0000-0003-000000000002', 'APPEAL', 'AT_HEARING', 'TRIAL', 'MODIFY_FIRST_INSTANCE_OBJECTIVE', DATE '2026-07-05', 'BA-HSPT-003', TRUE, TRUE, TRUE, 'Sua an do nguyen nhan khach quan.'),
    ('97400000-0000-0000-0004-000000000001', '97100000-0000-0000-0000-000000000004', '97300000-0000-0000-0004-000000000001', 'APPEAL', 'AT_HEARING', 'TERMINATION', 'OTHER_TERMINATION', DATE '2026-06-20', 'QD-HSPT-004', TRUE, TRUE, TRUE, 'Dinh chi khac tai phien toa.'),
    ('97400000-0000-0000-0005-000000000001', '97100000-0000-0000-0000-000000000005', '97300000-0000-0000-0005-000000000001', 'APPEAL', 'AT_HEARING', 'TRIAL', 'UPHOLD_FIRST_INSTANCE', DATE '2026-06-18', 'BA-HSPT-005', TRUE, TRUE, FALSE, 'Y an so tham.'),
    ('97400000-0000-0000-0005-000000000002', '97100000-0000-0000-0000-000000000005', '97300000-0000-0000-0005-000000000002', 'APPEAL', 'AT_HEARING', 'TRIAL', 'MODIFY_FIRST_INSTANCE_SUBJECTIVE', DATE '2026-06-18', 'BA-HSPT-005', TRUE, TRUE, FALSE, 'Sua an do nguyen nhan chu quan.')
ON CONFLICT (appellate_result_id) DO UPDATE SET
    appeal_protest_scope_code = EXCLUDED.appeal_protest_scope_code,
    decision_stage_code = EXCLUDED.decision_stage_code,
    result_group_code = EXCLUDED.result_group_code,
    result_type_code = EXCLUDED.result_type_code,
    result_date = EXCLUDED.result_date,
    decision_number = EXCLUDED.decision_number,
    is_final_result = EXCLUDED.is_final_result,
    counted_as_defendant_resolved = EXCLUDED.counted_as_defendant_resolved,
    counted_as_case_resolved = EXCLUDED.counted_as_case_resolved,
    note = EXCLUDED.note,
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO criminal_appellate_modify_criteria (id, appellate_result_id, criterion_code)
VALUES
    ('97500000-0000-0000-0002-000000000001', '97400000-0000-0000-0002-000000000004', 'REDUCE_PENALTY'),
    ('97500000-0000-0000-0002-000000000002', '97400000-0000-0000-0002-000000000004', 'SUSPENDED_SENTENCE_GRANTED'),
    ('97500000-0000-0000-0003-000000000001', '97400000-0000-0000-0003-000000000002', 'CHANGE_CHARGE'),
    ('97500000-0000-0000-0003-000000000002', '97400000-0000-0000-0003-000000000002', 'CHANGE_TO_LIGHTER_PENALTY'),
    ('97500000-0000-0000-0005-000000000001', '97400000-0000-0000-0005-000000000002', 'INCREASE_PENALTY'),
    ('97500000-0000-0000-0005-000000000002', '97400000-0000-0000-0005-000000000002', 'CHANGE_TO_HEAVIER_PENALTY')
ON CONFLICT (appellate_result_id, criterion_code) DO NOTHING;

UPDATE criminal_appellate_defendant_results r
SET decision_stage_id = dci.item_id,
    updated_at = CURRENT_TIMESTAMP
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'appellate_decision_stage'
  AND dci.item_code = r.decision_stage_code
  AND r.case_id IN (SELECT case_id FROM case_files WHERE case_code LIKE 'HSPT-%');

UPDATE criminal_appellate_defendant_results r
SET result_group_id = dci.item_id,
    updated_at = CURRENT_TIMESTAMP
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'appellate_defendant_result_group'
  AND dci.item_code = r.result_group_code
  AND r.case_id IN (SELECT case_id FROM case_files WHERE case_code LIKE 'HSPT-%');

UPDATE criminal_appellate_defendant_results r
SET result_type_id = dci.item_id,
    updated_at = CURRENT_TIMESTAMP
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'appellate_defendant_result_type'
  AND dci.item_code = r.result_type_code
  AND r.case_id IN (SELECT case_id FROM case_files WHERE case_code LIKE 'HSPT-%');

UPDATE criminal_appellate_modify_criteria mc
SET criterion_id = dci.item_id
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'appellate_modify_criterion'
  AND dci.item_code = mc.criterion_code
  AND mc.appellate_result_id IN (
      SELECT appellate_result_id
      FROM criminal_appellate_defendant_results
      WHERE case_id IN (SELECT case_id FROM case_files WHERE case_code LIKE 'HSPT-%')
  );
