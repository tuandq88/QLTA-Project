-- Test seed 040: deterministic criminal first-instance lifecycle data.
-- This file is for tests only. Do not include it in production seed bundles.

INSERT INTO courts (court_id, court_code, court_name, court_level, province, is_active)
VALUES (
    '90000000-0000-0000-0000-000000000001',
    'TEST_RETURN_QNG',
    'TAND test lifecycle tra ho so',
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
    (
        '91000000-0000-0000-0000-000000000001',
        '90000000-0000-0000-0000-000000000001',
        'HSST-RETURN-001',
        '01/2026/HSST-TEST',
        'criminal',
        'SO_THAM',
        'BLTTHS',
        DATE '2026-03-01',
        DATE '2026-03-10',
        'trial',
        'resolved',
        DATE '2026-06-20',
        'Test: tra VKS mot lan, thu ly lai ngay 2026-05-05, xet xu trong thang 6.'
    ),
    (
        '91000000-0000-0000-0000-000000000002',
        '90000000-0000-0000-0000-000000000001',
        'HSST-RETURN-002',
        '02/2026/HSST-TEST',
        'criminal',
        'SO_THAM',
        'BLTTHS',
        DATE '2026-01-10',
        DATE '2026-01-12',
        'trial',
        'resolved',
        DATE '2026-06-28',
        'Test: tra VKS hai lan, thu ly lai hai lan, xet xu trong thang 6.'
    ),
    (
        '91000000-0000-0000-0000-000000000003',
        '90000000-0000-0000-0000-000000000001',
        'HSST-RETURN-003',
        '03/2026/HSST-TEST',
        'criminal',
        'SO_THAM',
        'BLTTHS',
        DATE '2026-01-28',
        DATE '2026-02-01',
        'preparing',
        'preparing',
        NULL,
        'Test: tra VKS ba lan, thu ly lai lan bon nhung chua giai quyet.'
    ),
    (
        '91000000-0000-0000-0000-000000000004',
        '90000000-0000-0000-0000-000000000001',
        'HSST-RETURN-004',
        '04/2026/HSST-TEST',
        'criminal',
        'SO_THAM',
        'BLTTHS',
        DATE '2026-06-01',
        DATE '2026-06-05',
        'preparing',
        'resolved',
        DATE '2026-07-10',
        'Test: thu ly truoc ky A, tra VKS trong thang 7.'
    )
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
    ('92000000-0000-0000-0000-000000000001', '91000000-0000-0000-0000-000000000001', 'VKSND tinh Quang Ngai', 'CT-01/2026', DATE '2026-02-28', 'CQDT test', DATE '2026-03-01', 'HOI_DONG'),
    ('92000000-0000-0000-0000-000000000002', '91000000-0000-0000-0000-000000000002', 'VKSND tinh Quang Ngai', 'CT-02/2026', DATE '2026-01-10', 'CQDT test', DATE '2026-01-12', 'HOI_DONG'),
    ('92000000-0000-0000-0000-000000000003', '91000000-0000-0000-0000-000000000003', 'VKSND tinh Quang Ngai', 'CT-03/2026', DATE '2026-01-28', 'CQDT test', DATE '2026-02-01', 'HOI_DONG'),
    ('92000000-0000-0000-0000-000000000004', '91000000-0000-0000-0000-000000000004', 'VKSND tinh Quang Ngai', 'CT-04/2026', DATE '2026-06-01', 'CQDT test', DATE '2026-06-05', 'HOI_DONG')
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
    ('93000000-0000-0000-0000-000000000001', '92000000-0000-0000-0000-000000000001', 'Bi cao test 01', DATE '1990-01-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('93000000-0000-0000-0000-000000000002', '92000000-0000-0000-0000-000000000002', 'Bi cao test 02', DATE '1991-01-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('93000000-0000-0000-0000-000000000003', '92000000-0000-0000-0000-000000000003', 'Bi cao test 03', DATE '1992-01-01', 'female', 'Viet Nam', 'Quang Ngai', 'none', FALSE),
    ('93000000-0000-0000-0000-000000000004', '92000000-0000-0000-0000-000000000004', 'Bi cao test 04', DATE '1993-01-01', 'male', 'Viet Nam', 'Quang Ngai', 'none', FALSE)
ON CONFLICT (defendant_id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    date_of_birth = EXCLUDED.date_of_birth,
    gender = EXCLUDED.gender,
    nationality = EXCLUDED.nationality,
    residence = EXCLUDED.residence,
    criminal_record_status = EXCLUDED.criminal_record_status,
    is_detained = EXCLUDED.is_detained;

INSERT INTO charges (
    charge_id,
    defendant_id,
    crime_name,
    penal_code_article,
    clause_point,
    crime_severity,
    prosecution_decision,
    court_finding
)
VALUES
    ('94000000-0000-0000-0000-000000000001', '93000000-0000-0000-0000-000000000001', 'Toi test 01', 'Dieu test 001', 'Khoan 1', 'less_serious', 'Truy to test', NULL),
    ('94000000-0000-0000-0000-000000000002', '93000000-0000-0000-0000-000000000002', 'Toi test 02', 'Dieu test 002', 'Khoan 1', 'less_serious', 'Truy to test', NULL),
    ('94000000-0000-0000-0000-000000000003', '93000000-0000-0000-0000-000000000003', 'Toi test 03', 'Dieu test 003', 'Khoan 1', 'less_serious', 'Truy to test', NULL),
    ('94000000-0000-0000-0000-000000000004', '93000000-0000-0000-0000-000000000004', 'Toi test 04', 'Dieu test 004', 'Khoan 1', 'less_serious', 'Truy to test', NULL)
ON CONFLICT (charge_id) DO UPDATE SET
    crime_name = EXCLUDED.crime_name,
    penal_code_article = EXCLUDED.penal_code_article,
    clause_point = EXCLUDED.clause_point,
    crime_severity = EXCLUDED.crime_severity,
    prosecution_decision = EXCLUDED.prosecution_decision,
    court_finding = EXCLUDED.court_finding;

INSERT INTO case_occurrences (
    occurrence_id,
    case_id,
    occurrence_no,
    acceptance_date,
    acceptance_type_code,
    previous_occurrence_id,
    source_note
)
VALUES
    ('95000000-0000-0000-0001-000000000001', '91000000-0000-0000-0000-000000000001', 1, DATE '2026-03-10', 'INITIAL_ACCEPTANCE', NULL, 'HSST-RETURN-001 lan 1'),
    ('95000000-0000-0000-0001-000000000002', '91000000-0000-0000-0000-000000000001', 2, DATE '2026-05-05', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION', '95000000-0000-0000-0001-000000000001', 'HSST-RETURN-001 lan 2'),
    ('95000000-0000-0000-0002-000000000001', '91000000-0000-0000-0000-000000000002', 1, DATE '2026-01-12', 'INITIAL_ACCEPTANCE', NULL, 'HSST-RETURN-002 lan 1'),
    ('95000000-0000-0000-0002-000000000002', '91000000-0000-0000-0000-000000000002', 2, DATE '2026-03-05', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION', '95000000-0000-0000-0002-000000000001', 'HSST-RETURN-002 lan 2'),
    ('95000000-0000-0000-0002-000000000003', '91000000-0000-0000-0000-000000000002', 3, DATE '2026-05-20', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION', '95000000-0000-0000-0002-000000000002', 'HSST-RETURN-002 lan 3'),
    ('95000000-0000-0000-0003-000000000001', '91000000-0000-0000-0000-000000000003', 1, DATE '2026-02-01', 'INITIAL_ACCEPTANCE', NULL, 'HSST-RETURN-003 lan 1'),
    ('95000000-0000-0000-0003-000000000002', '91000000-0000-0000-0000-000000000003', 2, DATE '2026-03-15', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION', '95000000-0000-0000-0003-000000000001', 'HSST-RETURN-003 lan 2'),
    ('95000000-0000-0000-0003-000000000003', '91000000-0000-0000-0000-000000000003', 3, DATE '2026-04-22', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION', '95000000-0000-0000-0003-000000000002', 'HSST-RETURN-003 lan 3'),
    ('95000000-0000-0000-0003-000000000004', '91000000-0000-0000-0000-000000000003', 4, DATE '2026-06-12', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION', '95000000-0000-0000-0003-000000000003', 'HSST-RETURN-003 lan 4 chua giai quyet'),
    ('95000000-0000-0000-0004-000000000001', '91000000-0000-0000-0000-000000000004', 1, DATE '2026-06-05', 'INITIAL_ACCEPTANCE', NULL, 'HSST-RETURN-004 lan 1')
ON CONFLICT (case_id, occurrence_no) DO UPDATE SET
    acceptance_date = EXCLUDED.acceptance_date,
    acceptance_type_code = EXCLUDED.acceptance_type_code,
    previous_occurrence_id = EXCLUDED.previous_occurrence_id,
    source_note = EXCLUDED.source_note,
    updated_at = CURRENT_TIMESTAMP;

UPDATE case_occurrences co
SET acceptance_type_id = dci.item_id,
    updated_at = CURRENT_TIMESTAMP
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'acceptance_type'
  AND dci.item_code = co.acceptance_type_code
  AND co.case_id IN (
      SELECT case_id
      FROM case_files
      WHERE case_code LIKE 'HSST-RETURN-%'
  );

INSERT INTO case_resolution_events (
    resolution_event_id,
    case_id,
    occurrence_id,
    event_type_code,
    event_date,
    resolution_type_code,
    return_to_agency_code,
    decision_number,
    counted_as_resolved,
    reason
)
VALUES
    ('96000000-0000-0000-0001-000000000001', '91000000-0000-0000-0000-000000000001', '95000000-0000-0000-0001-000000000001', 'RESOLUTION', DATE '2026-04-15', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-001-1', TRUE, 'Can dieu tra bo sung'),
    ('96000000-0000-0000-0001-000000000002', '91000000-0000-0000-0000-000000000001', '95000000-0000-0000-0001-000000000002', 'RESOLUTION', DATE '2026-06-20', 'TRIAL_JUDGMENT', NULL, 'BA-001-2', TRUE, 'Xet xu so tham'),
    ('96000000-0000-0000-0002-000000000001', '91000000-0000-0000-0000-000000000002', '95000000-0000-0000-0002-000000000001', 'RESOLUTION', DATE '2026-02-10', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-002-1', TRUE, 'Can dieu tra bo sung lan 1'),
    ('96000000-0000-0000-0002-000000000002', '91000000-0000-0000-0000-000000000002', '95000000-0000-0000-0002-000000000002', 'RESOLUTION', DATE '2026-04-25', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-002-2', TRUE, 'Can dieu tra bo sung lan 2'),
    ('96000000-0000-0000-0002-000000000003', '91000000-0000-0000-0000-000000000002', '95000000-0000-0000-0002-000000000003', 'RESOLUTION', DATE '2026-06-28', 'TRIAL_JUDGMENT', NULL, 'BA-002-3', TRUE, 'Xet xu so tham'),
    ('96000000-0000-0000-0003-000000000001', '91000000-0000-0000-0000-000000000003', '95000000-0000-0000-0003-000000000001', 'RESOLUTION', DATE '2026-02-25', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-003-1', TRUE, 'Can dieu tra bo sung lan 1'),
    ('96000000-0000-0000-0003-000000000002', '91000000-0000-0000-0000-000000000003', '95000000-0000-0000-0003-000000000002', 'RESOLUTION', DATE '2026-04-05', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-003-2', TRUE, 'Can dieu tra bo sung lan 2'),
    ('96000000-0000-0000-0003-000000000003', '91000000-0000-0000-0000-000000000003', '95000000-0000-0000-0003-000000000003', 'RESOLUTION', DATE '2026-05-30', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-003-3', TRUE, 'Can dieu tra bo sung lan 3'),
    ('96000000-0000-0000-0004-000000000001', '91000000-0000-0000-0000-000000000004', '95000000-0000-0000-0004-000000000001', 'RESOLUTION', DATE '2026-07-10', 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION', 'PROCURACY', 'QDT-004-1', TRUE, 'Tra VKS trong thang 7')
ON CONFLICT (resolution_event_id) DO UPDATE SET
    event_type_code = EXCLUDED.event_type_code,
    event_date = EXCLUDED.event_date,
    resolution_type_code = EXCLUDED.resolution_type_code,
    return_to_agency_code = EXCLUDED.return_to_agency_code,
    decision_number = EXCLUDED.decision_number,
    counted_as_resolved = EXCLUDED.counted_as_resolved,
    reason = EXCLUDED.reason,
    updated_at = CURRENT_TIMESTAMP;

UPDATE case_resolution_events re
SET resolution_type_id = dci.item_id,
    updated_at = CURRENT_TIMESTAMP
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'resolution_type'
  AND dci.item_code = re.resolution_type_code
  AND re.case_id IN (
      SELECT case_id
      FROM case_files
      WHERE case_code LIKE 'HSST-RETURN-%'
  );

UPDATE case_resolution_events re
SET return_to_agency_id = dci.item_id,
    updated_at = CURRENT_TIMESTAMP
FROM dm_category_items dci
JOIN dm_categories dc ON dc.category_id = dci.category_id
WHERE dc.category_code = 'return_to_agency'
  AND dci.item_code = re.return_to_agency_code
  AND re.case_id IN (
      SELECT case_id
      FROM case_files
      WHERE case_code LIKE 'HSST-RETURN-%'
  );
