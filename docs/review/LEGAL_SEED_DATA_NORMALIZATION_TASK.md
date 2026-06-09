# Legal Seed Data Normalization Task

## Scope

Task type: database/seed-only. No backend, frontend, or business skill files were changed.

Primary source folder: `database/seed/legal_seed_data_tand_vietnam`.

## Source Files Reviewed

- `administrative_case_types_seed.csv`: administrative lawsuit type rows, used for legal relationship dropdown data.
- `all_legal_relations_master.xlsx`: spreadsheet copy of non-criminal legal relations; reviewed as source inventory, not used directly by SQL seed.
- `all_legal_seed_master.csv`: canonical combined seed source used by `010_legal_seed_data_tand_vietnam.sql`.
- `all_legal_seed_master.json`: JSON copy of canonical combined source.
- `all_legal_seed_postgresql.sql`: generated standalone SQL copy; retained as source artifact, not used by the normalized seed.
- `business_commercial_relations_seed.csv`: business/commercial legal relationship rows.
- `civil_legal_relations_seed.csv`: civil legal relationship rows.
- `criminal_offenses_seed.csv`: criminal offense source rows.
- `criminal_offenses_seed.json`: JSON copy of criminal offense source rows.
- `labor_relations_seed.csv`: labor legal relationship rows.
- `marriage_family_relations_seed.csv`: marriage and family legal relationship rows.
- `README_AI_SEED_DATA.md`: original source note.

## Data Classification

- Legal catalog data: criminal offenses, Penal Code article references, civil/marriage-family/business/labor/administrative legal relationships.
- Statistical catalog data: UI selector metadata for criminal offenses and existing statistical indicators/options.
- Dropdown data: `dm_crimes`, `dm_legal_relationships`, `dm_trial_result_types`, `dm_appellate_result_codes`, `dm_category_items`.
- Checkbox data: existing `dm_defendant_statistical_features` and `defendant_feature_flags` options.
- Radio data: existing recidivism and detention status option groups.
- Date data: no standalone source date columns were found in the legal CSV rows. Legal-basis text contains legal document years only.
- Non-Vietnamese display data: not found in the canonical CSV display `name` values.
- Duplicate codes: no duplicate `seed_id` was found in `all_legal_seed_master.csv`.
- Canonical source count: 391 rows, including 312 criminal offense rows and 79 non-criminal legal relationship/request rows.

## Target Tables

- `dm_penal_code_articles`: seeded from criminal offense article numbers.
- `dm_crimes`: seeded from criminal offense rows.
- `dm_legal_relationships`: seeded from all non-criminal rows.
- `statistical_categories`: adds `criminal_offenses`.
- `statistical_indicators`: adds `criminal_offense_selector`.

Existing seed files continue to seed:

- `dm_categories`
- `dm_category_items`
- `statistical_categories`
- `statistical_indicators`
- `statistical_indicator_options`
- `dm_defendant_statistical_features`
- `dm_trial_result_types`
- `dm_appellate_result_codes`
- `dm_fault_classifications`
- `dm_fault_reason_groups`
- `dm_appeal_protest_types`
- `dm_statistical_forms`
- `dm_statistical_metrics`
- `dm_statistical_form_items`

## Schema Synchronization

Added to `database/schema/unified_postgresql_schema.sql`:

- `statistical_indicator_options.option_name` widened to `TEXT`.
- `dm_penal_code_articles.article_title` widened to `TEXT`.
- `dm_penal_code_articles.source_document`, `source_url`, `notes`, `requires_human_review`.
- `dm_crimes.crime_name` widened to `TEXT`.
- `dm_crimes.legal_basis`, `source_document`, `source_url`, `notes`, `requires_human_review`.
- `dm_legal_relationships.relationship_name` widened to `TEXT`.
- `dm_legal_relationships.source_document`, `source_url`, `notes`, `requires_human_review`.

Added migration:

- `database/migrations/005_legal_seed_data_normalization.sql`

Reason: two source names exceed 255 characters, and source/legal metadata must stay attached to catalog rows.

## Seed Updates

Added:

- `database/seed/010_legal_seed_data_tand_vietnam.sql`

The seed uses `\copy` from `database/seed/legal_seed_data_tand_vietnam/all_legal_seed_master.csv`, maps criminal rows to `dm_penal_code_articles` and `dm_crimes`, and maps non-criminal rows to `dm_legal_relationships`.

The seed is idempotent through `ON CONFLICT ... DO UPDATE`.

Runtime seed counts after validation:

- `dm_penal_code_articles`: 312 rows.
- `dm_crimes`: 312 rows.
- `dm_legal_relationships`: 83 rows, including 79 rows from legal seed source and 4 earlier review-required placeholders.
- `dm_crimes.requires_human_review = TRUE`: 312 rows.

## Human Review Flags

- Criminal offense rows are marked `requires_human_review = TRUE` because the source note says they were extracted automatically from Penal Code article headings and should be reviewed when legal sources change.
- Non-criminal legal relationship rows are kept as source-level legal rows and are not expanded. They are marked `requires_human_review = FALSE` because they are seeded directly from the provided legal source file.

## Date Normalization

No source date column required conversion. The seed does not insert timestamp values. Documentation now states that date-only source values must use `dd/MM/yyyy`.

## Tests Added

- `tests/database/legal_seed_data_integrity_test.sql`
- `tests/database/legal_seed_data_vietnamese_and_date_format_checklist.md`

The SQL test checks seeded row counts, duplicate codes, blank display names, source metadata, FK validity, and required baseline catalogs.

## Validation Result

`tests/database/run_empty_postgres_check.ps1 -DatabaseName qlta_empty_test -Mode UnifiedOnly` passed on 09/06/2026.

The same seed files were run a second time on the same database without duplicate-key errors, confirming idempotent behavior for this task.

## Remaining Risks

- `\copy` in `010_legal_seed_data_tand_vietnam.sql` expects the script to run from the repository root, matching `tests/database/run_empty_postgres_check.ps1`.
- The source file is authoritative for this task, but legal/business owners should still review automatically extracted criminal offense rows before production use.
- The seed does not create a full detailed legal relationship tree beyond the provided source rows.
