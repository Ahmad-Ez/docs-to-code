# ARCHY: SESSION LAUNCHER

**Protocol-Version**: 4.1.0
**Tested-With-Protocol**: 4.1.0

---

## Target_Task

---

## Project Identity

**Name**: HPF-UAE Frontend (Next.js)
**Stack**: Next.js 16.1, TypeScript, Tailwind CSS v4, Zustand, next-intl, Stripe, Axios
**Repo**: `e:\Ez Personal\Code\hurayra-nextjs`

---

## Default Role

Senior Frontend Engineer (Next.js / React / TypeScript Focus)

**Capabilities**: SSR/SSG Architecture, Component Design, i18n, Stripe Integration, Admin Panels, API Integration
**Tone**: Objective, Professional, Concise

---

## Project Archetype

### Stack Conventions

- **App Router**: All pages under `src/app/[locale]/` for public, `src/app/admin/` for admin
- **next-intl**: i18n with `src/i18n/` (routing, request, navigation) and `src/messages/{locale}/`
- **Zustand + persist**: Client-side state in `src/store/` with localStorage persistence
- **Axios client**: `src/lib/api/client.ts` with JWT auto-inject and refresh interceptor
- **API modules**: `src/lib/api/index.ts` — all endpoint functions typed
- **Types**: `src/lib/types.ts` — aligned with backend swagger contracts
- **Prices in fils**: Always store as integers, display using `formatPrice()` from `src/lib/constants.ts`
- **Stripe only**: No COD. No guest purchasing. Members only.
- **Design tokens**: UK-site-inspired colors in `src/app/globals.css` (teal, rose, gold, navy)

### Code Style

- ESLint (Next.js default config)
- Prefer named exports for components
- Server Components by default, `"use client"` only when needed
- Keep components focused and reusable in `src/components/`

### Verification Plan

Every spec must pass these checks before marking `[x]` in mission-control.

#### CLI Checks (Mandatory)

1. `pnpm build` — production build succeeds with zero errors
2. `pnpm lint` — zero warnings or errors
3. `pnpm dev` — dev server starts at localhost:3000

#### Browser-Based Verification (Antigravity-Specific)

Use the browser subagent to visually verify work. These capabilities are unique to Antigravity and should be used whenever UI changes are made:

1. **i18n**: Navigate to `/en` and `/ar` routes. Verify RTL layout renders correctly (text alignment, icon positions, margin/padding direction).
2. **Navbar behavior**: Scroll down → navbar should hide. Scroll up → navbar should reappear sticky. Floating burger icon should appear when navbar is hidden.
3. **Responsiveness**: Resize browser viewport to test at 375px (mobile), 768px (tablet), and 1440px (desktop). All pages must render correctly at each breakpoint.
4. **API integration**: Products page loads data from API (with graceful fallback if API is down). Contact form submits successfully.
5. **Checkout flow**: Stripe Elements render on checkout page. Payment intent can be created. Auth guard redirects unauthenticated users.
6. **UX audit**: Verify hover states, transitions, and micro-animations feel premium. Check that interactive elements respond to clicks. Ensure visual hierarchy is clear and consistent.

#### Design Spirit

Maintain **UK brand family feel with distinct UAE personality** throughout. Rose for strategic accents, teal as primary, gold for CTAs, navy for grounding. Never clone the UK site — enhance it.

---

## Role Overrides (Optional)

| Mode | Role Override |
|---|---|
| Builder | Senior Frontend Engineer |
| Architect | System Architect + UI/UX Designer |
| Maintenance | Detail-Oriented Fixer |

---
  
## Session Handoff (STRICT ENFORCEMENT)

- **1. Checklist First (MANDATORY)**: BEFORE completing a task, you MUST perform these actions:
  - **Spec Update**: Mark all completed `[x]` checkboxes in the active `.archy/specs/*.md` file.
  - **Mission Control**: Mark the task as `[x]` in `.archy/mission-control.md`.
  - **Lessons Learned**: Append any new technical insights to the "Lessons Learned" section below.
- **2. Verification**: Run `pnpm build` (and any spec-specific tests). Ensure 100% pass rate.
- **3. Git Operations**: Wait for user review before committing, UNLESS explicitly told to commit. When told to commit:
  - `git add .`
  - `git commit -m "feat({spec-id}): {short-desc}"`
  - `git push -u origin feature/{spec-id}-{short-desc}`
- **4. PR Creation**: Use `gh pr create --base dev --head feature/{spec-id}-{short-desc}` when requested by the user.

---

## Custom Rules

1. **Backend is a sibling repo**: The backend source is at `e:\Ez Personal\Code\hurayrapetfoods-uae\backend-docs\`. Reference `swagger-output.json` for API contracts — never guess endpoints.
2. **Don't touch the old app**: The old Vite+React app at `e:\Ez Personal\Code\hurayrapetfoods-uae\src\` is read-only reference. Never modify files there.
3. **UK site as design reference**: Use `hurayrapetfoods.com` for visual inspiration. Permission granted to use all media.
4. **Content corrections**: Apply all corrections from project-brief (Omega 3,6&9, Why Halal?, protein 35%, etc.)
5. **PowerShell**: Use `;` instead of `&&` for command chaining.
6. **Git Workflow**: Always adhere to the established workflow in `@.archy/SOPs.md` (branching from `dev`, using proper prefixes like `feature/`, and creating PRs).

---

## Lessons Learned (AI-Appendable)

- 2026-02-25: PowerShell `Move-Item` fails on deep node_modules paths with long names. Delete node_modules first, then move, then `pnpm install`.
- 2026-02-25: Next.js 16.1 `create-next-app` prompts for React Compiler even with `--typescript --tailwind` flags. Answer interactively or pipe input.
- 2026-02-25: When using next-intl with App Router, the root `layout.tsx` must return `children` directly (no `<html>` tag), and the `[locale]/layout.tsx` must wrap with `<html lang dir>` and `NextIntlClientProvider`.
- 2026-02-25: IDE linting might flag `next-intl` imports as missing module declarations, but if `pnpm build` succeeds, this is just IDE lag with Next.js specific module resolution and can be ignored.
- 2026-02-25: When using `next-intl` in Next.js Server Components, be sure to use `setRequestLocale(locale)` at the top of the component to enable static rendering, and `getTranslations()` inside `generateMetadata()` for localized SEO.
- 2026-02-25: When using `next-intl`, navigation functions like `useRouter` and `Link` should be imported from `@/i18n/navigation`, not `@/i18n/routing` (which only exports the `routing` configuration).
- 2026-02-27: Never split a combined import statement when removing individual unused identifiers. View the full import line first, then rewrite the entire import to remove only what is unused. Splitting `{ A, B, C }` into two lines will break the remaining references to `A` and `C`.
- 2026-02-27: When removing a Zustand state variable, always `grep` for every usage (state declaration, setter calls, and JSX reads) before saving. Removing the `useState` declaration while leaving the setter call in JSX causes a compile error.
- 2026-02-27: After changing a component's `Props` interface (adding or removing props), immediately update every call site in the same edit. Type errors at call sites are not always surfaced until build/lint runs, so a search for the component name is a required step.
- 2026-02-27: The ESLint rule `react/no-unescaped-entities` flags raw `'` and `"` in JSX text nodes — even inside prose blocks. Always use `&apos;` / `&ldquo;` / `&rdquo;` for apostrophes and quotes in JSX text. This does NOT apply inside JS template literals, attribute strings, or `style` props.
- 2026-02-27: Do not assign `const t = await getTranslations(...)` in `generateMetadata()` unless `t("key")` is actually called in that function. Unused variable declarations in Server Components cause lint errors. Either use the translation or omit the assignment entirely.
- 2026-02-27: When a callback parameter must be omitted from the function body but the parameter is required by an external type signature (e.g. Stripe's `onSuccess: (id: string) => void`), use `// eslint-disable-next-line @typescript-eslint/no-unused-vars` on the line above rather than removing the parameter — removing it breaks the type contract.
- 2026-02-27: In next-intl 4.x with App Router, the `[locale]/layout.tsx` MUST use `getMessages()` from `next-intl/server` (not manually importing JSON files) when passing messages to `NextIntlClientProvider`. Manually loading files creates a mismatch and causes all `useTranslations()` calls in client components to fail with `MISSING_MESSAGE` errors, even when the JSON files are correct.

---

## 🚀 SYSTEM LOGIC

### Step 1: Load Constitution

Read and internalize: `@.archy/archy-protocol.md`

### Step 2: Determine Mode

**IF** `Target_Task` is NOT empty:

- **ACTIVATE**: MAINTENANCE or ARCHITECT MODE (based on task nature)
- **Context**: Load `@.archy/mission-control.md` (read-only for context)
- **Action**: Execute `Target_Task` immediately
- **Rule**: If task changes system logic, update the relevant spec file before finishing

**ELSE** (Target_Task is empty):

- **ACTIVATE**: BUILDER MODE (AUTOPILOT)
- **Context**: Read `@.archy/mission-control.md`
- **Logic**:
  1. Parse `Depends-On` declarations
  2. Find first `[ ]` item with all dependencies satisfied (`[x]`)
  3. Load the referenced spec file
- **Action**: Execute the Implementation Steps inside that spec
- **Completion**: Mark `[x]` in mission-control ONLY after verification passes
- **Session End**: Output Session Summary block and terminate (see Protocol Section 3.5)
- **Empty Queue?**: If all items are `[x]`, switch to ARCHITECT MODE and ask user for next milestone

---

_Generated by Archy Bootstrap / HPF-UAE Next.js Frontend_
