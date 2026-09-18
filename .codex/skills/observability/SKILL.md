---
name: observability
description: Verify backend operational evidence, measurements, benchmarks, and documented technical claims.
---

# Observability and Measurement

## Investigation

Run for backend areas with operated behavior or technical claims. Consume the area-linked claim inventory. Map metrics, logs, traces, latency percentiles, throughput, errors, query counts, pool/runtime metrics, load tests, benchmark artifacts, and reproducibility instructions to critical paths and claims.

Apply runtime gates when present: Python multiprocess/worker aggregation and async task errors; Node process/worker aggregation, rejected/background promises, and request-context propagation. Tool absence alone remains neutral.

## Orchestration contract

Receive validated repository context, backend area, mode/revision, rubric/specializations, technical-claim ledger, critical paths, and authorized measurements. Explore only artifacts needed for that area's operational paths and claims. Propose N/A when no backend operational or claim-verification responsibility exists. Record area provenance and updated claim statuses; implementation alone is not measurement.

For every claim capture text/location, implementation evidence, benchmark or runtime evidence, before/after revisions, workload, dataset, environment, metric definition, repetitions/warm-up, and missing evidence. Classify as VERIFIED, PARTIALLY_VERIFIED, UNVERIFIED, or CONTRADICTED.

## Findings

Report material blind spots only where a critical behavior, asserted SLO, operational decision, or optimization cannot be validated or diagnosed. Unsupported quantitative performance claims are findings/claim records. Observability tooling absence by itself is not a defect.

An implementation proves mechanism, not result. A single local timing does not prove production p95/p99 or throughput. Logs are not automatically useful metrics; tests are not benchmarks. Do not invent a need for tracing in a simple service without distributed paths.

## Verification and output

Performance claims become VERIFIED only with reproducible before/after evidence appropriate to the claim. PARTIALLY_VERIFIED means some components are demonstrated but the stated magnitude/scope is not. CONTRADICTED needs contrary evidence, not mere absence.

Own claim status and measurement-quality findings; specialists own underlying DB/cache/application defects. Output schema-compatible candidates, a claim ledger, evidence gaps, evidence coverage contributions, and runtime-verification status.
