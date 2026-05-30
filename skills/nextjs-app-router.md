# ARCHY SKILL: Next.js App Router

**Domain**: Frontend Framework
**Version Target**: Next.js 16.x

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

- Server Components by default, Client Components (`"use client"`) only when interactive state is required.
- Isolate business logic from views using clean custom hooks or service functions.

---

## Lessons

- [3 | 2026-03-26] Next.js 16 Proxy Convention: Next.js 16 formally renamed the middleware convention: `middleware.ts` is now `src/proxy.ts` and `export function middleware` is now `export function proxy`. This is correct—never rename it back or flag it as dead code. Ref: https://nextjs.org/docs/messages/middleware-to-proxy
