---
name: archy-reviewer
description: Reviews Builder output against the spec. Checks functional completeness and regressions. Does NOT check security.
kind: local
tools:
  - read_file
  - grep_search
  - glob
  - run_shell_command
model: gemini-3.1-pro-preview
---

> This agent's prompt has been centralized. See `../../.agents/archy-reviewer.md` for the core instructions.
