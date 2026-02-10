# 🤖 Archy (v4.1) — "Mission Control"

The AI Project Manager & Lead Engineer Protocol for CLI-based AI assistants.

---

## ⚡ Quick Start (TL;DR)

```bash
# 1. Copy protocol files into your project
mkdir .archy
cp ~/archy-core/archy-protocol.md .archy/
cp ~/archy-core/archy-templates.md .archy/

# 2a. If you have a project brief:
gemini "Read @.archy/archy-protocol.md and bootstrap this project based on @project-brief.md"

# 2b. If you don't have a brief yet:
gemini "Read @.archy/archy-protocol.md and bootstrap this project"

# 3. After bootstrap, run autopilot:
gemini "execute @.archy/base-prompt.md"
```

That's it. Archy will generate your base-prompt, specs, and mission-control, then build your project task by task.

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
- [Modes Overview](#modes-overview)
- [The Role System](#the-role-system)
- [Directory Structure](#directory-structure)
- [Configuration & Customization](#configuration--customization)
- [The Iron Rules](#the-iron-rules)
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

This is the `archy-core` repo. It contains only what needs to be portable:

```
archy-core/
├── archy-protocol.md     # 🧠 The Constitution — runtime rules, modes, role system
├── archy-templates.md     # 📐 Templates — spec, mission-control, base-prompt, project brief
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
ln -s ~/archy-core/archy-protocol.md your-project/.archy/archy-protocol.md
ln -s ~/archy-core/archy-templates.md your-project/.archy/archy-templates.md
```

With symlinks, updating `archy-core` updates all projects simultaneously. See [Context Efficiency](#context-efficiency) for trade-offs.

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

All files are presented for your approval before being written.

---

### Builder Mode (Autopilot)

The default mode. Picks the next eligible task and builds it.

```bash
gemini "execute @.archy/base-prompt.md"
```

**What happens:**
1. Reads `mission-control.md`
2. Finds the first `[ ]` item with all dependencies satisfied
3. Loads the referenced spec file
4. Writes tests first (TDD)
5. Implements the code
6. Runs verification
7. Marks checkboxes in spec, then marks `[x]` in mission-control

Repeat until the queue is empty.

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
4. Suggests base-prompt updates if project conventions change

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
4. Does NOT mark mission-control items unless explicitly told to

---

## Modes Overview

| Mode | Trigger | Responsibility |
|------|---------|----------------|
| 🏗️ **BOOTSTRAP** | No `base-prompt.md` or `mission-control.md` exists | Scaffolds entire project from brief or interview |
| 👷 **BUILDER** | Empty `Target_Task` + pending items in queue | Executes specs: writes tests → code → verifies → checks box |
| 📐 **ARCHITECT** | `Target_Task = "Plan X"` or empty queue | Interviews user → creates specs → updates mission-control |
| 🔧 **MAINTENANCE** | `Target_Task = "Fix/Change X"` | Fixes bugs → refactors → updates legacy specs |

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
- **Genuine protocol improvement** → edit manually in `archy-core`, all symlinked projects benefit

---

## The Iron Rules

Defined in `archy-protocol.md`, these are non-negotiable:

1. **Double Check** — Verify logic/code before outputting
2. **No Sugar-Coating** — Be objective, state risks clearly
3. **Filesystem is Truth** — Trust actual code over the plan
4. **Brief vs. Elaborate** — Respect the user's requested verbosity
5. **Spec-Lock** — No implementation without a detailed Spec
6. **Protocol Immutability** — AI cannot modify the protocol file

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
- Templates split into separate file — not loaded during Builder/Maintenance
- Mission-control contains dependency declarations inline — no need to open specs just to determine task order
- Specs are loaded one at a time — lazy loading
- Protocol contains no examples or templates — pure rules

---

## FAQ

### Can I use Archy with Claude, ChatGPT, or other AI CLIs?

Yes. Archy is model-agnostic. It's a markdown-based protocol. Any AI that can read files and follow instructions will work. The examples use `gemini` but substitute your CLI tool.

### What if the AI ignores the protocol?

Re-anchor it. Start your prompt with:

```
Read and strictly follow @.archy/archy-protocol.md before doing anything.
```

### Can I have multiple projects sharing the same protocol?

Yes — that's the design. Symlink `archy-protocol.md` and `archy-templates.md` from a central `archy-core` repo. Each project gets its own `base-prompt.md`, `mission-control.md`, and `specs/`.

### What if I want to change the protocol for one project only?

Copy instead of symlink. Then edit the copy freely. But consider putting project-specific rules in `base-prompt.md` first — that's what it's for.

### How do I add a feature mid-project?

Set `Target_Task = "Plan [feature name]"` in `base-prompt.md` and run. Architect Mode will interview you, create specs, and update mission-control.

### How do I skip a task?

Mark it as `[~]` in `mission-control.md`. Builder Mode will skip it.

### What if specs get out of sync with code?

Maintenance Mode detects stale specs and flags them. You can also manually trigger: `Target_Task = "Audit specs against codebase"`.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.1.0 | 2026-02-10 | Role Composition system, dependency-driven task selection, Bootstrap Mode, protocol/templates split, protocol immutability, auto-healing behaviors, failure escalation, project brief template |
| 4.0.0 | — | Initial "Mission Control" architecture — mode-based system, spec-driven development, file-based state |

---

## Credits

Archy is a concept by **Ahmad Ez**.

v4.1 — *"Mission Control"*
Designed for full automation with strategic human oversight.

---

## License

This project is open source. Use it, fork it, improve it.
If you build something cool with it, let me know.
