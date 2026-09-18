# RepoProof Orchestration Protocol

This protocol connects existing skills, composable rubrics, and reports. An orchestrating agent performs verification; shell entrypoints only validate input, clone without executing target code, and prepare paths.

## Canonical artifacts

```text
workspaces/<owner>-<repository>/
reports/<repository>/
├── repository-context.json
├── summary.md
├── findings.md
├── scorecard.json
└── evidence.json
```

`repository-context.json` is the only required intermediate file. It contains the shared area map. Do not create independent per-skill discovery trees.

## Ordered protocol

1. **Validate and clone.** Accept a GitHub HTTPS URL, use the safe clone helper, and execute no target code.
2. **Repository recon.** Inspect source, boundaries, manifests/build tools, scripts, configuration, docs, and claims as text.
3. **Detect areas.** Map evidence-backed frontend, backend, shared, mixed, or unknown areas. Record paths, languages, frameworks, modules, capabilities, dependencies, and profile candidates.
4. **Resolve profiles.** Assign `core` to every analyzable area. Add `frontend-web` or `backend-general` only where evidence supports them. Add `spring-backend`, `python-backend`, or `node-backend` only to matching Backend areas; every specialization requires Backend.
5. **Core verification.** Run repository-understanding first for each area and shared dependencies, then design-integrity and code-quality from the same context/capability map.
6. **Profile verification.** Run frontend-review for frontend areas. Run applicable Backend specialists for backend areas. Apply only the evidenced Spring/Python/Node runtime gates. Specialists may deepen relevant paths, not rescan the repository indiscriminately.
7. **Collect candidates.** Each finding validates against `finding.schema.json`, includes area/profile provenance, and cites evidence. Specialists return N/A proposals for inapplicable categories without technology-absence findings.
8. **Merge roots.** Group by violated decision/invariant, reachable path, area relationship, and remediation—not title/category. Preserve contributing skills and areas. One root causes one deduction.
9. **Validate certainty.** Reconcile severity, confidence, and verification. Missing runtime evidence never upgrades a finding; performance needs measurement.
10. **Finalize applicability.** Create an assessment for each applicable area/profile/category. N/A requires evidence and leaves the denominator.
11. **Evidence scoring.** Provide context, selected rubrics, all specialist envelopes, claims, executions, and limitations. Scoring may normalize/reject supplied candidates but discovers no new problem.
12. **Generate reports.** Group summary and scorecard by profiles actually present and area; validate ids and evidence links.

## Area and profile examples

The snippets below abbreviate the full repository-context schema.

### Spring backend repository

```yaml
areas:
  - path: .
    kind: BACKEND
    profiles: [core, backend-general, spring-backend]
```

Core and Backend categories score; Spring adds framework-specific evidence gates, not technology credit.

### Python backend repository

```yaml
areas:
  - path: .
    kind: BACKEND
    profiles: [core, backend-general, python-backend]
```

Python gates refine asyncio/blocking, GIL/worker, cancellation, session, and ORM reasoning.

### Node.js backend repository

```yaml
areas:
  - path: .
    kind: BACKEND
    profiles: [core, backend-general, node-backend]
```

Node gates refine event-loop, Promise/task, stream/backpressure, worker, transaction-client, and ORM reasoning.

### React frontend repository

```yaml
areas:
  - path: .
    kind: FRONTEND
    profiles: [core, frontend-web]
```

Database, transaction, Redis, and backend resource categories are not applied.

### Fullstack repository

```yaml
areas:
  - {path: frontend/, kind: FRONTEND, profiles: [core, frontend-web]}
  - {path: server/, kind: BACKEND, profiles: [core, backend-general, node-backend]}
```

Shared dependencies are mapped explicitly; findings attach to the area owning the root decision.

### Shared TypeScript library

```yaml
areas:
  - {path: packages/shared/, kind: SHARED, profiles: [core]}
```

Do not infer Frontend merely from TypeScript or Backend merely from Node-compatible code.

## Audit and Change

Audit evaluates current area states. Change uses the same pipeline but context must include requested/resolved base/head, merge-base, added/modified/renamed/deleted files, diff, and pre-change implementations/capabilities. Changed files inherit the profile of their owning area. Shared changes may affect several consumers, but findings still identify the root area and only introduced or worsened decisions are scored. This is not generic PR bug review.

## Specialist envelope

Each specialist receives validated context, one target area, selected profiles/rubrics, relevant upstream capability maps, mode/range, claims, and authorized runtime results. It returns:

```json
{
  "skill": "frontend-review",
  "area": {"path": "frontend/", "profiles": ["core", "frontend-web"]},
  "status": "COMPLETED",
  "applicability": {
    "status": "APPLICABLE",
    "reason": "Client state and component lifecycle paths are present.",
    "evidence_ids": ["EV-CTX-021"]
  },
  "findings": [],
  "evidence": [],
  "non_findings": [],
  "limitations": []
}
```

Status is `COMPLETED`, `PARTIAL`, or `NOT_RUN`; applicability is `APPLICABLE` or `N_A`. N/A requires reason/evidence and cannot create an adverse finding for missing technology.

## Routing matrix

| Skill | Profile | Runs when area context shows |
|---|---|---|
| repository-understanding | core | every analyzable area/change |
| design-integrity | core | responsibilities, dependencies, state/policy ownership, or abstractions |
| code-quality | core | executable implementation whose flow/contracts can be assessed |
| frontend-review | frontend-web | UI/component, client state, hooks/lifecycle, or frontend framework paths |
| cs-core | backend-general | algorithm/runtime/network/I/O/distributed paths |
| database-review | backend-general | persistence responsibility or database claim |
| transaction-concurrency | backend-general | shared state, transaction/concurrency boundary, or claim |
| application-performance | backend-general | material backend hot path or performance claim |
| observability | backend-general | operated backend behavior or measurement claim |
| cache-redis | backend-general | backend cache implementation/proposal/claim or evidenced need |

`spring-backend`, `python-backend`, and `node-backend` change how applicable Backend/Core paths are interpreted. They add no score merely for a runtime or framework. A polyglot backend area may use more than one specialization only when separate runtime paths are evidenced; findings remain attached to the owning path.

## Duplicate handling

Merge candidates when they share the same violated decision/invariant, reachable failure or divergence path, and minimal remedy. Category, file, or wording alone is not identity. Select the category/profile closest to the root decision, combine non-duplicate evidence, use the highest defensible—not proposed—severity, and preserve source candidate ids, skills, and areas in `evidence.json`. Do not merge separate area-local problems merely because their symptoms match.

## Runtime limitations

Runtime status is `NOT_REQUESTED`, `AVAILABLE`, `PARTIAL`, `UNAVAILABLE`, or `FAILED`. Record hypothesis, command, revision, environment/isolation, output, and limitation. Missing package install, build, browser, Docker, database, Redis, secret, or environment prerequisites never abort safe static verification. Use `NOT_RUN`/`BLOCKED` and lower certainty; inability to execute never proves a finding.

## Evidence-scoring input and output

Input is limited to validated area context, selected rubrics, specialist envelopes, candidate evidence/non-findings/applicability, claim ledger, runtime records, and limitations. Evidence-scoring does not reopen technical discovery.

For every area/profile/category assessment, deductions reference merged finding ids and positive/N/A judgments reference evidence. Normalize all applicable assessment weights. `summary.md` groups Core, Frontend, and Backend sections only when present; runtime specializations appear as applied context, not extra score groups. `scorecard.json` records profile and area path when available. `findings.md` contains merged findings, and `evidence.json` preserves provenance.
