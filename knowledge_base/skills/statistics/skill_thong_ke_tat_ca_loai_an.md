# Skill: Thống kê nghiệp vụ Tòa án

## Mục đích
Skill này dùng để xây dựng, kiểm tra và giải thích công thức tính toán thống kê cho hệ thống quản lý Tòa án. Nguồn chuẩn là tài liệu “Hướng dẫn sử dụng các loại biểu mẫu thống kê nghiệp vụ trong hệ thống Tòa án nhân dân”, ban hành theo Quyết định số 287/QĐ-TANDTC ngày 15/12/2017.

## Cách sử dụng
- Xác định đúng **mẫu thống kê** trước khi viết công thức.
- Với mỗi chỉ tiêu, phân loại thành: nhập thủ công, tự động tính từ dữ liệu vụ án, hoặc công thức tổng hợp từ cột khác.
- Khi cài đặt, luôn lưu số liệu theo **kỳ thống kê, đơn vị Tòa án, cấp xét xử, loại án, mã mẫu, dòng/chỉ tiêu, cột**.
- Các cột “tổng số”, “còn lại”, “đã giải quyết”, “phải giải quyết” phải là cột công thức, không cho nhập tay trừ khi có quyền hiệu chỉnh có nhật ký.

## Nguyên tắc nghiệp vụ chung
- Số phải giải quyết thường = cũ còn lại + mới thụ lý - chuyển đi, tùy mẫu.
- Số đã giải quyết thường = đình chỉ/trả hồ sơ/xét xử hoặc các nhóm kết quả tương ứng của mẫu.
- Số còn lại = số phải giải quyết - số đã giải quyết.
- Các cột “trong đó” chỉ là phân tích chi tiết, thường đã nằm trong cột tổng; không cộng trùng vào tổng.
- Nếu một vụ án/bị cáo thuộc nhiều điều kiện đặc thù, phải ưu tiên theo hướng dẫn của từng mẫu, ví dụ phúc thẩm vừa kháng cáo vừa kháng nghị thì thống kê vào nhóm kháng nghị.
- Các trường tiền tệ thống kê bằng đồng Việt Nam.

## Danh mục mẫu thống kê đã nhận diện

- **1A** — 1. Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm do cá nhân phạm tội (Mẫu 1A)
- **1A1** — 2. Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm do pháp nhân thương mại phạm tội (Mẫu 1A1)
- **1B** — 3. Thống kê thụ lý và giải quyết các vụ án hình sự phúc thẩm do cá nhân phạm tội (Mẫu 1B)
- **1B1** — 4. Thống kê thụ lý và giải quyết các vụ án hình sự phúc thẩm do pháp nhân thương mại phạm tội (Mẫu 1B1)
- **1C** — 5. Thống kê thụ lý và giải quyết các vụ án hình sự giám đốc thẩm do cá nhân phạm tội (Mẫu 1C)
- **1C1** — 6. Thống kê thụ lý và giải quyết các vụ án hình sự giám đốc thẩm do pháp nhân thương mại phạm tội (Mẫu 1C1)
- **1D** — 7. Thống kê thụ lý và giải quyết các vụ án hình sự tái thẩm do cá nhân phạm tội (Mẫu 1D)
- **1D1** — 8. Thống kê thụ lý và giải quyết các vụ án hình sự tái thẩm do pháp nhân thương mại phạm tội (Mẫu 1D1)
- **1E** — 9. Thống kê thụ lý, giải quyết các vụ án hình sự theo thủ tục xem xét lại quyết định của Hội đồng thẩm phán Tòa án nhân dân tối cao (Mẫu 1E)
- **1F** — 10. Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm có bị cáo là người dưới 18 tuổi (Mẫu 1F)
- **1G** — 11. Thống kê kết quả thi hành án hình sự (Mẫu 1G)
- **1H** — 12. Thống kê các bị cáo Tòa án cấp sơ thẩm cho hưởng án treo và cải tạo không giam giữ bị kháng cáo, kháng nghị (Mẫu 1H)
- **?** — 14. Thống kê các bị cáo Tòa án cấp sơ thẩm áp dụng các tình tiết giảm nhẹ trách nhiệm hình sự và quyết định hình phạt nhẹ hơn quy định của Bộ luật hình sự (Mẫu
- **1L** — 15. Thống kê các trường hợp Tòa án có vi phạm các quy định về tố tụng hình sự và thi hành án hình sự (Mẫu 1L)
- **1M** — 16. Thống kê thụ lý, giải quyết các vụ án về ma túy có liên quan đến việc giám định (Mẫu 1M)
- **2A** — 1. Thống kê thụ lý và giải quyết các vụ án, việc dân sự sơ thẩm (Mẫu 2A)
- **2B** — 2. Thống kê thụ lý và giải quyết các vụ án, việc dân sự phúc thẩm (Mẫu 2B)
- **2C** — 3. Thống kê thụ lý và giải quyết các vụ, việc dân sự giám đốc thẩm (Mẫu 2C)
- **2D** — 4. Thống kê thụ lý và giải quyết các vụ việc dân sự tái thẩm (Mẫu 2D)
- **2E** — 5. Thống kê thụ lý và giải quyết các vụ việc dân sự theo thủ tục đặc biệt (Mẫu 2E)
- **3A** — 1. Thống kê thụ lý, giải quyết các vụ, việc hôn nhân và gia đình sơ thẩm (Mẫu 3A)
- **3B** — 2. Thống kê thụ lý và giải quyết các vụ, việc hôn nhân và gia đình phúc thẩm (Mẫu 3B)
- **3C** — 3. Thống kê thụ lý và giải quyết các vụ việc hôn nhân gia đình giám đốc thẩm (Mẫu 3C)
- **?** — 4. Thống kê thụ lý và giải quyết các vụ việc hôn nhân gia đình tái thẩm (Mẫu
- **4A** — 1. Thống kê thụ lý và giải quyết các vụ việc về kinh doanh thương mại sơ thẩm (Mẫu 4A)
- **4B** — 2. Thống kê thụ lý và giải quyết các vụ, việc về kinh doanh thương mại phúc thẩm (Mẫu 4B)
- **4C** — 3. Thống kê thụ lý và giải quyết các vụ việc về kinh doanh thương mại giám đốc thẩm (Mẫu 4C)
- **4D** — 4. Thống kê thụ lý và giải quyết các vụ việc kinh doanh thương mại tái thẩm (Mẫu 4D)
- **4E** — 5. Thống kê thụ lý và giải quyết yêu cầu tuyên bố phá sản (Mẫu 4E)
- **4F** — 6. Thống kê thụ lý và giải quyết đơn đề nghị, kháng nghị việc giải quyết yêu cầu tuyên bố phá sản (Mẫu 4F)
- **4G** — 7. Thống kê thụ lý và giải quyết yêu cầu tuyên bố phá sản theo thủ tục đặc biệt dùng cho Tòa án nhân dân tối cao (Mẫu 4G)
- **5A** — 1. Thống kê thụ lý và giải quyết các vụ, việc lao động sơ thẩm (Mẫu 5A)
- **5B** — 2. Thống kê thụ lý và giải quyết các vụ việc lao động phúc thẩm (Mẫu 5B)
- **5C** — 3. Thống kê thụ lý và giải quyết các vụ việc lao động giám đốc thẩm (Mẫu 5C)
- **5D** — 4. Thống kê thụ lý và giải quyết các vụ việc lao động tái thẩm (Mẫu 5D)
- **6A** — 1. Thống kê thụ lý và giải quyết các vụ án hành chính sơ thẩm (Mẫu 6A)
- **6B** — 2. Thống kê thụ lý và giải quyết các vụ án hành chính phúc thẩm (Mẫu 6B)
- **?** — 3. Thống kê thụ lý và giải quyết các vụ án hành chính giám đốc thẩm (Mẫu
- **6D** — 4. Thống kê thụ lý và giải quyết các vụ án hành chính tái thẩm (Mẫu 6D)
- **6E** — 5. Thống kê thụ lý và giải quyết các vụ án hành chính theo thủ tục đặc biệt (Mẫu 6E)
- **7A** — 1. Thống kê thụ lý và giải quyết việc áp dụng các biện pháp xử lý hành chính tại Tòa án nhân dân (Mẫu 7A)
- **7B** — 2. Thống kê thụ lý và giải quyết đơn đề nghị hoãn, miễn chấp hành, giảm thời hạn, tạm đình chỉ hoặc miễn chấp hành phần thời gian áp dụng biện pháp xử lý hành chính còn lại tại Tòa án nhân dân (Mẫu 7B)
- **7C** — 3. Thống kê thụ lý và giải quyết khiếu nại, kiến nghị, kháng nghị các quyết định của Tòa án trong việc áp dụng các biện pháp xử lý hành chính (Mẫu 7C)
- **?** — 1. Thống kê thụ lý và giải quyết đơn đề nghị giám đốc thẩm, tái thẩm (Mẫu
- **8B-01** — 2. Thống kê thụ lý, giải quyết đơn khiếu nại, tố cáo quyết định tố tụng và hành vi tố tụng 2.1. Thống kê thụ lý, giải quyết đơn khiếu nại quyết định tố tụng, hành vi tố tụng (Mẫu 8B-01)
- **8C** — 3. Thống kê thụ lý và giải quyết các vụ việc cơ quan thi hành án yêu cầu sửa chữa, giải thích, kiến nghị giám đốc thẩm, tái thẩm bản án, quyết định của Tòa án (Mẫu 8C)
- **9A** — 1. Thống kê các hồ sơ ủy thác tư pháp về dân sự vào Việt Nam (Mẫu 9A)
- **9B** — 2. Thống kê các hồ sơ ủy thác tư pháp về dân sự ra nước ngoài (Mẫu 9B)
- **9C** — 3. Thống kê việc xử lý vi phạm hành chính thuộc thẩm quyền của Tòa án (Mẫu 9C)
- **9D** — 4. Thống kê quyết định về án phí trong các bản án, quyết định và việc xét miễn, giảm các khoản thu nộp ngân sách nhà nước (Mẫu 9D)
- **9E** — 5. Thống kê việc Tòa án trưng cầu giám định trong quá trình giải quyết, xét xử các loại án (Mẫu 9E)
- **9F** — 6. Thống kê số vụ việc dân sự cá nhân, tổ chức yêu cầu áp dụng, thay đổi, hủy bỏ biện pháp khẩn cấp tạm thời (Mẫu 9F)
- **9G** — 7. Thống kê các trường hợp Tòa án có vi phạm các quy định của pháp luật tố tụng dân sự, tố tụng hành chính (Mẫu 9G)
- **9I** — 9. Thống kê bản án, quyết định cung cấp cho Sở Tư pháp (Mẫu 9I)

## Quy trình tạo công thức cho hệ thống
1. Chọn mẫu, ví dụ 1A, 1B, 2A.
2. Tạo bảng ánh xạ cột: mã cột, tên cột, kiểu dữ liệu, phạm vi áp dụng, nguồn dữ liệu.
3. Đánh dấu cột công thức theo danh mục dưới đây.
4. Tạo kiểm tra chéo: tổng chi tiết = tổng chính; còn lại không âm; nhóm “trong đó” không vượt quá cột tổng.
5. Khi xuất báo cáo, tính lại công thức tại thời điểm kết xuất, không phụ thuộc số đã lưu thủ công.

## Danh mục công thức trích xuất từ tài liệu

### Mẫu 1A — 1. Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm do cá nhân phạm tội (Mẫu 1A)

- Dòng nguồn 42: + Cột 9 ghi tổng số vụ án phải giải quyết (Cột 9 = Cột 3 + Cột 5 - Cột 7);
- Dòng nguồn 43: + Cột 10 ghi tổng số bị cáo phải giải quyết (Cột 10 = Cột 4 + Cột 6 - Cột 8);
- Dòng nguồn 197: Cột 37 = Cột 11 + Cột 13 + Cột 16 • Cột 38 ghi tổng số bị cáo đã được giải quyết.
- Dòng nguồn 199: Cột 38 = Cột 12 + Cột 14 + Cột 17 - Từ Cột 39 đến Cột 47 phân tích số vụ án còn lại phải giải quyết, trong đó:
- Dòng nguồn 235: Cột 39 ghi tổng số vụ án còn lại (Cột 39 = Cột 9 - Cột 37);
- Dòng nguồn 236: Cột 40 ghi số bị cáo còn lại (Cột 40 = Cột 10 - Cột 38);
- Dòng nguồn 315: Lưu ý: Tổng số các bị cáo tại các Cột từ Cột 48 đến Cột 61 = Tổng số bị cáo đã

### Mẫu 1A1 — 2. Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm do pháp nhân thương mại phạm tội (Mẫu 1A1)

- Dòng nguồn 483: + Cột 9 ghi tổng số vụ án phải giải quyết (Cột 7 = Cột 3 + Cột 5 - Cột 7);
- Dòng nguồn 484: + Cột 10 ghi tổng số pháp nhân thương mại phải giải quyết (Cột 10 = Cột 4 + Cột 6 - Cột 8);
- Dòng nguồn 654: Cột 34 = Cột 11 + Cột 13 + Cột 16 • Cột 35 ghi tổng số pháp nhân thương mại đã được giải quyết.
- Dòng nguồn 656: Cột 35 = Cột 12 + Cột 14 + Cột 17 - Từ Cột 36 đến Cột 44 phân tích số vụ án còn lại phải giải quyết, trong đó:
- Dòng nguồn 660: Cột 36 ghi tổng số vụ án còn lại (Cột 36 = Cột 9 - Cột 34);
- Dòng nguồn 661: Cột 37 ghi số pháp nhân thương mại còn lại (Cột 37 = Cột 10 - Cột 35);
- Dòng nguồn 716: thương mại Tòa án đã xét xử ( Cột 17 = Cột 45 + Cột 46 + Cột 47 + Cột 48 + Cột 49)

### Mẫu 1B — 3. Thống kê thụ lý và giải quyết các vụ án hình sự phúc thẩm do cá nhân phạm tội (Mẫu 1B)

- Dòng nguồn 876: Cột 11 = Cột 3 + Cột 7 + Cột 12 ghi tổng số bị cáo bị kháng nghị phải giải quyết.
- Dòng nguồn 878: Cột 12 = Cột 4 + Cột 8 + Cột 13 ghi tổng số vụ án bị kháng cáo. Cột 13 = Cột 5+ Cột 9 + Cột 14 ghi tổng số bị cáo bị kháng cáo. Cột 14 = Cột 6 + Cột 10
- Dòng nguồn 879: + Cột 13 ghi tổng số vụ án bị kháng cáo. Cột 13 = Cột 5+ Cột 9 + Cột 14 ghi tổng số bị cáo bị kháng cáo. Cột 14 = Cột 6 + Cột 10 + Cột 15 ghi số trường hợp bi phạm thời hạn tạm giam.
- Dòng nguồn 880: + Cột 14 ghi tổng số bị cáo bị kháng cáo. Cột 14 = Cột 6 + Cột 10 + Cột 15 ghi số trường hợp bi phạm thời hạn tạm giam.
- Dòng nguồn 948: Cột 28 = Cột 16 + Cột 18 + Cột 20 + Cột 22 + Cột 24 + Cột 26 + Cột 29 ghi tổng số bị cáo đã được Tòa án giải quyết.
- Dòng nguồn 950: Cột 29 = Cột 17 + Cột 19 + Cột 21 + Cột 23 + Cột 25 + Cột 27 SỐ VỤ ÁN CÒN LẠI
- Dòng nguồn 971: + Cột 30 ghi số vụ án có kháng nghị còn lại. Cột 30 = Cột 11 - (Cột 16 + Cột 20 + Cột 24);
- Dòng nguồn 973: + Cột 31 ghi số bị cáo có kháng nghị còn lại. Cột 31 = Cột 12 - (Cột 17 + Cột 21 + Cột 25);
- Dòng nguồn 975: + Cột 32 ghi số vụ án có kháng cáo còn lại. Cột 32 = Cột 13 - (Cột 18 + Cột 22 + Cột 26);
- Dòng nguồn 977: + Cột 33 ghi số bị cáo có kháng cáo còn lại. Cột 33 = Cột 14 - (Cột 19 + Cột 23 + Cột 27);
- Dòng nguồn 979: + Cột 34 ghi tổng số vụ án còn lại phải giải quyết (Cột 34 = Cột 30 + Cột 32);
- Dòng nguồn 980: + Cột 35 ghi tổng số bị cáo còn lại phải giải quyết (Cột 35 = Cột 31 + Cột 33)

### Mẫu 1B1 — 4. Thống kê thụ lý và giải quyết các vụ án hình sự phúc thẩm do pháp nhân thương mại phạm tội (Mẫu 1B1)

- Dòng nguồn 1247: (Cột 11 = Cột 3 + Cột 7)
- Dòng nguồn 1249: Cột 12 = Cột 4 + Cột 8 + Cột 13 ghi tổng số vụ án bị kháng cáo phải giải quyết
- Dòng nguồn 1251: (Cột 13 = Cột 5 + Cột 9)
- Dòng nguồn 1253: Cột 14 = Cột 6 + Cột 10 Lưu ý:
- Dòng nguồn 1324: Cột 27 = Cột 15 + Cột 17 + Cột 19 + Cột 21 + Cột 23 + Cột 25 + Cột 28 ghi tổng số pháp nhân thương mại đã được Tòa án giải quyết.
- Dòng nguồn 1326: Cột 28 = Cột 16 + Cột 18 + Cột 20 + Cột 22 + Cột 24 + Cột 26 SỐ VỤ ÁN CÒN LẠI
- Dòng nguồn 1349: Cột 29 = Cột 11 - (Cột 15 + Cột 19 + Cột 23)
- Dòng nguồn 1351: Cột 30 = Cột 12 - (Cột 16 + Cột 20 + Cột 24).
- Dòng nguồn 1353: Cột 31 = Cột 13 - (Cột 17 + Cột 21 + Cột 25);
- Dòng nguồn 1355: Cột 32 = Cột 14 - (Cột 18 + Cột 22 + Cột 26).
- Dòng nguồn 1356: + Cột 33 ghi tổng số vụ án còn lại (Cột 33 = Cột 29 + Cột 31)
- Dòng nguồn 1357: + Cột 34 ghi tổng số pháp nhân thương mại còn lại (Cột 34 = Cột 30 + Cột 32).

### Mẫu 1C — 5. Thống kê thụ lý và giải quyết các vụ án hình sự giám đốc thẩm do cá nhân phạm tội (Mẫu 1C)

- Dòng nguồn 1595: Cột 11 = Cột 3 + Cột 5 + Cột 7 + Cột 9 + Cột 12 ghi tổng số bị cáo phải giải quyết.
- Dòng nguồn 1597: Cột 12 = Cột 4 + Cột 6 + Cột 8 + Cột 10
- Dòng nguồn 1642: Cột 21 = Cột 13 + Cột 15 + Cột 17 + Cột 19 + Cột 22 ghi tổng số bị cáo đã giải quyết.
- Dòng nguồn 1644: Cột 22 = Cột 14 + Cột 16 + Cột 18 + Cột 20 - Từ Cột 23 đến Cột 30 ghi số vụ án và bị cáo còn lại, trong đó:
- Dòng nguồn 1647: Cột 23 = Cột 3 + Cột 7 - Cột 13 - Cột 17 + Cột 24 ghi số bị cáo còn lại do Chánh án kháng nghị.
- Dòng nguồn 1649: Cột 24 = Cột 4 + Cột 8 - Cột 14 - Cột 18 + Cột 25 ghi số vụ án còn lại do Viện trưởng Viện kiểm sát kháng nghị
- Dòng nguồn 1651: Cột 25 = Cột 5 + Cột 9 - Cột 15 - Cột 19 + Cột 26 ghi số bị cáo còn lại do Viện trưởng Viện kiểm sát kháng nghị
- Dòng nguồn 1653: Cột 26 = Cột 6 + Cột 10 - Cột 16 - Cột 20 + Cột 27 ghi tổng số vụ án còn lại (Cột 27 = Cột 23 + Cột 25);
- Dòng nguồn 1654: + Cột 27 ghi tổng số vụ án còn lại (Cột 27 = Cột 23 + Cột 25);
- Dòng nguồn 1655: + Cột 28 ghi tổng số bị cáo còn lại (Cột 28 = Cột 24 + Cột 26).

### Mẫu 1C1 — 6. Thống kê thụ lý và giải quyết các vụ án hình sự giám đốc thẩm do pháp nhân thương mại phạm tội (Mẫu 1C1)

- Dòng nguồn 1819: Cột 11 = Cột 3 + Cột 5 + Cột 7 + Cột 9 + Cột 12 ghi tổng số pháp nhân thương mại phải giải quyết.
- Dòng nguồn 1821: Cột 12 = Cột 4 + Cột 6 + Cột 8 + Cột 10
- Dòng nguồn 1871: Cột 21 = Cột 13 + Cột 15 + Cột 17 + Cột 19 + Cột 22 ghi tổng số pháp nhân thương mại đã giải quyết.
- Dòng nguồn 1873: Cột 22 = Cột 14 + Cột 16 + Cột 18 + Cột 20 - Từ Cột 23 đến Cột 30 ghi số vụ án và pháp nhân thương mại còn lại, trong đó:
- Dòng nguồn 1876: Cột 23 = Cột 3 + Cột 7 - Cột 13 - Cột 17 + Cột 24 ghi số pháp nhân thương mại còn lại do Chánh án kháng nghị.
- Dòng nguồn 1878: Cột 24 = Cột 4 + Cột 8 - Cột 14 - Cột 18 + Cột 25 ghi số vụ án còn lại do Viện trưởng Viện kiểm sát kháng nghị
- Dòng nguồn 1880: Cột 25 = Cột 5 + Cột 9 - Cột 15 - Cột 19 + Cột 26 ghi số pháp nhân thương mại còn lại do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 1887: Cột 26 = Cột 6 + Cột 10 - Cột 16 - Cột 20 + Cột 27 ghi tổng số vụ án còn lại (Cột 27 = Cột 23 + Cột 25);
- Dòng nguồn 1888: + Cột 27 ghi tổng số vụ án còn lại (Cột 27 = Cột 23 + Cột 25);
- Dòng nguồn 1889: + Cột 28 ghi tổng số pháp nhân thương mại còn lại (Cột 28 = Cột 24 + Cột 26).

### Mẫu 1D — 7. Thống kê thụ lý và giải quyết các vụ án hình sự tái thẩm do cá nhân phạm tội (Mẫu 1D)

- Dòng nguồn 2025: + Cột 7 ghi tổng số vụ án phải giải quyết. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số bị cáo phải giải quyết. Cột 8 = Cột 4 + Cột 6 - Từ Cột 9 đến Cột 14 ghi số vụ án và bị cáo đã giải quyết, trong đó:
- Dòng nguồn 2026: + Cột 8 ghi tổng số bị cáo phải giải quyết. Cột 8 = Cột 4 + Cột 6 - Từ Cột 9 đến Cột 14 ghi số vụ án và bị cáo đã giải quyết, trong đó:
- Dòng nguồn 2032: + Cột 13 ghi tổng số vụ án đã giải quyết. Cột 13 = Cột 9 + Cột 11 + Cột 14 ghi tổng số bị cáo đã giải quyết. Cột 14 = Cột 10 + Cột 12
- Dòng nguồn 2033: + Cột 14 ghi tổng số bị cáo đã giải quyết. Cột 14 = Cột 10 + Cột 12
- Dòng nguồn 2090: + Cột 15 ghi số vụ án còn lại. Cột 15 = Cột 7 - Cột 13 + Cột 16 ghi số bị cáo còn lại. Cột 16 = Cột 8 - Cột 14 + Cột 17 và Cột 18 ghi số vụ án còn lại nhưng quá thời hạn xét xử tái thẩm vì
- Dòng nguồn 2091: + Cột 16 ghi số bị cáo còn lại. Cột 16 = Cột 8 - Cột 14 + Cột 17 và Cột 18 ghi số vụ án còn lại nhưng quá thời hạn xét xử tái thẩm vì

### Mẫu 1D1 — 8. Thống kê thụ lý và giải quyết các vụ án hình sự tái thẩm do pháp nhân thương mại phạm tội (Mẫu 1D1)

- Dòng nguồn 2164: + Cột 7 ghi tổng số vụ án phải giải quyết. Cột 7 = Cột 3 + Cột 5 40
- Dòng nguồn 2169: + Cột 8 ghi tổng số pháp nhân thương mại phải giải quyết. Cột 8 = Cột 4 + Cột 6 - Từ Cột 9 đến Cột 14 ghi số vụ án và pháp nhân thương mại đã giải quyết, trong
- Dòng nguồn 2176: + Cột 13 ghi tổng số vụ án đã giải quyết. Cột 13 = Cột 9 + Cột 11 + Cột 14 ghi tổng số pháp nhân thương mại đã giải quyết.
- Dòng nguồn 2178: Cột 14 = Cột 10 + Cột 12 SỐ VỤ ÁN CÒN LẠI PHÂN TÍCH SỐ BỊ CÁO ĐÃ XÉT XỬ
- Dòng nguồn 2224: + Cột 15 ghi số vụ án còn lại. Cột 15 = Cột 7 - Cột 13 + Cột 16 ghi số pháp nhân thương mại còn lại. Cột 16 = Cột 8 - Cột 14 + Cột 17 và Cột 18 ghi số vụ án còn lại nhưng quá thời hạn xét xử tái thẩm vì
- Dòng nguồn 2225: + Cột 16 ghi số pháp nhân thương mại còn lại. Cột 16 = Cột 8 - Cột 14 + Cột 17 và Cột 18 ghi số vụ án còn lại nhưng quá thời hạn xét xử tái thẩm vì

### Mẫu 1E — 9. Thống kê thụ lý, giải quyết các vụ án hình sự theo thủ tục xem xét lại quyết định của Hội đồng thẩm phán Tòa án nhân dân tối cao (Mẫu 1E)

- Dòng nguồn 2328: xem xét lại. Cột 11 = Cột 3 + Cột 7 + Cột 12 ghi tổng số vụ án phải giải quyết do Ủy ban tư pháp của Quốc hội kiến
- Dòng nguồn 2330: nghị xem xét lại. Cột 12 = Cột 4 + Cột 8
- Dòng nguồn 2338: nghị xem xét lại. Cột 13 = Cột 5 + Cột 9 + Cột 14 ghi tổng số vụ án phải giải quyết do Viện trưởng Viện kiểm sát nhân dân
- Dòng nguồn 2340: tối cao kiến nghị xem xét lại. Cột 14 = Cột 6 + Cột 10 + Cột 15 ghi tổng số vụ án phải giải quyết theo thủ tục xem xét lại quyết định của
- Dòng nguồn 2343: Cột 15 = Cột 11 + Cột 12 + Cột 13 + Cột 14 Lưu ý: Trường hợp vụ án có nhiều văn bản yêu cầu, đề nghị, kiến nghị xem xét lại
- Dòng nguồn 2386: cơ quan có thẩm quyền. Cột 20 = Cột 16 + Cột 17 + Cột 18 + Cột 19 + Từ Cột 21 đến Cột 25 ghi số vụ án đã giải quyết, nhất trí với yêu cầu, đề nghị,
- Dòng nguồn 2400: có thẩm quyền. Cột 25 = Cột 21 + Cột 22 + Cột 23 + Cột 24 + Cột 26 ghi tổng số các vụ án đã giải quyết theo yêu cầu, đề nghị, kiến nghị của
- Dòng nguồn 2402: các cơ quan có thẩm quyền. Cột 26 = Cột 20 + Cột 25 THỤ LÝ, GIẢI QUYẾT YÊU CẦU, ĐỀ NGHỊ, KIẾN NGHỊ
- Dòng nguồn 2423: quyết. Cột 27 = Cột 11 - Cột 16 - Cột 21 + Cột 28 ghi số vụ án có kiến nghị của Ủy ban tư pháp của Quốc hội chưa được
- Dòng nguồn 2425: giải quyết. Cột 28 = Cột 12 - Cột 17 - Cột 22 + Cột 29 ghi số vụ án có đề nghị của Chánh án Tòa án nhân dân tối cao chưa được
- Dòng nguồn 2427: giải quyết. Cột 29 = Cột 13 - Cột 18 - Cột 23 + Cột 30 ghi số vụ án có kiến nghị của Viện trưởng Viện kiểm sát nhân dân tối cao
- Dòng nguồn 2429: chưa được giải quyết. Cột 30 = Cột 14 - Cột 19 - Cột 24 + Cột 31 ghi tổng số vụ án có yêu cầu, đề nghị, kiến nghị chưa được giải quyết.
- Dòng nguồn 2431: Cột 31 = Cột 27 + Cột 28 + Cột 29 + Cột 30
- Dòng nguồn 2476: thẩm phán Tòa án nhân dân tối cao. Cột 34 = Cột 32 + Cột 33 + Từ Cột 35 đến Cột 39 phân tích kết quả giải quyết các vụ án theo thủ tục xem xét
- Dòng nguồn 2503: cao. Cột 40 = Cột 35 + Cột 36 + Cột 37 + Cột 38 + Cột 39 + Cột 41 ghi số vụ án còn lại Hội đồng Thẩm phán Tòa án nhân dân tối cao chưa
- Dòng nguồn 2506: tối cao. Cột 41 = Cột 34 - Cột 40

### Mẫu 1F — 10. Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm có bị cáo là người dưới 18 tuổi (Mẫu 1F)

- Dòng nguồn 2538: Cột 9 = Cột 3 + Cột 5 - Cột 7 + Cột 10 ghi tổng số bị cáo phải giải quyết trong kỳ thống kê.
- Dòng nguồn 2540: Cột 10 = Cột 4 + Cột 6 - Cột 8 Lưu ý: Số liệu thống kê tại Cột bao gồm các trường hợp sau:
- Dòng nguồn 2582: Cột 19 = Cột 11 + Cột 13 + Cột 15 Cột 20 = Cột 12 + Cột 14 + Cột 16 + Cột 21, Cột 22 ghi số vụ án, bị cáo còn lại, trong đó:
- Dòng nguồn 2583: Cột 20 = Cột 12 + Cột 14 + Cột 16 + Cột 21, Cột 22 ghi số vụ án, bị cáo còn lại, trong đó:
- Dòng nguồn 2586: Cột 21 = Cột 9 - Cột 19 • Cột 22 ghi số bị cáo còn lại trong kỳ thống kê.
- Dòng nguồn 2588: Cột 22 = Cột 10 - Cột 22

### Mẫu 1G — 11. Thống kê kết quả thi hành án hình sự (Mẫu 1G)

- Dòng nguồn 2753: (Cột 1 = Cột 10 + Cột 11 của kỳ thống kê trước chuyển sang).
- Dòng nguồn 2758: Cột 3 = Cột 4 + Cột 5 + Cột 6 + Cột 7 - Từ Cột 4 đến Cột 7 phân tích số người bị kết án, trong đó:
- Dòng nguồn 2831: 14 = Cột 12 + Cột 13 + Từ Cột 15 đến Cột 19 ghi tổng số người bị kết án phạt tù có quyết định thi hành
- Dòng nguồn 2843: Cột 19 = Cột 15 + Cột 16 + Cột 17 + Cột 18 + Từ Cột 20 đến Cột 26 phân tích các trường hợp người bị kết án phạt tù đã có
- Dòng nguồn 2884: + Cột 29 ghi tổng số người bị kết án tử hình đã có quyết định thi hành án Cột 29 = Cột 27 + Cột 28 + Cột 30 ghi số người bị kết án tử hình đã thi hành án;

### Mẫu 1H — 12. Thống kê các bị cáo Tòa án cấp sơ thẩm cho hưởng án treo và cải tạo không giam giữ bị kháng cáo, kháng nghị (Mẫu 1H)

- Dòng nguồn 2972: chưa có kết quả xét xử phúc thẩm kỳ trước chuyển sang (Cột 2 =Cột 20 kỳ trước chuyển sang).
- Dòng nguồn 2975: trước chưa có kết quả xét xử phúc thẩm kỳ trước chuyển sang (Cột 3 =Cột 21 kỳ trước chuyển sang).
- Dòng nguồn 2978: hoặc kháng nghị ở kỳ trước chưa có kết quả xét xử phúc thẩm kỳ trước chuyển sang (Cột 4 = Cột 22 kỳ trước chuyển sang).
- Dòng nguồn 2987: thống kê: Cột 8 = Cột 2+Cột 5.
- Dòng nguồn 2989: kỳ thống kê: Cột 9 = Cột 3+Cột 6.
- Dòng nguồn 2991: kháng cáo, kháng nghị trong kỳ thống kê: Cột 10 = Cột 4 + Cột 7.
- Dòng nguồn 3057: Cột 20 = Cột 8 - (Cột 11 + Cột 14 + Cột 17)
- Dòng nguồn 3059: thẩm. Cột 21 = Cột 9 - (Cột 12 + Cột 15 + Cột 18)
- Dòng nguồn 3062: Cột 22 = Cột 10 - (Cột 13+Cột 16+ Cột 19)
- Dòng nguồn 3091: trước chưa có kết quả xét xử giám đốc thẩm chuyển sang (Cột 2 3 =Cột 35 kỳ trước chuyển sang).
- Dòng nguồn 3102: nghị ở kỳ trước chưa có kết quả xét xử giám đốc thẩm chuyển sang (Cột 24 = Cột 36 kỳ trước chuyển sang).
- Dòng nguồn 3109: đốc thẩm trong kỳ thống kê: Cột 27 = Cột 23+Cột 25.
- Dòng nguồn 3111: bị kháng nghị trong kỳ thống kê: Cột 28 = Cột 24+Cột 26.
- Dòng nguồn 3142: đốc thẩm. Cột 35 = Cột 27- (Cột 29+Cột 31+Cột 33).
- Dòng nguồn 3144: giám đốc thẩm. Cột 36= Cột 28- (Cột 30+Cột 32+Cột 34).
- Dòng nguồn 3177: chưa có kết quả xét xử giám đốc thẩm chuyển sang (Cột 4 =Cột 16 kỳ trước chuyển sang).
- Dòng nguồn 3179: kỳ trước chưa có kết quả xét xử giám đốc thẩm chuyển sang (Cột 5 =Cột 17 kỳ trước chuyển sang).
- Dòng nguồn 3190: đốc thẩm trong kỳ thống kê: Cột 8 = Cột 4 + Cột 6.
- Dòng nguồn 3192: kháng nghị trong kỳ thống kê: Cột 9 = Cột 5 + Cột 7.
- Dòng nguồn 3235: Cột 16 = Cột 8 - (Cột 10 + Cột 12 + Cột 14)
- Dòng nguồn 3238: Cột 17 = Cột 9 - (Cột 11 + Cột 13 + Cột 15)

### Mẫu 2A — 1. Thống kê thụ lý và giải quyết các vụ án, việc dân sự sơ thẩm (Mẫu 2A)

- Dòng nguồn 3928: Cột 6 = Cột 2 + Cột 3 - Cột 4 - Cột 5.
- Dòng nguồn 3940: + Cột 10 ghi tổng số vụ việc dân sự đã giải quyết (Cột 10 = Cột 7 + Cột 8 + Cột 9).
- Dòng nguồn 3983: + Cột 11 ghi tổng số vụ việc dân sự còn lại. Cột 11 = Cột 6 - Cột 10 + Cột 12 và 13 ghi số vụ việc dân sự còn lại nhưng đã quá thời hạn phải giải

### Mẫu 2B — 2. Thống kê thụ lý và giải quyết các vụ án, việc dân sự phúc thẩm (Mẫu 2B)

- Dòng nguồn 4137: Cột 6 = Cột 2 + Cột 4.
- Dòng nguồn 4138: Cột 7 = Cột 3 + Cột 5.
- Dòng nguồn 4139: Cột 8 = Cột 6 + Cột 7.
- Dòng nguồn 4195: Cột 13 = Cột 9 + Cột 10 + Cột 11 + Cột 12 + Từ Cột 14 đến Cột 16 ghi số vụ án Toà án đã xét xử đối với vụ án dân sự hoặc
- Dòng nguồn 4208: quyết. Cột 16 = Cột 14 + Cột 15.
- Dòng nguồn 4211: Cột 17 = Cột 9 + Cột 11 + Cột 14 * Cột 18 ghi số vụ việc dân sự do Viện kiểm sát kháng nghị đã giải quyết.
- Dòng nguồn 4213: Cột 18 = Cột 10 + Cột 12 + Cột 15 * Cột 19 ghi tổng số vụ việc dân sự đã được giải quyết.
- Dòng nguồn 4215: Cột 19 = Cột 17 + Cột 18 SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 4240: Cột 20 = Cột 6 - Cột 17 + Cột 21 ghi số vụ việc dân sự bị kháng nghị còn lại.
- Dòng nguồn 4242: Cột 21 = Cột 7 - Cột 18 + Cột 22 ghi tổng số vụ việc dân sự có kháng cáo và kháng nghị còn lại.
- Dòng nguồn 4244: Cột 22 = Cột 20 + Cột 21 + Cột 23 và 24 ghi số vụ việc còn lại nhưng đã quá thời hạn phải giải quyết theo

### Mẫu 2C — 3. Thống kê thụ lý và giải quyết các vụ, việc dân sự giám đốc thẩm (Mẫu 2C)

- Dòng nguồn 4434: + Cột 6 ghi tổng số vụ việc phải giải quyết do Chánh án kháng nghị (Cột 6 = Cột 2 + Cột 4);
- Dòng nguồn 4437: nghị (Cột 7 = Cột 3 + Cột 5);
- Dòng nguồn 4438: + Cột 8 ghi tổng số vụ việc phải giải quyết (Cột 8 = Cột 6 + Cột 7).
- Dòng nguồn 4449: Cột 13 = Cột 9 + Cột 10 + Cột 11 + Cột 12
- Dòng nguồn 4469: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 4470: + Cột 15 ghi số vụ việc còn lại do Viện trưởng Viện kiểm sát kháng nghị Cột 15 = Cột 7- (Cột 10 + Cột 12)
- Dòng nguồn 4472: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 + Cột 17,18 ghi số vụ việc dân sự còn lại quá hạn luật định, trong đó:

### Mẫu 2D — 4. Thống kê thụ lý và giải quyết các vụ việc dân sự tái thẩm (Mẫu 2D)

- Dòng nguồn 4588: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 4590: nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 4591: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 4618: Cột 13 = Cột 9 + Cột 10 + Cột11 + Cột 12 - Từ Cột 14 đến Cột 16 ghi các vụ việc còn lại, trong đó:
- Dòng nguồn 4621: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 4622: + Cột 15 ghi số vụ việc còn lại do Viện trưởng Viện kiểm sát kháng nghị Cột 15 = Cột 7 - (Cột 10 + Cột 12)
- Dòng nguồn 4624: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ

### Mẫu 2E — 5. Thống kê thụ lý và giải quyết các vụ việc dân sự theo thủ tục đặc biệt (Mẫu 2E)

- Dòng nguồn 4720: Cột 10 = Cột 2 + Cột 6 Cột 11 ghi tổng số vụ việc do Ủy ban tư pháp của Quốc hội kiến nghị.
- Dòng nguồn 4722: Cột 11 = Cột 3 + Cột 7 Cột 12 ghi tổng số số vụ việc do Chánh án Tòa án nhân dân tối cao đề nghị. Cột 12 = Cột 4 + Cột 8
- Dòng nguồn 4724: = Cột 4 + Cột 8 Cột 13 ghi tổng số vụ việc do Viện trưởng Viện kiểm sát nhân dân tối cao kiến
- Dòng nguồn 4726: nghị. Cột 13 = Cột 5 + Cột 9 Cột 14 tổng số vụ việc có yêu cầu, đề nghị, kiến nghị xem xét lại quyết định của
- Dòng nguồn 4729: Cột 14 = Cột 10 + Cột 11 + Cột 12 + Cột 13 THỤ LÝ, GIẢI QUYẾT YÊU CẦU, ĐỀ NGHỊ, KIẾN NGHỊ
- Dòng nguồn 4778: Cột 19 = Cột 15 + Cột 16 + Cột 17 + Cột 18 * Cột 20 đến Cột 25 thống kê số vụ việc Hội đồng Thẩm phán Tòa án nhân dân tối
- Dòng nguồn 4796: Cột 24 = Cột 20 + Cột 21 + Cột 22 + Cột 23 THỤ LÝ, GIẢI QUYẾT YÊU CẦU, ĐỀ NGHỊ, KIẾN NGHỊ
- Dòng nguồn 4822: Cột 30 = Cột 26 + Cột 27 + Cột 28 + Cột 29 THỤ LÝ, GIẢI QUYẾT VỤ, VIỆC DÂN SỰ THEO THỦ TỤC ĐẶC BIỆT
- Dòng nguồn 4860: Cột 33 = Cột 31 + Cột 32 + Cột 34 đến Cột 37 thống kê kết quả xem xét lại quyết định Hội đồng Thẩm phán
- Dòng nguồn 4882: Cột 37= Cột 34 + Cột 35 + Cột 36.
- Dòng nguồn 4884: Cột 38 = Cột 33 - Cột 37 III. BIỂU MẪU THỐNG KÊ VỀ CÁC VỤ, VIỆC HÔN NHÂN VÀ GIA ĐÌNH

### Mẫu 3A — 1. Thống kê thụ lý, giải quyết các vụ, việc hôn nhân và gia đình sơ thẩm (Mẫu 3A)

- Dòng nguồn 4917: (Cột 6 = Cột 2 + Cột 3 - Cột 4 - Cột 5).
- Dòng nguồn 4966: Cột 15 = Cột 7 + Cột 9 + Cột 10 + Cột 13
- Dòng nguồn 4999: Cột 16 = Cột 6 - Cột 15 + Cột 17 và Cột 18 phân tích nguyên nhân các vụ, việc hôn nhân và gia đình quá

### Mẫu 3B — 2. Thống kê thụ lý và giải quyết các vụ, việc hôn nhân và gia đình phúc thẩm (Mẫu 3B)

- Dòng nguồn 5128: Cột 6 = Cột 2 + Cột 4.
- Dòng nguồn 5134: Cột 7 = Cột 3 + Cột 5.
- Dòng nguồn 5135: Cột 8 = Cột 6 + Cột 7.
- Dòng nguồn 5193: Cột 13 = Cột 9 + Cột 10 + Cột 11 + Cột 12 + Từ Cột 14 đến Cột 16 ghi số vụ án Toà án đã xét xử đối với vụ án hôn nhân và
- Dòng nguồn 5202: được giải quyết. Cột 16 = Cột 14 + Cột 15.
- Dòng nguồn 5206: Cột 17 = Cột 9 + Cột 11 + Cột 14 * Cột 18 ghi số vụ việc hôn nhân và gia đình do Viện kiểm sát kháng nghị đã giải
- Dòng nguồn 5209: Cột 18 = Cột 10 + Cột 12 + Cột 15 * Cột 19 ghi tổng số vụ việc hôn nhân và gia đình đã được giải quyết.
- Dòng nguồn 5211: Cột 19 = Cột 17 + Cột 18 SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 5244: Cột 20 = Cột 6 - Cột 17 + Cột 21 ghi số vụ việc hôn nhân và gia đình bị kháng nghị còn lại.
- Dòng nguồn 5246: Cột 21 = Cột 7 - Cột 18 + Cột 22 ghi tổng số vụ việc hôn nhân và gia đình có kháng cáo và kháng nghị còn
- Dòng nguồn 5249: Cột 22 = Cột 20 + Cột 21 + Cột 23 và 24 ghi số vụ việc còn lại nhưng đã quá thời hạn phải giải quyết theo

### Mẫu 3C — 3. Thống kê thụ lý và giải quyết các vụ việc hôn nhân gia đình giám đốc thẩm (Mẫu 3C)

- Dòng nguồn 5434: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 5436: nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 - Từ Cột 9 đến Cột 13 phân tích số vụ việc đã giải quyết, trong đó:
- Dòng nguồn 5437: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 - Từ Cột 9 đến Cột 13 phân tích số vụ việc đã giải quyết, trong đó:
- Dòng nguồn 5448: Cột 13 = Cột 9 + Cột 10 + Cột11 + Cột 12
- Dòng nguồn 5468: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 5469: + Cột 15 ghi số vụ việc còn lại do Viện trưởng Viện kiểm sát kháng nghị Cột 15 = Cột 7 - (Cột 10 + Cột 12)
- Dòng nguồn 5471: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 + Cột 17 và Cột 18 ghi số vụ việc hôn nhân gia đình còn lại quá hạn luật định, trong

### Mẫu 4A — 1. Thống kê thụ lý và giải quyết các vụ việc về kinh doanh thương mại sơ thẩm (Mẫu 4A)

- Dòng nguồn 5710: Cột 6 = Cột 2 + Cột 3 - Cột 4 - Cột 5 - Từ Cột 7 đến Cột 10 ghi số vụ việc đã giải quyết, trong đó:
- Dòng nguồn 5726: Cột 10 = Cột 7 + Cột 8 + Cột 9 SỐ VỤ VIỆC CÒN LẠI ĐẶC ĐIỂM CÁC VỤ, VIỆC ĐÃ GIẢI QUYẾT
- Dòng nguồn 5761: Cột 11 = Cột 6 - Cột 10 + Cột 12 và Cột 13 ghi số vụ việc về kinh doanh thương mại còn lại nhưng đã quá

### Mẫu 4B — 2. Thống kê thụ lý và giải quyết các vụ, việc về kinh doanh thương mại phúc thẩm (Mẫu 4B)

- Dòng nguồn 5884: Cột 6 = Cột 2 + Cột 4.
- Dòng nguồn 5885: Cột 7 = Cột 3 + Cột 5.
- Dòng nguồn 5886: Cột 8 = Cột 6 + Cột 7.
- Dòng nguồn 5944: Cột 13 = Cột 9 + Cột 10 + Cột 11 + Cột 12 + Từ Cột 14 đến Cột 16 ghi số vụ án Toà án đã xét xử đối với vụ án kinh doanh
- Dòng nguồn 5953: đã được giải quyết. Cột 16 = Cột 14 + Cột 15.
- Dòng nguồn 5958: Cột 17 = Cột 9 + Cột 11 + Cột 14 * Cột 18 ghi số vụ việc kinh doanh thương mại do Viện kiểm sát kháng nghị đã
- Dòng nguồn 5961: Cột 18 = Cột 10 + Cột 12 + Cột 15 * Cột 19 ghi tổng số vụ việc kinh doanh thương mại đã được giải quyết.
- Dòng nguồn 5963: Cột 19 = Cột 17 + Cột 18 SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 5993: Cột 20 = Cột 6 - Cột 17 + Cột 21 ghi số vụ việc kinh doanh thương mại bị kháng nghị còn lại.
- Dòng nguồn 5995: Cột 21 = Cột 7 - Cột 18 + Cột 22 ghi tổng số vụ việc kinh doanh thương mại có kháng cáo và kháng nghị
- Dòng nguồn 5998: Cột 22 = Cột 20 + Cột 21 + Cột 23 và 24 ghi số vụ việc còn lại nhưng đã quá thời hạn phải giải quyết theo

### Mẫu 4C — 3. Thống kê thụ lý và giải quyết các vụ việc về kinh doanh thương mại giám đốc thẩm (Mẫu 4C)

- Dòng nguồn 6195: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 6197: nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 6198: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 6230: Cột 13 = Cột 9 + Cột 10 + Cột11 + Cột 12 - Từ Cột 14 đến Cột 18 ghi các vụ việc còn lại, trong đó:
- Dòng nguồn 6233: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 6234: + Cột 15 ghi số vụ việc còn lại do Viện trưởng Viện kiểm sát kháng nghị Cột 15 = Cột 7 - (Cột 10 + Cột 12)
- Dòng nguồn 6236: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 + Cột 17,18 ghi số vụ việc kinh doanh thương mại còn lại quá hạn luật định, trong

### Mẫu 4D — 4. Thống kê thụ lý và giải quyết các vụ việc kinh doanh thương mại tái thẩm (Mẫu 4D)

- Dòng nguồn 6356: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 6358: nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ VIỆC CÒN LẠI
- Dòng nguồn 6359: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ VIỆC CÒN LẠI
- Dòng nguồn 6390: Cột 13 = Cột 9 + Cột 10 + Cột11 + Cột 12 - Từ Cột 14 đến Cột 16 ghi các vụ việc còn lại, trong đó:
- Dòng nguồn 6393: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 6394: + Cột 15 ghi số vụ việc còn lại do Viện trưởng Viện kiểm sát kháng nghị Cột 15 = Cột 7 - (Cột 10 + Cột 12)
- Dòng nguồn 6396: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 PHÂN TÍCH CÁC VỤ, VIỆC ĐÃ XÉT XỬ

### Mẫu 4E — 5. Thống kê thụ lý và giải quyết yêu cầu tuyên bố phá sản (Mẫu 4E)

- Dòng nguồn 6480: (Cột 9 = Cột 5+cột 6+cột 8).
- Dòng nguồn 6481: - Cột 10 ghi tổng số đơn còn lại chưa xử lý (Cột 10 = cột 4 - cột 9).
- Dòng nguồn 6504: số vụ việc có kết quả giải quyết đơn yêu cầu mở thủ tục phá sản đã thụ lý (Cột 16 = cột 14 + cột 15);
- Dòng nguồn 6507: (Cột 17= cột 13 - cột 16)
- Dòng nguồn 6562: (Cột 20 = Cột 18 + Cột 19)
- Dòng nguồn 6581: (Cột 24 = Cột 21+Cột 22+Cột 23)
- Dòng nguồn 6584: hồi kinh doanh (Cột 25 = Cột 20 - Cột 24)
- Dòng nguồn 6654: quyết (Cột 28 = cột 26 + cột 27).
- Dòng nguồn 6700: (Cột 40 = cột 33 + cột 34 + cột 35 + cột 36 + cột 37 + cột 38 + cột 39)
- Dòng nguồn 6705: (Cột 41 = cột 29 + cột 32 + cột 40)
- Dòng nguồn 6707: (Cột 42 = cột 28 - cột 41)

### Mẫu 4F — 6. Thống kê thụ lý và giải quyết đơn đề nghị, kháng nghị việc giải quyết yêu cầu tuyên bố phá sản (Mẫu 4F)

- Dòng nguồn 6853: Toà án cấp dưới liên quan đến yêu cầu tuyên bố phá sản; (Cột 2 = Cột 12 kỳ trước chuyển sang).
- Dòng nguồn 6856: của Toà án cấp dưới liên quan đến yêu cầu tuyên bố phá sản; (Cột 3 = cột 13 kỳ trước chuyển sang).
- Dòng nguồn 6866: án nhân dân cấp dưới liên quan đến yêu cầu tuyên bố phá sản (Cột 6 = cột 2 + cột 4).
- Dòng nguồn 6869: Toà án nhân dân cấp dưới liên quan đến yêu cầu tuyên bố phá sản (Cột 7 = Cột 3 + Cột 5).
- Dòng nguồn 6873: (Cột 8 = Cột 6 + Cột 7).
- Dòng nguồn 6892: (Cột 11= Cột 9 + Cột 10)
- Dòng nguồn 6896: + Cột 12 ghi số đơn có đề nghị chưa giải quyết (Cột 12 = Cột 6 - Cột 9)
- Dòng nguồn 6897: + Cột 13 ghi số đơn có kháng nghị chưa giải quyết (Cột 13 = Cột 7 - Cột 10)
- Dòng nguồn 6900: (Cột 14 = Cột 8 - Cột 11)
- Dòng nguồn 6943: (Cột 15 + Cột 16 + Cột 17 + Cột 18 + Cột 19 + Cột 20 + Cột 21 = Cột 11)

### Mẫu 4G — 7. Thống kê thụ lý và giải quyết yêu cầu tuyên bố phá sản theo thủ tục đặc biệt dùng cho Tòa án nhân dân tối cao (Mẫu 4G)

- Dòng nguồn 7032: kiến nghị liên quan đến yêu cầu tuyên bố phá sản; (Cột 2 = Cột 16 kỳ trước chuyển sang).
- Dòng nguồn 7040: kiến nghị liên quan đến yêu cầu tuyên bố phá sản (Cột 3 = Cột 17 kỳ trước chuyển sang).
- Dòng nguồn 7044: quan đến yêu cầu tuyên bố phá sản (Cột 4 = Cột 18 kỳ trước chuyển sang).
- Dòng nguồn 7061: phá sản (Cột 8 = Cột 2 + Cột 5)
- Dòng nguồn 7064: đề nghị, kiến nghị liên quan đến yêu cầu tuyên bố phá sản. (Cột 9 = Cột 3 + Cột 6)
- Dòng nguồn 7067: nghị liên quan đến yêu cầu tuyên bố phá sản (Cột 10 = Cột 4 + Cột 7)
- Dòng nguồn 7069: kê: (Cột 11 = Cột 8 + Cột 9 + Cột 10)
- Dòng nguồn 7100: tuyên bố phá sản (Cột 15 = Cột 12 + Cột 13 + Cột 14).
- Dòng nguồn 7104: + Cột 16 ghi số đơn có đề nghị chưa giải quyết (Cột 16 = Cột 8 - Cột 12)
- Dòng nguồn 7106: quyết (Cột 17 = Cột 9 - Cột 13).
- Dòng nguồn 7108: (Cột 18 = Cột 10 - Cột 14).
- Dòng nguồn 7111: đến yêu cầu tuyên bố phá sản (Cột 19 = Cột 16 + Cột 17 + Cột 18).
- Dòng nguồn 7149: 20 + Cột 21 + Cột 22 + Cột 23 + Cột 24 + Cột 25 = Cột 15).

### Mẫu 5A — 1. Thống kê thụ lý và giải quyết các vụ, việc lao động sơ thẩm (Mẫu 5A)

- Dòng nguồn 7208: (Cột 6 = Cột 2 + Cột 3 - Cột 4 - Cột 5).
- Dòng nguồn 7217: Cột 10 = Cột 7 + Cột 8 + Cột 9 SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 7244: Cột 11 = Cột 6 - Cột 10 + Cột 12 và Cột 13 ghi số vụ việc lao động còn lại nhưng đã quá thời hạn phải

### Mẫu 5B — 2. Thống kê thụ lý và giải quyết các vụ việc lao động phúc thẩm (Mẫu 5B)

- Dòng nguồn 7375: Cột 6 = Cột 2 + Cột 4.
- Dòng nguồn 7376: Cột 7 = Cột 3 + Cột 5.
- Dòng nguồn 7377: Cột 8 = Cột 6 + Cột 7.
- Dòng nguồn 7433: Cột 13 = Cột 9 + Cột 10 + Cột 11 + Cột 12 143
- Dòng nguồn 7445: giải quyết. Cột 16 = Cột 14 + Cột 15.
- Dòng nguồn 7449: Cột 17 = Cột 9 + Cột 11 + Cột 14 * Cột 18 ghi số vụ việc lao động do Viện kiểm sát kháng nghị đã giải quyết.
- Dòng nguồn 7451: Cột 18 = Cột 10 + Cột 12 + Cột 15 * Cột 19 ghi tổng số vụ việc lao động đã được giải quyết.
- Dòng nguồn 7453: Cột 19 = Cột 17 + Cột 18 SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 7478: Cột 20 = Cột 6 - Cột 17 + Cột 21 ghi số vụ việc lao động bị kháng nghị còn lại.
- Dòng nguồn 7480: Cột 21 = Cột 7 - Cột 18 + Cột 22 ghi tổng số vụ việc lao động có kháng cáo và kháng nghị còn lại.
- Dòng nguồn 7482: Cột 22 = Cột 20 + Cột 21 + Cột 23 và 24 ghi số vụ việc còn lại nhưng đã quá thời hạn phải giải quyết

### Mẫu 5C — 3. Thống kê thụ lý và giải quyết các vụ việc lao động giám đốc thẩm (Mẫu 5C)

- Dòng nguồn 7664: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát
- Dòng nguồn 7666: kháng nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7
- Dòng nguồn 7667: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 7703: Cột 13 = Cột 9 + Cột 10 + Cột11 + Cột 12 - Từ Cột 14 đến Cột 18 ghi các vụ việc còn lại, trong đó:
- Dòng nguồn 7706: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 7708: Cột 15 = Cột 7- (Cột 10 + Cột 12)
- Dòng nguồn 7709: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 + Cột 17,18 ghi số vụ việc lao động còn lại quá hạn luật định, trong đó:

### Mẫu 5D — 4. Thống kê thụ lý và giải quyết các vụ việc lao động tái thẩm (Mẫu 5D)

- Dòng nguồn 7829: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát
- Dòng nguồn 7831: kháng nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7
- Dòng nguồn 7832: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT SỐ VỤ, VIỆC CÒN LẠI
- Dòng nguồn 7866: Cột 13 = Cột 9 + Cột 10 + Cột11 + Cột 12 - Từ Cột 14 đến Cột 16 ghi các vụ việc còn lại, trong đó:
- Dòng nguồn 7869: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 7871: Cột 15 = Cột 7 - (Cột 10 + Cột 12)
- Dòng nguồn 7872: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15

### Mẫu 6A — 1. Thống kê thụ lý và giải quyết các vụ án hành chính sơ thẩm (Mẫu 6A)

- Dòng nguồn 7925: + Cột 2 ghi số vụ án cũ còn lại; Cột 2 = cột 17 kỳ trước chuyển sang
- Dòng nguồn 7950: + Cột 6 ghi tổng số vụ án phải giải quyết. Cột 6 = Cột 2 + Cột 3 - Cột 4 - Cột 5 SỐ VỤ ÁN ĐÃ GIẢI QUYẾT
- Dòng nguồn 7982: Cột 9 = Cột 7 + Cột 8 + Cột 10 đến Cột 14 thống kê số vụ án đã xét xử theo khoản 2 Điều 193 Luật
- Dòng nguồn 7990: * Cột 13 ghi tổng số vụ án đã xét xử: Cột 13 = Cột 10 + Cột 11 + Cột 12 * Cột 14 ghi số vụ án đã xét xử có kiến nghị với cơ quan nhà nước, người
- Dòng nguồn 7994: + Cột 15 ghi tổng số vụ án đã giải quyết: Cột 15 = Cột 9 + Cột 13 + Cột 16 ghi tổng số các vụ án có đối thoại đã giải quyết theo Khoản 1 Điều
- Dòng nguồn 8026: + Cột 17 ghi tổng số vụ án còn lại: Cột 17 = Cột 6 - Cột 15 + Cột 18 và cột 19 thống kê số vụ án còn lại nhưng đã quá thời hạn phải giải

### Mẫu 6B — 2. Thống kê thụ lý và giải quyết các vụ án hành chính phúc thẩm (Mẫu 6B)

- Dòng nguồn 8141: nghị. (Cột 2= cột 18, cột 3 = cột 19 kỳ thống kê trước chuyển sang).
- Dòng nguồn 8147: Cột 6 = Cột 2 + Cột 4 * Cột 7 ghi tổng số vụ án phải giải quyết do Viện kiểm sát kháng nghị:
- Dòng nguồn 8149: Cột 7 = Cột 3 + Cột 5.
- Dòng nguồn 8150: * Cột 8 ghi tổng số các vụ án phải giải quyết: Cột 8 = Cột 6 + Cột 7 SỐ VỤ ÁN ĐÃ GIẢI QUYẾT
- Dòng nguồn 8196: Cột 13 = (Cột 9 + Cột 10 + Cột 11 + Cột 12)
- Dòng nguồn 8201: * Cột 16 ghi tổng số vụ án đã xét xử: Cột 16 = Cột 14 + Cột 15 + Cột 17 đến Cột 19 ghi tổng số các vụ án đã giải quyết, trong đó:
- Dòng nguồn 8204: Cột 17 = Cột 9 + Cột 11 + Cột 14 * Cột 18 ghi tổng số vụ án Viện kiểm sát kháng nghị đã giải quyết.
- Dòng nguồn 8206: Cột 18 = Cột 10 + Cột 12 + Cột 15 * Cột 19 ghi tổng số vụ án có kháng cáo, kháng nghị đã giải quyết.
- Dòng nguồn 8208: Cột 19 = Cột 17 + Cột 18
- Dòng nguồn 8240: Cột 20 = Cột 6 - Cột 17 + Cột 21 ghi tổng số các vụ án còn lại do có kháng nghị:
- Dòng nguồn 8242: Cột 21 = Cột 7 - Cột 18 + Cột 22 thống kê tổng số các vụ án còn lại: Cột 22 = Cột 20 + Cột 21 + Cột 23 và Cột 24 thống kê số vụ án còn lại nhưng đã quá thời hạn phải giải
- Dòng nguồn 8243: + Cột 22 thống kê tổng số các vụ án còn lại: Cột 22 = Cột 20 + Cột 21 + Cột 23 và Cột 24 thống kê số vụ án còn lại nhưng đã quá thời hạn phải giải

### Mẫu 6D — 4. Thống kê thụ lý và giải quyết các vụ án hành chính tái thẩm (Mẫu 6D)

- Dòng nguồn 8602: (Cột 2 = cột 18 kỳ trước chuyển sang)
- Dòng nguồn 8604: nghị: (Cột 3 = cột 19 kỳ trước chuyển sang)
- Dòng nguồn 8614: Cột 6 = Cột 2 + Cột 4.
- Dòng nguồn 8616: kiểm sát kháng nghị. Cột 7 = Cột 3 + Cột 5.
- Dòng nguồn 8617: + Cột 8 ghi tổng số vụ án hành chính phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ ÁN ĐÃ GIẢI QUYẾT
- Dòng nguồn 8639: rút kháng nghị. Cột 11= Cột 9 + Cột 10;
- Dòng nguồn 8644: kháng nghị. Cột 14 = Cột 12 + Cột 13;
- Dòng nguồn 8646: quyết. Cột 15 = Cột 9 + Cột 12;
- Dòng nguồn 8648: kháng nghị đã giải quyết. Cột 16 = Cột 10 + Cột 13;
- Dòng nguồn 8650: Cột 17 = Cột 15 + Cột 16.
- Dòng nguồn 8666: Cột 18 = Cột 6 - Cột 15.
- Dòng nguồn 8668: Cột 19 = Cột 7 - Cột 16.
- Dòng nguồn 8670: Cột 20 = Cột 18 + Cột 19 + Cột 21 và Cột 22 thống kê số vụ án hành chính còn lại quá hạn luật định

### Mẫu 6E — 5. Thống kê thụ lý và giải quyết các vụ án hành chính theo thủ tục đặc biệt (Mẫu 6E)

- Dòng nguồn 8743: Quốc hội (Cột 2 = cột 26 kỳ trước chuyển sang).
- Dòng nguồn 8745: của Quốc hội (Cột 3 = Cột 27 kỳ trước chuyển sang).
- Dòng nguồn 8747: nhân dân tối cao (Cột 4 = Cột 28 kỳ trước chuyển sang).
- Dòng nguồn 8749: kiểm sát nhân dân tối cao (Cột 5 = Cột 29 kỳ trước chuyển sang).
- Dòng nguồn 8775: Quốc hội yêu cầu, Cột 10 = Cột 2 + Cột 6.
- Dòng nguồn 8777: Quốc hội kiến nghị, Cột 11= Cột 3 + Cột 7.
- Dòng nguồn 8779: án Tòa án nhân dân tối cao, Cột 12 = Cột 4 + Cột 8.
- Dòng nguồn 8781: trưởng Viện kiểm sát nhân dân tối cao, Cột 13 = Cột 5 + Cột 9.
- Dòng nguồn 8784: Cột 14 = Cột 10 + Cột 11 + Cột 12 + Cột 13.
- Dòng nguồn 8830: Cột 19 = Cột 15 + Cột 16 + Cột 17 + Cột 18 + Cột 20 đến Cột 24 ghi số vụ án hành chính Hội đồng Thẩm phán Tòa án nhân
- Dòng nguồn 8844: Cột 24 = Cột 20 + Cột 21 + Cột 22 + Cột 23.
- Dòng nguồn 8846: Cột 25 = Cột 19 + Cột 24.
- Dòng nguồn 8858: còn lại chưa giải quyết. Cột 26 = Cột 10 - Cột 15 - Cột 20.
- Dòng nguồn 8860: hội kiến nghị còn lại chưa giải quyết . Cột 27 = Cột 11 - Cột 16 - Cột 21.
- Dòng nguồn 8866: tối cao còn lại chưa giải quyết. Cột 28 = Cột 12 - Cột 17 - Cột 22.
- Dòng nguồn 8868: nhân dân tối cao còn lại chưa giải quyết. Cột 29 = Cột 13 - Cột 18 - Cột 23.
- Dòng nguồn 8870: lại chưa giải quyết. Cột 30 = (Cột 26 + cột 27 + Cột 28 + Cột 29)
- Dòng nguồn 8905: * Cột 31 ghi số hồ sơ cũ còn lại chưa giải quyết (Cột 31 = Cột 39 kỳ trước chuyển sang).
- Dòng nguồn 8908: (Số liệu Cột 32 = Cột 24 chuyển sang)
- Dòng nguồn 8910: Cột 33 = Cột 31+Cột 32.
- Dòng nguồn 8930: giải quyết. Cột 38 = Cột 34 + Cột 35 + Cột 36 + Cột 37.
- Dòng nguồn 8931: - Cột 39 ghi số vụ án còn lại chưa giải quyết. Cột 39 = Cột 33 - Cột 38.

### Mẫu 7A — 1. Thống kê thụ lý và giải quyết việc áp dụng các biện pháp xử lý hành chính tại Tòa án nhân dân (Mẫu 7A)

- Dòng nguồn 8995: + Cột 4 ghi tổng số hồ sơ phải giải quyết. Cột 4 = Cột 2 + Cột 3.
- Dòng nguồn 9009: Tòa án giải quyết. Cột 9 = Cột 5 + Cột 6 + Cột 7 + Cột 8.
- Dòng nguồn 9032: Cột 10 = Cột 4 - Cột 9.

### Mẫu 7B — 2. Thống kê thụ lý và giải quyết đơn đề nghị hoãn, miễn chấp hành, giảm thời hạn, tạm đình chỉ hoặc miễn chấp hành phần thời gian áp dụng biện pháp xử lý hành chính còn lại tại Tòa án nhân dân (Mẫu 7B)

- Dòng nguồn 9131: Cột 4 = cột 2 + cột 3.
- Dòng nguồn 9139: + Cột 7 ghi tổng số hồ sơ Tòa án đã giải quyết. Cột 7 = Cột 5 + Cột 6 - Từ Cột 8 đến Cột 10 ghi số hồ sơ còn lại Tòa án chưa giải quyết trong kỳ
- Dòng nguồn 9142: + Cột 8 ghi tổng số hồ sơ còn lại. Cột 8 = Cột 4 - Cột 7 + Cột 9 và Cột 10 ghi số hồ sơ còn lại nhưng đã quá thời hạn quy định của
- Dòng nguồn 9179: Lưu ý: Cột 5= Cột 11+ cột 12+ cột 13+ cột 14+ cột 15.

### Mẫu 7C — 3. Thống kê thụ lý và giải quyết khiếu nại, kiến nghị, kháng nghị các quyết định của Tòa án trong việc áp dụng các biện pháp xử lý hành chính (Mẫu 7C)

- Dòng nguồn 9209: Cột 8 = Cột 2 + Cột 3 + Cột 4 + Cột 5 + Cột 6 + Cột 7 Lưu ý: - Nếu một hồ sơ vừa có khiếu nại và vừa có kháng nghị của Viện kiểm sát thì
- Dòng nguồn 9240: Cột 15 = Cột 9 + Cột 10 + Cột 11 + Cột 12 + Cột 13 + Cột 14.
- Dòng nguồn 9286: Cột 19 = Cột 16 + Cột 17 + Cột 18.

### Mẫu 8B-01 — 2. Thống kê thụ lý, giải quyết đơn khiếu nại, tố cáo quyết định tố tụng và hành vi tố tụng 2.1. Thống kê thụ lý, giải quyết đơn khiếu nại quyết định tố tụng, hành vi tố tụng (Mẫu 8B-01)

- Dòng nguồn 9578: + Cột 2 ghi số đơn tồn từ kỳ trước chuyển sang. Cột 2 = Cột 11 kỳ trước
- Dòng nguồn 9582: Cột 4 = Cột 2 + Cột 3 - Từ Cột 5 đến Cột 10 thống kê số đơn khiếu nại Tòa án đã xử lý, cụ thể:
- Dòng nguồn 9593: Cột 10 = Cột 5 + Cột 6 + Cột 7 + Cột 8 + Cột 9 - Cột 11 ghi số đơn còn lại Tòa án chưa xử lý. Cột 11 = Cột 4 - Cột 10 Đánh giá việc khiếu nại
- Dòng nguồn 9594: - Cột 11 ghi số đơn còn lại Tòa án chưa xử lý. Cột 11 = Cột 4 - Cột 10 Đánh giá việc khiếu nại
- Dòng nguồn 9626: + Cột 12 ghi số đơn cũ còn lại từ kỳ trước chuyển sang. Cột 12= Cột 19 của
- Dòng nguồn 9632: + Cột 13 ghi số đơn mới thụ lý trong thời điểm thống kê. Cột 13 = Cột 5 chuyển sang.
- Dòng nguồn 9635: Cột 14 = Cột 12 + Cột 13 + Cột 15 ghi số đơn Tòa án đã giải quyết bằng hình thức ra quyết định.
- Dòng nguồn 9640: Cột 18 = Cột 15 + Cột 16 + Cột 17 + Cột 19 ghi số đơn khiếu nại thuộc thẩm quyền nhưng Tòa án chưa giải quyết.
- Dòng nguồn 9647: Lưu ý: Cột 20 + Cột 21 + Cột 22 = Cột 18 - Cột 23,24 theo dõi số việc Tòa án phải xử lý sau giải quyết khiếu nại, cụ thể:
- Dòng nguồn 9703: + Cột 2 ghi số đơn tồn trước thời điểm báo cáo chuyển qua. Cột 2 = Cột 11 của kỳ trước chuyển sang.
- Dòng nguồn 9707: Cột 4 = Cột 2 + Cột 3 - Từ Cột 5 đến Cột 10 thống kê số đơn tố cáo Tòa án đã xử lý, cụ thể:
- Dòng nguồn 9717: Cột 10 = Cột 5 + Cột 6 + Cột 7 + Cột 8 + Cột 9 - Cột 11 ghi số đơn còn lại Tòa án chưa xử lý. Cột 11 = Cột 4 - Cột 10
- Dòng nguồn 9718: - Cột 11 ghi số đơn còn lại Tòa án chưa xử lý. Cột 11 = Cột 4 - Cột 10
- Dòng nguồn 9757: + Cột 12 ghi số đơn cũ còn lại từ kỳ trước chuyển sang. Cột 12= Cột 19 của
- Dòng nguồn 9759: + Cột 13 ghi số đơn mới thụ lý trong thời điểm thống kê. Cột 13 = Cột 5 chuyển sang.
- Dòng nguồn 9762: Cột 14 = Cột 12 + Cột 13 + Cột 15 ghi số đơn Tòa án đã giải quyết bằng hình thức ra quyết định (Kết luận).
- Dòng nguồn 9768: Cột 18 = Cột 15 + Cột 16 + Cột 17 + Cột 19 ghi số đơn khiếu nại thuộc thẩm quyền nhưng Tòa án chưa giải quyết.

### Mẫu 8C — 3. Thống kê thụ lý và giải quyết các vụ việc cơ quan thi hành án yêu cầu sửa chữa, giải thích, kiến nghị giám đốc thẩm, tái thẩm bản án, quyết định của Tòa án (Mẫu 8C)

- Dòng nguồn 9837: Cột 6 = Cột 2 + Cột 3 + Cột 4 + Cột 5 + Từ Cột 7 đến Cột 11: thống kê số bản án, quyết định cơ quan thi hành án
- Dòng nguồn 9852: Cột 11 = Cột 7 + Cột 8 + Cột 9 + Cột 10 + Từ Cột 12 đến Cột 16: thống kê tổng số bản án, quyết định cơ quan thi hành
- Dòng nguồn 9858: Cột 12 = Cột 2 + Cột 7 * Cột 13: ghi số bản án, quyết định cơ quan thi hành án dân sự yêu cầu Tòa
- Dòng nguồn 9861: Cột 13 = Cột 3 + Cột 8 * Cột 14: ghi số bản án, quyết định cơ quan thi hành án dân sự kiến nghị Tòa
- Dòng nguồn 9864: thống kê. Cột 14 = Cột 4 + Cột 9 * Cột 15: ghi số bản án, quyết định cơ quan thi hành án dân sự kiến nghị Tòa
- Dòng nguồn 9867: kê. Cột 15 = Cột 5 + Cột 10 * Cột 16: ghi tổng số bản án, quyết định cơ quan thi hành án dân sự yêu cầu
- Dòng nguồn 9870: Cột 16 = Cột 6 + Cột 11 193
- Dòng nguồn 9921: Cột 25 = Cột 17 + Cột 18 + Cột 19 + Cột 20 + Cột 21 + Cột 22 + Cột 23 + Cột 24 - Từ Cột 26 đến Cột 30: thống kê số bản án, quyết định cơ quan thi hành án
- Dòng nguồn 9941: giải quyết. Cột 30 = Cột 26 + Cột 27 + Cột 28 + Cột 29.
- Dòng nguồn 9967: Cột 33 = Cột 31 + Cột 32 - Từ Cột 34 đến Cột 36: thống kê số bản án, quyết định cơ quan thi hành án
- Dòng nguồn 9984: Cột 36 = Cột 34 + Cột 35 - Cột 37: thống kê số bản án, quyết định cơ quan thi hành án dân sự yêu cầu
- Dòng nguồn 9987: giải quyết. Cột 37 = Cột 33 - Cột 36 SỐ VỤ TÒA ÁN
- Dòng nguồn 10023: Cột 40 = Cột 38 + Cột 39
- Dòng nguồn 10040: Cột 43 = Cột 41 + Cột 42.
- Dòng nguồn 10043: Cột 44 = Cột 40 - Cột 43.

### Mẫu 9A — 1. Thống kê các hồ sơ ủy thác tư pháp về dân sự vào Việt Nam (Mẫu 9A)

- Dòng nguồn 10159: Cột 5 = Cột 3 + Cột 4.

### Mẫu 9B — 2. Thống kê các hồ sơ ủy thác tư pháp về dân sự ra nước ngoài (Mẫu 9B)

- Dòng nguồn 10223: + Cột 5 tổng số các trường hợp đã yêu cầu thực hiện ủy thác tư pháp (Cột 5 = Cột 3 + Cột 4);

### Mẫu 9C — 3. Thống kê việc xử lý vi phạm hành chính thuộc thẩm quyền của Tòa án (Mẫu 9C)

- Dòng nguồn 10273: tòa. Cột 1 = Cột 2 + Cột 3 + Cột 5.
- Dòng nguồn 10308: quá trình Tòa án giải quyết các vụ việc phá sản. Cột 7= Cột 8 + Cột 9 + Cột 11.

### Mẫu 9F — 6. Thống kê số vụ việc dân sự cá nhân, tổ chức yêu cầu áp dụng, thay đổi, hủy bỏ biện pháp khẩn cấp tạm thời (Mẫu 9F)

- Dòng nguồn 10493: Cột 9 = Cột 3 + Cột 6 • Cột 10 ghi tổng số yêu cầu thay đổi biện pháp khẩn cấp tạm thời.
- Dòng nguồn 10495: Cột 10 = Cột 4 + Cột 7 • Cột 11 ghi tổng số yêu cầu hủy bỏ biện pháp khẩn cấp tạm thời.
- Dòng nguồn 10497: Cột 11 = Cột 5 + Cột 8 + Cột 12 ghi tổng số các yêu cầu áp dụng, thay đổi, hủy bỏ biện pháp khẩn
- Dòng nguồn 10499: cấp tạm thời. Cột 12 = Cột 9 + Cột 10 + Cột 11.
- Dòng nguồn 10531: + Cột 16 ghi tổng số yêu cầu đương sự rút. Cột 16 = Cột 13 + Cột 14 + Cột 15 - Từ Cột 17 đến Cột 20 ghi số đơn được Tòa án chấp nhận áp dụng, thay đổi, hủy
- Dòng nguồn 10540: Cột 20 = Cột 17 + Cột 18 + Cột 19 206
- Dòng nguồn 10575: hủy bỏ biện pháp khẩn cấp tạm thời. Cột 24 = Cột 21 + Cột 22 + Cột 23 - Từ Cột 25 đến Cột 28 ghi số yêu cầu của đương sự Tòa án chưa giải quyết,
- Dòng nguồn 10582: Cột 28 = Cột 25 + Cột 26 + Cột 27.

### Mẫu 9I — 9. Thống kê bản án, quyết định cung cấp cho Sở Tư pháp (Mẫu 9I)

- Dòng nguồn 10772: Cột 1 = Cột 2 + Cột 3 + Cột 4 + Cột 5 - Từ Cột 2 đến Cột 5: phân loại thông tin đã cung cấp cho Sở Tư pháp, cụ thể:

### Mẫu 14. Thống kê các bị  — 14. Thống kê các bị 

- Dòng nguồn 3296: trong kỳ thống kê. Cột 8 = Cột 4 + Cột 6.
- Dòng nguồn 3298: trong kỳ thống kê. Cột 9 = Cột 5 + Cột 7.
- Dòng nguồn 3313: Cột 16 = Cột 8 - Cột 10 - Cột 12 - Cột 14 + Cột 17: số bị cáo Tòa án án cấp sơ thẩm áp dụng điều 54 bị kháng cáo, kháng
- Dòng nguồn 3316: Cột 17 = Cột 9 - Cột 11 - Cột 13 - Cột 15
- Dòng nguồn 3356: trong kỳ thống kê. Cột 22 = Cột 18 + Cột 20 + Cột 23: ghi tổng số bị cáo Tòa án áp dụng điều 54 bị kháng nghị giám đốc thẩm
- Dòng nguồn 3358: trong kỳ thống kê. Cột 23 = Cột 19 + Cột 21.
- Dòng nguồn 3378: Cột 30 = Cột 22 - Cột 24 - Cột 26 - Cột 28 + Cột 31: số bị cáo Tòa án áp dụng điều 54 bị kháng nghị giám đốc thẩm trong kỳ
- Dòng nguồn 3381: Cột 31 = Cột 23 - Cột 25 - Cột 27 - Cột 29.

### Mẫu 4. Thống kê thụ lý v — 4. Thống kê thụ lý v

- Dòng nguồn 5593: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ việc phải giải quyết do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 5595: nghị. Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT
- Dòng nguồn 5596: + Cột 8 ghi tổng số vụ việc phải giải quyết. Cột 8 = Cột 6 + Cột 7 SỐ VỤ, VIỆC ĐÃ GIẢI QUYẾT
- Dòng nguồn 5620: Cột 13 = Cột 9 + Cột 10 + Cột 11 + Cột 12 SỐ VỤ, VIỆC
- Dòng nguồn 5640: Cột 14 = Cột 6 - (Cột 9 + Cột 11)
- Dòng nguồn 5641: + Cột 15 ghi số vụ việc còn lại do Viện trưởng Viện kiểm sát kháng nghị Cột 15 = Cột 7 - (Cột 10 + Cột 12)
- Dòng nguồn 5643: + Cột 16 ghi tổng số các vụ việc còn lại. Cột 16 = Cột 14 + Cột 15 - Từ Cột 17 đến Cột 20 phân tích các vụ việc đã xét xử, trong đó:

### Mẫu 3. Thống kê thụ lý v — 3. Thống kê thụ lý v

- Dòng nguồn 8432: Cột 2 = cột 18 (kỳ thống kê trước chuyển sang).
- Dòng nguồn 8434: nghị: Cột 3= cột 19 (kỳ thống kê trước chuyển sang).
- Dòng nguồn 8439: Cột 6 = Cột 2 + Cột 4 + Cột 7 ghi tổng số vụ án hành chính phải giải quyết do Viện trưởng Viện
- Dòng nguồn 8441: kiểm sát kháng nghị: Cột 7 = Cột 3 + Cột 5 + Cột 8 ghi tổng số vụ án hành chính phải giải quyết: Cột 8 = Cột 6 + Cột 7 SỐ VỤ ÁN ĐÃ GIẢI QUYẾT
- Dòng nguồn 8442: + Cột 8 ghi tổng số vụ án hành chính phải giải quyết: Cột 8 = Cột 6 + Cột 7 SỐ VỤ ÁN ĐÃ GIẢI QUYẾT
- Dòng nguồn 8467: rút kháng nghị: Cột 11= Cột 9 + Cột 10 + Cột 12 ghi số vụ án hành chính do Chánh án kháng nghị đã được đưa ra xét
- Dòng nguồn 8473: kháng nghị: Cột 14 = Cột 12 + Cột 13.
- Dòng nguồn 8475: nghị: Cột 15 = Cột 9 + Cột 12.
- Dòng nguồn 8477: kiểm sát kháng nghị: Cột 16 = Cột 10 + Cột 13.
- Dòng nguồn 8479: Cột 17 = Cột 15 + Cột 16 SỐ VỤ ÁN CÒN LẠI
- Dòng nguồn 8490: Cột 18 = Cột 6 - Cột 15 + Cột 19 ghi số vụ án hành chính còn lại do Viện trưởng Viện kiểm sát kháng
- Dòng nguồn 8492: nghị: Cột 19 = Cột 7 - Cột 16 + Cột 20 ghi tổng số các vụ án hành chính còn lại: Cột 20 = (Cột 18 + Cột 19)
- Dòng nguồn 8493: + Cột 20 ghi tổng số các vụ án hành chính còn lại: Cột 20 = (Cột 18 + Cột 19)

### Mẫu 1. Thống kê thụ lý v — 1. Thống kê thụ lý v

- Dòng nguồn 9402: * Cột 4 ghi tổng số đơn đã nhận trong kỳ thống kê. Cột 4 = Cột 2 + Cột 3.
- Dòng nguồn 9411: * Cột 6: ghi số đơn thuộc thẩm quyền giải quyết của Toà án. Cột 6 = Cột 10 * Cột 7: ghi tổng số đơn đã xử lý trong kỳ thống kê. Cột 7 = Cột 5 + Cột 6 * Cột 8: ghi số đơn còn lại chưa xử lý. Cột 8 = Cột 4 - Cột 7.
- Dòng nguồn 9412: * Cột 7: ghi tổng số đơn đã xử lý trong kỳ thống kê. Cột 7 = Cột 5 + Cột 6 * Cột 8: ghi số đơn còn lại chưa xử lý. Cột 8 = Cột 4 - Cột 7.
- Dòng nguồn 9413: * Cột 8: ghi số đơn còn lại chưa xử lý. Cột 8 = Cột 4 - Cột 7.
- Dòng nguồn 9439: + Cột 12 ghi tổng số đơn Tòa án phải giải quyết. Cột 12 = Cột 9 + Cột 10 - Cột 11 + Cột 13: ghi số đơn/vụ có kiến nghị của đại biểu Quốc hội.
- Dòng nguồn 9494: Cột 29 = Cột 18 + Cột 23 + Cột 28 + Cột 30 ghi tỷ lệ giải quyết đơn đề nghị giám đốc thẩm, tái thẩm.
- Dòng nguồn 9496: Cột 30 = Cột 29/Cột 12 x 100

## Gợi ý cấu trúc hàm tính
```pseudo
function tinh_cot(mau, cot, row):
    formula = FORMULA_CATALOG[mau][cot]
    return evaluate(formula, row)

function kiem_tra_mau(mau, row):
    errors = []
    for rule in VALIDATION_RULES[mau]:
        if not rule.pass(row): errors.add(rule.message)
    return errors
```

## Quy tắc kiểm tra dữ liệu tối thiểu
- Mọi số lượng vụ án, bị cáo, đương sự, pháp nhân phải là số nguyên không âm.
- Cột còn lại không được âm.
- Cột phân tích “trong đó” không vượt quá cột tổng tương ứng.
- Không cộng cột ghi chú/theo dõi vào tổng nếu tài liệu ghi rõ “đã được thống kê tại cột…” hoặc “không tính vào số liệu thống kê”.
- Khi có mâu thuẫn giữa công thức và mô tả chữ, ghi cảnh báo để cán bộ thống kê xác minh theo biểu mẫu gốc.
