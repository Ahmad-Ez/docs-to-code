# 🚀 Mission Control

## Status Legend
- `[x]` — Completed & Verified
- `[ ]` — Queued (eligible for auto-pilot when dependencies met)
- `[~]` — Skipped / Deprecated
- `[!]` — Blocked (dependency issue or needs user input)

---

## Execution Queue

<!--
  Dependencies are declared inline. Format:
  - [ ] @.archy/specs/feature.md | Depends-On: [dep1.md, dep2.md]

  If no dependencies, omit the Depends-On clause:
  - [ ] @.archy/specs/standalone-feature.md
-->

- [x] @.archy/specs/00-project-init.md
- [ ] @.archy/specs/01-database-schema.md | Depends-On: [00-project-init.md]
- [ ] @.archy/specs/02-auth-setup.md | Depends-On: [01-database-schema.md]
- [ ] @.archy/specs/03-api-routes.md | Depends-On: [01-database-schema.md, 02-auth-setup.md]

---

## Completed Archive

<!-- Move completed items here to keep the queue clean -->

---

## Blocked / Needs Attention

<!-- Items that cannot proceed without user intervention -->
