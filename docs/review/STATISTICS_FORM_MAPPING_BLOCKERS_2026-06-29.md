# Rà soát mapping chức năng thống kê theo loại án

Ngày rà soát: 29/06/2026

```yaml
Task: Rà soát trước khi viết chức năng thống kê theo từng loại án và cấp xét xử
Objective: Xác minh đầy đủ chuỗi nguồn dữ liệu -> công thức -> chỉ tiêu -> ô biểu mẫu -> Excel
Input: unified schema, data dictionary, formula catalog, validation rules, skill thống kê và biểu mẫu trong bieu_mau/
Output: Bảng mapping đã xác minh và danh sách blocker phải xử lý trước khi code
Dependencies: Documents/huong_dan_bm.pdf, Quyết định 287/QĐ-TANDTC được dẫn chiếu trong dự án
Validation: Không suy diễn trường, chỉ tiêu, công thức, biểu mẫu hoặc vị trí ghi khi chưa có mapping nguồn
Owner Agent: Codex
Priority: Cao
```

## 1. Kết luận tại thời điểm rà soát

**DỪNG TRƯỚC KHI CODE** theo yêu cầu số 7 của task.

Repo chưa có mapping đầy đủ, có thể thực thi, từ từng chỉ tiêu của mẫu thống kê về bảng/cột của `database/schema/unified_postgresql_schema.sql`. Vì vậy chưa thể viết API tính toán và xuất biểu mẫu mà vẫn bảo đảm truy vết nguồn, không tự suy diễn và không ghi sai số liệu.

Không sửa backend, schema, seed hoặc biểu mẫu nguồn trong lần rà soát này.

### 1.1. Cập nhật quyết định phạm vi ngày 29/06/2026

Sau rà soát, chủ dự án đã xác nhận:

- Các file trong `bieu_mau/` là dữ liệu xuất từ phần mềm thống kê, được dùng làm mẫu tham chiếu về bố cục, vị trí và số liệu; không xem là template trắng hay nguồn dữ liệu chính.
- Chỉ triển khai công thức cho các cột đã có căn cứ trong skill trích từ hướng dẫn ban hành theo Quyết định 287/QĐ-TANDTC.
- Nếu workbook có nhiều cột hơn hướng dẫn, các cột phát sinh được giữ lại để tham chiếu nhưng không tính, không ghi số liệu và được đưa vào backlog nghiệp vụ sau.
- Excel là định dạng báo cáo duy nhất trong phạm vi hiện tại. Không triển khai xuất hoặc chuyển đổi PDF.

Các quyết định trên cho phép chuyển từ trạng thái “dừng toàn bộ” sang triển khai theo từng lát dọc sau khi hoàn thành mapping nguồn cho mẫu tương ứng. Một mẫu chỉ được phát hành chính thức khi các ô được ghi đều truy vết được; mẫu còn thiếu nguồn chỉ được trả ở trạng thái nháp kèm cảnh báo, không tự điền `0`.

Kế hoạch xử lý chi tiết: `docs/plans/STATISTICS_REPORTING_IMPLEMENTATION_PLAN_V1.md`.

Kết quả triển khai A/B: `docs/review/STATISTICS_AB_IMPLEMENTATION_RESULT_2026-06-29.md`. Catalog form/cột, mapping nguồn, calculation service, API và XLSX exporter đã được bổ sung; blocker còn lại là các ô chưa có nguồn chuẩn hóa và catalog phân rã dòng đầy đủ.

## 2. Nguồn đã đối chiếu

- Schema source of truth: `database/schema/unified_postgresql_schema.sql`.
- Data dictionary database: `database/schema/DATABASE_TABLES_DATA_DICTIONARY_VI.md`.
- Rule tổng: `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md`.
- Skill thống kê tổng và skill riêng của Hình sự, Dân sự, Hôn nhân gia đình, Kinh doanh thương mại, Lao động, Hành chính.
- JSON dưới `knowledge_base/data/statistics/`.
- 24 workbook trong `bieu_mau/`.
- Seed catalog thống kê: `database/seed/004_statistical_reference_data_seed.sql` và `database/seed/025_excel_seed_statistical_indicators.sql`.
- Backend hiện có: `backend/src/modules/statistics.ts`, `backend/src/common/report-period.ts`, `backend/src/modules/case-period-report.ts`.

## 3. Mapping cấp biểu mẫu đã xác minh

Các cột Excel dưới đây là vị trí vật lý đã đọc trực tiếp từ workbook. `C2` là ô chứa khoảng thời gian trong tất cả các mẫu đã kiểm tra. Các vùng dữ liệu hiện chứa số liệu tháng 05/2026; đây không phải template trắng.

| Loại án | Cấp xét xử | Mã mẫu/cấu hình | Trường nguồn nền đã có trong schema | Formula/validation hiện có | Workbook / sheet | Vị trí Excel đã xác minh | Trạng thái mapping nguồn -> chỉ tiêu |
|---|---|---|---|---|---|---|---|
| Hình sự | Sơ thẩm | 1A / `HS_ST_1A` | `case_files.case_id`, `case_type`, `case_group`, `acceptance_date`, `closed_date`; bị cáo từ `defendants`; tội danh từ `charges` | Có formula; validation nằm gộp trong formula catalog | `Hình sự sơ thẩm.xlsx` / `HinhSu_SoTham` | kỳ `C2`; số thứ tự `A7:CP7`; dữ liệu hiện tại hàng 8-25 | **Thiếu** column mapping, input mapping và binding từng Cột 1-94 về bảng/cột/indicator |
| Hình sự | Phúc thẩm | 1B / `HS_PT_1B` | Như trên; kết quả bị cáo có `criminal_appellate_defendant_results` | Có formula; validation nằm gộp trong formula catalog | `Hình sự phúc thẩm.xlsx` / `HinhSu_PT_CN` | kỳ `C2`; số thứ tự `A8:BY8`; dữ liệu hiện tại hàng 9-48 | **Thiếu** column/input mapping; chưa có binding đầy đủ 77 cột; phải giữ grain theo `defendant_id` |
| Dân sự | Sơ thẩm | 2A / `DS_ST_2A` | Nền hồ sơ từ `case_files`; chi tiết từ `civil_case_details`; quan hệ từ `case_legal_relationships` | Có formula và validation | `Dân sự sơ thẩm.xlsx` / `DSST` | kỳ `C2`; số thứ tự `A8:AH8`; dữ liệu hiện tại hàng 9-23 | **Thiếu** data dictionary riêng, column mapping và input mapping |
| Dân sự | Phúc thẩm | 2B / `DS_PT_2B` | Như trên; theo dõi cấp trên có các bảng `appellate_*` | Có formula và validation | `Dân sự Phúc thẩm.xlsx` / `DS_PT` | kỳ `C2`; số thứ tự `A7:AW7`; dữ liệu hiện tại hàng 8-85 | **Thiếu** data dictionary riêng, column mapping và input mapping |
| Hôn nhân gia đình | Sơ thẩm | 3A / `HNGD_ST_3A` | Có thể dùng nền `case_files` và `civil_case_details` | Có formula, validation và mapping tên logic -> Cột | `Hôn nhân gia đình sơ thẩm.xlsx` / `HonNhan_GiaDinh_SoTham` | kỳ `C2`; số thứ tự `A7:AK7`; tổng tại hàng 8 | **Thiếu** binding tên logic về bảng/cột schema; nhiều cột đang đánh dấu `manual` |
| Hôn nhân gia đình | Phúc thẩm | 3B / `HNGD_PT_3B` | Có thể dùng nền `case_files`, `civil_case_details`, `appellate_*` | Có formula, validation và mapping tên logic -> Cột | `Hôn nhân gia đình phúc thẩm.xlsx` / `HonNhan_GiaDinh_phuc_tham` | kỳ `C2`; số thứ tự `A8:AW8`; dữ liệu hiện tại hàng 9-39 | **Thiếu** binding tên logic về bảng/cột schema; nhiều cột đang đánh dấu `manual` |
| Kinh doanh thương mại | Sơ thẩm | 4A / `KDTM_ST_4A` | Có thể dùng nền `case_files` và `civil_case_details` | Có data dictionary, formula, validation và tên cột | `Kinh doanh thương mại sơ thẩm.xlsx` / `KinhTe_SoTham` | kỳ `C2`; số thứ tự `A7:AI7`; dữ liệu hiện tại hàng 8-11 | **Thiếu** input mapping và binding từng cột về schema |
| Kinh doanh thương mại | Phúc thẩm | 4B / `KDTM_PT_4B` | Có thể dùng nền `case_files`, `civil_case_details`, `appellate_*` | Có data dictionary, formula, validation và tên cột | `Kinh doanh thương mại phúc thẩm.xlsx` / `KinhTe_phuc_tham` | kỳ `C2`; số thứ tự `A8:AW8`; dữ liệu hiện tại hàng 9-37 | **Thiếu** input mapping và binding từng cột về schema |
| Lao động | Sơ thẩm | 5A / `LD_ST_5A` | Có thể dùng nền `case_files` và `civil_case_details` | Có dictionary, formula, validation, column/input mapping khái niệm | `Lao động sơ thẩm.xlsx` / `LaoDong_SoTham` | kỳ `C2`; số thứ tự `A7:AL7`; tổng tại hàng 8 | **Thiếu** binding vật lý về bảng/cột; phần lớn cột đang là `manual` |
| Lao động | Phúc thẩm | 5B / `LD_PT_5B` | Có thể dùng nền `case_files`, `civil_case_details`, `appellate_*` | Có dictionary, formula, validation, column/input mapping khái niệm | `Lao động phúc thẩm.xlsx` / `LaoDong_phuc_tham` | kỳ `C2`; số thứ tự `A8:AW8`; tổng tại hàng 9 | **Thiếu** binding vật lý về bảng/cột; phần lớn cột đang là `manual` |
| Hành chính | Sơ thẩm | 6A / `HC_ST_6A` | Nền `case_files`; chi tiết `administrative_case_details`; đối tượng kiện `challenged_admin_objects` | Có dictionary, formula, validation và column mapping | `Hành chính sơ thẩm.xlsx` / `HanhChinh_SoTham` | kỳ `C2`; số thứ tự `A7:AK7`; dữ liệu hiện tại hàng 8-10 | **Không hợp lệ để code**: `input_mapping.json` trỏ tới tên bảng không tồn tại như `administrative_case`, `appellate_review`, `case_status_history`, `court_unit`, `report_period` |
| Hành chính | Phúc thẩm | 6B / `HC_PT_6B` | Có thể dùng nền `case_files`, `administrative_case_details`, `appellate_*` | Có dictionary, formula, validation và column mapping | `Hành chính phúc thẩm.xlsx` / `HanhChinh_phuc_tham` | kỳ `C2`; số thứ tự `A8:AU8`; dữ liệu hiện tại hàng 9-12 | **Không hợp lệ để code** vì source table trong input mapping không khớp schema source of truth |
| Phá sản | Mẫu 4E/4F/4G được nhắc trong skill; schema có `case_type='bankruptcy'` | 4E, 4F, 4G | Chỉ có nền chung `case_files`; không có module chi tiết phá sản | Chỉ có đoạn công thức trích thô trong catalog tổng | **Không có workbook tương ứng** | **Không xác định được** sheet/hàng/cột/ô | **Thiếu toàn bộ** dictionary, validation, input/column mapping, bảng nguồn nghiệp vụ và biểu mẫu Excel |
| Loại khác trong schema | `civil_matter`, `administrative_measure`, `other` | Chưa xác định | Chỉ có enum/nền chung | Không có bộ catalog riêng được xác minh | Không có workbook tương ứng | Không xác định | **Thiếu toàn bộ mapping và biểu mẫu** |

## 4. Quy tắc cấp xét xử và thời gian đã xác minh

- Sơ thẩm phải lọc `case_files.case_group = 'SO_THAM'` hoặc `case_group_id` tương ứng.
- Phúc thẩm phải lọc `case_files.case_group = 'PHUC_THAM'` hoặc `case_group_id` tương ứng.
- Không dùng `case_type`, `procedure_law` hoặc `current_stage` để suy ra cấp xét xử.
- Khoảng `from_date` - `to_date` bao gồm cả hai biên.
- Trạng thái báo cáo phải xác định tại `to_date`, không lấy trạng thái hiện tại nếu hồ sơ được giải quyết sau kỳ.
- Năm công tác `Y` là từ `01/10/(Y-1)` đến hết `30/09/Y`.
- Với hình sự phúc thẩm, kết quả phải tính theo từng `defendant_id`; không gán một kết quả chung cho toàn vụ nhiều bị cáo.

## 5. Blocker bắt buộc phải xử lý

### 5.1. Catalog biểu mẫu trong database chưa sẵn sàng

`database/seed/004_statistical_reference_data_seed.sql` chỉ seed một mẫu `FORM_REVIEW_REQUIRED`. Chưa có các mẫu `1A`, `1B`, `2A`, `2B`, `3A`, `3B`, `4A`, `4B`, `5A`, `5B`, `6A`, `6B` trong `dm_statistical_forms`.

`dm_statistical_form_items` chưa được seed đầy đủ từng dòng/chỉ tiêu, và chưa có `source_table`, `source_field`, `formula_ref` tương ứng cho các mẫu trên.

### 5.2. Mapping JSON không đồng nhất và không khớp schema

- Dân sự thiếu `data_dictionary.json`, `column_mapping.json`, `input_mapping.json`.
- Hình sự thiếu `column_mapping.json`, `input_mapping.json`; validation chỉ nằm gộp trong formula catalog.
- Kinh doanh thương mại thiếu `input_mapping.json`.
- Hôn nhân gia đình chủ yếu map tên logic sang mã cột, chưa map sang bảng/cột database.
- Lao động mô tả nguồn ở mức khái niệm và đánh dấu nhiều chỉ tiêu là nhập tay, chưa có nguồn record để truy vết.
- Hành chính dùng tên bảng không tồn tại trong unified schema.
- Phá sản và các enum loại án khác chưa có bộ cấu hình riêng.

### 5.3. Biểu mẫu đầu ra chưa đủ điều kiện tự động ghi

- Cả 24 workbook đều hard-code kỳ 01/05/2026-31/05/2026 tại `C2`. Một số workbook chứa nhiều hàng số liệu đã điền; các workbook còn lại chỉ có khung/tổng cộng. Chưa có bản template trắng bất biến được chỉ định làm source of truth.
- Workbook không chứa công thức Excel; toàn bộ công thức phải đến từ catalog đã được duyệt.
- Chưa có quy tắc xác định hàng động theo đơn vị + loại tranh chấp/tội danh, quy tắc chèn/xóa hàng, vùng tổng đơn vị và tổng toàn tỉnh.
- Backend cũ chỉ xuất báo cáo danh sách kỳ bằng workbook tự dựng; không phải các mẫu ngành 1A-6B nên không thể tái sử dụng làm bằng chứng “đúng biểu mẫu”.

### 5.4. Mâu thuẫn giữa tài liệu hướng dẫn và workbook/catalog

Đã trích trực tiếp `Documents/huong_dan_bm.pdf` (211 trang). Một số số lượng cột không khớp với workbook và JSON hiện tại:

| Mẫu | Hướng dẫn theo Quyết định 287 | Workbook/JSON hiện tại | Kết luận |
|---|---:|---:|---|
| 1A Hình sự sơ thẩm | 91 cột | 94 cột | Mâu thuẫn; chưa có tài liệu pháp lý/version giải thích 3 cột bổ sung |
| 3A Hôn nhân gia đình sơ thẩm | 36 cột | 37 cột được đánh số/mapping | Mâu thuẫn; chưa có căn cứ version |
| 4A Kinh doanh thương mại sơ thẩm | 32 cột | 35 cột | Mâu thuẫn; chưa có căn cứ version |
| 5A Lao động sơ thẩm | 35 cột | 38 cột | Mâu thuẫn; chưa có căn cứ version |
| 1B, 2A, 3B, 4B, 5B, 6A, 6B | Số cột trích được lần lượt là 77, 34, 49, 49, 49, 37, 47 | Khớp số cột được đánh số trong workbook tương ứng | Chỉ khớp cấu trúc cột; vẫn thiếu binding nguồn |

Ngoài ra, workbook Lao động giám đốc thẩm đang ghi `Mẫu 3C` thay vì mã nhóm Lao động dự kiến `5C`; workbook Lao động tái thẩm ghi `Mẫu 6D` thay vì `5D`. Không được tự sửa mã mẫu khi chưa xác minh bản chuẩn.

### 5.5. Thiếu nguồn cho các chỉ tiêu chi tiết

Các cột như chuyển/nhập vụ án, nguyên nhân quá hạn, số lần tạm đình chỉ, rút kháng cáo/kháng nghị, án lệ, thủ tục rút gọn, biện pháp khẩn cấp tạm thời, luật sư/VKS tham gia, lỗi cấp sơ thẩm và nhiều đặc điểm đương sự chưa có binding được duyệt tới bảng/cột/option cụ thể. Không được suy ra các cột này từ text tự do hoặc từ trạng thái hiện tại.

## 6. Bộ dữ liệu tối thiểu cần bổ sung trước khi triển khai

Mỗi ô/chỉ tiêu tự động phải có một record mapping được duyệt với tối thiểu:

```text
form_code
trial_level
case_type
row_code / row_source_catalog
column_code
excel_sheet
excel_row_rule
excel_column
source_table
source_primary_key
source_field hoặc source_join
filter_expression
aggregation_grain
formula_ref
validation_rule_refs
legal_basis
trace_required
```

Đồng thời cần:

1. Seed đầy đủ `dm_statistical_forms`, `dm_statistical_metrics`, `dm_statistical_form_items`.
2. Mapping chuẩn hóa cho từng mẫu, ưu tiên JSON machine-readable dùng đúng tên bảng/cột trong unified schema.
3. Template Excel sạch hoặc quy tắc clone/xóa số liệu cũ được phê duyệt, không sửa file nguồn.
4. Test fixture có nguồn record ID cho từng ô, test chống đếm trùng, test biên thời gian, test tách `SO_THAM`/`PHUC_THAM` và test tổng dòng/cột Excel.

## 7. Điều kiện mở khóa code

Chỉ bắt đầu viết API/service/export khi tất cả mẫu nằm trong phạm vi đã đạt đồng thời:

- đủ dictionary, formula, validation;
- mọi chỉ tiêu có binding tới schema hiện hành;
- xác định được grain đếm (`case_id`, `occurrence_id`, `defendant_id` hoặc entity khác);
- xác định chính xác sheet/hàng/cột và quy tắc hàng động;
- có template Excel được duyệt;
- truy vết được mỗi số liệu về record nguồn;
- không còn tên bảng/cột khái niệm không tồn tại trong schema.
