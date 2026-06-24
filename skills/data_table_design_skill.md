# Data Table Design Skill

## Skill ID

`DATA_TABLE_DESIGN_SKILL`

## Mục đích

Thiết kế bảng dữ liệu hồ sơ, danh sách thống kê, danh sách phân công án và danh sách theo dõi kháng cáo/kháng nghị.

## Stack ưu tiên khi frontend đã sẵn sàng

- TanStack Table cho bảng phức tạp.
- shadcn/ui: `table`, `button`, `dropdown-menu`, `badge`, `input`, `select`, `pagination`, `skeleton`, `alert`.
- Lucide React cho action icon và trạng thái.

## Tính năng bắt buộc

- Tìm kiếm.
- Lọc theo đơn vị, loại án, trạng thái, thời hạn, Thẩm phán hoặc kỳ thống kê nếu phù hợp.
- Sắp xếp.
- Phân trang.
- Hiển thị trạng thái hồ sơ.
- Cảnh báo thời hạn/sắp quá hạn/quá hạn.
- Thao tác theo phân quyền.
- Column visibility nếu bảng nhiều cột.
- Export chỉ khi quyền và nguồn dữ liệu cho phép.

## Quy tắc chống đếm trùng

- Luôn ghi rõ row entity: `case_file`, `case_occurrence`, `case_resolution_event`, `defendant`, `appellate_tracking` hoặc entity khác.
- Không group theo `case_id` nếu skill yêu cầu occurrence-level hoặc defendant-level.
- Với dashboard drill-down, tổng ở chart phải khớp số dòng sau filter hoặc có giải thích aggregation.

## Trạng thái bắt buộc

- `loading`: skeleton row.
- `empty`: chưa có bản ghi theo filter.
- `error`: lỗi tải dữ liệu hoặc filter không hợp lệ.
- `readonly`: ẩn action sửa/xóa, giữ action xem.
- `permission_denied`: không tải dữ liệu vượt quyền hoặc không hiện action.

## Không được làm

- Không hard-code cột nghiệp vụ nếu chưa đối chiếu Data Dictionary.
- Không dùng màu làm tín hiệu duy nhất; phải có text/badge.
- Không tạo thao tác ghi dữ liệu nếu chưa có workflow xác nhận/audit.

## Output

```yaml
Table name:
Row entity:
Columns:
Search:
Filters:
Sorting:
Pagination:
Status badges:
Deadline warnings:
Row actions:
Permissions:
Anti-duplication:
States:
Implementation notes:
```

