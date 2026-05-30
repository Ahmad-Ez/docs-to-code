# ARCHY SKILL: Tooling & Scripting

**Domain**: Tooling / Scripting / Windows Automation
**Version Target**: PowerShell 7 / Bash

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

- Zero hardcoding of identities in automation scripts.
- Cross-platform execution compatibility (Bash and Windows PowerShell setups).

---

## Lessons

- [3 | 2026-03-03] PowerShell Parameter Isolation: Avoid naming script parameters or local variables with reserved PowerShell automatic variable names (such as `$Profile`), as they will shadow system profiles and corrupt startup environments. Use names like `$Identity` instead.
- [3 | 2026-03-03] Dynamic Identity Extraction: Avoid hardcoding individual developer user names (e.g. "ahmad") inside git/PR automation scripts. Dynamically extract the active developer from git config (`git config user.name`/`email`) and write execution state variables to local gitignored files to make tooling completely zero-setup.
- [3 | 2026-03-03] PowerShell Command Chaining: Use `;` as a command separator instead of `&&` when running multi-command executions in PowerShell, as `&&` is not natively supported in standard Windows environments.
