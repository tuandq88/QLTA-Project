\set ON_ERROR_STOP on

-- Duplicate prevention test for migration 002.
-- Usage:
--   psql "$DATABASE_URL" -f database/schema/unified_postgresql_schema.sql
--   psql "$DATABASE_URL" -f database/migrations/002_database_constraints_and_indexes.sql
--   psql "$DATABASE_URL" -f tests/database/duplicate_prevention_test.sql

BEGIN;

DO $$
DECLARE
    v_court_id uuid;
    v_upper_court_id uuid;
    v_user_id uuid;
    v_case_id uuid;
    v_case_2_id uuid;
    v_assignment_id uuid;
    v_decision_id uuid;
    v_period_id uuid;
    v_metric_id uuid;
    v_tracking_id uuid;
    v_result_id uuid;
BEGIN
    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('TST-DUP-001', 'Toa an test cap tinh', 'province')
    RETURNING court_id INTO v_court_id;

    INSERT INTO courts (court_code, court_name, court_level)
    VALUES ('TST-DUP-002', 'Toa an test cap tren', 'upper')
    RETURNING court_id INTO v_upper_court_id;

    INSERT INTO users (full_name, role_code, email, court_id)
    VALUES ('Tham phan duplicate test', 'judge', 'judge_dup_test@example.local', v_court_id)
    RETURNING user_id INTO v_user_id;

    INSERT INTO case_files (case_code, case_number, case_type, case_status, court_id, acceptance_date)
    VALUES ('CASE-DUP-001', '01/2026/TLST-DS', 'civil', 'accepted', v_court_id, DATE '2026-01-10')
    RETURNING case_id INTO v_case_id;

    INSERT INTO case_files (case_code, case_number, case_type, case_status, court_id, acceptance_date)
    VALUES ('CASE-DUP-002', '02/2026/TLST-DS', 'civil', 'accepted', v_court_id, DATE '2026-01-11')
    RETURNING case_id INTO v_case_2_id;

    BEGIN
        INSERT INTO case_files (case_code, case_number, case_type, case_status, court_id, acceptance_date)
        VALUES ('CASE-DUP-001-B', '01/2026/TLST-DS', 'civil', 'accepted', v_court_id, DATE '2026-01-10');
        RAISE EXCEPTION 'Expected duplicate case number/type/court to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    INSERT INTO case_assignments (case_id, user_id, assignment_role, assignment_method, status, is_primary)
    VALUES (v_case_id, v_user_id, 'presiding_judge', 'RANDOM', 'active', TRUE)
    RETURNING assignment_id INTO v_assignment_id;

    BEGIN
        INSERT INTO case_assignments (case_id, user_id, assignment_role, assignment_method, status, is_primary)
        VALUES (v_case_id, v_user_id, 'presiding_judge', 'DESIGNATED', 'active', TRUE);
        RAISE EXCEPTION 'Expected duplicate active primary assignment to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    INSERT INTO decisions (case_id, decision_type, decision_number, decision_date)
    VALUES (v_case_id, 'judgment', '01/2026/DS-ST', DATE '2026-01-31')
    RETURNING decision_id INTO v_decision_id;

    INSERT INTO statistics_periods (period_type, start_date, end_date, report_year, report_month)
    VALUES ('month', DATE '2026-01-01', DATE '2026-01-31', 2026, 1)
    RETURNING period_id INTO v_period_id;

    INSERT INTO statistics_snapshots (
        period_id, court_id, case_id, statistic_form_code, metric_code,
        metric_name, metric_value, aggregation_level
    )
    VALUES (
        v_period_id, v_court_id, NULL, 'FORM-TEST', 'accepted_case_count',
        'So thu ly', 1, 'court'
    );

    BEGIN
        INSERT INTO statistics_snapshots (
            period_id, court_id, case_id, statistic_form_code, metric_code,
            metric_name, metric_value, aggregation_level
        )
        VALUES (
            v_period_id, v_court_id, NULL, 'FORM-TEST', 'accepted_case_count',
            'So thu ly lap', 2, 'court'
        );
        RAISE EXCEPTION 'Expected duplicate statistics snapshot to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    INSERT INTO kpi_metrics (metric_code, metric_name, metric_group, unit)
    VALUES ('KPI-DUP-001', 'KPI duplicate test', 'case_quality', 'count')
    RETURNING metric_id INTO v_metric_id;

    INSERT INTO kpi_values (metric_id, period_id, court_id, judge_id, actual_value)
    VALUES (v_metric_id, v_period_id, v_court_id, v_user_id, 1);

    BEGIN
        INSERT INTO kpi_values (metric_id, period_id, court_id, judge_id, actual_value)
        VALUES (v_metric_id, v_period_id, v_court_id, v_user_id, 2);
        RAISE EXCEPTION 'Expected duplicate KPI value to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    INSERT INTO appellate_trackings (
        original_case_id, original_decision_id, original_court_id, upper_court_id, case_type,
        appeal_protest_type, received_date, tracking_status
    )
    VALUES (v_case_id, v_decision_id, v_court_id, v_upper_court_id, 'civil', 'APPEAL', DATE '2026-02-01', 'received')
    RETURNING appellate_tracking_id INTO v_tracking_id;

    BEGIN
        INSERT INTO appellate_trackings (
            original_case_id, original_decision_id, original_court_id, upper_court_id, case_type,
            appeal_protest_type, received_date, tracking_status
        )
        VALUES (v_case_id, v_decision_id, v_court_id, v_upper_court_id, 'civil', 'APPEAL', DATE '2026-02-02', 'received');
        RAISE EXCEPTION 'Expected duplicate appellate tracking to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    BEGIN
        INSERT INTO appeal_protest_items (
            appellate_tracking_id, item_type, received_date, status
        )
        VALUES (v_tracking_id, 'BOTH', DATE '2026-02-01', 'received');
        RAISE EXCEPTION 'Expected BOTH appeal/protest item to fail';
    EXCEPTION WHEN check_violation THEN
        NULL;
    END;

    INSERT INTO appellate_results (
        appellate_tracking_id, result_code, result_name, result_date
    )
    VALUES (v_tracking_id, 'uphold', 'Giu nguyen', DATE '2026-03-01')
    RETURNING appellate_result_id INTO v_result_id;

    BEGIN
        INSERT INTO appellate_fault_assessments (
            appellate_result_id, fault_classification, responsible_judge_id
        )
        VALUES (v_result_id, 'subjective', v_user_id);
        RAISE EXCEPTION 'Expected subjective fault without reason to fail';
    EXCEPTION WHEN check_violation THEN
        NULL;
    END;

    INSERT INTO validation_results (
        case_id, rule_code, message, field_name, severity, validation_status
    )
    VALUES (v_case_id, 'RULE-DUP-001', 'Rule duplicate test', 'case_number', 'WARNING', 'open');

    BEGIN
        INSERT INTO validation_results (
            case_id, rule_code, message, field_name, severity, validation_status
        )
        VALUES (v_case_id, 'RULE-DUP-001', 'Rule duplicate test', 'case_number', 'WARNING', 'open');
        RAISE EXCEPTION 'Expected duplicate open validation result to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;

    INSERT INTO case_risk_flags (
        case_id, risk_type, severity, message, source_rule_code, status
    )
    VALUES (v_case_2_id, 'overdue_risk', 'WARNING', 'Risk duplicate test', 'RISK-DUP-001', 'open');

    BEGIN
        INSERT INTO case_risk_flags (
            case_id, risk_type, severity, message, source_rule_code, status
        )
        VALUES (v_case_2_id, 'overdue_risk', 'CRITICAL', 'Risk duplicate test 2', 'RISK-DUP-001', 'open');
        RAISE EXCEPTION 'Expected duplicate open risk flag to fail';
    EXCEPTION WHEN unique_violation THEN
        NULL;
    END;
END $$;

ROLLBACK;

SELECT 'duplicate_prevention_test passed' AS result;
