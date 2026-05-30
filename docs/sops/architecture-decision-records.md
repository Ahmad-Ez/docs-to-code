# Architecture Decision Records (ADRs) SOP

A lightweight, durable record of significant architectural decisions. ADRs answer "why is the system shaped this way?" so future contributors (human or AI) don't relitigate settled choices — and know exactly what to revisit when constraints change.

---

## When to Write an ADR

Write one when a decision is hard to reverse, affects multiple modules, or constrains future work.

| Trigger | Examples |
| --- | --- |
| Persistence model | Postgres vs MongoDB; single-tenant vs multi-tenant schema |
| Authentication & sessions | NextAuth vs Clerk vs custom; JWT vs session cookies |
| Communication protocol | REST vs GraphQL vs tRPC; sync vs event-driven |
| Framework choice | Next.js App Router vs Pages; Express vs Fastify vs Hono |
| Infrastructure | Vercel vs self-hosted; SQS vs Kafka vs Redis Streams |
| Performance trade-offs | Eventual consistency vs strong; precompute vs on-demand |
| Hardware boundary | Inference on-device vs server-side; edge vs origin |
| Cross-cutting policy | Logging standard, error-handling convention, retry/backoff strategy |

**Do NOT write an ADR for**: file naming, code style, single-module implementation choices, library version bumps, anything reversible in under an hour.

---

## File Structure

- All ADRs live in `docs/adr/`.
- Filename: `NNNN-slug.md` — zero-padded sequential, hyphen-slug.
  - `0001-use-postgres-as-primary-store.md`
  - `0002-adopt-nextauth-v5.md`
- Numbers are never reused. Superseded ADRs keep their number and update Status.

---

## ADR Template

Copy this into a new `docs/adr/NNNN-slug.md`:

````markdown
# ADR-NNNN: {Short Title in Active Voice}

**Status**: Proposed
**Date**: YYYY-MM-DD
**Deciders**: {names or roles}
**Supersedes**: {ADR-XXXX, or "None"}
**Superseded-By**: {ADR-XXXX once deprecated, or "None"}

---

## Context

{2-5 paragraphs. What problem? What forces are at play? What constraints are real? Cite specific pressures, not generalities.}

---

## Decision

{1-3 paragraphs. Declarative. "We will use X." Unambiguous. A reader six months from now should be able to act on this sentence alone.}

---

## Consequences

### Positive
- {What gets better, faster, simpler, or safer}

### Negative
- {What gets harder, slower, or more expensive. Every decision has costs.}

### Neutral
- {Operational shifts, team-skill changes, vendor relationships}

---

## Alternatives Considered

### Alternative 1: {Name}
- **Summary**: {how it would have worked}
- **Why rejected**: {specific reason — cost, complexity, latency, lock-in}

### Alternative 2: {Name}
- **Summary**:
- **Why rejected**:

Minimum two alternatives.

---

## References

- {Spec files this ADR informs: `.archy/specs/05-auth.md`}
- {External docs, RFCs, benchmark links}
- {Related ADRs: ADR-0002, ADR-0007}
````

---

## Lifecycle

| Status | Meaning |
| --- | --- |
| **Proposed** | Drafted, under discussion. Not yet binding. |
| **Accepted** | Approved. The system MUST conform. Spec authors treat it as a constraint. |
| **Deprecated** | No longer recommended; not yet replaced. New work avoids it. |
| **Superseded** | Replaced by a newer ADR. Kept for history; do not delete. |

Status transitions are explicit edits to the ADR file. Supersession is bidirectional — update both ADRs when transitioning.

---

## Review Process

1. **Draft**: Author creates `docs/adr/NNNN-slug.md` with Status = Proposed. The Archy Architect can do this when a spec exposes a contradiction or new architectural axis.
2. **Discuss**: Share the file (PR, link, message). One other engineer reviews. For high-impact ADRs (data store, auth, compliance), require explicit sign-off from the responsible owner.
3. **Accept or revise**: Update Status to Accepted on merge. Keep negotiation in PR comments — the ADR reflects the final decision.
4. **Reference**: Once Accepted, downstream specs cite the ADR number in their `META.ADRs:` field.

---

## Integration with Archy

The Architect treats ADRs as **hard constraints**:

- Before drafting any spec, Architect reads `docs/adr/` to identify relevant ADRs (Architect's process Step 2 — Consult ADRs).
- Architect populates the spec's META `ADRs:` field with every relevant ADR number.
- If a spec would **contradict** an Accepted ADR, Architect halts and asks the user whether to (a) honor the ADR, or (b) draft a superseding ADR first.
- The Reviewer cross-checks the spec's `META.ADRs:` against the actual ADR files during Architectural Rigor Audit Step 6e.
- The Builder, when surfacing an architectural lesson, flags it `ADR-CANDIDATE:` in report notes (Builder's Step 7) — the Conductor routes it to the Architect for ADR drafting.
- The Debugger, when root cause is architectural, flags `ARCH-ROOT:` in report notes — the Conductor surfaces it to the Architect.

ADRs are write-only for the Architect (or human authors). Builder, Reviewer, Security Auditor, Housekeeper, and Debugger read but never write.
