# 🤖 Docs-to-Code (Archy Protocol) (v4.1) — "Mission Control"

Docs-to-Code: Spec-locked, mission-control protocol for autonomous AI software engineering.

---

## ⚡ Quick Start (TL;DR)

```bash
# 1. Copy protocol files into your project
mkdir .archy
cp ~/docs-to-code/archy-protocol.md .archy/
cp ~/docs-to-code/archy-templates.md .archy/

# 2a. If you have a project brief:
gemini "Read @.archy/archy-protocol.md and bootstrap this project based on @project-brief.md"

# 2b. If you don't have a brief yet:
gemini "Read @.archy/archy-protocol.md and bootstrap this project"

# 3. After bootstrap, run autopilot (single task per session):
gemini "execute @.archy/base-prompt.md"

# 4. Or use the runner for full hands-off autopilot:
./.archy/archy-runner.sh
```

That's it. Archy will generate your base-prompt, specs, mission-control, and a runner script, then build your project task by task — one fresh session per spec.

---

## 🧭 Table of Contents

- [What is Archy?](#what-is-archy)
- [Philosophy](#philosophy)
- [Repository Contents](#repository-contents)
- [Installation](#installation)
- [Usage](#usage)
  - [Bootstrap (First Run)](#bootstrap-first-run)
  - [Builder Mode (Autopilot)](#builder-mode-autopilot)
  - [Architect Mode (Planning)](#architect-mode-planning)
  - [Maintenance Mode (Fixes & Refactors)](#maintenance-mode-fixes--refactors)
  - [The Runner (Full Autopilot)](#the-runner-full-autopilot)
- [Modes Overview](#modes-overview)
- [Session Boundaries](#session-boundaries)
- [The Role System](#the-role-system)
- [Directory Structure](#directory-structure)
- [Configuration & Customization](#configuration--customization)
- [The Iron Rules](#the-iron-rules)
- [Auto-Healing Behaviors](#auto-healing-behaviors)
- [Context Efficiency](#context-efficiency)
- [FAQ](#faq)
- [Version History](#version-history)

---

## What is Archy?

Archy is a **drop-in AI protocol** that turns any CLI-based AI assistant (Gemini CLI, Claude, etc.) into an autonomous Lead Software Engineer with project management capabilities.

It decouples **Planning** (Architect) from **Execution** (Builder) using a file-based state system — no databases, no servers, just markdown files that live in your repo.

---

## Philosophy

> **"Docs-Driven Development."**

- The AI never writes code without a **Spec**.
- The Spec never gets written without a **Plan**.
- The Plan never gets created without a **Brief**.

The user focuses on **strategy** (what to build and why). Archy handles **tactics** (how to build it, in what order, and verifying it works).

---

## Repository Contents

This is the `docs-to-code` repo. It contains only what needs to be portable:

```
docs-to-code/
├── archy-protocol.md     # 🧠 The Constitution — runtime rules, modes, role system
├── archy-templates.md     # 📐 Templates — spec, mission-control, base-prompt, project brief, runner
└── README.md              # 📖 This file
```

These two `.md` files are designed to be **copied or symlinked** into any project.

---

## Installation

### Option A: Copy (Independent per project)

```bash
mkdir -p your-project/.archy
cp archy-protocol.md your-project/.archy/
cp archy-templates.md your-project/.archy/
```

### Option B: Symlink (Shared across projects)

```bash
mkdir -p your-project/.archy
ln -s ~/docs-to-code/archy-protocol.md your-project/.archy/archy-protocol.md
ln -s ~/docs-to-code/archy-templates.md your-project/.archy/archy-templates.md
```

With symlinks, updating `docs-to-code` updates all projects simultaneously. See [Context Efficiency](#context-efficiency) for trade-offs.

---

## Usage

### Bootstrap (First Run)

Bootstrap is triggered automatically when Archy detects no `base-prompt.md` or `mission-control.md` in `.archy/`.

**With an existing project brief:**

```bash
gemini "Read @.archy/archy-protocol.md and bootstrap this project based on @project-brief.md"
```

**Without a brief (guided interview):**

```bash
gemini "Read @.archy/archy-protocol.md and bootstrap this project"
```

Archy will interview you, then generate:

- `.archy/project-brief.md` (if created from interview)
- `.archy/base-prompt.md` (customized to your project)
- `.archy/specs/*.md` (one per identified task)
- `.archy/mission-control.md` (dependency-ordered queue)
- `.archy/archy-runner.sh` (autopilot loop script)
- `.archy/runner-config.sh` (runner configuration)
- `.archy/sessions.log` (empty, for session audit trail)

All files are presented for your approval before being written.

---

### Builder Mode (Autopilot)

The default mode. Picks the next eligible task and builds it.

```bash
gemini "execute @.archy/base-prompt.md"
```

**What happens:**

1. Reads `mission-control.md`
2. Parses `Depends-On` declarations and builds an implicit dependency graph
3. Finds the first `[ ]` item with all dependencies satisfied (`[x]`)
4. Loads the referenced spec file
5. Resolves the session Role (see [The Role System](#the-role-system))
6. Writes tests first (TDD)
7. Implements the code
8. Runs verification
9. Marks checkboxes in spec, then marks `[x]` in mission-control
10. Outputs a **Session Summary** and terminates

Each session executes **exactly one spec**, then exits. This prevents context saturation and hallucination accumulation.

---

### Architect Mode (Planning)

For planning new features or milestones.

Edit `base-prompt.md` and set:

```markdown
## Target_Task
Plan the user referral system
```

Then run:

```bash
gemini "execute @.archy/base-prompt.md"
```

**What happens:**

1. Interviews you for requirements and edge cases
2. Creates new spec file(s) in `.archy/specs/`
3. Appends them to `mission-control.md` with dependency declarations
4. Generates prerequisite specs if dependencies don't yet exist
5. Suggests base-prompt updates if project conventions change

---

### Maintenance Mode (Fixes & Refactors)

For bug fixes, refactors, or doc updates.

Edit `base-prompt.md` and set:

```markdown
## Target_Task
Fix the CORS error in app.ts
```

Then run:

```bash
gemini "execute @.archy/base-prompt.md"
```

**What happens:**

1. Traces the bug to the original spec
2. Applies the fix using TDD
3. Updates the spec to reflect new logic (retroactive documentation)
4. Flags stale specs if implementation has drifted significantly
5. Does NOT mark mission-control items unless explicitly told to

---

### The Runner (Full Autopilot)

The runner is an external shell script that manages the loop across fresh AI sessions. It is generated during Bootstrap.

```bash
# Normal autopilot
./.archy/archy-runner.sh

# Preview mode (no execution)
./.archy/archy-runner.sh --dry-run

# Limit to 10 tasks
./.archy/archy-runner.sh --max 10
```

**What happens:**

1. Launches one AI session per task in a fresh context
2. The AI handles ONE spec, outputs a Session Summary, and exits
3. The runner parses the result, logs it to `sessions.log`, and decides whether to continue
4. Halts after 3 consecutive failures

**Configuration** is in `.archy/runner-config.sh` — set your AI CLI tool, project name, rate limiting, and safety limits there.

---

## Modes Overview

| Mode | Trigger | Responsibility |
|------|---------|----------------|
| 🏗️ **BOOTSTRAP** | No `base-prompt.md` or `mission-control.md` exists | Scaffolds entire project from brief or interview |
| 👷 **BUILDER** | Empty `Target_Task` + pending items in queue | Executes specs: writes tests → code → verifies → checks box |
| 📐 **ARCHITECT** | `Target_Task = "Plan X"` or empty queue | Interviews user → creates specs → updates mission-control |
| 🔧 **MAINTENANCE** | `Target_Task = "Fix/Change X"` | Fixes bugs → refactors → updates legacy specs |

---

## Session Boundaries

### One Task Per Session

Each Builder Mode session executes **exactly ONE spec** from the mission-control queue. This is a core design principle, not a limitation.

### Session Contract

At the end of every Builder session, the AI outputs:

```
--- SESSION SUMMARY ---
Task: {spec filename}
Status: COMPLETED | FAILED | ESCALATED
Files Changed: {list}
Tests: PASS | FAIL (attempt {n}/3)
Next Eligible Task: {spec filename or "QUEUE EMPTY"}
---
```

### Why

- Fresh context per task prevents hallucination accumulation
- Each session loads only the protocol + base-prompt + one spec
- The external runner manages the loop, context clearing, and failure handling
- Session summaries are appended to `.archy/sessions.log` for audit trail

---

## The Role System

Archy supports a flexible role system that adapts per-task.

### Role Hierarchy (Highest to Lowest Priority)

1. **Explicit Target_Task override** — inline role in the task
2. **Spec file `Role:` field** — task-specific expertise
3. **`base-prompt.md` default role** — project-wide persona
4. **Protocol fallback** — "Senior Software Engineer"

### Role Composition

When roles from different levels coexist:

| Relationship | Behavior | Example |
|-------------|----------|---------|
| **Specialization** | Spec replaces base | base="Backend Engineer", spec="DBA" → DBA |
| **Orthogonal** | Roles merge | base="Backend Engineer", spec="Security Auditor" → both |
| **Conflict** | Spec wins + warning logged | base="Move Fast", spec="Security-First" → Security-First |

### Manual Override Syntax (in spec files)

| Syntax | Behavior |
|--------|----------|
| `Role: DBA` | Auto-determine (specialization/merge/conflict) |
| `Role: =DBA` | Force replace — ignore base-prompt role |
| `Role: +Security Auditor` | Force merge — add to base-prompt role |

Spec roles apply **only** during that spec's execution. The session reverts to the base-prompt role afterward.

---

## Directory Structure

After bootstrap, your project will look like this:

```
my-project/
├── .archy/
│   ├── archy-protocol.md      # 🧠 The Constitution (symlinked or copied)
│   ├── archy-templates.md      # 📐 Templates (symlinked or copied)
│   ├── base-prompt.md          # 🚀 The Entry Point (project-specific, generated)
│   ├── mission-control.md      # 📋 The Queue (dependency-ordered)
│   ├── project-brief.md        # 📝 The Brief (if generated from interview)
│   ├── archy-runner.sh         # 🔄 The Autopilot Loop (generated, executable)
│   ├── runner-config.sh        # ⚙️ Runner Configuration (generated)
│   ├── sessions.log            # 📊 Session Audit Trail
│   └── specs/                  # 📂 The Blueprints
│       ├── 00-project-init.md
│       ├── 01-database-schema.md
│       ├── 02-auth-setup.md
│       └── ...
├── src/
├── tests/
├── package.json
└── ...
```

---

## Configuration & Customization

### base-prompt.md (Project-Level)

This is your main customization surface. After bootstrap, edit it to:

- Change the default **Role** and **Tone**
- Define **Stack Conventions** (e.g., "All API routes in `app/api/`")
- Set **Code Style** rules (e.g., "Prettier + ESLint with Airbnb config")
- Configure **Testing Strategy** and test command
- Add **Custom Rules** that supplement the protocol
- Override roles per mode
- Append to **Lessons Learned** (with user approval)

Example:

```markdown
## Default Role
Senior Rust Systems Engineer
**Capabilities**: Memory Safety, Zero-Cost Abstractions, Systems Programming
**Tone**: Precise, Technical, Safety-Conscious

## Project Archetype
### Stack Conventions
- All unsafe blocks must have a `// SAFETY:` comment
- Prefer `thiserror` over manual `impl Display for Error`
- Use `tokio` for all async runtime needs

### Testing Strategy
- Test command: `cargo test`
- Property-based testing with `proptest` for core algorithms
```

### runner-config.sh (Runner-Level)

Configure your AI CLI tool, rate limiting, and safety limits:

```bash
AI_CMD='gemini'           # Your AI CLI tool
AI_PROMPT_FLAG='--prompt'  # How it accepts prompts
MAX_TASKS=7              # Safety limit per run
PAUSE_BETWEEN=2           # Seconds between sessions
DRY_RUN=false             # Preview mode
```

Supports Gemini CLI, Claude Code CLI, Aider, or any custom tool.

### Spec Files (Task-Level)

Each spec can override the session role:

```markdown
## META
Role: =DBA
Depends-On: [00-project-init.md]
```

### Protocol File (Global — Do Not Edit via AI)

The protocol is designed to be **stable and generic**. It should not need per-project changes. If you find yourself wanting to edit it:

- **Project-specific rules** → put them in `base-prompt.md` under Custom Rules
- **Task-specific behavior** → put it in the spec file
- **Genuine protocol improvement** → edit manually in `docs-to-code`, all symlinked projects benefit

---

## The Iron Rules

Defined in `archy-protocol.md`, these are non-negotiable:

1. **Double Check** — Verify logic/code before outputting
2. **No Sugar-Coating** — Be objective, state risks clearly
3. **Filesystem is Truth** — Trust actual code over the plan
4. **Brief vs. Elaborate** — Respect the user's requested verbosity
5. **Spec-Lock** — No implementation without a detailed Spec
6. **Protocol Immutability** — AI cannot modify the protocol file; suggest changes to the user

---

## Auto-Healing Behaviors

Archy includes built-in recovery mechanisms:

| Condition | Action |
|-----------|--------|
| Spec references non-existent file | Triggers Architect Mode to create missing spec |
| Test fails 3 consecutive times | HALTs, provides diagnostic summary, asks user for guidance |
| Spec appears stale vs. codebase | Flags in output, suggests Maintenance Mode review |
| Circular dependency in mission-control | HALTs, displays cycle, asks user to resolve |
| Ambiguous or vague spec | HALTs Builder, switches to Architect to refine |
| Missing `base-prompt.md` or `mission-control.md` | Triggers Bootstrap Mode |

---

## Context Efficiency

Archy is designed to minimize AI context window consumption:

| File | Loaded When | Approx Weight |
|------|------------|---------------|
| `archy-protocol.md` | Every session (via base-prompt) | ~1500 tokens |
| `archy-templates.md` | Bootstrap & Architect only | ~1500 tokens |
| `base-prompt.md` | Every session (entry point) | ~500 tokens |
| `mission-control.md` | Every session (queue check) | Varies |
| `specs/*.md` | Only the active task's spec | Varies |

**Key design decisions for context efficiency:**

- Templates split into a separate file — not loaded during Builder/Maintenance
- Mission-control contains dependency declarations inline — no need to open specs just to determine task order
- Specs are loaded one at a time — lazy loading
- One task per session — fresh context prevents accumulation
- Protocol contains no examples or templates — pure rules

---

## FAQ

### Can I use Archy with Claude, ChatGPT, or other AI CLIs?

Yes. Archy is model-agnostic. It's a markdown-based protocol. Any AI that can read files and follow instructions will work. The examples use `gemini` but substitute your CLI tool. Update `runner-config.sh` accordingly.

### What if the AI ignores the protocol?

Re-anchor it. Start your prompt with:

```
Read and strictly follow @.archy/archy-protocol.md before doing anything.
```

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

### How does the runner handle failures?

The runner checks each session's output for `Status: FAILED` or `Status: ESCALATED`. After 3 consecutive failures, it halts and directs you to `sessions.log` for details. On success, the failure counter resets.

### Can I run the runner in preview mode?

Yes: `./.archy/archy-runner.sh --dry-run` shows what would execute without actually launching AI sessions.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.1.0 | 2026-02-10 | Role Composition system, dependency-driven task selection, Bootstrap Mode, protocol/templates split, protocol immutability, auto-healing behaviors, failure escalation, project brief template, runner script generation, session boundaries & logging |
| 4.0.0 | — | Initial "Mission Control" architecture — mode-based system, spec-driven development, file-based state |

---

## Keywords

AI agent, autonomous software engineering, spec-driven development, docs-driven development, TDD, mission control, task queue, Gemini CLI, prompt protocol

---

## Credits

Archy is a concept by **Ahmad Ez**.

Docs-to-code (Archy protocol)
v4.1 — *"Mission Control"*
Designed for full automation with strategic human oversight.

---

## License

This project is open source. Use it, fork it, improve it.
If you build something cool with it, let me know.
