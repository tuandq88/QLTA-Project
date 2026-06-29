# Kế hoạch xử lý và triển khai báo cáo thống kê theo loại án

Phiên bản: 1.0
Ngày lập: 29/06/2026

```yaml
Task: Chuẩn hóa và triển khai báo cáo thống kê theo từng loại án, cấp xét xử
Objective: Tạo API, service tính toán và xuất Excel theo biểu mẫu tham chiếu; số liệu truy vết được và không đếm trùng
Input: unified schema, catalog thống kê, skill theo Quyết định 287, workbook trong bieu_mau/
Output: Mapping machine-readable, API/service, Excel export và test
Dependencies: PostgreSQL theo unified schema; mapping nguồn được duyệt theo từng mẫu
Validation: Đúng cấp xét xử, đúng kỳ báo cáo, đúng công thức 287, đúng vị trí biểu mẫu, không ghi ô thiếu nguồn
Owner Agent: Backend/Reporting Agent
Priority: Cao
```

## 1. Quyết định phạm vi

### Trạng thái thực hiện ngày 29/06/2026

- [x] T01 - Mapping machine-readable cho 12 mẫu A/B.
- [x] T02 - Clone/làm sạch template trong bộ nhớ, không sửa `bieu_mau/`.
- [x] T03 - Seed 12 form, 585 item và 93 formula ref.
- [x] T04 - Mapping các nguồn hiện có; ô thiếu nguồn được đánh dấu `unmapped`.
- [x] T05 - Calculation service, trace và validation nền.
- [x] T06 - API danh sách/xem trước/xuất.
- [x] T07 - Export XLSX đúng workbook/sheet tham chiếu.
- [x] T08 - Unit/template/database/runtime smoke test.
- [ ] Hoàn thiện toàn bộ catalog phân rã dòng và các ô `unmapped` để báo cáo chuyển từ `incomplete` sang `complete`.

### 1.1. Phạm vi giai đoạn đầu

Triển khai 12 mẫu sơ thẩm/phúc thẩm:

| Loại án | Sơ thẩm | Phúc thẩm |
|---|---|---|
| Hình sự | 1A - 91 cột theo hướng dẫn | 1B - 77 cột |
| Dân sự | 2A - 34 cột | 2B - 49 cột |
| Hôn nhân gia đình | 3A - 36 cột | 3B - 49 cột |
| Kinh doanh thương mại | 4A - 32 cột | 4B - 49 cột |
| Lao động | 5A - 35 cột | 5B - 49 cột |
| Hành chính | 6A - 37 cột | 6B - 47 cột |

Giám đốc thẩm, tái thẩm, phá sản và các loại `civil_matter`, `administrative_measure`, `other` được tách thành backlog sau khi 12 mẫu trên ổn định.

### 1.2. Xử lý cột phát sinh trong workbook

| Mẫu | Cột workbook | Cột triển khai | Cột tạm bỏ qua |
|---|---:|---:|---|
| 1A | 94 | 91 | C92-C94 |
| 3A | 37 | 36 | C37 |
| 4A | 35 | 32 | C33-C35 |
| 5A | 38 | 35 | C36-C38 |

Quy tắc:

- Không xóa cột phát sinh khỏi file nguồn trong `bieu_mau/`.
- Template dẫn xuất vẫn có thể giữ bố cục các cột này, nhưng exporter không tính và không ghi số liệu.
- Không ghi `0` vào cột bị bỏ qua; để trống và ghi metadata `deferred_columns` trong trace.
- Tạo backlog riêng để xác minh căn cứ, ý nghĩa, nguồn và công thức của từng cột phát sinh.

### 1.3. Trạng thái báo cáo

- `complete`: mọi ô được yêu cầu trong phạm vi có nguồn và validation hợp lệ.
- `incomplete`: còn ô chưa có nguồn; API trả cảnh báo và danh sách ô thiếu.
- `invalid`: sai công thức, đếm trùng, sai cấp xét xử hoặc sai biên thời gian; không cho xuất bản chính thức.

Ô chưa truy vết được phải để trống. Không dùng `0` thay cho “không có nguồn dữ liệu”.

## 2. Công việc phải thực hiện

### T01 - Chuẩn hóa hợp đồng mapping

```yaml
Task: Tạo schema mapping thống kê machine-readable
Objective: Chuẩn hóa quan hệ form -> dòng -> cột -> nguồn -> công thức -> validation -> ô Excel
Input: JSON hiện có, unified schema, skill thống kê
Output: knowledge_base/data/statistics/report_mapping.schema.json và mapping theo từng mẫu
Dependencies: Không có
Validation: JSON parse được; mọi tên bảng/cột tồn tại; không có alias khái niệm chưa ánh xạ
Owner Agent: Data Dictionary/Formula Agent
Priority: Cao
```

Mỗi chỉ tiêu cần tối thiểu: `form_code`, `case_type`, `trial_level`, `row_code`, `column_code`, `source_table`, `source_key`, `source_field/source_join`, `filter`, `aggregation_grain`, `formula_ref`, `validation_refs`, `excel_sheet`, `excel_row_rule`, `excel_column`, `trace_required`.

Phân loại cột thành:

- `source`: đếm/tổng hợp trực tiếp từ record nguồn;
- `formula`: tính từ các cột đã có nguồn;
- `deferred`: cột ngoài phạm vi Quyết định 287 hoặc chưa duyệt nghiệp vụ;
- `unmapped`: nằm trong phạm vi nhưng chưa có nguồn, phải làm báo cáo `incomplete`.

### T02 - Tạo template Excel dẫn xuất an toàn

```yaml
Task: Tạo template dẫn xuất từ bieu_mau/
Objective: Giữ nguyên bố cục tham chiếu nhưng loại số liệu mẫu khỏi vùng ghi
Input: 12 workbook sơ thẩm/phúc thẩm
Output: Runtime template clone/clean service và manifest hash nguồn
Dependencies: T01
Validation: Không sửa file nguồn; giữ sheet, merge, kích thước, font Tahoma; vùng dữ liệu được làm sạch; cột deferred để trống
Owner Agent: Reporting Agent
Priority: Cao
```

Exporter clone trực tiếp workbook nguồn trong bộ nhớ, lưu SHA-256 và chỉ làm sạch các ô số trong vùng dữ liệu. Không tạo hoặc sửa bản nhị phân dưới `bieu_mau/`; không xóa tiêu đề, danh mục hàng, định dạng, merge, chiều rộng cột hoặc chiều cao hàng.

### T03 - Hoàn thiện catalog database

```yaml
Task: Seed catalog 12 mẫu thống kê
Objective: Thay FORM_REVIEW_REQUIRED bằng catalog có thể tra cứu
Input: Mapping đã duyệt từ T01
Output: Seed dm_statistical_forms, dm_statistical_metrics, dm_statistical_form_items
Dependencies: T01
Validation: Idempotent; mỗi item có form, metric/formula_ref và nguồn phù hợp; cập nhật database README/data dictionary nếu schema đổi
Owner Agent: Database Agent
Priority: Cao
```

Ưu tiên không đổi schema. Mapping join phức tạp đặt trong JSON được version hóa; các trường `source_table`, `source_field`, `formula_ref` trong catalog database lưu phần có thể biểu diễn chính xác.

### T04 - Sửa và bổ sung mapping theo từng loại án

```yaml
Task: Hoàn thiện mapping nguồn cho 12 mẫu
Objective: Loại bỏ tên bảng khái niệm và xác định grain chống đếm trùng
Input: Mapping hiện có và unified schema
Output: Bộ mapping đã duyệt cho 1A-6B
Dependencies: T01
Validation: Mọi nguồn tồn tại; query mẫu chạy được; cột chưa đủ nguồn được đánh dấu unmapped, không suy diễn
Owner Agent: Data Dictionary Agent
Priority: Cao
```

Các việc cụ thể:

- Hình sự: tạo column/input mapping; 1A theo `case_id` và `defendant_id`; 1B bắt buộc kết quả theo `defendant_id`.
- Dân sự: bổ sung data dictionary, column mapping, input mapping cho 2A/2B.
- Hôn nhân gia đình: đổi mapping tên logic sang bảng/cột/indicator thật.
- Kinh doanh thương mại: bổ sung input mapping cho 4A/4B.
- Lao động: thay nguồn `manual` bằng binding thật khi schema có dữ liệu; phần chưa có giữ `unmapped`.
- Hành chính: thay `administrative_case`, `appellate_review`, `case_status_history`, `court_unit`, `report_period` bằng bảng thật hoặc đánh dấu chưa có nguồn.

### T05 - Xây dựng calculation service dùng chung

```yaml
Task: Viết statistics calculation service
Objective: Tính số liệu theo mapping, công thức và grain đã duyệt
Input: T01-T04
Output: Repository, calculation service, formula evaluator và trace manifest
Dependencies: T03, T04
Validation: Không eval chuỗi tùy ý; không đếm trùng; from_date/to_date bao gồm hai biên; trạng thái tại to_date
Owner Agent: Backend Agent
Priority: Cao
```

Service phải:

- bắt buộc `SO_THAM` cho mẫu A và `PHUC_THAM` cho mẫu B;
- hỗ trợ `from_date`, `to_date`, `court_id`; năm công tác quy đổi 01/10-30/09;
- tính cột formula phía server để API và Excel dùng cùng một kết quả;
- trả record ID nguồn theo từng ô hoặc nhóm ô;
- không ghi dữ liệu chính; snapshot chỉ ghi khi có workflow được phê duyệt;
- dừng xuất bản chính thức nếu validation mức lỗi không đạt.

### T06 - API thống kê và truy vết

```yaml
Task: Tạo API báo cáo theo biểu mẫu
Objective: Cho phép xem trước, kiểm tra và xuất cùng một bộ số liệu
Input: Calculation service
Output: API forms, calculate/preview, trace và export
Dependencies: T05
Validation: DTO Zod; form_code khóa đúng case_type/trial_level; response chuẩn; readonly
Owner Agent: Backend Agent
Priority: Cao
```

Đề xuất endpoint:

- `GET /api/statistics/forms` - danh sách mẫu và trạng thái mapping.
- `POST /api/statistics/reports/calculate` - trả cells, totals, validation, completeness và trace.
- `GET /api/statistics/reports/:formCode/export?format=xlsx&from_date=...&to_date=...&court_id=...`.
- `GET /api/statistics/reports/:formCode/trace?...` - truy vết nguồn từng ô.

### T07 - Export Excel theo template

```yaml
Task: Ghi kết quả vào template Excel dẫn xuất
Objective: Xuất đúng sheet, dòng, cột và định dạng tham chiếu
Input: Template T02 và kết quả T05
Output: XLSX hoàn chỉnh
Dependencies: T02, T05
Validation: Chỉ ghi ô mapped; cột deferred/unmapped để trống; file nguồn không đổi; font Tahoma
Owner Agent: Reporting Agent
Priority: Cao
```

Exporter cập nhật kỳ tại `C2`, đơn vị báo cáo, các hàng phân loại và tổng. Không dùng số liệu sẵn trong workbook làm kết quả. Công thức nghiệp vụ được calculation service tính; Excel chỉ trình bày kết quả thống nhất với API.

### T08 - Test bắt buộc

```yaml
Task: Viết test nghiệp vụ, API và file xuất
Objective: Chứng minh số liệu đúng và biểu mẫu không bị biến dạng
Input: T05-T07
Output: Unit, integration, database và XLSX tests
Dependencies: T05, T06, T07
Validation: Toàn bộ test trọng yếu pass; fixture có record nguồn xác định
Owner Agent: QA Agent
Priority: Cao
```

Bộ test tối thiểu:

- mỗi công thức trong phạm vi Quyết định 287;
- biên `from_date`/`to_date` và năm công tác;
- tách tuyệt đối `SO_THAM`/`PHUC_THAM`;
- chống đếm trùng theo `case_id`, `occurrence_id`, `defendant_id`;
- hồ sơ giải quyết sau `to_date` vẫn là tồn cuối kỳ;
- ô thiếu nguồn để trống và báo `incomplete`;
- workbook nguồn không bị sửa, sheet/merge/vùng dữ liệu đúng;
- cột phát sinh không được ghi;
- tổng dòng, tổng cột và tổng đơn vị/toàn tỉnh;

## 3. Thứ tự triển khai khuyến nghị

1. T01 + T02: hợp đồng mapping và template dẫn xuất.
2. Pilot 2A/2B: số cột khớp hướng dẫn, có dữ liệu tham chiếu phong phú; hoàn thiện T03-T07 cho một lát dọc.
3. 6A/6B: sửa alias nguồn sai và kiểm chứng module Hành chính chuyên biệt.
4. 3A/3B, 4A/4B, 5A/5B: áp dụng engine chung; cột phát sinh để deferred.
5. 1A/1B: triển khai grain vụ án/bị cáo và logic hình sự phúc thẩm riêng.
6. T08: chạy toàn bộ regression 12 mẫu.

Mỗi cặp mẫu chỉ chuyển sang cặp tiếp theo khi đạt: mapping nguồn đầy đủ cho các ô được ghi, công thức pass, tách cấp xét xử pass, XLSX đúng template và trace về record nguồn được.

## 4. Backlog sau giai đoạn đầu

- Xác minh và triển khai các cột phát sinh C92-C94 của 1A, C37 của 3A, C33-C35 của 4A, C36-C38 của 5A.
- Xác minh mã mẫu đúng cho Lao động giám đốc thẩm/tái thẩm.
- Triển khai 1C/1D, 2C/2D, 3C/3D, 4C/4D, 5C/5D, 6C/6D.
- Bổ sung schema, dictionary, validation, mapping và workbook cho phá sản 4E/4F/4G.
- Xác định biểu mẫu cho `civil_matter`, `administrative_measure`, `other` nếu thực tế phải báo cáo riêng.
- Bổ sung snapshot/versioning và quy trình ký duyệt báo cáo nếu nghiệp vụ yêu cầu lưu báo cáo chính thức.

## 5. Tiêu chí hoàn thành toàn bộ

- 12 mẫu sơ thẩm/phúc thẩm dùng đúng số cột theo phạm vi Quyết định 287.
- Không ghi dữ liệu vào cột phát sinh hoặc ô không có nguồn.
- API và Excel có cùng số liệu.
- Mỗi ô có trace nguồn và formula/validation version.
- Không đếm trùng; đúng trạng thái tại cuối kỳ và đúng năm công tác.
- File trong `bieu_mau/` không bị thay đổi.
- Test nghiệp vụ và template Excel đều đạt.
