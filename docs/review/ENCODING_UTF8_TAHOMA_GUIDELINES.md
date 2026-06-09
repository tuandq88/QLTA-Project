# Hướng dẫn tiếng Việt UTF-8 và font Tahoma

## Nguyên tắc chung

- Tất cả báo cáo hoàn thành, README, checklist và tài liệu review phải viết bằng tiếng Việt.
- File văn bản phải lưu mã hóa UTF-8.
- Không ghi secret, mật khẩu hoặc nội dung `.env.local` vào tài liệu.
- Nếu console PowerShell hiển thị mojibake, không suy luận rằng file sai mã hóa; cần kiểm tra bằng editor hỗ trợ UTF-8 hoặc dùng script ghi file UTF-8.

## PowerShell

Khi cần giảm rủi ro mojibake ở log runtime:

- Thông điệp `Write-Host` có thể dùng tiếng Việt không dấu.
- File kết quả dùng `Set-Content -Encoding UTF8`.
- Không coi `NOTICE` hoặc `WARNING` PostgreSQL là lỗi nếu `psql` trả exit code 0.

## Tài liệu có font

Khi xuất DOCX, PDF hoặc HTML dùng để in:

- Font mặc định: Tahoma.
- Cỡ chữ nội dung khuyến nghị: 11pt hoặc 12pt.
- Tiêu đề có thể dùng Tahoma Bold.

## Báo cáo database

Báo cáo database phải nêu rõ:

- File đã đọc.
- File đã sửa/tạo.
- Kết quả chạy script.
- Lỗi còn lại.
- Lệnh PowerShell để chạy lại.
