---
name: frontend-review
description: Verify frontend component, state, lifecycle, async, reuse, and architecture decisions in mapped frontend areas using framework-specific evidence.
---

# Frontend Review

## Inputs and scope

Run only for areas assigned `frontend-web`, after Core repository-understanding. Receive the area map, languages/frameworks, components, hooks, utilities, API clients, routes/entry paths, capability map, change scope, claims, and authorized runtime evidence. Inspect semantic neighbors required to prove a path; do not rediscover the whole repository.

## Repository understanding and design

Search before judging new frontend code: existing hooks, utilities, API clients, components, state modules, framework extension points, and shared domain logic. Report semantic reimplementation only when responsibilities and callers overlap and divergence is plausible.

Evaluate component/module responsibility, cohesion, coupling, change isolation, and the UI/domain-policy boundary. A large component is not a finding by size; show distinct coupled responsibilities. A custom hook, wrapper, context, provider, or abstraction is not good or bad by existence—show whether it isolates a real lifecycle/state concern or adds an unjustified parallel layer. Prop drilling is a finding only when it creates a demonstrated coupling or change problem.

## State

Trace state ownership and updates. Look for duplicated sources of truth, stored derived state that can diverge, stale closures/state, conflicting global and local ownership, and state whose lifecycle does not match its consumer. Do not require a global store, reducer, or particular library without repository evidence.

## Lifecycle and async

Trace effects, subscriptions, timers, event listeners, requests, navigation/unmount paths, and overlapping operations. Report missing cleanup, stale request results, races, duplicate fetching, incorrect effect semantics, or missing cancellation only when the path can outlive, overlap, or update the wrong owner. Dependency arrays or framework APIs alone do not prove a defect.

## Performance restraint

Do not report missing memoization, missing `useCallback`, ordinary rendering, component size, or collection transforms without materiality. A performance finding needs measurement or a concrete structural amplification path; impact remains SUSPECTED without workload/runtime evidence. Classify frontend technical/performance claims with the shared VERIFIED/PARTIALLY_VERIFIED/UNVERIFIED/CONTRADICTED states; implementation alone does not verify improvement.

## Output and ownership

Use frontend categories `frontend_responsibility`, `frontend_state`, `frontend_async_lifecycle`, or `frontend_architecture`. Every finding records `area.path` and `area.profile: frontend-web`, evidence, confidence, verification level, and minimal remediation. Core semantic duplication remains owned by repository-understanding; merge shared root causes rather than double-deducting. Return N_A only when the mapped area lacks relevant frontend behavior, with evidence and reason.
