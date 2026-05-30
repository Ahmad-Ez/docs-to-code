---
name: archy-builder
description: Executes one spec from mission-control via TDD. Writes lessons to the candidates buffer.
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

> This agent's prompt has been centralized. See `../../.agents/archy-builder.md` for the core instructions.
