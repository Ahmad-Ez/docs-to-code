# Docs-to-Code (Archy Protocol) v7.0 — "The Conductor"

Archy is a multi-agent, spec-locked software engineering protocol. You describe what to build. Specialized AI agents plan it, build it, review it, audit it, clean up after themselves, and hand you a PR.

It's designed for native use with **Claude Code** and **Gemini CLI**. One protocol, two environments, zero duplication.

---

## ⚡ Quick Start

**One-time**: Clone the master repo somewhere stable (e.g., `~/docs-to-code`).

```bash
git clone https://github.com/Ahmad-Ez/docs-to-code ~/docs-to-code
```

**Per project** — from inside your project root:

```bash
# New project (bootstrap):
claude "execute @~/docs-to-code/archy-templates.md bootstrap"

# Existing v6 project (migrate):
claude "execute @~/docs-to-code/archy-templates.md migrate"

# Normal work (after bootstrap):
claude "execute @.archy/base-prompt.md"
```

The master-repo files install themselves into your project's `.archy/`. You don't copy anything manually.

---

## 🎯 What is v7.0?

v7 is the **paradigm shift** release. Earlier versions packed all logic into a monolithic protocol read by a single AI. v7 splits the work across specialized agents, each with narrow scope and fresh context.

### The Paradigm Shift

- **One Conductor, many agents.** Your CLI conversation is the Conductor — it reads your config, picks the mode, dispatches specialized agents for each phase, parses their structured reports, and drives the gate sequence.
- **Strict DRY.** Project config lives in `base-prompt.md`. Orchestration logic lives in `archy-conductor.md`. Role-specific logic lives in each agent file. No duplication.
- **Structured communication.** Agents don't return prose — they return YAML reports with `verdict`, `issues`, and `next_action` fields. Gate logic is deterministic, not based on grepping English.
- **Parallel critics, comprehensive fixes.** Reviewer (functional) and Security Auditor (exploits) run in parallel. Builder addresses all findings in one pass — no stale line numbers from sequential fixes.
- **Escalation path.** When Builder gets stuck (3 failures in a cycle), a Debugger agent takes over with a higher-capability model and broader tools.

---

## 🧑‍🤝‍🧑 The Agent Roster

| Agent | Model (CC / Gemini) | Role |
| ------- | --------------------- | ------ |
| **Conductor** | — (main thread) | Reads `base-prompt.md` and `mission-control.md`. Dispatches agents. Parses reports. Runs gates. |
| **Architect** | opus / gemini-pro | Investigates the codebase. Writes spec files. Tags security-sensitive work with `+Security`. |
| **Builder** | sonnet / gemini-pro | Executes one spec via TDD. Commits and pushes. Extracts lessons. |
| **Reviewer** | sonnet / gemini-pro | Functional completeness + regressions. Runs through project skills. |
| **Security Auditor** | sonnet / gemini-pro | Adversarial exploit check. Triggered only on `+Security` specs. Fixed persona. |
| **Housekeeper** | haiku / gemini-flash-lite | Skill lifecycle (promotions, caps, archive audit). Commits skill changes. |
| **Debugger** | opus / gemini-pro | Forensic root-cause when Builder is stuck. Write-capable. Last stop before user escalation. |

Only the Conductor is implicit (it's your CLI conversation). The other six are agent files in `.claude/agents/` or `.gemini/agents/`, generated at bootstrap.

---

## 🌊 The Gate Sequence

```txt
     ┌────────────┐
     │ Conductor  │ (your CLI thread)
     └─────┬──────┘
           │ 1. pick next spec
           ▼
     ┌────────────┐
     │  Builder   │ ──► commits + pushes feature branch
     └─────┬──────┘
           │ 2. report: ready_for_critics
           ▼
     ┌────────────┬────────────────┐
     │  Reviewer  │ Security Auditor│  ← in parallel
     └─────┬──────┴────────┬───────┘
           │               │
           └───────┬───────┘
                   │ 3. collect both reports
                   ▼
            Any FAIL? ──► Builder (with previous_reports)  ──► Loop
                   │
                   │ Both PASS
                   ▼
          Builder stuck after 3? ──► Debugger ──► re-run critics
                   │
                   ▼
            ┌─────────────┐
            │ Housekeeper │ → commits skill lifecycle changes
            └──────┬──────┘
                   │ 4. commit + push confirmed
                   ▼
              Create PR
```

Key properties:

- Critics run **in parallel**, Conductor waits for both before deciding
- Fix loops address **all findings** (HIGH/MEDIUM/LOW) in a single Builder pass
- Housekeeper commit must land **before** PR creation
- After 3 Builder failures in a cycle, Debugger dispatches automatically

---

## 📁 Directory Structure

```txt
my-project/
├── .archy/
│   ├── archy-protocol.md       # Iron Rules + glossary (read by all agents)
│   ├── archy-conductor.md      # Orchestration brain (read only by Conductor)
│   ├── archy-templates.md      # Bootstrap + Migration prompts + artifact skeletons
│   ├── base-prompt.md          # 🚀 Your launchpad — project config, Target_Task
│   ├── mission-control.md      # 📋 Spec queue (Conductor reads/writes)
│   ├── archy-runner.sh         # 🔄 Optional batch autopilot
│   ├── sessions.log            # Audit trail
│   ├── skills/
│   │   ├── _project.md         # Project quirks (always loaded)
│   │   ├── _candidates.md      # Staging buffer (score-based promotion)
│   │   ├── _archive.md         # Cold storage (human-reviewable)
│   │   └── nextjs.md           # Stack-specific skills
│   └── specs/
│       ├── 00-db-schema.md
│       └── 01-auth-api.md
├── .claude/agents/             # Claude Code only
│   ├── archy-architect.md
│   ├── archy-builder.md
│   ├── archy-reviewer.md
│   ├── archy-security-auditor.md
│   ├── archy-housekeeper.md
│   └── archy-debugger.md
├── .gemini/agents/             # Gemini CLI only (same six files)
│   └── ...
├── docs/                       # ← outside .archy/ by design
│   ├── project-brief.md        # Human-authored project description
│   └── sops/
│       └── git-workflow.md     # Team conventions (plugin-style)
├── src/
└── package.json
```

`docs/` sits alongside `.archy/` rather than inside it — the brief and SOPs serve the team, not just Archy.

---

## 🎓 The Skill Lifecycle

Lessons don't enter the skill files directly. They earn their place:

```txt
Candidates (_candidates.md)     ← Builder/Debugger write new lessons here
   │  score starts at 1
   │  increments on independent re-encounter across sessions
   │  cap: 15 entries
   │
   ▼ score ≥ 3 (promotion, by Housekeeper)
Skill Files (skills/*.md)       ← Proven lessons, sorted by score
   │  cap: 25 per file
   │  loaded conditionally based on "Load when..." hints
   │
   ▼ cap overflow (demotion, lowest score)
Archive (_archive.md)           ← Cold storage, human-reviewable
      │  Housekeeper reads only during audit
      │  audit triggers every 5 demotions
      ▲
      │ score ≥ 3 aggregate across similar entries
      └── revive back to relevant skill file
```

**Two fast-paths:**

- **User corrections** ("don't do X") bypass candidates entirely — promoted direct to skill files.
- **Standalone Builder sessions** (outside the Conductor cycle) also write directly to candidates, keeping minor fixes from being lost.

Every skill file has a self-documenting `FORMAT SPEC` comment header so agents always know the format without needing to load a separate template.

---

## 🚢 Bootstrap: New Project

Run once per project:

```bash
# With a project brief at docs/project-brief.md:
# or without a brief (interviews you):
claude "execute @.archy/archy-templates.md bootstrap"
or
gemini --prompt "execute @.archy/archy-templates.md bootstrap"
```

The bootstrap prompt will:

1. Detect your CLI (Claude Code, Gemini CLI, or both)
2. Warn if your CLI version is below the known-good minimum
3. Read your brief or interview you to create one at `docs/project-brief.md`
4. Ask which environment capabilities you have (browser subagent, etc.)
5. Ask whether you want starter SOPs (copies samples from the master repo)
6. Generate all artifacts and agent files
7. Show you a summary and ask for approval before writing anything

---

## 🔄 Migration: v6.x → v7.0

If you have an existing Archy v6 project:

```bash
# From inside your v6 project root:
claude "execute @~/docs-to-code/archy-templates.md migrate"
# Gemini equivalent:
gemini --prompt "execute @~/docs-to-code/archy-templates.md migrate"
```

>The @~/docs-to-code/archy-templates.md path points to the master repo, not the project's .archy/. Both Claude Code and Gemini CLI support @ references to absolute paths.

The migration:

1. Archives v6 files (protocol, templates, old base-prompt, old agent files) to `.archy/.v6-backup/`
2. Preserves your specs, skills, mission-control, sessions.log, and project-brief untouched
3. Regenerates base-prompt using your extracted v6 config
4. Generates v7 agent files for your environment
5. Surfaces a "Manual Review" list for anything that didn't map cleanly
6. Asks for approval before writing

Your specs and skill files work as-is in v7. The format is unchanged between versions — only the orchestration layer is different.

---

## 🎬 Modes of Operation

| Mode | Trigger | What happens |
| ------ | --------- | -------------- |
| **Builder** | Empty `Target_Task` + pending specs | Conductor picks next spec, runs gate sequence |
| **Architect** | `Target_Task = "Plan X"` | Conductor dispatches Architect to interview + draft specs |
| **Maintenance** | `Target_Task = "Fix X"` or `"Refactor X"` | Full gate sequence, often with spec updates |
| **Bootstrap** | No `base-prompt.md` | One-shot, via `archy-templates.md bootstrap` |
| **Migration** | v6 protocol detected | One-shot, via `archy-templates.md migrate` |

---

## 🎭 Role Composition

Builder and Reviewer compose their persona from two sources:

| Base Prompt Default Role | Spec `Role:` Field | Result |
| -------------------------- | -------------------- | -------- |
| Backend Engineer | `DBA` (specialization) | DBA only (replace) |
| Backend Engineer | `+Security` (merge marker) | Backend Engineer with Security lens |
| Backend Engineer | `=Security-First Engineer` (explicit replace) | Security-First Engineer |
| Backend Engineer | *empty* | Backend Engineer |

Architect (creates specs), Security Auditor (fixed adversarial), Housekeeper (fixed mechanical), and Debugger (fixed forensic) all have non-composable roles.

---

## 🔌 SOPs as Plugins

SOPs live in `docs/sops/*.md`. They're team-authored conventions (git workflow, code review standards, deployment procedures) that Archy loads as reference, never auto-modifies.

Register them in `base-prompt.md`:

## Active SOPs

| SOP | File | Load when... |
| --- | ---- | ------------ |
| Git Workflow | docs/sops/git-workflow.md | Always |
| Code Review | docs/sops/code-review.md | Reviewer and Architect runs |

Bootstrap offers to copy starter SOPs from the master repo. You can add your own at any time — just drop a file in `docs/sops/` and register it in base-prompt.

---

## 🧠 The Conductor Contract

The Conductor (your CLI conversation) has exclusive responsibilities:

- **Only reader** of `base-prompt.md` and `mission-control.md`
- **Assembles Task Dossiers** — YAML envelopes that tell each agent exactly what to load and which role to apply
- **Parses Structured Reports** — YAML verdicts returned by every agent
- **Runs the gate sequence** — parallel dispatch, fix loops, debugger escalation, housekeeper commit, PR creation
- **Handles auto-healing** — stale specs, circular dependencies, missing files, malformed reports

Agents never see `base-prompt.md`. Agents never see each other's definitions. Agents see: the protocol (invariants), their own agent file (role), and a Task Dossier (what to do). Nothing else.

This is why v7 is DRY without being fragile: each agent has exactly the context it needs, curated per dispatch, no stale state.

---

## 🛠 Interactive vs. Runner

**Interactive (default, recommended):** Run `execute @.archy/base-prompt.md` one spec at a time. Review the PR. Test locally. Trigger the next session when ready. This is the primary workflow.

**Runner (opt-in batch):** `./archy-runner.sh` loops through your queue autonomously. Use for catching up after a break, CI pipelines, or very high-trust spec quality. Defaults to all Git-Ops true (auto-branch, auto-commit, auto-merge). Edit the top of the script to dial any of them back.

The runner parses structured YAML verdicts from each session, so gate decisions aren't based on prose grep. Three consecutive failures of any kind (FAIL, ESCALATE, infrastructure error, malformed report) halt the runner.

---

## 📚 Files in the Master Repo

```txt
docs-to-code/
├── archy-protocol.md           # The invariants (every agent loads)
├── archy-conductor.md          # Orchestration brain (Conductor loads)
├── archy-templates.md          # Bootstrap/Migration + artifact skeletons + agent templates
├── docs/
│   ├── sops/
│   │   └── git-workflow.md     # Sample SOP (copied to projects at bootstrap)
│   └── memory-strategies.md    # Design rationale for the skill lifecycle system
├── README.md
└── LICENSE
```

Four Archy files total: protocol, conductor, templates, plus the sample SOPs. Everything else is generated per-project at bootstrap.

---

## 🤔 FAQ

**Why two CLIs? Isn't this a lot of dual-path work?**
Minimal. 90% of each agent template is identical across Claude Code and Gemini CLI. Only the frontmatter (tool syntax, model name) differs. One source of truth with `{{#if env}}` blocks, bootstrap resolves them at install time.

**Does Gemini CLI support subagent orchestration?**
Yes at the top level — the main conversation can dispatch subagents. Gemini blocks *nested* subagent calls (subagent-calling-subagent), which is why the Conductor lives at the top level in both environments. One architecture, two CLIs, no compromise.

**The protocol file is much smaller in v7. Did functionality get lost?**
No. v6's protocol carried mode definitions, gate sequences, composition rules — all now in `archy-conductor.md`. Only the Conductor reads the conductor file. Agents only need invariants (protocol) + their own definition. The total system isn't smaller; it's partitioned.

**Can I use Archy with Aider, Cursor, or another CLI?**
The markdown is universal. The agent files assume Claude Code or Gemini CLI frontmatter syntax. For other CLIs, you'd need to adapt the frontmatter (tool names, model identifiers) manually. Everything else works.

**What if an agent ignores the protocol?**
The Conductor enforces gate sequence deterministically. If an agent returns a malformed report, the Conductor halts and surfaces the raw output. If an agent takes destructive action outside the spec scope, the Conductor halts before PR. These are safety interlocks, not guidelines.

**Can I skip a task?**
Mark it `[~]` in `mission-control.md`. Conductor skips it.

**What if I want to keep editing specs by hand after they're written?**
Go ahead. Specs are markdown, meant to be edited. Just don't change a spec's success criteria mid-build — restart the Builder session with the updated spec instead.

---

## 🧭 Philosophy

> Docs-Driven Development meets Continuous Learning meets Strict Isolation.

- No code without a Spec.
- No Spec without understanding.
- No Spec completion without verification.
- No session end without extracting lessons.
- No agent knowing more than it needs to.

The human focuses on **what** and **why**. Archy handles **how**, **in what order**, and **does it actually work** — then saves what it learned for next time.

---

## 📜 Version History

| Version | Date | Highlights |
| ------- | ---- | ---------- |
| 7.0.0 | 2026-04-18 | **"The Conductor"** — Multi-agent isolation. Conductor extracted to dedicated file. Structured Reports replace freeform markdown. Parallel critics with comprehensive-fix loop. Debugger agent for escalation. SOPs and project-brief moved to `docs/`. Self-documenting skill file headers. Unified agent templates with environment conditionals. |
| 6.1.x | 2026-03-18 onward | "Earned Knowledge" — skill lifecycle, candidates buffer, archive audit. Housekeeper subagent. PR gate separation. |
| 6.0.0 | 2026-03-09 | "Delegation & Discipline" — first subagent delegation, conditional skill loading. |
| 5.x | 2026-02 | Git-Ops runner, environment capabilities, skill plugin system. |
| 4.x | earlier | Mission Control queue, role composition, auto-healing. |

Full protocol history preserved in `archy-protocol-v6.md` for projects that need to trace decisions back.

---

## 🙏 Credits

Archy is a concept by **Ahmad Ez**.

*Docs-to-Code (Archy Protocol) v7.0 — "The Conductor"*
*Multi-agent. Strictly isolated. Fully instrumented.*

## License

Open source. Fork it. Improve it. If it saves you from a 3am debugging session, pay it forward.
