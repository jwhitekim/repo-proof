---
name: application-performance
description: Evaluate material backend-area application performance decisions without unsupported micro-optimization claims.
---

# Application Performance

## Investigation

Run only for `backend-general` areas. Use area paths and measurement evidence to identify plausible hot paths. Inspect allocation and collection pipelines, serialization, batching, blocking I/O, async/worker configuration, pool relationships, and persistence-framework work not owned by database-review. Apply JPA-specific gates only under `spring-backend`.

Under `python-backend`, relate CPU-bound work, GIL behavior, worker/process count, blocking ratio, and process memory to an evidenced path. Under `node-backend`, relate synchronous CPU work, serialization, worker threads/processes, event-loop delay, and pool concurrency. Do not prescribe multiprocessing, worker threads, or async conversion without materiality.

## Orchestration contract

Receive validated repository context, backend area, mode/revision, rubric/specializations, relevant paths/claims, upstream evidence, and authorized measurements. Explore only plausible hot paths in that area. Propose N/A when no material performance responsibility or claim can be assessed. Record area provenance; unmeasured impact remains uncertain.

## Findings

Report only a concrete cost mechanism with plausible materiality: repeated full-data copies on a high-volume path, missing batch at established volume, blocking tasks saturating a bounded worker pool, async that only shifts/expands queues, or serialization/allocation confirmed by profiling. Separate mechanism from measured magnitude.

Do not claim streams are inherently slow, replace loops for taste, flag ordinary allocations, or call an implementation faster because it is async/cached/batched. A benchmark must represent the relevant workload and environment.

## Evidence and overlap

VERIFIED performance requires before/after measurements or profiling with revision, dataset, workload, environment, warm-up, metric, and results. Static analysis can make a resource mechanism CODE_PROVEN but performance impact is SUSPECTED. Database query counts belong to database-review; generic executor safety to cs-core; measurements/claims to observability. Merge shared causes.

Output finding candidates plus hot-path rationale, cost model, measurement quality, missing data, and minimal remediation or measurement experiment.
