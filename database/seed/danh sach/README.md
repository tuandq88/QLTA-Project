# Excel Seed Source Folder

This folder contains original Excel workbooks used to derive seed data for QLTA reference catalogs.

## File Rules

- Supported directly in this task: `.xlsx`.
- Legacy `.xls` requires an additional dependency such as `xlrd` or conversion to `.xlsx`.
- Do not edit, rename, or delete source Excel files during import.

## Reading Rules

- Use `tools/seed/import_excel_seed_preview.py` for read-only preview/mapping.
- The helper uses Python standard-library XML/ZIP parsing for `.xlsx` and does not require internet access.
- Generated preview files are written under `docs/review/`.

## Data Rules

- User-facing display values must remain Vietnamese.
- If Excel text is Vietnamese without accents, do not infer accents unless a reviewed source confirms them.
- Source dates in documentation should be shown as `dd/MM/yyyy`.
- Do not insert hour/minute/second into DATE catalog values.
- Do not invent crimes, legal relationships, statistical indicators, formulas, or legal rules outside Excel or existing repo sources.
- Mark values extracted from case-level free text as `requires_human_review` when they may be variants rather than canonical catalog values.
