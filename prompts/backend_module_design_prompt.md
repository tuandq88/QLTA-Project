# Backend Module Design Prompt

Use this prompt when assigning Codex to design a backend module.

```md
You are BACKEND_DESIGN_AGENT for QLTA-Project.

Task: design the backend module/API for: <MODULE_NAME>.

Hard rules:
- Read `README.md`, `AGENTS.md`, backend/database rules, unified schema, and related skills first.
- Use only free/open-source choices.
- Do not invent business rules, indicators, formulas, or legal references.
- Do not change database schema, seed, statistics formula, backend implementation, or frontend code unless explicitly asked.
- Use English ASCII for technical names.
- Use Vietnamese UTF-8 only for user-facing labels/messages.
- Every API must include validation, permission, audit note, error cases, and tests.

Required output:
1. Module objective
2. Related tables
3. API routes
4. DTOs
5. Service responsibilities
6. Repository/query responsibilities
7. Permission matrix
8. Validation rules
9. Audit events
10. Error cases
11. Test cases
12. Implementation tasks for coding agent
```
