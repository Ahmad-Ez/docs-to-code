# DOCS-TO-CODE (ARCHY TEMPLATES) (v6.1)

Version: 6.1.0
Companion to: archy-protocol.md

This file contains structural templates for all Archy artifacts.
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
- [ ] Environmental verification (e.g., Browser Subagent visual check if applicable)

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

**Protocol-Version**: 6.1.0
**Tested-With-Protocol**: 6.1.0

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

## Environment & Capabilities

{Define IDE-specific capabilities or tools available to the AI in this specific environment.}

- **Browser Subagent**: {e.g., Available. Use the browser subagent to visually verify UI/UX changes on `localhost:3000`. Test responsiveness (375px, 768px, 1440px) and i18n RTL rendering.}
- **Terminal Integration**: Standard
- **Verification Protocol**: 
  1. Run standard CLI checks (build, lint, test).
  2. **IF** UI changes were made, invoke Browser Subagent to execute visual checks.

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

## Active Skills (Stack Memory)

*Load ONLY the skills relevant to the current task. Do not read all files.*
*`_candidates.md` is read ONLY during lesson extraction at session end — never during task execution.*

| Skill | File | Load when... |
|-------|------|--------------|
| Project Quirks | `@.archy/skills/_project.md` | Always |
| {skill name} | `@.archy/skills/{file}.md` | {brief trigger description} |

---

## 🚀 SYSTEM LOGIC

### Subagent Delegation (Optional)

If the host environment supports spawning specialized subagents (e.g., `.claude/agents/` in Claude Code), **delegate** each mode to its matching agent instead of executing inline:

| Mode | Subagent | Fallback |
|------|----------|----------|
| ARCHITECT | `archy-architect` | Execute architect steps inline |
| BUILDER | `archy-builder` | Execute builder steps inline |
| MAINTENANCE | *(none — always inline)* | Execute directly |

After a Builder subagent completes, spawn `spec-reviewer` to verify the implementation against its spec before marking it done.

If subagents are **not** available, proceed inline as described below.

---

### Step 1: Load Constitution
Read and internalize: `@.archy/archy-protocol.md`

### Step 2: Determine Mode

**IF** `Target_Task` is NOT empty:
- **ACTIVATE**: MAINTENANCE or ARCHITECT MODE (based on task nature)
- **Context**: Load `@.archy/mission-control.md` (read-only for context)
- **Action**: Execute `Target_Task` immediately (or delegate to the appropriate subagent)
- **Rule**: If task changes system logic, update the relevant spec file before finishing

**ELSE** (Target_Task is empty):
- **ACTIVATE**: BUILDER MODE (AUTOPILOT)
- **Context**: Read `@.archy/mission-control.md`
- **Logic**:
  1. Parse `Depends-On` declarations
  2. Find first `[ ]` item with all dependencies satisfied (`[x]`)
  3. Load the referenced spec file
- **Action**: Execute the spec (or delegate to the builder subagent)
- **Review**: After implementation, verify against the spec (or delegate to the reviewer subagent)
- **Completion**: Mark `[x]` in mission-control ONLY after verification passes
- **Session End**: Output Session Summary block and terminate (see Protocol Section 4)
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

## 5.5 Skills Plugin Template

```markdown
# ARCHY SKILL: {Technology Name} (e.g., Next.js App Router)

**Domain**: {e.g., Frontend Framework, ORM, Testing}
**Version Target**: {e.g., v14.x - v15.x}

---

## Core Tenets
- {e.g., Server Components by default, Client Components only when interactivity is needed.}
- {e.g., Colocate data fetching with the components that need it.}

---

## Lessons
<!-- MAX: 25 entries. Sorted by score desc (tiebreak: last_seen desc). Demote from bottom when cap exceeded. -->
<!-- Format: - [score | last_seen] Lesson description -->

- [5 | 2026-03-15] {e.g., App Router params changed in v15 — use `params` as Promise}
- [3 | 2026-03-10] {e.g., Use `next/dynamic` for client-only libs, not conditional rendering}
- [1 | 2026-02-20] {e.g., Middleware runs on edge runtime — no Node.js APIs available}

---

```

**Note**: The `_project.md` skill file uses this same template with domain "Project-Specific" and "Load when: always" in the Active Skills table. It holds project-specific lessons that previously lived in the base-prompt quirks section.

---

## 5.6 Runner Script Template

```bash
#!/bin/bash
# .archy/archy-runner.sh
# Generated by Archy Bootstrap — the outer autopilot loop
#
# Usage:
#   ./archy-runner.sh              # Normal autopilot
#   ./archy-runner.sh --dry-run    # Preview mode (no execution)
#   ./archy-runner.sh --max 10     # Limit to 10 tasks
#
# This script runs one AI session per task in a fresh context.
# The AI handles ONE spec, outputs a Session Summary, and exits.
# This script manages the loop, logging, Git-Ops, and failure handling.

set -euo pipefail

# ─── Configuration ───────────────────────────────────────────────────

# CLI Tool Configuration
AI_CMD='gemini'              # Your AI CLI tool (e.g., gemini, claude, aider)
AI_PROMPT_FLAG='--prompt'    # How it accepts prompts (e.g., --prompt, --message)

# Project Settings
PROJECT_NAME="{Project Name}"
ARCHY_DIR=".archy"
BASE_PROMPT="$ARCHY_DIR/base-prompt.md"
MISSION_CONTROL="$ARCHY_DIR/mission-control.md"
SESSION_LOG="$ARCHY_DIR/sessions.log"

# Runner Limits
MAX_TASKS=7                  # Safety limit — max tasks per autopilot run
PAUSE_BETWEEN=2              # Seconds to pause between sessions
DRY_RUN=false                # Set to true to preview without executing

# Autonomous Git-Ops (Opt-In Features)
# WARNING: Enabling these allows the runner to automatically branch, commit, and merge.
AUTO_GIT=false
AUTO_CREATE_BRANCH=false
AUTO_COMMIT=false
AUTO_MERGE=false
AUTO_DELETE_BRANCH=false

# Git-Ops Variables
GIT_BASE_BRANCH="dev"
GIT_FEATURE_PREFIX="feature"
GIT_COMMIT_PREFIX="feat"

# ─── Parse CLI Arguments ─────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --max)
            MAX_TASKS="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: archy-runner.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Preview mode — show what would run without executing"
            echo "  --max N      Maximum number of tasks to execute (default: $MAX_TASKS)"
            echo "  --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run with --help for usage."
            exit 1
            ;;
    esac
done

# ─── Validate Environment ────────────────────────────────────────────
if [ ! -f "$BASE_PROMPT" ]; then
    echo "❌ Base prompt not found: $BASE_PROMPT"
    echo "   Run Archy Bootstrap first."
    exit 1
fi

if [ ! -f "$MISSION_CONTROL" ]; then
    echo "❌ Mission control not found: $MISSION_CONTROL"
    echo "   Run Archy Bootstrap first."
    exit 1
fi

if ! command -v "$AI_CMD" &> /dev/null; then
    echo "❌ AI CLI tool not found: $AI_CMD"
    echo "   Install it or update the configuration at the top of this script."
    exit 1
fi

# ─── Initialize ──────────────────────────────────────────────────────
COMPLETED=0
FAILED=0
SESSION_NUM=0
START_TIME=$(date +%s)

touch "$SESSION_LOG"

# ─── Helpers ─────────────────────────────────────────────────────────
log_session() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "" >> "$SESSION_LOG"
    echo "=== Session $SESSION_NUM | $timestamp ===" >> "$SESSION_LOG"
    echo "$1" >> "$SESSION_LOG"
}

get_next_spec() {
    local line
    line=$(grep -m 1 '^\- \[ \]' "$MISSION_CONTROL" || true)
    echo "$line" | sed -n 's/.*\([A-Za-z0-9._-]\+\.md\).*/\1/p'
}

git_is_ready() {
    [ "$AUTO_GIT" = true ] && command -v git &> /dev/null && [ -d ".git" ]
}

# ─── Header ──────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════╗"
echo "║  🚀 Archy Runner — Autopilot Mode               ║"
echo "║  Project: $PROJECT_NAME"
echo "║  Max Tasks: $MAX_TASKS"
if [ "$DRY_RUN" = true ]; then
echo "║  ⚠️  DRY RUN — No sessions will be executed      ║"
fi
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ─── Main Loop ───────────────────────────────────────────────────────
while [ $COMPLETED -lt $MAX_TASKS ]; do
    SESSION_NUM=$((SESSION_NUM + 1))

    # Count tasks
    PENDING=$(grep -c '^\- \[ \]' "$MISSION_CONTROL" 2>/dev/null || echo 0)
    BLOCKED=$(grep -c '^\- \[!\]' "$MISSION_CONTROL" 2>/dev/null || echo 0)
    DONE=$(grep -c '^\- \[x\]' "$MISSION_CONTROL" 2>/dev/null || echo 0)

    if [ "$PENDING" -eq 0 ]; then
        echo "✅ All tasks completed or queue empty."
        echo ""
        echo "📊 Final Stats: Completed: $COMPLETED | Failed: $FAILED | Done: $DONE | Blocked: $BLOCKED"
        log_session "QUEUE EMPTY — Run complete. Completed: $COMPLETED, Failed: $FAILED"
        break
    fi

    echo "┌──────────────────────────────────────────"
    echo "│ 📋 Session $SESSION_NUM"
    echo "│ Pending: $PENDING | Done: $DONE | Blocked: $BLOCKED"
    echo "└──────────────────────────────────────────"

    SPEC_FILE=$(get_next_spec)
    SPEC_ID="${SPEC_FILE%.md}"
    FEATURE_BRANCH=""

    # Pre-Session Git-Ops
    if git_is_ready; then
        if [ -n "$SPEC_ID" ] && [ "$AUTO_CREATE_BRANCH" = true ]; then
            git checkout "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
            git pull --ff-only origin "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
            FEATURE_BRANCH="$GIT_FEATURE_PREFIX/$SPEC_ID"
            if git show-ref --verify --quiet "refs/heads/$FEATURE_BRANCH"; then
                git checkout "$FEATURE_BRANCH" >/dev/null 2>&1 || true
            else
                git checkout -b "$FEATURE_BRANCH" >/dev/null 2>&1 || true
            fi
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [DRY RUN] Would execute: $AI_CMD $AI_PROMPT_FLAG \"execute @$BASE_PROMPT\""
        log_session "[DRY RUN] Would execute session. Pending: $PENDING"
        COMPLETED=$((COMPLETED + 1))
        continue
    fi

    echo "   🔨 Launching AI session..."
    echo ""

    # Execute session with robust output capture
    SESSION_TMP=$(mktemp)
    if command -v script &> /dev/null; then
        script -q -e -c "$AI_CMD $AI_PROMPT_FLAG \"execute @$BASE_PROMPT\"" "$SESSION_TMP"
        EXIT_CODE=$?
        SESSION_OUTPUT=$(sed '/^Script (started|done) on/d' "$SESSION_TMP")
    else
        $AI_CMD $AI_PROMPT_FLAG "execute @$BASE_PROMPT" 2>&1 | tee "$SESSION_TMP"
        EXIT_CODE=${PIPESTATUS[0]}
        SESSION_OUTPUT=$(cat "$SESSION_TMP")
    fi
    rm "$SESSION_TMP"

    if [ $EXIT_CODE -ne 0 ]; then
        echo "   ⚠️  Session exited with error (code $EXIT_CODE)"
        FAILED=$((FAILED + 1))
        log_session "FAILED (exit code $EXIT_CODE)\n$SESSION_OUTPUT"

        if [ $FAILED -ge 3 ]; then
            echo "🛑 3 consecutive failures. Halting autopilot."
            log_session "HALTED — 3 consecutive failures"
            exit 1
        fi
        sleep "$PAUSE_BETWEEN"
        continue
    fi

    log_session "$SESSION_OUTPUT"

    # Check session outcome
    if echo "$SESSION_OUTPUT" | grep -q "Status: FAILED\|Status: ESCALATED"; then
        echo "   ⚠️  Task reported FAILED or ESCALATED"
        FAILED=$((FAILED + 1))
        if [ $FAILED -ge 3 ]; then
            echo "🛑 3 failures reached. Halting autopilot."
            log_session "HALTED — 3 failures reached"
            exit 1
        fi
    else
        COMPLETED=$((COMPLETED + 1))
        FAILED=0
        echo "   ✅ Task completed successfully"

        # Check for Upstream Sync Flags
        if echo "$SESSION_OUTPUT" | grep -q "\[FLAG: Sync upstream"; then
            echo "   💡 NOTE: Session flagged generic knowledge for upstream sync. Check logs."
        fi

        # Post-Session Git-Ops
        if git_is_ready; then
            if [ "$AUTO_COMMIT" = true ] && [ -n "$SPEC_ID" ]; then
                if ! git diff --quiet || ! git diff --cached --quiet; then
                    git add -A
                    git commit -m "$GIT_COMMIT_PREFIX: $SPEC_ID" >/dev/null 2>&1 || true
                fi
            fi
            if [ "$AUTO_MERGE" = true ] && [ -n "$FEATURE_BRANCH" ]; then
                git checkout "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
                git pull --ff-only origin "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
                if git merge --no-ff "$FEATURE_BRANCH" -m "merge: $SPEC_ID" >/dev/null 2>&1; then
                    if [ "$AUTO_DELETE_BRANCH" = true ]; then
                        git branch -d "$FEATURE_BRANCH" >/dev/null 2>&1 || true
                    fi
                else
                    echo "   ⚠️  Merge failed for $FEATURE_BRANCH into $GIT_BASE_BRANCH"
                fi
            fi
        fi
    fi

    echo ""
    sleep "$PAUSE_BETWEEN"
done

# ─── Summary ─────────────────────────────────────────────────────────
END_TIME=$(date +%s)
ELAPSED=$(( END_TIME - START_TIME ))
MINUTES=$(( ELAPSED / 60 ))
SECONDS=$(( ELAPSED % 60 ))

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  🏁 Autopilot Run Complete                       ║"
echo "║  Tasks Completed: $COMPLETED"
echo "║  Tasks Failed: $FAILED"
echo "║  Time Elapsed: ${MINUTES}m ${SECONDS}s"
echo "║  Session Log: $SESSION_LOG"
echo "╚══════════════════════════════════════════════════╝"

log_session "RUN COMPLETE — Completed: $COMPLETED, Failed: $FAILED, Time: ${MINUTES}m ${SECONDS}s"

```

---

## 5.7 Claude Code Agent Definition Templates

*Generated during Bootstrap ONLY if the environment is Claude Code. Skip for other AI tools.*

### archy-architect.md

````markdown
---
name: archy-architect
description: Plans new features by creating detailed spec files for the Archy protocol
tools: Read, Write, Edit, Glob, Grep
---

You are an **Architect** in the Archy docs-to-code protocol.

## Context

- Read `.archy/project-brief.md` for project vision and constraints
- Read `.archy/mission-control.md` for current queue state
- Read existing specs in `.archy/specs/` for patterns and numbering

## Process

1. **Interrogate** — Ask clarifying questions about scope, edge cases, and integration points. Do not guess.
2. **Draft spec** in `.archy/specs/` with:
   - META: Role, Depends-On, Effort estimate
   - Objective with success criteria
   - Implementation steps (checkboxed)
   - Verification plan with test commands
   - Artifacts list
3. **Schedule** — Append to `.archy/mission-control.md` respecting dependency order
4. If prerequisites don't exist, create those specs first

## Rules

- Number specs sequentially based on existing highest number
- Keep specs focused — one feature per spec
- Assign appropriate roles (e.g., +Security Auditor for auth features)
````

### archy-builder.md

````markdown
---
name: archy-builder
description: Executes one spec from mission-control following the Archy docs-to-code protocol
tools: Read, Write, Edit, Bash, Grep, Glob
---

You are a **Builder** in the Archy docs-to-code protocol.

## Context

- Read `.archy/archy-protocol.md` Section 3 MODE A for full rules
- Read `.archy/base-prompt.md` for project conventions and stack details
- Load only the skill files relevant to this spec from `.archy/skills/`

## Process

1. Read the assigned spec file from `.archy/specs/`
2. Apply Role Composition Rules from the protocol
3. Follow TDD: write/plan tests first, then implement, then verify
4. Check off implementation steps as you complete them
5. Run the verification plan (test command from spec)
6. Extract lessons learned → write to `.archy/skills/_candidates.md` (or directly to skill file for user corrections). Process promotions, demotions, expirations, and archive audit trigger per Protocol Section 4.
7. Mark spec as complete in `.archy/mission-control.md`

## Rules

- ONE spec per session — do not pick up the next task
- Halt after 3 consecutive test failures and escalate
- Do not modify files outside the spec's scope without justification
````

### spec-reviewer.md

````markdown
---
name: spec-reviewer
description: Reviews implementation against its spec, checking for gaps and regressions
tools: Read, Grep, Glob, Bash
---

You are a **Spec Reviewer** in the Archy docs-to-code protocol.

## Process

1. Read the spec file and identify all success criteria
2. Read the implementation artifacts listed in the spec
3. Run the verification plan commands
4. Check every implementation step checkbox claim against actual code
5. Report: PASS (all criteria met) or FAIL (list gaps)

## Rules

- Do NOT fix code — only report findings
- Be objective and thorough
- Check for regressions in files adjacent to changed code
````

---

## 5.8 Candidates Buffer Template

```markdown
# Skill Candidates (Staging Buffer)
<!-- MAX: 15 entries. AI reads this ONLY during lesson extraction at session end — never during task execution. -->
<!-- Score increments on independent re-encounter across sessions (same session = 1 sighting max). -->
<!-- Promote to relevant skill file when score >= 3. Expire to _archive.md if last_seen > 10 sessions ago. -->

| # | Lesson | Category | First Seen | Last Seen | Score | Origin |
|---|--------|----------|------------|-----------|-------|--------|
```

---

## 5.9 Skills Archive Template

```markdown
# Skills Archive
<!-- Demotions since last audit: 0 -->
<!-- AI writes here on demotion/expiry. AI reads ONLY during archive audit (triggered every 5 demotions). -->
<!-- Human-reviewable safety net. Entries carry their last score for context. -->
<!-- During audit: group semantically similar entries, sum scores, revive aggregates with score >= 3 to _candidates.md, merge duplicates. -->

## Archived Entries

<!-- Format: -->
<!-- - [score | date_archived] Origin: {skills/file.md or _candidates.md} | Reason: {cap-overflow | expired | audit-merged} -->
<!--   {Lesson description} -->
```

---

## TEMPLATE USAGE REFERENCE

| Template | Used By | When |
| --- | --- | --- |
| 5.1 Spec File | Architect Mode, Bootstrap Mode | Creating new task specs |
| 5.2 Mission Control | Bootstrap Mode | Initial project scaffolding |
| 5.3 Base-Prompt | Bootstrap Mode | Initial project scaffolding |
| 5.4 Project Brief | Bootstrap Mode | When no brief exists and user needs guided interview |
| 5.5 Skills Plugin | Bootstrap Mode, Builder Mode | Creating/updating skill files (including `_project.md`) |
| 5.6 Runner Script | Bootstrap Mode | Initial project scaffolding |
| 5.7 Claude Code Agents | Bootstrap Mode | When environment is Claude Code — generates `.claude/agents/` definitions |
| 5.8 Candidates Buffer | Bootstrap Mode | Initial scaffolding of `.archy/skills/_candidates.md` |
| 5.9 Skills Archive | Bootstrap Mode | Initial scaffolding of `.archy/skills/_archive.md` |

---

## VERSION HISTORY

| Version | Date | Changes |
| --- | --- | --- |
| 6.1.0 | 2026-03-18 | Skill lifecycle: replaced base-prompt quirks with `_project.md` skill file, added candidates buffer template (5.8), skills archive template (5.9), score-sorted lesson format `[score | last_seen]`, updated skills plugin template with 25-entry cap. |
| 6.0.0 | 2026-03-09 | Conditional skill loading in base-prompt, subagent delegation in system logic, quirks cap (max 5), Claude Code agent templates (5.7). |
| 5.0.0 | 2026-02-27 | Added Environment & Capabilities and Active Skills to Base-Prompt. Merged Runner Config into Runner Script and added Git-Ops features. Added Skills Plugin Template. |
| 4.1.0 | 2026-02-10 | Initial split from archy-protocol.md; added Project Brief template, Runner Script template, session logging. |

---

*Docs-to-Code (Archy Templates) v6.1 — Companion to Archy Protocol*
*Loaded on-demand. Not required during Builder or Maintenance sessions.*
