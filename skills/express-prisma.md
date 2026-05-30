# ARCHY SKILL: Express & Prisma

**Domain**: Backend Framework / ORM
**Version Target**: Express 5 / Prisma 7

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

- Zero-annotation API structure where route logic and database queries are completely segregated.
- Always use `@prisma/adapter-pg` with a shared connection pool for optimal resource management.

---

## Lessons

- [3 | 2026-03-21] Parallel Worktree Symlinks: In multi-agent parallel flows, git worktrees checked out in separate folders lack generated files (such as `src/generated/client` from Prisma schema build). Instead of running a full network-dependent compile inside worktrees, install using `pnpm install --frozen-lockfile --ignore-scripts` (skipping side-effect scripts) and symbolically link `src/generated` from the integration root directory: `ln -s <main>/src/generated <worktree>/src/generated`.
- [3 | 2026-03-19] Git Staging Hygiene: When git worktrees are running under a root repository directory structure, running blanket staging commands like `git add -A` or `git add .` from the rootStages the active worktree folders as git submodules, corrupting the git history. Always target specific files or clean globs in `git add`, never use broad wildcards.
- [3 | 2026-03-18] Prisma 7 Adapter: Prisma 7 defaults to a client engine requiring a driver adapter; always use `@prisma/adapter-pg` with the existing `pg` pool in the database connection singleton.
