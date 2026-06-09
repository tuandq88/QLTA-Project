# Excel Seed Source Mapping Checklist

- [ ] Every generated Excel seed file has a `-- Source: database/seed/danh sach/...` comment.
- [ ] Every workbook sheet was scanned and listed in `docs/review/EXCEL_SEED_DANH_SACH_IMPORT_TASK.md`.
- [ ] Rows with missing/ambiguous business meaning are listed as requiring human review.
- [ ] Display values remain Vietnamese as read from Excel.
- [ ] Technical codes are generated from display text only for database keys.
- [ ] Date values in reports use `dd/MM/yyyy` when shown as dates.
- [ ] No timestamp with hour/minute/second is inserted into DATE catalog fields.
- [ ] Seed files use `ON CONFLICT` or `WHERE NOT EXISTS` to avoid duplicates.
- [ ] Excel source files are not modified or deleted.
