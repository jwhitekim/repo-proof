---
name: repository-understanding
description: Verify that implementations reuse and respect existing repository capabilities, boundaries, and sources of truth.
---

# Repository Understanding

## Start with

Consume the area map and change scope. For each new or evaluated behavior, state its responsibility in repository terms. Search semantic peers in the area and its shared dependencies: functions, modules, components, hooks, domain methods, services, utilities, clients, repositories, strategies, handlers, extension registrations, and tests that encode the same rule. Trace both old and new call paths.

## Orchestration contract

Receive the validated repository context, mode/revision, selected area/profile, and authorized runtime records. This is the first Core specialist for every analyzable area; propose N/A only when that area cannot be meaningfully assessed. Additional exploration is limited to semantic peers and call paths identified from context. Return area-scoped schema-valid findings and the existing-capability map used downstream.

## Findings

Report when evidence shows duplicated responsibility or business truth, an ignored active extension point, bypassed module/dependency direction, a repository convention conflict with behavioral consequences, or change scope disproportionate to the requirement. Show where paths diverge and how they can evolve differently. Use `repository_understanding` for capability/boundary failures and `change_discipline` for unnecessary scope, redesign, or public-surface expansion. In CHANGE mode, attribute only introduced/worsened divergence.

Do not report token-level duplication, similar names, intentional adapters, bounded-context separation, or an alternative whose different invariant/lifecycle is demonstrated. Do not demand reuse when the existing capability is inaccessible, deprecated, unsafe, or semantically different. Do not reward conformity for its own sake.

## Evidence required

Include both implementations or the bypassed extension point, reachable callers, ownership/invariant evidence, and the behavioral divergence risk. Use CODE_PROVEN only when the call path and overlap are established; otherwise SUSPECTED and list missing usage/runtime facts.

## Boundaries and output

Own repository reuse/change-discipline findings. Send invariant leakage to design-integrity, algorithm/runtime mechanics to cs-core, and persistence/concurrency impact to those specialists as evidence contributions. Emit finding-schema candidates plus `existing_capability_map`, `overlap_explanation`, and `cross_skill_evidence`; never duplicate the same root cause.
