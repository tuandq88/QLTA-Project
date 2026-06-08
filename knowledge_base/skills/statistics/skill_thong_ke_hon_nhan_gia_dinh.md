# Skill thống kê án Hôn nhân và gia đình hoàn chỉnh

**Phiên bản:** 1.0.0  
**Phạm vi:** Mẫu 3A, 3B, 3C, 3D về thụ lý và giải quyết các vụ, việc hôn nhân và gia đình.

## 1. Mục tiêu
Skill này dùng để sinh công thức thống kê, ánh xạ dữ liệu đầu vào, kiểm tra tính hợp lệ số liệu và tạo KPI/dashboard cho nhóm án Hôn nhân và gia đình trong hệ thống quản lý Tòa án.

## 2. Các biểu mẫu hỗ trợ

- **HNGD_ST_3A**: TOÀ ÁN NHÂN DÂN THỐNG KÊ THỤ LÝ VÀ GIẢI QUYẾT CÁC VỤ, VIỆC HÔN NHÂN VÀ GIA ĐÌNH SƠ THẨM Mẫu 3A; sheet `HonNhan_GiaDinh_SoTham`; 38 cột.
- **HNGD_PT_3B**: TOÀ ÁN NHÂN DÂN THỐNG KÊ THỤ LÝ VÀ GIẢI QUYẾT CÁC VỤ, VIỆC HÔN NHÂN VÀ GIA ĐÌNH PHÚC THẨM Mẫu 3B; sheet `HonNhan_GiaDinh_phuc_tham`; 49 cột.
- **HNGD_GDT_3C**: TOÀ ÁN NHÂN DÂN THỐNG KÊ THỤ LÝ VÀ GIẢI QUYẾT CÁC VỤ, VIỆC HÔN NHÂN VÀ GIA ĐÌNH GIÁM ĐỐC THẨM Mẫu 3C; sheet `HonNhan_GiaDinh_GĐT`; 30 cột.
- **HNGD_TT_3D**: TOÀ ÁN NHÂN DÂN THỐNG KÊ THỤ LÝ VÀ GIẢI QUYẾT CÁC VỤ, VIỆC HÔN NHÂN VÀ GIA ĐÌNH TÁI THẨM Mẫu 3D; sheet `HonNhan_GiaDinh_TT`; 21 cột.

## 3. Nguyên tắc nghiệp vụ chung
- Mỗi dòng thống kê là một loại vụ án/việc hoặc nguyên nhân/nhóm tranh chấp trong biểu mẫu.
- Các cột “Tổng số”, “Cộng”, “Còn lại” là cột công thức, không nhập tay trong hệ thống trừ khi có cơ chế hiệu chỉnh kèm nhật ký.
- Các cột “Trong đó” là chỉ tiêu con, dùng để phân tích; không cộng trùng vào tổng nếu đã nằm trong nhóm tổng.
- Số liệu quá hạn phân tách theo nguyên nhân chủ quan/khách quan; tổng quá hạn không vượt số còn lại.
- Số tạm đình chỉ lần 2/trên 2 lần/kiến nghị VBQPPL là phân tích trong tổng tạm đình chỉ.
- Ở phúc thẩm, nếu có cả kháng cáo và kháng nghị thì cần ưu tiên luồng kháng nghị khi quy định biểu mẫu yêu cầu tránh tính trùng.
- Ở giám đốc thẩm/tái thẩm, số liệu luôn tách theo nguồn kháng nghị của Chánh án và Viện trưởng.

## 4. Data Dictionary lõi

- `case_id` (string): Mã vụ/việc duy nhất
- `case_group` (enum): Nhóm vụ án/việc HNGĐ Giá trị: vu_an_ly_hon, vu_an_hon_nhan_gia_dinh_khac, viec_hon_nhan_gia_dinh.
- `case_subtype` (string): Loại tranh chấp/yêu cầu: ly hôn, nuôi con, chia tài sản sau ly hôn, hủy kết hôn trái pháp luật...
- `court_id` (string): Mã đơn vị Tòa án
- `period_start` (date): 
- `period_end` (date): 
- `procedure_level` (enum):  Giá trị: so_tham, phuc_tham, giam_doc_tham, tai_tham.
- `old_pending` (boolean/count): Cũ còn lại từ kỳ trước
- `newly_accepted` (boolean/count): Mới thụ lý trong kỳ
- `transferred_out` (boolean/count): Chuyển hồ sơ sang Tòa án khác
- `merged_case` (boolean/count): Nhập vụ án, chỉ áp dụng sơ thẩm
- `resolved_status` (enum):  Giá trị: dinh_chi, cong_nhan_thoa_thuan, khong_chap_nhan_yeu_cau, chap_nhan_yeu_cau, xet_xu_giai_quyet, rut_khang_cao, rut_khang_nghi, ly_do_khac.
- `remaining_status` (enum):  Giá trị: con_lai, qua_han_chu_quan, qua_han_khach_quan, tam_dinh_chi.
- `suspension_repeat_level` (enum):  Giá trị: lan_1, lan_2, tren_2_lan.
- `ca_tandtc_recommendation` (boolean): Có văn bản kiến nghị cơ quan có thẩm quyền xem xét VBQPPL
- `appeal_source` (enum):  Giá trị: khang_cao, khang_nghi.
- `protest_authority` (enum):  Giá trị: chanh_an, vien_truong.
- `protest_withdrawn` (boolean): 
- `trial_result_appellate` (enum):  Giá trị: giu_nguyen, sua_mot_phan_so_tham_sai, sua_mot_phan_ly_do_khac, sua_toan_bo_so_tham_sai, sua_toan_bo_ly_do_khac, huy_mot_phan_so_tham_sai, huy_toan_bo_so_tham_sai, huy_va_dinh_chi, dinh_chi_phuc_tham_giu_nguyen_so_tham.
- `trial_result_gdt` (enum):  Giá trị: khong_chap_nhan_khang_nghi, sua_mot_phan, sua_toan_bo, huy_dinh_chi, huy_phuc_tham_giu_so_tham, huy_gdt_giu_so_tham, huy_gdt_giu_phuc_tham, huy_de_so_tham_lai, huy_de_phuc_tham_lai.
- `trial_result_tt` (enum):  Giá trị: khong_chap_nhan_khang_nghi, huy_de_so_tham_lai, huy_va_dinh_chi.
- `applied_precedent` (boolean): 
- `summary_procedure` (boolean): 
- `provisional_measure` (boolean): 
- `invalid_individual_decision_cancelled` (boolean/count): 
- `third_party_public_interest_lawsuit` (boolean): 
- `procuracy_participation` (boolean): 
- `lawyer_participation` (boolean): 
- `other_protector_participation` (boolean): 
- `divorce_reconciled_reunion` (boolean): 
- `divorce_not_accepted` (boolean): 
- `not_recognized_as_spouses` (boolean): 
- `divorce_accepted` (boolean): 
- `spouses_18_to_30` (boolean): 
- `children_under_18_count` (integer): 
- `female_children_under_18_count` (integer): 
- `children_under_7_count` (integer): 
- `foreign_element` (boolean): 
- `experience_trial` (boolean): 
- `successful_mediation` (boolean): 

## 5. Công thức cột theo từng biểu mẫu

### HNGD_ST_3A

- **HNGD_ST_3A_C06** — Cột 6: `C2 + C3 - C4 + C5` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số
- **HNGD_ST_3A_C15** — Cột 15: `C7 + C9 + C10 + C13` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Tổng cộng
- **HNGD_ST_3A_C16** — Cột 16: `C6 - C15` — SỐ VỤ VIỆC CÒN LẠI > Tổng số
### HNGD_PT_3B

- **HNGD_PT_3B_C06** — Cột 6: `C2 + C4` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Kháng cáo
- **HNGD_PT_3B_C07** — Cột 7: `C3 + C5` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Kháng nghị
- **HNGD_PT_3B_C08** — Cột 8: `C6 + C7` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Cộng
- **HNGD_PT_3B_C13** — Cột 13: `C9 + C10 + C11 + C12` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ > Cộng
- **HNGD_PT_3B_C16** — Cột 16: `C14 + C15` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Xét xử hoặc giải quyết > Cộng
- **HNGD_PT_3B_C17** — Cột 17: `C9 + C11 + C14` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số > Kháng cáo
- **HNGD_PT_3B_C18** — Cột 18: `C10 + C12 + C15` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số > Kháng nghị
- **HNGD_PT_3B_C19** — Cột 19: `C17 + C18` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số > Cộng
- **HNGD_PT_3B_C20** — Cột 20: `C6 - C17` — SỐ VỤ, VIỆC CÒN LẠI > Tổng số > Kháng cáo
- **HNGD_PT_3B_C21** — Cột 21: `C7 - C18` — SỐ VỤ, VIỆC CÒN LẠI > Tổng số > Kháng nghị
- **HNGD_PT_3B_C22** — Cột 22: `C20 + C21` — SỐ VỤ, VIỆC CÒN LẠI > Tổng số > Cộng
### HNGD_GDT_3C

- **HNGD_GDT_3C_C06** — Cột 6: `C2 + C4` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Chánh án kháng nghị
- **HNGD_GDT_3C_C07** — Cột 7: `C3 + C5` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Viện trưởng kháng nghị
- **HNGD_GDT_3C_C08** — Cột 8: `C6 + C7` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Cộng
- **HNGD_GDT_3C_C13** — Cột 13: `C9 + C10 + C11 + C12` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số
- **HNGD_GDT_3C_C14** — Cột 14: `C6 - C9 - C11` — SỐ VỤ, VIỆC CÒN LẠI > Chánh án kháng nghị
- **HNGD_GDT_3C_C15** — Cột 15: `C7 - C10 - C12` — SỐ VỤ, VIỆC CÒN LẠI > Viện trưởng kháng nghị
- **HNGD_GDT_3C_C16** — Cột 16: `C14 + C15` — SỐ VỤ, VIỆC CÒN LẠI > Tổng số
### HNGD_TT_3D

- **HNGD_TT_3D_C06** — Cột 6: `C2 + C4` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Chánh án kháng nghị
- **HNGD_TT_3D_C07** — Cột 7: `C3 + C5` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Viện trưởng kháng nghị
- **HNGD_TT_3D_C08** — Cột 8: `C6 + C7` — SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Cộng
- **HNGD_TT_3D_C13** — Cột 13: `C9 + C10 + C11 + C12` — SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số
- **HNGD_TT_3D_C14** — Cột 14: `C6 - C9 - C11` — SỐ VỤ, VIỆC CÒN LẠI > Chánh án kháng nghị
- **HNGD_TT_3D_C15** — Cột 15: `C7 - C10 - C12` — SỐ VỤ, VIỆC CÒN LẠI > Viện trưởng kháng nghị
- **HNGD_TT_3D_C16** — Cột 16: `C14 + C15` — SỐ VỤ, VIỆC CÒN LẠI > Tổng số

## 6. Mapping cột chi tiết

### HNGD_ST_3A

- C1: LOẠI VỤ ÁN VÀ VIỆC HÔN NHÂN VÀ GIA ĐÌNH — nguồn: category
- C2: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại — nguồn: manual
- C3: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý — nguồn: manual
- C4: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Chuyển hồ sơ — nguồn: manual
- C5: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Nhập vụ án — nguồn: manual
- C6: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số — nguồn: formula; formula `C2 + C3 - C4 + C5`
- C7: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Đình chỉ > Tổng số — nguồn: manual
- C8: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Đình chỉ > Hòa giải đoàn tụ thành — nguồn: manual
- C9: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Công nhận thoả thuận của đương sự — nguồn: manual
- C10: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Không chấp nhận (công nhận) yêu cầu của đương sự > Tổng số — nguồn: manual
- C11: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Không chấp nhận (công nhận) yêu cầu của đương sự > Số vụ án không chấp nhận đơn xin ly hôn — nguồn: manual
- C12: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Không chấp nhận (công nhận) yêu cầu của đương sự > Số việc không công nhận là vợ chồng — nguồn: manual
- C13: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Chấp nhận (công nhận) yêu cầu của đương sự > Tổng số — nguồn: manual
- C14: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Chấp nhận (công nhận) yêu cầu của đương sự > Số vụ án cho ly hôn — nguồn: manual
- C15: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT, XÉT XỬ > Tổng cộng — nguồn: formula; formula `C7 + C9 + C10 + C13`
- C16: SỐ VỤ VIỆC CÒN LẠI > Tổng số — nguồn: formula; formula `C6 - C15`
- C17: SỐ VỤ VIỆC CÒN LẠI > Quá hạn luật định > Nguyên nhân chủ quan — nguồn: manual
- C18: SỐ VỤ VIỆC CÒN LẠI > Quá hạn luật định > Nguyên nhân khách quan — nguồn: manual
- C19: SỐ VỤ VIỆC CÒN LẠI > Tạm đình chỉ > Tổng số — nguồn: manual
- C20: SỐ VỤ VIỆC CÒN LẠI > Tạm đình chỉ > Trong đó > Tạm đình chỉ lần 2 — nguồn: manual
- C21: SỐ VỤ VIỆC CÒN LẠI > Tạm đình chỉ > Trong đó > Tạm đình chỉ trên 2 lần — nguồn: manual
- C22: SỐ VỤ VIỆC CÒN LẠI > Tạm đình chỉ > Trong đó > Chánh án TANDTC có văn bản kiến nghị cơ quan nhà nước có thẩm quyền xem xét, sửa đổi, bổ sung hoặc bãi bỏ VBQPPL — nguồn: manual
- C23: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Áp dụng án lệ — nguồn: manual
- C24: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Giải quyết vụ án theo thủ tục rút gọn — nguồn: manual
- C25: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Áp dụng biện pháp khẩn cấp tạm thời — nguồn: manual
- C26: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Số quyết định cá biệt trái pháp luật của cơ quan, tổ chức bị Tòa án hủy — nguồn: manual
- C27: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Cơ quan, tổ chức khởi kiện bảo vệ quyền và lợi ích hợp pháp của người khác, lợi ích công cộng và nhà nước — nguồn: manual
- C28: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Viện kiểm sát tham gia — nguồn: manual
- C29: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Người bảo vệ quyền, lợi ích hợp pháp cho đương sự > Luật sư — nguồn: manual
- C30: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT > Người bảo vệ quyền, lợi ích hợp pháp cho đương sự > Người bảo vệ quyền, lợi ích hợp pháp khác — nguồn: manual
- C31: ĐẶC ĐIỂM VỢ, CHỒNG, CON TRONG VỤ ÁN LY HÔN ĐÃ GIẢI QUYẾT > Vợ chồng từ 18 đến 30 tuổi — nguồn: manual
- C32: ĐẶC ĐIỂM VỢ, CHỒNG, CON TRONG VỤ ÁN LY HÔN ĐÃ GIẢI QUYẾT > Số con dưới 18 tuổi > Tổng số — nguồn: manual
- C33: ĐẶC ĐIỂM VỢ, CHỒNG, CON TRONG VỤ ÁN LY HÔN ĐÃ GIẢI QUYẾT > Số con dưới 18 tuổi > Trong đó > Nữ — nguồn: manual
- C34: ĐẶC ĐIỂM VỢ, CHỒNG, CON TRONG VỤ ÁN LY HÔN ĐÃ GIẢI QUYẾT > Số con dưới 18 tuổi > Trong đó > Số con dưới 7 tuổi — nguồn: manual
- C35: ĐẶC ĐIỂM VỢ, CHỒNG, CON TRONG VỤ ÁN LY HÔN ĐÃ GIẢI QUYẾT > Có yếu tố nước ngoài — nguồn: manual
- C36: Số vụ án Tòa án tổ chức phiên tòa rút kinh nghiệm — nguồn: manual
- C37: Số vụ án Tòa án tổ chức hòa giải thành công — nguồn: manual
### HNGD_PT_3B

- C1: LOẠI VỤ ÁN VÀ VIỆC HÔN NHÂN VÀ GIA ĐÌNH — nguồn: category
- C2: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại > Kháng cáo — nguồn: manual
- C3: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại > Kháng nghị — nguồn: manual
- C4: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý > Kháng cáo — nguồn: manual
- C5: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý > Kháng nghị — nguồn: manual
- C6: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Kháng cáo — nguồn: formula; formula `C2 + C4`
- C7: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Kháng nghị — nguồn: formula; formula `C3 + C5`
- C8: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Cộng — nguồn: formula; formula `C6 + C7`
- C9: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ > Rút kháng cáo — nguồn: manual
- C10: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ > Rút kháng nghị — nguồn: manual
- C11: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ > Lý do khác > Kháng cáo — nguồn: manual
- C12: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ > Lý do khác > Kháng nghị — nguồn: manual
- C13: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ > Cộng — nguồn: formula; formula `C9 + C10 + C11 + C12`
- C14: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Xét xử hoặc giải quyết > Kháng cáo — nguồn: manual
- C15: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Xét xử hoặc giải quyết > Kháng nghị — nguồn: manual
- C16: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Xét xử hoặc giải quyết > Cộng — nguồn: formula; formula `C14 + C15`
- C17: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số > Kháng cáo — nguồn: formula; formula `C9 + C11 + C14`
- C18: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số > Kháng nghị — nguồn: formula; formula `C10 + C12 + C15`
- C19: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số > Cộng — nguồn: formula; formula `C17 + C18`
- C20: SỐ VỤ, VIỆC CÒN LẠI > Tổng số > Kháng cáo — nguồn: formula; formula `C6 - C17`
- C21: SỐ VỤ, VIỆC CÒN LẠI > Tổng số > Kháng nghị — nguồn: formula; formula `C7 - C18`
- C22: SỐ VỤ, VIỆC CÒN LẠI > Tổng số > Cộng — nguồn: formula; formula `C20 + C21`
- C23: SỐ VỤ, VIỆC CÒN LẠI > Quá hạn luật định > Nguyên nhân chủ quan — nguồn: manual
- C24: SỐ VỤ, VIỆC CÒN LẠI > Quá hạn luật định > Nguyên nhân khách quan — nguồn: manual
- C25: SỐ VỤ, VIỆC CÒN LẠI > Tạm đình chỉ > Tổng số — nguồn: manual
- C26: SỐ VỤ, VIỆC CÒN LẠI > Tạm đình chỉ > Trong đó > Tạm đình chỉ lần 2 — nguồn: manual
- C27: SỐ VỤ, VIỆC CÒN LẠI > Tạm đình chỉ > Trong đó > Tạm đình chỉ trên 2 lần — nguồn: manual
- C28: SỐ VỤ, VIỆC CÒN LẠI > Tạm đình chỉ > Trong đó > Chánh án TANDTC có văn bản kiến nghị cơ quan nhà nước có thẩm quyền xem xét, sửa đổi, bổ sung hoặc bãi bỏ VBQPPL do có dấu hiệu trái PL — nguồn: manual
- C29: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Giữ nguyên bản án, quyết định sơ thẩm — nguồn: manual
- C30: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Sửa một phần bản án, quyết định sơ thẩm > Do cấp sơ thẩm sai — nguồn: manual
- C31: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Sửa một phần bản án, quyết định sơ thẩm > Lý do khác — nguồn: manual
- C32: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Sửa toàn bộ bản án, quyết định sơ thẩm > Do cấp sơ thẩm sai — nguồn: manual
- C33: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Sửa toàn bộ bản án, quyết định sơ thẩm > Lý do khác — nguồn: manual
- C34: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Hủy một phần bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm > Do cấp sơ thẩm sai — nguồn: manual
- C35: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Hủy một phần bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm > Lý do khác — nguồn: manual
- C36: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Hủy toàn bộ bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm > Do cấp sơ thẩm sai — nguồn: manual
- C37: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Hủy toàn bộ bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm > Lý do khác — nguồn: manual
- C38: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Hủy bản án, quyết định sơ thẩm và đình chỉ giải quyết vụ án > Do cấp sơ thẩm sai — nguồn: manual
- C39: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Hủy bản án, quyết định sơ thẩm và đình chỉ giải quyết vụ án > Lý do khác — nguồn: manual
- C40: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Đình chỉ xét xử phúc thẩm và giữ nguyên bản án sơ thẩm — nguồn: manual
- C41: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Số vụ việc Viện kiểm sát có kháng nghị nhưng không được chấp nhận — nguồn: manual
- C42: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Số vụ việc VKS rút kháng nghị nhưng đương sự không rút kháng cáo — nguồn: manual
- C43: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Áp dụng án lệ — nguồn: manual
- C44: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Giải quyết vụ án theo thủ tục rút gọn — nguồn: manual
- C45: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Áp dụng biện pháp khẩn cấp tạm thời — nguồn: manual
- C46: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Viện kiểm sát tham gia — nguồn: manual
- C47: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Có người bảo vệ quyền, lợi ích hợp pháp cho đương sự > Luật sư — nguồn: manual
- C48: ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ XÉT XỬ, GIẢI QUYẾT > Có người bảo vệ quyền, lợi ích hợp pháp cho đương sự > Người bảo vệ quyền, lợi ích hợp pháp khác — nguồn: manual
- C49: Số vụ án Tòa án tổ chức phiên tòa rút kinh nghiệm — nguồn: manual
### HNGD_GDT_3C

- C1: LOẠI VỤ ÁN VÀ VIỆC HÔN NHÂN VÀ GIA ĐÌNH — nguồn: category
- C2: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại > Chánh án kháng nghị — nguồn: manual
- C3: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại > Viện trưởng kháng nghị — nguồn: manual
- C4: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý > Chánh án kháng nghị — nguồn: manual
- C5: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý > Viện trưởng kháng nghị — nguồn: manual
- C6: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Chánh án kháng nghị — nguồn: formula; formula `C2 + C4`
- C7: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Viện trưởng kháng nghị — nguồn: formula; formula `C3 + C5`
- C8: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Cộng — nguồn: formula; formula `C6 + C7`
- C9: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ xét xử giám đốc thẩm > Chánh án rút kháng nghị — nguồn: manual
- C10: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ xét xử giám đốc thẩm > Viện trưởng rút kháng nghị — nguồn: manual
- C11: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đã xét xử > Chánh án kháng nghị — nguồn: manual
- C12: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đã xét xử > Viện trưởng kháng nghị — nguồn: manual
- C13: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số — nguồn: formula; formula `C9 + C10 + C11 + C12`
- C14: SỐ VỤ, VIỆC CÒN LẠI > Chánh án kháng nghị — nguồn: formula; formula `C6 - C9 - C11`
- C15: SỐ VỤ, VIỆC CÒN LẠI > Viện trưởng kháng nghị — nguồn: formula; formula `C7 - C10 - C12`
- C16: SỐ VỤ, VIỆC CÒN LẠI > Tổng số — nguồn: formula; formula `C14 + C15`
- C17: SỐ VỤ, VIỆC CÒN LẠI > Quá hạn luật định > Nguyên nhân chủ quan — nguồn: manual
- C18: SỐ VỤ, VIỆC CÒN LẠI > Quá hạn luật định > Nguyên nhân khách quan — nguồn: manual
- C19: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Giữ nguyên bản án, quyết định có hiệu lực pháp luật > Không chấp nhận kháng nghị của Chánh án — nguồn: manual
- C20: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Giữ nguyên bản án, quyết định có hiệu lực pháp luật > Không chấp nhận kháng nghị của Viện trưởng — nguồn: manual
- C21: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Sửa một phần bản án, quyết định của Tòa án đã có hiệu lực pháp luật — nguồn: manual
- C22: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Sửa toàn bộ bản án, quyết định của Tòa án đã có hiệu lực pháp luật — nguồn: manual
- C23: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy bản án, quyết định có hiệu lực pháp luật và đình chỉ giải quyết vụ án — nguồn: manual
- C24: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy bản án, quyết định phúc thẩm, giữ nguyên bản án, quyết định sơ thẩm — nguồn: manual
- C25: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định sơ thẩm — nguồn: manual
- C26: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định phúc thẩm — nguồn: manual
- C27: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy quyết định của giám đốc thẩm,bản án quyết định phúc thẩm,giữ nguyên bản án,quyết định sơ thẩm — nguồn: manual
- C28: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục sơ thẩm — nguồn: manual
- C29: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục phúc thẩm — nguồn: manual
- C30: Áp dụng án lệ — nguồn: manual
### HNGD_TT_3D

- C1: LOẠI VỤ ÁN VÀ VIỆC HÔN NHÂN VÀ GIA ĐÌNH — nguồn: category
- C2: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại > Chánh án kháng nghị — nguồn: manual
- C3: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Cũ còn lại > Viện trưởng kháng nghị — nguồn: manual
- C4: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý > Chánh án kháng nghị — nguồn: manual
- C5: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Mới thụ lý > Viện trưởng kháng nghị — nguồn: manual
- C6: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Chánh án kháng nghị — nguồn: formula; formula `C2 + C4`
- C7: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Viện trưởng kháng nghị — nguồn: formula; formula `C3 + C5`
- C8: SỐ VỤ, VIỆC PHẢI GIẢI QUYẾT > Tổng số > Cộng — nguồn: formula; formula `C6 + C7`
- C9: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ xét xử tái thẩm > Chánh án rút kháng nghị — nguồn: manual
- C10: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đình chỉ xét xử tái thẩm > Viện trưởng rút kháng nghị — nguồn: manual
- C11: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đã xét xử > Chánh án kháng nghị — nguồn: manual
- C12: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Đã xét xử > Viện trưởng kháng nghị — nguồn: manual
- C13: SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT > Tổng số — nguồn: formula; formula `C9 + C10 + C11 + C12`
- C14: SỐ VỤ, VIỆC CÒN LẠI > Chánh án kháng nghị — nguồn: formula; formula `C6 - C9 - C11`
- C15: SỐ VỤ, VIỆC CÒN LẠI > Viện trưởng kháng nghị — nguồn: formula; formula `C7 - C10 - C12`
- C16: SỐ VỤ, VIỆC CÒN LẠI > Tổng số — nguồn: formula; formula `C14 + C15`
- C17: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Giữ nguyên bản án, quyết định có hiệu lực pháp luật > Không chấp nhận kháng nghị của Chánh án — nguồn: manual
- C18: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Giữ nguyên bản án, quyết định có hiệu lực pháp luật > Không chấp nhận kháng nghị của Viên trưởng — nguồn: manual
- C19: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy bản án, quyết định đã có hiệu lực pháp luật để xét xử sơ thẩm lại — nguồn: manual
- C20: PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ > Hủy bản án, quyết định đã có hiệu lực pháp luật và đình chỉ giải quyết vụ án — nguồn: manual
- C21: Áp dụng án lệ — nguồn: manual

## 7. Validation Rules

- **HNGD_ST_3A_NON_NEGATIVE** (HNGD_ST_3A): `all_numeric_columns >= 0` — Tất cả số liệu đếm phải là số nguyên không âm
- **HNGD_ST_3A_INTEGER** (HNGD_ST_3A): `all_count_columns are integers` — Các cột số lượng vụ/việc phải là số nguyên
- **HNGD_PT_3B_NON_NEGATIVE** (HNGD_PT_3B): `all_numeric_columns >= 0` — Tất cả số liệu đếm phải là số nguyên không âm
- **HNGD_PT_3B_INTEGER** (HNGD_PT_3B): `all_count_columns are integers` — Các cột số lượng vụ/việc phải là số nguyên
- **HNGD_GDT_3C_NON_NEGATIVE** (HNGD_GDT_3C): `all_numeric_columns >= 0` — Tất cả số liệu đếm phải là số nguyên không âm
- **HNGD_GDT_3C_INTEGER** (HNGD_GDT_3C): `all_count_columns are integers` — Các cột số lượng vụ/việc phải là số nguyên
- **HNGD_TT_3D_NON_NEGATIVE** (HNGD_TT_3D): `all_numeric_columns >= 0` — Tất cả số liệu đếm phải là số nguyên không âm
- **HNGD_TT_3D_INTEGER** (HNGD_TT_3D): `all_count_columns are integers` — Các cột số lượng vụ/việc phải là số nguyên
- **HNGD_ST_3A_R001** (HNGD_ST_3A): `C6 == C2 + C3 - C4 + C5` — Tổng số phải giải quyết bằng cũ còn lại + mới thụ lý - chuyển hồ sơ + nhập vụ án
- **HNGD_ST_3A_R002** (HNGD_ST_3A): `C15 == C7 + C9 + C10 + C13` — Tổng đã giải quyết bằng đình chỉ + công nhận thỏa thuận + không chấp nhận + chấp nhận yêu cầu
- **HNGD_ST_3A_R003** (HNGD_ST_3A): `C16 == C6 - C15` — Còn lại bằng phải giải quyết trừ đã giải quyết
- **HNGD_ST_3A_R004** (HNGD_ST_3A): `C8 <= C7` — Hòa giải đoàn tụ thành là chỉ tiêu trong nhóm đình chỉ
- **HNGD_ST_3A_R005** (HNGD_ST_3A): `C11 <= C10 and C12 <= C10` — Chỉ tiêu chi tiết không chấp nhận yêu cầu không vượt tổng nhóm
- **HNGD_ST_3A_R006** (HNGD_ST_3A): `C14 <= C13` — Số vụ án cho ly hôn không vượt tổng chấp nhận yêu cầu
- **HNGD_ST_3A_R007** (HNGD_ST_3A): `C17 + C18 <= C16` — Quá hạn chủ quan + khách quan không vượt tổng còn lại
- **HNGD_ST_3A_R008** (HNGD_ST_3A): `C19 <= C16` — Tạm đình chỉ không vượt tổng còn lại
- **HNGD_ST_3A_R009** (HNGD_ST_3A): `C20 <= C19 and C21 <= C19 and C22 <= C19` — Các chỉ tiêu trong đó của tạm đình chỉ không vượt tổng tạm đình chỉ
- **HNGD_ST_3A_R010** (HNGD_ST_3A): `C29 + C30 <= C15` — Vụ có người bảo vệ quyền, lợi ích hợp pháp không vượt đã giải quyết
- **HNGD_ST_3A_R011** (HNGD_ST_3A): `C33 <= C32 and C34 <= C32` — Số con nữ/dưới 7 tuổi là chi tiết của số con dưới 18 tuổi
- **HNGD_ST_3A_R012** (HNGD_ST_3A): `C31 <= C14` — Vợ chồng 18-30 tuổi chỉ áp dụng nhóm vụ án ly hôn đã được chấp nhận
- **HNGD_ST_3A_R013** (HNGD_ST_3A): `C35 <= C15` — Yếu tố nước ngoài không vượt tổng đã giải quyết
- **HNGD_ST_3A_R014** (HNGD_ST_3A): `C36 <= C15 and C37 <= C15` — Phiên tòa rút kinh nghiệm/hòa giải thành công không vượt tổng đã giải quyết
- **HNGD_PT_3B_R001** (HNGD_PT_3B): `C6 == C2 + C4` — Tổng kháng cáo phải giải quyết = cũ kháng cáo + mới kháng cáo
- **HNGD_PT_3B_R002** (HNGD_PT_3B): `C7 == C3 + C5` — Tổng kháng nghị phải giải quyết = cũ kháng nghị + mới kháng nghị
- **HNGD_PT_3B_R003** (HNGD_PT_3B): `C8 == C6 + C7` — Tổng cộng phải giải quyết = kháng cáo + kháng nghị
- **HNGD_PT_3B_R004** (HNGD_PT_3B): `C13 == C9 + C10 + C11 + C12` — Đình chỉ cộng = rút kháng cáo + rút kháng nghị + lý do khác
- **HNGD_PT_3B_R005** (HNGD_PT_3B): `C16 == C14 + C15` — Xét xử/giải quyết cộng = kháng cáo + kháng nghị
- **HNGD_PT_3B_R006** (HNGD_PT_3B): `C17 == C9 + C11 + C14` — Tổng đã giải quyết kháng cáo
- **HNGD_PT_3B_R007** (HNGD_PT_3B): `C18 == C10 + C12 + C15` — Tổng đã giải quyết kháng nghị
- **HNGD_PT_3B_R008** (HNGD_PT_3B): `C19 == C17 + C18` — Tổng đã giải quyết = kháng cáo + kháng nghị
- **HNGD_PT_3B_R009** (HNGD_PT_3B): `C20 == C6 - C17 and C21 == C7 - C18 and C22 == C20 + C21` — Còn lại đúng theo từng nguồn kháng cáo/kháng nghị
- **HNGD_PT_3B_R010** (HNGD_PT_3B): `C23 + C24 <= C22` — Quá hạn không vượt tổng còn lại
- **HNGD_PT_3B_R011** (HNGD_PT_3B): `C25 <= C22` — Tạm đình chỉ không vượt tổng còn lại
- **HNGD_PT_3B_R012** (HNGD_PT_3B): `C26 <= C25 and C27 <= C25 and C28 <= C25` — Chi tiết tạm đình chỉ không vượt tổng tạm đình chỉ
- **HNGD_PT_3B_R013** (HNGD_PT_3B): `C30 + C31 + C32 + C33 + C34 + C35 + C36 + C37 + C38 + C39 + C29 + C40 <= C16` — Phân tích kết quả xét xử không vượt tổng xét xử/giải quyết
- **HNGD_PT_3B_R014** (HNGD_PT_3B): `C30 + C32 + C34 + C36 + C38 <= C16` — Các trường hợp do sơ thẩm sai không vượt tổng xét xử/giải quyết
- **HNGD_PT_3B_R015** (HNGD_PT_3B): `C41 <= C15` — VKS kháng nghị không được chấp nhận không vượt số xét xử kháng nghị
- **HNGD_PT_3B_R016** (HNGD_PT_3B): `C42 <= C10 + C15` — VKS rút kháng nghị nhưng đương sự không rút kháng cáo cần đối chiếu nhóm kháng nghị
- **HNGD_PT_3B_R017** (HNGD_PT_3B): `C47 + C48 <= C19` — Có người bảo vệ quyền, lợi ích hợp pháp không vượt tổng đã giải quyết
- **HNGD_PT_3B_R018** (HNGD_PT_3B): `C49 <= C19` — Phiên tòa rút kinh nghiệm không vượt tổng đã giải quyết
- **HNGD_GDT_3C_R001** (HNGD_GDT_3C): `C6 == C2 + C4 and C7 == C3 + C5 and C8 == C6 + C7` — Tổng phải giải quyết đúng theo nguồn kháng nghị
- **HNGD_GDT_3C_R002** (HNGD_GDT_3C): `C13 == C9 + C10 + C11 + C12` — Tổng đã giải quyết = rút kháng nghị + đã xét xử
- **HNGD_GDT_3C_R003** (HNGD_GDT_3C): `C14 == C6 - C9 - C11 and C15 == C7 - C10 - C12 and C16 == C14 + C15` — Còn lại đúng theo nguồn kháng nghị
- **HNGD_GDT_3C_R004** (HNGD_GDT_3C): `C17 + C18 <= C16` — Quá hạn không vượt tổng còn lại
- **HNGD_GDT_3C_R005** (HNGD_GDT_3C): `C19 + C20 + C21 + C22 + C23 + C24 + C25 + C26 + C27 + C28 + C29 <= C11 + C12` — Phân tích kết quả xét xử không vượt số đã xét xử
- **HNGD_GDT_3C_R006** (HNGD_GDT_3C): `C19 <= C11 and C20 <= C12` — Không chấp nhận kháng nghị đúng nguồn Chánh án/Viện trưởng
- **HNGD_GDT_3C_R007** (HNGD_GDT_3C): `C30 <= C11 + C12` — Áp dụng án lệ không vượt số đã xét xử
- **HNGD_TT_3D_R001** (HNGD_TT_3D): `C6 == C2 + C4 and C7 == C3 + C5 and C8 == C6 + C7` — Tổng phải giải quyết đúng theo nguồn kháng nghị
- **HNGD_TT_3D_R002** (HNGD_TT_3D): `C13 == C9 + C10 + C11 + C12` — Tổng đã giải quyết = rút kháng nghị + đã xét xử
- **HNGD_TT_3D_R003** (HNGD_TT_3D): `C14 == C6 - C9 - C11 and C15 == C7 - C10 - C12 and C16 == C14 + C15` — Còn lại đúng theo nguồn kháng nghị
- **HNGD_TT_3D_R004** (HNGD_TT_3D): `C17 + C18 + C19 + C20 <= C11 + C12` — Phân tích kết quả xét xử không vượt số đã xét xử
- **HNGD_TT_3D_R005** (HNGD_TT_3D): `C17 <= C11 and C18 <= C12` — Không chấp nhận kháng nghị đúng nguồn Chánh án/Viện trưởng
- **HNGD_TT_3D_R006** (HNGD_TT_3D): `C21 <= C11 + C12` — Áp dụng án lệ không vượt số đã xét xử

## 8. KPI/Dashboard đề xuất

- **HNGD_KPI_001** `ty_le_giai_quyet` = `resolved_total / total_to_resolve * 100`
- **HNGD_KPI_002** `ty_le_ton` = `remaining_total / total_to_resolve * 100`
- **HNGD_KPI_003** `ty_le_qua_han` = `overdue_total / remaining_total * 100`
- **HNGD_KPI_004** `ty_le_tam_dinh_chi` = `suspended_remaining / remaining_total * 100`
- **HNGD_KPI_005** `ty_le_ap_dung_an_le` = `precedent_cases / resolved_total * 100`
- **HNGD_KPI_006** `ty_le_thu_tuc_rut_gon` = `summary_procedure_cases / resolved_total * 100`
- **HNGD_KPI_007** `ty_le_bien_phap_khan_cap_tam_thoi` = `provisional_measure_cases / resolved_total * 100`
- **HNGD_KPI_008** `ty_le_vks_tham_gia` = `procuracy_participation_cases / resolved_total * 100`
- **HNGD_KPI_009** `ty_le_luat_su_tham_gia` = `lawyer_cases / resolved_total * 100`
- **HNGD_ST_KPI_010** `ty_le_hoa_giai_doan_tu_thanh` = `reconciled_reunion_cases / resolved_total * 100`
- **HNGD_ST_KPI_011** `ty_le_cong_nhan_thoa_thuan` = `recognized_agreement_cases / resolved_total * 100`
- **HNGD_ST_KPI_012** `ty_le_cho_ly_hon` = `divorce_accepted_cases / resolved_total * 100`
- **HNGD_PT_KPI_013** `ty_le_sua_an_do_so_tham_sai` = `modified_due_first_instance_error / appellate_tried_total * 100`
- **HNGD_PT_KPI_014** `ty_le_huy_an_do_so_tham_sai` = `cancelled_due_first_instance_error / appellate_tried_total * 100`
- **HNGD_GDT_KPI_015** `ty_le_chap_nhan_khang_nghi_giam_doc_tham` = `(reviewed_total - rejected_protest_total) / reviewed_total * 100`
- **HNGD_TT_KPI_016** `ty_le_chap_nhan_khang_nghi_tai_tham` = `(retrial_reviewed_total - retrial_rejected_protest_total) / retrial_reviewed_total * 100`

## 9. Gợi ý triển khai trong hệ thống
```pseudo
function calculate_form(form_code, row):
    for formula in FORMULA_CATALOG[form_code]:
        row[formula.column] = evaluate(formula.expression, row)
    return row

function validate_form(form_code, row):
    errors = []
    for rule in VALIDATION_RULES[form_code]:
        if not evaluate(rule.expression, row):
            errors.append(rule.message)
    return errors
```

## 10. Hồ sơ file
Bộ skill gồm `SKILL.md`, `formula_catalog_hon_nhan_gia_dinh.json`, `validation_rules_hon_nhan_gia_dinh.json`, `column_mapping_hon_nhan_gia_dinh.json`, `data_dictionary_hon_nhan_gia_dinh.json`, `input_mapping_hon_nhan_gia_dinh.json`.
