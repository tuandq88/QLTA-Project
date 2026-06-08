# Implementation notes - án Hành chính

## Kiến trúc khuyến nghị
1. Bảng nghiệp vụ vụ án hành chính.
2. Bảng lịch sử trạng thái vụ án theo kỳ.
3. Bảng đương sự/người tham gia tố tụng.
4. Bảng thông tin phúc thẩm/giám đốc thẩm/tái thẩm.
5. Bảng snapshot thống kê theo kỳ để khóa số liệu sau khi duyệt.

## Quy trình tính
- Bước 1: lấy danh sách vụ án thuộc kỳ thống kê.
- Bước 2: phân loại theo mẫu 6A/6B/6C/6D.
- Bước 3: ánh xạ mỗi vụ án vào một dòng loại khiếu kiện.
- Bước 4: cộng các cột nhập liệu.
- Bước 5: tính lại cột công thức từ formula_catalog.
- Bước 6: chạy validation_rules.
- Bước 7: sinh file báo cáo/dashboard.

## Cảnh báo cần hiển thị cho lãnh đạo
- Đơn vị có tỷ lệ quá hạn cao.
- Số còn lại tăng bất thường so với kỳ trước.
- Tỷ lệ hủy/sửa phúc thẩm cao.
- Vụ có bồi thường thiệt hại lớn.
- Vụ hành chính có yếu tố nước ngoài hoặc áp dụng án lệ.
