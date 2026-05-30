---
name: archy-debugger
description: Forensic root-cause analysis and fix when Builder is stuck after 3 consecutive failures. Write-capable. Runs on high-capability model.
kind: local
tools:
  - read_file
  - write_file
  - replace
  - run_shell_command
  - grep_search
  - glob
model: gemini-3.1-pro-preview
---

> This agent's prompt has been centralized. See `../../.agents/archy-debugger.md` for the core instructions.
