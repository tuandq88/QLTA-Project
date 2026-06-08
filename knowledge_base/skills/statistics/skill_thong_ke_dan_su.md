# Skill thống kê loại án dân sự

**Tên skill:** `civil_case_statistics`  
**Phiên bản:** `2.0.0`  
**Phạm vi:** Thống kê thụ lý, giải quyết các vụ án, việc dân sự theo 04 biểu mẫu: sơ thẩm, phúc thẩm, giám đốc thẩm, tái thẩm.  
**Nguồn nghiệp vụ:** Hướng dẫn sử dụng biểu mẫu thống kê nghiệp vụ trong hệ thống Tòa án nhân dân ban hành theo Quyết định số 287/QĐ-TANDTC ngày 15/12/2017 và 04 biểu mẫu Excel dân sự do người dùng cung cấp.

---

## 1. Mục tiêu của skill

Skill này dùng cho hệ thống quản lý Tòa án để:

1. Chuẩn hóa dữ liệu đầu vào của loại án dân sự.
2. Sinh công thức thống kê cho từng cột trong biểu mẫu dân sự.
3. Kiểm tra quan hệ cộng, trừ giữa các chỉ tiêu.
4. Phát hiện sai lệch số liệu trước khi xuất báo cáo.
5. Sinh KPI, dashboard lãnh đạo cho án dân sự.
6. Tách riêng logic dân sự với hình sự, hôn nhân gia đình, hành chính, kinh doanh thương mại, lao động.

Skill này **không thay thế biểu mẫu chính thức**, mà đóng vai trò lớp nghiệp vụ để hệ thống tự động tính toán, đối chiếu và gợi ý cảnh báo.

---

## 2. Biểu mẫu được hỗ trợ

| Mã nội bộ | Biểu mẫu | Tên biểu mẫu | Số cột |
|---|---:|---|---:|
| `DS_ST_2A` | Mẫu 2A | Thống kê thụ lý và giải quyết các vụ án, việc dân sự sơ thẩm | 34 |
| `DS_PT_2B` | Mẫu 2B | Thống kê thụ lý và giải quyết các vụ án, việc dân sự phúc thẩm | 49 |
| `DS_GDT_2C` | Mẫu 2C | Thống kê thụ lý và giải quyết các vụ án, việc dân sự giám đốc thẩm | 30 |
| `DS_TT_2D` | Mẫu 2D | Thống kê thụ lý và giải quyết các vụ án, việc dân sự tái thẩm | 21 |

---

## 3. Nguyên tắc nghiệp vụ chung

### 3.1. Nguyên tắc xác định loại vụ án, việc dân sự

- Cột 1 của các biểu mẫu ghi tên loại vụ án, việc dân sự đã thụ lý, giải quyết trong kỳ.
- Mục A ghi các **vụ án dân sự**.
- Mục B ghi các **việc dân sự**.
- Trường hợp khi thụ lý xác định quan hệ tranh chấp là A nhưng khi giải quyết xác định là B thì thống kê theo **quan hệ tranh chấp mà Tòa án đã giải quyết**.

### 3.2. Nguyên tắc tổng số phải giải quyết

Đối với sơ thẩm:

```text
Tổng số phải giải quyết = Cũ còn lại + Mới thụ lý - Chuyển hồ sơ + Nhập vụ án
```

Đối với phúc thẩm, giám đốc thẩm, tái thẩm:

```text
Tổng số phải giải quyết = Cũ còn lại + Mới thụ lý
```

Riêng cấp phúc thẩm, giám đốc thẩm, tái thẩm cần tách theo chủ thể/thủ tục kháng cáo, kháng nghị.

### 3.3. Nguyên tắc tổng số đã giải quyết

```text
Tổng số đã giải quyết = Đình chỉ + Công nhận thỏa thuận + Xét xử/giải quyết
```

Riêng phúc thẩm, giám đốc thẩm, tái thẩm:

```text
Tổng số đã giải quyết = Đình chỉ + Đã xét xử
```

### 3.4. Nguyên tắc số còn lại

```text
Số còn lại = Tổng số phải giải quyết - Tổng số đã giải quyết
```

### 3.5. Nguyên tắc quá hạn

- Số vụ, việc quá hạn luật định là một phần của số còn lại.
- Nếu cùng có nguyên nhân chủ quan và khách quan thì ưu tiên thống kê vào nguyên nhân khách quan.

### 3.6. Nguyên tắc tạm đình chỉ

- Tạm đình chỉ lần 2 và tạm đình chỉ trên 2 lần là chỉ tiêu con của tổng số tạm đình chỉ.
- Chỉ tiêu có văn bản kiến nghị của Chánh án TANDTC về VBQPPL là chỉ tiêu con của tổng số tạm đình chỉ.

---

## 4. Mô hình dữ liệu lõi

### 4.1. `civil_case`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `case_id` | string | Mã vụ, việc duy nhất |
| `case_code` | string | Số thụ lý/số hồ sơ |
| `case_category` | enum | `vu_an_dan_su`, `viec_dan_su` |
| `civil_matter_code` | string | Mã loại tranh chấp/việc dân sự |
| `civil_matter_name` | string | Tên loại tranh chấp/việc dân sự |
| `court_id` | string | Đơn vị Tòa án |
| `court_level` | enum | `khu_vuc`, `tinh`, `cap_cao`, `toi_cao` |
| `procedure_level` | enum | `so_tham`, `phuc_tham`, `giam_doc_tham`, `tai_tham` |
| `acceptance_date` | date | Ngày thụ lý |
| `resolved_date` | date | Ngày giải quyết |
| `status` | enum | Trạng thái hiện tại |
| `period_id` | string | Kỳ thống kê |
| `is_old_pending` | boolean | Cũ còn lại từ kỳ trước |
| `is_newly_accepted` | boolean | Mới thụ lý trong kỳ |
| `is_transferred` | boolean | Chuyển hồ sơ |
| `is_joined` | boolean | Nhập vụ án |
| `is_overdue` | boolean | Quá hạn luật định |
| `overdue_reason` | enum | `chu_quan`, `khach_quan` |
| `is_suspended` | boolean | Tạm đình chỉ |
| `suspension_count` | integer | Số lần tạm đình chỉ |
| `has_vbqppl_recommendation` | boolean | Có kiến nghị sửa đổi/bãi bỏ VBQPPL |

### 4.2. `civil_party`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `party_id` | string | Mã đương sự |
| `case_id` | string | Mã vụ, việc |
| `role` | enum | `nguyen_don`, `bi_don`, `nguoi_yeu_cau`, `nguoi_bi_yeu_cau`, `nguoi_lien_quan` |
| `party_type` | enum | `ca_nhan`, `co_quan_to_chuc` |
| `age_group` | enum | `duoi_15`, `tu_15_duoi_18`, `tu_18_tro_len` |
| `is_foreign_element` | boolean | Yếu tố nước ngoài |

### 4.3. `civil_resolution`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `resolution_id` | string | Mã kết quả giải quyết |
| `case_id` | string | Mã vụ, việc |
| `resolution_type` | enum | `dinh_chi`, `cong_nhan_thoa_thuan`, `xet_xu_giai_quyet`, `rut_khang_cao`, `rut_khang_nghi`, `ly_do_khac` |
| `trial_result_type` | enum | Kết quả xét xử phúc thẩm/GĐT/TT |
| `has_precedent` | boolean | Có áp dụng án lệ |
| `is_summary_procedure` | boolean | Thủ tục rút gọn |
| `has_temporary_emergency_measure` | boolean | Biện pháp khẩn cấp tạm thời |
| `vks_participated` | boolean | Viện kiểm sát tham gia |
| `has_lawyer` | boolean | Có luật sư |
| `has_other_representative` | boolean | Người bảo vệ quyền, lợi ích hợp pháp khác |
| `experience_trial` | boolean | Phiên tòa rút kinh nghiệm |
| `successful_mediation` | boolean | Hòa giải thành công |

### 4.4. `civil_appeal_protest`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `appeal_id` | string | Mã kháng cáo/kháng nghị |
| `case_id` | string | Mã vụ, việc |
| `stage` | enum | `phuc_tham`, `giam_doc_tham`, `tai_tham` |
| `source_type` | enum | `khang_cao`, `chanh_an_khang_nghi`, `vien_truong_khang_nghi`, `vks_khang_nghi` |
| `is_old_pending` | boolean | Cũ còn lại |
| `is_newly_accepted` | boolean | Mới thụ lý |
| `is_withdrawn` | boolean | Rút kháng cáo/kháng nghị |
| `withdrawn_by` | enum | `duong_su`, `chanh_an`, `vien_truong`, `vks` |
| `accepted_result` | enum | `chap_nhan`, `khong_chap_nhan`, `mot_phan` |

---

## 5. Mapping biểu mẫu Mẫu 2A - Dân sự sơ thẩm

### 5.1. Nhóm cột phải giải quyết

| Cột | Tên chỉ tiêu | Mã trường | Công thức/nguồn |
|---:|---|---|---|
| 1 | Loại vụ án và việc dân sự | `civil_matter_name` | Theo loại vụ/việc |
| 2 | Cũ còn lại | `old_pending_cases` | Đếm hồ sơ cũ còn lại |
| 3 | Mới thụ lý | `new_cases` | Đếm hồ sơ thụ lý mới |
| 4 | Chuyển hồ sơ | `transferred_cases` | Đếm hồ sơ chuyển |
| 5 | Nhập vụ án | `joined_cases` | Đếm hồ sơ nhập |
| 6 | Tổng số phải giải quyết | `total_to_resolve` | `C6 = C2 + C3 - C4 + C5` |

### 5.2. Nhóm cột đã giải quyết

| Cột | Tên chỉ tiêu | Mã trường | Công thức/nguồn |
|---:|---|---|---|
| 7 | Đình chỉ | `dismissed_cases` | Kết quả đình chỉ |
| 8 | Công nhận thỏa thuận | `recognized_agreement_cases` | Quyết định công nhận thỏa thuận |
| 9 | Xét xử hoặc giải quyết | `tried_or_resolved_cases` | Đã xét xử/giải quyết |
| 10 | Tổng số đã giải quyết | `resolved_cases` | `C10 = C7 + C8 + C9` |

### 5.3. Nhóm cột còn lại

| Cột | Tên chỉ tiêu | Mã trường | Công thức/nguồn |
|---:|---|---|---|
| 11 | Tổng số còn lại | `remaining_cases` | `C11 = C6 - C10` |
| 12 | Quá hạn - nguyên nhân chủ quan | `overdue_subjective_cases` | Đếm quá hạn do chủ quan |
| 13 | Quá hạn - nguyên nhân khách quan | `overdue_objective_cases` | Đếm quá hạn khách quan |
| 14 | Tạm đình chỉ - tổng số | `suspended_cases` | Đếm vụ/việc tạm đình chỉ |
| 15 | Tạm đình chỉ lần 2 | `suspended_second_time_cases` | `suspension_count = 2` |
| 16 | Tạm đình chỉ trên 2 lần | `suspended_more_than_two_cases` | `suspension_count > 2` |
| 17 | Có kiến nghị VBQPPL | `vbqppl_recommendation_cases` | Chỉ tiêu con của tạm đình chỉ |

### 5.4. Đặc điểm vụ, việc đã giải quyết

| Cột | Tên chỉ tiêu | Mã trường |
|---:|---|---|
| 18 | Áp dụng án lệ | `precedent_cases` |
| 19 | Giải quyết theo thủ tục rút gọn | `summary_procedure_cases` |
| 20 | Áp dụng biện pháp khẩn cấp tạm thời | `temporary_emergency_measure_cases` |
| 21 | Quyết định cá biệt trái pháp luật bị hủy | `illegal_individual_decision_cancelled_cases` |
| 22 | Viện kiểm sát tham gia | `vks_participated_cases` |
| 23 | Có yếu tố nước ngoài | `foreign_element_cases` |
| 24 | Có luật sư | `lawyer_cases` |
| 25 | Người bảo vệ quyền, lợi ích hợp pháp khác | `other_representative_cases` |

### 5.5. Đặc điểm nguyên đơn, bị đơn

| Cột | Tên chỉ tiêu | Mã trường |
|---:|---|---|
| 26 | Nguyên đơn là cơ quan, tổ chức - tổng số | `plaintiff_org_total` |
| 27 | Cơ quan/tổ chức khởi kiện bảo vệ quyền lợi người khác, lợi ích công cộng, nhà nước | `plaintiff_org_public_interest` |
| 28 | Nguyên đơn cá nhân từ đủ 15 đến dưới 18 tuổi | `plaintiff_person_15_to_under_18` |
| 29 | Nguyên đơn cá nhân từ đủ 18 tuổi trở lên | `plaintiff_person_18_or_above` |
| 30 | Bị đơn là cơ quan, tổ chức | `defendant_org_total` |
| 31 | Bị đơn cá nhân từ đủ 15 đến dưới 18 tuổi | `defendant_person_15_to_under_18` |
| 32 | Bị đơn cá nhân từ đủ 18 tuổi trở lên | `defendant_person_18_or_above` |
| 33 | Phiên tòa rút kinh nghiệm | `experience_trial_cases` |
| 34 | Hòa giải thành công | `successful_mediation_cases` |

---

## 6. Mapping biểu mẫu Mẫu 2B - Dân sự phúc thẩm

### 6.1. Phải giải quyết

| Cột | Chỉ tiêu | Công thức/nguồn |
|---:|---|---|
| 1 | Loại vụ án và việc dân sự | Theo loại vụ/việc |
| 2 | Cũ còn lại do kháng cáo | Đếm kháng cáo cũ |
| 3 | Cũ còn lại do kháng nghị | Đếm kháng nghị cũ |
| 4 | Mới thụ lý do kháng cáo | Đếm kháng cáo mới |
| 5 | Mới thụ lý do kháng nghị | Đếm kháng nghị mới |
| 6 | Tổng kháng cáo phải giải quyết | `C6 = C2 + C4` |
| 7 | Tổng kháng nghị phải giải quyết | `C7 = C3 + C5` |
| 8 | Cộng phải giải quyết | `C8 = C6 + C7` |

### 6.2. Đã giải quyết

| Cột | Chỉ tiêu | Công thức/nguồn |
|---:|---|---|
| 9 | Đình chỉ do rút kháng cáo | Đếm vụ/việc rút kháng cáo |
| 10 | Đình chỉ do rút kháng nghị | Đếm vụ/việc rút kháng nghị |
| 11 | Đình chỉ lý do khác - kháng cáo | Đếm đình chỉ khác liên quan kháng cáo |
| 12 | Đình chỉ lý do khác - kháng nghị | Đếm đình chỉ khác liên quan kháng nghị |
| 13 | Cộng đình chỉ | `C13 = C9 + C10 + C11 + C12` |
| 14 | Xét xử/giải quyết do kháng cáo | Đếm đã xét xử/giải quyết kháng cáo |
| 15 | Xét xử/giải quyết do kháng nghị | Đếm đã xét xử/giải quyết kháng nghị |
| 16 | Cộng xét xử/giải quyết | `C16 = C14 + C15` |
| 17 | Tổng đã giải quyết do kháng cáo | `C17 = C9 + C11 + C14` |
| 18 | Tổng đã giải quyết do kháng nghị | `C18 = C10 + C12 + C15` |
| 19 | Cộng đã giải quyết | `C19 = C17 + C18` hoặc `C13 + C16` |

### 6.3. Còn lại, quá hạn, tạm đình chỉ

| Cột | Chỉ tiêu | Công thức/nguồn |
|---:|---|---|
| 20 | Còn lại do kháng cáo | `C20 = C6 - C17` |
| 21 | Còn lại do kháng nghị | `C21 = C7 - C18` |
| 22 | Cộng còn lại | `C22 = C20 + C21` |
| 23 | Quá hạn do nguyên nhân chủ quan | Đếm quá hạn chủ quan |
| 24 | Quá hạn do nguyên nhân khách quan | Đếm quá hạn khách quan |
| 25 | Tạm đình chỉ tổng số | Đếm tạm đình chỉ |
| 26 | Tạm đình chỉ lần 2 | Chỉ tiêu con của C25 |
| 27 | Tạm đình chỉ trên 2 lần | Chỉ tiêu con của C25 |
| 28 | Tạm đình chỉ do kiến nghị VBQPPL | Chỉ tiêu con của C25 |

### 6.4. Phân tích vụ, việc đã xét xử

| Cột | Chỉ tiêu | Mã trường |
|---:|---|---|
| 29 | Giữ nguyên bản án, quyết định sơ thẩm | `upheld_first_instance_cases` |
| 30 | Sửa một phần do cấp sơ thẩm sai | `partly_modified_due_first_instance_error` |
| 31 | Sửa một phần do lý do khác | `partly_modified_other_reason` |
| 32 | Sửa toàn bộ do cấp sơ thẩm sai | `fully_modified_due_first_instance_error` |
| 33 | Sửa toàn bộ do lý do khác | `fully_modified_other_reason` |
| 34 | Hủy một phần để giải quyết lại do cấp sơ thẩm sai | `partly_cancelled_retrial_due_first_instance_error` |
| 35 | Hủy một phần để giải quyết lại do lý do khác | `partly_cancelled_retrial_other_reason` |
| 36 | Hủy toàn bộ để giải quyết lại do cấp sơ thẩm sai | `fully_cancelled_retrial_due_first_instance_error` |
| 37 | Hủy toàn bộ để giải quyết lại do lý do khác | `fully_cancelled_retrial_other_reason` |
| 38 | Hủy và đình chỉ do cấp sơ thẩm sai | `cancelled_and_dismissed_due_first_instance_error` |
| 39 | Hủy và đình chỉ do lý do khác | `cancelled_and_dismissed_other_reason` |
| 40 | Đình chỉ xét xử phúc thẩm và giữ nguyên án sơ thẩm | `appellate_dismissed_and_upheld` |
| 41 | VKS kháng nghị không được chấp nhận | `vks_protest_rejected_cases` |
| 42 | VKS rút kháng nghị nhưng đương sự không rút kháng cáo | `vks_withdrawn_party_not_withdrawn_cases` |

### 6.5. Đặc điểm vụ, việc đã giải quyết

| Cột | Chỉ tiêu | Mã trường |
|---:|---|---|
| 43 | Áp dụng án lệ | `precedent_cases` |
| 44 | Thủ tục rút gọn | `summary_procedure_cases` |
| 45 | Biện pháp khẩn cấp tạm thời | `temporary_emergency_measure_cases` |
| 46 | Viện kiểm sát tham gia | `vks_participated_cases` |
| 47 | Có luật sư | `lawyer_cases` |
| 48 | Người bảo vệ quyền, lợi ích hợp pháp khác | `other_representative_cases` |
| 49 | Phiên tòa rút kinh nghiệm | `experience_trial_cases` |

---

## 7. Mapping biểu mẫu Mẫu 2C - Dân sự giám đốc thẩm

| Cột | Chỉ tiêu | Công thức/nguồn |
|---:|---|---|
| 1 | Loại vụ án và việc dân sự | Theo loại vụ/việc |
| 2 | Cũ còn lại - Chánh án kháng nghị | Đếm cũ còn lại |
| 3 | Cũ còn lại - Viện trưởng kháng nghị | Đếm cũ còn lại |
| 4 | Mới thụ lý - Chánh án kháng nghị | Đếm mới thụ lý |
| 5 | Mới thụ lý - Viện trưởng kháng nghị | Đếm mới thụ lý |
| 6 | Tổng Chánh án kháng nghị | `C6 = C2 + C4` |
| 7 | Tổng Viện trưởng kháng nghị | `C7 = C3 + C5` |
| 8 | Cộng phải giải quyết | `C8 = C6 + C7` |
| 9 | Đình chỉ xét xử do Chánh án rút kháng nghị | Đếm rút kháng nghị |
| 10 | Đình chỉ xét xử do Viện trưởng rút kháng nghị | Đếm rút kháng nghị |
| 11 | Đã xét xử do Chánh án kháng nghị | Đếm xét xử |
| 12 | Đã xét xử do Viện trưởng kháng nghị | Đếm xét xử |
| 13 | Tổng đã giải quyết | `C13 = C9 + C10 + C11 + C12` |
| 14 | Còn lại - Chánh án kháng nghị | `C14 = C6 - C9 - C11` |
| 15 | Còn lại - Viện trưởng kháng nghị | `C15 = C7 - C10 - C12` |
| 16 | Tổng còn lại | `C16 = C14 + C15` |
| 17 | Quá hạn nguyên nhân chủ quan | Đếm quá hạn chủ quan |
| 18 | Quá hạn nguyên nhân khách quan | Đếm quá hạn khách quan |
| 19 | Giữ nguyên - không chấp nhận kháng nghị của Chánh án | Đếm không chấp nhận |
| 20 | Giữ nguyên - không chấp nhận kháng nghị của Viện trưởng | Đếm không chấp nhận |
| 21 | Sửa một phần bản án, quyết định đã có hiệu lực | Đếm sửa một phần |
| 22 | Sửa toàn bộ bản án, quyết định đã có hiệu lực | Đếm sửa toàn bộ |
| 23 | Hủy bản án, quyết định có hiệu lực và đình chỉ | Đếm hủy, đình chỉ |
| 24 | Hủy bản án/quyết định phúc thẩm, giữ nguyên sơ thẩm | Đếm |
| 25 | Hủy quyết định GĐT, giữ nguyên sơ thẩm | Đếm |
| 26 | Hủy quyết định GĐT, giữ nguyên phúc thẩm | Đếm |
| 27 | Hủy quyết định GĐT, bản án/quyết định phúc thẩm, giữ nguyên sơ thẩm | Đếm |
| 28 | Hủy để xét xử lại sơ thẩm | Đếm |
| 29 | Hủy để xét xử lại phúc thẩm | Đếm |
| 30 | Áp dụng án lệ | Đếm |

---

## 8. Mapping biểu mẫu Mẫu 2D - Dân sự tái thẩm

| Cột | Chỉ tiêu | Công thức/nguồn |
|---:|---|---|
| 1 | Loại vụ án và việc dân sự | Theo loại vụ/việc |
| 2 | Cũ còn lại - Chánh án kháng nghị | Đếm cũ còn lại |
| 3 | Cũ còn lại - Viện trưởng kháng nghị | Đếm cũ còn lại |
| 4 | Mới thụ lý - Chánh án kháng nghị | Đếm mới thụ lý |
| 5 | Mới thụ lý - Viện trưởng kháng nghị | Đếm mới thụ lý |
| 6 | Tổng Chánh án kháng nghị | `C6 = C2 + C4` |
| 7 | Tổng Viện trưởng kháng nghị | `C7 = C3 + C5` |
| 8 | Cộng phải giải quyết | `C8 = C6 + C7` |
| 9 | Đình chỉ do Chánh án rút kháng nghị | Đếm rút kháng nghị |
| 10 | Đình chỉ do Viện trưởng rút kháng nghị | Đếm rút kháng nghị |
| 11 | Đã xét xử do Chánh án kháng nghị | Đếm xét xử |
| 12 | Đã xét xử do Viện trưởng kháng nghị | Đếm xét xử |
| 13 | Tổng đã giải quyết | `C13 = C9 + C10 + C11 + C12` |
| 14 | Còn lại - Chánh án kháng nghị | `C14 = C6 - C9 - C11` |
| 15 | Còn lại - Viện trưởng kháng nghị | `C15 = C7 - C10 - C12` |
| 16 | Tổng còn lại | `C16 = C14 + C15` |
| 17 | Giữ nguyên - không chấp nhận kháng nghị của Chánh án | Đếm không chấp nhận |
| 18 | Giữ nguyên - không chấp nhận kháng nghị của Viện trưởng | Đếm không chấp nhận |
| 19 | Hủy bản án/quyết định đã có hiệu lực để xét xử sơ thẩm lại | Đếm |
| 20 | Hủy bản án/quyết định đã có hiệu lực và đình chỉ | Đếm |
| 21 | Áp dụng án lệ | Đếm |

---

## 9. Formula catalog chính

### 9.1. Nhóm công thức chung

| ID | Tên | Công thức |
|---|---|---|
| `DS_CORE_001` | Tổng sơ thẩm phải giải quyết | `old_pending + newly_accepted - transferred + joined` |
| `DS_CORE_002` | Tổng cấp xét lại phải giải quyết | `old_pending + newly_accepted` |
| `DS_CORE_003` | Tổng đã giải quyết sơ thẩm | `dismissed + recognized_agreement + tried_or_resolved` |
| `DS_CORE_004` | Tổng đã giải quyết xét lại | `dismissed + tried_or_reviewed` |
| `DS_CORE_005` | Còn lại | `total_to_resolve - total_resolved` |
| `DS_CORE_006` | Tỷ lệ giải quyết | `safe_divide(total_resolved, total_to_resolve) * 100` |
| `DS_CORE_007` | Tỷ lệ còn lại | `safe_divide(remaining, total_to_resolve) * 100` |
| `DS_CORE_008` | Tỷ lệ quá hạn | `safe_divide(overdue_subjective + overdue_objective, remaining) * 100` |
| `DS_CORE_009` | Tỷ lệ tạm đình chỉ | `safe_divide(suspended, remaining) * 100` |

### 9.2. Nhóm sơ thẩm

| ID | Tên | Công thức |
|---|---|---|
| `DS_ST_001` | Tổng phải giải quyết cột 6 | `C2 + C3 - C4 + C5` |
| `DS_ST_002` | Tổng đã giải quyết cột 10 | `C7 + C8 + C9` |
| `DS_ST_003` | Còn lại cột 11 | `C6 - C10` |
| `DS_ST_004` | Quá hạn tổng | `C12 + C13` |
| `DS_ST_005` | Tạm đình chỉ hợp lệ | `C15 + C16 <= C14` |
| `DS_ST_006` | Kiến nghị VBQPPL hợp lệ | `C17 <= C14` |
| `DS_ST_007` | Tỷ lệ công nhận thỏa thuận | `safe_divide(C8, C10) * 100` |
| `DS_ST_008` | Tỷ lệ hòa giải thành công | `safe_divide(C34, C10) * 100` |
| `DS_ST_009` | Tỷ lệ án có yếu tố nước ngoài | `safe_divide(C23, C10) * 100` |
| `DS_ST_010` | Tỷ lệ VKS tham gia | `safe_divide(C22, C10) * 100` |

### 9.3. Nhóm phúc thẩm

| ID | Tên | Công thức |
|---|---|---|
| `DS_PT_001` | Tổng kháng cáo phải giải quyết | `C2 + C4` |
| `DS_PT_002` | Tổng kháng nghị phải giải quyết | `C3 + C5` |
| `DS_PT_003` | Cộng phải giải quyết | `C6 + C7` |
| `DS_PT_004` | Cộng đình chỉ | `C9 + C10 + C11 + C12` |
| `DS_PT_005` | Cộng xét xử/giải quyết | `C14 + C15` |
| `DS_PT_006` | Đã giải quyết kháng cáo | `C9 + C11 + C14` |
| `DS_PT_007` | Đã giải quyết kháng nghị | `C10 + C12 + C15` |
| `DS_PT_008` | Tổng đã giải quyết | `C17 + C18` |
| `DS_PT_009` | Còn lại kháng cáo | `C6 - C17` |
| `DS_PT_010` | Còn lại kháng nghị | `C7 - C18` |
| `DS_PT_011` | Cộng còn lại | `C20 + C21` |
| `DS_PT_012` | Tổng sửa án | `C30 + C31 + C32 + C33` |
| `DS_PT_013` | Tổng hủy án | `C34 + C35 + C36 + C37 + C38 + C39` |
| `DS_PT_014` | Tỷ lệ y án | `safe_divide(C29, C16) * 100` |
| `DS_PT_015` | Tỷ lệ sửa án | `safe_divide(C30 + C31 + C32 + C33, C16) * 100` |
| `DS_PT_016` | Tỷ lệ hủy án | `safe_divide(C34 + C35 + C36 + C37 + C38 + C39, C16) * 100` |

### 9.4. Nhóm giám đốc thẩm

| ID | Tên | Công thức |
|---|---|---|
| `DS_GDT_001` | Tổng Chánh án kháng nghị | `C2 + C4` |
| `DS_GDT_002` | Tổng Viện trưởng kháng nghị | `C3 + C5` |
| `DS_GDT_003` | Cộng phải giải quyết | `C6 + C7` |
| `DS_GDT_004` | Tổng đã giải quyết | `C9 + C10 + C11 + C12` |
| `DS_GDT_005` | Còn lại Chánh án | `C6 - C9 - C11` |
| `DS_GDT_006` | Còn lại Viện trưởng | `C7 - C10 - C12` |
| `DS_GDT_007` | Tổng còn lại | `C14 + C15` |
| `DS_GDT_008` | Tổng giữ nguyên | `C19 + C20` |
| `DS_GDT_009` | Tổng sửa án | `C21 + C22` |
| `DS_GDT_010` | Tổng hủy án | `C23 + C24 + C25 + C26 + C27 + C28 + C29` |
| `DS_GDT_011` | Tỷ lệ kháng nghị không chấp nhận | `safe_divide(C19 + C20, C11 + C12) * 100` |
| `DS_GDT_012` | Tỷ lệ hủy để xét xử lại | `safe_divide(C28 + C29, C11 + C12) * 100` |

### 9.5. Nhóm tái thẩm

| ID | Tên | Công thức |
|---|---|---|
| `DS_TT_001` | Tổng Chánh án kháng nghị | `C2 + C4` |
| `DS_TT_002` | Tổng Viện trưởng kháng nghị | `C3 + C5` |
| `DS_TT_003` | Cộng phải giải quyết | `C6 + C7` |
| `DS_TT_004` | Tổng đã giải quyết | `C9 + C10 + C11 + C12` |
| `DS_TT_005` | Còn lại Chánh án | `C6 - C9 - C11` |
| `DS_TT_006` | Còn lại Viện trưởng | `C7 - C10 - C12` |
| `DS_TT_007` | Tổng còn lại | `C14 + C15` |
| `DS_TT_008` | Tổng giữ nguyên | `C17 + C18` |
| `DS_TT_009` | Tổng hủy | `C19 + C20` |
| `DS_TT_010` | Tỷ lệ không chấp nhận kháng nghị | `safe_divide(C17 + C18, C11 + C12) * 100` |
| `DS_TT_011` | Tỷ lệ hủy tái thẩm | `safe_divide(C19 + C20, C11 + C12) * 100` |

---

## 10. Validation rules

### 10.1. Quy tắc chung

| ID | Điều kiện | Mức lỗi | Thông báo |
|---|---|---|---|
| `DS_RULE_001` | `total_to_resolve = total_resolved + remaining` | Error | Tổng phải giải quyết phải bằng đã giải quyết cộng còn lại |
| `DS_RULE_002` | Mọi chỉ tiêu số lượng `>= 0` | Error | Không được có số âm |
| `DS_RULE_003` | `overdue_subjective + overdue_objective <= remaining` | Error | Quá hạn không được lớn hơn số còn lại |
| `DS_RULE_004` | `suspended <= remaining` | Error | Tạm đình chỉ không được lớn hơn số còn lại |
| `DS_RULE_005` | `suspended_second_time + suspended_more_than_two <= suspended` | Warning | Các chỉ tiêu con của tạm đình chỉ vượt tổng tạm đình chỉ |
| `DS_RULE_006` | `vbqppl_recommendation <= suspended` | Warning | Kiến nghị VBQPPL phải nằm trong tạm đình chỉ |
| `DS_RULE_007` | Nếu có cả quá hạn chủ quan và khách quan cho cùng vụ thì ghi khách quan | Warning | Kiểm tra phân loại nguyên nhân quá hạn |

### 10.2. Sơ thẩm

| ID | Công thức kiểm tra |
|---|---|
| `DS_ST_RULE_001` | `C6 = C2 + C3 - C4 + C5` |
| `DS_ST_RULE_002` | `C10 = C7 + C8 + C9` |
| `DS_ST_RULE_003` | `C11 = C6 - C10` |
| `DS_ST_RULE_004` | `C12 + C13 <= C11` |
| `DS_ST_RULE_005` | `C14 <= C11` |
| `DS_ST_RULE_006` | `C15 + C16 <= C14` |
| `DS_ST_RULE_007` | `C17 <= C14` |
| `DS_ST_RULE_008` | `C18:C25 <= C10` |
| `DS_ST_RULE_009` | `C33 <= C9` |
| `DS_ST_RULE_010` | `C34 <= C10` |

### 10.3. Phúc thẩm

| ID | Công thức kiểm tra |
|---|---|
| `DS_PT_RULE_001` | `C6 = C2 + C4` |
| `DS_PT_RULE_002` | `C7 = C3 + C5` |
| `DS_PT_RULE_003` | `C8 = C6 + C7` |
| `DS_PT_RULE_004` | `C13 = C9 + C10 + C11 + C12` |
| `DS_PT_RULE_005` | `C16 = C14 + C15` |
| `DS_PT_RULE_006` | `C17 = C9 + C11 + C14` |
| `DS_PT_RULE_007` | `C18 = C10 + C12 + C15` |
| `DS_PT_RULE_008` | `C19 = C17 + C18` |
| `DS_PT_RULE_009` | `C20 = C6 - C17` |
| `DS_PT_RULE_010` | `C21 = C7 - C18` |
| `DS_PT_RULE_011` | `C22 = C20 + C21` |
| `DS_PT_RULE_012` | `C23 + C24 <= C22` |
| `DS_PT_RULE_013` | `C25 <= C22` |
| `DS_PT_RULE_014` | `C26 + C27 + C28 <= C25` |
| `DS_PT_RULE_015` | `C29 + C30 + C31 + C32 + C33 + C34 + C35 + C36 + C37 + C38 + C39 + C40 = C16` |

### 10.4. Giám đốc thẩm

| ID | Công thức kiểm tra |
|---|---|
| `DS_GDT_RULE_001` | `C6 = C2 + C4` |
| `DS_GDT_RULE_002` | `C7 = C3 + C5` |
| `DS_GDT_RULE_003` | `C8 = C6 + C7` |
| `DS_GDT_RULE_004` | `C13 = C9 + C10 + C11 + C12` |
| `DS_GDT_RULE_005` | `C14 = C6 - C9 - C11` |
| `DS_GDT_RULE_006` | `C15 = C7 - C10 - C12` |
| `DS_GDT_RULE_007` | `C16 = C14 + C15` |
| `DS_GDT_RULE_008` | `C17 + C18 <= C16` |
| `DS_GDT_RULE_009` | `C19 + C20 + C21 + C22 + C23 + C24 + C25 + C26 + C27 + C28 + C29 = C11 + C12` |

### 10.5. Tái thẩm

| ID | Công thức kiểm tra |
|---|---|
| `DS_TT_RULE_001` | `C6 = C2 + C4` |
| `DS_TT_RULE_002` | `C7 = C3 + C5` |
| `DS_TT_RULE_003` | `C8 = C6 + C7` |
| `DS_TT_RULE_004` | `C13 = C9 + C10 + C11 + C12` |
| `DS_TT_RULE_005` | `C14 = C6 - C9 - C11` |
| `DS_TT_RULE_006` | `C15 = C7 - C10 - C12` |
| `DS_TT_RULE_007` | `C16 = C14 + C15` |
| `DS_TT_RULE_008` | `C17 + C18 + C19 + C20 = C11 + C12` |

---

## 11. Dashboard KPI đề xuất

### 11.1. KPI điều hành chung

| KPI | Công thức |
|---|---|
| Tổng thụ lý dân sự | `sum(new_cases)` |
| Tổng phải giải quyết | `sum(total_to_resolve)` |
| Tổng đã giải quyết | `sum(total_resolved)` |
| Tỷ lệ giải quyết | `sum(total_resolved) / sum(total_to_resolve) * 100` |
| Tổng còn lại | `sum(remaining)` |
| Tỷ lệ tồn | `sum(remaining) / sum(total_to_resolve) * 100` |
| Tổng quá hạn | `sum(overdue_subjective + overdue_objective)` |
| Tỷ lệ quá hạn | `sum(overdue) / sum(remaining) * 100` |
| Tỷ lệ công nhận thỏa thuận | `sum(recognized_agreement) / sum(total_resolved) * 100` |
| Tỷ lệ hòa giải thành công | `sum(successful_mediation) / sum(total_resolved) * 100` |
| Tỷ lệ án có yếu tố nước ngoài | `sum(foreign_element_cases) / sum(total_resolved) * 100` |

### 11.2. KPI chất lượng xét xử phúc thẩm

| KPI | Công thức |
|---|---|
| Tỷ lệ y án | `upheld / appellate_tried * 100` |
| Tỷ lệ sửa án | `modified / appellate_tried * 100` |
| Tỷ lệ hủy án | `cancelled / appellate_tried * 100` |
| Tỷ lệ sửa, hủy do lỗi sơ thẩm | `(modified_due_error + cancelled_due_error) / appellate_tried * 100` |
| Tỷ lệ VKS kháng nghị không được chấp nhận | `vks_protest_rejected / appellate_tried * 100` |

### 11.3. KPI giám đốc thẩm, tái thẩm

| KPI | Công thức |
|---|---|
| Tỷ lệ kháng nghị không được chấp nhận | `rejected_protests / reviewed_cases * 100` |
| Tỷ lệ sửa án | `modified_cases / reviewed_cases * 100` |
| Tỷ lệ hủy án | `cancelled_cases / reviewed_cases * 100` |
| Tỷ lệ hủy để xét xử lại | `cancelled_for_retrial / reviewed_cases * 100` |

---

## 12. Gợi ý triển khai trong hệ thống

### 12.1. Module nhập liệu

- Nhập thông tin vụ/việc dân sự một lần theo hồ sơ.
- Tự động phân loại vào sơ thẩm, phúc thẩm, giám đốc thẩm, tái thẩm.
- Tự động ghi nhận trạng thái cũ còn lại, mới thụ lý, chuyển hồ sơ, nhập vụ án.
- Khi có kết quả giải quyết, hệ thống cập nhật nhóm chỉ tiêu đã giải quyết.
- Trường hợp phúc thẩm, giám đốc thẩm, tái thẩm phải ghi rõ chủ thể kháng cáo/kháng nghị.

### 12.2. Module tính toán

- Không nhập trực tiếp các cột tổng.
- Các cột tổng, tỷ lệ, cảnh báo phải do công thức sinh tự động.
- Khi người dùng chỉnh một chỉ tiêu nguồn, hệ thống tự kiểm tra toàn bộ quy tắc liên quan.

### 12.3. Module cảnh báo

Cần cảnh báo tối thiểu các lỗi:

1. Tổng phải giải quyết sai.
2. Tổng đã giải quyết sai.
3. Số còn lại sai.
4. Quá hạn lớn hơn còn lại.
5. Tạm đình chỉ lớn hơn còn lại.
6. Chỉ tiêu con lớn hơn chỉ tiêu cha.
7. Tổng kết quả xét xử phúc thẩm/GĐT/TT không khớp số đã xét xử.
8. Có số âm.

---

## 13. Pseudocode tính toán

```python
def safe_divide(numerator, denominator):
    if denominator in (0, None):
        return 0
    return numerator / denominator


def calculate_first_instance(row):
    row.total_to_resolve = row.old_pending + row.newly_accepted - row.transferred + row.joined
    row.total_resolved = row.dismissed + row.recognized_agreement + row.tried_or_resolved
    row.remaining = row.total_to_resolve - row.total_resolved
    row.resolution_rate = safe_divide(row.total_resolved, row.total_to_resolve) * 100
    row.remaining_rate = safe_divide(row.remaining, row.total_to_resolve) * 100
    return row


def calculate_appellate(row):
    row.total_appeal = row.old_appeal + row.new_appeal
    row.total_protest = row.old_protest + row.new_protest
    row.total_to_resolve = row.total_appeal + row.total_protest
    row.resolved_appeal = row.withdrawn_appeal + row.other_dismissed_appeal + row.tried_appeal
    row.resolved_protest = row.withdrawn_protest + row.other_dismissed_protest + row.tried_protest
    row.total_resolved = row.resolved_appeal + row.resolved_protest
    row.remaining_appeal = row.total_appeal - row.resolved_appeal
    row.remaining_protest = row.total_protest - row.resolved_protest
    row.remaining = row.remaining_appeal + row.remaining_protest
    return row


def calculate_review(row):
    row.total_chief_justice = row.old_chief_justice + row.new_chief_justice
    row.total_procurator = row.old_procurator + row.new_procurator
    row.total_to_resolve = row.total_chief_justice + row.total_procurator
    row.total_resolved = row.withdrawn_chief_justice + row.withdrawn_procurator + row.reviewed_chief_justice + row.reviewed_procurator
    row.remaining_chief_justice = row.total_chief_justice - row.withdrawn_chief_justice - row.reviewed_chief_justice
    row.remaining_procurator = row.total_procurator - row.withdrawn_procurator - row.reviewed_procurator
    row.remaining = row.remaining_chief_justice + row.remaining_procurator
    return row
```

---

## 14. Output chuẩn của skill

Skill nên xuất ra các đối tượng:

```json
{
  "form_code": "DS_ST_2A",
  "period": "2026-05",
  "court_id": "TAND_QUANG_NGAI",
  "rows": [],
  "formulas_applied": [],
  "validation_errors": [],
  "kpi_summary": {}
}
```

---

## 15. Ghi chú tích hợp AI

Khi người dùng hỏi bằng ngôn ngữ tự nhiên, AI cần ánh xạ như sau:

| Câu hỏi | Mapping |
|---|---|
| “Tổng án dân sự phải giải quyết tháng này?” | `sum(total_to_resolve)` |
| “Tỷ lệ giải quyết án dân sự sơ thẩm?” | `sum(C10)/sum(C6)*100` |
| “Án dân sự còn lại bao nhiêu?” | `sum(remaining_cases)` |
| “Có bao nhiêu án quá hạn?” | `sum(overdue_subjective + overdue_objective)` |
| “Tỷ lệ án phúc thẩm bị hủy sửa?” | `(sum(modified)+sum(cancelled))/sum(appellate_tried)*100` |
| “Đơn vị nào có tồn nhiều?” | group by `court_id`, sort by `remaining desc` |
| “Loại tranh chấp nào nhiều nhất?” | group by `civil_matter_code`, sort by `total_to_resolve desc` |

---

## 16. Phiên bản

- `2.0.0`: Hoàn chỉnh mapping 04 biểu mẫu dân sự, công thức, validation rules, data dictionary, KPI và pseudocode.
