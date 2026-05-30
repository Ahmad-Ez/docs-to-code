# ARCHY SKILL: Testing & ESM Patterns

**Domain**: Jest, ESM Mocking, Test Isolation
**Version Target**: Jest 30 / Node 20 ESM

---

<!--
  FORMAT SPEC — DO NOT EDIT, used by Builder/Debugger/Housekeeper:
  Entry format:  - [score | YYYY-MM-DD] Lesson description
    - score: integer, number of independent sightings (starts at 1 in candidates, promotes to skill at ≥ 3)
    - YYYY-MM-DD: last_seen date
  Sort order: score desc, last_seen desc as tiebreaker
  Cap: 25 entries per skill file. Overflow demotes the lowest-score entry to `_archive.md`.
  Writers: Housekeeper (normal lifecycle), Builder/Debugger (direct write on user corrections).
-->

## Core Tenets

- ESM mocking requires a different pattern than CommonJS: always use `jest.unstable_mockModule` with a dynamic `await import(...)` after the mock declaration.
- Tests must be fully isolated — no shared state, no global app imports, and no real database connections.

---

## Lessons

- [3 | 2026-03-18] ESM Mocking Pattern:
  * Mock ESM modules using `jest.unstable_mockModule` BEFORE importing the target controller or service file under test:
    ```javascript
    jest.unstable_mockModule('./service.js', () => ({
      getData: jest.fn()
    }));
    const { controller } = await import('./controller.js');
    ```
  * All variables declared inside the mock factory callback must be prefixed with the word `mock` (case-insensitive) to prevent Jest initialization scope errors.
- [3 | 2026-04-25] Dynamic Mock Object Syncing:
  * When adding new database model access (e.g. `prisma.orderItem`) to a service, ALL test files that mock the database client for that service must be updated to include the new model in their mock objects. Missing models will trigger synchronous `TypeError: Cannot read properties of undefined` during test runs.
- [3 | 2026-04-25] Fire-and-Forget testing patterns:
  * When testing controller paths that use a fire-and-forget promise pattern (`someService().catch(() => {})`), the mocked service function MUST return a real Promise (use `mockResolvedValue(undefined)` or `mockRejectedValue(...)`). If the mocked function returns `undefined` due to a cleared mock, calling `.catch()` on it will throw a TypeError synchronously, bubbling up and falsely registering as an unhandled 500 error.
- [3 | 2026-03-18] Express Test Isolation:
  * Do not import the global `app.js` or main server module inside controller tests. This pulls in all global routers, heavy configurations, and database connections. Instead, instantiate a bare-bones Express app within each test file (`const app = express()`) and mount *only* the specific controller and mocked middlewares under test.
  * Always provide and call a cache reset mechanism in `beforeEach` blocks when testing modules containing in-memory caching layers.
- [1 | 2026-04-10] Queue & Redis Connection Laziness:
  * Instantiating queues (e.g. BullMQ) or Redis connections at module load time creates live IORedis connections even with `lazyConnect: true`. This leaves open handles that prevent Jest from exiting cleanly. Wrap connection instances in a lazy getter (using a closed-over `_instance = null` pattern) and export a proxy object that defers construction until a method is actually called.
