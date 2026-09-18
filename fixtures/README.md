# Fixture regression and calibration

Fixtures are deliberately small repositories that test finding precision, evidence quality, category ownership, profile routing, verification restraint, and false-positive suppression. They are not score goldens.

## Directory layout

Fixtures are grouped by verification responsibility and specialization, not merely by source language:

```text
fixtures/
├── core/
├── backend/
│   ├── general/
│   ├── spring/
│   ├── python/
│   └── node/
└── profile-detection/
```

`backend/spring` contains the Java/Spring implementations. A Java backend without Spring would belong under `backend/general` or a future Java-runtime specialization only when such specialization is justified.

## Core fixtures

| Fixture | Positive control | Principal negative controls |
|---|---|---|
| `duplicate-service` | an added service duplicates an established `DiscountPolicy` rule | no interface/factory/Redis/class-size advice |
| `interface-not-needed` | negative control with one stable concrete service | no interface/DIP/factory recommendation |

## Backend General fixtures

| Fixture | Positive control | Principal negative controls |
|---|---|---|
| `no-cache-needed` | negative control with a three-item in-process catalog | no Redis/cache recommendation |

## Spring Backend fixtures

| Fixture | Positive control | Principal negative controls |
|---|---|---|
| `lost-update` | two transactions can read and overwrite the same unversioned inventory state | no mandatory pessimistic-lock prescription |
| `n-plus-one` | `findAll()` results dereference a lazy collection in a mapped loop | LAZY alone is not evidence; no universal eager/index advice |
| `fake-performance-claim` | Redis cache code exists but the “80%” claim has no measurement | implementation must not verify the claim |

## Python Backend fixtures

| Fixture | Positive control | Principal negative controls |
|---|---|---|
| `asyncio-blocking-io` | blocking URL operation is reached inside an async request path | async or sync syntax alone is not blocking proof |
| `session-lifecycle` | request-created DB connection is never closed | no mandatory ORM, async driver, pool, or index |
| `cancellation-handling` | timeout returns while a shielded task retains a file | cancellation is not universally required |
| `sync-code-valid` | valid bounded synchronous backend handler | no async, multiprocessing, or worker-count prescription |

## Node.js Backend fixtures

| Fixture | Positive control | Principal negative controls |
|---|---|---|
| `event-loop-blocking` | request path performs two-million-round synchronous PBKDF2 | short sync work is not automatically a finding |
| `promise-lifecycle` | rejecting audit Promise loses ownership after response completion | missing `await` alone is not a defect |
| `stream-backpressure` | flowing producer ignores the response write signal | stream use itself is not a defect |
| `async-code-valid` | awaited fetch has timeout cancellation and timer cleanup | async does not imply race or worker-thread need |

`profile-detection/python-library` and `profile-detection/node-shared-library` are Core-only controls proving that language/runtime manifests alone do not imply a Backend profile.

Profile ownership is explicit in every `expected.yaml`. Future frontend fixtures can be added under `frontend/` using the same contract and harness.

Each directory contains minimal source/build files, `expected.yaml` (the normative contract), and `observed.yaml` (the checked-in, human-reviewed regression projection for the current skills). Fixture source is inspected as untrusted input; the harness does not compile or execute it.

## Expectation contract

`expected.yaml` follows `schemas/fixture-expectation.schema.json`. It declares applicable profiles, and each required finding specifies root concepts, category, minimum confidence, allowed verification levels, and minimum evidence references. Forbidden concepts/categories are active failures. `maximum_false_positives` is normally zero.

One `must_find` entry represents one merged root finding. For example, lost update must not appear once under CS and again under transactions. A finding not satisfying a required entry is unexpected even when it is not explicitly forbidden.

`observed.yaml` is a projection, not a replacement for `finding.schema.json` or the normal report:

```yaml
fixture: example
profiles: [core, backend-general]
findings:
  - id: RP-DB-001
    title: Concrete finding title
    category: database
    concepts: [n-plus-one]
    confidence: HIGH
    verification_level: CODE_PROVEN
    evidence: [path/one, path/two]
claims:
  - {id: claim-id, status: UNVERIFIED}
```

Run the reviewed baselines with:

```sh
scripts/run-fixtures.sh
```

For a fresh RepoProof run, export the projection as `<results>/<fixture>/regression.yaml` and run:

```sh
scripts/run-fixtures.sh --results <results>
```

The harness recursively discovers fixtures and checks required findings, forbidden concepts/categories, exact profile routing, category ownership, confidence, verification level, evidence count, claim status, unexpected findings, and maximum false positives. Failures distinguish missed findings, forbidden findings, wrong profiles, wrong verification levels, and wrong claim statuses.

## Development metrics

Output records Expected Findings, Found Expected Findings, Missed Findings, Unexpected Findings, Forbidden Findings, and Claim Verification Accuracy. It also reports directional precision (matched expected findings / all observed findings), recall (satisfied expectations / all expectations), and false-positive count.

These fixture counts are intentionally small. Their ratios are regression signals, not statistically stable quality estimates. Overall RepoProof score is not a fixture success criterion.

## Adding a regression

When calibration exposes a false positive or missed finding, isolate the decision and minimum evidence in a new fixture. Add strong `must_not_find` controls, update the skill minimally, then run the complete suite. Do not copy a real repository wholesale or add repository-name exceptions.

Future scenarios—unnecessary abstractions, ignored extension points, indexes, deadlocks, executor sizing, and cache stampedes—should be implemented when a concrete regression needs them.
