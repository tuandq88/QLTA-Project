# SKILL: THỐNG KÊ ÁN HÀNH CHÍNH HOÀN CHỈNH V1.0

## 1. Mục tiêu
Skill này dùng để xây dựng công thức, kiểm tra số liệu, sinh báo cáo và dashboard cho nhóm án hành chính theo 04 biểu mẫu: sơ thẩm, phúc thẩm, giám đốc thẩm và tái thẩm. Skill kế thừa nguyên tắc chung của skill thống kê Tòa án: cột tổng/còn lại/đã giải quyết là cột công thức; dữ liệu vụ án là nguồn gốc; biểu mẫu là kết quả tổng hợp.

## 2. Phạm vi biểu mẫu

- **HC_ST_6A** — Mẫu 6A: Thống kê thụ lý và giải quyết các vụ án hành chính sơ thẩm (TAND cấp huyện và cấp tỉnh).
- **HC_PT_6B** — Mẫu 6B: Thống kê thụ lý và giải quyết các vụ án hành chính phúc thẩm (TAND cấp tỉnh và cấp cao).
- **HC_GDT_6C** — Mẫu 6C: Thống kê thụ lý và giải quyết các vụ án hành chính giám đốc thẩm (TAND cấp cao và TAND tối cao).
- **HC_TT_6D** — Mẫu 6D: Thống kê thụ lý và giải quyết các vụ án hành chính tái thẩm (TAND cấp cao và TAND tối cao).

## 3. Nguyên tắc nghiệp vụ chính
- Số phải giải quyết = cũ còn lại + mới thụ lý, có điều chỉnh chuyển hồ sơ/nhập vụ án nếu biểu mẫu có cột riêng.
- Số đã giải quyết = nhóm đình chỉ + nhóm xét xử/đã xét xử theo từng cấp thủ tục.
- Số còn lại = số phải giải quyết - số đã giải quyết.
- Chỉ tiêu “trong đó” không cộng lần nữa vào tổng nếu đã nằm trong cột cha.
- Quá hạn luật định chia theo nguyên nhân chủ quan/khách quan; tổng quá hạn không vượt số còn lại.
- Các chỉ tiêu về án lệ, thủ tục rút gọn, biện pháp khẩn cấp tạm thời, VKS tham gia, người bảo vệ quyền lợi là chỉ tiêu phân tích, không làm tăng tổng số vụ.

## 4. Cấu trúc dữ liệu lõi

### administrative_case
- `case_id` (uuid) — Mã duy nhất của vụ án hành chính
- `court_unit_id` (string) — Mã đơn vị Tòa án
- `report_period` (date_range) — Kỳ thống kê
- `procedure_level` (enum) — 
- `claim_type_code` (enum) — Loại khiếu kiện hành chính
- `old_remaining_flag` (boolean) — Vụ cũ còn lại từ kỳ trước
- `newly_accepted_date` (date) — Ngày thụ lý mới
- `transferred_out` (boolean) — Chuyển hồ sơ/vụ án
- `imported_case` (boolean) — Nhập vụ án
- `resolution_status` (enum) — 
- `overdue_reason` (enum) — 
- `temporary_suspension_count` (integer) — 
- `has_vbqppl_recommendation` (boolean) — 
- `uses_precedent` (boolean) — 
- `summary_procedure` (boolean) — 
- `interim_urgent_measure` (boolean) — 
- `procuracy_participated` (boolean) — 
- `foreign_element` (boolean) — 
- `compensation_case` (boolean) — 
- `compensation_amount_vnd` (currency) — 
- `trial_experience_session` (boolean) — 
### participant
- `participant_id` (uuid) — 
- `case_id` (uuid) — 
- `role` (enum) — 
- `party_type` (enum) — 
- `is_lawyer` (boolean) — 
- `is_other_representative` (boolean) — 
### appellate_review
- `review_id` (uuid) — 
- `case_id` (uuid) — 
- `review_level` (enum) — 
- `petition_source` (enum) — 
- `withdrawn` (boolean) — 
- `review_result` (enum) — 
- `error_by_lower_court` (boolean) — 

## 5. Công thức chuẩn


### HC_ST_6A — Mẫu 6A
- **HC_ST_001**: Tổng số phải giải quyết → `C6 = C2 + C3 - C4 + C5`
- **HC_ST_002**: Cộng đình chỉ → `C9 = C7 + C8`
- **HC_ST_003**: Cộng xét xử → `C13 = C10 + C11 + C12`
- **HC_ST_004**: Tổng số đã giải quyết → `C15 = C9 + C13`
- **HC_ST_005**: Tổng số còn lại → `C17 = C6 - C15`
- **HC_ST_KPI_001**: Tỷ lệ giải quyết → `resolution_rate = safe_div(C15, C6) * 100`
- **HC_ST_KPI_002**: Tỷ lệ tồn → `remaining_rate = safe_div(C17, C6) * 100`
- **HC_ST_KPI_003**: Tỷ lệ đối thoại → `dialogue_rate = safe_div(C16, C6) * 100`
- **HC_ST_KPI_004**: Tỷ lệ chấp nhận yêu cầu → `accepted_rate = safe_div(C11 + C12, C13) * 100`
- **HC_ST_KPI_005**: Tỷ lệ bác yêu cầu → `rejected_rate = safe_div(C10, C13) * 100`
- **HC_ST_KPI_006**: Tỷ lệ quá hạn → `overdue_rate = safe_div(C18 + C19, C17) * 100`
- **HC_ST_KPI_007**: Tỷ lệ tạm đình chỉ → `suspension_rate = safe_div(C20, C17) * 100`
- **HC_ST_KPI_008**: Tổng số tiền bồi thường → `compensation_amount = SUM(C30)`

### HC_PT_6B — Mẫu 6B
- **HC_PT_001**: Tổng kháng cáo phải giải quyết → `C6 = C2 + C4`
- **HC_PT_002**: Tổng kháng nghị phải giải quyết → `C7 = C3 + C5`
- **HC_PT_003**: Tổng số phải giải quyết → `C8 = C6 + C7`
- **HC_PT_004**: Đình chỉ lý do khác cộng → `C13 = C9 + C10 + C11 + C12`
- **HC_PT_005**: Xét xử cộng → `C16 = C14 + C15`
- **HC_PT_006**: Đã giải quyết kháng cáo → `C17 = C9 + C11 + C14`
- **HC_PT_007**: Đã giải quyết kháng nghị → `C18 = C10 + C12 + C15`
- **HC_PT_008**: Đã giải quyết cộng → `C19 = C17 + C18`
- **HC_PT_009**: Còn lại kháng cáo → `C20 = C6 - C17`
- **HC_PT_010**: Còn lại kháng nghị → `C21 = C7 - C18`
- **HC_PT_011**: Còn lại cộng → `C22 = C8 - C19`
- **HC_PT_KPI_001**: Tỷ lệ giải quyết phúc thẩm → `resolution_rate = safe_div(C19, C8) * 100`
- **HC_PT_KPI_002**: Tỷ lệ sửa án → `modified_rate = safe_div(C30 + C31 + C32 + C33, C16) * 100`
- **HC_PT_KPI_003**: Tỷ lệ hủy án → `cancelled_rate = safe_div(C34 + C35 + C36 + C37, C16) * 100`
- **HC_PT_KPI_004**: Tỷ lệ giữ nguyên → `upheld_rate = safe_div(C29, C16) * 100`
- **HC_PT_KPI_005**: Tỷ lệ hủy/sửa do cấp sơ thẩm sai → `first_instance_error_rate = safe_div(C30 + C32 + C34 + C36, C16) * 100`
- **HC_PT_KPI_006**: Tỷ lệ quá hạn → `overdue_rate = safe_div(C23 + C24, C22) * 100`

### HC_GDT_6C — Mẫu 6C
- **HC_GDT_001**: Tổng phải giải quyết - Chánh án kháng nghị → `C6 = C2 + C4`
- **HC_GDT_002**: Tổng phải giải quyết - Viện trưởng kháng nghị → `C7 = C3 + C5`
- **HC_GDT_003**: Tổng phải giải quyết - cộng → `C8 = C6 + C7`
- **HC_GDT_004**: Đình chỉ/rút kháng nghị cộng → `C11 = C9 + C10`
- **HC_GDT_005**: Đã xét xử cộng → `C14 = C12 + C13`
- **HC_GDT_006**: Đã giải quyết - Chánh án kháng nghị → `C15 = C9 + C12`
- **HC_GDT_007**: Đã giải quyết - Viện trưởng kháng nghị → `C16 = C10 + C13`
- **HC_GDT_008**: Đã giải quyết cộng → `C17 = C15 + C16`
- **HC_GDT_009**: Còn lại - Chánh án kháng nghị → `C18 = C6 - C15`
- **HC_GDT_010**: Còn lại - Viện trưởng kháng nghị → `C19 = C7 - C16`
- **HC_GDT_011**: Còn lại tổng số → `C20 = C8 - C17`
- **HC_GDT_KPI_001**: Tỷ lệ giải quyết giám đốc thẩm → `resolution_rate = safe_div(C17, C8) * 100`
- **HC_GDT_KPI_002**: Tỷ lệ không chấp nhận kháng nghị giám đốc thẩm → `not_accepted_rate = safe_div(C23 + C24, C14) * 100`
- **HC_GDT_KPI_003**: Tỷ lệ quá hạn giám đốc thẩm → `overdue_rate = safe_div(C21 + C22, C20) * 100`

### HC_TT_6D — Mẫu 6D
- **HC_TT_001**: Tổng phải giải quyết - Chánh án kháng nghị → `C6 = C2 + C4`
- **HC_TT_002**: Tổng phải giải quyết - Viện trưởng kháng nghị → `C7 = C3 + C5`
- **HC_TT_003**: Tổng phải giải quyết - cộng → `C8 = C6 + C7`
- **HC_TT_004**: Đình chỉ/rút kháng nghị cộng → `C11 = C9 + C10`
- **HC_TT_005**: Đã xét xử cộng → `C14 = C12 + C13`
- **HC_TT_006**: Đã giải quyết - Chánh án kháng nghị → `C15 = C9 + C12`
- **HC_TT_007**: Đã giải quyết - Viện trưởng kháng nghị → `C16 = C10 + C13`
- **HC_TT_008**: Đã giải quyết cộng → `C17 = C15 + C16`
- **HC_TT_009**: Còn lại - Chánh án kháng nghị → `C18 = C6 - C15`
- **HC_TT_010**: Còn lại - Viện trưởng kháng nghị → `C19 = C7 - C16`
- **HC_TT_011**: Còn lại tổng số → `C20 = C8 - C17`
- **HC_TT_KPI_001**: Tỷ lệ giải quyết tái thẩm → `resolution_rate = safe_div(C17, C8) * 100`
- **HC_TT_KPI_002**: Tỷ lệ không chấp nhận kháng nghị tái thẩm → `not_accepted_rate = safe_div(C23 + C24, C14) * 100`
- **HC_TT_KPI_003**: Tỷ lệ quá hạn tái thẩm → `overdue_rate = safe_div(C21 + C22, C20) * 100`

### HC_GDT_6C — Mẫu 6C
- **HC_GDT_KPI_004**: Tỷ lệ hủy/sửa theo giám đốc thẩm → `revision_rate = safe_div(C25+C26+C27+C28+C29+C30+C31+C32+C33, C14) * 100`

### HC_TT_6D — Mẫu 6D
- **HC_TT_KPI_004**: Tỷ lệ hủy án theo tái thẩm → `cancelled_retrial_rate = safe_div(C25+C26+C27+C28, C14) * 100`

### HC_GDT_6C — Mẫu 6C
- **HC_GDT_KPI_005**: Tỷ lệ áp dụng án lệ → `precedent_rate = safe_div(C34, C14) * 100`

### HC_TT_6D — Mẫu 6D
- **HC_TT_KPI_005**: Tỷ lệ áp dụng án lệ → `precedent_rate = safe_div(C29, C14) * 100`

## 6. Quy tắc kiểm tra số liệu

- **HC_ST_RULE_001** [error] C6 == C2 + C3 - C4 + C5 — Số phải giải quyết sơ thẩm phải bằng cũ còn lại + mới thụ lý - chuyển hồ sơ + nhập vụ án
- **HC_ST_RULE_002** [error] C9 == C7 + C8 — C9 == C7 + C8
- **HC_ST_RULE_003** [error] C13 == C10 + C11 + C12 — C13 == C10 + C11 + C12
- **HC_ST_RULE_004** [error] C15 == C9 + C13 — C15 == C9 + C13
- **HC_ST_RULE_005** [error] C17 == C6 - C15 — C17 == C6 - C15
- **HC_ST_RULE_006** [warning] C18 + C19 <= C17 — Quá hạn không được vượt số còn lại
- **HC_ST_RULE_007** [warning] C20 <= C17 — Tạm đình chỉ không được vượt số còn lại
- **HC_ST_RULE_008** [warning] C21 <= C20 and C22 <= C20 and C23 <= C20 — Các chỉ tiêu trong đó của tạm đình chỉ không vượt tổng tạm đình chỉ
- **HC_ST_RULE_009** [warning] C29 <= C13 — Số vụ có bồi thường không vượt số vụ xét xử
- **HC_ST_RULE_010** [warning] C31 + C32 <= C15 — Số vụ có người bảo vệ quyền lợi không vượt số vụ đã giải quyết
- **HC_ST_RULE_011** [info] C33 + C34 >= C15 or C33 + C34 == 0 — Đối chiếu phân loại người khởi kiện theo hồ sơ nhập
- **HC_ST_RULE_012** [info] C35 + C36 >= C15 or C35 + C36 == 0 — Đối chiếu phân loại người bị kiện theo hồ sơ nhập
- **HC_PT_RULE_001** [error] C6 == C2 + C4 — C6 == C2 + C4
- **HC_PT_RULE_002** [error] C7 == C3 + C5 — C7 == C3 + C5
- **HC_PT_RULE_003** [error] C8 == C6 + C7 — C8 == C6 + C7
- **HC_PT_RULE_004** [error] C13 == C9 + C10 + C11 + C12 — C13 == C9 + C10 + C11 + C12
- **HC_PT_RULE_005** [error] C16 == C14 + C15 — C16 == C14 + C15
- **HC_PT_RULE_006** [error] C19 == C17 + C18 — C19 == C17 + C18
- **HC_PT_RULE_007** [error] C22 == C8 - C19 — C22 == C8 - C19
- **HC_PT_RULE_008** [warning] C23 + C24 <= C22 — C23 + C24 <= C22
- **HC_PT_RULE_009** [error] all_numeric_columns_are_non_negative — all_numeric_columns_are_non_negative
- **HC_PT_RULE_010** [warning] detail_columns_do_not_exceed_parent_total — detail_columns_do_not_exceed_parent_total
- **HC_GDT_RULE_001** [error] C6 == C2 + C4 — C6 == C2 + C4
- **HC_GDT_RULE_002** [error] C7 == C3 + C5 — C7 == C3 + C5
- **HC_GDT_RULE_003** [error] C8 == C6 + C7 — C8 == C6 + C7
- **HC_GDT_RULE_004** [error] C11 == C9 + C10 — C11 == C9 + C10
- **HC_GDT_RULE_005** [error] C14 == C12 + C13 — C14 == C12 + C13
- **HC_GDT_RULE_006** [error] C17 == C15 + C16 — C17 == C15 + C16
- **HC_GDT_RULE_007** [error] C20 == C8 - C17 — C20 == C8 - C17
- **HC_GDT_RULE_008** [warning] C21 + C22 <= C20 — C21 + C22 <= C20
- **HC_GDT_RULE_009** [error] all_numeric_columns_are_non_negative — all_numeric_columns_are_non_negative
- **HC_GDT_RULE_010** [warning] detail_columns_do_not_exceed_parent_total — detail_columns_do_not_exceed_parent_total
- **HC_TT_RULE_001** [error] C6 == C2 + C4 — C6 == C2 + C4
- **HC_TT_RULE_002** [error] C7 == C3 + C5 — C7 == C3 + C5
- **HC_TT_RULE_003** [error] C8 == C6 + C7 — C8 == C6 + C7
- **HC_TT_RULE_004** [error] C11 == C9 + C10 — C11 == C9 + C10
- **HC_TT_RULE_005** [error] C14 == C12 + C13 — C14 == C12 + C13
- **HC_TT_RULE_006** [error] C17 == C15 + C16 — C17 == C15 + C16
- **HC_TT_RULE_007** [error] C20 == C8 - C17 — C20 == C8 - C17
- **HC_TT_RULE_008** [warning] C21 + C22 <= C20 — C21 + C22 <= C20
- **HC_TT_RULE_009** [error] all_numeric_columns_are_non_negative — all_numeric_columns_are_non_negative
- **HC_TT_RULE_010** [warning] detail_columns_do_not_exceed_parent_total — detail_columns_do_not_exceed_parent_total
- **HC_PT_RULE_011** [warning] C30 + C31 <= C16 and C32 + C33 <= C16 and C34 + C35 <= C16 and C36 + C37 <= C16 — Các nhóm sửa/hủy không vượt tổng số xét xử
- **HC_GDT_RULE_011** [warning] C23 + C24 + C25 + C26 + C27 + C28 + C29 + C30 + C31 + C32 + C33 == C14 — Tổng kết quả xét xử giám đốc thẩm nên khớp số đã xét xử
- **HC_TT_RULE_011** [warning] C23 + C24 + C25 + C26 + C27 + C28 == C14 — Tổng kết quả xét xử tái thẩm nên khớp số đã xét xử

## 7. KPI lãnh đạo
- Tỷ lệ giải quyết theo đơn vị, cấp xét xử, loại khiếu kiện.
- Tỷ lệ tồn và quá hạn luật định.
- Tỷ lệ tạm đình chỉ.
- Tỷ lệ bác yêu cầu, chấp nhận một phần, chấp nhận toàn bộ tại sơ thẩm.
- Tỷ lệ giữ nguyên, sửa, hủy ở phúc thẩm.
- Tỷ lệ kháng nghị không được chấp nhận ở giám đốc thẩm/tái thẩm.
- Số vụ áp dụng án lệ, rút gọn, biện pháp khẩn cấp tạm thời, có yếu tố nước ngoài.
- Chỉ tiêu bồi thường thiệt hại: số vụ và số tiền.


## 8. Hàm hỗ trợ khuyến nghị
```pseudo
safe_div(a, b):
    if b == 0: return 0
    return a / b

calc_row(form, row):
    apply formula_catalog[form]
    run validation_rules[form]
    return computed_row, warnings
```


## 9. Chuẩn triển khai
- Lưu số liệu ở mức vụ án, sau đó tổng hợp theo đơn vị/kỳ/loại khiếu kiện.
- Không nhập tay các cột công thức; nếu có hiệu chỉnh bắt buộc ghi nhật ký.
- Mọi cảnh báo không chặn xuất báo cáo cần phân loại `warning`; lỗi sai công thức hoặc số âm là `error`.
