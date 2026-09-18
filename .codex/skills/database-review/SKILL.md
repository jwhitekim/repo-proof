---
name: database-review
description: Verify backend-area query behavior, mappings, constraints, pagination, and index decisions against actual access patterns.
---

# Database Review

## Investigation

Run only for backend areas with persistence responsibility or a database claim. Trace area entry paths through repositories/data access to query shape and subsequent data access. Inspect framework-relevant mappings, generated/custom queries, batching, pagination, schemas, constraints, and indexes. Apply Spring/JPA-specific semantics only when the `spring-backend` specialization is assigned.

For `python-backend`, trace actual ORM evaluation and session/unit-of-work lifetime, including sync drivers used from async paths. For `node-backend`, trace promise-based query evaluation, transaction-client scope, relation loading, and pool ownership. Django/SQLAlchemy/Prisma/TypeORM method or relation declarations alone do not prove query count.

## Orchestration contract

Receive validated repository context, backend area, mode/revision, rubric/specializations, persistence/entry paths, capability map, claims, and authorized query/runtime records. Explore only mapped query, model/entity, migration, schema, and semantic callers in that area. Propose N/A when no persistence responsibility or database claim exists. Record area provenance.

## Findings

Accept evidenced N+1/query explosion, incorrect fetch plans, avoidable per-row writes, unsafe pagination, missing integrity constraints, or indexes demonstrably absent, redundant, misordered, low-value, or write-costly for the workload. Treat covering indexes and keyset pagination as contextual options, not defaults.

Never infer N+1 from `LAZY`/`EAGER` alone or demand an index for every `WHERE`. Do not assert offset cost without page depth/scale, or index benefit without query/data/workload evidence. Repository method names are not query plans.

## Verification

CODE_PROVEN can establish query multiplication from a concrete access loop and mapping. VERIFIED performance/index conclusions require recorded SQL/query count or an execution plan/benchmark with dataset and environment. Otherwise record SUSPECTED impact and missing inputs. Separate integrity constraints from concurrency strategy.

Own DB/query/index mechanics. Share transaction scope with transaction-concurrency and application CPU/allocation with application-performance. Emit finding candidates plus query-path, expected query count, schema/index evidence, measurement status, and minimal targeted query/schema remediation.
