---
name: statistical_form_ab_export
description: Quy tắc tính và xuất Excel cho 12 mẫu thống kê sơ thẩm/phúc thẩm 1A-6B từ template trong bieu_mau.
version: 1.0.0
domain: judicial_statistics
---

# Skill xuất biểu mẫu thống kê A/B

## Phạm vi

- 1A/1B Hình sự.
- 2A/2B Dân sự.
- 3A/3B Hôn nhân gia đình.
- 4A/4B Kinh doanh thương mại.
- 5A/5B Lao động.
- 6A/6B Hành chính.
- Chỉ xuất XLSX; không triển khai PDF.

Mapping thực thi: `knowledge_base/data/statistics/report_mapping_ab.json`.

## Quy tắc bắt buộc

1. Mẫu A chỉ lấy `case_group = 'SO_THAM'`; mẫu B chỉ lấy `case_group = 'PHUC_THAM'` hoặc tracking phúc thẩm tương ứng.
2. Khoảng `from_date` - `to_date` bao gồm hai biên. Trạng thái cũ còn lại được xác định tại đầu kỳ, không theo trạng thái hiện tại.
3. Một ô nguồn phải có bảng nguồn, record ID và grain. Không có nguồn thì để trống và đánh dấu `unmapped`; không ghi `0`.
4. Cột công thức chỉ được tính khi mọi toán hạng đã có nguồn. Không coi toán hạng thiếu là `0`.
5. `BOTH` (vừa kháng cáo vừa kháng nghị) được xếp vào nhóm kháng nghị để tránh đếm trùng.
6. Hình sự phúc thẩm dùng `criminal_appellate_defendant_results` theo từng bị cáo; case count chỉ dùng record có `counted_as_case_resolved = true`.
7. Hình sự sơ thẩm trả hồ sơ dùng `case_resolution_events` theo occurrence/event, không đếm cơ học theo `case_id`.
8. Kết quả sơ thẩm lấy quyết định mới nhất trong kỳ cho mỗi hồ sơ; hồ sơ công nhận thỏa thuận không được đếm lại vào nhóm xét xử chấp nhận/bác yêu cầu.
9. Exporter clone workbook nguồn trong bộ nhớ, xóa số liệu mẫu tại vùng số, giữ nguyên sheet/merge/style và chỉ ghi ô `source` hoặc `formula` vào dòng `Tổng cộng`.
10. Không sửa hoặc ghi đè file trong `bieu_mau/`.

## Cột phát sinh tạm bỏ qua

- 1A: C92-C94.
- 3A: C37.
- 4A: C33-C35.
- 5A: C36-C38.

Các cột này phải để trống và mang trạng thái `deferred` cho đến khi có căn cứ nghiệp vụ được duyệt.

## Trạng thái báo cáo

- `incomplete`: còn ô chưa có nguồn hoặc chưa có phân rã đầy đủ theo danh mục dòng; vẫn có thể xuất bản nháp XLSX.
- `invalid`: có validation lỗi như giá trị âm; không dùng làm báo cáo chính thức.
- `complete`: chỉ dùng khi toàn bộ ô và danh mục dòng trong phạm vi đã được mapping, kiểm thử và truy vết.

## API

- `GET /api/statistics/forms`.
- `GET /api/statistics/reports/:formCode?from_date=...&to_date=...&court_id=...`.
- `GET /api/statistics/reports/:formCode/export?format=xlsx&from_date=...&to_date=...&court_id=...`.

Header XLSX phải có `X-Report-Status` và `X-Template-Source-SHA256`.

## Test tối thiểu

- 6 mẫu A map `SO_THAM`, 6 mẫu B map `PHUC_THAM`.
- Công thức không chạy khi thiếu toán hạng.
- Cột deferred luôn trống.
- Hash file nguồn trước/sau export không đổi.
- Đủ 12 sheet/template và kỳ báo cáo đúng tại `C2`.
- Database có 12 form, 585 form item và 93 cột formula_ref.
