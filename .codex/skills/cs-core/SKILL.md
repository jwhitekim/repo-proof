---
name: cs-core
description: Verify applied CS, runtime, network, I/O, and distributed-system fundamentals on reachable backend-area paths.
---

# CS Core

## Investigation

Run only for `backend-general` areas. Starting from area entry paths, inspect data size and loop nesting, collection semantics, shared mutable state, event loops/workers/executors and queue bounds, resource lifecycle, blocking behavior, client timeouts/retries, idempotency, backpressure, and partial-failure assumptions. Establish reachability and realistic input/concurrency bounds.

## Orchestration contract

Receive validated repository context, backend area, mode/revision, rubric/specializations, relevant capability/entry-path maps, and authorized runtime records. Explore only that area's reachable algorithm, resource, network, I/O, concurrency, or distributed paths. Propose N/A when no relevant backend behavior is in scope. Use `cs_fundamentals` for algorithm/runtime fundamentals and `network_io` for network, I/O, pool, timeout, retry, or resource-lifecycle roots. Record area provenance.

## Findings

Accept avoidable material O(N²), unsuitable collections with demonstrated scale, unbounded threads/queues, resource leaks, retry amplification or duplicate effects, missing timeout on a reachable remote call, blocking work mismatched to executor capacity, and incorrect consistency/idempotency assumptions. State the failure mechanism and constraints.

Do not flag all nested loops, streams, copying, blocking I/O, missing retries, or mutable state. Small bounded collections and simple sequential code can be correct. Backoff matters only where retries are justified. Never invent production scale.

## Runtime specialization gates

When assigned `python-backend`, apply the Python rubric to asyncio task/cancellation ownership, blocking calls on event-loop paths, GIL-sensitive CPU work, WSGI/ASGI worker capacity, and process/queue bounds. Do not treat synchronous code or the GIL as defects by themselves.

When assigned `node-backend`, apply the Node rubric to event-loop blocking, promise/background-task ownership, timer/listener lifecycle, stream backpressure, worker/process boundaries, and async interleavings. “Single-threaded” does not disprove races; an unawaited promise does not prove one.

## Evidence and overlap

Evidence includes the reachable path, operation complexity/resource bound, input origin or missing runtime bound, and failure outcome. Measurement is required to verify performance impact; static mechanics may be CODE_PROVEN while magnitude stays SUSPECTED. Transactional races belong to transaction-concurrency; DB round trips to database-review; hot-path cost to application-performance. Contribute shared evidence and let scoring merge a common root cause.

Output schema-compatible candidates with complexity/resource models and reproduction prerequisites. Minimal remediation should bound, select, close, or make idempotent the existing mechanism.
