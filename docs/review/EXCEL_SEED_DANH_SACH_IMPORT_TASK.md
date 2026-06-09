# Excel Seed Danh Sach Import Task

## Scope

Task type: database/seed-only. No backend, frontend, or business skill files were changed. Source Excel files under `database/seed/danh sach` were read only.

## Excel Files Read

| File | Sheet | Header row | Data rows | Columns |
| --- | --- | ---: | ---: | --- |
| `Dân sự mở rộng - Phúc thẩm.xlsx` | `Projects 3` | 2 | 552 | Chủ toạ; Thành viên; Thư ký; Loại án; Số án; Ngày xử; Số/Ngày TL; Nguyên đơn; Bị đơn; Vụ việc; Số BA/QĐ ST; Ngày BA/QĐ ST; Tòa án xét xử sơ thẩm; KC/KN; Kết quả XXPT |
| `Dân sự mở rộng - Sơ thẩm.xlsx` | `Projects 3` | 2 | 673 | STT; Loại án; Số/ngày thụ lý; Nguyên đơn/NKK; Bị đơn/NBK; Quan hệ pháp luật; Thẩm phán; Hội đồng; Thư ký; Số/Ngày BA/QD; Kháng cáo/Kháng nghị; Hình thức xét xử; Ghi chú |
| `Hình sự - Phúc thẩm.xlsx` | `Projects 3` | 2 | 575 | Chủ toạ; Thành viên; Thư ký; Số BA/QĐ PT; Ngày BA/QĐ PT; Số/Ngày TL; Họ và tên; Số BC; KC/KN; Tội danh; Mức án ST; Số BA/QĐ ST; Ngày BA/QĐ ST; Tòa án xét xử Sơ thẩm; Kết quả XXPT |
| `Hình sự - Sơ thẩm.xlsx` | `Projects 3` | 2 | 509 | STT; Số/ngày thụ lý; Họ và tên bị cáo; Năm sinh; Tội danh; Thẩm phán; Hội đồng; Thư ký; Số/Ngày BA/QD; Kết quả XXST; Kháng cáo/Kháng nghị; Hình thức xét xử; Ghi chú |

Preview artifacts:

- `docs/review/excel_seed_preview.json`
- `docs/review/excel_seed_preview.csv`
- `docs/review/excel_seed_records.csv`

## Generated Seed Files

| Seed file | Purpose | Target tables |
| --- | --- | --- |
| `database/seed/020_excel_seed_case_categories.sql` | Case-type aliases and hearing formats found in Excel | `dm_categories`, `dm_category_items` |
| `database/seed/021_excel_seed_criminal_categories.sql` | Criminal offense names found in Excel; only inserts missing names not already in `dm_crimes` | `dm_crimes` |
| `database/seed/022_excel_seed_civil_categories.sql` | Civil legal relationships/dispute text from Excel | `dm_legal_relationships` |
| `database/seed/023_excel_seed_administrative_categories.sql` | Administrative lawsuit/relationship text from Excel | `dm_legal_relationships` |
| `database/seed/024_excel_seed_labor_business_marriage_categories.sql` | Marriage-family and business-commercial relationship text from Excel | `dm_legal_relationships` |
| `database/seed/025_excel_seed_statistical_indicators.sql` | UI dropdown indicators/options for hearing format and detailed appellate result text | `statistical_categories`, `statistical_indicators`, `statistical_indicator_options` |

No standalone labor seed rows were generated because the Excel data did not contain a stable labor catalog value beyond sparse case rows.

## Seed Counts Generated

- Case-type aliases: 7.
- Hearing format options: 4.
- Criminal offense names found in Excel: 80 source values; seed inserts only names missing from the existing legal catalog.
- Civil legal relationship/dispute values: 244.
- Administrative lawsuit/relationship values: 34.
- Marriage-family relationship/dispute values: 44.
- Business-commercial relationship/dispute values: 20.
- Labor relationship/dispute values: 0.
- Detailed appellate result options: 14.
- Total statistical dropdown options from Excel: 18.

Runtime counts after applying all seed files on an empty database:

- Excel category items stored in `dm_category_items`: 11.
- Excel crime rows inserted as missing names in `dm_crimes`: 10. The other Excel crime names already matched the legal catalog by display name.
- Excel legal relationship rows stored in `dm_legal_relationships`: 335.
- Excel statistical dropdown options stored in `statistical_indicator_options`: 18.

## Source To Target Mapping

| Excel source | Source column | Target table | Target column | Transform rule | Validation rule |
| --- | --- | --- | --- | --- | --- |
| Civil first/appellate workbooks | `Loại án` | `dm_category_items` | `item_name` | Preserve Vietnamese display; generate technical `item_code`; store count in `metadata` | Non-empty display value |
| Civil/criminal first-instance workbooks | `Hình thức xét xử` | `dm_category_items`, `statistical_indicator_options` | `item_name`, `option_name` | Preserve Vietnamese display; generate dropdown option code | No duplicate option within indicator/category |
| Criminal workbooks | `Tội danh` | `dm_crimes` | `crime_name` | Preserve Vietnamese display; insert only if no same display name already exists | No duplicate `crime_code`; source rows require review |
| Civil workbooks | `Quan hệ pháp luật`, `Vụ việc` | `dm_legal_relationships` | `relationship_name` | Preserve Vietnamese display; scope by `Loại án`; generate `relationship_code` | No duplicate `relationship_code`; source rows require review |
| Appellate workbooks | `Kết quả XXPT` | `statistical_indicator_options` | `option_name` | Preserve detailed result phrase; do not infer flags such as cancelled/modified | Requires human review before mapping to official result codes |

## Human Review

Values extracted from case-level free-text columns are marked or documented as requiring review because they may include spelling variants, mixed casing, abbreviations, or case-specific wording. This includes Excel-derived legal relationships, case matters, criminal offenses that are not already in the legal catalog, and detailed appellate result phrases.

The following data was not seeded automatically:

- `Kháng cáo/Kháng nghị` and `KC/KN` free text because values often include party names/counts and case-specific prose.
- `Kết quả XXST` sentence text because many values are concrete punishments such as imprisonment terms or fines, not stable catalog result types.
- Party names, judge names, clerk names, case numbers, judgment numbers, and court names because this task is reference seed only, not case-data import.

## Schema Review

No new schema table was required. Existing tables used:

- `dm_categories`
- `dm_category_items`
- `dm_crimes`
- `dm_legal_relationships`
- `statistical_categories`
- `statistical_indicators`
- `statistical_indicator_options`

Missing specialized tables such as `dm_crime_groups`, `dm_crime_severity_levels`, `dm_sentence_types`, `dm_administrative_lawsuit_types`, and `dm_case_result_types` were not added in this task because the Excel sources were case lists, not reviewed standalone catalog tables.

## Validation

Added tests:

- `tests/database/excel_seed_integrity_test.sql`
- `tests/database/excel_seed_duplicate_prevention_test.sql`
- `tests/database/excel_seed_source_mapping_checklist.md`

Run command:

```powershell
.\tests\database\run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly
```

Validation result on 09/06/2026: `PASSED`.

The Excel seed files `020` through `025` were also run a second time on the same database without duplicate-key errors.
