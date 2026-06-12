/*
  Liệt kê án sơ thẩm theo kỳ 01/06/2026 - 12/06/2026.

  Nguyên tắc:
  - Chỉ nhóm STT theo "Loại án", không tách dòng theo "Nhóm danh sách".
  - Mỗi case/occurrence xuất hiện 1 dòng; trạng thái thụ lý, giải quyết, còn lại hiển thị bằng cột cờ.
  - Ưu tiên case_occurrences/case_resolution_events; fallback về case_files khi hồ sơ chưa có occurrence/event.
  - File này không dùng psql meta-command, chạy trực tiếp được trong pgAdmin4.
*/

WITH params AS (
    SELECT
        DATE '2026-06-01' AS from_date,
        DATE '2026-06-12' AS to_date
),
case_type_lookup AS (
    SELECT dci.item_id, dci.item_code, dci.item_name
    FROM dm_category_items dci
),
case_group_lookup AS (
    SELECT dci.item_id, dci.item_code, dci.item_name
    FROM dm_category_items dci
),
resolution_type_lookup AS (
    SELECT dci.item_id, dci.item_code, dci.item_name
    FROM dm_category_items dci
),
first_instance_cases AS (
    SELECT
        cf.case_id,
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
        COALESCE(NULLIF(ct.item_name, ''), cf.case_type::text) AS case_type_display,
        COALESCE(NULLIF(cg.item_name, ''), NULLIF(cf.case_group, ''), 'SO_THAM') AS case_group_display
    FROM case_files cf
    LEFT JOIN case_type_lookup ct ON ct.item_id = cf.case_type_id
    LEFT JOIN case_group_lookup cg ON cg.item_id = cf.case_group_id
    WHERE cf.case_group = 'SO_THAM'
       OR cg.item_code = 'SO_THAM'
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
            FILTER (WHERE p.participant_type = 'defendant') AS respondents
    FROM participants p
    WHERE p.participant_type IN ('plaintiff', 'defendant')
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
        fic.case_id,
        CONCAT_WS(
            ' - ',
            pc.plaintiffs,
            pc.respondents,
            COALESCE(lrc.relationship_names, ccd.dispute_type)
        ) AS content_text
    FROM first_instance_cases fic
    LEFT JOIN participant_content pc ON pc.case_id = fic.case_id
    LEFT JOIN legal_relationship_content lrc ON lrc.case_id = fic.case_id
    LEFT JOIN civil_case_details ccd ON ccd.case_id = fic.case_id
),
case_content AS (
    SELECT
        fic.case_id,
        COALESCE(NULLIF(ccr.content_text, ''), NULLIF(cci.content_text, ''), NULLIF(fic.summary, ''), fic.case_code, fic.case_number) AS content_text
    FROM first_instance_cases fic
    LEFT JOIN criminal_content ccr ON ccr.case_id = fic.case_id
    LEFT JOIN civil_content cci ON cci.case_id = fic.case_id
),
stat_rows AS (
    SELECT
        fic.case_id,
        co.occurrence_id,
        co.acceptance_date,
        fre.event_date AS resolution_date,
        COALESCE(
            NULLIF(rt.item_name, ''),
            NULLIF(fre.resolution_type_code, ''),
            NULLIF(ld.result_summary, ''),
            NULLIF(fic.resolution_status, ''),
            'Đã giải quyết'
        ) AS resolved_result_text,
        COALESCE(NULLIF(fre.decision_number, ''), NULLIF(ld.decision_number, '')) AS resolution_number,
        (co.acceptance_date BETWEEN p.from_date AND p.to_date) AS is_accepted_in_period,
        (fre.event_date BETWEEN p.from_date AND p.to_date) AS is_resolved_in_period,
        (
            co.acceptance_date <= p.to_date
            AND (fre.event_date IS NULL OR fre.event_date > p.to_date)
        ) AS is_remaining_as_of_date
    FROM first_instance_cases fic
    JOIN case_occurrences co ON co.case_id = fic.case_id
    CROSS JOIN params p
    LEFT JOIN first_resolution_event fre ON fre.occurrence_id = co.occurrence_id
    LEFT JOIN resolution_type_lookup rt ON rt.item_id = fre.resolution_type_id
    LEFT JOIN latest_decision ld ON ld.case_id = fic.case_id

    UNION ALL

    SELECT
        fic.case_id,
        NULL::uuid AS occurrence_id,
        fic.acceptance_date,
        fic.closed_date AS resolution_date,
        COALESCE(
            NULLIF(ld.result_summary, ''),
            NULLIF(fic.resolution_status, ''),
            fic.case_status::text,
            'Đã giải quyết'
        ) AS resolved_result_text,
        NULLIF(ld.decision_number, '') AS resolution_number,
        (fic.acceptance_date BETWEEN p.from_date AND p.to_date) AS is_accepted_in_period,
        (fic.closed_date BETWEEN p.from_date AND p.to_date) AS is_resolved_in_period,
        (
            fic.acceptance_date <= p.to_date
            AND (fic.closed_date IS NULL OR fic.closed_date > p.to_date)
        ) AS is_remaining_as_of_date
    FROM first_instance_cases fic
    CROSS JOIN params p
    LEFT JOIN occurrence_counts oc ON oc.case_id = fic.case_id
    LEFT JOIN latest_decision ld ON ld.case_id = fic.case_id
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
            PARTITION BY fic.case_type_display
            ORDER BY fr.acceptance_date, fic.case_number, fic.case_code, fic.case_id, fr.occurrence_id
        ) AS stt,
        fic.case_type_display,
        CASE
            WHEN NULLIF(fic.case_number, '') IS NOT NULL AND fr.acceptance_date IS NOT NULL
                THEN fic.case_number || ' - ' || to_char(fr.acceptance_date, 'DD/MM/YYYY')
            WHEN NULLIF(fic.case_number, '') IS NOT NULL
                THEN fic.case_number
            WHEN fr.acceptance_date IS NOT NULL
                THEN to_char(fr.acceptance_date, 'DD/MM/YYYY')
            ELSE NULL
        END AS acceptance_number_date,
        cc.content_text,
        fic.case_group_display,
        hp.presiding_judges,
        hp.panel_members,
        hp.clerks,
        CASE WHEN fr.is_accepted_in_period IS TRUE THEN 'x' END AS accepted_flag,
        CASE WHEN fr.is_resolved_in_period IS TRUE THEN 'x' END AS resolved_flag,
        CASE WHEN fr.is_remaining_as_of_date IS TRUE THEN 'x' END AS remaining_flag,
        CASE
            WHEN fr.is_resolved_in_period IS TRUE THEN fr.resolved_result_text
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
        fr.resolution_date,
        fic.case_number,
        fic.case_code,
        fic.case_id,
        fr.occurrence_id
    FROM filtered_rows fr
    JOIN first_instance_cases fic ON fic.case_id = fr.case_id
    LEFT JOIN case_content cc ON cc.case_id = fr.case_id
    LEFT JOIN hearing_people hp ON hp.case_id = fr.case_id
)
SELECT
    stt AS "STT",
    case_type_display AS "Loại án",
    acceptance_number_date AS "Số/ngày thụ lý",
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
FROM final_rows
ORDER BY
    case_type_display,
    stt,
    acceptance_date NULLS LAST,
    case_number NULLS LAST,
    case_code NULLS LAST,
    case_id,
    occurrence_id NULLS LAST;
