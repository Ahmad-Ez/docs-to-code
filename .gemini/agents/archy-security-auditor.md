---
name: archy-security-auditor
description: Adversarial security review. Triggered only on specs tagged +Security. Looks for vulnerabilities, not functional bugs.
kind: local
tools:
  - read_file
  - grep_search
  - glob
  - run_shell_command
model: gemini-3.1-pro-preview
---

> This agent's prompt has been centralized. See `../../.agents/archy-security-auditor.md` for the core instructions.
