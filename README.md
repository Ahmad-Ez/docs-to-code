# Auto-Archy: Centralized Agent Protocol

**Auto-Archy** is a "Prompt-as-Code" framework that transforms the Gemini CLI into a state-aware, autonomous software engineering lead. By replacing ephemeral chat memory with a persistent `.archy/state.json` file, it enables infinite-context development, architectural consistency, and rigorous task management.

## 🚀 Setup

### 1. Clone the Repository

Clone this repository to a permanent location on your machine (e.g., `~/code`).

```bash
cd ~/code
git clone https://github.com/Ahmad-Ez/auto-archy.git
```

### 2. Configure the Alias

Add the `new-project` alias to your shell configuration (`.zshrc`, `.bashrc`, or PowerShell profile) to easily bootstrap new projects.

**Bash / Zsh:**

```bash
alias new-project="~/code/auto-archy/utils/bootstrap.sh"
```

**PowerShell:**

```powershell
function New-Project { & "C:\path\to\code\auto-archy\utils\bootstrap.sh" $args }
```

*(Reload your shell configuration after saving)*

---

## 🛠 Usage Workflow

### Initialize a New Project

Run the alias you just created to scaffold a new project structure.

```bash
cd ~/code
new-project "my-awesome-app"
```

**This script will:**

* Create the folder `~/code/my-awesome-app`.
* Initialize the hidden `.archy/` directory.
* Seed the project with `project_brief.md` (for your requirements) and `state.json` (for the agent's memory).
* **Print an "Initialization Prompt"** for you to copy.

### 2. Phase 1: Blueprinting (Architect Mode)

* **Goal:** Define the architecture, stack, and development plan without writing code.
* **Action:**
    1. Edit `my-awesome-app/project_brief.md` to describe your application idea.
    2. Start the Gemini CLI.
    3. **Paste the Initialization Prompt** generated in step 1.
       * *Context to provide:* `PROTOCOL.md`, `project_brief.md`
       * *Prompt:*
         > "I am starting a new project. Here is the PROTOCOL and the BRIEF. Please perform Phase 1: Blueprinting."

The agent will read your brief and generate a detailed technical plan in `.archy/state.json`.

### Phase 2: Construction (Builder Mode)

* **Goal:** Execute the plan, one task at a time.
* **Action:**
    1. Review the plan in `.archy/state.json` (optional).
    2. In the Gemini CLI, instruct the agent to execute a task:
       * *Context to provide:* `PROTOCOL.md`, `.archy/state.json`
       * *Prompt:*
         > "Execute Task M1-T1."
    3. **The Agent will:**
       * Read the state and relevant files.
       * Write a test case (TDD).
       * Write the implementation code.
       * Run tests to verify correctness.
       * Mark the task as "completed" in `state.json`.

### Phase 3: Maintenance & Evolution

* **Goal:** Add features or refactor existing code safely.
* **Action:**
    1. Ask the agent to plan a change:
       * *Context to provide:* `PROTOCOL.md`, `.archy/state.json`
       * *Prompt:*
         > "I need to add user authentication. Update the plan."
    2. The agent will amend `state.json` with new milestones/tasks.
    3. Proceed with **Phase 2** execution for the new tasks.

---

## 📂 Core Components

| Component | Description |
| :--- | :--- |
| **`PROTOCOL.md`** | The "Operating System" for the agent. It defines the rules, phases, and behavior constraints. |
| **`.archy/state.json`** | The persistent memory. Tracks the tech stack, database schema, API contracts, and task progress. |
| **`project_brief.md`** | The user's requirements document. Edited by you to drive Phase 1. |
