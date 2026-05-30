# ARCHY SKILL: API Design

**Domain**: Endpoint Design / OpenAPI Validation
**Version Target**: OpenAPI 3.x / Zod 3.x

---

<!--
  FORMAT SPEC — DO NOT EDIT, used by Builder/Debugger/Housekeeper:
  Entry format:  - [score | YYYY-MM-DD] Lesson description
    - score: integer, number of independent sightings (starts at 1 in candidates, promotes to skill at ≥ 3)
    - YYYY-MM-DD: last_seen date
  Sort order: score desc, last_seen desc as tiebreaker
  Cap: 25 entries per skill file. Overflow demotes the lowest-score entry to `_archive.md`.
  Writers: Housekeeper (normal lifecycle), Builder/Debugger (direct write on user corrections).
-->

## Core Tenets

- Zero-annotation AST-based API contracts.
- Strictly type-safe validation schemas using declarative Zod libraries.

---

## Lessons

- [3 | 2026-03-18] AST-Driven Swagger Spec Generation: OpenAPI specs should be auto-generated programmatically from live code instead of manual, drift-prone comment annotations (like `@swagger` or JSDocs) which severely pollute LLM context windows. Declare route metadata objects (`export const routeMeta = { tag: 'Sales', prefix: '/api/sales', secured: true };`) and use an AST-based parser utility to read these metadata variables alongside middleware Zod validators (`validateBody`, `validateQuery`) to compile complete Swagger JSON schemas upon startup.
- [3 | 2026-03-18] Zod Union Mutual Exclusivity: In Zod, using `z.union()` causes the parser to pick the first matching branch and strip unknown properties, making cross-field mutual exclusivity checks unreliable. For schemas that require "exactly one of fieldA or fieldB", use a standard object structure with both fields optional, and then enforce the constraint using `.superRefine()`—this ensures Zod inspects all raw inputs before issuing validation issues.
- [3 | 2026-03-18] Stripe Webhook Body Parsing: Express routes handling Stripe webhooks must apply `express.raw()` body parser before any standard body parsers to capture the exact raw body required for webhook cryptographic signature verification.
