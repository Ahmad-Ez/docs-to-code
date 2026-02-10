# ARCHY TEMPLATES (v4.1)

Version: 4.1.0
Companion to: archy-protocol.md

This file contains structural templates for all Auto-Archy artifacts.
It is loaded ONLY during Bootstrap Mode (Mode D) and Architect Mode (Mode B) when creating new artifacts.
It is NOT loaded during Builder Mode or Maintenance Mode.

---

## 5.1 Spec File Template

```markdown
# SPEC: {Feature Name}

## META
Role: {Role for this task — use =Role to replace, +Role to merge, or plain Role for auto-detect}
Depends-On: [{list of spec filenames this depends on, or empty array}]
Blocks: [{list of spec filenames that depend on this, for documentation}]
Estimated-Effort: {optional: time estimate}

---

## 1. Objective

{Briefly describe what we are building and why. Include success criteria.}

---

## 2. Technical Requirements

- **Files to Create/Edit**: `src/...`
- **Dependencies**: {packages to add to manifest}
- **Key Constraints**: {e.g., "Use Zod for validation", "Mobile-first CSS", "Must be idempotent"}

---

## 3. Implementation Steps

- [ ] Step 1: {Scaffolding/setup task}
- [ ] Step 2: {Core logic implementation}
- [ ] Step 3: {Error handling and edge cases}
- [ ] Step 4: {Integration with existing modules}

---

## 4. Verification Plan (Definition of Done)

**Test Command**: `{e.g., npm test, pytest, cargo test}`

- [ ] Unit tests written and passing
- [ ] Integration tests passing (if applicable)
- [ ] Linter/formatter checks pass
- [ ] Manual verification: {describe how to verify}

---

## 5. Artifacts

**Implementation**:
- `{path/to/file.ts}`

**Tests**:
- `{path/to/file.test.ts}`

---

## 6. Notes

{Any additional context, decisions made, or gotchas for future reference.}
```

---

## 5.2 Mission Control Template

```markdown
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

---

## Completed Archive

<!-- Move completed items here to keep the queue clean -->

---

## Blocked / Needs Attention

<!-- Items that cannot proceed without user intervention -->
```

---

## 5.3 Base-Prompt Template

```markdown
# ARCHY: SESSION LAUNCHER

**Protocol-Version**: 4.1.0
**Tested-With-Protocol**: 4.1.0

---

## Target_Task

{Leave empty for auto-pilot Builder Mode, or specify task like "Plan user authentication" or "Fix CORS error in app.ts"}

---

## Project Identity

**Name**: {Project Name}
**Stack**: {e.g., Next.js 14, Prisma, PostgreSQL, TailwindCSS}
**Repo**: {optional: repo URL}

---

## Default Role

{e.g., Senior Full-Stack Engineer (Node.js/React Focus)}

**Capabilities**: {e.g., System Architecture, API Design, DevOps, Security}
**Tone**: {e.g., Objective, Professional, Concise}

---

## Project Archetype

### Stack Conventions
- {e.g., All API routes in `app/api/`}
- {e.g., Zod for all input validation}
- {e.g., Error codes defined in `lib/errors.ts`}

### Code Style
- {e.g., Prettier + ESLint with Airbnb config}
- {e.g., Prefer named exports}

### Testing Strategy
- {e.g., Vitest for unit tests, Playwright for E2E}
- {e.g., Test command: `npm test`}

---

## Role Overrides (Optional)

| Mode | Role Override |
|------|---------------|
| Builder | {default from above, or override} |
| Architect | {e.g., System Architect + DBA} |
| Maintenance | {e.g., Security-Conscious Fixer} |

---

## Custom Rules (Optional)

{Any project-specific rules that supplement the protocol. These take precedence over protocol defaults but cannot contradict Iron Rules.}

---

## Lessons Learned (AI-Appendable)

<!-- Architect/Maintenance modes may append entries here with user approval -->

- {date}: {lesson learned during development}

---

## 🚀 SYSTEM LOGIC

### Step 1: Load Constitution
Read and internalize: `@.archy/archy-protocol.md`

### Step 2: Determine Mode

**IF** `Target_Task` is NOT empty:
- **ACTIVATE**: MAINTENANCE or ARCHITECT MODE (based on task nature)
- **Context**: Load `@.archy/mission-control.md` (read-only for context)
- **Action**: Execute `Target_Task` immediately
- **Rule**: If task changes system logic, update the relevant spec file before finishing

**ELSE** (Target_Task is empty):
- **ACTIVATE**: BUILDER MODE (AUTOPILOT)
- **Context**: Read `@.archy/mission-control.md`
- **Logic**: 
  1. Parse `Depends-On` declarations
  2. Find first `[ ]` item with all dependencies satisfied (`[x]`)
  3. Load the referenced spec file
- **Action**: Execute the Implementation Steps inside that spec
- **Completion**: Mark `[x]` in mission-control ONLY after verification passes
- **Empty Queue?**: If all items are `[x]`, switch to ARCHITECT MODE and ask user for next milestone
```

---

## 5.4 Project Brief Template

```markdown
# Project Brief: {Project Name}

## 1. Vision

{One paragraph: What is this? Who is it for? What problem does it solve?}

---

## 2. Core Features

List features in priority order (P0 = must-have for v1, P1 = important, P2 = nice-to-have):

- **P0**: {Feature 1} — {brief description}
- **P0**: {Feature 2} — {brief description}
- **P1**: {Feature 3} — {brief description}
- **P2**: {Feature 4} — {brief description}

---

## 3. Tech Stack

### Required/Preferred
- **Runtime**: {e.g., Node.js 20, Python 3.12, Bun}
- **Framework**: {e.g., Next.js 14, FastAPI, SvelteKit}
- **Database**: {e.g., PostgreSQL, MongoDB, SQLite, Supabase}
- **ORM/Query Builder**: {e.g., Prisma, Drizzle, SQLAlchemy}
- **Auth**: {e.g., NextAuth, Clerk, Lucia, custom JWT}
- **Hosting**: {e.g., Vercel, AWS, Railway, self-hosted}

### Optional/Under Consideration
- **Cache**: {e.g., Redis, in-memory}
- **Storage**: {e.g., S3, Cloudflare R2, local}
- **Payments**: {e.g., Stripe, Lemon Squeezy}
- **Email**: {e.g., Resend, SendGrid, Postmark}
- **Other**: {any other services or tools}

### Open to Suggestions
{List areas where you'd like the Architect to recommend options}

---

## 4. Constraints & Requirements

### Technical Constraints
- {e.g., Must work offline}
- {e.g., Must support multi-tenancy}
- {e.g., API response time < 200ms}

### Compliance & Security
- {e.g., GDPR compliance required}
- {e.g., SOC2 considerations}
- {e.g., Data must not leave EU}

### Integration Requirements
- {e.g., Must integrate with existing legacy API at X}
- {e.g., SSO with company Okta}

### Timeline & Resources
- {e.g., MVP needed in 4 weeks}
- {e.g., Solo developer}

---

## 5. Out of Scope (v1)

Explicitly list what is NOT included in the initial release:

- {e.g., Mobile app — web only for v1}
- {e.g., Multi-language / i18n support}
- {e.g., Advanced analytics dashboard}
- {e.g., Public API for third-party integrations}

---

## 6. User Roles & Personas

| Role | Description | Key Actions |
|------|-------------|-------------|
| {e.g., Admin} | {e.g., Platform owner, manages settings} | {e.g., CRUD users, view analytics, configure billing} |
| {e.g., Member} | {e.g., Regular user of the platform} | {e.g., Create projects, invite collaborators} |
| {e.g., Guest} | {e.g., View-only access via shared link} | {e.g., View shared content, leave comments} |

---

## 7. Success Criteria

Define what "done" looks like for v1:

### Functional
- {e.g., User can sign up, verify email, and log in}
- {e.g., User can create, edit, and delete projects}
- {e.g., Admin can manage users and billing}

### Non-Functional
- {e.g., 90% test coverage on core modules}
- {e.g., Lighthouse performance score > 90}
- {e.g., Page load time < 2s on 3G}
- {e.g., Zero critical security vulnerabilities}

---

## 8. Existing Assets (Optional)

{List anything that already exists and should be incorporated or respected}

- {e.g., Existing database with schema at `docs/legacy-schema.sql`}
- {e.g., Brand guidelines at `docs/brand.pdf`}
- {e.g., Figma designs at [link]}
- {e.g., Existing API docs at [link]}

---

## 9. Open Questions

{Unresolved decisions for Architect Mode to clarify with the user}

- {e.g., Should we use server-side or client-side auth state management?}
- {e.g., Do we need real-time features (WebSocket) for v1?}
- {e.g., Monorepo or separate repos for frontend/backend?}
```

---

## TEMPLATE USAGE REFERENCE

| Template | Used By | When |
|----------|---------|------|
| 5.1 Spec File | Architect Mode, Bootstrap Mode | Creating new task specs |
| 5.2 Mission Control | Bootstrap Mode | Initial project scaffolding |
| 5.3 Base-Prompt | Bootstrap Mode | Initial project scaffolding |
| 5.4 Project Brief | Bootstrap Mode | When no brief exists and user needs guided interview |

---

## VERSION HISTORY

| Version | Date | Changes |
|---------|------|---------|
| 4.1.0 | 2026-02-10 | Initial split from archy-protocol.md; added Project Brief template (5.4), Template Usage Reference |

---

*Archy Templates v4.1 — Companion to Archy Protocol*
*Loaded on-demand. Not required during Builder or Maintenance sessions.*
