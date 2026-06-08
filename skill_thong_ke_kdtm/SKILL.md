# Skill thống kê loại án kinh doanh thương mại

**Tên skill:** `commercial_business_case_statistics`  
**Phiên bản:** `3.0.0`  
**Phạm vi:** Thống kê thụ lý, giải quyết các vụ án, việc kinh doanh thương mại theo 04 biểu mẫu: sơ thẩm, phúc thẩm, giám đốc thẩm, tái thẩm.  
**Nguồn nghiệp vụ:** Skill thống kê Tòa án tổng quát, tài liệu hướng dẫn biểu mẫu thống kê nghiệp vụ TAND và 04 biểu mẫu Excel KDTM do người dùng cung cấp.

---

## 1. Mục tiêu của skill

Skill này dùng cho hệ thống quản lý Tòa án để:

1. Chuẩn hóa dữ liệu đầu vào của loại án kinh doanh thương mại.
2. Sinh công thức thống kê cho từng cột của biểu mẫu KDTM.
3. Kiểm tra quan hệ cộng, trừ giữa các chỉ tiêu trước khi xuất báo cáo.
4. Phát hiện sai lệch số liệu theo kỳ, theo đơn vị và theo loại tranh chấp.
5. Sinh KPI, dashboard lãnh đạo phục vụ theo dõi án KDTM.
6. Tách riêng logic KDTM với hình sự, dân sự, hôn nhân gia đình, hành chính, lao động.

Skill này **không thay thế biểu mẫu chính thức**, mà đóng vai trò lớp nghiệp vụ để hệ thống tự động tính toán, đối chiếu, cảnh báo và gợi ý báo cáo.

---

## 2. Biểu mẫu được hỗ trợ

| Mã nội bộ | Biểu mẫu | Tên biểu mẫu | Số cột |
|---|---:|---|---:|
| `KDTM_ST_4A` | Mẫu 4A | Thống kê thụ lý và giải quyết các vụ, việc KDTM sơ thẩm | 35 |
| `KDTM_PT_4B` | Mẫu 4B | Thống kê thụ lý và giải quyết các vụ, việc KDTM phúc thẩm | 49 |
| `KDTM_GDT_4C` | Mẫu 4C | Thống kê thụ lý và giải quyết các vụ, việc KDTM giám đốc thẩm | 30 |
| `KDTM_TT_4D` | Mẫu 4D | Thống kê thụ lý và giải quyết các vụ, việc KDTM tái thẩm | 21 |

---

## 3. Nguyên tắc nghiệp vụ chung

### 3.1. Nguyên tắc xác định loại vụ án, việc KDTM

- Cột 1 của các biểu mẫu ghi tên loại vụ án, việc kinh doanh thương mại đã thụ lý, giải quyết trong kỳ.
- Khi thụ lý một quan hệ tranh chấp nhưng khi giải quyết Tòa án xác định quan hệ khác thì thống kê theo quan hệ tranh chấp/vụ việc mà Tòa án đã giải quyết.
- Dữ liệu phải được tổng hợp theo kỳ báo cáo, theo đơn vị Tòa án và theo loại tranh chấp/việc KDTM.

### 3.2. Nguyên tắc tổng số phải giải quyết

Đối với sơ thẩm:

```text
Tổng số phải giải quyết = Cũ còn lại + Mới thụ lý - Chuyển hồ sơ + Nhập vụ án
```

Đối với phúc thẩm, giám đốc thẩm, tái thẩm:

```text
Tổng số phải giải quyết = Cũ còn lại + Mới thụ lý
```

Riêng phúc thẩm tách theo **kháng cáo** và **kháng nghị**. Giám đốc thẩm, tái thẩm tách theo **Chánh án kháng nghị** và **Viện trưởng kháng nghị**.

### 3.3. Nguyên tắc tổng số đã giải quyết

Sơ thẩm:

```text
Tổng số đã giải quyết = Đình chỉ + Công nhận thỏa thuận của đương sự + Xét xử/giải quyết
```

Phúc thẩm:

```text
Tổng số đã giải quyết = Đình chỉ + Xét xử/giải quyết
```

Giám đốc thẩm, tái thẩm:

```text
Tổng số đã giải quyết = Đình chỉ xét xử + Đã xét xử
```

### 3.4. Nguyên tắc số còn lại

```text
Số còn lại = Tổng số phải giải quyết - Tổng số đã giải quyết
```

### 3.5. Nguyên tắc quá hạn

- Số vụ, việc quá hạn luật định là một phần của số còn lại.
- Nếu một vụ việc vừa có nguyên nhân chủ quan vừa có nguyên nhân khách quan, ưu tiên thống kê vào nguyên nhân khách quan để tránh trùng số.

### 3.6. Nguyên tắc tạm đình chỉ

- Tạm đình chỉ lần 2, tạm đình chỉ trên 2 lần và tạm đình chỉ do kiến nghị VBQPPL là các chỉ tiêu con của tổng số tạm đình chỉ.
- Tổng các chỉ tiêu con không được lớn hơn tổng số tạm đình chỉ.

### 3.7. Nguyên tắc phúc thẩm, giám đốc thẩm, tái thẩm

- Phúc thẩm phải tách nguồn thụ lý theo kháng cáo/kháng nghị.
- Giám đốc thẩm, tái thẩm phải tách nguồn kháng nghị theo Chánh án/Viện trưởng.
- Kết quả sửa, hủy án phải tách được nguyên nhân do cấp sơ thẩm sai và lý do khác, phục vụ đánh giá chất lượng xét xử.

---

## 4. Mô hình dữ liệu lõi

### 4.1. `kdtm_case`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `case_id` | string | Mã vụ, việc duy nhất |
| `case_code` | string | Số thụ lý/số hồ sơ |
| `matter_code` | string | Mã loại tranh chấp/việc KDTM |
| `matter_name` | string | Tên loại tranh chấp/việc KDTM |
| `court_id` | string | Đơn vị Tòa án |
| `court_level` | enum | khu_vuc, tinh, cap_cao, toi_cao |
| `procedure_level` | enum | so_tham, phuc_tham, giam_doc_tham, tai_tham |
| `period_id` | string | Kỳ thống kê |
| `acceptance_date` | date | Ngày thụ lý |
| `resolved_date` | date | Ngày giải quyết |
| `status` | enum | dang_giai_quyet, dinh_chi, cong_nhan_thoa_thuan, xet_xu_giai_quyet, tam_dinh_chi, chuyen_ho_so |
| `is_old_pending` | boolean | Cũ còn lại |
| `is_newly_accepted` | boolean | Mới thụ lý |
| `is_transferred` | boolean | Chuyển hồ sơ |
| `is_joined` | boolean | Nhập vụ án |
| `is_overdue` | boolean | Quá hạn luật định |
| `overdue_reason` | enum | chu_quan, khach_quan |
| `is_suspended` | boolean | Tạm đình chỉ |
| `suspension_count` | integer | Số lần tạm đình chỉ |
| `has_vbqppl_recommendation` | boolean | Có kiến nghị sửa đổi/bãi bỏ VBQPPL |

### 4.2. `kdtm_first_instance_result`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `case_id` | string | Khóa ngoại vụ việc |
| `is_dismissed` | boolean | Đình chỉ |
| `is_settlement_recognized` | boolean | Công nhận thỏa thuận |
| `is_tried_or_resolved` | boolean | Đã xét xử/giải quyết |
| `claim_result` | enum | khong_chap_nhan, chap_nhan_mot_phan, chap_nhan_toan_bo |
| `is_successful_mediation` | boolean | Hòa giải thành công |
| `has_precedent` | boolean | Áp dụng án lệ |
| `is_simplified_procedure` | boolean | Thủ tục rút gọn |
| `has_interim_measure` | boolean | Biện pháp khẩn cấp tạm thời |
| `has_cancelled_illegal_individual_decision` | boolean | Hủy quyết định cá biệt trái pháp luật |
| `has_procuracy_participation` | boolean | VKS tham gia |
| `has_lawyer` | boolean | Có luật sư |
| `has_other_protector` | boolean | Có người bảo vệ quyền lợi khác |

### 4.3. `kdtm_party`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `party_id` | string | Mã đương sự |
| `case_id` | string | Mã vụ việc |
| `role` | enum | nguyen_don, bi_don, nguoi_lien_quan |
| `party_type` | enum | doanh_nghiep_nha_nuoc, doi_tuong_khac |
| `has_foreign_element` | boolean | Có yếu tố nước ngoài |

### 4.4. `kdtm_appeal_review`

| Trường | Kiểu | Mô tả |
|---|---|---|
| `case_id` | string | Mã vụ việc |
| `review_type` | enum | phuc_tham, giam_doc_tham, tai_tham |
| `source` | enum | khang_cao, chanh_an_khang_nghi, vien_truong_khang_nghi |
| `is_withdrawn` | boolean | Rút kháng cáo/kháng nghị |
| `withdrawn_by` | enum | duong_su, chanh_an, vien_truong |
| `is_reviewed` | boolean | Đã xét xử |
| `result` | enum | giu_nguyen, sua_mot_phan, sua_toan_bo, huy_mot_phan, huy_toan_bo, huy_va_dinh_chi, dinh_chi_xet_xu |
| `error_source` | enum | cap_so_tham_sai, ly_do_khac |
| `has_precedent` | boolean | Áp dụng án lệ |

---

## 5. Mapping biểu mẫu và cột chỉ tiêu

### 5.1. KDTM_ST_4A - Thống kê thụ lý và giải quyết các vụ, việc kinh doanh thương mại sơ thẩm

| Cột | Chỉ tiêu |
|---:|---|
| 1 | Loại vụ án và việc KDTM |
| 2 | Cũ còn lại |
| 3 | Mới thụ lý |
| 4 | Chuyển hồ sơ |
| 5 | Nhập vụ án |
| 6 | Tổng số phải giải quyết |
| 7 | Đình chỉ |
| 8 | Công nhận thỏa thuận của đương sự |
| 9 | Xét xử/giải quyết - Không chấp nhận yêu cầu, đề nghị |
| 10 | Xét xử/giải quyết - Chấp nhận một phần yêu cầu, đề nghị |
| 11 | Xét xử/giải quyết - Chấp nhận toàn bộ yêu cầu, đề nghị |
| 12 | Xét xử/giải quyết - Tổng |
| 13 | Tổng số đã giải quyết |
| 14 | Tổng số còn lại |
| 15 | Quá hạn luật định - Nguyên nhân chủ quan |
| 16 | Quá hạn luật định - Nguyên nhân khách quan |
| 17 | Tạm đình chỉ - Tổng số |
| 18 | Tạm đình chỉ lần 2 |
| 19 | Tạm đình chỉ trên 2 lần |
| 20 | Tạm đình chỉ do kiến nghị VBQPPL |
| 21 | Áp dụng án lệ |
| 22 | Giải quyết theo thủ tục rút gọn |
| 23 | Áp dụng biện pháp khẩn cấp tạm thời |
| 24 | Quyết định cá biệt trái pháp luật bị Tòa án hủy |
| 25 | Viện kiểm sát tham gia |
| 26 | Có luật sư |
| 27 | Có người bảo vệ quyền, lợi ích hợp pháp khác |
| 28 | Nguyên đơn - Doanh nghiệp nhà nước |
| 29 | Nguyên đơn - Đối tượng khác |
| 30 | Nguyên đơn - Có yếu tố nước ngoài |
| 31 | Bị đơn - Doanh nghiệp nhà nước |
| 32 | Bị đơn - Đối tượng khác |
| 33 | Bị đơn - Có yếu tố nước ngoài |
| 34 | Phiên tòa rút kinh nghiệm |
| 35 | Hòa giải thành công |

### 5.2. KDTM_PT_4B - Thống kê thụ lý và giải quyết các vụ, việc kinh doanh thương mại phúc thẩm

| Cột | Chỉ tiêu |
|---:|---|
| 1 | Loại vụ án và việc KDTM |
| 2 | Cũ còn lại - Kháng cáo |
| 3 | Cũ còn lại - Kháng nghị |
| 4 | Mới thụ lý - Kháng cáo |
| 5 | Mới thụ lý - Kháng nghị |
| 6 | Tổng số phải giải quyết - Kháng cáo |
| 7 | Tổng số phải giải quyết - Kháng nghị |
| 8 | Tổng số phải giải quyết - Cộng |
| 9 | Đình chỉ - Rút kháng cáo |
| 10 | Đình chỉ - Rút kháng nghị |
| 11 | Đình chỉ lý do khác - Kháng cáo |
| 12 | Đình chỉ lý do khác - Kháng nghị |
| 13 | Đình chỉ - Cộng |
| 14 | Xét xử/giải quyết - Kháng cáo |
| 15 | Xét xử/giải quyết - Kháng nghị |
| 16 | Xét xử/giải quyết - Cộng |
| 17 | Tổng số đã giải quyết - Kháng cáo |
| 18 | Tổng số đã giải quyết - Kháng nghị |
| 19 | Tổng số đã giải quyết - Cộng |
| 20 | Còn lại - Kháng cáo |
| 21 | Còn lại - Kháng nghị |
| 22 | Còn lại - Cộng |
| 23 | Quá hạn - Nguyên nhân chủ quan |
| 24 | Quá hạn - Nguyên nhân khách quan |
| 25 | Tạm đình chỉ - Tổng số |
| 26 | Tạm đình chỉ lần 2 |
| 27 | Tạm đình chỉ trên 2 lần |
| 28 | Tạm đình chỉ do kiến nghị VBQPPL |
| 29 | Giữ nguyên bản án/quyết định sơ thẩm |
| 30 | Sửa một phần do cấp sơ thẩm sai |
| 31 | Sửa một phần do lý do khác |
| 32 | Sửa toàn bộ do cấp sơ thẩm sai |
| 33 | Sửa toàn bộ do lý do khác |
| 34 | Hủy một phần để giải quyết lại sơ thẩm do cấp sơ thẩm sai |
| 35 | Hủy một phần để giải quyết lại sơ thẩm do lý do khác |
| 36 | Hủy toàn bộ để giải quyết lại sơ thẩm do cấp sơ thẩm sai |
| 37 | Hủy toàn bộ để giải quyết lại sơ thẩm do lý do khác |
| 38 | Hủy và đình chỉ do cấp sơ thẩm sai |
| 39 | Hủy và đình chỉ do lý do khác |
| 40 | Đình chỉ xét xử phúc thẩm |
| 41 | VKS kháng nghị nhưng không được chấp nhận |
| 42 | VKS rút kháng nghị nhưng đương sự không rút kháng cáo |
| 43 | Áp dụng án lệ |
| 44 | Giải quyết theo thủ tục rút gọn |
| 45 | Áp dụng biện pháp khẩn cấp tạm thời |
| 46 | Viện kiểm sát tham gia |
| 47 | Có luật sư |
| 48 | Có người bảo vệ quyền, lợi ích hợp pháp khác |
| 49 | Phiên tòa rút kinh nghiệm |

### 5.3. KDTM_GDT_4C - Thống kê thụ lý và giải quyết các vụ, việc kinh doanh thương mại giám đốc thẩm

| Cột | Chỉ tiêu |
|---:|---|
| 1 | Loại vụ án và việc KDTM |
| 2 | Cũ còn lại - Chánh án kháng nghị |
| 3 | Cũ còn lại - Viện trưởng kháng nghị |
| 4 | Mới thụ lý - Chánh án kháng nghị |
| 5 | Mới thụ lý - Viện trưởng kháng nghị |
| 6 | Tổng phải giải quyết - Chánh án kháng nghị |
| 7 | Tổng phải giải quyết - Viện trưởng kháng nghị |
| 8 | Tổng phải giải quyết - Cộng |
| 9 | Đình chỉ GĐT - Chánh án rút kháng nghị |
| 10 | Đình chỉ GĐT - Viện trưởng rút kháng nghị |
| 11 | Đã xét xử - Chánh án kháng nghị |
| 12 | Đã xét xử - Viện trưởng kháng nghị |
| 13 | Tổng số đã giải quyết |
| 14 | Còn lại - Chánh án kháng nghị |
| 15 | Còn lại - Viện trưởng kháng nghị |
| 16 | Còn lại - Tổng số |
| 17 | Quá hạn - Nguyên nhân chủ quan |
| 18 | Quá hạn - Nguyên nhân khách quan |
| 19 | Giữ nguyên/không chấp nhận kháng nghị của Chánh án |
| 20 | Giữ nguyên/không chấp nhận kháng nghị của Viện trưởng |
| 21 | Sửa một phần bản án/quyết định có hiệu lực |
| 22 | Sửa toàn bộ bản án/quyết định có hiệu lực |
| 23 | Hủy bản án/quyết định có hiệu lực và đình chỉ |
| 24 | Hủy án/quyết định phúc thẩm, giữ nguyên sơ thẩm |
| 25 | Hủy quyết định GĐT, giữ nguyên sơ thẩm |
| 26 | Hủy quyết định GĐT, giữ nguyên phúc thẩm |
| 27 | Hủy QĐ GĐT và bản án/quyết định phúc thẩm, giữ nguyên sơ thẩm |
| 28 | Hủy bản án/quyết định có hiệu lực để xét xử lại sơ thẩm |
| 29 | Hủy bản án/quyết định có hiệu lực để xét xử lại phúc thẩm |
| 30 | Áp dụng án lệ |

### 5.4. KDTM_TT_4D - Thống kê thụ lý và giải quyết các vụ, việc kinh doanh thương mại tái thẩm

| Cột | Chỉ tiêu |
|---:|---|
| 1 | Loại vụ án và việc KDTM |
| 2 | Cũ còn lại - Chánh án kháng nghị |
| 3 | Cũ còn lại - Viện trưởng kháng nghị |
| 4 | Mới thụ lý - Chánh án kháng nghị |
| 5 | Mới thụ lý - Viện trưởng kháng nghị |
| 6 | Tổng phải giải quyết - Chánh án kháng nghị |
| 7 | Tổng phải giải quyết - Viện trưởng kháng nghị |
| 8 | Tổng phải giải quyết - Cộng |
| 9 | Đình chỉ tái thẩm - Chánh án rút kháng nghị |
| 10 | Đình chỉ tái thẩm - Viện trưởng rút kháng nghị |
| 11 | Đã xét xử - Chánh án kháng nghị |
| 12 | Đã xét xử - Viện trưởng kháng nghị |
| 13 | Tổng số đã giải quyết |
| 14 | Còn lại - Chánh án kháng nghị |
| 15 | Còn lại - Viện trưởng kháng nghị |
| 16 | Còn lại - Tổng số |
| 17 | Giữ nguyên/không chấp nhận kháng nghị của Chánh án |
| 18 | Giữ nguyên/không chấp nhận kháng nghị của Viện trưởng |
| 19 | Hủy bản án/quyết định có hiệu lực để xét xử sơ thẩm lại |
| 20 | Hủy bản án/quyết định có hiệu lực và đình chỉ |
| 21 | Áp dụng án lệ |

---

## 6. Công thức tính toán trọng tâm

Danh mục đầy đủ nằm trong `formula_catalog_kdtm.json`. Các công thức dưới đây là nhóm lõi thường dùng để sinh báo cáo và dashboard.

### 6.1. Sơ thẩm

```text
C6  = C2 + C3 - C4 + C5
C12 = C9 + C10 + C11
C13 = C7 + C8 + C12
C14 = C6 - C13
```

### 6.2. Phúc thẩm

```text
C6  = C2 + C4
C7  = C3 + C5
C8  = C6 + C7
C13 = C9 + C10 + C11 + C12
C16 = C14 + C15
C17 = C9 + C11 + C14
C18 = C10 + C12 + C15
C19 = C17 + C18 = C13 + C16
C20 = C6 - C17
C21 = C7 - C18
C22 = C20 + C21 = C8 - C19
```

### 6.3. Giám đốc thẩm

```text
C6  = C2 + C4
C7  = C3 + C5
C8  = C6 + C7
C13 = C9 + C10 + C11 + C12
C14 = C6 - C9 - C11
C15 = C7 - C10 - C12
C16 = C14 + C15 = C8 - C13
```

### 6.4. Tái thẩm

```text
C6  = C2 + C4
C7  = C3 + C5
C8  = C6 + C7
C13 = C9 + C10 + C11 + C12
C14 = C6 - C9 - C11
C15 = C7 - C10 - C12
C16 = C14 + C15 = C8 - C13
```

---

## 7. KPI lãnh đạo

### 7.1. KPI chung toàn loại án KDTM

| KPI | Công thức | Ý nghĩa |
|---|---|---|
| Tỷ lệ giải quyết | `đã_giải_quyết / phải_giải_quyết * 100` | Đo tiến độ xử lý án trong kỳ |
| Tỷ lệ tồn | `còn_lại / phải_giải_quyết * 100` | Đo áp lực án tồn |
| Tỷ lệ quá hạn | `quá_hạn / còn_lại * 100` | Cảnh báo vi phạm thời hạn |
| Tỷ lệ tạm đình chỉ | `tạm_đình_chỉ / còn_lại * 100` | Đánh giá nguyên nhân án tồn |
| Tỷ lệ áp dụng án lệ | `áp_dụng_án_lệ / đã_giải_quyết hoặc đã_xét_xử * 100` | Theo dõi áp dụng án lệ |

### 7.2. KPI sơ thẩm

- Tỷ lệ công nhận thỏa thuận của đương sự.
- Tỷ lệ hòa giải thành công.
- Tỷ lệ chấp nhận toàn bộ yêu cầu.
- Tỷ lệ chấp nhận một phần yêu cầu.
- Tỷ lệ không chấp nhận yêu cầu.
- Tỷ lệ vụ việc có yếu tố nước ngoài.
- Tỷ lệ vụ việc có luật sư/người bảo vệ quyền lợi.

### 7.3. KPI phúc thẩm

- Tỷ trọng kháng cáo, kháng nghị.
- Tỷ lệ giữ nguyên bản án/quyết định sơ thẩm.
- Tỷ lệ sửa án.
- Tỷ lệ sửa do lỗi cấp sơ thẩm.
- Tỷ lệ hủy án.
- Tỷ lệ hủy do lỗi cấp sơ thẩm.
- Tỷ lệ VKS kháng nghị nhưng không được chấp nhận.

### 7.4. KPI giám đốc thẩm, tái thẩm

- Tỷ lệ kháng nghị được/không được chấp nhận.
- Tỷ lệ sửa án/quyết định đã có hiệu lực.
- Tỷ lệ hủy án/quyết định đã có hiệu lực.
- Tỷ lệ hủy để xét xử lại sơ thẩm hoặc phúc thẩm.

---

## 8. Quy tắc kiểm tra dữ liệu

Danh mục đầy đủ nằm trong `validation_rules_kdtm.json`.

Nhóm kiểm tra chính:

1. Kiểm tra tổng phải giải quyết.
2. Kiểm tra tổng đã giải quyết.
3. Kiểm tra số còn lại.
4. Kiểm tra quá hạn không vượt số còn lại.
5. Kiểm tra tạm đình chỉ không vượt số còn lại.
6. Kiểm tra chi tiết tạm đình chỉ không vượt tổng tạm đình chỉ.
7. Kiểm tra phân tích kết quả xét xử không vượt tổng số đã xét xử.
8. Kiểm tra chỉ tiêu đặc điểm vụ việc không vượt tổng số đã giải quyết.

---

## 9. Gợi ý dashboard điều hành

### 9.1. Dashboard cấp tỉnh

- Tổng số KDTM phải giải quyết.
- Tổng số đã giải quyết.
- Tỷ lệ giải quyết.
- Tổng số còn lại.
- Tổng số quá hạn.
- Tổng số tạm đình chỉ.
- Số vụ việc có yếu tố nước ngoài.
- Số vụ việc hòa giải thành công.
- Số vụ việc áp dụng án lệ.

### 9.2. Dashboard chất lượng xét xử

- Số vụ phúc thẩm giữ nguyên.
- Số vụ phúc thẩm sửa án.
- Số vụ phúc thẩm hủy án.
- Số vụ sửa/hủy do lỗi cấp sơ thẩm.
- Số vụ giám đốc thẩm/tái thẩm hủy án đã có hiệu lực.

### 9.3. Dashboard theo đơn vị

- So sánh tỷ lệ giải quyết giữa các TAND khu vực.
- So sánh án tồn, quá hạn theo đơn vị.
- Xếp hạng đơn vị theo số vụ KDTM mới thụ lý.
- Cảnh báo đơn vị có tỷ lệ tồn/quá hạn cao.

### 9.4. Dashboard theo nhóm tranh chấp

- Mua bán hàng hóa.
- Cung ứng dịch vụ.
- Thế chấp, tín dụng, ngân hàng.
- Hợp đồng đầu tư.
- Đầu tư tài chính, ngân hàng.
- Các tranh chấp KDTM khác.

---

## 10. Quy trình sử dụng skill trong hệ thống

1. Nhận dữ liệu đầu vào từ phân hệ nhập liệu hoặc file Excel.
2. Chuẩn hóa vụ việc theo `kdtm_case`, `kdtm_party`, `kdtm_first_instance_result`, `kdtm_appeal_review`.
3. Xác định biểu mẫu cần sinh theo cấp xét xử.
4. Áp dụng mapping cột trong `column_mapping_kdtm.json`.
5. Tính công thức trong `formula_catalog_kdtm.json`.
6. Chạy kiểm tra trong `validation_rules_kdtm.json`.
7. Trả về báo cáo, cảnh báo sai lệch và KPI dashboard.
8. Xuất biểu mẫu thống kê theo đúng mẫu đang sử dụng.

---

## 11. Cảnh báo triển khai

- Không cho nhập tay vào các cột tổng nếu đã có công thức nguồn.
- Cần lưu vết số liệu theo kỳ để đối chiếu cũ còn lại/kỳ trước.
- Cần khóa logic tránh một vụ việc vừa tính vào kháng cáo vừa tính vào kháng nghị nếu quy tắc biểu mẫu yêu cầu ưu tiên một nguồn.
- Các chỉ tiêu đặc điểm như án lệ, thủ tục rút gọn, VKS tham gia, luật sư có thể đồng thời xảy ra; không nên cộng các chỉ tiêu này để so sánh bằng tổng đã giải quyết, chỉ kiểm tra từng chỉ tiêu không vượt tổng.
- Tỷ lệ phần trăm phải xử lý mẫu số bằng 0 bằng quy tắc `safe_divide`: nếu mẫu số = 0 thì trả về 0 hoặc `null` theo cấu hình báo cáo.
