# Archy Real-World Lessons Learned

This document compiles highly valuable technical lessons and best practices extracted from real-world, dual-path implementations of the Archy docs-to-code protocol (such as the `hurayra-backend` and `hurayra-nextjs` satellite architecture).

These lessons are captured from actual agent execution cycles and are saved here to inform future agent training, standard skills design, and operational procedures.

---

## 1. Codebase Orchestration & Git Worktrees

### A. Parallel Worktree Symlink Strategy
* **Context**: Multi-agent parallel systems often check out branches in isolated git worktrees.
* **Problem**: Framework-specific generated artifacts (such as `src/generated/client` from Prisma schema compilation or heavy `node_modules` folders) are missing inside fresh worktree checkouts. Running build/generation commands can be slow, resource-heavy, or fail if they require database connections or specific local network settings.
* **Lesson**: Run `pnpm install --frozen-lockfile --ignore-scripts` inside the worktree (to safely install only packages and skip side-effect scripts) and **symbolically link** heavy generation outputs from the main repository directory:
  ```bash
  ln -s <main_repo_path>/src/generated <worktree_path>/src/generated
  ```
  This keeps worktrees extremely lightweight, prevents parallel network build collisions, and speeds up startup from minutes to seconds.

### B. Git Staging Hygiene
* **Context**: Staging files when local git worktrees are running.
* **Problem**: Running blanket staging commands like `git add -A` or `git add .` from the main repository root stages the temporary active worktree directories as **git submodules**. This corrupts the git tree and causes major integration conflicts.
* **Lesson**: Builders and housekeepers must target explicit files and clean file globs when staging changes. Never use generic wildcard staging commands (`git add .`) when worktrees are active in the repository directory structure.

---

## 2. Framework Versioning (Next.js 16+)

### Next.js Proxy/Middleware Naming Convention
* **Context**: Upgrading react/web frameworks to cutting-edge versions.
* **Problem**: Next.js 16 has formally renamed the middleware convention:
  * `middleware.ts` is now `src/proxy.ts`
  * `export function middleware` is now `export function proxy`
* **Lesson**: Core Next.js skill definitions (`nextjs.md`) must explicitly document this structure. Agents that are unaware of this update will attempt to "fix" or rename `src/proxy.ts` back to `middleware.ts` as a lint error, resulting in compilation failures and 404 execution crashes.

---

## 3. Zero-Annotation API Documentation

### AST-Driven Swagger Spec Generation
* **Context**: Documenting large-scale Express/Fastify backends.
* **Problem**: Manual OpenAPI/Swagger annotations (`#swagger`, `@swagger`, JSDocs) are highly verbose, easily drift from actual schemas, and severely pollute the AI's context window.
* **Lesson**: Adopt a zero-annotation AST-based generation model. Define validators using Zod schemas inside `src/validators/` and apply them to standard route middleware:
  * Run a generator script (`scripts/swagger-gen.js`) that uses abstract syntax tree (AST) analysis to parse route setups and validators.
  * Define metadata cleanly via route exports:
    ```javascript
    export const routeMeta = { tag: 'Sales', prefix: '/api/sales', secured: true };
    ```
  * Automatically regenerate specifications upon dev startup (`pnpm dev` runs generator). This eliminates annotation maintenance entirely and keeps the documentation 100% correct relative to the codebase state.

---

## 4. Scripting & Windows Automation

### A. PowerShell Parameter Isolation
* **Context**: Writing git and testing autopilot scripts for Windows.
* **Problem**: Storing or passing automatic variable names like `$Profile` in PowerShell functions shadows the built-in system `$PROFILE` variable, corrupting environment initialization scripts.
* **Lesson**: Avoid naming parameters or local variables with reserved PowerShell names. Use `$Identity` or `$UserProfile` instead.

### B. Dynamic User Detection
* **Context**: Authoring commits and git hooks via automation scripts.
* **Problem**: Hardcoding default developer names (e.g. `ahmad`) inside automated runner scripts makes the setup fragile across collaborative dev environments.
* **Lesson**: Dynamically query user configuration from Git on script startup:
  ```powershell
  $GitUser = git config user.name
  $GitEmail = git config user.email
  ```
  Save execution state to gitignored local JSON snapshots rather than committing configuration parameters. This keeps tools completely zero-setup.
