# ARCHY SKILL: React Components & UI Patterns

**Domain**: React, JSX, Hydration, UI Components, State
**Version Target**: React 18.x - 19.x

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

- Server Components by default; `"use client"` only at the leaves when interactivity is strictly required.
- Always use optional chaining (`?.`) or safe fallbacks when reading from potentially undefined API responses or route parameters.

---

## Lessons

- [5 | 2026-04-23] React Hook Form (RHF) and Zod Type Mismatches:
  * Adding `.default("")` to a Zod schema field makes the parser input type `string | undefined` but the output type `string`. This causes `zodResolver` to reject the mismatch with a TypeScript error on the form `resolver` property. To fix this, define schemas *without* `.default()` and explicitly pass values inside `defaultValues` when instantiating `useForm`.
  * If a form field is disabled in an edit view and excluded from the PUT payload, do not include it in the `safeParse` call; validating fields the user cannot modify leads to unreachable, unfixable form errors.
  * For optional passwords in edit forms, use `.min(8, "…").or(z.literal(""))` rather than `.optional()`, ensuring that an empty string passes (skipping reset) but non-empty values must meet the length requirement.
- [3 | 2026-04-23] Hydration Mismatches & UI Fixes:
  * Prevent hydration mismatches from client-side state (such as values fetched from `localStorage` or browser APIs) by wrapping the conditional rendering inside a `useState`/`useEffect` `isMounted` mount check.
  * Literal `\r\n` line endings inside JSX className strings (often introduced on Windows systems) will trigger hydration mismatches on the server. Always flatten JSX className strings to single lines.
  * Native HTML5 `<details>` and `<summary>` tags should be preferred for simple interactive sections (like FAQs) in Server Components to avoid needing `"use client"` and reduce JavaScript bundle sizes.
- [3 | 2026-04-23] next/image Optimization Patterns:
  * When utilizing `next/image` with the `fill` property, the parent container MUST have a non-zero height and `overflow-hidden` to prevent layout overflow and zero-height console warnings.
  * When modifying Next.js image dimensions via CSS/Tailwind, add `width: "auto"` or `height: "auto"` as inline styles to prevent aspect ratio console warnings.
  * Prefer local, CSS-stylized SVG placeholders over external placeholder services, which often return 400 errors when processed through Next.js image optimization engines.
- [3 | 2026-04-07] requestAnimationFrame (rAF) for Effect States:
  * To avoid `react-hooks/set-state-in-effect` violations, wrap any state modifications in `useEffect` bodies in a `requestAnimationFrame` block:
    ```javascript
    useEffect(() => {
      const id = requestAnimationFrame(() => setState(val));
      return () => cancelAnimationFrame(id);
    }, [val]);
    ```
  * Do not initialize loading states inside delayed rAF blocks while triggering synchronous fetches, as it creates a race condition. Initialize `isLoading: true` directly in `useState` and use rAF only for the finally block's `setIsLoading(false)` call.
- [1 | 2026-05-01] Recharts ResponsiveContainer Synchronous Dimensions Warning:
  * In Recharts 3.x, `ResponsiveContainer` initializes with dimensions `-1, -1` before the `ResizeObserver` fires, causing synchronous warnings. To resolve this, do NOT use `isMounted` wrappers; instead, pass `initialDimension={{ width: 10, height: 10 }}` (or any positive numbers) directly to the `ResponsiveContainer` component.
