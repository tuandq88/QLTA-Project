# Skill: Công thức tính toán, thống kê án hình sự – Mẫu 1A và 1B

## Mục đích
Skill này dùng riêng cho việc xây dựng, kiểm tra, giải thích và sinh công thức thống kê án hình sự theo 02 biểu mẫu:

- **Mẫu 1A**: Thống kê thụ lý và giải quyết các vụ án hình sự sơ thẩm do cá nhân phạm tội.
- **Mẫu 1B**: Thống kê thụ lý và giải quyết các vụ án hình sự phúc thẩm do cá nhân phạm tội.

Skill này được tách từ skill thống kê nghiệp vụ Tòa án tổng quát và danh mục công thức `formula_catalog.json`. Khi triển khai hệ thống, không thiết kế màn hình nhập liệu theo toàn bộ cột biểu mẫu; phải thiết kế theo vòng đời vụ án/bị cáo, sau đó sinh báo cáo thống kê tự động.

## Phạm vi áp dụng

| Mã mẫu | Cấp xét xử | Chủ thể thống kê | Số cột biểu mẫu | Đơn vị ghi nhận |
|---|---|---:|---:|---|
| 1A | Sơ thẩm | Cá nhân phạm tội | 94 | Vụ án, bị cáo |
| 1B | Phúc thẩm | Cá nhân phạm tội | 77 | Vụ án, bị cáo, kháng cáo, kháng nghị |

## Nguyên tắc chung

1. Lưu dữ liệu gốc theo **vụ án** và **bị cáo**, không lưu trực tiếp theo cột biểu mẫu nếu có thể tránh.
2. Các chỉ tiêu **tổng số**, **phải giải quyết**, **đã giải quyết**, **còn lại** là chỉ tiêu công thức, không cho nhập tay thông thường.
3. Các chỉ tiêu “trong đó”, “phân tích” là chỉ tiêu chi tiết, không cộng trùng vào tổng nếu đã nằm trong tổng.
4. Một vụ án có thể có nhiều bị cáo; công thức phải tách rõ đơn vị đếm **vụ** và **bị cáo**.
5. Khi vụ án phúc thẩm vừa có kháng cáo vừa có kháng nghị, ưu tiên thống kê vào nhóm **kháng nghị** khi xác định nguồn phải giải quyết/còn lại.
6. Khi xuất báo cáo, tính lại công thức tại thời điểm kết xuất theo kỳ thống kê, đơn vị Tòa án, cấp xét xử, mẫu, dòng/chỉ tiêu và cột.

---

# 1. Mẫu 1A – Hình sự sơ thẩm do cá nhân phạm tội

## 1.1. Dữ liệu nhập thủ công tối thiểu

### A. Thông tin định danh vụ án
- Mã vụ án nội bộ
- Số thụ lý
- Ngày thụ lý
- Đơn vị Tòa án
- Tội danh
- Điều luật áp dụng
- Thẩm phán, thư ký

### B. Dữ liệu đầu kỳ và phát sinh trong kỳ
- Vụ án cũ còn lại
- Bị cáo cũ còn lại
- Vụ án mới thụ lý
- Bị cáo mới thụ lý
- Vụ án chuyển đi/chuyển vụ án
- Bị cáo chuyển đi/chuyển vụ án

### C. Dữ liệu quá trình giải quyết
- Đình chỉ: vụ/bị cáo
- Trả hồ sơ cho Viện kiểm sát: vụ/bị cáo
- Xét xử: vụ/bị cáo
- Tạm đình chỉ: vụ/bị cáo
- Vụ quá hạn luật định và nguyên nhân chủ quan/khách quan
- Vụ án yêu cầu VKS bổ sung tài liệu, chứng cứ
- Vụ án điểm hoặc xét xử lưu động
- Vụ án xét xử theo thủ tục rút gọn
- Vụ án liên quan bạo lực gia đình
- Vi phạm thời hạn tạm giam trong giai đoạn xét xử
- Tòa án phục hồi vụ án
- Tòa án xác minh, thu thập, bổ sung chứng cứ
- Khởi tố vụ án tại phiên tòa

### D. Dữ liệu kết quả xét xử và bị cáo
- Không có tội
- Miễn trách nhiệm hình sự hoặc miễn hình phạt
- Giáo dục tại trường giáo dưỡng
- Án treo
- Hình phạt chính: cảnh cáo, phạt tiền, cải tạo không giam giữ, trục xuất, tù theo khung thời hạn, chung thân, tử hình
- Hình phạt bổ sung
- Thiệt hại, tài sản chiếm đoạt, tài sản thu hồi, bồi thường
- Nhân thân bị cáo: công chức/viên chức, đảng viên, không nghề nghiệp, tái phạm, nghiện ma túy, dân tộc thiểu số, nữ, độ tuổi, người nước ngoài
- Nhân thân người bị hại
- Người bào chữa/người bảo vệ quyền lợi hợp pháp
- Án lệ, phiên tòa rút kinh nghiệm

## 1.2. Công thức cốt lõi

| Cột | Tên chỉ tiêu | Công thức |
|---:|---|---|
| 9 | Tổng số vụ án phải giải quyết | `C9 = C3 + C5 - C7` |
| 10 | Tổng số bị cáo phải giải quyết | `C10 = C4 + C6 - C8` |
| 37 | Tổng số vụ án đã giải quyết | `C37 = C11 + C13 + C16` |
| 38 | Tổng số bị cáo đã giải quyết | `C38 = C12 + C14 + C17` |
| 39 | Tổng số vụ án còn lại | `C39 = C9 - C37` |
| 40 | Số bị cáo còn lại | `C40 = C10 - C38` |

## 1.3. Quy tắc kiểm tra tự động

- `C9 >= C37`
- `C10 >= C38`
- `C39 >= 0`
- `C40 >= 0`
- Cột vụ án không được cộng với cột bị cáo.
- Các nhóm hình phạt chính phải đối chiếu với số bị cáo đã xét xử.
- Một bị cáo chỉ được tính một lần trong nhóm hình phạt chính.

---

# 2. Mẫu 1B – Hình sự phúc thẩm do cá nhân phạm tội

## 2.1. Dữ liệu nhập thủ công tối thiểu

### A. Thông tin định danh vụ án phúc thẩm
- Mã vụ án phúc thẩm
- Số thụ lý phúc thẩm
- Ngày thụ lý phúc thẩm
- Đơn vị Tòa án phúc thẩm
- Đơn vị/Tòa án sơ thẩm nguồn
- Tội danh
- Điều luật áp dụng
- Thẩm phán, thư ký

### B. Dữ liệu nguồn thụ lý
- Cũ còn lại do kháng nghị: vụ/bị cáo
- Cũ còn lại do kháng cáo: vụ/bị cáo
- Mới thụ lý do kháng nghị: vụ/bị cáo
- Mới thụ lý do kháng cáo: vụ/bị cáo
- Số trường hợp vi phạm thời hạn tạm giam

### C. Dữ liệu kết quả giải quyết
- Rút kháng nghị: vụ/bị cáo
- Rút kháng cáo: vụ/bị cáo
- Đình chỉ vì lý do khác: kháng nghị/kháng cáo, vụ/bị cáo
- Xét xử do kháng nghị: vụ/bị cáo
- Xét xử do kháng cáo: vụ/bị cáo
- Tạm đình chỉ: vụ/bị cáo
- Số vụ quá hạn luật định và nguyên nhân

### D. Dữ liệu kết quả xét xử phúc thẩm
- Giữ nguyên bản án, quyết định sơ thẩm
- Miễn trách nhiệm hình sự hoặc miễn hình phạt
- Cho hưởng án treo/không cho hưởng án treo
- Giảm/tăng hình phạt; chuyển hình phạt nhẹ hơn/nặng hơn
- Thay đổi tội danh
- Sửa phần hình phạt bổ sung, biện pháp tư pháp
- Sửa phần bồi thường, vật chứng, phần khác
- Hủy bản án sơ thẩm và các lý do hủy
- Đình chỉ xét xử phúc thẩm
- Khởi tố vụ án tại phiên tòa
- Án tử hình: giữ nguyên, tăng lên, giảm, hủy để điều tra/xét xử lại
- Tòa án chấp nhận kháng nghị VKS
- Người bào chữa, án lệ, phiên tòa rút kinh nghiệm

## 2.2. Công thức cốt lõi

| Cột | Tên chỉ tiêu | Công thức |
|---:|---|---|
| 11 | Tổng số vụ án bị kháng nghị phải giải quyết | `C11 = C3 + C7` |
| 12 | Tổng số bị cáo bị kháng nghị phải giải quyết | `C12 = C4 + C8` |
| 13 | Tổng số vụ án bị kháng cáo phải giải quyết | `C13 = C5 + C9` |
| 14 | Tổng số bị cáo bị kháng cáo phải giải quyết | `C14 = C6 + C10` |
| 28 | Tổng số vụ án đã được Tòa án giải quyết | `C28 = C16 + C18 + C20 + C22 + C24 + C26` |
| 29 | Tổng số bị cáo đã được Tòa án giải quyết | `C29 = C17 + C19 + C21 + C23 + C25 + C27` |
| 30 | Số vụ án có kháng nghị còn lại | `C30 = C11 - (C16 + C20 + C24)` |
| 31 | Số bị cáo có kháng nghị còn lại | `C31 = C12 - (C17 + C21 + C25)` |
| 32 | Số vụ án có kháng cáo còn lại | `C32 = C13 - (C18 + C22 + C26)` |
| 33 | Số bị cáo có kháng cáo còn lại | `C33 = C14 - (C19 + C23 + C27)` |
| 34 | Tổng số vụ án còn lại phải giải quyết | `C34 = C30 + C32` |
| 35 | Tổng số bị cáo còn lại phải giải quyết | `C35 = C31 + C33` |

## 2.3. Quy tắc kiểm tra tự động

- `C30 >= 0`, `C31 >= 0`, `C32 >= 0`, `C33 >= 0`.
- `C34 = C30 + C32`.
- `C35 = C31 + C33`.
- `C28 <= C11 + C13`.
- `C29 <= C12 + C14`.
- Không cộng trùng vụ án vừa kháng cáo vừa kháng nghị; ưu tiên nhóm kháng nghị.

---

# 3. Gợi ý mô hình tính toán trong hệ thống

## 3.1. Bảng dữ liệu nền

- `criminal_cases`: thông tin vụ án
- `criminal_defendants`: thông tin bị cáo
- `criminal_case_events`: sự kiện tố tụng theo dòng thời gian
- `criminal_first_instance_results`: kết quả sơ thẩm
- `criminal_appeal_sources`: nguồn kháng cáo/kháng nghị phúc thẩm
- `criminal_appeal_results`: kết quả phúc thẩm
- `criminal_stat_periods`: kỳ thống kê
- `criminal_stat_cells`: số liệu kết xuất theo mẫu, dòng, cột
- `criminal_formula_rules`: danh mục công thức
- `criminal_validation_errors`: lỗi kiểm tra chéo

## 3.2. Quy trình sinh báo cáo

1. Chọn kỳ thống kê, đơn vị Tòa án, mẫu 1A hoặc 1B.
2. Lọc vụ án thuộc kỳ thống kê.
3. Gom nhóm theo tội danh và điều luật.
4. Tính các cột nhập liệu từ dữ liệu vụ án/bị cáo/sự kiện.
5. Tính các cột công thức.
6. Chạy kiểm tra chéo.
7. Sinh bảng thống kê và lưu nhật ký kết xuất.

## 3.3. Nguyên tắc phân loại nguồn dữ liệu

| Loại trường | Cách xử lý |
|---|---|
| Nhập thủ công | Dữ liệu nghiệp vụ chưa thể suy ra: tội danh, kết quả xét xử, lý do đình chỉ, tình tiết đặc thù |
| Tự động tính từ hồ sơ | Số bị cáo, độ tuổi, giới tính, số ngày còn hạn, quá hạn, nhóm tội danh |
| Công thức tổng hợp | Tổng phải giải quyết, tổng đã giải quyết, còn lại, tổng theo kháng cáo/kháng nghị |
| Kiểm tra chéo | So sánh tổng - chi tiết, vụ - bị cáo, số còn lại không âm |

## 4. Cách dùng skill này khi viết công thức

Khi người dùng yêu cầu công thức cho một cột, hãy trả lời theo cấu trúc:

```text
Mẫu: 1A hoặc 1B
Cột: số cột
Tên chỉ tiêu:
Nguồn dữ liệu:
Công thức:
Điều kiện lọc:
Kiểm tra chéo:
Gợi ý trường nhập liệu:
```

Ví dụ:

```text
Mẫu: 1A
Cột: 39
Tên chỉ tiêu: Tổng số vụ án còn lại
Nguồn dữ liệu: cột tổng phải giải quyết và tổng đã giải quyết
Công thức: C39 = C9 - C37
Kiểm tra chéo: C39 không được âm
```

## 5. Lưu ý triển khai

- Không để người dùng nhập trực tiếp các cột công thức, trừ quyền hiệu chỉnh đặc biệt có ghi nhật ký.
- Cần lưu cả số liệu theo vụ án và số liệu đã tổng hợp để đối chiếu khi có sai lệch.
- Mọi lần xuất báo cáo phải có mã kỳ, thời điểm xuất, người xuất, phiên bản công thức.
- Khi thay đổi công thức, phải tăng phiên bản skill/catalog để bảo toàn lịch sử báo cáo.
