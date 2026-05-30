# ARCHY TEMPLATES (v7.0)

**Version**: 7.0.0
**Companion to**: `archy-protocol.md`, `archy-conductor.md`

This file serves three purposes:

1. **Executable prompts**: Bootstrap (Section A) and Migration (Section B) are full prompts an AI can execute when invoked explicitly.
2. **Artifact skeletons**: Section C holds the templates for files created at bootstrap time.
3. **Agent definitions**: Section D holds the six agent templates with environment-conditional blocks.

Loaded only at bootstrap, migration, or when the Architect needs to reference an artifact format. Not loaded during normal Builder/Maintenance sessions.

---

## DISPATCHER (Instructions for AI loading this file)

If the user invokes this file with an `execute` directive, determine their intent from their message:

| User says... | Execute |
| -------------- | --------- |
| "bootstrap", "initialize", "set up", "new project" | **Section A** — Bootstrap Prompt |
| "migrate", "upgrade from v6", "convert old archy" | **Section B** — Migration Prompt |
| (anything else, or ambiguous) | HALT. Ask: "Do you want to bootstrap a new project or migrate from v6.1?" |

If the user did NOT use an `execute` directive and is just referencing this file for a template, treat the file as reference documentation. Do not execute anything.

---

## SECTION A: BOOTSTRAP PROMPT

You are running **Bootstrap Mode** for the Archy v7.0 protocol. Your job is to scaffold a new project from zero. Follow these steps exactly.

### A.1 Preflight

1. **Check for existing Archy installation**:
   - If `.archy/archy-conductor.md` exists → v7 is already installed. Halt. Tell the user.
   - If `.archy/archy-protocol.md` exists AND it declares version 6.x → v6 project detected. Offer to run Section B (Migration) instead. Halt if user declines.
   - If neither exists → proceed.

2. **Detect environment**: Ask the user which CLI they use:
   - `claude-code` (Claude Code)
   - `gemini-cli` (Gemini CLI)
   - `both`

   Also ask the CLI version. Warn if below minimum:
   - Claude Code: minimum 2.0.0
   - Gemini CLI: minimum 0.8.0 (Gemini CLI's subagent spec is less stable — warn even on current versions that cross-agent delegation is restricted to the top-level Conductor pattern)

   Store as `ENV` and `ENV_VERSIONS` for later file generation.

3. **Detect project brief**:
   - Look for `./project-brief.md`, `./.archy/project-brief.md`, `./docs/project-brief.md`
   - If found → read and use it. Skip to A.3.
   - If not found → proceed to A.2 (interview).

### A.2 Interview (only if no brief exists)

Walk the user through the Project Brief template (Section C.2). Ask one question group at a time, not all at once. When complete, write the brief to `./docs/project-brief.md` using template C.2 and present it for confirmation before proceeding.

### A.3 Analyze Brief

Extract from the brief:

- **Tech stack decisions** → determines which skill files to scaffold (e.g., Next.js project → note that `next.js.md` skill should exist but start empty with just a format header)
- **Feature set** → determines initial specs for mission-control
- **Default Role** → e.g., "Senior Full-Stack Engineer (Node.js/React Focus)"
- **Environment capabilities** → Ask the user: "Does your environment have a Browser Subagent capability? Any other specialized tools?" Store as `CAPABILITIES`.
- **Git-Ops preferences** → Ask: "Do you want the runner script to auto-branch, auto-commit, auto-merge?" Default all to `true`. Store as `GIT_OPS`.

### A.4 Clarify Open Questions

If the brief has ambiguities (tech stack conflicts, unclear feature boundaries), ask the user. Do not assume.

### A.5 Generate Artifacts

Produce files in this order. Use templates from Section C and Section D (Part 2). Resolve all `{{#if env == 'X'}}` conditionals using the `ENV` value from A.1.

**Core (always):**

- `.archy/archy-protocol.md` — copy from the master repo
- `.archy/archy-conductor.md` — copy from the master repo
- `.archy/archy-templates.md` — copy from the master repo (this file)
- `.archy/base-prompt.md` — fill in template C.1 with project details, Default Role, env capabilities, Git-Ops preferences, and an empty Active Skills table (add `_project.md` as "Load when: always")
- `.archy/mission-control.md` — use template C.3; populate with initial specs derived from brief's feature list
- `.archy/specs/*.md` — one spec per identified P0/P1 feature, using the Architect's spec template (from Architect agent definition in Section D.1). Number sequentially (`00-`, `01-`, etc.)
- `.archy/skills/_project.md` — use template C.4, empty body with format header
- `.archy/skills/_candidates.md` — use template C.5, empty body with format header (session counter = 0)
- `.archy/skills/_archive.md` — use template C.6, empty body with format header (demotion counter = 0)
- `.archy/sessions.log` — empty file
- `.archy/archy-runner.sh` — use template from Section E, inject `GIT_OPS` values, `chmod +x`

**SOPs (optional):**

Ask the user: "Do you want starter SOPs (git workflow, code review)? These go in `./docs/sops/` and you can add/remove them anytime." If yes, copy sample files from the master repo's `sops/` directory into `./docs/sops/` and add them to base-prompt's Active SOPs table.

**Agent files (copy-paste):**

1. Copy the `.agents/` directory from the docs-to-code master repository directly to the project root directory.
2. If `ENV` includes `claude-code`:
   Copy the `.claude/` directory from the docs-to-code master repository directly to the project root directory.
3. If `ENV` includes `gemini-cli`:
   Copy the `.gemini/` directory from the docs-to-code master repository directly to the project root directory.
4. Copy the `.antigravity/` directory from the docs-to-code master repository directly to the project root directory (for Antigravity 2.0, IDE, and CLI support).

### A.6 Present Summary & Confirm

Before writing anything, show the user:

1. List of files to be created with one-line descriptions
2. Text-based dependency graph of initial specs
3. Estimated task count
4. Environment-specific notes (warnings if CLI versions are below minimum)

Ask for explicit approval. Wait.

### A.7 Write Files

Upon approval, create all files. Do NOT begin building — that's a separate command.

### A.8 Handoff

Output:

> ✅ **Bootstrap complete.** Your project is at Archy v7.0.
>
> **To plan a new feature**: Edit `.archy/base-prompt.md`, set `Target_Task: "Plan <feature>"`, then run `execute @.archy/base-prompt.md`.
>
> **To build the next queued spec**: Leave `Target_Task` empty in `.archy/base-prompt.md`, then run `execute @.archy/base-prompt.md`.
>
> **To review the queue**: Open `.archy/mission-control.md`.

Terminate.

---

## SECTION B: MIGRATION PROMPT

You are running **Migration Mode** to upgrade a project from Archy v6.1.x to v7.0. Follow these steps exactly.

### B.1 Preflight

You are being executed from the master `docs-to-code` repo's `archy-templates.md`, NOT from a project-local copy. The user has invoked you from inside their v6 project directory.

1. Verify project's `.archy/archy-protocol.md` exists and declares version 6.x. If not, halt and tell the user this isn't a v6 project.
2. Verify project's `.archy/archy-conductor.md` does NOT exist. If it does, v7 is already installed — halt and ask user to either reinstall from scratch or abort.
3. Locate your own file path (the master repo) so you can read sibling files (`archy-protocol.md` and `archy-conductor.md`) from there. Ask the user to confirm the master repo path if needed.
4. Read the existing project `.archy/base-prompt.md` entirely. Extract:
   - Project name, stack, repo URL
   - Default Role
   - Environment capabilities
   - Custom rules
   - Active Skills table entries
   - Git-Ops preferences (from runner script if present)

### B.2 Preserve Existing Work

The following files and directories are preserved **untouched**:

- `.archy/specs/` — all existing specs
- `.archy/skills/*.md` — all skill files including `_project.md`, `_candidates.md`, `_archive.md`
- `.archy/mission-control.md`
- `.archy/project-brief.md` or `./docs/project-brief.md`
- `.archy/sessions.log`
- `./docs/sops/` if present

### B.3 Archive v6 Artifacts

Create `.archy/.v6-backup/` in the project and move into it:

- `.archy/archy-protocol.md` (v6.x) — from the project
- `.archy/archy-templates.md` (v6.x) — from the project
- `.archy/base-prompt.md` — from the project (will be regenerated)
- `.agents/` (if present), `.antigravity/` (if present), `.claude/agents/archy-*.md` and/or `.gemini/agents/archy-*.md` — from the project

These are not deleted — they stay in `.v6-backup/` for reference. The user can remove the folder later if desired.

### B.4 Regenerate v7 Artifacts

Source files come from the master repo (wherever this `archy-templates.md` is located). Copy:

- Master's `archy-protocol.md` → project's `.archy/archy-protocol.md`
- Master's `archy-conductor.md` → project's `.archy/archy-conductor.md`
- Master's `archy-templates.md` (this file) → project's `.archy/archy-templates.md`
- Master's `.agents/` → project's `.agents/` (copy directory as-is)
- If old project had `.claude/agents/`:
  Master's `.claude/` → project's `.claude/` (copy directory as-is)
- If old project had `.gemini/agents/`:
  Master's `.gemini/` → project's `.gemini/` (copy directory as-is)
- Master's `.antigravity/` → project's `.antigravity/` (copy directory as-is)

Then, using extracted config from B.1 and templates from Section C of this file:

- Regenerate `.archy/base-prompt.md` from template C.1 using extracted project config. Preserve Target_Task (leave empty unless user specifies). Preserve Custom Rules verbatim. Preserve Active Skills table entries.
- Skill file headers — Optionally inject the v7 `FORMAT SPEC — DO NOT EDIT` comment block into existing skill files (_project.md,_candidates.md, _archive.md, stack skills). Content below the header is untouched. Ask the user before doing this — it's cosmetic, not required. If they decline, skip.

### B.5 Surface Items Needing Review

Some v6 configurations don't map cleanly to v7. Do NOT silently drop them. Instead, output a **Manual Review** list:

- Custom rules that referenced v6-specific concepts (e.g., named modes like "Mode A" or terminology like "Role Composition Rules") — list them and note they may need rewording for v7's Conductor-based structure
- Environment capabilities that don't fit v7's schema — list them
- Any unknown fields in the old base-prompt — list them

The user reviews this list and manually updates the new base-prompt as needed.

### B.6 Confirm Before Writing

Show the user:

1. Files to be archived to `.v6-backup/`
2. Files to be regenerated
3. Files left untouched
4. The Manual Review list

Ask for approval. Wait.

### B.7 Write Files

Upon approval, execute.

### B.8 Handoff

Output:

> ✅ **Migration to v7.0 complete.**
>
> - Your specs, skills, mission-control, and session history are untouched.
> - v6 files are archived at `.archy/.v6-backup/` for reference.
> - Review the Manual Review list above and update `.archy/base-prompt.md` if needed.
> - Run `execute @.archy/base-prompt.md` to continue with your next spec.

Terminate.

---

## SECTION C: ARTIFACT TEMPLATES

### C.1 Base-Prompt Template

```markdown
# ARCHY: SESSION LAUNCHER

**Protocol-Version**: 7.0.0
**Tested-With-Conductor**: 7.0.0

---

## Target_Task

{Leave empty for Builder Mode (next spec in queue).
Set to "Plan <feature>" for Architect Mode.
Set to "Fix <bug>" or "Refactor <thing>" for Maintenance Mode.}

---
## 🚀 YOUR ROLE

**You are the Conductor.** This file is your instruction set. You are NOT an implementation agent — you dispatch to specialized agents, parse their Structured Reports, and run the gate sequence.

Before doing anything else:

1. Load `@.archy/archy-protocol.md` — Iron Rules and glossary (shared invariants).
2. Load `@.archy/archy-conductor.md` — your full operational playbook (mode determination, Task Dossier assembly, gate sequence, role composition, auto-healing).

The conductor file is your behavior. The protocol is your constitution. Everything else in this file is project-specific configuration you consume to do your job.

If at any point in the session you find yourself writing code, running tests, or editing implementation files directly — stop. That's an agent's job. Dispatch instead.

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

### Code Style
- {e.g., Prettier + ESLint with Airbnb config}
- {e.g., Prefer named exports}

### Testing Strategy
- **Test command**: `{e.g., npm test}`
- **Build command**: `{e.g., npm run build}`
- **Lint command**: `{e.g., npm run lint}`
- {Additional notes about test framework, coverage expectations, E2E setup}

---

## Environment & Capabilities

{List any specialized tools available in this environment. The Conductor passes these to agents via the Task Dossier's `env_capabilities` field.}

- **Browser Subagent**: {e.g., Available. Use for UI verification on `localhost:3000`. Test responsiveness at 375/768/1440px.}
- **Terminal Integration**: Standard

---

## Active Skills

*The Conductor loads only skills whose "Load when..." hint matches the current task.*

| Skill | File | Load when... |
| ------- | ------ | -------------- |
| Project Quirks | `.archy/skills/_project.md` | Always |
| {skill name} | `.archy/skills/{file}.md` | {brief trigger description} |

---

## Active SOPs

*Plugin-style team conventions. Drop new files in `./docs/sops/` and register them here.*

| SOP | File | Load when... |
| ----- | ------ | -------------- |
| {e.g., Git Workflow} | `./docs/sops/git-workflow.md` | Always, or when merging |

*(Omit this section entirely if no SOPs are in use.)*

---

## Custom Rules (Optional)

{Project-specific rules that supplement the protocol. These take precedence over defaults but cannot contradict Iron Rules.}

- {e.g., All database migrations require review by @dba before merge.}

---

## Role Overrides (Optional)

{Per-mode role overrides. Omit the table if using Default Role throughout.}

| Mode | Role Override |
| ------ | --------------- |
| Architect | {e.g., System Architect + DBA} |
| Maintenance | {e.g., Security-Conscious Fixer} |
```

### C.2 Project Brief Template

```markdown
# Project Brief: {Project Name}

## 1. Vision

{One paragraph: What is this? Who is it for? What problem does it solve?}

---

## 2. Core Features

*Listed in priority order (P0 = must-have for v1, P1 = important, P2 = nice-to-have).*

- **P0**: {Feature 1} — {brief description}
- **P0**: {Feature 2} — {brief description}
- **P1**: {Feature 3} — {brief description}

---

## 3. Tech Stack

### Required
- **Runtime**: {e.g., Node.js 20}
- **Framework**: {e.g., Next.js 14}
- **Database**: {e.g., PostgreSQL}
- **ORM**: {e.g., Prisma}
- **Auth**: {e.g., NextAuth v5}
- **Hosting**: {e.g., Vercel + Railway}

### Optional
- **Cache**: {e.g., Redis}
- **Storage**: {e.g., S3}
- **Payments**: {e.g., Stripe}
- **Email**: {e.g., Resend}

### Open to Suggestions
{Areas where you'd like Archy's Architect to recommend options.}

---

## 4. Constraints

### Technical
- {e.g., Must work offline}

### Compliance & Security
- {e.g., HIPAA considerations}

### Integration
- {e.g., Must call existing legacy API at X}

### Timeline
- {e.g., MVP in 4 weeks, solo developer}

---

## 5. Out of Scope (v1)

- {e.g., Mobile app}
- {e.g., i18n}

---

## 6. User Roles

| Role | Description | Key Actions |
| ------ | ------------- | ------------- |
| {Admin} | {Platform owner} | {CRUD users, view analytics} |
| {Member} | {Regular user} | {Create projects, invite collaborators} |

---

## 7. Success Criteria

### Functional
- {e.g., User can sign up, verify email, log in}

### Non-Functional
- {e.g., 90% test coverage on core modules}
- {e.g., Page load < 2s on 3G}

---

## 8. Existing Assets

{Anything that already exists and should be incorporated.}

- {e.g., Legacy schema at `docs/legacy.sql`}
- {e.g., Figma designs at [link]}

---

## 9. Open Questions

{Unresolved decisions for the Architect to clarify.}

- {e.g., Server-side or client-side auth state?}
```

### C.3 Mission Control Template

```markdown
# 🚀 Mission Control

## Status Legend
- `[x]` — Completed & Verified
- `[ ]` — Queued (eligible when dependencies met)
- `[~]` — Skipped / Deprecated
- `[!]` — Blocked (needs user intervention)

---

## Execution Queue

<!--
  Dependencies are declared inline. Format:
  - [ ] .archy/specs/feature.md | Depends-On: [dep1.md, dep2.md]
  Omit Depends-On clause if no dependencies.
-->

- [ ] .archy/specs/00-initial-feature.md

## Blocked / Needs Attention

<!-- Items that cannot proceed without user intervention. -->
```

### C.4 Skill File Template

Used for stack-specific skill files (e.g., `nextjs.md`, `prisma.md`) and for `_project.md`. All skill files share this structure.

```markdown
# ARCHY SKILL: {Technology Name}

**Domain**: {e.g., Frontend Framework, ORM, Testing, Project-Specific}
**Version Target**: {e.g., v14.x — v15.x, or N/A for project skills}

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
<!-- 1-3 bullet points capturing the fundamental approach for this tech. Rarely changes. -->

- {e.g., Server Components by default, Client Components only when interactivity is needed}

---

## Lessons

<!-- Sorted by score desc. Housekeeper enforces sort on every lifecycle pass. -->

<!-- Example:
- [5 | 2026-03-15] App Router params changed in v15 — use `params` as Promise
- [3 | 2026-03-10] Use `next/dynamic` for client-only libs, not conditional rendering
-->
```

**Notes on `_project.md`**: Uses this template with Domain = "Project-Specific" and Version Target = "N/A". Always loaded (set "Load when: always" in base-prompt's Active Skills table).

### C.5 Candidates Buffer Template

```markdown
# Skill Candidates (Staging Buffer)

<!-- Session counter: 0 -->

<!--
  FORMAT SPEC — DO NOT EDIT:
  Staging area for unproven lessons. Entries start at score 1 on first sighting.
  Score increments on independent re-encounter across sessions (same session = 1 sighting max).
  Promotion: when score ≥ 3, Housekeeper moves the entry to the relevant skill file.
  Cap: 15 entries. Overflow demotes the lowest-score entry to `_archive.md`.
  Writers: Builder and Debugger (direct write on lesson extraction).
  Housekeeper reads this file only during lifecycle phase at session end.
  Session counter in the header above increments each time a Builder/Debugger session writes here.
-->

## Entries

| # | Lesson | Category | First Seen | Last Seen | Score | Origin |
| --- | -------- | ---------- | ------------ | ----------- | ------- | -------- |
```

### C.6 Archive Template

```markdown
# Skills Archive

<!-- Demotions since last audit: 0 -->

<!--
  FORMAT SPEC — DO NOT EDIT:
  Cold storage for demoted lessons. Writes by Housekeeper on cap overflow.
  Reads by Housekeeper ONLY during archive audit (triggered when the demotion counter above reaches 5).
  Human-reviewable safety net.

  Entry format:
  - [score | YYYY-MM-DD] Origin: {path or "candidates"} | Reason: {candidate-overflow | skill-cap | audit-merged}
    {Lesson description}

  Audit behavior (Housekeeper):
    - Group semantically similar entries
    - Sum scores within each group
    - Aggregates with combined score ≥ 3 → revive directly to the origin skill file (fall back to _project.md if origin file no longer exists)
    - Duplicate entries → merge with combined score
    - Reset demotion counter to 0
    - Max one audit per session
-->

## Archived Entries

<!-- No entries yet. -->
```

## SECTION D: AGENT TEMPLATES (DEPRECATED)

> [!NOTE]
> Section D has been deprecated and decoupled from this template file.
> The six specialized agents are now centralized in `.agents/` as permanent markdown prompt files, with tool-specific distal connectors in `.claude/agents/` and `.gemini/agents/`. This enables clean copy-paste bootstrapping and convenient visualization/editing.

## SECTION E: RUNNER SCRIPT TEMPLATE

The runner is generated at bootstrap but is **optional**. The primary Archy workflow is interactive: the user types `execute @.archy/base-prompt.md` in their CLI, one spec at a time, with manual PR review between sessions.

The runner exists for edge cases: CI pipelines, batch catch-up runs after a long break, or users who have high trust in their spec quality. It manages the outer autopilot loop, session logging, and Git-Ops.

### E.1 Script

Bootstrap generates this as `.archy/archy-runner.sh` and runs `chmod +x`:

```bash
#!/bin/bash
# .archy/archy-runner.sh
# Archy v7.0 autopilot runner — opt-in, interactive workflow is the norm.
#
# Usage:
#   ./.archy/archy-runner.sh              # Autopilot, max {{MAX_TASKS}} tasks
#   ./.archy/archy-runner.sh --dry-run    # Preview without executing
#   ./.archy/archy-runner.sh --max 5      # Override task limit
#
# Each AI session handles ONE spec and returns a Structured Report.
# This script drives the loop, parses reports, handles Git-Ops, and logs sessions.

set -euo pipefail

# ─── CLI Tool Configuration ──────────────────────────────────────────

AI_CMD='{{AI_CMD}}'                # e.g., gemini, claude
AI_PROMPT_FLAG='{{AI_PROMPT_FLAG}}' # e.g., --prompt (gemini), -p (claude)

# ─── Project Settings ────────────────────────────────────────────────

PROJECT_NAME="{{PROJECT_NAME}}"
ARCHY_DIR=".archy"
BASE_PROMPT="$ARCHY_DIR/base-prompt.md"
MISSION_CONTROL="$ARCHY_DIR/mission-control.md"
SESSION_LOG="$ARCHY_DIR/sessions.log"

# ─── Runner Limits ───────────────────────────────────────────────────

MAX_TASKS=7
PAUSE_BETWEEN=2
DRY_RUN=false

# ─── Git-Ops (default: all true; flip to false for manual control) ──

AUTO_GIT=true
AUTO_CREATE_BRANCH=true
AUTO_COMMIT=true
AUTO_MERGE=true
AUTO_DELETE_BRANCH=true

GIT_BASE_BRANCH="dev"
GIT_FEATURE_PREFIX="feature"
GIT_COMMIT_PREFIX="feat"

# ─── CLI Argument Parsing ────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run) DRY_RUN=true; shift ;;
    --max) MAX_TASKS="$2"; shift 2 ;;
    --help|-h)
      cat <<'HELP'
Usage: archy-runner.sh [OPTIONS]

Options:
  --dry-run    Preview mode — show what would run without executing
  --max N      Maximum tasks to execute (default: 7)
  --help       Show this help

Edit the top of this script to adjust AI_CMD, Git-Ops flags, and branch names.
HELP
      exit 0 ;;
    *) echo "Unknown option: $1"; echo "Run with --help for usage."; exit 1 ;;
  esac
done

# ─── Validate Environment ────────────────────────────────────────────

[ -f "$BASE_PROMPT" ] || { echo "❌ Base prompt not found: $BASE_PROMPT"; exit 1; }
[ -f "$MISSION_CONTROL" ] || { echo "❌ Mission control not found: $MISSION_CONTROL"; exit 1; }
command -v "$AI_CMD" &>/dev/null || { echo "❌ AI CLI not found: $AI_CMD"; exit 1; }

# ─── State ───────────────────────────────────────────────────────────

COMPLETED=0
FAILED=0
SESSION_NUM=0
START_TIME=$(date +%s)
touch "$SESSION_LOG"

# ─── Helpers ─────────────────────────────────────────────────────────

log_session() {
  local timestamp; timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  {
    echo ""
    echo "=== Session $SESSION_NUM | $timestamp ==="
    echo "$1"
  } >> "$SESSION_LOG"
}

get_next_spec() {
  local line
  line=$(grep -m 1 '^\- \[ \]' "$MISSION_CONTROL" || true)
  echo "$line" | sed -n 's/.*\([A-Za-z0-9._-]\+\.md\).*/\1/p'
}

git_is_ready() {
  [ "$AUTO_GIT" = true ] && command -v git &>/dev/null && [ -d ".git" ]
}

# Parse the YAML report block from session output.
# Returns the verdict via stdout, or empty string if not found.
extract_verdict() {
  local output="$1"
  echo "$output" | awk '
    /^```yaml/ { in_yaml=1; next }
    /^```/ && in_yaml { in_yaml=0; next }
    in_yaml && /^\s*verdict:/ {
      gsub(/^\s*verdict:\s*/, "")
      gsub(/\s*#.*$/, "")
      print
      exit
    }
  '
}

# ─── Header ──────────────────────────────────────────────────────────

cat <<HEADER
╔══════════════════════════════════════════════════╗
║  🚀 Archy Runner v7.0 — Autopilot                ║
║  Project: $PROJECT_NAME
║  Max Tasks: $MAX_TASKS
$([ "$DRY_RUN" = true ] && echo "║  ⚠️  DRY RUN — no execution                       ║")
╚══════════════════════════════════════════════════╝
HEADER
echo ""

# ─── Main Loop ───────────────────────────────────────────────────────

while [ "$COMPLETED" -lt "$MAX_TASKS" ]; do
  SESSION_NUM=$((SESSION_NUM + 1))

  PENDING=$(grep -c '^\- \[ \]' "$MISSION_CONTROL" 2>/dev/null || echo 0)
  BLOCKED=$(grep -c '^\- \[!\]' "$MISSION_CONTROL" 2>/dev/null || echo 0)
  DONE=$(grep -c '^\- \[x\]' "$MISSION_CONTROL" 2>/dev/null || echo 0)

  if [ "$PENDING" -eq 0 ]; then
    echo "✅ Queue empty."
    echo "📊 Completed: $COMPLETED | Failed: $FAILED | Done: $DONE | Blocked: $BLOCKED"
    log_session "QUEUE EMPTY — Completed: $COMPLETED, Failed: $FAILED"
    break
  fi

  echo "┌──────────────────────────────────────────"
  echo "│ 📋 Session $SESSION_NUM"
  echo "│ Pending: $PENDING | Done: $DONE | Blocked: $BLOCKED"
  echo "└──────────────────────────────────────────"

  SPEC_FILE=$(get_next_spec)
  SPEC_ID="${SPEC_FILE%.md}"
  FEATURE_BRANCH=""

  # Pre-session: create feature branch
  if git_is_ready && [ -n "$SPEC_ID" ] && [ "$AUTO_CREATE_BRANCH" = true ]; then
    git checkout "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
    git pull --ff-only origin "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
    FEATURE_BRANCH="$GIT_FEATURE_PREFIX/$SPEC_ID"
    if git show-ref --verify --quiet "refs/heads/$FEATURE_BRANCH"; then
      git checkout "$FEATURE_BRANCH" >/dev/null 2>&1
    else
      git checkout -b "$FEATURE_BRANCH" >/dev/null 2>&1
    fi
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "   🔍 [DRY RUN] Would execute: $AI_CMD $AI_PROMPT_FLAG \"execute @$BASE_PROMPT\""
    log_session "[DRY RUN] Would execute. Pending: $PENDING"
    COMPLETED=$((COMPLETED + 1))
    continue
  fi

  echo "   🔨 Launching AI session..."
  echo ""

  # Execute session with output capture
  SESSION_TMP=$(mktemp)
  if command -v script &>/dev/null; then
    script -q -e -c "$AI_CMD $AI_PROMPT_FLAG \"execute @$BASE_PROMPT\"" "$SESSION_TMP"
    EXIT_CODE=$?
    SESSION_OUTPUT=$(sed -E '/^Script (started|done) on/d' "$SESSION_TMP")
  else
    $AI_CMD $AI_PROMPT_FLAG "execute @$BASE_PROMPT" 2>&1 | tee "$SESSION_TMP"
    EXIT_CODE=${PIPESTATUS[0]}
    SESSION_OUTPUT=$(cat "$SESSION_TMP")
  fi
  rm -f "$SESSION_TMP"

  # Non-zero exit = infrastructure failure, not logical failure
  if [ "$EXIT_CODE" -ne 0 ]; then
    echo "   ⚠️  Session exited with error (code $EXIT_CODE)"
    FAILED=$((FAILED + 1))
    log_session "INFRASTRUCTURE FAILURE (exit $EXIT_CODE)"
    [ "$FAILED" -ge 3 ] && { echo "🛑 3 infrastructure failures. Halting."; exit 1; }
    sleep "$PAUSE_BETWEEN"
    continue
  fi

  log_session "$SESSION_OUTPUT"

  # Parse the structured report
  VERDICT=$(extract_verdict "$SESSION_OUTPUT")

  case "$VERDICT" in
    COMPLETE|PASS|FIXED)
      COMPLETED=$((COMPLETED + 1))
      FAILED=0
      echo "   ✅ Session verdict: $VERDICT"

      # Post-session: merge to base branch
      if git_is_ready && [ -n "$FEATURE_BRANCH" ] && [ "$AUTO_MERGE" = true ]; then
        git checkout "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
        git pull --ff-only origin "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
        if git merge --no-ff "$FEATURE_BRANCH" -m "merge: $SPEC_ID" >/dev/null 2>&1; then
          git push origin "$GIT_BASE_BRANCH" >/dev/null 2>&1 || true
          [ "$AUTO_DELETE_BRANCH" = true ] && git branch -d "$FEATURE_BRANCH" >/dev/null 2>&1 || true
        else
          echo "   ⚠️  Merge failed for $FEATURE_BRANCH → $GIT_BASE_BRANCH"
        fi
      fi
      ;;

    ESCALATE)
      FAILED=$((FAILED + 1))
      echo "   🛑 Session returned ESCALATE — halting autopilot for user input"
      log_session "ESCALATED — user intervention required"
      exit 2
      ;;

    FAIL)
      FAILED=$((FAILED + 1))
      echo "   ❌ Session returned FAIL — gate did not pass"
      [ "$FAILED" -ge 3 ] && { echo "🛑 3 failures. Halting."; exit 1; }
      ;;

    "")
      FAILED=$((FAILED + 1))
      echo "   ⚠️  Could not parse verdict from session output (malformed report?)"
      [ "$FAILED" -ge 3 ] && { echo "🛑 3 malformed sessions. Halting."; exit 1; }
      ;;

    *)
      FAILED=$((FAILED + 1))
      echo "   ⚠️  Unexpected verdict: $VERDICT"
      [ "$FAILED" -ge 3 ] && { echo "🛑 3 unexpected verdicts. Halting."; exit 1; }
      ;;
  esac

  echo ""
  sleep "$PAUSE_BETWEEN"
done

# ─── Summary ─────────────────────────────────────────────────────────

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
MIN=$((ELAPSED / 60))
SEC=$((ELAPSED % 60))

cat <<SUMMARY

╔══════════════════════════════════════════════════╗
║  🏁 Autopilot Complete                           ║
║  Completed: $COMPLETED
║  Failed: $FAILED
║  Elapsed: ${MIN}m ${SEC}s
║  Log: $SESSION_LOG
╚══════════════════════════════════════════════════╝
SUMMARY

log_session "RUN COMPLETE — Completed: $COMPLETED, Failed: $FAILED, Time: ${MIN}m ${SEC}s"
```

### E.2 Bootstrap Placeholder Resolution

At bootstrap, Section A resolves these placeholders:

| Placeholder | Source | Example |
| ------------- | -------- | --------- |
| `{{AI_CMD}}` | User's ENV choice | `gemini` / `claude` |
| `{{AI_PROMPT_FLAG}}` | User's ENV | `--prompt` / `-p` |
| `{{PROJECT_NAME}}` | Brief or user input | `PEX Platform` |
| `{{MAX_TASKS}}` | Default 7, user may override | `7` |

Git-Ops flags are hardcoded to `true` in the generated file per default. Users flip to `false` manually by editing the script if they want step-by-step control.

---

## SECTION F: TEMPLATE USAGE REFERENCE

| Template | Defined In | Used By | When |
| ---------- | ----------- | --------- | ------ |
| Spec File | Section D.1 (baked into Architect agent) | Architect | Every new spec |
| Base-Prompt | Section C.1 | Bootstrap, Migration | Project scaffolding |
| Project Brief | Section C.2 | Bootstrap (interview flow) | If brief doesn't exist at bootstrap |
| Mission Control | Section C.3 | Bootstrap | Initial queue scaffolding |
| Skill File | Section C.4 | Bootstrap (empty init), Housekeeper (on first promotion to new file) | Scaffolding + lifecycle |
| Candidates Buffer | Section C.5 | Bootstrap | Initial empty state |
| Archive | Section C.6 | Bootstrap | Initial empty state |
| Architect Agent | Section D.1 | Bootstrap | One-time agent install |
| Builder Agent | Section D.2 | Bootstrap | One-time agent install |
| Reviewer Agent | Section D.3 | Bootstrap | One-time agent install |
| Security Auditor Agent | Section D.4 | Bootstrap | One-time agent install |
| Housekeeper Agent | Section D.5 | Bootstrap | One-time agent install |
| Debugger Agent | Section D.6 | Bootstrap | One-time agent install |
| Runner Script | Section E.1 | Bootstrap | One-time, opt-in |

**Files this template does NOT generate** (user-authored, live in `./docs/`):

- `./docs/project-brief.md` — conceptually templated here but lives outside `.archy/`
- `./docs/sops/*.md` — plugin-style, users bring their own or copy samples from master repo

---

## VERSION HISTORY

| Version | Date | Changes |
| --------- | ------ | --------- |
| 7.0.0 | 2026-04-18 | Initial v7 release. Unified template file with dispatcher for Bootstrap/Migration prompts. Agent templates consolidated with `{{#if env}}` conditionals instead of separate Claude/Gemini file sets. Self-documenting format headers embedded in skill files. SOPs and project-brief moved to `./docs/`. Git-Ops defaults flipped to true. Runner updated to parse Structured Report YAML verdicts instead of grepping prose. |

---

*Archy Templates v7.0 — End of templates file.*
