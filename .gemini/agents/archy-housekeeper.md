---
name: archy-housekeeper
description: Manages skill lifecycle (promotions, caps, archive audits) and commits skill file changes to git.
kind: local
tools:
  - read_file
  - write_file
  - replace
  - glob
  - grep_search
  - run_shell_command
model: gemini-3.1-flash-lite-preview
---

> This agent's prompt has been centralized. See `../../.agents/archy-housekeeper.md` for the core instructions.
