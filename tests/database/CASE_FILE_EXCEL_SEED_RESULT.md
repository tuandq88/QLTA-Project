# Ket qua seed case_files tu Excel

## Ket luan

- Ket luan: PASSED sau khi chay seed va test PostgreSQL tren database `qlta_schema_merge_test`.
- So dong du dieu kien seed vao `case_files`: 2244.
- So dong bi bo qua: 65.
- So dong co `case_number` ky thuat bang `case_code` de phu hop khoa `(court_id, case_number, case_type)`: 2244; so thu ly goc van duoc giu trong `summary`.
- Khong thay doi schema nghiep vu.
- Khong seed hang loat du lieu khong chac chan vao bang phu; cac gia tri free-text duoc giu trong `case_files.summary` de truy vet.

## File va sheet nguon

| File Excel | Sheet | Header row | Dong du lieu doc | Dong seed case_files | Dong bo qua | Cot |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 3 | 552 | 487 | 65 | Chủ toạ; Thành viên; Thư ký; Loại án; Số án; Ngày xử; Số/Ngày TL; Nguyên đơn; Bị đơn; Vụ việc; Số BA/QĐ ST; Ngày BA/QĐ ST; Tòa án xét xử sơ thẩm; KC/KN; Kết quả XXPT |
| `Dân sự mở rộng - Sơ thẩm.xlsx` | `Projects 3` | 3 | 673 | 673 | 0 | STT; Loại án; Số/ngày thụ lý; Nguyên đơn/NKK; Bị đơn/NBK; Quan hệ pháp luật; Thẩm phán; Hội đồng; Thư ký; Số/Ngày BA/QD; Kháng cáo/Kháng nghị; Hình thức xét xử; Ghi chú |
| `Hình sự - Phúc thẩm.xlsx` | `Projects 3` | 3 | 575 | 575 | 0 | Chủ toạ; Thành viên; Thư ký; Số BA/QĐ PT; Ngày BA/QĐ PT; Số/Ngày TL; Họ và tên; Số BC; KC/KN; Tội danh; Mức án ST; Số BA/QĐ ST; Ngày BA/QĐ ST; Tòa án xét xử Sơ thẩm; Kết quả XXPT |
| `Hình sự - Sơ thẩm.xlsx` | `Projects 3` | 3 | 509 | 509 | 0 | STT; Số/ngày thụ lý; Họ và tên bị cáo; Năm sinh; Tội danh; Thẩm phán; Hội đồng; Thư ký; Số/Ngày BA/QD; Kết quả XXST; Kháng cáo/Kháng nghị; Hình thức xét xử; Ghi chú |

## Phan loai du lieu

- Du lieu vu an mau: cac dong sau header co `Loai an`/nguon hinh su va co `So/ngay thu ly`, `So/Ngay TL` hoac so BA/QD du lam khoa ho so ky thuat.
- Du lieu danh muc: `Loai an`, `Hinh thuc xet xu`, `Toi danh`, `Quan he phap luat`, `Vu viec`, `Ket qua XXPT` da duoc xu ly o seed 020-025; seed 030 chi tham chieu catalog nen neu map chac chan.
- Du lieu thong ke: `Hinh thuc xet xu`, `Ket qua XXPT`, nhom loai an phuc vu kiem tra thong ke nhung khong duoc dien giai thanh chi tieu moi trong seed nay.
- Metadata: dong tieu de bao cao o dong 1, dong trong, header dong 3, ten file, ten sheet, so dong nguon.
- Khong map chac chan: ten Tham phan/Chu toa, Hoi dong, Thu ky, duong su/bi cao, noi dung KC/KN, muc an, ket qua XXST dang cau, toa an so tham phuc tham. Cac truong nay duoc giu trong `summary`, khong ep sang bang danh muc hoac bang nguoi dung.

## Mapping Excel -> case_files

| Nhom file | Excel | case_files | Ghi chu |
| --- | --- | --- | --- |
| Tat ca | File/sheet/dong | `case_code`, `case_id`, `summary` | `case_code` dang `EXCEL-<file>-<row>`, UUID deterministic bang `uuid_generate_v5`. |
| Tat ca | `So/ngay thu ly` hoac `So/Ngay TL` | `case_number`, `filing_date`, `acceptance_date` | Tach dong dau lam so, dong co dinh dang ngay lam ngay thu ly. `case_number` dung `case_code` ky thuat de dap ung unique index hien tai; so goc nam trong `summary`. |
| Dan su mo rong | `Loai an` | `case_type`, `case_type_id`, `case_group`, `case_group_id`, `procedure_law*` | Chi map alias ro: Dan su, HNGD/Hon nhan gia dinh, KDTM/Kinh doanh thuong mai, Lao dong, Hanh chinh. |
| Hinh su | Ten file hinh su | `case_type=criminal`, `case_group=criminal`, `procedure_law=BLTTHS` | File hinh su khong co cot `Loai an`. |
| So tham | `So/Ngay BA/QD`, `Khang cao/Khang nghi` | `current_stage`, `case_status`, `resolution_status` | Co khang cao/khang nghi thi `appealed`; co BA/QD thi `resolved`. |
| Phuc tham | `So BA/QD PT`, `Ngay BA/QD PT`, `Ket qua XXPT` | `current_stage=appeal_tracking`, `case_status` | Co ngay/ket qua phuc tham thi `resolved`. |
| Tat ca | Khong co cot toa an hien tai | `court_id` | Seed them court ky thuat `EXCEL_SEED_TAND_QNG` vi `case_files.court_id` NOT NULL. |

## Mapping Excel value -> danh muc

| Gia tri Excel | Bang danh muc | Cach xu ly |
| --- | --- | --- |
| Alias loai an | `dm_categories`, `dm_category_items` category `excel_case_type_alias`; catalog chuan `case_type` | Seed 020 giu alias; seed 030 chi map alias ro sang enum/catalog chuan. |
| Hinh thuc xet xu | `dm_category_items` category `excel_hearing_format`; `statistical_indicator_options` | Seed 020 va 025 da co; seed 030 khong map vao `hearings` vi khong tao lich phien toa. |
| Toi danh | `dm_crimes` | Seed 021 da bo sung danh muc; seed 030 khong tao `charges`/`defendants` vi moi o co the chua nhieu bi cao/toi danh. |
| Quan he phap luat/Vu viec | `dm_legal_relationships` | Seed 022-024 da bo sung; seed 030 khong tao chi tiet chuyen nganh vi chua co khoa lien ket chac chan theo tung dong. |
| Ket qua XXPT chi tiet | `statistical_indicator_options` | Seed 025 da bo sung; chua map sang result code chinh thuc neu chua review nghiep vu. |

## Thong ke seed

| Nhom | So dong |
| --- | ---: |
| case_type `administrative` | 388 |
| case_type `business_commercial` | 37 |
| case_type `civil` | 687 |
| case_type `criminal` | 1084 |
| case_type `marriage_family` | 48 |
| current_stage `accepted` | 42 |
| current_stage `appeal_tracking` | 1432 |
| current_stage `resolved` | 770 |

## Bang duoc seed

- `courts`: them/cap nhat 1 court ky thuat `EXCEL_SEED_TAND_QNG`.
- `case_files`: them/cap nhat 2244 dong tu Excel.
- `dm_categories`, `dm_category_items`, `statistical_categories`, `statistical_indicators`, `statistical_indicator_options`: van do seed 020-025 quan ly; seed 030 chi doc FK nullable khi co catalog nen.

## So dong sau seed can kiem tra bang SQL

```sql
SELECT count(*) FROM case_files WHERE case_code LIKE 'EXCEL-%';
SELECT count(*) FROM courts WHERE court_code = 'EXCEL_SEED_TAND_QNG';
SELECT count(*) FROM dm_categories;
SELECT count(*) FROM dm_category_items;
SELECT count(*) FROM statistical_categories;
SELECT count(*) FROM statistical_indicators;
```

## Dong bo qua

| File | Sheet | Dong | Ly do |
| --- | --- | ---: | --- |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 40 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 41 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 42 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 43 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 59 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 60 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 77 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 88 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 90 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 101 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 102 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 104 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 114 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 118 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 123 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 140 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 146 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 147 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 161 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 162 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 167 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 169 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 176 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 180 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 189 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 190 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 202 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 204 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 206 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 222 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 265 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 277 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 279 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 286 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 307 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 308 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 323 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 343 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 353 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 358 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 360 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 375 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 377 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 379 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 384 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 386 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 394 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 399 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 413 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 429 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 436 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 441 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 445 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 446 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 452 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 467 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 468 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 502 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 517 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 524 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 527 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 530 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 531 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 534 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 535 | Thieu case_type hoac thieu dong thoi so/ngay thu ly va so BA/QD co the dung lam khoa ho so. |

## Validation

- Test bo sung: `tests/database/case_file_excel_seed_integrity_test.sql`.
- Runner cap nhat: `tests/database/run_seed_validation_check.ps1` chay them test case file seed.
- Cac lenh da chay va PASSED:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_schema_merge_test -Mode UnifiedOnly
.\tests\database\run_seed_validation_check.ps1 -DatabaseName qlta_schema_merge_test
.\tests\database\run_statistics_precheck.ps1 -DatabaseName qlta_schema_merge_test
```
