# IMPLEMENTATION NOTES - LAO ĐỘNG

## Mã hóa biểu mẫu
- LD_ST_5A: Sơ thẩm
- LD_PT_5B: Phúc thẩm
- LD_GDT: Giám đốc thẩm
- LD_TT: Tái thẩm

## Cơ chế tính an toàn
- Với phép chia tỷ lệ, nếu mẫu số = 0 thì trả về null, không trả về 0 để tránh hiểu sai.
- Luôn tính lại các cột công thức khi kết xuất báo cáo.
- Mọi chỉnh sửa tay vào cột công thức phải lưu audit log.

## Nhóm cảnh báo ưu tiên cao
- Còn lại âm.
- Đã giải quyết lớn hơn phải giải quyết.
- Tổng chi tiết kết quả xét xử phúc thẩm khác số xét xử/giải quyết.
- Tổng phân tích giám đốc thẩm/tái thẩm khác số đã xét xử.
- Chi tiết tạm đình chỉ lớn hơn tổng tạm đình chỉ.
