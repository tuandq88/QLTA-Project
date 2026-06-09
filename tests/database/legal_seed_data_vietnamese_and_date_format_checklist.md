# Legal Seed Data Vietnamese And Date Format Checklist

## Scope

Manual checklist for data seeded from `database/seed/legal_seed_data_tand_vietnam`.

## Checklist

- [ ] User-facing display fields such as `name`, `label`, `title`, `description`, `category_name`, `item_name`, `option_name`, `display_name`, `metric_name`, `form_name`, `reason_name`, `result_name`, `crime_name`, and `relationship_name` are Vietnamese.
- [ ] English labels are not used for user-facing display text.
- [ ] Technical codes without Vietnamese accents are allowed for `code`, `crime_code`, `relationship_code`, `metric_code`, `rule_code`, and similar key fields.
- [ ] Dates in seed/documentation are written as `dd/MM/yyyy` when they are source dates.
- [ ] DATE values do not include hour/minute/second unless the target field is truly a timestamp.
- [ ] Rows that were extracted automatically or need legal/business confirmation are marked with `requires_human_review`.
- [ ] The seed does not invent a complete crime catalog or legal-relationship catalog beyond the files in `legal_seed_data_tand_vietnam`.
- [ ] Broad source rows such as "other disputes/requests" remain broad and are not expanded into unsupported detailed categories.
- [ ] UI mappings use dropdown/searchable dropdown for crimes and legal relationships, checkbox group for multi-select features, and radio only for mutually exclusive options.
