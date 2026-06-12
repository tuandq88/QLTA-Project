-- Test: Excel appellate "Kết quả XXPT" must be imported and shown as result text.
-- Requires generated Excel seeds 030 and 033.

\set ON_ERROR_STOP on

DO $$
DECLARE
    v_excel_appellate_rows INTEGER;
    v_result_rows INTEGER;
    v_result_rows_with_date INTEGER;
    v_result_rows_without_date INTEGER;
    v_unmapped_result_rows INTEGER;
    v_period_result_rows INTEGER;
    v_period_result_without_date INTEGER;
    v_period_result_collapsed_to_unresolved INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_excel_appellate_rows
    FROM case_files
    WHERE case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
       OR case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%';

    IF v_excel_appellate_rows <> 1127 THEN
        RAISE EXCEPTION 'Expected 1127 Excel appellate rows, got %', v_excel_appellate_rows;
    END IF;

    WITH latest_decision AS (
        SELECT DISTINCT ON (d.case_id)
            d.case_id,
            d.decision_date,
            d.result_summary
        FROM decisions d
        WHERE NULLIF(d.result_summary, '') IS NOT NULL
        ORDER BY d.case_id, d.decision_date DESC NULLS LAST, d.decision_id
    ),
    app AS (
        SELECT cf.case_id, cf.case_code, cf.closed_date, ld.decision_date, ld.result_summary
        FROM case_files cf
        LEFT JOIN latest_decision ld ON ld.case_id = cf.case_id
        WHERE cf.case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
           OR cf.case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%'
    )
    SELECT
        COUNT(*) FILTER (WHERE NULLIF(result_summary, '') IS NOT NULL),
        COUNT(*) FILTER (WHERE NULLIF(result_summary, '') IS NOT NULL AND COALESCE(closed_date, decision_date) IS NOT NULL),
        COUNT(*) FILTER (WHERE NULLIF(result_summary, '') IS NOT NULL AND COALESCE(closed_date, decision_date) IS NULL)
    INTO v_result_rows, v_result_rows_with_date, v_result_rows_without_date
    FROM app;

    IF v_result_rows <> 843 THEN
        RAISE EXCEPTION 'Expected 843 Excel XXPT result rows mapped to decisions.result_summary, got %', v_result_rows;
    END IF;

    IF v_result_rows_with_date <> 840 THEN
        RAISE EXCEPTION 'Expected 840 Excel XXPT result rows with valid result/closed date, got %', v_result_rows_with_date;
    END IF;

    IF v_result_rows_without_date <> 3 THEN
        RAISE EXCEPTION 'Expected 3 Excel XXPT result rows without valid result date requiring warning, got %',
            v_result_rows_without_date;
    END IF;

    WITH excel_result_cases AS (
        SELECT cf.case_id
        FROM case_files cf
        JOIN decisions d ON d.case_id = cf.case_id
        WHERE (cf.case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
            OR cf.case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%')
          AND NULLIF(d.result_summary, '') IS NOT NULL
    )
    SELECT 843 - COUNT(DISTINCT case_id)
    INTO v_unmapped_result_rows
    FROM excel_result_cases;

    IF v_unmapped_result_rows <> 0 THEN
        RAISE EXCEPTION 'Excel XXPT result rows missing database mapping: %', v_unmapped_result_rows;
    END IF;

    WITH period_result_cases AS (
        SELECT
            cf.case_id,
            COALESCE(cf.closed_date, d.decision_date) AS resolution_date,
            d.result_summary
        FROM case_files cf
        JOIN LATERAL (
            SELECT d.decision_date, d.result_summary
            FROM decisions d
            WHERE d.case_id = cf.case_id
              AND NULLIF(d.result_summary, '') IS NOT NULL
            ORDER BY d.decision_date DESC NULLS LAST, d.decision_id
            LIMIT 1
        ) d ON TRUE
        WHERE (cf.case_code LIKE 'EXCEL-HINH_SU_PHUC_THAM-%'
            OR cf.case_code LIKE 'EXCEL-DAN_SU_MO_RONG_PHUC_THAM-%')
          AND cf.acceptance_date <= DATE '2026-06-12'
          AND (COALESCE(cf.closed_date, d.decision_date) IS NULL
            OR COALESCE(cf.closed_date, d.decision_date) >= DATE '2026-06-01')
    ),
    displayed AS (
        SELECT
            *,
            CASE
                WHEN NULLIF(result_summary, '') IS NOT NULL THEN result_summary
                WHEN resolution_date IS NULL OR resolution_date > DATE '2026-06-12' THEN 'Chưa giải quyết'
                ELSE NULL
            END AS resolution_result
        FROM period_result_cases
    )
    SELECT
        COUNT(*),
        COUNT(*) FILTER (WHERE resolution_date IS NULL),
        COUNT(*) FILTER (WHERE resolution_result = 'Chưa giải quyết')
    INTO v_period_result_rows, v_period_result_without_date, v_period_result_collapsed_to_unresolved
    FROM displayed;

    IF v_period_result_rows <> 7 THEN
        RAISE EXCEPTION 'Expected 7 period rows with imported XXPT result, got %', v_period_result_rows;
    END IF;

    IF v_period_result_without_date <> 3 THEN
        RAISE EXCEPTION 'Expected 3 period imported XXPT result rows without date warning, got %',
            v_period_result_without_date;
    END IF;

    IF v_period_result_collapsed_to_unresolved <> 0 THEN
        RAISE EXCEPTION 'Imported XXPT result rows must not be displayed as Chưa giải quyết: %',
            v_period_result_collapsed_to_unresolved;
    END IF;

    RAISE NOTICE 'Excel XXPT result import passed: result_rows=%, with_date=%, without_date_warning=%, period_result_rows=%',
        v_result_rows, v_result_rows_with_date, v_result_rows_without_date, v_period_result_rows;
END $$;
