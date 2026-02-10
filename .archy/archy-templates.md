# DOCS-TO-CODE (ARCHY TEMPLATES) (v4.1)

Version: 4.1.0
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
- **Session End**: Output Session Summary block and terminate (see Protocol Section 3.5)
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

## 5.5 Runner Script Template

### 5.5.1 Runner Configuration

```bash
#!/bin/bash
# .archy/runner-config.sh
# Generated by Archy Bootstrap — edit to match your environment
#
# CLI Tool Configuration
# Uncomment and modify the line matching your AI CLI tool.
# The command should accept a prompt string as its final argument.

# Gemini CLI
AI_CMD='gemini'
AI_PROMPT_FLAG='--prompt'

# Claude Code CLI
# AI_CMD='claude'
# AI_PROMPT_FLAG='--message'

# Aider
# AI_CMD='aider'
# AI_PROMPT_FLAG='--message'

# Custom tool
# AI_CMD='my-tool'
# AI_PROMPT_FLAG='run'

# Project Settings
PROJECT_NAME="{Project Name}"
ARCHY_DIR=".archy"
BASE_PROMPT="$ARCHY_DIR/base-prompt.md"
MISSION_CONTROL="$ARCHY_DIR/mission-control.md"
SESSION_LOG="$ARCHY_DIR/sessions.log"

# Runner Settings
MAX_TASKS=7          # Safety limit — max tasks per autopilot run
PAUSE_BETWEEN=2       # Seconds to pause between sessions (rate limiting)
DRY_RUN=false         # Set to true to preview without executing
```

### 5.5.2 Runner Script

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
# This script manages the loop, logging, and failure handling.

set -euo pipefail

# ─── Load Configuration ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/runner-config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config not found: $CONFIG_FILE"
    echo "   Run Archy Bootstrap first, or create runner-config.sh manually."
    exit 1
fi

source "$CONFIG_FILE"

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
    echo "   Install it or update runner-config.sh with the correct command."
    exit 1
fi

# ─── Initialize ──────────────────────────────────────────────────────
COMPLETED=0
FAILED=0
SESSION_NUM=0
START_TIME=$(date +%s)

# Create session log if it doesn't exist
touch "$SESSION_LOG"

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

# ─── Log Helper ──────────────────────────────────────────────────────
log_session() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "" >> "$SESSION_LOG"
    echo "=== Session $SESSION_NUM | $timestamp ===" >> "$SESSION_LOG"
    echo "$1" >> "$SESSION_LOG"
}

# ─── Main Loop ───────────────────────────────────────────────────────
while [ $COMPLETED -lt $MAX_TASKS ]; do
    SESSION_NUM=$((SESSION_NUM + 1))

    # Count pending tasks
    PENDING=$(grep -c '^\- \[ \]' "$MISSION_CONTROL" 2>/dev/null || true)
    BLOCKED=$(grep -c '^\- \[!\]' "$MISSION_CONTROL" 2>/dev/null || true)
    DONE=$(grep -c '^\- \[x\]' "$MISSION_CONTROL" 2>/dev/null || true)

    # Check if queue is empty
    if [ "$PENDING" -eq 0 ]; then
        echo "✅ All tasks completed or queue empty."
        echo ""
        echo "📊 Final Stats:"
        echo "   Completed this run: $COMPLETED"
        echo "   Failed: $FAILED"
        echo "   Already done: $DONE"
        echo "   Blocked: $BLOCKED"
        log_session "QUEUE EMPTY — Run complete. Completed: $COMPLETED, Failed: $FAILED"
        break
    fi

    # Display status
    echo "┌──────────────────────────────────────────"
    echo "│ 📋 Session $SESSION_NUM"
    echo "│ Pending: $PENDING | Done: $DONE | Blocked: $BLOCKED"
    echo "└──────────────────────────────────────────"

    # Dry run mode
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [DRY RUN] Would execute: $AI_CMD $AI_PROMPT_FLAG \"execute @$BASE_PROMPT\""
        echo "   🔍 [DRY RUN] Pending tasks:"
        grep '^\- \[ \]' "$MISSION_CONTROL" | head -5 | while read -r line; do
            echo "      $line"
        done
        echo ""
        log_session "[DRY RUN] Would execute session. Pending: $PENDING"
        COMPLETED=$((COMPLETED + 1))
        continue
    fi

    # Execute one task in a fresh AI session
    echo "   🔨 Launching AI session..."
    echo ""

    SESSION_OUTPUT=$($AI_CMD $AI_PROMPT_FLAG "execute @$BASE_PROMPT" 2>&1) || {
        EXIT_CODE=$?
        echo "   ⚠️  Session exited with error (code $EXIT_CODE)"
        FAILED=$((FAILED + 1))
        log_session "FAILED (exit code $EXIT_CODE)\n$SESSION_OUTPUT"

        # Check for consecutive failures
        if [ $FAILED -ge 3 ]; then
            echo ""
            echo "🛑 3 consecutive failures. Halting autopilot."
            echo "   Check .archy/sessions.log for details."
            log_session "HALTED — 3 consecutive failures"
            exit 1
        fi

        echo "   Continuing to next task..."
        sleep "$PAUSE_BETWEEN"
        continue
    }

    # Log the session output
    log_session "$SESSION_OUTPUT"

    # Check if session summary indicates failure
    if echo "$SESSION_OUTPUT" | grep -q "Status: FAILED\|Status: ESCALATED"; then
        echo "   ⚠️  Task reported FAILED or ESCALATED"
        FAILED=$((FAILED + 1))

        if [ $FAILED -ge 3 ]; then
            echo ""
            echo "🛑 3 failures reached. Halting autopilot."
            echo "   Check .archy/sessions.log for details."
            log_session "HALTED — 3 failures reached"
            exit 1
        fi
    else
        COMPLETED=$((COMPLETED + 1))
        FAILED=0  # Reset consecutive failure counter on success
        echo "   ✅ Task completed successfully"
    fi

    echo ""

    # Pause between sessions
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

## TEMPLATE USAGE REFERENCE

| Template | Used By | When |
|----------|---------|------|
| 5.1 Spec File | Architect Mode, Bootstrap Mode | Creating new task specs |
| 5.2 Mission Control | Bootstrap Mode | Initial project scaffolding |
| 5.3 Base-Prompt | Bootstrap Mode | Initial project scaffolding |
| 5.4 Project Brief | Bootstrap Mode | When no brief exists and user needs guided interview |
| 5.5.1 Runner Config | Bootstrap Mode | Initial project scaffolding |
| 5.5.2 Runner Script | Bootstrap Mode | Initial project scaffolding |

---

## VERSION HISTORY

| Version | Date | Changes |
|---------|------|---------|
| 4.1.0 | 2026-02-10 | Initial split from archy-protocol.md; added Project Brief template (5.4), Runner Script template (5.5), Template Usage Reference, session logging |

---

*Docs-to-Code (Archy Templates) v4.1 — Companion to Archy Protocol*
*Loaded on-demand. Not required during Builder or Maintenance sessions.*
