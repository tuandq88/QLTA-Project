# Thiết kế màn hình Quản lý vụ án V1

## 1. Design Read

Màn hình `CaseManagementPage` là màn hình nghiệp vụ chính cho lãnh đạo, Thẩm phán, Thư ký, thống kê viên và quản trị theo dõi hồ sơ vụ án/vụ việc.

Ngôn ngữ thiết kế:

- nghiêm túc, rõ ràng, phù hợp cơ quan nhà nước;
- ưu tiên đọc nhanh, lọc nhanh, kiểm tra dữ liệu và truy xuất nguồn;
- mật độ thông tin trung bình-cao, motion rất thấp;
- không dùng hero marketing, card rỗng, hiệu ứng trang trí hoặc placeholder nghiệp vụ giả.

## 2. Mục tiêu nghiệp vụ

- Xem danh sách hồ sơ vụ án/vụ việc đang quản lý.
- Tìm kiếm, lọc, sắp xếp hồ sơ theo các trường đã có trong schema.
- Mở nhanh chi tiết hồ sơ để kiểm tra vòng đời, người tham gia tố tụng, phiên tòa, quyết định, thời hạn, validation và cảnh báo.
- Hỗ trợ các trạng thái dữ liệu bắt buộc: `loading`, `empty`, `error`, `readonly`, `permission_denied`.
- Chuẩn bị sẵn cấu trúc để sau này nối API, không hard-code nghiệp vụ, chỉ tiêu, công thức hoặc căn cứ pháp lý.

## 3. Route và component đề xuất

```text
Route: /cases
Page: CaseManagementPage
```

Component:

- `CaseManagementPage`: màn hình tổng.
- `CaseCommandBar`: thanh thao tác và chế độ xem.
- `CaseFilterPanel`: bộ lọc hồ sơ.
- `CaseDataTable`: bảng danh sách hồ sơ.
- `CaseDetailWorkspace`: vùng chi tiết hồ sơ.
- `CaseLifecycleTimeline`: diễn biến/vòng đời hồ sơ.
- `CaseWarningPanel`: cảnh báo thời hạn, validation, dữ liệu thiếu.
- `CasePermissionActionBar`: thao tác theo quyền.
- `DataState`: trạng thái `loading`, `empty`, `error`, `readonly`, `permission_denied`.

## 4. Bố cục màn hình

### 4.1 Desktop

```text
┌────────────────────────────────────────────────────────────────────────────┐
│ Header: Quản lý vụ án | Năm công tác | Đơn vị | Trạng thái hệ thống        │
├────────────────────────────────────────────────────────────────────────────┤
│ Command bar: Tạo hồ sơ | Nhập Excel | Xuất | Làm mới | Chế độ chỉ xem       │
├────────────────────────────────────────────────────────────────────────────┤
│ Filter panel: tìm kiếm, loại án, cấp xét xử, tòa án, ngày, trạng thái      │
├──────────────────────────────────────────────┬─────────────────────────────┤
│ CaseDataTable                                │ CaseDetailWorkspace         │
│ - STT                                        │ - Header hồ sơ              │
│ - Số/mã hồ sơ                                │ - Cảnh báo                  │
│ - Tóm tắt/tên hiển thị                       │ - Tabs/sections             │
│ - Loại án/cấp xét xử                         │ - Thông tin chung           │
│ - Tòa án                                     │ - Vòng đời                  │
│ - Ngày thụ lý/ngày giải quyết                │ - Người tham gia            │
│ - Trạng thái/cảnh báo                        │ - Phiên tòa/quyết định      │
│ - Thao tác xem                               │ - Validation/AI tham khảo   │
└──────────────────────────────────────────────┴─────────────────────────────┘
```

Tỷ lệ đề xuất:

- Bảng danh sách: 60-65% chiều rộng.
- Chi tiết hồ sơ: 35-40% chiều rộng, có thể thu gọn/mở rộng.

### 4.2 Tablet

- Filter panel chuyển thành 2 cột.
- Detail workspace mở dạng drawer hoặc full-width panel bên dưới bảng.
- Bảng giữ horizontal scroll cho cột nghiệp vụ, không ép chữ quá nhỏ.

### 4.3 Mobile

Chưa ưu tiên ở V1. Nếu cần, chỉ hiển thị danh sách dạng compact và mở chi tiết dạng full-screen drawer.

## 5. Bộ lọc bắt buộc

Các bộ lọc phải lấy danh mục từ API hoặc nguồn danh mục chuẩn, không hard-code danh mục nghiệp vụ:

- Tìm kiếm theo số/mã hồ sơ hoặc tóm tắt/tên hiển thị.
- Tòa án quản lý: `case_files.court_id -> courts.court_name`.
- Loại án: `case_files.case_type` hoặc danh mục tương ứng khi API đã join.
- Cấp xét xử/nhóm án: `case_files.case_group`, chỉ dùng cho `SO_THAM`/`PHUC_THAM`.
- Trạng thái hồ sơ: `case_files.case_status`.
- Ngày thụ lý: ưu tiên `case_occurrences.acceptance_date`, fallback `case_files.acceptance_date`.
- Ngày giải quyết: ưu tiên `case_resolution_events.event_date` với `counted_as_resolved = TRUE`, fallback `case_files.closed_date`.
- Cảnh báo: quá hạn, sắp hết hạn, thiếu dữ liệu, có validation mở.

Nếu dùng năm công tác, `working_year = Y` phải quy đổi thành `from_date = (Y - 1)-10-01`, `to_date = Y-09-30`.

## 6. Bảng danh sách hồ sơ

### 6.1 Cột mặc định

| Cột UI | Nguồn dữ liệu |
|---|---|
| STT | số thứ tự trên trang hiện tại |
| Số/mã hồ sơ | `case_files.case_number`, `case_files.case_code` |
| Tóm tắt/tên hiển thị | `case_files.summary`; schema hiện chưa có `case_title` |
| Loại án | `case_files.case_type` hoặc danh mục join |
| Cấp xét xử | `case_files.case_group` |
| Tòa án | `case_files.court_id -> courts.court_name` |
| Ngày thụ lý | `case_occurrences.acceptance_date`, fallback `case_files.acceptance_date` |
| Ngày giải quyết | `case_resolution_events.event_date`, fallback `case_files.closed_date` |
| Trạng thái | `case_files.case_status`, `case_files.resolution_status` |
| Cảnh báo | `deadlines`, `validation_results`, `case_risk_flags` |
| Thao tác | xem chi tiết, sửa, xuất, khóa theo quyền |

### 6.2 Sắp xếp

- Ngày thụ lý.
- Ngày giải quyết.
- Loại án.
- Cấp xét xử.
- Tòa án.
- Trạng thái.

### 6.3 Nguyên tắc chống đếm trùng

- Màn hình quản lý có thể hiển thị một dòng theo `case_files.case_id`.
- Khi dùng cho báo cáo/thống kê theo kỳ, phải hiển thị hoặc truy xuất theo `case_occurrences.occurrence_id` nếu skill nghiệp vụ yêu cầu.
- Không dùng `UNION ALL` để nhân dòng thụ lý/giải quyết/còn lại trong cùng một danh sách.
- Với án phúc thẩm, không dùng `case_files.court_id` thay cho `first_instance_court_id` khi cần Tòa án sơ thẩm.

## 7. Chi tiết hồ sơ vụ án

Chi tiết hồ sơ nên là panel bên phải trên desktop, drawer/full-width trên tablet.

### 7.1 Header chi tiết

Hiển thị:

- Tóm tắt/tên hiển thị hồ sơ.
- `case_code`, `case_number` nếu có.
- Loại án, cấp xét xử, trạng thái.
- Tòa án quản lý.
- Cờ cảnh báo: quá hạn, thiếu dữ liệu, validation, AI tham khảo.

Nếu không có dữ liệu, hiển thị `Chưa có dữ liệu`.

### 7.2 Nhóm thông tin

Các section/tabs:

1. **Thông tin chung**
   - `case_files.case_code`
   - `case_files.case_number`
   - `case_files.case_type`
   - `case_files.case_group`
   - `case_files.procedure_law`
   - `case_files.current_stage`
   - `case_files.case_status`
   - `case_files.resolution_status`
   - `case_files.summary`

2. **Thông tin thụ lý**
   - `case_files.filing_date`
   - `case_files.acceptance_date`
   - `case_occurrences.occurrence_no`
   - `case_occurrences.acceptance_date`
   - `case_occurrences.acceptance_type_code`
   - `case_occurrences.source_note`

3. **Tòa án và cấp xét xử**
   - `case_files.court_id -> courts`
   - `case_files.first_instance_court_id -> courts`
   - `case_files.first_instance_case_number`
   - `case_files.first_instance_judgment_number`
   - `case_files.first_instance_judgment_date`

4. **Người tiến hành tố tụng**
   - `case_hearing_members`
   - `court_staff`
   - role chuẩn: `PRESIDING_JUDGE`, `PANEL_JUDGE`, `HEARING_CLERK`

5. **Người tham gia tố tụng / đương sự / bị cáo**
   - `participants`
   - với hình sự: `criminal_case_details`, `defendants`
   - không tạo tên giả nếu dữ liệu thiếu.

6. **Diễn biến xử lý hồ sơ**
   - `case_events`
   - `case_occurrences`
   - `case_resolution_events`

7. **Phiên tòa / lịch xét xử**
   - `hearings`
   - `case_hearing_members`

8. **Quyết định / kết quả giải quyết**
   - `decisions`
   - `case_resolution_events`
   - với hình sự phúc thẩm nhiều bị cáo: `criminal_appellate_defendant_results`

9. **Kháng cáo / kháng nghị**
   - `appeals`
   - `appellate_trackings`
   - `appeal_protest_items`
   - `appellate_results`

10. **Thời hạn / cảnh báo**
    - `deadlines`
    - `case_risk_flags`
    - trạng thái hiển thị: bình thường, sắp hết hạn, quá hạn, thiếu dữ liệu.

11. **Tài liệu / văn bản**
    - `documents`

12. **Validation**
    - `validation_results`
    - severity: `INFO`, `WARNING`, `ERROR`, `CRITICAL`
    - hiển thị `field_name`, `message`, `suggested_action`, `legal_basis` nếu có.

13. **AI tham khảo**
    - `ai_suggestions`
    - chỉ hiển thị đề xuất/cảnh báo, không cho ghi đè dữ liệu chính.

14. **Audit**
    - `audit_logs`
    - chỉ hiển thị khi có quyền xem audit.

## 8. Command bar và quyền thao tác

Nút/command đề xuất:

- `Tạo hồ sơ`: chỉ hiện khi có quyền tạo.
- `Nhập dữ liệu`: chỉ hiện khi có quyền import.
- `Xuất danh sách`: disabled nếu không có quyền xuất.
- `Sửa hồ sơ`: disabled hoặc ẩn khi `readonly`.
- `Khóa hồ sơ`: chỉ dùng khi workflow backend cho phép.
- `Xem audit`: chỉ hiện khi có quyền.
- `Làm mới`: luôn có nếu được xem danh sách.

Trạng thái quyền:

- `readonly`: vẫn xem được, các thao tác ghi bị disabled.
- `permission_denied`: hiển thị màn hình từ chối truy cập, không render dữ liệu.

## 9. Trạng thái UI bắt buộc

- `loading`: skeleton/table loading, không nhấp thao tác ghi.
- `empty`: hiển thị không có hồ sơ phù hợp, giữ filter để người dùng chỉnh.
- `error`: báo lỗi tải dữ liệu, có nút thử lại.
- `readonly`: banner “Chế độ chỉ xem”.
- `permission_denied`: không hiển thị dữ liệu hồ sơ.

## 10. Validation và cảnh báo

Cảnh báo trên danh sách:

- Hồ sơ quá hạn hoặc sắp hết hạn từ `deadlines`.
- Thiếu ngày thụ lý khi trạng thái đã thụ lý.
- Đã giải quyết nhưng thiếu ngày/kết quả giải quyết.
- Thiếu Thẩm phán chủ tọa hoặc Thư ký nếu dữ liệu phiên tòa yêu cầu.
- Hồ sơ phúc thẩm thiếu `first_instance_court_id`.
- Có validation mở trong `validation_results`.

Không tự kết luận lỗi nghiệp vụ nếu chưa có rule hoặc nguồn dữ liệu tương ứng.

## 11. Gợi ý visual hierarchy

- Nền tổng thể sáng, trung tính.
- Bảng là bề mặt chính, không đặt trong nhiều lớp card lồng nhau.
- Panel chi tiết có header cố định và section rõ ràng.
- Dùng màu cảnh báo tiết chế:
  - đỏ: lỗi nghiêm trọng/quá hạn;
  - vàng: sắp hết hạn/thiếu dữ liệu;
  - xanh: đã giải quyết/hoàn tất;
  - xám: chưa có dữ liệu/readonly.
- Icon chỉ dùng để tăng nhận diện thao tác, không thay text nghiệp vụ quan trọng.

## 12. API contract cần chuẩn bị

Danh sách:

```text
GET /api/cases
```

Query đề xuất:

```yaml
search:
court_id:
case_type:
case_group:
case_status:
acceptance_from:
acceptance_to:
resolution_from:
resolution_to:
warning:
page:
page_size:
sort:
```

Chi tiết:

```text
GET /api/cases/{case_id}
```

Response nên gom sẵn các nhóm:

```yaml
case:
court:
first_instance_court:
occurrences:
resolution_events:
participants:
hearing_members:
hearings:
decisions:
appeals:
appellate_tracking:
deadlines:
documents:
validation_results:
risk_flags:
ai_suggestions:
audit_logs:
permissions:
```

## 13. Những điểm chưa xác định trong nguồn hiện có

- Schema hiện chưa có cột `case_title`; màn hình chỉ được dùng `case_files.summary` hoặc trường tổng hợp từ API để hiển thị tên/tóm tắt hồ sơ.
- Một số cột danh mục `_id` được mô tả trong data dictionary nhưng unified schema hiện còn giữ cả dạng text/enum; API cần chuẩn hóa display name trước khi đưa lên UI.
- Workflow khóa hồ sơ/chỉnh sửa/xuất báo cáo chưa có contract quyền chi tiết; UI chỉ thiết kế trạng thái disabled/hidden.
- Màn hình mobile chưa phải ưu tiên V1.

## 14. Definition of Done cho bước triển khai code

- Có component danh sách, filter, table, detail workspace, warning panel và data state.
- Có responsive desktop/tablet.
- Có accessibility cơ bản: label filter, focus state, keyboard navigation, contrast đủ.
- Không hard-code dữ liệu nghiệp vụ thật.
- Chạy được `typecheck/build` nếu frontend có script.
- Không sửa backend, database, schema, seed, migration hoặc logic thống kê.
