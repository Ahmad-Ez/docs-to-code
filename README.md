# 🤖 Docs-to-Code (Archy Protocol) (v6.1) — "Earned Knowledge"

Docs-to-Code: A spec-locked, autonomous AI software engineering protocol with continuous learning, environment awareness, and Git-Ops automation.

---

## ⚡ Quick Start (TL;DR)

```bash
# 1. Copy protocol files into your project
mkdir .archy
cp ~/docs-to-code/.archy/archy-protocol.md .archy/
cp ~/docs-to-code/.archy/archy-templates.md .archy/

# 2a. If you have a project brief:
gemini "Read @.archy/archy-protocol.md and bootstrap this project based on @project-brief.md"
# Or with Claude Code:
# claude "Read @.archy/archy-protocol.md and bootstrap this project based on @project-brief.md"

# 2b. If you don't have a brief yet:
gemini "Read @.archy/archy-protocol.md and bootstrap this project"

# 3. After bootstrap, run autopilot (single task per session):
gemini "execute @.archy/base-prompt.md"

# 4. Or use the Git-Ops runner for full hands-off autopilot:
./.archy/archy-runner.sh

```

---

## 🚀 What's New in V6.1?

V6.1 introduces a **skill lifecycle system** — lessons now earn their place through repeated evidence instead of single-pass judgment.

1. **Candidates Buffer**: New lessons land in a staging area (`_candidates.md`) at score 1. Score increments on independent re-encounter across sessions. Only lessons with score ≥ 3 promote to a skill file. This filters signal from noise.
2. **Project Skill File**: `_project.md` replaces the old "System & Prompting Quirks" section in base-prompt. Project-specific lessons now follow the same lifecycle rules as all other skills — unified system, no special cases.
3. **Score-Sorted Skills**: Entries in skill files use `[score | last_seen]` format, sorted by score descending. When a file exceeds its 25-entry cap, the lowest-score entries are demoted.
4. **Human-Only Archive**: Demoted lessons go to `_archive.md`. The AI writes to it but never reads it during normal operation — it's a human-reviewable safety net.
5. **Demotion-Triggered Archive Audit**: Every 5th demotion triggers an audit routine. The AI scans the archive for recurring patterns (lessons that keep getting independently rediscovered), sums their scores, and revives worthy ones. Self-regulating frequency — active projects audit more often.
6. **User Correction Fast-Track**: Explicit corrections ("don't do X", "use Y instead") bypass the buffer entirely and promote directly to skill files. High-confidence signals shouldn't wait.
7. **Housekeeper Subagent**: Skill lifecycle management (promotions, cap enforcement, demotions, archive audits) is delegated to a dedicated `archy-housekeeper` subagent at session end. Falls back to inline execution in single-agent environments.

For the design rationale behind these decisions, see [docs/memory-strategies.md](docs/memory-strategies.md).

### V6.1.1–6.1.4 (Point Releases)

1. **Fix-All Severities** *(6.1.4)*: The reviewer fix loop now triggers on ANY issue — HIGH, MEDIUM, or LOW. Builder re-runs until the reviewer returns PASS with zero issues.
2. **Housekeeper Commit Gate** *(6.1.3)*: The housekeeper must commit and push its skill lifecycle changes before reporting completion. The parent orchestrator waits for that commit+push confirmation before creating the PR. Housekeeper agent gains `Bash` tool for git operations.
3. **DRY Base-Prompt** *(6.1.2)*: Removed duplicated operational logic from base-prompt (subagent delegation, workflow gates, mode determination, session handoff). The protocol is now the single source of truth for all runtime behavior. Base-prompt provides project-specific configuration only.
4. **SOPs Template** *(6.1.2)*: New Template 5.10 generates a `.archy/SOPs.md` file during Bootstrap, encoding repo-agnostic git workflow conventions (branching strategy, merge methods, PR requirements). Referenced from base-prompt's Custom Rules section.
5. **PR Gate** *(6.1.1)*: Builder sessions end at push — no PR created. The parent orchestrator owns the full gate sequence: spec-reviewer → fix loop until PASS → housekeeper → PR creation. Applies to both subagent and inline execution.

### V6.0 (Previous)

1. **Subagent Delegation (Optional)**: Builder, Architect, and Reviewer modes can now be delegated to specialized subagents.
2. **Conditional Skill Loading**: Base-prompt contains a menu with "Load when..." hints.
3. **Claude Code Agent Templates**: Bootstrap generates `.claude/agents/` definitions when environment is Claude Code.

---

## 🧭 Table of Contents

* [Philosophy](#philosophy)
* [Repository Contents](#repository-contents)
* [Installation](#installation)
* [The Skills Architecture (Memory)](#the-skills-architecture-memory)
* [Memory Strategies (Design Rationale)](docs/memory-strategies.md)
* [Autonomous Git-Ops (Runner)](#autonomous-git-ops-runner)
* [Subagent Delegation](#subagent-delegation)
* [Modes Overview](#modes-overview)
* [Usage Guide](#usage-guide)
* [The Role System](#the-role-system)
* [Directory Structure](#directory-structure)
* [FAQ](#faq)

---

## Philosophy

> **"Docs-Driven Development meets Continuous Learning."**

* The AI never writes code without a **Spec**.
* The Spec never gets written without a **Plan**.
* The Plan never gets created without a **Brief**.
* A task is never finished without extracting **Lessons Learned**.

The user focuses on **strategy** (what to build and why). Archy handles **tactics** (how to build it, in what order, verifying it works, and saving the knowledge for next time).

---

## Repository Contents

This is the `docs-to-code` root repo. It contains only what needs to be portable:

```text
docs-to-code/
├── .archy/
│   ├── archy-protocol.md     # 🧠 The Constitution — runtime rules, skill lifecycle, continuous learning
│   └── archy-templates.md    # 📐 Templates — specs, queues, base-prompt, skills, candidates, archive, agents, runner, SOPs
├── docs/
│   └── memory-strategies.md  # 📝 Design rationale — strategies explored, trade-offs, why this approach
├── README.md                 # 📖 This file

```

---

## Installation

### Option A: Symlink (Recommended for Protocol)

Symlink the core rules so updating `docs-to-code` updates all your projects simultaneously.

```bash
mkdir -p your-project/.archy
ln -s ~/docs-to-code/.archy/archy-protocol.md your-project/.archy/archy-protocol.md
ln -s ~/docs-to-code/.archy/archy-templates.md your-project/.archy/archy-templates.md

```

### Option B: Copy (Independent)

```bash
mkdir -p your-project/.archy
cp ~/docs-to-code/.archy/archy-protocol.md your-project/.archy/
cp ~/docs-to-code/.archy/archy-templates.md your-project/.archy/

```

**Note on Skills:** Always *copy* the relevant `.archy/skills/*.md` files into your new project during Bootstrap so Archy has local access to stack knowledge.

---

## The Skills Architecture (Memory)

Since V6.1, Archy uses a **lifecycle-based skill system** where lessons earn their place through repeated evidence. Knowledge flows through four tiers:

```text
CANDIDATES (_candidates.md)     → Staging area. Score starts at 1, increments on re-encounter.
    ↓ promote (score ≥ 3)           Expires after 10 sessions unseen. Max 15 entries.
SKILL FILES (skills/*.md)       → Proven lessons. Score-sorted, max 25 per file.
    ↓ demote (cap overflow)         Includes _project.md (always loaded) for project-specific lessons.
ARCHIVE (_archive.md)           → Cold storage. AI writes, never reads (except during audit).
    ↑ revive (audit finds pattern)  Human-reviewable safety net.
```

**Conditional Loading:** The base-prompt contains a menu table with "Load when..." hints. The AI loads only relevant skill files per task.

 | Skill | File | Load when... |
 | ----- | ---- | ------------ |
 | Project Quirks | `@.archy/skills/_project.md` | Always |
 | React | `@.archy/skills/react-components.md` | Component, JSX, hydration |

**User corrections** ("don't do X", "use Y instead") bypass the buffer and promote directly to skill files — high-confidence signals shouldn't wait.

**Archive Audit:** Every 5th demotion triggers an audit. The AI scans the archive for recurring patterns, sums scores of similar entries, and revives aggregates with score ≥ 3. This catches lessons that keep getting independently rediscovered.

**The Sync Loop:** When Archy learns a generic stack lesson, it flags it in the Session Summary with `[FLAG: Sync upstream...]`. You then copy that lesson back to the master `docs-to-code/skills/` repo so all future projects inherit it.

For the full design rationale (strategies explored, trade-offs, why we chose this approach), see [docs/memory-strategies.md](docs/memory-strategies.md).

---

## Autonomous Git-Ops (Runner)

The runner (`archy-runner.sh`) is generated during Bootstrap. It isolates every task into a fresh AI context window.

Edit the top of the script to configure it:

```bash
AI_CMD='gemini'              # e.g., gemini, claude, aider, cursor
AUTO_GIT=true                # Enable Git-Ops
AUTO_CREATE_BRANCH=true      # Auto-branch from dev (feature/spec-id)
AUTO_COMMIT=true             # Auto-commit on pass
AUTO_MERGE=false             # Push for human PR review

```

**Usage:**

```bash
./.archy/archy-runner.sh              # Normal autopilot
./.archy/archy-runner.sh --dry-run    # Preview what will run
./.archy/archy-runner.sh --max 5      # Limit to 5 tasks

```

---

## Subagent Delegation

When using AI tools that support subagents (e.g., Claude Code with `.claude/agents/`), Archy can delegate each mode to a specialized agent:

| Mode | Agent File | Behavior |
| ------ | ---------- | -------- |
| ARCHITECT | `.claude/agents/archy-architect.md` | Plans features, creates specs |
| BUILDER | `.claude/agents/archy-builder.md` | Executes one spec with TDD |
| REVIEWER | `.claude/agents/spec-reviewer.md` | Verifies implementation against spec |
| HOUSEKEEPER | `.claude/agents/archy-housekeeper.md` | Skill lifecycle: promotions, caps, demotions, archive audits |
| MAINTENANCE | *(none)* | Always inline — scope too varied |

**This is optional.** If no subagents are available (Gemini CLI, Aider, etc.), all modes execute inline as before. The base-prompt's System Logic section handles this with an if/else fallback.

During Bootstrap, Archy generates these agent files automatically when it detects Claude Code as the environment.

---

## Modes Overview

| Mode | Trigger | Responsibility |
| --- | --- | --- |
| 🏗️ **BOOTSTRAP** | No `base-prompt.md` exists | Scaffolds project, queries IDE capabilities, loads Skills |
| 👷 **BUILDER** | Empty `Target_Task` + pending items | Executes specs: TDD → Verify via Subagents → Check Box → Extract Lessons |
| 📐 **ARCHITECT** | `Target_Task = "Plan X"` | Interviews user → creates specs → updates mission-control |
| 🔧 **MAINTENANCE** | `Target_Task = "Fix X"` | Fixes bugs → updates legacy specs → extracts lessons |

---

## Usage Guide

### 1. Architect Mode (Planning)

Set your goal in `base-prompt.md`:

```markdown
## Target_Task
Plan the Stripe webhook integration

```

Run `gemini "execute @.archy/base-prompt.md"`. Archy will ask you questions, write the specs, and update the queue.

### 2. Builder Mode (Autopilot)

Clear the `Target_Task` in `base-prompt.md`.
Run `gemini "execute @.archy/base-prompt.md"`. Archy will find the first unblocked task in the queue, build it, test it, and update the checklist.

### 3. Maintenance Mode (Refactoring)

Set your goal in `base-prompt.md`:

```markdown
## Target_Task
Refactor the auth middleware to use Zod schemas

```

Run the prompt. Archy will fix the code and retroactively update the old specs to match reality.

---

## The Role System

Archy dynamically shifts personas based on the task:

| Relationship | Behavior | Example |
| --- | --- | --- |
| **Specialization** | Spec replaces base | base="Backend Engineer", spec="DBA" → DBA |
| **Orthogonal** | Roles merge | base="Backend Engineer", spec="Security Auditor" → both |
| **Conflict** | Spec wins | base="Move Fast", spec="Security-First" → Security-First |

Force a role in a spec file:

* `Role: =DBA` (Ignore base prompt, use only DBA)
* `Role: +Security` (Merge with base prompt)

---

## Directory Structure

After bootstrap, your project will look like this:

```text
my-project/
├── .archy/
│   ├── archy-protocol.md       # Immutable Constitution
│   ├── archy-templates.md      # On-demand Templates
│   ├── base-prompt.md          # 🚀 Mission Launcher & Capabilities
│   ├── mission-control.md      # 📋 Execution Queue
│   ├── archy-runner.sh         # 🔄 Git-Ops Autopilot Loop
│   ├── sessions.log            # Audit Trail
│   ├── SOPs.md                 # Git Workflow conventions
│   ├── skills/                 # Skill Lifecycle System
│   │   ├── _project.md         # Project-specific lessons (always loaded)
│   │   ├── _candidates.md      # Staging buffer (read at session end only)
│   │   ├── _archive.md         # Cold storage (human-reviewable)
│   │   └── nextjs-app-router.md
│   └── specs/                  # The Blueprints
│       ├── 00-db-schema.md
│       └── 01-auth-api.md
├── .claude/                    # Claude Code only (optional)
│   └── agents/
│       ├── archy-architect.md
│       ├── archy-builder.md
│       ├── spec-reviewer.md
│       └── archy-housekeeper.md
├── src/
└── package.json

```

---

## FAQ

**Can I use Archy with Claude Code, Gemini CLI, or Aider?**
Yes. Archy is a markdown-based protocol that works with any AI tool. Update `AI_CMD` in `archy-runner.sh` to match your CLI. Claude Code users get bonus features: native subagent delegation via `.claude/agents/` files generated during Bootstrap.

**How does Archy know how to use my IDE's browser subagent?**
During Bootstrap, Archy asks about your environment. It injects the `Environment & Capabilities` block into your `base-prompt.md`. Builder Mode reads this and incorporates it into the Verification phase.

**What if the AI ignores the protocol?**
Re-anchor it. Start your prompt with: `Read and strictly follow @.archy/archy-protocol.md before doing anything.`

**How do I handle circular dependencies in the queue?**
Archy detects them and halts automatically. You must manually resolve the `Depends-On` declarations in `mission-control.md`.

### Can I have multiple projects sharing the same protocol?

Yes — that's the design. Symlink `archy-protocol.md` and `archy-templates.md` from a central `docs-to-code` repo. Each project gets its own `base-prompt.md`, `mission-control.md`, `specs/`, and runner scripts.

### What if I want to change the protocol for one project only?

Copy instead of symlink. Then edit the copy freely. But consider putting project-specific rules in `base-prompt.md` first — that's what it's for.

### How do I add a feature mid-project?

Set `Target_Task = "Plan [feature name]"` in `base-prompt.md` and run. Architect Mode will interview you, create specs, and update mission-control with proper dependency declarations.

### How do I skip a task?

Mark it as `[~]` in `mission-control.md`. Builder Mode will skip it.

### What if specs get out of sync with code?

Maintenance Mode detects stale specs and flags them. You can also manually trigger: `Target_Task = "Audit specs against codebase"`.

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 6.1.4 | 2026-04-07 | **Fix-All Severities**: Reviewer fix loop triggers on ANY issue (HIGH, MEDIUM, or LOW). Builder re-runs until reviewer returns PASS with zero issues. |
| 6.1.3 | 2026-03-27 | **Housekeeper Commit Gate**: Housekeeper must commit+push skill lifecycle changes before reporting completion. Orchestrator waits for confirmation before creating PR. Housekeeper gains `Bash` tool. |
| 6.1.2 | 2026-03-26 | **DRY Base-Prompt**: Removed duplicated operational logic from base-prompt. Protocol is now the single source of truth. Added SOPs template (5.10) and SOPs reference in base-prompt. |
| 6.1.1 | 2026-03-25 | **PR Gate**: Builder ends at push (no PR). Parent orchestrator owns: spec-reviewer → fix loop → housekeeper → PR. |
| 6.1.0 | 2026-03-18 | **"Earned Knowledge"**: Skill lifecycle system — candidates buffer, frequency-based promotion, project skill file, score-sorted demotion, human-only archive with audit routine, user correction fast-track. |
| 6.0.0 | 2026-03-09 | **"Delegation & Discipline"**: Subagent delegation (optional), conditional skill loading, quirks cap, Claude Code agent templates. |
| 5.0.0 | 2026-02-27 | **"Integration & Memory"**: Introduced Autonomous Git-Ops Runner, IDE/Environment Capability extraction, and the Active Skills plugin system. |
| 4.1.0 | 2026-02-10 | Role Composition, Auto-Healing, split templates, runner generation. |
| 4.0.0 | — | Initial "Mission Control" queue architecture. |

---

## Keywords

AI agent, autonomous software engineering, spec-driven development, docs-driven development, TDD, mission control, task queue, Gemini CLI, prompt protocol, Claude Code, subagents, conditional loading

---

## Credits

Archy is a concept by **Ahmad Ez**.

*Docs-to-Code (Archy Protocol) v6.1 — "Earned Knowledge"*
*Designed for full automation with strategic human oversight.*

---

## License

This project is open source. Use it, fork it, improve it.
If you build something cool with it, let me know.
