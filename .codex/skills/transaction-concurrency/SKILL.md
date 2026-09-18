---
name: transaction-concurrency
description: Verify backend transaction semantics, race control, atomicity, locking, contention, and deadlock risks, with Spring gates when applicable.
---

# Transaction and Concurrency

## Investigation

Run only for backend areas with shared mutable state, transaction boundaries, or concurrency claims. Trace competing entry paths, transaction boundaries, isolation assumptions, read-modify-write sequences, constraints/versioning, atomic updates, external work inside transactions, lock scope/order, and the runtime concurrency model. For `spring-backend`, additionally trace actual proxy call sites, propagation, rollback rules, self-invocation, and async boundary semantics from the Spring rubric.

For `python-backend`, include coroutine interleavings, task-local/session context, worker retries, and sync/async unit-of-work boundaries. For `node-backend`, include interleavings across `await`, transaction callbacks/clients, requests, workers, processes, and consumers. Neither runtime model removes database or distributed races.

## Orchestration contract

Receive validated repository context, backend area, mode/revision, rubric/specializations, shared-state paths, capability map, persistence evidence, and authorized runtime records. Explore only competing paths needed to establish atomicity. Propose N/A when the area has no shared-state transaction/concurrency responsibility. Record area provenance and explicit interleaving evidence or limitations.

## Findings

Accept lost update, reachable check-then-act races, proxy boundaries that defeat intended transactions, overly broad transactions holding DB resources across remote I/O, missing final constraint for a uniqueness invariant, unjustified strong locks, contention, or conflicting lock order. Explain interleaving and invariant violated.

Do not penalize missing locks without a concurrency hazard. Do not assume `@Transactional` applies through self-invocation or that every remote call in a transaction is material; trace it. Do not prescribe optimistic/pessimistic locking when an atomic statement or unique constraint is the smaller defense.

## Evidence

CODE_PROVEN requires concrete competing paths/interleaving and persistence semantics. VERIFIED requires a controlled reproduction or database/runtime evidence. Deadlock likelihood or production contention usually remains SUSPECTED without workload/DB evidence. Record isolation and database assumptions explicitly.

This skill owns atomicity and transaction-boundary findings. Database-review supplies query/constraint facts; cs-core owns non-transactional thread-safety mechanics. Output finding candidates, interleaving diagrams in text, evidence ids, reproduction needs, and the minimum atomic/boundary change.
