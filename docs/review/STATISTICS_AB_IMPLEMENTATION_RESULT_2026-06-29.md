# Kết quả triển khai thống kê biểu mẫu A/B

Ngày hoàn thành: 29/06/2026

```yaml
Task: Triển khai thống kê và xuất Excel theo template A/B
Objective: Tính các ô truy vết được, tách sơ thẩm/phúc thẩm và xuất đúng workbook trong bieu_mau/
Input: Unified schema, skill Quyết định 287, 12 workbook A/B
Output: Mapping, catalog database, calculation service, API, XLSX exporter và test
Dependencies: PostgreSQL unified schema và seed chuẩn
Validation: Typecheck, unit test, template test, database precheck, runtime smoke test
Owner Agent: Codex
Priority: Cao
```

## Đã hoàn thành

- Tạo mapping version hóa cho 12 mẫu tại `knowledge_base/data/statistics/report_mapping_ab.json`.
- Tách 6 mẫu A = `SO_THAM`, 6 mẫu B = `PHUC_THAM`.
- Chỉ dùng số cột theo hướng dẫn Quyết định 287; đánh dấu `deferred` cho cột phát sinh.
- Tạo calculation service dùng nguồn chuẩn hóa:
  - `case_files`, `decisions`, `dm_trial_result_types`;
  - `mediation_sessions`;
  - `case_resolution_events` theo event/occurrence;
  - `appellate_trackings`, `dm_appellate_result_codes`;
  - `criminal_appellate_defendant_results` theo bị cáo.
- Công thức chỉ chạy khi đủ toán hạng có nguồn; ô thiếu nguồn để trống.
- Tạo API danh sách mẫu, xem trước số liệu/trace và xuất XLSX.
- Exporter clone workbook nguồn trong bộ nhớ, làm sạch số liệu mẫu, giữ bố cục và ghi vào dòng tổng cộng.
- Không triển khai PDF.
- Seed 12 form, 585 item cột và 93 `formula_ref` vào catalog database.
- Bổ sung skill tái sử dụng `skill_statistical_form_ab_export.md`.

## API

```text
GET /api/statistics/forms
GET /api/statistics/reports/:formCode?from_date=YYYY-MM-DD&to_date=YYYY-MM-DD&court_id=UUID
GET /api/statistics/reports/:formCode/export?format=xlsx&from_date=YYYY-MM-DD&to_date=YYYY-MM-DD&court_id=UUID
```

`court_id` là tùy chọn. Export trả `X-Report-Status` và hash SHA-256 của template nguồn.

## Phần còn để trạng thái incomplete

- Chưa có catalog đầy đủ để dựng toàn bộ phân rã dòng theo tội danh/quan hệ pháp luật/loại khiếu kiện cho mọi mẫu.
- Các cột chuyển/nhập vụ án, quá hạn, tạm đình chỉ chi tiết và một số chỉ tiêu đặc thù chưa có nguồn chuẩn hóa thì để trống.
- Các cột phân tích kết quả phúc thẩm chi tiết hơn mức `dm_appellate_result_codes` hiện có chưa được tự suy diễn.

Đây là chủ ý an toàn dữ liệu, không phải ghi `0`. API trả danh sách `unmappedCells` và validation `UNMAPPED_SOURCE_CELLS`.

Kết quả smoke test trên dữ liệu hiện có:

| Mẫu | Ô đã có nguồn/công thức | Ô chưa có mapping nguồn |
|---|---:|---:|
| 1A | 12 | 78 |
| 1B | 23 | 53 |
| 2A | 6 | 27 |
| 2B | 22 | 26 |
| 3A | 7 | 28 |
| 3B | 22 | 26 |
| 4A | 9 | 22 |
| 4B | 22 | 26 |
| 5A | 9 | 25 |
| 5B | 22 | 26 |
| 6A | 6 | 30 |
| 6B | 22 | 24 |

Danh sách mã ô cụ thể được trả trực tiếp tại `data.unmappedCells` của API từng mẫu để tiếp tục mapping mà không phải suy đoán.

## Kết quả kiểm tra

- Backend typecheck: đạt.
- Vitest: 25/25 test đạt.
- Kiểm tra 12 workbook: đúng sheet, đúng ô kỳ, cột deferred trống, hash nguồn không đổi.
- Empty PostgreSQL `UnifiedOnly`: đạt.
- Seed validation: đạt.
- Statistics precheck: đạt; xác nhận 12 form, 585 item, 93 formula ref.
- Runtime smoke test đọc thật: cả 12 mẫu trả kết quả; XLSX 2A xuất thành công.

## Bước phát triển tiếp theo

1. Hoàn thiện catalog dòng cho từng loại án để thay `ROW_BREAKDOWN_DEFERRED`.
2. Bổ sung nguồn chuẩn hóa cho các ô đang `unmapped` theo danh sách API trả về.
3. Sau khi A/B đạt `complete`, triển khai C/D ở giai đoạn tiếp theo.
