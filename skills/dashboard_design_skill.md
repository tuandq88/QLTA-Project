# Dashboard Design Skill

## Skill ID

`DASHBOARD_DESIGN_SKILL`

## Mục đích

Thiết kế dashboard điều hành, KPI, biểu đồ, cảnh báo thời hạn và drill-down cho lãnh đạo TAND hai cấp tỉnh Quảng Ngãi.

## Stack ưu tiên khi frontend đã sẵn sàng

- Recharts cho biểu đồ miễn phí, mã nguồn mở.
- Tremor chỉ dùng nếu phù hợp license/stack và không kéo dependency không cần thiết.
- shadcn/ui: `card`, `badge`, `tabs`, `table`, `alert`, `skeleton`, `select`, `popover`.
- Lucide React cho icon trạng thái.

## Quy tắc dashboard

- Mọi KPI phải có Formula Catalog hoặc nguồn công thức rõ ràng.
- Không hiển thị số liệu tổng nếu thiếu nguồn dữ liệu, kỳ thống kê hoặc quyền xem.
- Luôn có bộ lọc thời gian, đơn vị, loại án hoặc cấp xét xử khi nghiệp vụ cần.
- Số liệu phải drill-down được tới bảng/list nguồn hoặc ghi rõ chưa có API.
- Cảnh báo quá hạn/sắp hết hạn phải dựa trên Validation Rules hoặc deadline rule có căn cứ.
- Không đếm trùng: nêu rõ đơn vị đếm là case, occurrence, event, defendant hay tracking item.

## Trạng thái bắt buộc

- `loading`: skeleton KPI/chart.
- `empty`: chưa có số liệu trong kỳ hoặc thiếu bộ lọc.
- `error`: lỗi tải dữ liệu/công thức.
- `readonly`: xem dashboard không có thao tác quản trị.
- `permission_denied`: không hiện KPI vượt quyền.

## Không được làm

- Không tạo KPI/chỉ tiêu mới.
- Không suy đoán lỗi chủ quan/khách quan khi thiếu căn cứ.
- Không vẽ biểu đồ trang trí nếu không giúp ra quyết định.

## Output

```yaml
Dashboard name:
Audience:
Filters:
KPI cards:
Charts:
Alerts:
Drill-down:
Formula sources:
Anti-duplication:
States:
Permissions:
Implementation notes:
```

