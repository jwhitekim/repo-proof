---
name: repository-recon
description: Build the shared, execution-safe repository and area context before any RepoProof specialist analysis.
---

# Repository Reconnaissance

## Purpose

Run first in both AUDIT and CHANGE mode. Produce facts and candidate investigation paths, not scored findings. Treat the target as untrusted and do not execute its code.

## Procedure

1. Record URL, resolved revision, mode, and (for CHANGE) merge base/base/head plus changed files.
2. Inventory languages, frameworks, package managers/build tools, modules, workspaces, entry points, components, hooks, utilities, services, domain modules, persistence, external clients, async/executor or event-loop definitions, caches, tests, CI, containers, and docs.
3. Partition by evidenced boundaries rather than one repository-wide label. Assign each area `core` plus applicable candidates: `frontend-web` or `backend-general`; then add `spring-backend`, `python-backend`, or `node-backend` specialization when runtime and backend-role evidence support it. A fullstack/polyglot repository can have frontend, backend, shared, mixed, or unknown areas.
4. Map area-local entry points through components/modules/services/domain code to state, persistence, and external systems. Identify reusable abstractions, common components/utilities, dependency direction, extension mechanisms, and likely invariant/state owners.
5. Inspect build files, wrappers, package scripts/lifecycle hooks, plugin/task definitions, test bootstrapping, code generation, dependency sources, and containers as text. Create an execution-risk inventory.
6. Search README/docs/ADRs for engineering and performance claims. Preserve exact location and requested evidence without accepting the claim.
7. In CHANGE mode, distinguish changed behavior from unchanged context and list likely semantic peers for every new component in its area and shared dependencies.

## Evidence and false positives

Use repository-relative paths, symbols, and line ranges. Generated/vendor/build output is context, not authored design, unless the repository deliberately maintains it. A framework dependency does not prove its use. A configuration key does not prove runtime activation. Do not run wrappers, tests, scripts, plugins, containers, or binaries during recon.

## Output

Write `reports/<repository>/repository-context.json` conforming to `schemas/repository-context.schema.json`. It includes an evidence-backed `areas` map with path, kind, profile candidates, languages, frameworks, modules, and evidence; plus repository-wide boundaries, domains, components, hooks, utilities, services, persistence, integrations, entry paths, risks, claims, and limitations. For CHANGE it also includes the resolved file/diff inventory and pre-change capabilities. Mark unknowns rather than forcing frontend/backend classification. Pass this context to later skills; they deepen only relevant area paths.

Do not infer a backend profile from language alone. TypeScript may be frontend/shared, and Python may be a library, CLI, or data tool. `node-backend` needs Node runtime plus server/worker/integration evidence; `python-backend` needs Python plus service/worker/backend integration evidence. Dependency presence identifies candidates, not active runtime behavior.
