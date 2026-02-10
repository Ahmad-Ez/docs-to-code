# 🤖 Auto-Archy (v4.0)
**The "Mission Control" Protocol for AI-Assisted Software Engineering.**

Auto-Archy is a drop-in **AI Project Manager & Lead Engineer** for the Gemini CLI. It decouples *Planning* (Architect) from *Execution* (Builder) using a file-based state system.

> **Philosophy:** "Docs-Driven Development." The AI never writes code without a Spec. The Spec never gets written without a Plan.

---

## 📦 Installation

Auto-Archy is designed to be portable. To "install" it into any project:

1.  **Copy** the entire `.archy` folder from this repo into the root of your target project.
2.  **That's it.** Your project is now Auto-Archy enabled.

### Directory Structure
Once installed, your project will look like this:

```text
my-project/
├── .archy/
│   ├── base-prompt.md         <-- 🚀 THE ENTRY POINT (Run this file)
│   ├── auto-archy-protocol.md <-- 🧠 The Constitution (Rules & Modes)
│   ├── mission-control.md     <-- 📋 The State (Kanban/Playlist)
│   └── specs/                 <-- 📂 The Detailed Blueprints (Markdown)
├── src/
├── package.json
└── ...

```

---

## 🚀 Usage

You interact with Auto-Archy through a single entry point using the Gemini CLI.

### 1. The "Autopilot" (Builder Mode)

To let Auto-Archy pick the next task from the queue and build it:

```bash
execute .archy/base-prompt.md

```

* **What happens:** It checks `.archy/mission-control.md`, finds the first unchecked `[ ]` item, reads its Spec file, and writes the code.

### 2. The "Brainstorm" (Architect Mode)

To plan a new feature or start a project from scratch:

```bash
execute .archy/base-prompt.md

```

* **Input inside CLI:** When prompted, type: *"Plan the User Referral System"*
* **What happens:** It switches to **Architect Mode**. It will interview you, generate a `referral-system.md` file in `.archy/specs/`, and add it to the Mission Control queue.

### 3. The "Hotfix" (Maintenance Mode)

To fix a bug or refactor code without disturbing the plan:

```bash
execute .archy/base-prompt.md

```

* **Input inside CLI:** When prompted, type: *"Fix the CORS error in app.ts"*
* **What happens:** It switches to **Maintenance Mode**. It fixes the code immediately. *Note: It will also update the relevant Spec file to keep documentation in sync.*

---

## 🧠 The 3 Modes

| Mode | Trigger | Responsibility |
| --- | --- | --- |
| **👷 BUILDER** | Default (Empty Task) | **EXECUTION.** Reads a Spec file -> Writes Code -> Runs Tests -> Checks Box `[x]`. |
| **📐 ARCHITECT** | "Plan X" or Empty Queue | **STRATEGY.** Interviews User -> Creates `.archy/specs/*.md` -> Updates `mission-control.md`. |
| **🔧 MAINTAINER** | "Fix/Change X" | **ADAPTION.** Fixes Bugs -> Refactors Code -> Updates Legacy Specs. |

---

## ⚙️ Configuration

You can customize the **Persona** for specific projects by editing `.archy/base-prompt.md`:

```markdown
**Role:** Senior Rust Systems Engineer
**Focus:** Memory Safety, Zero-Cost Abstractions

```

---

## 🛡️ The Iron Rules

*Defined in `auto-archy-protocol.md`*

1. **Spec-Lock:** No implementation code is written without a detailed Markdown Spec.
2. **Filesystem is Truth:** The AI trusts the actual code over the plan.
3. **Retroactive Documentation:** If a bug is fixed in Maintenance Mode, the original Spec file must be updated.

---

*Auto-Archy is a concept by Ahmad Ez. v4.0 "Mission Control".*
