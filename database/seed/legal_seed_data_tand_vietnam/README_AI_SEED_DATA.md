# Bộ Seed Data danh mục vụ việc/TAND Việt Nam

Ngày tạo: 2026-06-09

## Nguồn pháp lý chính
- Bộ luật Hình sự - VBHN 135/VBHN-VPQH năm 2025.
- Bộ luật Tố tụng dân sự - VBHN 99/VBHN-VPQH năm 2025.
- Luật Tố tụng hành chính - VBHN 109/VBHN-VPQH năm 2025.

## Phạm vi dữ liệu
- Tội danh hình sự: 312 dòng, trích từ các điều có tiêu đề bắt đầu bằng “Tội ...” trong Phần các tội phạm của Bộ luật Hình sự.
- Quan hệ/yêu cầu/vụ việc ngoài hình sự: 79 dòng, trích theo Điều 26-33 BLTTDS và Điều 30 Luật TTHC.

## Lưu ý sử dụng
Danh mục này là seed data cấp luật để AI và hệ thống tra cứu, phân loại ban đầu. Các dòng “các tranh chấp/yêu cầu khác” được giữ nguyên theo luật, không tự diễn giải thành quan hệ pháp luật chi tiết. Khi nhập liệu thực tế, nên có trường `custom_legal_relation` để ghi nhận quan hệ cụ thể do Thẩm phán/Thư ký xác định.
