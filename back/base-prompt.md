# Base Prompt for Hurayra Pet Foods UAE (HPF-UAE)

## Project Identity

- **Current Task:**
  """
make sure that all the project api endpoints are represented by swagger ui
"""

- **Project Name:** HPF-UAE (Satellite Sales Terminal)
- **Description:** A high-performance logic buffer between Next.js and Odoo ERP, managing inventory integrity, "Combo" logic, and order lifecycle (Stripe, Jeebly, Odoo).
- **Primary Goal:** Ensure zero-overselling and accurate "Combo Explosion" logic while maintaining a 30-minute grace period before pushing orders to shipping/ERP.

## Mandatory Pre-Flight (STRICT ENFORCEMENT)

- **Git Branching Strategy**:
  1. **Branch First**: BEFORE making any file changes, you MUST create a feature branch.
  2. **Source of Truth**: All feature branches MUST be created from `origin/dev`. Always run `git fetch origin dev` before branching.
  3. **Command**: `git checkout --no-track -b feature/{spec-id}-{short-desc} origin/dev`. (Use `--no-track` to prevent local branch from accidentally tracking `origin/dev`)

## Archy Configuration

- **Default Role:** Senior Full-stack Engineer
- **Project Archetype:** Satellite API (Node.js ESM / Express / Prisma / PostgreSQL)
- **Prisma Client:** Generated to `src/generated/client`. Always import `prisma` from `src/DB/connection.db.js`. Uses `@prisma/adapter-pg` for driver-level compatibility.
- **Test Command:** pnpm test

## Session Handoff (STRICT ENFORCEMENT)

- **1. Checklist First (MANDATORY)**: BEFORE committing or pushing, you MUST perform these actions:
  - **Spec Update**: Mark all completed `[x]` checkboxes in the active `.archy/specs/*.md` file.
  - **Mission Control**: Mark the task as `[x]` in `.archy/mission-control.md`.
  - **Lessons Learned**: Append any new technical insights to the "Troubleshooting & Lessons Learned" section below.
- **2. Verification**: Run `pnpm test` (and any spec-specific tests). Ensure 100% pass rate.
- **3. Git Operations**:
  - `git add .`
  - `git commit -m "feat({spec-id}): {short-desc}"`
  - `git push -u origin feature/{spec-id}-{short-desc}` (The `-u` ensures your local branch tracks the remote feature branch, not dev)
- **4. PR Creation**: Use `gh pr create --base dev --head feature/{spec-id}-{short-desc} --title "feat({spec-id}): {short-desc}" --body "Automated PR for {spec-id}"`.

## Supporting Directives

- **Package Manager:** Use `pnpm` for all dependency management and script execution.
- **Schema-First:** Always define Zod schemas for API inputs and Prisma models for persistence.
- **Safety First:** Maintain a safety stock buffer (default=2) and hard 15-minute reservations during checkout.
- **Satellite Pattern:** Never write directly to Odoo; use API integrations.
- **Price Integrity:** Store all monetary values as integers (fils) to prevent floating-point issues.
- **ESM Only:** Adhere to Node.js ESM (ECMAScript Modules) standards.
- **TDD:** Write/plan tests first and iterate to green.
- **Clean Code:** Adhere to SOLID principles and ensure modular, testable code.

## Workflow & Standards

- **SOP Adherence:** Strictly follow `@docs/SOPs.md` for git flow (branching from `dev`, squash merging) and code standards.
- **Documentation First:** Always consult and abide by the requirements and technical designs in `@docs/SOPs.md`, `@docs/**`, `@.archy/project-brief.md`, and `@.archy/extra/**` to ensure all implementations align with the master plan.
- **Frontend Alignment:**
  - The frontend repository is located at: `E:\Ez Personal\Code\hurayrapetfoods-uae`
  - Check this sibling repo for existing types, schemas, or integration requirements to ensure full-stack compatibility.

## Troubleshooting & Lessons Learned

- **PowerShell Multi-Command Syntax**: Use `;` instead of `&&` when chaining multiple shell commands in a single `run_shell_command` call, as `&&` is not natively supported as a statement separator in the current environment's PowerShell version.
- **Prisma 7 Engine Issues:** In this environment, Prisma 7 defaults to the `client` engine which requires a driver adapter. Always use `@prisma/adapter-pg` with the existing `pg` pool in `src/DB/connection.db.js`.
- **Client Generation Path:** Standard `npx prisma generate` may fail to update `node_modules` correctly due to `pnpm` symlinking. The schema is configured to output to `src/generated/client`.
- **Environment Variables:** `config.service.js` must use `dotenv.config({ override: true })` to ensure `.env` values take precedence over stale shell environment variables.
- **ESM Testing:** Use `jest.unstable_mockModule` and `await import(...)` for mocking dependencies in ESM-based Jest tests to avoid `require is not defined` errors.
- **Shared Prisma Instance:** Always import the singleton `prisma` from `src/DB/connection.db.js` (including in scripts like `seed.js`) to ensure consistent configuration and connection pooling.
- **Test Isolation & Caching:** When implementing in-memory caches (e.g., for settings or metadata), always provide and use a reset mechanism (e.g., `clearCache()`) in `beforeEach` blocks to prevent state leakage between tests.
- **Prisma 7 Schema Constraints**: In Prisma 7, the `datasource` block in `schema.prisma` should NOT contain a `url` if it is being managed via `prisma.config.ts`.
- **ESM Mocking with Shared Objects**: When using `jest.unstable_mockModule` with shared mock objects, ensure the objects are defined outside the mock factory and correctly referenced to maintain consistency across the service and the test.
- **Stripe Webhook Raw Body**: For Stripe signature verification, the raw body must be captured _before_ any other body parsers (like `express.json()`) modify it. Using `express.raw()` on the specific webhook route is the most reliable approach in this ESM environment.
- **PowerShell Test Patterns**: When running tests in PowerShell with `--testPathPattern`, regex patterns containing pipes (`|`) must be double-quoted to prevent the shell from misinterpreting them.
- **Jest 30 CLI**: The `--testPathPattern` flag is deprecated/replaced by `--testPathPatterns`.
- **ESM Mocking Scoping**: Variables used inside the `jest.unstable_mockModule` factory must be prefixed with `mock` (case-insensitive "mock" at the start) to be accessible due to hoisting constraints.
- **Shipping Logistics (Jeebly)**: Total "pieces" in shipping payloads must represent the exploded physical components of bundles to maintain inventory and shipping integrity.
- **Odoo XML-RPC Re-auth**: Odoo sessions can expire. Implement automatic re-authentication by catching "Access Denied" errors in the service wrapper and retrying once after calling `connect()`.
- **Prisma Mocking in ESM**: When mocking Prisma methods like `update` in ESM-based Jest tests, ensure they return a resolved promise (e.g., `mockResolvedValue({})`) to prevent errors when chained with `.catch()`.
- **ESM Test Pathing**: `jest.unstable_mockModule` requires absolute or correctly relative paths. Always verify the path relative to the test file when mocking internal project modules.
- **Admin Route Ordering**: Static routes (e.g., `/export`) must be defined BEFORE parameterized routes (e.g., `/:id`) in Express to prevent the parameter from capturing the static path.
- **Prisma Date Aggregations**: Use `prisma.$queryRaw` for `DATE_TRUNC` and other complex date-based groupings, as standard Prisma aggregation methods have limited support for these operations.
- **Zod Parameter Coercion**: Use `z.preprocess` or `z.coerce` for validating request query parameters to ensure string inputs are correctly transformed into expected types (numbers, booleans).
- **Jest 30 CLI Migration**: The `--testPathPattern` flag has been replaced by `--testPathPatterns`. Always use the latter in CLI commands.
- **Validation Middleware**: Centralizing Zod validation in a middleware (`validate.js`) reduces boilerplate in controllers and ensures consistent error responses for validation failures.
- **JWT Refresh Tokens**: Storing refresh tokens in the database with `revokedAt` allows for server-side session management and forced logouts without waiting for token expiration.
- **Password Reset Security**: When requesting a password reset, always return a success message even if the user doesn't exist to prevent "user enumeration" attacks.
- **Validation Middleware Expansion**: When extending validation middleware to support query parameters (`validateQuery`), ensure that the parsed and typed data is attached to the request object (e.g., `req.validatedQuery`) to avoid repeated parsing in controllers.
- **Zod Query Preprocessing**: Query parameters are always strings. Use `z.preprocess` for booleans (converting "true"/"false" strings) and `z.coerce` for numbers to ensure correct types before validation.
- **Webhook Middleware Ordering**: When mounting webhooks before global `express.json()` (to capture raw bodies for Stripe), subsequent JSON-based webhooks (like Jeebly) must explicitly use `express.json()` in their specific route definitions to avoid `req.body` being undefined.
- **Frontend Reconciliation**: Always audit the frontend repository (if available) to ensure endpoints match the expected payload and parameter naming (e.g., `:slug` vs `:id`).
- **Prisma Schema Gaps**: Ensure all models used by the application (including those managed via manual SQL) are reflected in `schema.prisma` to allow for unified type-safe data access.
- **Local DB Connectivity**: If `DATABASE_URL` in `.env` uses a non-standard port (e.g., 51214), it likely refers to a temporary or managed instance (like `prisma dev` or a local proxy) that must be running for migrations and scripts to succeed.
- **ESM Mocking and Service Facades**: When testing services that depend on other services with in-memory caches (like `settingsService`), ensure the test imports the dependency and calls its reset/invalidation mechanism in `beforeEach`. Do not assume the primary service (facade) will expose these methods unless explicitly delegated.
- **Prisma Mock Completeness**: Always ensure Prisma mocks in tests include all methods used by dependencies, such as `findUnique` if a dependency service relies on it, even if the primary service being tested doesn't call it directly.
- **CI/CD Command Chaining (PowerShell)**: Use `;` instead of `&&` when chaining commands in PowerShell environments (e.g., `pnpm lint; pnpm test`).
- **Prisma Config in Docker**: If `prisma.config.ts` is present, ensure `ts-node` and `typescript` are installed (even if only as devDependencies), or use `npx prisma migrate deploy` which handles the execution environment more robustly than manual node invocation.
- **Docker Build Context**: Ensure `.dockerignore` excludes `src/generated` if it's generated during the build, to prevent stale local clients from overwriting the fresh Alpine-compatible client generated in the Docker build stages.
- **VPS Bootstrap (PostgreSQL Repo)**: Some VPS images (especially older Ubuntu) may have a stale `/etc/apt/sources.list.d/pgdg.list` that causes `apt-get update` to fail with a 404. Always check for and remove this file if the droplet doesn't require a local PostgreSQL managed by that specific repo.
- **Firewall (Multi-Service VPS)**: When bootstrapping a droplet that already hosts services (like Odoo/Nginx), ensure `ufw` rules are **additive** and explicitly allow existing service ports (80, 443, 8004, 8072) to prevent service disruption.
- **Express Reverse Proxy**: Always set `app.set('trust proxy', 1)` in Express when running behind Nginx. Ensure Nginx passes `X-Forwarded-For` and `X-Forwarded-Proto` headers so the app can correctly identify client IPs and secure protocols.
- **Docker Resource Limits**: On shared/constrained VPS environments, explicitly set `memory` limits and `logging` rotation in `docker-compose.yml` to prevent a single service from crashing the entire server (OOM or Disk Full).
- **Swagger ESM Integration**: When using `swagger-jsdoc` in an ESM project, ensure the `apis` paths in the configuration are relative to the working directory where the application starts.
- **Testing Swagger UI**: `supertest` can verify the `/api-docs` endpoint by checking for `200 OK` and the presence of `<!DOCTYPE html>` and `Swagger UI` strings in the response body.
- **Swagger Documentation Scope**: To ensure complete API documentation, the `swagger-jsdoc` configuration (`apis` array) must include glob patterns for all locations where routes are defined, such as `./src/routes/*.js` and `./src/modules/**/*.js`. A partial scan will lead to an incomplete Swagger UI.
- **Zod Schema Updates Impeding Tests**: When changing Zod schemas to expect a different structure (e.g., from string `name: 'text'` to an object `name: { ar: 'text', en: 'text' }`), existing controller test payload mocks will start returning HTTP 400. Always ensure to update the payload structures inside your `__tests__` directories to reflect schema changes.
- **Jest ESM Prisma `upsert` and UnhandledRejections**: Ensure nested Prisma mock functions correctly return resolved promises, otherwise Jest VM will throw UnhandledRejection or generic memory property access `TypeError: Cannot read properties of undefined` in standard Express test suites utilizing supertest without a global error boundary.
- **Controller Test Isolation in ESM**: When testing isolated Express controllers with `jest.unstable_mockModule` in an ESM environment, avoid importing the global `app.js`, as it can lead to deeply nested dependency graph failures and unhandled promise rejections. Instead, instantiate a fast, bare-bones Express app within the test file (`const app = express(); app.use(...)`) and mount only the specific routes and mocked middlewares needed for the test suite.
- **Swagger Documentation Consistency**: Instead of manually maintaining JSDoc annotations across all route controllers (which often leads to drift), use `swagger-autogen` to automatically scan Express endpoints and generate `swagger-output.json`. This ensures 100% of endpoints are documented in Swagger UI dynamically.

---

_Generated by Archy Bootstrap / Refined for Satellite Architecture_
