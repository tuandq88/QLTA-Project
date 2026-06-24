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
- Use PostgreSQL as the data source.
- Do not invent business rules, indicators, formulas, or legal references.
- Do not change database schema or statistics logic unless explicitly assigned.
- Use English ASCII names for technical objects.
- Use Vietnamese UTF-8 only for user-facing content.
- Define validation, permissions, audit notes, errors, and tests for every API design.

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
