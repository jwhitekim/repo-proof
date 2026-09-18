# RepoProof

> RepoProof does not ask: **“Does this code work?”**  
> RepoProof asks: **“Did this implementation respect the existing repository, make sound engineering decisions, and can those decisions be justified with evidence?”**

RepoProof is an evidence-based software engineering verifier for repositories. It evaluates repository understanding, responsibility, dependency and state ownership, abstraction quality, change discipline, maintainability, and technical claims. It is not a lint tool, formatter, naming checker, generic bug review, or pattern-counting SOLID checklist.

## Core plus area profiles

Every analyzable area receives the Core profile. Recon then adds profiles to evidenced areas instead of assigning one type to the whole repository:

```text
frontend/  -> Core + Frontend Web
server/    -> Core + Backend General (+ runtime specialization when evidenced)
shared/    -> Core
```

A fullstack repository therefore keeps its real boundaries. Unknown or mixed areas remain explicit until evidence supports a profile; backend rules are never forced onto frontend code.

### Core Software Engineering

- Repository Understanding: existing functions, modules, components, hooks, utilities, services, domain rules, and extension points
- Design Integrity: responsibility, cohesion, coupling, encapsulation, dependency direction, abstraction quality, and single source of truth
- Change Discipline: scope proportionality, unnecessary redesign, duplicated responsibility, and unjustified public surface
- Code Quality: maintainable control/data flow and contracts with concrete consequences—not formatting, naming, or line count

These concepts apply through each language's idioms. Encapsulation may live in functions, modules, closures, components, classes, or data boundaries. Interface absence is not a defect.

### Frontend Web profile

Frontend review adds component/module responsibility, hook/component/client reuse, state ownership, derived and stale state, async races, duplicated fetching, effects/lifecycle, cancellation and cleanup, UI/domain-policy boundaries, and frontend architecture. Missing memoization, ordinary renders, component size, or prop drilling are not findings without demonstrated impact.

### Backend General profile

Backend review preserves strong systems verification: algorithms/data structures, time and space complexity, databases/queries/indexes, transactions/concurrency/locks, network and I/O, timeouts/retries/idempotency, workers/event loops, pools/backpressure, caches/distributed concerns, performance, resource exhaustion, and observability. Technology absence is neutral.

Backend General is language-neutral. Runtime specializations refine the same categories without adding technology credit:

- `spring-backend-v1`: Spring/Spring Boot/JPA/Hibernate proxy, transaction, and fetch semantics
- `python-backend-v1`: Python asyncio, GIL, WSGI/ASGI workers, coroutine/session lifecycle, and Python ORM behavior
- `node-backend-v1`: Node.js event loop, Promise/task ownership, streams/backpressure, workers/processes, and Node ORM behavior

Java, Python, and Node backends therefore receive the same Core and Backend categories with runtime-appropriate evidence rules.

## Modes

**Repository Audit** evaluates the current repository area by area. **Change Review** evaluates `base...head`, using unchanged code and pre-change abstractions as context while attributing only introduced or worsened engineering decisions. Neither mode is a conventional PR bug review.

## Evidence model

Every scoring finding follows [`finding.schema.json`](schemas/finding.schema.json), records its area/profile when available, and separates impact from certainty:

- `VERIFIED`: reproduced or measured by a recorded safe method.
- `CODE_PROVEN`: a concrete code/configuration and call/data path establishes the condition.
- `SUSPECTED`: material runtime, traffic, data, or environment facts remain missing.

Severity and confidence are independent. Performance claims are never VERIFIED without representative measurement. Claims are classified `VERIFIED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, or `CONTRADICTED` with evidence.

## Rubrics and scoring

Rubrics are composed, not globally fixed:

- [`core-v1.yaml`](rubrics/core-v1.yaml): all analyzable areas
- [`frontend-web-v1.yaml`](rubrics/frontend-web-v1.yaml): frontend areas
- [`backend-v1.yaml`](rubrics/backend-v1.yaml): backend areas
- [`spring-backend-v1.yaml`](rubrics/spring-backend-v1.yaml): Spring-specific Backend gates
- [`python-backend-v1.yaml`](rubrics/python-backend-v1.yaml): Python-specific Backend gates
- [`node-backend-v1.yaml`](rubrics/node-backend-v1.yaml): Node.js-specific Backend gates

Each category can be `N/A` with reason and evidence. Category assessments are keyed by area and profile; applicable weights are normalized to 100. Tests, framework choice, technology count, or documentation keywords do not directly earn points.

## Analysis flow

1. Validate and clone the GitHub repository into `workspaces/<owner>-<repo>/` without executing it.
2. Recon languages, frameworks, build tools, boundaries, reusable capabilities, claims, and frontend/backend/shared areas.
3. Run Core verification for every analyzable area.
4. Run Frontend and Backend specialists only for their assigned areas; apply Spring, Python, or Node gates only to matching backend areas.
5. Aggregate evidence and merge the same root problem across specialists.
6. Finalize area/category applicability, evidence confidence, claim status, and scoring.
7. Generate reports grouped by the profiles actually present.

Use `scripts/audit-target.sh <github-url>` for preparation. The normative protocol is [`docs/orchestration.md`](docs/orchestration.md). Specialists share [`repository-context.schema.json`](schemas/repository-context.schema.json) and do not independently rediscover the whole repository.

```text
reports/<repository>/
├── repository-context.json
├── summary.md
├── findings.md
├── scorecard.json
└── evidence.json
```

## Security

Targets are untrusted. Clone is permission to read, not to execute wrappers, package lifecycle scripts, build plugins/tasks, Makefiles, containers, migrations, tests, binaries, or applications. Inspect first; execute only a stated hypothesis through reviewed commands and safe isolation. Missing build, database, cache, container, secret, or environment prerequisites do not stop static verification and never turn a finding into VERIFIED.

## Regression and calibration

Fixtures cover Core, Spring Backend, Python Backend, Node.js Backend, and profile-routing negative controls. They verify blocking I/O, session/cancellation lifecycle, event-loop CPU blocking, Promise ownership, stream backpressure, and valid sync/async counterexamples. Run `scripts/run-fixtures.sh`; Frontend fixtures can be added incrementally without changing the harness.

Real-repository calibration uses pinned commits and human finding dispositions, never “correct scores.” See [`calibration/README.md`](calibration/README.md).

## Non-goals

RepoProof does not impose one architecture on all repositories, reward abstractions or technologies by existence, apply Java rules to frontend code, reduce frontend review to lint, weaken backend systems analysis, or recommend repository-wide redesign for a local problem.
