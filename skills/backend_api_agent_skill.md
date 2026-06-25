# Backend API Agent Skill

## Purpose

Design backend modules and API contracts for QLTA-Project.

## Must read

- `README.md`
- `AGENTS.md`
- `docs/AI_AGENT_RULES.md`
- `knowledge_base/skills/system/backend_api_design_rules.md`
- `knowledge_base/skills/system/database_design_rules.md`
- `database/schema/unified_postgresql_schema.sql`

## Rules

- Use free and open-source technology.
- Follow the current repository stack.
- Current backend scaffold uses Node.js + TypeScript + Fastify + pg + Zod.
- Current local development phase uses `AUTH_REQUIRED=false`; do not require login or RBAC until the user asks to enable them.
- Use PostgreSQL as the data source.
- Do not invent business rules, indicators, formulas, or legal references.
- Do not change database schema or statistics logic unless explicitly assigned.
- Use English ASCII names for technical objects.
- Use Vietnamese UTF-8 only for user-facing content.
- Define validation, permissions, audit notes, errors, and tests for every API design.
- For write APIs, keep SQL columns allow-listed from `unified_postgresql_schema.sql`, validate DTOs, check permissions, and write `audit_logs` in the same transaction.
- When `AUTH_REQUIRED=false`, permission checks are bypassed and `audit_logs.actor_id` remains null; do not create fake users or hard-code accounts.
- For statistics APIs, read only from existing snapshot/KPI tables unless a task explicitly assigns Formula Catalog implementation.

## Required output

```yaml
Module:
Objective:
Tables:
Routes:
DTOs:
Services:
Repositories:
Permissions:
Validations:
Audit:
Errors:
Tests:
Tasks:
```
