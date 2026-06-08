# Đối chiếu skill/rule với tài liệu PDF

Ngày rà soát: 2026-06-08

Phạm vi rà soát gồm các rule/skill trong `knowledge_base/`, `skill_phan_cong_an_ngau_nhien/`, `skill_theo_doi_an_huy_sua/`, `skill_thong_ke_*` và 5 PDF trong `Documents/`.

## Kết luận nhanh

Phần lớn skill đang đi đúng hướng và bám sát các văn bản chính. Tuy nhiên có một số điểm cần sửa hoặc kiểm tra lại trước khi triển khai thành code:

1. `skill_phan_cong_an_ngau_nhien` có nguy cơ sai ở pseudocode xử lý xung đột Thẩm phán - vụ việc.
2. `skill_theo_doi_an_huy_sua` cần bổ sung trường/quy tắc về thời hạn kháng cáo, kháng nghị theo từng luật tố tụng.
3. Một số formula sinh từ OCR trong `skill_thong_ke_tat_ca_loai_an/formula_catalog.json` bị lỗi dính dòng, có công thức tự tham chiếu hoặc thiếu cấu trúc.
4. Rule tổng yêu cầu `legal_basis` nhưng nhiều validation JSON theo từng loại án chưa có trường căn cứ pháp lý chi tiết.

## Nguồn PDF đã đối chiếu

- `Thông tư 01_2022_TT-TANDTC...pdf`: phân công Thẩm phán.
- `huong_dan_bm.pdf`: hướng dẫn biểu mẫu thống kê theo Quyết định 287/QĐ-TANDTC.
- `99-vbhn-vpqh.pdf`: Bộ luật Tố tụng dân sự hợp nhất.
- `104-vbhn-vpqh.pdf`: Bộ luật Tố tụng hình sự hợp nhất.
- `109-vbhn-vpqh.pdf`: Luật Tố tụng hành chính hợp nhất.

## Điểm phù hợp

### Phân công án ngẫu nhiên

Skill đã đúng ở các nhóm chính của Thông tư 01/2022/TT-TANDTC:

- Phạm vi áp dụng gồm vụ án hình sự, hành chính, vụ việc dân sự và các vụ việc khác thuộc thẩm quyền Tòa án.
- Nguyên tắc phân công: vô tư, khách quan, ngẫu nhiên, công bằng, dân chủ, công khai, hợp lý, kịp thời.
- Tiêu chí phân công: tải việc tương đương, chuyên môn/kinh nghiệm, người chưa thành niên, vị trí công tác, Tòa/Tổ chuyên trách, chỉ tiêu lãnh đạo, chỉ tiêu thai sản.
- Loại trừ Thẩm phán theo Điều 5: phải từ chối/bị thay đổi, đi biệt phái/công tác/đào tạo từ 01 tháng trở lên, nghỉ phép/thai sản/điều trị bệnh, kỷ luật/chờ kỷ luật/tạm dừng phân công, lý do khác không thể thực hiện nhiệm vụ.
- Sắp xếp Thẩm phán theo Điều 7 và Điều 9: ít án đang giải quyết hơn, nhiều án tạm đình chỉ hơn, ít án quá hạn hơn, ít án hủy/sửa chủ quan trong 01 năm hơn, rồi theo tên tiếng Việt.

### Theo dõi kháng cáo/kháng nghị

Skill đã đúng về hướng thiết kế:

- Một vụ án có thể có nhiều đơn kháng cáo/quyết định kháng nghị.
- Cần tách hồ sơ theo dõi, từng item kháng cáo/kháng nghị, kết quả cấp trên, đánh giá lỗi và lịch sử trạng thái.
- Cần phân loại kết quả: rút, y án, sửa, hủy, đình chỉ, tạm đình chỉ, hủy một phần, xét xử lại.
- Không tự kết luận lỗi chủ quan khi chưa có căn cứ.

### Thống kê

Rule tổng về chống đếm trùng là phù hợp với `huong_dan_bm.pdf`, vì hướng dẫn biểu mẫu nhiều lần nêu các cột chi tiết đã nằm trong cột tổng, hoặc chỉ dùng để theo dõi và không cộng lại vào tổng.

## Điểm cần sửa hoặc làm rõ

### 1. Pseudocode phân công án xử lý xung đột chưa sát Điều 9

File: `skill_phan_cong_an_ngau_nhien/SKILL_PHAN_CONG_AN_NGAU_NHIEN_V1.md`

Thông tư 01, Điều 9 quy định khi Thẩm phán được phân công vụ việc nhưng thuộc trường hợp phải từ chối hoặc bị thay đổi đối với vụ việc đó thì phải phân công vụ việc tiếp theo trong Danh sách vụ việc.

Pseudocode hiện tại:

```python
case = cases.pop(0)
if judge_has_case_specific_conflict(judge, case):
    cases.append(case)
    continue
```

Cách này đưa vụ bị xung đột xuống cuối danh sách và chuyển lượt sang Thẩm phán kế tiếp. Khi triển khai có thể làm sai thứ tự phân bổ. Nên sửa logic thành: giữ cùng Thẩm phán, bỏ qua vụ bị xung đột, thử vụ tiếp theo trong danh sách; vụ bị xung đột vẫn phải được phân công cho Thẩm phán khác đủ điều kiện theo lượt phù hợp, có log lý do bỏ qua.

### 2. Thiếu rule thời hạn kháng cáo/kháng nghị chi tiết

File: `skill_theo_doi_an_huy_sua/SKILL_THEO_DOI_AN_KHANG_CAO_KHANG_NGHI_V1.md`

Skill có `appeal_deadline_status`, nhưng chưa mô hình hóa rõ thời hạn theo từng thủ tục:

- Dân sự: Điều 273 BLTTDS quy định kháng cáo bản án sơ thẩm 15 ngày, quyết định tạm đình chỉ/đình chỉ 07 ngày; Điều 280 quy định thời hạn kháng nghị.
- Hành chính: Điều 206 Luật TTHC quy định kháng cáo bản án sơ thẩm 15 ngày, quyết định tạm đình chỉ/đình chỉ 07 ngày; Điều 211 và các điều tiếp theo quy định kháng nghị.
- Hình sự: BLTTHS có nhóm quy định về kháng cáo/kháng nghị và thủ tục phúc thẩm; riêng Điều 337 quy định thời hạn kháng nghị của Viện kiểm sát là 15/30 ngày đối với bản án, 07/15 ngày đối với quyết định.

Nên bổ sung các trường:

- `appeal_or_protest_deadline_date`
- `deadline_basis_code`
- `deadline_basis_article`
- `is_late`
- `late_reason`
- `late_accepted_by_upper_court`

### 3. Formula catalog tổng có dấu hiệu lỗi OCR

File: `skill_thong_ke_tat_ca_loai_an/formula_catalog.json`

Một số dòng bị dính nội dung mô tả vào công thức hoặc tạo công thức không thể dùng trực tiếp. Ví dụ nhóm công thức có dạng `Cột 6 = Cột 2 + Cột 4 + Cột 7` hoặc `Cột 8 = Cột 6 + Cột 7 SỐ VỤ...`, trong đó cột tổng lại phụ thuộc chính phần kế tiếp hoặc dính tiêu đề. Đây không hẳn là sai quy định, nhưng là lỗi dữ liệu trích xuất.

Khuyến nghị: không dùng trực tiếp file tổng này để tính toán. Hãy chuẩn hóa lại từng formula theo `huong_dan_bm.pdf` và các file formula riêng từng loại án.

### 4. Validation thiếu căn cứ pháp lý cụ thể

Rule tổng yêu cầu validation result có `legal_basis`, nhưng nhiều validation trong các thư mục `skill_thong_ke_*` mới dừng ở mô tả nghiệp vụ. Khi triển khai, các rule như quá hạn chuẩn bị xét xử, quá hạn tạm giam, thời hạn kháng cáo/kháng nghị cần lưu căn cứ điều luật cụ thể.

Khuyến nghị: mỗi validation nên có:

```yaml
rule_code:
legal_basis_document:
legal_basis_article:
legal_basis_text_summary:
```

## Việc chưa kết luận là sai

Các skill thống kê theo loại án có nhiều công thức và mapping chi tiết. Do PDF hướng dẫn biểu mẫu dài và các file skill cũng lớn, lần rà soát này chỉ xác định các rủi ro rõ ràng ở mức rule/schema. Chưa thể khẳng định toàn bộ từng cột biểu mẫu đã khớp 100% nếu chưa làm bảng đối chiếu từng mẫu Excel với `huong_dan_bm.pdf`.

## Khuyến nghị tiếp theo

1. Sửa pseudocode phân công án trong skill và test bằng tình huống có xung đột Thẩm phán - vụ việc.
2. Tạo bảng `legal_rule_references` hoặc seed danh mục legal basis cho deadline/validation.
3. Làm script đối chiếu từng file Excel trong `bieu_mau/` với `huong_dan_bm.pdf`.
4. Tách `formula_catalog.json` tổng thành catalog đã chuẩn hóa, không dùng text OCR dính dòng.
