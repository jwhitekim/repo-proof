---
name: evidence-scoring
description: Merge specialist evidence, decide applicability, calculate scores, and render RepoProof reports without fresh technical inspection.
---

# Evidence Scoring and Reporting

## Hard boundary

Run last. Do not inspect new technical paths or create novel technical findings. If evidence is insufficient, downgrade confidence/verification, return an evidence request, or omit the deduction; never fill gaps by intuition.

## Inputs

Require a validated `repository-context.json` with area/profile assignments, selected Core and optional profile rubrics, all specialist envelopes, claim ledger, runtime records, and mode/base/head. Use `docs/orchestration.md`. Validate every accepted finding and its area provenance. Do not reopen the repository to discover issues.

## Merge and normalize

1. Group candidates by violated invariant/decision, affected call/data path, and minimal remediation—not title or file alone.
2. Merge cross-category evidence into one primary finding; select the category closest to the root decision and retain secondary concepts/evidence. Preserve source ids in `merged_from`.
3. Normalize severity by plausible impact and scope. Keep confidence independent. VERIFIED requires reproduction/measurement; performance cannot be VERIFIED by static reasoning.
4. Reject style/lint items and technology-presence deductions.
5. In CHANGE mode, exclude unrelated legacy findings from change scoring, while retaining them only as context.
6. Do not merge separate area instances merely because they share a category; merge only the same root decision/path/remediation and retain all contributing areas.

## Applicability and scoring

Create category assessments per applicable area/profile. Core applies to every analyzable area; frontend and backend categories apply only to assigned areas; Spring, Python, and Node specializations refine Backend evidence gates without adding technology credit. N_A needs evidence and leaves the denominator. Score against selected rubrics; every deduction references finding ids and positive judgment references evidence ids. Compute:

`normalized = round(100 * applicable_earned / applicable_max, 1)`

Compute evidence coverage separately as supported weighted decisions divided by scored weighted decisions. It is not a bonus. Summarize raw category/group points, normalized overall score, runtime verification NONE/PARTIAL/FULL, and severity counts.

## Reports

Create the existing four reports beside repository context. Emit scorecard schema version 2.0 with `selected_profiles`, `profile`, and `area_path`; schema 1.0 remains readable only for legacy reports. Group the human summary by Core, Frontend, and Backend profiles actually present, then by area; omit absent profiles or explain N/A. `evidence.json` retains candidate-to-merged ids, skills, and area provenance. Validate scorecard and evidence references. Never hide uncertainty behind profile or overall scores.
