---
name: design-integrity
description: Evaluate responsibility, invariant ownership, dependencies, layers, and abstractions in repository context.
---

# Design Integrity

## Investigation

Use the area map and existing-capability map. Trace ownership of invariants or state, dependencies, public API expansion, and reasons functions/modules/components/classes change. Compare abstractions with actual variants and call sites using the language and framework's idioms.

## Orchestration contract

Receive validated repository context, mode/revision, rubric/profile, repository-understanding capability map, and authorized runtime records. Explore only relevant owners, callers, dependencies, and variants. Propose N/A when no meaningful service/domain/layer or abstraction decision is present. Return the standard specialist envelope; every finding must independently validate against `schemas/finding.schema.json`.

## Findings

Accept concrete cases such as one policy maintained in multiple owners, infrastructure concerns entering domain code, UI and domain policy becoming inseparable, a module/service/component coupling unrelated change reasons, speculative wrappers/factories/interfaces/hooks with no demonstrated variation, or bypassed extension mechanisms. Describe the real consequence, never just a principle name.

Reject “class/component is long,” “SRP violation,” “anemic model,” “needs interface,” or layer preferences without repository-specific responsibility and change evidence. Functions, closures, modules, components, classes, and data pipelines can all provide encapsulation. Tests or mocks alone do not mandate an interface.

## Proof and coordination

Evidence must identify owner(s), callers, dependencies, duplicated policy/invariant, and consequence. Prefer CODE_PROVEN for static dependency and duplicate-policy paths; use SUSPECTED when future-change or organizational assumptions dominate. Repository-understanding owns pre-existing-capability bypass; this skill contributes design evidence. Concurrency/database consequences go to their owners and are merged later.

Output finding-schema candidates, evidence ids, a responsibility map, and explicit non-findings that prevented false positives. Remediation should consolidate ownership or narrow a boundary with minimal changes, not prescribe wholesale architecture.
