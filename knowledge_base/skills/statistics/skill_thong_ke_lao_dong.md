# SKILL: THỐNG KÊ ÁN LAO ĐỘNG HOÀN CHỈNH V1.0

## 1. Mục tiêu
Skill này dùng để xây dựng công thức, kiểm tra số liệu, ánh xạ dữ liệu đầu vào và sinh chỉ tiêu dashboard cho nhóm biểu mẫu thống kê án lao động trong hệ thống Tòa án. Skill kế thừa nguyên tắc chung của skill thống kê Tòa án và chuyên biệt hóa cho 04 thủ tục: sơ thẩm, phúc thẩm, giám đốc thẩm, tái thẩm.

## 2. Phạm vi biểu mẫu

- **LD_ST_5A** — Thống kê thụ lý và giải quyết các vụ, việc lao động sơ thẩm; sheet `LaoDong_SoTham`; mẫu `5A`; số cột: 38.
- **LD_PT_5B** — Thống kê thụ lý và giải quyết các vụ, việc lao động phúc thẩm; sheet `LaoDong_phuc_tham`; mẫu `5B`; số cột: 49.
- **LD_GDT** — Thống kê thụ lý và giải quyết các vụ, việc lao động giám đốc thẩm; sheet `LaoDong_GDT`; mẫu `theo file: 3C`; số cột: 30.
- **LD_TT** — Thống kê thụ lý và giải quyết các vụ, việc lao động tái thẩm; sheet `LaoDong_TaiTham`; mẫu `theo file: 6D`; số cột: 21.

## 3. Nguyên tắc thống kê chung
- Mọi dòng chỉ tiêu được thống kê theo loại vụ án/việc lao động.
- Cột tổng, cột còn lại, cột đã giải quyết, cột tỷ lệ là cột tính toán, không nhập tay nếu hệ thống có đủ dữ liệu nguồn.
- Các cột “trong đó” chỉ là phân tích chi tiết của cột tổng tương ứng, không cộng trùng vào tổng chính.
- Số quá hạn luật định phải phân loại nguyên nhân chủ quan hoặc khách quan; không vượt số còn lại.
- Số tạm đình chỉ lần 2/trên 2 lần/kiến nghị VBQPPL là phân tích của số tạm đình chỉ.
- Các chỉ tiêu về đặc điểm đương sự, áp dụng án lệ, rút gọn, biện pháp khẩn cấp tạm thời, VKS tham gia, luật sư tham gia là chỉ tiêu phân tích trên số đã giải quyết.

## 4. Data Dictionary lõi

### LABOR_CASE
- `case_id` (uuid): Mã định danh vụ, việc lao động
- `case_number` (string): Số thụ lý/số hồ sơ
- `case_subtype` (enum): Loại vụ án/việc lao động theo dòng chỉ tiêu của biểu mẫu
- `court_id` (string): Đơn vị Tòa án thụ lý/giải quyết
- `period_id` (string): Kỳ thống kê
- `procedure_level` (enum): Sơ thẩm, phúc thẩm, giám đốc thẩm, tái thẩm
- `acceptance_date` (date): Ngày thụ lý
- `status` (enum): Cũ còn lại, mới thụ lý, chuyển, nhập, đã giải quyết, còn lại
- `resolution_date` (date): Ngày giải quyết
- `resolution_result` (enum): Đình chỉ, công nhận thỏa thuận, xét xử/giải quyết, giữ nguyên, sửa, hủy...
- `is_overdue` (boolean): Quá hạn luật định
- `overdue_reason` (enum): Chủ quan hoặc khách quan
- `is_temporarily_suspended` (boolean): Tạm đình chỉ
- `temporary_suspension_count` (integer): Số lần tạm đình chỉ để xác định lần 2/trên 2 lần
- `chief_justice_normative_recommendation` (boolean): Có kiến nghị xem xét sửa đổi/bãi bỏ VBQPPL do dấu hiệu trái pháp luật
### LABOR_APPELLATE
- `appeal_flag` (boolean): Có kháng cáo
- `protest_flag` (boolean): Có kháng nghị
- `appeal_withdrawn` (boolean): Rút kháng cáo
- `protest_withdrawn` (boolean): Rút kháng nghị
- `first_instance_error` (boolean): Sửa/hủy do cấp sơ thẩm sai
- `appeal_trial_result` (enum): Giữ nguyên, sửa một phần, sửa toàn bộ, hủy một phần, hủy toàn bộ, hủy và đình chỉ, đình chỉ phúc thẩm
### LABOR_CASSATION_RETRIAL
- `protest_source` (enum): Chánh án hoặc Viện trưởng
- `protest_withdrawn` (boolean): Người kháng nghị rút kháng nghị
- `review_result` (enum): Không chấp nhận, sửa, hủy, giữ nguyên, xét xử lại...
- `reviewed_by_procedure` (enum): Giám đốc thẩm hoặc tái thẩm
### LABOR_PARTY_FEATURES
- `plaintiff_worker_under_15` (boolean): Nguyên đơn là người lao động dưới 15 tuổi
- `plaintiff_female_worker` (boolean): Nguyên đơn là lao động nữ
- `plaintiff_disabled_worker` (boolean): Nguyên đơn là lao động khuyết tật/tàn tật
- `plaintiff_foreign_factor` (boolean): Nguyên đơn có yếu tố nước ngoài
- `defendant_worker_under_15` (boolean): Bị đơn là người lao động dưới 15 tuổi
- `defendant_female_worker` (boolean): Bị đơn là lao động nữ
- `defendant_disabled_worker` (boolean): Bị đơn là lao động khuyết tật/tàn tật
- `defendant_foreign_factor` (boolean): Bị đơn có yếu tố nước ngoài
### PROCEDURAL_FEATURES
- `applied_precedent` (boolean): Áp dụng án lệ
- `summary_procedure` (boolean): Giải quyết theo thủ tục rút gọn
- `temporary_urgent_measure` (boolean): Áp dụng biện pháp khẩn cấp tạm thời
- `procuracy_participated` (boolean): Viện kiểm sát tham gia
- `lawyer_participated` (boolean): Có luật sư tham gia bảo vệ quyền lợi
- `other_representative_participated` (boolean): Có người bảo vệ quyền, lợi ích hợp pháp khác
- `experience_trial` (boolean): Tổ chức phiên tòa rút kinh nghiệm
- `successful_conciliation` (boolean): Tòa án tổ chức hòa giải thành công

## 5. Công thức nghiệp vụ chính

### LD_ST_001 — total_to_resolve
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C6 = C2 + C3 - C4 + C5`
- Cột liên quan: [6]
- Ý nghĩa: Tổng số vụ, việc lao động sơ thẩm phải giải quyết

### LD_ST_002 — trial_or_resolution_total
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C12 = C9 + C10 + C11`
- Cột liên quan: [12]
- Ý nghĩa: Tổng nhóm xét xử/giải quyết theo kết quả chấp nhận yêu cầu

### LD_ST_003 — resolved_total
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C13 = C7 + C8 + C12`
- Cột liên quan: [13]
- Ý nghĩa: Tổng số vụ, việc đã giải quyết

### LD_ST_004 — remaining_total
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C14 = C6 - C13`
- Cột liên quan: [14]
- Ý nghĩa: Tổng số vụ, việc còn lại

### LD_ST_007 — resolution_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C13 / C6 * 100`
- Cột liên quan: [6, 13]
- Ý nghĩa: Tỷ lệ giải quyết sơ thẩm

### LD_ST_008 — remaining_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C14 / C6 * 100`
- Cột liên quan: [6, 14]
- Ý nghĩa: Tỷ lệ tồn sơ thẩm

### LD_ST_009 — conciliation_success_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C38 / C13 * 100`
- Cột liên quan: [13, 38]
- Ý nghĩa: Tỷ lệ hòa giải thành công trong số đã giải quyết

### LD_ST_010 — recognition_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C8 / C13 * 100`
- Cột liên quan: [8, 13]
- Ý nghĩa: Tỷ lệ công nhận thỏa thuận

### LD_ST_011 — trial_resolution_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C12 / C13 * 100`
- Cột liên quan: [12, 13]
- Ý nghĩa: Tỷ lệ xét xử/giải quyết trong số đã giải quyết

### LD_ST_012 — partial_accept_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C10 / C12 * 100`
- Cột liên quan: [10, 12]
- Ý nghĩa: Tỷ lệ chấp nhận một phần yêu cầu trong nhóm xét xử/giải quyết

### LD_ST_013 — full_accept_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C11 / C12 * 100`
- Cột liên quan: [11, 12]
- Ý nghĩa: Tỷ lệ chấp nhận toàn bộ yêu cầu trong nhóm xét xử/giải quyết

### LD_ST_014 — reject_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C9 / C12 * 100`
- Cột liên quan: [9, 12]
- Ý nghĩa: Tỷ lệ không chấp nhận yêu cầu trong nhóm xét xử/giải quyết

### LD_ST_015 — procuracy_participation_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C25 / C13 * 100`
- Cột liên quan: [25, 13]
- Ý nghĩa: Tỷ lệ vụ việc có Viện kiểm sát tham gia

### LD_ST_016 — lawyer_participation_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `C27 / C13 * 100`
- Cột liên quan: [27, 13]
- Ý nghĩa: Tỷ lệ vụ việc có luật sư bảo vệ quyền lợi

### LD_ST_017 — foreign_factor_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `(C32 + C36) / C13 * 100`
- Cột liên quan: [32, 36, 13]
- Ý nghĩa: Tỷ lệ vụ việc có yếu tố nước ngoài theo đặc điểm nguyên đơn/bị đơn

### LD_ST_018 — female_worker_party_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `(C30 + C34) / C13 * 100`
- Cột liên quan: [30, 34, 13]
- Ý nghĩa: Tỷ lệ vụ việc có nguyên đơn/bị đơn là lao động nữ

### LD_ST_019 — minor_worker_party_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `(C29 + C33) / C13 * 100`
- Cột liên quan: [29, 33, 13]
- Ý nghĩa: Tỷ lệ vụ việc có nguyên đơn/bị đơn là người lao động dưới 15 tuổi

### LD_ST_020 — disability_worker_party_rate
- Biểu mẫu: `LD_ST_5A`
- Công thức: `(C31 + C35) / C13 * 100`
- Cột liên quan: [31, 35, 13]
- Ý nghĩa: Tỷ lệ vụ việc có nguyên đơn/bị đơn là người lao động khuyết tật/tàn tật

### LD_PT_001 — appeal_to_resolve
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C6 = C2 + C4`
- Cột liên quan: [6]
- Ý nghĩa: Tổng phải giải quyết theo kháng cáo

### LD_PT_002 — protest_to_resolve
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C7 = C3 + C5`
- Cột liên quan: [7]
- Ý nghĩa: Tổng phải giải quyết theo kháng nghị

### LD_PT_003 — total_to_resolve
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C8 = C6 + C7`
- Cột liên quan: [8]
- Ý nghĩa: Cộng phải giải quyết phúc thẩm

### LD_PT_004 — other_dismissal_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C13 = C9 + C10 + C11 + C12`
- Cột liên quan: [13]
- Ý nghĩa: Cộng đình chỉ phúc thẩm

### LD_PT_005 — trial_resolution_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C16 = C14 + C15`
- Cột liên quan: [16]
- Ý nghĩa: Cộng xét xử/giải quyết phúc thẩm

### LD_PT_006 — resolved_appeal
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C17 = C9 + C11 + C14`
- Cột liên quan: [17]
- Ý nghĩa: Đã giải quyết theo kháng cáo

### LD_PT_007 — resolved_protest
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C18 = C10 + C12 + C15`
- Cột liên quan: [18]
- Ý nghĩa: Đã giải quyết theo kháng nghị

### LD_PT_008 — resolved_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C19 = C17 + C18 = C13 + C16`
- Cột liên quan: [19]
- Ý nghĩa: Cộng đã giải quyết phúc thẩm

### LD_PT_009 — remaining_appeal
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C20 = C6 - C17`
- Cột liên quan: [20]
- Ý nghĩa: Còn lại theo kháng cáo

### LD_PT_010 — remaining_protest
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C21 = C7 - C18`
- Cột liên quan: [21]
- Ý nghĩa: Còn lại theo kháng nghị

### LD_PT_011 — remaining_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C22 = C20 + C21 = C8 - C19`
- Cột liên quan: [22]
- Ý nghĩa: Cộng còn lại phúc thẩm

### LD_PT_014 — modified_partial_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C30 + C31`
- Cột liên quan: [30, 31]
- Ý nghĩa: Tổng sửa một phần

### LD_PT_015 — modified_full_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C32 + C33`
- Cột liên quan: [32, 33]
- Ý nghĩa: Tổng sửa toàn bộ

### LD_PT_016 — cancel_partial_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C34 + C35`
- Cột liên quan: [34, 35]
- Ý nghĩa: Tổng hủy một phần để giải quyết lại

### LD_PT_017 — cancel_full_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C36 + C37`
- Cột liên quan: [36, 37]
- Ý nghĩa: Tổng hủy toàn bộ để giải quyết lại

### LD_PT_018 — cancel_and_dismiss_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C38 + C39`
- Cột liên quan: [38, 39]
- Ý nghĩa: Tổng hủy án và đình chỉ

### LD_PT_019 — trial_result_total
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C29 + C30 + C31 + C32 + C33 + C34 + C35 + C36 + C37 + C38 + C39 + C40`
- Cột liên quan: [29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40]
- Ý nghĩa: Tổng phân tích kết quả xét xử phúc thẩm

### LD_PT_021 — resolution_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C19 / C8 * 100`
- Cột liên quan: [19, 8]
- Ý nghĩa: Tỷ lệ giải quyết phúc thẩm

### LD_PT_022 — remaining_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C22 / C8 * 100`
- Cột liên quan: [22, 8]
- Ý nghĩa: Tỷ lệ tồn phúc thẩm

### LD_PT_023 — upheld_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C29 / C16 * 100`
- Cột liên quan: [29, 16]
- Ý nghĩa: Tỷ lệ giữ nguyên án sơ thẩm

### LD_PT_024 — modified_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `(C30+C31+C32+C33) / C16 * 100`
- Cột liên quan: [30, 31, 32, 33, 16]
- Ý nghĩa: Tỷ lệ sửa án

### LD_PT_025 — cancelled_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `(C34+C35+C36+C37+C38+C39) / C16 * 100`
- Cột liên quan: [34, 35, 36, 37, 38, 39, 16]
- Ý nghĩa: Tỷ lệ hủy án

### LD_PT_026 — first_instance_error_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `(C30+C32+C34+C36+C38) / C16 * 100`
- Cột liên quan: [30, 32, 34, 36, 38, 16]
- Ý nghĩa: Tỷ lệ sửa/hủy do cấp sơ thẩm sai

### LD_PT_027 — vks_rejected_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C41 / C15 * 100`
- Cột liên quan: [41, 15]
- Ý nghĩa: Tỷ lệ kháng nghị VKS không được chấp nhận

### LD_PT_028 — vks_withdraw_not_appeal_rate
- Biểu mẫu: `LD_PT_5B`
- Công thức: `C42 / C7 * 100`
- Cột liên quan: [42, 7]
- Ý nghĩa: Tỷ lệ VKS rút kháng nghị nhưng đương sự không rút kháng cáo

### LD_GDT_001 — chief_to_resolve
- Biểu mẫu: `LD_GDT`
- Công thức: `C6 = C2 + C4`
- Cột liên quan: [6]
- Ý nghĩa: Tổng phải giải quyết do Chánh án kháng nghị

### LD_GDT_002 — procurator_to_resolve
- Biểu mẫu: `LD_GDT`
- Công thức: `C7 = C3 + C5`
- Cột liên quan: [7]
- Ý nghĩa: Tổng phải giải quyết do Viện trưởng kháng nghị

### LD_GDT_003 — total_to_resolve
- Biểu mẫu: `LD_GDT`
- Công thức: `C8 = C6 + C7`
- Cột liên quan: [8]
- Ý nghĩa: Cộng phải giải quyết giám đốc thẩm

### LD_GDT_004 — resolved_total
- Biểu mẫu: `LD_GDT`
- Công thức: `C13 = C9 + C10 + C11 + C12`
- Cột liên quan: [13]
- Ý nghĩa: Tổng số đã giải quyết giám đốc thẩm

### LD_GDT_005 — remaining_chief
- Biểu mẫu: `LD_GDT`
- Công thức: `C14 = C6 - C9 - C11`
- Cột liên quan: [14]
- Ý nghĩa: Còn lại theo Chánh án kháng nghị

### LD_GDT_006 — remaining_procurator
- Biểu mẫu: `LD_GDT`
- Công thức: `C15 = C7 - C10 - C12`
- Cột liên quan: [15]
- Ý nghĩa: Còn lại theo Viện trưởng kháng nghị

### LD_GDT_007 — remaining_total
- Biểu mẫu: `LD_GDT`
- Công thức: `C16 = C14 + C15 = C8 - C13`
- Cột liên quan: [16]
- Ý nghĩa: Tổng số còn lại giám đốc thẩm

### LD_GDT_009 — not_accept_total
- Biểu mẫu: `LD_GDT`
- Công thức: `C19 + C20`
- Cột liên quan: [19, 20]
- Ý nghĩa: Tổng không chấp nhận kháng nghị

### LD_GDT_010 — trial_result_total
- Biểu mẫu: `LD_GDT`
- Công thức: `C19+C20+C21+C22+C23+C24+C25+C26+C27+C28+C29`
- Cột liên quan: [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
- Ý nghĩa: Tổng phân tích kết quả xét xử giám đốc thẩm

### LD_GDT_012 — resolution_rate
- Biểu mẫu: `LD_GDT`
- Công thức: `C13 / C8 * 100`
- Cột liên quan: [13, 8]
- Ý nghĩa: Tỷ lệ giải quyết giám đốc thẩm

### LD_GDT_013 — accept_protest_rate
- Biểu mẫu: `LD_GDT`
- Công thức: `(C21+C22+C23+C24+C25+C26+C27+C28+C29) / (C11+C12) * 100`
- Cột liên quan: [21, 22, 23, 24, 25, 26, 27, 28, 29, 11, 12]
- Ý nghĩa: Tỷ lệ chấp nhận kháng nghị

### LD_GDT_014 — not_accept_rate
- Biểu mẫu: `LD_GDT`
- Công thức: `(C19+C20) / (C11+C12) * 100`
- Cột liên quan: [19, 20, 11, 12]
- Ý nghĩa: Tỷ lệ không chấp nhận kháng nghị

### LD_GDT_015 — cancel_retrial_rate
- Biểu mẫu: `LD_GDT`
- Công thức: `(C28+C29) / (C11+C12) * 100`
- Cột liên quan: [28, 29, 11, 12]
- Ý nghĩa: Tỷ lệ hủy để xét xử lại sơ thẩm/phúc thẩm

### LD_TT_001 — chief_to_resolve
- Biểu mẫu: `LD_TT`
- Công thức: `C6 = C2 + C4`
- Cột liên quan: [6]
- Ý nghĩa: Tổng phải giải quyết do Chánh án kháng nghị tái thẩm

### LD_TT_002 — procurator_to_resolve
- Biểu mẫu: `LD_TT`
- Công thức: `C7 = C3 + C5`
- Cột liên quan: [7]
- Ý nghĩa: Tổng phải giải quyết do Viện trưởng kháng nghị tái thẩm

### LD_TT_003 — total_to_resolve
- Biểu mẫu: `LD_TT`
- Công thức: `C8 = C6 + C7`
- Cột liên quan: [8]
- Ý nghĩa: Cộng phải giải quyết tái thẩm

### LD_TT_004 — resolved_total
- Biểu mẫu: `LD_TT`
- Công thức: `C13 = C9 + C10 + C11 + C12`
- Cột liên quan: [13]
- Ý nghĩa: Tổng số đã giải quyết tái thẩm

### LD_TT_005 — remaining_chief
- Biểu mẫu: `LD_TT`
- Công thức: `C14 = C6 - C9 - C11`
- Cột liên quan: [14]
- Ý nghĩa: Còn lại theo Chánh án kháng nghị

### LD_TT_006 — remaining_procurator
- Biểu mẫu: `LD_TT`
- Công thức: `C15 = C7 - C10 - C12`
- Cột liên quan: [15]
- Ý nghĩa: Còn lại theo Viện trưởng kháng nghị

### LD_TT_007 — remaining_total
- Biểu mẫu: `LD_TT`
- Công thức: `C16 = C14 + C15 = C8 - C13`
- Cột liên quan: [16]
- Ý nghĩa: Tổng số còn lại tái thẩm

### LD_TT_008 — trial_result_total
- Biểu mẫu: `LD_TT`
- Công thức: `C17 + C18 + C19 + C20`
- Cột liên quan: [17, 18, 19, 20]
- Ý nghĩa: Tổng phân tích kết quả xét xử tái thẩm

### LD_TT_010 — resolution_rate
- Biểu mẫu: `LD_TT`
- Công thức: `C13 / C8 * 100`
- Cột liên quan: [13, 8]
- Ý nghĩa: Tỷ lệ giải quyết tái thẩm

### LD_TT_011 — not_accept_rate
- Biểu mẫu: `LD_TT`
- Công thức: `(C17 + C18) / (C11 + C12) * 100`
- Cột liên quan: [17, 18, 11, 12]
- Ý nghĩa: Tỷ lệ không chấp nhận kháng nghị tái thẩm

### LD_TT_012 — cancel_retrial_rate
- Biểu mẫu: `LD_TT`
- Công thức: `C19 / (C11 + C12) * 100`
- Cột liên quan: [19, 11, 12]
- Ý nghĩa: Tỷ lệ hủy để xét xử sơ thẩm lại

### LD_TT_013 — cancel_dismiss_rate
- Biểu mẫu: `LD_TT`
- Công thức: `C20 / (C11 + C12) * 100`
- Cột liên quan: [20, 11, 12]
- Ý nghĩa: Tỷ lệ hủy và đình chỉ

## 6. Quy tắc kiểm tra số liệu

- **RULE_LD_ST_005** (`LD_ST_5A`): `C15 + C16 <= C14` — Quá hạn luật định không vượt quá số còn lại
- **RULE_LD_ST_006** (`LD_ST_5A`): `C18 + C19 <= C17; C20 <= C17` — Các cột trong đó của tạm đình chỉ không vượt quá tổng tạm đình chỉ
- **RULE_LD_PT_012** (`LD_PT_5B`): `C23 + C24 <= C22` — Quá hạn không vượt quá còn lại
- **RULE_LD_PT_013** (`LD_PT_5B`): `C26 + C27 <= C25; C28 <= C25` — Chi tiết tạm đình chỉ không vượt tổng
- **RULE_LD_PT_020** (`LD_PT_5B`): `C29+C30+C31+C32+C33+C34+C35+C36+C37+C38+C39+C40 = C16` — Phân tích kết quả xét xử phải bằng số xét xử/giải quyết
- **RULE_LD_GDT_008** (`LD_GDT`): `C17 + C18 <= C16` — Quá hạn không vượt quá còn lại
- **RULE_LD_GDT_011** (`LD_GDT`): `C19+C20+C21+C22+C23+C24+C25+C26+C27+C28+C29 = C11+C12` — Phân tích xét xử bằng số đã xét xử
- **RULE_LD_TT_009** (`LD_TT`): `C17 + C18 + C19 + C20 = C11 + C12` — Phân tích xét xử bằng số đã xét xử
- **RULE_LD_NON_NEGATIVE_ALL** (`ALL`): `Mọi cột số lượng phải là số nguyên không âm; cột tỷ lệ/tiền tính theo kiểu số thực không âm` — Kiểm tra dữ liệu đầu vào cơ bản
- **RULE_LD_ST_TOTAL** (`LD_ST_5A`): `C6 = C2 + C3 - C4 + C5; C12 = C9+C10+C11; C13=C7+C8+C12; C14=C6-C13` — Bảo toàn số liệu sơ thẩm
- **RULE_LD_PT_TOTAL** (`LD_PT_5B`): `C6=C2+C4; C7=C3+C5; C8=C6+C7; C19=C17+C18; C22=C8-C19` — Bảo toàn số liệu phúc thẩm
- **RULE_LD_GDT_TOTAL** (`LD_GDT`): `C8=C6+C7; C13=C9+C10+C11+C12; C16=C8-C13` — Bảo toàn số liệu giám đốc thẩm
- **RULE_LD_TT_TOTAL** (`LD_TT`): `C8=C6+C7; C13=C9+C10+C11+C12; C16=C8-C13` — Bảo toàn số liệu tái thẩm
- **RULE_LD_DETAIL_NOT_EXCEED_RESOLVED** (`ALL`): `Các cột đặc điểm vụ việc đã giải quyết không được vượt Cột tổng đã giải quyết tương ứng` — Áp dụng án lệ, rút gọn, biện pháp khẩn cấp, VKS tham gia, luật sư...
- **RULE_LD_PT_APPEAL_PROTEST_PRIORITY** (`LD_PT_5B`): `Nếu cùng vụ việc vừa kháng cáo vừa kháng nghị thì ưu tiên thống kê theo nhóm kháng nghị khi quy định của biểu mẫu yêu cầu` — Quy tắc tránh cộng trùng phúc thẩm
- **RULE_LD_GDT_TT_PROTEST_SOURCE** (`LD_GDT,LD_TT`): `Mỗi hồ sơ giám đốc thẩm/tái thẩm phải xác định nguồn kháng nghị: Chánh án hoặc Viện trưởng` — Nguồn kháng nghị là trục tổng hợp chính

## 7. KPI dashboard lãnh đạo
- Tổng thụ lý/phải giải quyết theo cấp xét xử và đơn vị.
- Tổng đã giải quyết và tỷ lệ giải quyết.
- Án/vụ việc còn lại, tỷ lệ tồn, số quá hạn luật định.
- Tạm đình chỉ, tạm đình chỉ lần 2, tạm đình chỉ trên 2 lần.
- Hòa giải thành công, công nhận thỏa thuận, xét xử/giải quyết.
- Phúc thẩm: giữ nguyên, sửa, hủy; sửa/hủy do cấp sơ thẩm sai.
- Giám đốc thẩm/tái thẩm: tỷ lệ không chấp nhận/chấp nhận kháng nghị, hủy để xét xử lại.
- Đặc điểm đương sự: lao động nữ, dưới 15 tuổi, khuyết tật/tàn tật, yếu tố nước ngoài.

## 8. Gợi ý triển khai trong hệ thống
```pseudo
input: case_event, form_id, period_id, court_id
normalize case_event -> LABOR_CASE
map LABOR_CASE to columns by column_mapping_lao_dong.json
calculate formulas by formula_catalog_lao_dong.json
run validation_rules_lao_dong.json
export Excel/PDF/dashboard
```

## 9. Lưu ý về mẫu gốc
Trong 04 file Excel, mẫu giám đốc thẩm ghi là `Mẫu 3C` và mẫu tái thẩm ghi là `Mẫu 6D`. Skill vẫn đặt mã nghiệp vụ là `LD_GDT` và `LD_TT` để tránh phụ thuộc vào số mẫu có thể bị kế thừa/nhầm từ biểu mẫu khác; trường `template` vẫn lưu đúng nội dung hiển thị trong file.
