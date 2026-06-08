# Ghi chú rà soát schema hợp nhất

File `unified_postgresql_schema.sql` hiện đã có nền tảng tốt: enum chính, bảng master data, hồ sơ lõi, module án chuyên biệt, phân công ngẫu nhiên, phúc thẩm/kháng cáo-kháng nghị, thống kê/KPI và lớp AI/audit.

## Điểm đã chuẩn hóa bằng migration 002

- Bổ sung ràng buộc chống trùng ở cấp database cho các vùng dễ phát sinh dữ liệu lặp: mã email người dùng, số vụ án theo tòa/loại án, đương sự theo danh tính trong cùng hồ sơ, tài liệu theo số văn bản, phân công thẩm phán chính active, snapshot thống kê, KPI, batch phân công, tracking phúc thẩm/kháng cáo-kháng nghị, validation/risk đang mở.
- Bổ sung check constraint tối thiểu cho ngày tháng và giá trị số: ngày kết thúc không trước ngày bắt đầu, số liệu thống kê/KPI không âm, thứ tự phân công dương, phân loại lỗi chủ quan phải có nhóm lý do.
- Bổ sung index đọc nhanh cho dashboard, pool phân công án, lịch xét xử, hạn xử lý, thống kê/KPI, phúc thẩm, validation, AI/risk và audit.

## Những điểm cố ý chưa đổi trực tiếp trong schema gốc

- Không đổi tên bảng/cột lõi để tránh phá các tài liệu skill/rule hiện có.
- Không sửa nội dung nghiệp vụ của skill hoặc công thức thống kê.
- Không thêm trigger, materialized view, partitioning hay `row_version` vào migration 002 vì yêu cầu migration lần này tập trung vào constraint/index.

## Điểm cần xác nhận nghiệp vụ trước khi siết thêm

- Một hồ sơ có được tồn tại nhiều bản ghi `appellate_trackings` cùng loại kháng cáo/kháng nghị cho cùng quyết định hay không.
- Khóa chống trùng của `participants` có đủ khi trùng họ tên nhưng khác người, hoặc thiếu số định danh.
- Chỉ số KPI nào có thể là tỷ lệ/điểm số âm trong trường hợp đặc biệt. Migration 002 đang mặc định số liệu KPI và thống kê không âm.
- Quy tắc trùng của `statistics_snapshots`: hiện khóa theo kỳ, tòa, hồ sơ, mã biểu, mã chỉ tiêu, cấp tổng hợp. Nếu cùng chỉ tiêu cần lưu nhiều phiên bản lịch sử thì phải thêm cột version hoặc trạng thái hiệu lực.
- Quy tắc trạng thái `tracking_status`, `validation_status`, `risk_type`, `status` ở các bảng text nên được chuẩn hóa thành enum hoặc bảng danh mục ở task sau.

## Khuyến nghị task sau

- Thêm optimistic locking bằng `row_version` cho bảng ghi thường xuyên.
- Tạo materialized view dashboard sau khi chốt công thức KPI và biểu thống kê.
- Dùng exclusion constraint cho `judge_status_periods` để chặn khoảng thời gian trạng thái thẩm phán chồng lấn.
- Cân nhắc partition theo thời gian cho audit/event/validation/statistics khi dữ liệu vận hành tăng mạnh.
