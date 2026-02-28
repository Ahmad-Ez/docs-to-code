# 🤖 Docs-to-Code (Archy Protocol) (v5.0) — "Integration & Memory"

Docs-to-Code: A spec-locked, autonomous AI software engineering protocol with continuous learning, environment awareness, and Git-Ops automation.

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

# 4. Or use the Git-Ops runner for full hands-off autopilot:
./.archy/archy-runner.sh

```

---

## 🚀 What's New in V5?

V5 transforms Archy from a stateless code generator into an environment-aware, version-controlling integration agent.

1. **Stack Memory (Skills Plugins)**: Archy now extracts generic framework lessons (e.g., Next.js quirks, Prisma mocking) and flags them for synchronization to reusable `.archy/skills/*.md` files. You can drop these plugins into new projects to grant Archy "veteran" status on Day 1.
2. **Autonomous Git-Ops Runner**: The external runner script can now autonomously branch from `dev`, commit completed features, and (optionally) merge them back, fully managing the Git lifecycle.
3. **Environment Capabilities**: Archy now queries your IDE capabilities during Bootstrap (e.g., Antigravity Browser Subagents, Cursor rules) and leverages them during the Verification phase of a spec.

---

## 🧭 Table of Contents

* [Philosophy](#philosophy)
* [Repository Contents](#repository-contents)
* [Installation](#installation)
* [The Skills Architecture (Memory)](#the-skills-architecture-memory)
* [Autonomous Git-Ops (Runner)](#autonomous-git-ops-runner)
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
├── archy-protocol.md     # 🧠 The Constitution — runtime rules, continuous learning loop
├── archy-templates.md    # 📐 Templates — specs, queues, base-prompt, skills, runner
├── SOPs.md               # 🌿 Generic Git Workflow SOP
├── skills/               # 🎒 Veteran Knowledge Plugins (e.g., nextjs.md, prisma.md)
└── README.md             # 📖 This file

```

---

## Installation

### Option A: Symlink (Recommended for Protocol)

Symlink the core rules so updating `docs-to-code` updates all your projects simultaneously.

```bash
mkdir -p your-project/.archy
ln -s ~/docs-to-code/archy-protocol.md your-project/.archy/archy-protocol.md
ln -s ~/docs-to-code/archy-templates.md your-project/.archy/archy-templates.md

```

### Option B: Copy (Independent)

```bash
mkdir -p your-project/.archy
cp ~/docs-to-code/archy-protocol.md your-project/.archy/
cp ~/docs-to-code/archy-templates.md your-project/.archy/

```

**Note on Skills:** Always *copy* the relevant `.archy/skills/*.md` files into your new project during Bootstrap so Archy has local access to stack knowledge.

---

## The Skills Architecture (Memory)

In older versions, `base-prompt.md` became bloated with generic lessons. In V5, knowledge is separated into two tiers:

1. **System & Prompting Quirks (`base-prompt.md`)**: Project-specific environmental issues (e.g., "In this specific Docker container, use port 51214"). Archy appends these automatically.
2. **Active Skills (`.archy/skills/*.md`)**: Generic, reusable stack knowledge (e.g., "Next.js 15 Server Components routing quirks").

**The Sync Loop:**
When Archy learns a generic stack lesson, it outputs a `[FLAG: Sync upstream...]` in its Session Summary. You, the human, then copy that lesson back to the master `docs-to-code/skills/` repo so all future projects inherit the knowledge.

---

## Autonomous Git-Ops (Runner)

The runner (`archy-runner.sh`) is generated during Bootstrap. It isolates every task into a fresh AI context window.

Edit the top of the script to configure it:

```bash
AI_CMD='gemini'              # e.g., gemini, claude, aider
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
│   ├── skills/                 # Stack Plugins
│   │   └── nextjs-app-router.md
│   └── specs/                  # The Blueprints
│       ├── 00-db-schema.md
│       └── 01-auth-api.md
├── src/
└── package.json

```

---

## FAQ

**Can I use Archy with Claude or Aider?**
Yes. Archy is a markdown-based protocol. Update `AI_CMD` in `archy-runner.sh` to match your CLI tool.

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
| 5.0.0 | 2026-02-27 | **"Integration & Memory"**: Introduced Autonomous Git-Ops Runner, IDE/Environment Capability extraction, and the Active Skills plugin system. |
| 4.1.0 | 2026-02-10 | Role Composition, Auto-Healing, split templates, runner generation. |
| 4.0.0 | — | Initial "Mission Control" queue architecture. |

---

## Keywords

AI agent, autonomous software engineering, spec-driven development, docs-driven development, TDD, mission control, task queue, Gemini CLI, prompt protocol

---

## Credits

Archy is a concept by **Ahmad Ez**.

*Docs-to-Code (Archy Protocol) v5.0 — "Integration & Memory"*
*Designed for full automation with strategic human oversight.*

---

## License

This project is open source. Use it, fork it, improve it.
If you build something cool with it, let me know.
