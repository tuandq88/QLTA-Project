# Core Database Schema Task Review

## Scope Completed

Created a standalone PostgreSQL core schema for the QLTA project. The schema can run on an empty database and contains only the core data model needed before later modules.

Core tables created:

- `courts`
- `users`
- `judge_profiles`
- `case_files`
- `participants`
- `documents`
- `hearings`
- `decisions`
- `case_assignments`
- `case_events`
- `deadlines`
- `validation_results`
- `audit_logs`
- minimal reference-data foundation: `dm_categories`, `dm_category_items`

## Main Relationships

- `courts` self-references through `parent_court_id`.
- `courts` owns `users` and `case_files`.
- `users` has one optional `judge_profiles` row.
- `case_files` is the central table for participants, documents, hearings, decisions, assignments, events, deadlines, and validation results.
- `users` is referenced by assigned judges, assignments, lifecycle events, and audit actors.
- `documents` may support decisions and lifecycle events as source documents.

## Duplicate-Prevention Constraints

- `courts.court_code` is unique.
- `users.email` has a case-insensitive partial unique index when not null.
- `judge_profiles.user_id` is unique.
- `judge_profiles.judge_code` has a partial unique index when not null.
- `case_files.case_code` is unique.
- `case_files` has a partial business-key unique index on `court_id + case_number + case_type + acceptance_date`.
- `participants` has a soft identity unique index on `case_id + participant_type + full_name + date_of_birth` when `full_name` is present.
- `documents.checksum` is unique when not null.
- `documents` prevents duplicate numbered documents in the same case with `case_id + document_type + document_number + document_date`.
- `decisions` prevents duplicate numbered decisions in the same case with `case_id + decision_type + decision_number + decision_date`.
- `case_assignments` allows only one active primary assignment per `case_id + assignment_role`.

## Important Indexes

- Court lookup: `idx_courts_parent`, `idx_courts_level`.
- User lookup: `idx_users_court`, `idx_users_role`, `idx_users_active`.
- Judge assignment lookup: `idx_judge_profiles_specialized_group`, `idx_judge_profiles_active_assignment`.
- Case dashboard and search lookup: `idx_case_files_court`, `idx_case_files_type`, `idx_case_files_status`, `idx_case_files_acceptance_date`, `idx_case_files_assigned_judge`, `idx_case_files_current_stage`, `idx_case_files_court_status`, `idx_case_files_court_type_acceptance`.
- Child-table lookup: `idx_participants_case`, `idx_documents_case`, `idx_hearings_case`, `idx_decisions_case`, `idx_case_assignments_case`, `idx_case_events_case`, `idx_deadlines_case`, `idx_validation_results_case`.
- Deadline alert lookup: `idx_deadlines_pending_overdue`.
- Audit lookup: `idx_audit_logs_table_record`, `idx_audit_logs_actor`, `idx_audit_logs_event_time`, `idx_audit_logs_action`.

## Design Decisions

- The core schema uses `pgcrypto` and `gen_random_uuid()` for new core IDs because this is available in modern PostgreSQL and avoids coupling to application-side UUID generation.
- `uuid-ossp` is also enabled for compatibility with existing later migrations in this repository that still use `uuid_generate_v4()`.
- PostgreSQL enums are used for stable operational values that participate in constraints and partial indexes: court level, user role, case type/status, participant/document/hearing/decision types, assignment role/status, deadline status, validation severity, and audit action.
- A minimal `dm_categories` / `dm_category_items` foundation is included for later flexible catalogs, with seed rows for core enum categories and commonly used core item codes. Detailed legal/statistical reference data is intentionally left for a dedicated reference-data task.
- `case_events` is only a business lifecycle log. It is not used as a system audit log.
- `validation_results` stores warnings, validation messages, and suggested action only. It does not overwrite primary case data.
- `audit_logs` stores system-level events and is not a source table for business facts.

## Intentionally Out Of Scope

- Detailed random assignment logic and assignment batch tables.
- Appeal/protest tracking tables and result/fault workflows.
- Statistics/KPI formulas, snapshots, dashboard metrics, and chart logic.
- Specialized case detail tables for civil, criminal, administrative, marriage-family, business-commercial, or labor cases.
- Backend API, frontend screens, and dashboard UI.

## Unified Schema Note

`database/schema/unified_postgresql_schema.sql` already contains the existing broader schema for specialized modules, random assignment, appeal/protest, statistics/KPI, AI suggestions, and audit support. This task adds a standalone core schema in `database/schema/core_database_schema.sql` and the first migration in `database/migrations/001_core_database_schema.sql` without deleting or rewriting the existing unified schema.

The existing unified schema has some historical naming differences from this core task, such as `audit_logs.audit_log_id` / `action_at` / `old_data` / `new_data` versus the requested core names `audit_id` / `event_time` / `before_data` / `after_data`. A later schema harmonization task should reconcile those names carefully without breaking existing module migrations.

## Remaining Risks

- Enum values are intentionally minimal. Business owners should confirm exact local codes before production seed data is finalized.
- The participant duplicate rule is conservative and may need stronger identity matching after real data samples are reviewed.
- The `case_files` business key assumes `acceptance_date` is available. Legacy rows without acceptance dates may still need validation warnings rather than hard constraints.
- Legal-basis text is stored but not validated against source legal documents in this task.
- Existing later migrations should be reviewed after this core baseline because they were created before this `001` migration and may have legacy column-name assumptions.

## Business Confirmations Needed

- Final local court code convention for TAND two-level Quang Ngai units.
- Canonical case number format by case type and procedural stage.
- Approved participant type list for all case groups.
- Approved document and decision type catalogs.
- Whether active primary assignment uniqueness should be per `case_id` only or per `case_id + assignment_role`.
- Exact deadline type catalog and legal-basis references from source legal documents.

## How To Run

Apply schema on an empty database:

```bash
psql -d tand_quangngai -f database/migrations/001_core_database_schema.sql
```

Run tests:

```bash
psql -d tand_quangngai -f tests/database/core_schema_integrity_test.sql
psql -d tand_quangngai -f tests/database/core_schema_duplicate_prevention_test.sql
```
