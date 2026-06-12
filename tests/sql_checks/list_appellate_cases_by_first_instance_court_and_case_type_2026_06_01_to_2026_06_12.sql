/*
  Liệt kê án phúc thẩm theo kỳ 01/06/2026 - 12/06/2026.

  Nguyên tắc:
  - Chỉ lấy hồ sơ có cấp xét xử PHUC_THAM từ case_files.case_group hoặc case_group_id -> dm_category_items.item_code.
  - Sắp xếp và đánh STT theo Tòa án xét xử sơ thẩm + Loại án; không tách thêm theo "Nhóm danh sách".
  - Mỗi case/occurrence xuất hiện 1 dòng; thụ lý, giải quyết, còn lại hiển thị bằng cột cờ.
  - Tòa án sơ thẩm lấy từ case_files.first_instance_court_id.
    Nếu thiếu first_instance_court_id thì hiển thị "Chưa xác định" và gắn cảnh báo dữ liệu.
  - Với án hình sự phúc thẩm có criminal_appellate_defendant_results, kết quả vụ án được tổng hợp từ cấp bị cáo.
    Vụ án chỉ coi là giải quyết khi toàn bộ bị cáo có final result counted_as_defendant_resolved đến mốc thống kê.
  - File này không dùng psql meta-command, chạy trực tiếp được trong pgAdmin4.
*/

WITH params AS (
    SELECT
        DATE '2026-06-01' AS from_date,
        DATE '2026-06-12' AS to_date
),
category_lookup AS (
    SELECT dci.item_id, dci.item_code, dci.item_name
    FROM dm_category_items dci
),
appellate_cases AS (
    SELECT
        cf.case_id,
        cf.court_id,
        cf.case_code,
        cf.case_number,
        cf.case_type,
        cf.case_type_id,
        cf.case_group,
        cf.case_group_id,
        cf.acceptance_date,
        cf.closed_date,
        cf.resolution_status,
        cf.case_status,
        cf.summary,
        cf.first_instance_court_id,
        cf.first_instance_case_number,
        cf.first_instance_judgment_number,
        cf.first_instance_judgment_date,
        COALESCE(NULLIF(ct.item_name, ''), cf.case_type::text) AS case_type_display,
        COALESCE(NULLIF(cg.item_name, ''), NULLIF(cf.case_group, ''), 'PHUC_THAM') AS case_group_display
    FROM case_files cf
    LEFT JOIN category_lookup ct ON ct.item_id = cf.case_type_id
    LEFT JOIN category_lookup cg ON cg.item_id = cf.case_group_id
    WHERE cf.case_group = 'PHUC_THAM'
       OR cg.item_code = 'PHUC_THAM'
),
first_instance_court_lookup AS (
    SELECT
        ac.case_id,
        ac.first_instance_court_id,
        CASE
            WHEN ac.first_instance_court_id IS NULL THEN 'MISSING_FIRST_INSTANCE_COURT'
            ELSE NULL
        END AS first_instance_court_source,
        COALESCE(c.court_name, c.court_code, 'Chưa xác định') AS first_instance_court_display,
        CASE
            WHEN ac.first_instance_court_id IS NULL THEN 'MISSING_FIRST_INSTANCE_COURT'
            ELSE NULL
        END AS data_warning
    FROM appellate_cases ac
    LEFT JOIN courts c ON c.court_id = ac.first_instance_court_id
),
occurrence_counts AS (
    SELECT co.case_id, COUNT(*) AS occurrence_count
    FROM case_occurrences co
    GROUP BY co.case_id
),
latest_decision AS (
    SELECT DISTINCT ON (d.case_id)
        d.case_id,
        d.decision_number,
        d.decision_date,
        d.result_summary,
        d.result_code
    FROM decisions d
    ORDER BY d.case_id, d.decision_date DESC NULLS LAST, d.decision_id
),
first_resolution_event AS (
    SELECT DISTINCT ON (cre.occurrence_id)
        cre.case_id,
        cre.occurrence_id,
        cre.event_date,
        cre.resolution_type_code,
        cre.resolution_type_id,
        cre.decision_number,
        cre.resolution_event_id
    FROM case_resolution_events cre
    WHERE cre.counted_as_resolved IS TRUE
    ORDER BY cre.occurrence_id, cre.event_date, cre.resolution_event_id
),
hearing_people AS (
    SELECT
        chm.case_id,
        string_agg(cs.full_name, '; ' ORDER BY chm.member_order, cs.full_name)
            FILTER (WHERE chm.role_code = 'PRESIDING_JUDGE') AS presiding_judges,
        string_agg(cs.full_name, '; ' ORDER BY chm.member_order, cs.full_name)
            FILTER (WHERE chm.role_code = 'PANEL_JUDGE') AS panel_members,
        string_agg(cs.full_name, '; ' ORDER BY chm.member_order, cs.full_name)
            FILTER (WHERE chm.role_code = 'HEARING_CLERK') AS clerks
    FROM case_hearing_members chm
    JOIN court_staff cs ON cs.staff_id = chm.staff_id
    GROUP BY chm.case_id
),
criminal_defendant_counts AS (
    SELECT
        ccd.case_id,
        COUNT(d.defendant_id)::integer AS defendant_count
    FROM criminal_case_details ccd
    JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id
    GROUP BY ccd.case_id
),
criminal_appellate_result_summary AS (
    SELECT
        car.case_id,
        COUNT(DISTINCT car.defendant_id)::integer AS resolved_defendant_count,
        MAX(car.result_date) AS case_resolution_date,
        string_agg(DISTINCT car.decision_number, '; ' ORDER BY car.decision_number)
            FILTER (WHERE NULLIF(car.decision_number, '') IS NOT NULL) AS decision_numbers,
        string_agg(DISTINCT result_line.result_text, '; ' ORDER BY result_line.result_text) AS result_summary
    FROM (
        SELECT
            car.case_id,
            car.result_type_code,
            COUNT(*)::integer AS result_count,
            COALESCE(NULLIF(rt.item_name, ''), car.result_type_code) || ': ' || COUNT(*)::text || ' bị cáo' AS result_text
        FROM criminal_appellate_defendant_results car
        LEFT JOIN category_lookup rt ON rt.item_id = car.result_type_id
        WHERE car.is_final_result IS TRUE
          AND car.counted_as_defendant_resolved IS TRUE
        GROUP BY car.case_id, car.result_type_code, COALESCE(NULLIF(rt.item_name, ''), car.result_type_code)
    ) result_line
    JOIN criminal_appellate_defendant_results car
      ON car.case_id = result_line.case_id
     AND car.result_type_code = result_line.result_type_code
     AND car.is_final_result IS TRUE
     AND car.counted_as_defendant_resolved IS TRUE
    GROUP BY car.case_id
),
criminal_appellate_case_resolution AS (
    SELECT
        cdc.case_id,
        cdc.defendant_count,
        cars.resolved_defendant_count,
        CASE
            WHEN cdc.defendant_count > 0
             AND cars.resolved_defendant_count >= cdc.defendant_count
                THEN cars.case_resolution_date
            ELSE NULL::date
        END AS case_resolution_date,
        cars.result_summary,
        cars.decision_numbers
    FROM criminal_defendant_counts cdc
    JOIN criminal_appellate_result_summary cars ON cars.case_id = cdc.case_id
),
criminal_content AS (
    SELECT
        ccd.case_id,
        CONCAT_WS(
            ' - ',
            CASE
                WHEN first_defendant.full_name IS NULL THEN NULL
                WHEN defendant_count.defendant_count > 1 THEN first_defendant.full_name || ' và đồng phạm'
                ELSE first_defendant.full_name
            END,
            first_charge.crime_name
        ) AS content_text
    FROM criminal_case_details ccd
    LEFT JOIN LATERAL (
        SELECT d.full_name, d.defendant_id
        FROM defendants d
        WHERE d.criminal_detail_id = ccd.criminal_detail_id
        ORDER BY d.full_name, d.defendant_id
        LIMIT 1
    ) first_defendant ON TRUE
    LEFT JOIN LATERAL (
        SELECT COUNT(*)::integer AS defendant_count
        FROM defendants d
        WHERE d.criminal_detail_id = ccd.criminal_detail_id
    ) defendant_count ON TRUE
    LEFT JOIN LATERAL (
        SELECT ch.crime_name
        FROM defendants d
        JOIN charges ch ON ch.defendant_id = d.defendant_id
        WHERE d.criminal_detail_id = ccd.criminal_detail_id
        ORDER BY d.full_name, d.defendant_id, ch.charge_id
        LIMIT 1
    ) first_charge ON TRUE
),
participant_content AS (
    SELECT
        p.case_id,
        string_agg(COALESCE(NULLIF(p.full_name, ''), NULLIF(p.organization_name, '')), '; ' ORDER BY p.participant_id)
            FILTER (WHERE p.participant_type = 'plaintiff') AS plaintiffs,
        string_agg(COALESCE(NULLIF(p.full_name, ''), NULLIF(p.organization_name, '')), '; ' ORDER BY p.participant_id)
            FILTER (WHERE p.participant_type = 'defendant') AS respondents,
        string_agg(COALESCE(NULLIF(p.full_name, ''), NULLIF(p.organization_name, '')), '; ' ORDER BY p.participant_id)
            FILTER (WHERE p.participant_type = 'appellant') AS appellants
    FROM participants p
    WHERE p.participant_type IN ('plaintiff', 'defendant', 'appellant')
    GROUP BY p.case_id
),
legal_relationship_content AS (
    SELECT
        clr.case_id,
        string_agg(dlr.relationship_name, '; ' ORDER BY clr.is_primary DESC, dlr.sort_order, dlr.relationship_name) AS relationship_names
    FROM case_legal_relationships clr
    JOIN dm_legal_relationships dlr ON dlr.legal_relationship_id = clr.legal_relationship_id
    GROUP BY clr.case_id
),
civil_content AS (
    SELECT
        ac.case_id,
        CONCAT_WS(
            ' - ',
            COALESCE(pc.appellants, pc.plaintiffs),
            pc.respondents,
            COALESCE(lrc.relationship_names, ccd.dispute_type)
        ) AS content_text
    FROM appellate_cases ac
    LEFT JOIN participant_content pc ON pc.case_id = ac.case_id
    LEFT JOIN legal_relationship_content lrc ON lrc.case_id = ac.case_id
    LEFT JOIN civil_case_details ccd ON ccd.case_id = ac.case_id
),
case_content AS (
    SELECT
        ac.case_id,
        COALESCE(NULLIF(ccr.content_text, ''), NULLIF(cci.content_text, ''), NULLIF(ac.summary, ''), ac.case_code, ac.case_number) AS content_text,
        (NULLIF(ccr.content_text, '') IS NULL AND NULLIF(cci.content_text, '') IS NULL AND NULLIF(ac.summary, '') IS NOT NULL) AS used_summary_fallback
    FROM appellate_cases ac
    LEFT JOIN criminal_content ccr ON ccr.case_id = ac.case_id
    LEFT JOIN civil_content cci ON cci.case_id = ac.case_id
),
stat_rows AS (
    SELECT
        ac.case_id,
        co.occurrence_id,
        co.acceptance_date,
        CASE
            WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
            ELSE COALESCE(fre.event_date, ld.decision_date)
        END AS resolution_date,
        COALESCE(
            NULLIF(cacr.result_summary, ''),
            NULLIF(ld.result_summary, ''),
            NULLIF(ac.resolution_status, '')
        ) AS imported_result_text,
        COALESCE(
            NULLIF(cacr.result_summary, ''),
            NULLIF(rt.item_name, ''),
            NULLIF(fre.resolution_type_code, ''),
            NULLIF(ld.result_summary, ''),
            NULLIF(ac.resolution_status, ''),
            'Đã giải quyết'
        ) AS resolved_result_text,
        COALESCE(NULLIF(cacr.decision_numbers, ''), NULLIF(fre.decision_number, ''), NULLIF(ld.decision_number, '')) AS resolution_number,
        (co.acceptance_date BETWEEN p.from_date AND p.to_date) AS is_accepted_in_period,
        (
            CASE
                WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
                ELSE COALESCE(fre.event_date, ld.decision_date)
            END BETWEEN p.from_date AND p.to_date
        ) AS is_resolved_in_period,
        (
            co.acceptance_date <= p.to_date
            AND (
                CASE
                    WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
                    ELSE COALESCE(fre.event_date, ld.decision_date)
                END IS NULL
                OR CASE
                    WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
                    ELSE COALESCE(fre.event_date, ld.decision_date)
                END > p.to_date
            )
        ) AS is_remaining_as_of_date
    FROM appellate_cases ac
    JOIN case_occurrences co ON co.case_id = ac.case_id
    CROSS JOIN params p
    LEFT JOIN criminal_appellate_case_resolution cacr ON cacr.case_id = ac.case_id
    LEFT JOIN first_resolution_event fre ON fre.occurrence_id = co.occurrence_id
    LEFT JOIN category_lookup rt ON rt.item_id = fre.resolution_type_id
    LEFT JOIN latest_decision ld ON ld.case_id = ac.case_id

    UNION ALL

    SELECT
        ac.case_id,
        NULL::uuid AS occurrence_id,
        ac.acceptance_date,
        CASE
            WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
            ELSE COALESCE(ac.closed_date, ld.decision_date)
        END AS resolution_date,
        COALESCE(
            NULLIF(cacr.result_summary, ''),
            NULLIF(ld.result_summary, ''),
            NULLIF(ac.resolution_status, '')
        ) AS imported_result_text,
        COALESCE(
            NULLIF(cacr.result_summary, ''),
            NULLIF(ld.result_summary, ''),
            NULLIF(ac.resolution_status, ''),
            ac.case_status::text,
            'Đã giải quyết'
        ) AS resolved_result_text,
        COALESCE(NULLIF(cacr.decision_numbers, ''), NULLIF(ld.decision_number, '')) AS resolution_number,
        (ac.acceptance_date BETWEEN p.from_date AND p.to_date) AS is_accepted_in_period,
        (
            CASE
                WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
                ELSE COALESCE(ac.closed_date, ld.decision_date)
            END BETWEEN p.from_date AND p.to_date
        ) AS is_resolved_in_period,
        (
            ac.acceptance_date <= p.to_date
            AND (
                CASE
                    WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
                    ELSE COALESCE(ac.closed_date, ld.decision_date)
                END IS NULL
                OR CASE
                    WHEN cacr.case_id IS NOT NULL THEN cacr.case_resolution_date
                    ELSE COALESCE(ac.closed_date, ld.decision_date)
                END > p.to_date
            )
        ) AS is_remaining_as_of_date
    FROM appellate_cases ac
    CROSS JOIN params p
    LEFT JOIN occurrence_counts oc ON oc.case_id = ac.case_id
    LEFT JOIN criminal_appellate_case_resolution cacr ON cacr.case_id = ac.case_id
    LEFT JOIN latest_decision ld ON ld.case_id = ac.case_id
    WHERE COALESCE(oc.occurrence_count, 0) = 0
),
filtered_rows AS (
    SELECT sr.*
    FROM stat_rows sr
    WHERE sr.is_accepted_in_period IS TRUE
       OR sr.is_resolved_in_period IS TRUE
       OR sr.is_remaining_as_of_date IS TRUE
),
final_rows AS (
    SELECT
        row_number() OVER (
            PARTITION BY fic.first_instance_court_display, ac.case_type_display
            ORDER BY fr.acceptance_date, ac.case_number, ac.case_code, ac.case_id, fr.occurrence_id
        ) AS stt,
        fic.first_instance_court_display,
        ac.case_type_display,
        CASE
            WHEN NULLIF(ac.case_number, '') IS NOT NULL AND fr.acceptance_date IS NOT NULL
                THEN ac.case_number || ' - ' || to_char(fr.acceptance_date, 'DD/MM/YYYY')
            WHEN NULLIF(ac.case_number, '') IS NOT NULL
                THEN ac.case_number
            WHEN fr.acceptance_date IS NOT NULL
                THEN to_char(fr.acceptance_date, 'DD/MM/YYYY')
            ELSE NULL
        END AS acceptance_number_date,
        cc.content_text,
        ac.case_group_display,
        hp.presiding_judges,
        hp.panel_members,
        hp.clerks,
        CASE WHEN fr.is_accepted_in_period IS TRUE THEN 'x' END AS accepted_flag,
        CASE WHEN fr.is_resolved_in_period IS TRUE THEN 'x' END AS resolved_flag,
        CASE WHEN fr.is_remaining_as_of_date IS TRUE THEN 'x' END AS remaining_flag,
        CASE
            WHEN fr.is_resolved_in_period IS TRUE THEN fr.resolved_result_text
            WHEN NULLIF(fr.imported_result_text, '') IS NOT NULL THEN fr.imported_result_text
            WHEN fr.is_remaining_as_of_date IS TRUE THEN 'Chưa giải quyết'
            ELSE NULL
        END AS resolution_result,
        CASE
            WHEN fr.is_resolved_in_period IS TRUE AND NULLIF(fr.resolution_number, '') IS NOT NULL AND fr.resolution_date IS NOT NULL
                THEN fr.resolution_number || ' - ' || to_char(fr.resolution_date, 'DD/MM/YYYY')
            WHEN fr.is_resolved_in_period IS TRUE AND NULLIF(fr.resolution_number, '') IS NOT NULL
                THEN fr.resolution_number
            WHEN fr.is_resolved_in_period IS TRUE AND fr.resolution_date IS NOT NULL
                THEN to_char(fr.resolution_date, 'DD/MM/YYYY')
            ELSE NULL
        END AS resolution_number_date,
        fr.acceptance_date,
        ac.case_number,
        ac.case_code,
        ac.case_id,
        fr.occurrence_id,
        CONCAT_WS(
            ';',
            fic.data_warning,
            CASE
                WHEN NULLIF(fr.imported_result_text, '') IS NOT NULL
                 AND fr.resolution_date IS NULL
                    THEN 'XXPT_RESULT_WITHOUT_DATE'
            END
        ) AS data_warning
    FROM filtered_rows fr
    JOIN appellate_cases ac ON ac.case_id = fr.case_id
    JOIN first_instance_court_lookup fic ON fic.case_id = fr.case_id
    LEFT JOIN case_content cc ON cc.case_id = fr.case_id
    LEFT JOIN hearing_people hp ON hp.case_id = fr.case_id
)
SELECT
    stt AS "STT",
    first_instance_court_display AS "Tòa án xét xử sơ thẩm",
    case_type_display AS "Loại án",
    acceptance_number_date AS "Số/ngày thụ lý phúc thẩm",
    content_text AS "Nội dung vụ án",
    case_group_display AS "Cấp xét xử",
    presiding_judges AS "Thẩm phán chủ tọa",
    panel_members AS "Hội đồng",
    clerks AS "Thư ký",
    accepted_flag AS "Thụ lý trong kỳ",
    resolved_flag AS "Giải quyết trong kỳ",
    remaining_flag AS "Còn lại cuối kỳ",
    resolution_result AS "Kết quả giải quyết",
    resolution_number_date AS "Số/ngày giải quyết"
    ,data_warning AS "Cảnh báo dữ liệu"
FROM final_rows
ORDER BY
    first_instance_court_display,
    case_type_display,
    stt,
    acceptance_date NULLS LAST,
    case_number NULLS LAST,
    case_code NULLS LAST,
    case_id,
    occurrence_id NULLS LAST;
