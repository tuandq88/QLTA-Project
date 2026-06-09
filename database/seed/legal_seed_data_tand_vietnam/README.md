# Legal Seed Data TAND Vietnam

This directory is the source folder for legal reference seed data used by `database/seed/010_legal_seed_data_tand_vietnam.sql`.

## Files

- `all_legal_seed_master.csv`: canonical combined source for current PostgreSQL seed mapping.
- `all_legal_seed_master.json`: JSON copy of the combined legal seed source.
- `all_legal_seed_postgresql.sql`: generated standalone SQL copy of the combined source.
- `criminal_offenses_seed.csv`: criminal offense rows extracted from the Penal Code source.
- `criminal_offenses_seed.json`: JSON copy of criminal offense rows.
- `civil_legal_relations_seed.csv`: civil legal relationship/request rows.
- `marriage_family_relations_seed.csv`: marriage and family relationship/request rows.
- `business_commercial_relations_seed.csv`: business and commercial relationship/request rows.
- `labor_relations_seed.csv`: labor relationship/request rows.
- `administrative_case_types_seed.csv`: administrative lawsuit type rows.
- `all_legal_relations_master.xlsx`: spreadsheet copy of non-criminal legal relation rows.
- `README_AI_SEED_DATA.md`: original source note for this data package.

## Target Tables

- Criminal offense rows seed `dm_penal_code_articles` and `dm_crimes`.
- Non-criminal legal relationship/request rows seed `dm_legal_relationships`.
- UI metadata for criminal offense selection seeds `statistical_categories` and `statistical_indicators`.

## Rules

- User-facing fields must be Vietnamese.
- Technical codes may be ASCII or uppercase identifiers.
- Source dates in documentation must use `dd/MM/yyyy`.
- Do not include hour/minute/second for data that is only a date.
- Rows extracted automatically from legal source headings are marked `requires_human_review` where legal/business review is still needed.
- Do not invent crimes, legal relationships, form items, metrics, legal rules, or formulas beyond the source files in this folder.
- Broad legal source rows such as "other disputes/requests" must remain broad unless a later reviewed source explicitly expands them.
