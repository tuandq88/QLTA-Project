---
name: criminal_statistics_specialist
description: Skill riêng cho loại án hình sự, dùng để phân tích biểu mẫu 1A, 1B, 1C, 1D; sinh công thức thống kê, kiểm tra đối chiếu số liệu và hỗ trợ tạo dashboard điều hành cho hệ thống quản lý Tòa án.
version: 1.0
domain: judicial_statistics
---

# Skill: Thống kê án hình sự

## 1. Mục đích
Skill này dùng riêng cho thống kê án hình sự trong hệ thống Tòa án. Skill hỗ trợ: phân tích biểu mẫu hình sự, xác định dữ liệu đầu vào, sinh công thức tính toán, kiểm tra tính hợp lệ, tạo báo cáo đối chiếu và đề xuất KPI/dashboard cho lãnh đạo.

## 2. Phạm vi biểu mẫu

- **HS_ST_1A**: Hình sự sơ thẩm do cá nhân phạm tội (Mẫu 1A)
- **HS_PT_1B**: Hình sự phúc thẩm do cá nhân phạm tội (Mẫu 1B)
- **HS_GDT_1C**: Hình sự giám đốc thẩm do cá nhân phạm tội (Mẫu 1C)
- **HS_TT_1D**: Hình sự tái thẩm do cá nhân phạm tội (Mẫu 1D)

## 3. Nguyên tắc nghiệp vụ bắt buộc
- Không suy đoán công thức ngoài hướng dẫn hoặc catalog.
- Cột tổng, cột còn lại, cột đã giải quyết phải tính bằng công thức, hạn chế nhập thủ công.
- Các cột “trong đó” là phân tích chi tiết, không cộng trùng vào tổng.
- Trường hợp vụ án vừa có kháng cáo vừa có kháng nghị ở phúc thẩm thì ưu tiên thống kê vào nhóm kháng nghị.
- Với sơ thẩm, nếu Tòa án xét xử theo tội danh khác với truy tố thì thống kê theo tội danh Tòa án đã xét xử.
- Số lượng vụ án/bị cáo phải là số nguyên không âm; tài sản, thiệt hại tính bằng VNĐ.

## 4. Thực thể dữ liệu lõi
### CASE
`case_id`, `case_number`, `court_code`, `court_level`, `procedure_stage`, `form_code`, `crime_code`, `crime_name`, `article`, `clause`, `acceptance_date`, `status`, `is_overdue`, `overdue_reason`, `is_suspended`, `is_restored`, `has_precedent`, `is_experience_trial`

### DEFENDANT
`defendant_id`, `case_id`, `gender`, `birth_date`, `age_group`, `ethnicity`, `nationality`, `occupation`, `is_party_member`, `is_civil_servant`, `is_drug_addict`, `is_recidivist`, `is_foreigner`, `trial_result`, `sentence_type`, `sentence_years`, `additional_penalty`

### APPEAL_OR_PROTEST
`appeal_id`, `case_id`, `type`, `source`, `is_withdrawn`, `withdrawn_date`, `appellate_result`

### REVIEW_RESULT
`review_id`, `case_id`, `procedure_stage`, `protest_source`, `is_accepted`, `review_result_type`

## 5. Công thức chuẩn theo biểu mẫu

### HS_ST_1A — Hình sự sơ thẩm do cá nhân phạm tội (Mẫu 1A)

- **1A_C9** (Tổng số vụ án phải giải quyết): `C9 = C3 + C5 - C7`
- **1A_C10** (Tổng số bị cáo phải giải quyết): `C10 = C4 + C6 - C8`
- **1A_C37** (Tổng số vụ án đã giải quyết): `C37 = C11 + C13 + C16`
- **1A_C38** (Tổng số bị cáo đã giải quyết): `C38 = C12 + C14 + C17`
- **1A_C39** (Tổng số vụ án còn lại): `C39 = C9 - C37`
- **1A_C40** (Tổng số bị cáo còn lại): `C40 = C10 - C38`
- **1A_RULE_SENTENCE** (Đối chiếu bị cáo đã xét xử với hình phạt chính): `SUM(C48:C61) = C17`

### HS_PT_1B — Hình sự phúc thẩm do cá nhân phạm tội (Mẫu 1B)

- **1B_C11** (Tổng số vụ án bị kháng nghị phải giải quyết): `C11 = C3 + C7`
- **1B_C12** (Tổng số bị cáo bị kháng nghị phải giải quyết): `C12 = C4 + C8`
- **1B_C13** (Tổng số vụ án bị kháng cáo phải giải quyết): `C13 = C5 + C9`
- **1B_C14** (Tổng số bị cáo bị kháng cáo phải giải quyết): `C14 = C6 + C10`
- **1B_C28** (Tổng số vụ án đã giải quyết): `C28 = C16 + C18 + C20 + C22 + C24 + C26`
- **1B_C29** (Tổng số bị cáo đã giải quyết): `C29 = C17 + C19 + C21 + C23 + C25 + C27`
- **1B_C30** (Số vụ án có kháng nghị còn lại): `C30 = C11 - (C16 + C20 + C24)`
- **1B_C31** (Số bị cáo có kháng nghị còn lại): `C31 = C12 - (C17 + C21 + C25)`
- **1B_C32** (Số vụ án có kháng cáo còn lại): `C32 = C13 - (C18 + C22 + C26)`
- **1B_C33** (Số bị cáo có kháng cáo còn lại): `C33 = C14 - (C19 + C23 + C27)`
- **1B_C34** (Tổng số vụ án còn lại): `C34 = C30 + C32`
- **1B_C35** (Tổng số bị cáo còn lại): `C35 = C31 + C33`

### HS_GDT_1C — Hình sự giám đốc thẩm do cá nhân phạm tội (Mẫu 1C)

- **1C_C11** (Tổng số vụ án phải giải quyết): `C11 = C3 + C5 + C7 + C9`
- **1C_C12** (Tổng số bị cáo phải giải quyết): `C12 = C4 + C6 + C8 + C10`
- **1C_C21** (Tổng số vụ án đã giải quyết): `C21 = C13 + C15 + C17 + C19`
- **1C_C22** (Tổng số bị cáo đã giải quyết): `C22 = C14 + C16 + C18 + C20`
- **1C_C23** (Vụ án còn lại do Chánh án kháng nghị): `C23 = C3 + C7 - C13 - C17`
- **1C_C24** (Bị cáo còn lại do Chánh án kháng nghị): `C24 = C4 + C8 - C14 - C18`
- **1C_C25** (Vụ án còn lại do Viện trưởng kháng nghị): `C25 = C5 + C9 - C15 - C19`
- **1C_C26** (Bị cáo còn lại do Viện trưởng kháng nghị): `C26 = C6 + C10 - C16 - C20`
- **1C_C27** (Tổng số vụ án còn lại): `C27 = C23 + C25`
- **1C_C28** (Tổng số bị cáo còn lại): `C28 = C24 + C26`

### HS_TT_1D — Hình sự tái thẩm do cá nhân phạm tội (Mẫu 1D)

- **1D_C7** (Tổng số vụ án phải giải quyết): `C7 = C3 + C5`
- **1D_C8** (Tổng số bị cáo phải giải quyết): `C8 = C4 + C6`
- **1D_C13** (Tổng số vụ án đã giải quyết): `C13 = C9 + C11`
- **1D_C14** (Tổng số bị cáo đã giải quyết): `C14 = C10 + C12`
- **1D_C15** (Số vụ án còn lại): `C15 = C7 - C13`
- **1D_C16** (Số bị cáo còn lại): `C16 = C8 - C14`

## 6. KPI gợi ý cho dashboard

- **KPI_RESOLUTION_RATE**: Tỷ lệ giải quyết = `resolved_case / total_case * 100`
- **KPI_PENDING_RATE**: Tỷ lệ án tồn = `remaining_case / total_case * 100`
- **KPI_OVERDUE_RATE**: Tỷ lệ án quá hạn = `overdue_case / remaining_case * 100`
- **KPI_RETURN_RATE**: Tỷ lệ trả hồ sơ điều tra bổ sung = `returned_case / resolved_case * 100`
- **KPI_APPEAL_RATE**: Tỷ lệ kháng cáo = `appeal_case / first_instance_resolved_case * 100`
- **KPI_PROTEST_RATE**: Tỷ lệ kháng nghị = `protest_case / first_instance_resolved_case * 100`
- **KPI_MODIFIED_RATE**: Tỷ lệ sửa án = `modified_case / appellate_tried_case * 100`
- **KPI_CANCELLED_RATE**: Tỷ lệ hủy án = `cancelled_case / appellate_tried_case * 100`

## 7. Validation rules

- **VAL_NON_NEGATIVE** [error]: Mọi cột số lượng vụ án, bị cáo phải là số nguyên không âm.
- **VAL_BALANCE_CASE** [error]: total_case = resolved_case + remaining_case, áp dụng cho các mẫu có cột tổng, đã giải quyết, còn lại.
- **VAL_BALANCE_DEFENDANT** [error]: total_defendant = resolved_defendant + remaining_defendant, áp dụng cho các mẫu có cột tổng, đã giải quyết, còn lại.
- **VAL_WITHIN_TOTAL** [warning]: Các cột “trong đó” không được vượt quá cột tổng tương ứng.
- **VAL_1A_MAIN_PENALTY** [error]: Mẫu 1A: tổng số bị cáo tại C48:C61 phải bằng số bị cáo đã xét xử tại C17; C62 chỉ theo dõi, không cộng vào tổng.
- **VAL_OVERDUE_REMAINING** [error]: Số vụ quá hạn không được lớn hơn số vụ còn lại.
- **VAL_APPEAL_PROTEST_PRIORITY** [warning]: Mẫu 1B: vụ án vừa có kháng cáo vừa có kháng nghị thì thống kê vào nhóm kháng nghị.

## 7.1. Danh sách trả hồ sơ điều tra bổ sung

Khi cần list chi tiết vụ án hình sự sơ thẩm mà Tòa án trả hồ sơ cho Viện kiểm sát để điều tra bổ sung, dùng skill:

`knowledge_base/skills/statistics/skill_criminal_first_instance_return_to_procuracy_list.md`

Quy tắc bắt buộc: đơn vị tính là occurrence/event, không phải distinct `case_id`. Trả hồ sơ cho Viện kiểm sát để điều tra bổ sung là một lần đã giải quyết; thụ lý lại sau điều tra bổ sung là một lần thụ lý mới.

## 8. Quy trình sử dụng skill
1. Nhận diện `form_code`: HS_ST_1A, HS_PT_1B, HS_GDT_1C hoặc HS_TT_1D.
2. Đọc `criminal_data_dictionary.json` để biết cột dữ liệu.
3. Đọc `criminal_formula_catalog.json` để lấy công thức áp dụng.
4. Sinh công thức theo cột đích.
5. Chạy validation trước khi xuất biểu mẫu.
6. Sinh dashboard từ nhóm KPI chuẩn.

## 9. Định dạng trả lời khi được gọi
- Nếu yêu cầu “tạo công thức”: trả JSON gồm `form_code`, `target_column`, `formula`, `dependencies`, `validation`.
- Nếu yêu cầu “kiểm tra số liệu”: trả bảng lỗi gồm `rule_id`, `severity`, `location`, `message`.
- Nếu yêu cầu “tạo dashboard”: trả danh sách KPI, công thức, nguồn dữ liệu, bộ lọc kỳ thống kê/đơn vị/cấp xét xử.
