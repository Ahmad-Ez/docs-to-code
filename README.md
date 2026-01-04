# Auto-Archy: The Autonomous Architect Protocol

Auto-Archy is a "Prompt-as-Code" system that turns the Gemini CLI into a state-aware, autonomous software engineer. It replaces chat-based memory with a persistent `.archy/state.json` file, allowing for infinite-context software development.

## Setup
1. Clone this repo:
   ```bash
   git clone [https://github.com/Ahmad-Ez/auto-archy.git](https://github.com/Ahmad-Ez/auto-archy.git) ~/auto-archy

```

2. Define a shell alias for convenience (add to .zshrc or .bashrc):
```bash
alias archy-init="cp ~/auto-archy/templates/project_brief.md ."

```



## The Workflow

### Phase 1: The Blueprint (Architect Mode)

**Goal:** Define the project structure without writing code.

1. Create a `project_brief.md` in your folder.
2. Start Gemini CLI.
3. **Prompt:**
> "I am uploading `~/auto-archy/PROTOCOL.md` and `project_brief.md`. Perform Phase 1: Blueprinting. Initialize the `.archy/state.json`."



### Phase 2: The Build Loop (Builder Mode)

**Goal:** Execute the plan one task at a time.

1. Start a NEW Gemini session (flush context).
2. **Prompt:**
> "I am uploading `~/auto-archy/PROTOCOL.md` and `.archy/state.json`. Execute Milestone M1-T1. You have permission to read/write files."



### Phase 3: Maintenance

**Goal:** Add features or refactor safely.

1. **Prompt:**
> "I am uploading `~/auto-archy/PROTOCOL.md` and `.archy/state.json`. Phase 3: Amend the plan to add [Feature X]."