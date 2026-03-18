# Memory Strategies: Design Rationale for Archy's Skill Lifecycle

This document captures the design thinking behind Archy v6.1's skill lifecycle system. It covers the strategies we explored, the trade-offs considered, and why we landed on the current approach.

---

## The Problem

AI coding agents extract "lessons learned" after every task. But:

- **The agent doesn't know what's noise yet.** At task completion, everything feels important. You often can't tell what's signal until later.
- **No feedback loop.** A skill gets written and stays forever. There's no mechanism to say "this skill was wrong" or "this skill stopped being relevant."
- **The AI is both the learner and the judge.** The same agent that made the mistake decides what the lesson is.
- **One size doesn't fit all.** A 3-file hobby project and a 50-file enterprise monorepo shouldn't share the same memory constraints.

Previous versions (v5-v6.0) used a simple two-tier system: project quirks in base-prompt (capped at 5) and stack-generic lessons in skill files (uncapped). This worked but had no quality gate — every lesson was treated as proven truth the moment it was written.

---

## Strategies Explored

### 1. Staging Buffer with Frequency-Based Promotion (Adopted)

**Concept:** New lessons land in a candidates buffer at score 1. Score increments on independent re-encounter across sessions. Promote to skill file at score >= 3. Expire if not seen in 10 sessions.

**Why this works:** If the AI hits the same wall 3 times across different sessions, that's a strong signal. One-off lessons — which are most noise — naturally expire. The system only remembers what keeps coming up.

**Trade-off:** A genuinely important lesson that only occurs once takes longer to establish. Accepted because: if it's truly important and the project continues, it will recur.

### 2. Outcome-Validated Learning (Explored, Deferred)

**Concept:** Track whether sessions that loaded a particular skill had fewer retries, fewer test failures, or fewer user corrections. Skills that don't correlate with better outcomes get demoted.

**Why we deferred:** Requires tracking session outcomes over time and correlating them with loaded skills. The infrastructure cost (outcome tracking, statistical comparison) exceeds the benefit for a markdown-based protocol. May revisit if Archy gets a persistent runtime.

### 3. Token Budget with Dynamic Sizing (Explored, Simplified Away)

**Concept:** Express skill capacity as a percentage of the AI's context window (2%), with hard floor (500 tokens) and ceiling (4000 tokens). Distribute budget across loaded files. Use percentile tiers (P30/P70) within each file to determine active vs. standby vs. demote zones.

**Why we simplified:** The binding constraint for skill memory is AI attention quality, not raw context size or token cost. But the percentile math and cross-file budget distribution added complexity without proportional benefit. Conditional file loading (the Active Skills table's "Load when..." hints) already handles the major lever — which files load at all. Whether a loaded file has 15 or 25 entries is a second-order effect in a 200K context window.

**What survived:** Hard caps per file (25 entries) and score-based sorting. Simple, effective, no math.

### 4. Separate Observer from Actor (Explored, Partially Adopted)

**Concept:** Have a dedicated "retrospective" phase or separate agent review the session log for lessons, rather than having the builder extract its own lessons.

**What we adopted:** The archive audit routine is a form of this — it's a separate phase (triggered every 5 demotions) that reviews accumulated evidence rather than judging in the moment. The candidates buffer itself is a "wait and see" mechanism that defers judgment.

**What we didn't adopt:** A fully separate retrospective agent. Too much overhead for the marginal improvement.

### 5. Global Titles-Only Loading (Explored, Rejected)

**Concept:** Instead of loading full skill file content for relevant files, show ALL lesson titles across ALL skill files (~2 tokens each). AI cherry-picks individual lessons to load in full. Eliminates cross-file fairness problems.

**Why we rejected:** Adds another decision layer per session. A loaded skill file with 20 entries is only ~600 tokens — just load the whole thing. The surgical precision of per-lesson selection isn't worth the cognitive overhead on the agent.

### 6. Statistical Distribution Cutoffs (Explored, Rejected)

**Concept:** Inspired by biology/statistics — use standard deviations or normal distribution to determine dynamic cutoffs for promotion/demotion. Skills above P70 are "active," between P30-P70 are "standby," below P30 are demoted. Cutoffs are relative to each file's own distribution, scaling naturally.

**Why we rejected:** Elegant in theory but overkill for ~20 entries per file. Standard deviation is meaningless with small sample sizes. The simpler approach (sort by score, demote from bottom when cap exceeded) achieves the same practical result without the mathematical overhead. Studies also suggest that bloated memory/skill systems can degrade agent performance compared to no memory at all — complexity must pay for itself.

---

## The Attention Constraint

The most important insight from the design process: **the binding constraint on skills is AI attention, not context size or token cost.**

- **Token cost:** At 4000 skill tokens on Claude Opus ($15/M input), that's $0.06 per session. Negligible.
- **Context window:** Skills at 2% of 200K = 4K tokens. Nowhere near filling the window.
- **AI attention:** LLMs don't attend equally across their context. The "lost in the middle" effect means high attention at start and end, degraded in between. Skills compete with the spec and source code for the AI's effective attention window (~20-40K tokens for quality work).

This is why we rejected the elaborate token budget system and kept it simple: conditional file loading controls *which* files load (the big lever), and hard caps control *how many entries* per file (the small lever).

---

## Archive Design: The "Never Read" Principle

The archive went through three design iterations:

1. **Active lookup:** AI checks archive during demotion for existing entries, combines scores, potentially revives. **Problem:** Contradicts "AI never reads archive" — can't be both cold storage and active lookup.

2. **Pure graveyard:** AI writes, never reads. If a lesson recurs, it re-earns its place from scratch. **Problem:** Lessons that cycle between active and archive lose their accumulated evidence.

3. **Graveyard with periodic audit (adopted):** AI writes during normal operation (never reads). But every 5th demotion triggers an audit — the AI scans the archive once, groups similar entries, sums scores, and revives patterns. **Why this works:** The audit is event-driven (not every session), self-regulating (active projects audit more), and the counter prevents over-invocation. The archive is still "cold" 95% of the time.

---

## User Corrections as High-Signal

One design decision that emerged naturally: **user corrections should bypass the buffer entirely.**

When a user says "don't mock the database in these tests" or "use Y pattern instead of X," that's:
- Already validated by a human (the highest-quality signal)
- Often correcting a mistake the AI is about to repeat
- Time-sensitive — waiting for 3 sightings means the AI makes the same mistake 2 more times

So user corrections promote directly to skill files. Everything else goes through the buffer.

---

## What We Intentionally Left Out

- **Time-based decay:** We explored expiring candidates after N sessions unseen, but with only 15 candidate slots and zero context cost (never loaded during tasks), cap-based overflow is sufficient. Adding a decay cycle added complexity to manage a file that barely matters token-wise.
- **Decay formulas:** Score doesn't decay over time. The sort order (score desc, last_seen desc as tiebreaker) creates natural decay — stale entries sink to the bottom and get demoted when the cap is hit. No formula needed.
- **Dedicated housekeeping agent:** We added an `archy-housekeeper` subagent to handle skill lifecycle management at session end. This separates concerns — the builder builds, the housekeeper manages knowledge. In single-agent environments, it falls back to inline execution.
- **Cross-file score normalization:** A score of 3 in one file means the same as 3 in another. No relative weighting between files.
- **Automated conflict resolution:** When a new lesson contradicts an existing skill, the system flags it and asks the user. Auto-resolution is too risky for a knowledge system.
- **Per-project dynamic caps:** All projects use the same caps (15 candidates, 25 per skill file). The simplicity outweighs the marginal benefit of scaling caps with project size. If a project genuinely needs more, the user can adjust the numbers in the protocol copy.

---

## Summary

The v6.1 skill lifecycle is intentionally simple:

| Tier | File | Cap | Purpose |
|------|------|-----|---------|
| Candidates | `_candidates.md` | 15 | Prove yourself (score >= 3 to promote) |
| Skill Files | `skills/*.md` | 25 each | Proven, score-sorted, conditionally loaded |
| Archive | `_archive.md` | Uncapped | Human safety net, audited every 5 demotions |

The system errs on the side of *less* memory rather than more. A few high-quality, battle-tested lessons outperform a bloated collection of unvalidated tips. The buffer is the key innovation — it transforms lesson extraction from a single-pass judgment into an evidence-based process.
