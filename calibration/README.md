# Real-repository calibration

Calibration tests RepoProof behavior on real repositories after fixture regression passes. The first pinned target is Spring-based, but future targets should cover Core-only, Frontend, Java/Spring Backend, Python Backend, Node.js Backend, and fullstack area routing. Calibration does not assign a “correct” overall score. Review asks whether findings understand repository context, cite enough evidence, express uncertainty correctly, merge duplicate roots, route profiles correctly, avoid architectural ideology, and avoid missing material decisions.

## Safe workflow

1. Run `scripts/run-fixtures.sh`; do not calibrate a skill change while fixtures fail.
2. Select `targets.yaml` entry and verify the remote still contains the pinned commit. Never silently substitute current `main`.
3. Clone with the existing safe workflow and checkout the exact commit without executing repository code.
4. Follow `docs/orchestration.md`: recon first, applicable specialists second, evidence-scoring last. Runtime verification remains optional and separately authorized.
5. Store normal RepoProof artifacts beneath `calibration/results/<target>/report/`.
6. Copy `reviewed-findings.template.yaml` to `calibration/results/<target>/reviewed-findings.yaml`. A human classifies every merged finding as `valid`, `false_positive`, `needs_more_evidence`, `duplicate`, or `unclear`, with reasons and evidence notes. Record material missed findings too.
7. Compare patterns across targets and runs. Do not modify a rubric or skill merely to fit one repository.

## Review meanings

- `valid`: root problem, category, certainty, and evidence are defensible.
- `false_positive`: asserted problem is absent or rests on an invalid rule.
- `needs_more_evidence`: plausible, but certainty or impact exceeds evidence.
- `duplicate`: another accepted finding owns the same root decision and remediation.
- `unclear`: explicit additional context is needed for a decision.

Ambiguity is not hidden by lowering severity. Use `needs_more_evidence`, `SUSPECTED`, or an explicit insufficient-evidence note. Do not infer traffic, data distributions, or performance from source alone.

## Calibration-to-fixture loop

```text
real repository result
  -> human review identifies false positive or miss
  -> root reasoning failure is isolated
  -> minimal positive/negative fixture is added
  -> smallest relevant skill clarification is made
  -> complete fixture regression is rerun
  -> calibration is repeated at the pinned commit
```

Never add repository-name, organization, popularity, or project-specific exception rules. A famous repository is not presumed correct, and its score is not ground truth. Repeated reasoning patterns—not a single result—justify skill changes.

## Result layout

```text
calibration/results/<target>/
├── report/
│   ├── repository-context.json
│   ├── summary.md
│   ├── findings.md
│   ├── scorecard.json
│   └── evidence.json
└── reviewed-findings.yaml
```
