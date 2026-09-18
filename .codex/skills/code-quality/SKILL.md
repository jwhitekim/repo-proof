---
name: code-quality
description: Verify maintainable implementation structure and contracts across languages without turning RepoProof into lint or style review.
---

# Code Quality

## Scope

Apply the Core profile to each mapped area after repository-understanding. Inspect implementation-level maintainability that is not owned by architecture specialists: control and data flow, API and error contracts, resource ownership, hidden side effects, local duplication, and complexity that creates a concrete change or verification cost.

Use the language and framework's idioms. Functions, modules, closures, components, classes, and data pipelines can all express responsibility and encapsulation; Java class structure is not the default model.

## Findings

Accept a finding only when a reachable implementation has a specific maintenance or reliability consequence—for example, two local paths encode a policy differently, resource ownership is unclear enough to leak, an error contract is silently discarded across callers, or tangled branching makes an invariant untraceable. Show callers, state/data flow, and the consequence.

Do not score formatting, naming, line count, generic complexity thresholds, comment density, test count, missing interfaces, or personal idiom preferences. Do not duplicate repository-understanding's existing-capability finding or design-integrity's responsibility/dependency finding; contribute evidence to the root owner.

## Orchestration contract

Receive the validated area map, Core rubric, capability map, mode/change scope, and authorized runtime evidence. Explore only paths needed to establish the implementation consequence. Return the standard specialist envelope with area-scoped, schema-valid findings, non-findings, evidence, limitations, and applicability. Prefer minimal remediation that clarifies the existing flow or contract.

