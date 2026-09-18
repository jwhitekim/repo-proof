---
name: cache-redis
description: Evaluate backend cache and Redis decision quality, consistency, failure behavior, and operational evidence.
---

# Cache and Redis

## Applicability first

Run only for backend areas. From area context, identify actual access patterns, latency/load constraints, source of truth, and cache implementation, claim, or proposed need. If none exists, recommend N/A with evidence; never penalize cache or Redis absence.

## Orchestration contract

Receive validated repository context, backend area, mode/revision, rubric/specializations, cache/access paths, capability map, claims, and authorized runtime records. Explore only that area's cache lifecycle, source of truth, callers, and origin. When no cache implementation/proposal/claim or evidence-backed need exists, return N_A—never a cache recommendation. Record area provenance.

## Investigation and findings

Trace keys and tenancy, TTL rationale, invalidation/write ordering, stale-data tolerance, serialization/versioning, hit/miss behavior, penetration, concurrent misses/stampede, hot keys, fallback during Redis failure, network overhead, and DB/cache ownership. Report a finding only with a reachable inconsistency/failure/load path or evidence that remote caching adds unjustified complexity/cost.

Do not demand cache-aside, TTL, distributed locks, or Redis universally. No hit-ratio metric does not alone prove a bad cache. Stampede requires concurrent miss potential and costly origin behavior. Eventual consistency may be an explicit valid tradeoff.

## Evidence and overlap

Establish access path, concurrency model, key lifecycle, source of truth, and business tolerance. VERIFIED performance benefit requires representative before/after measurement and hit ratio; implementation is not proof. Consistency mechanics can be CODE_PROVEN, while traffic impact may remain SUSPECTED.

Own cache decision/consistency findings. Database load mechanics go to database-review, general partial failure/idempotency to cs-core, and performance claims to observability. Output candidates, cache lifecycle map, applicability rationale, claim evidence, and minimal correction (including removal when that is smallest).
