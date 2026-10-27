# RepoProof

RepoProof is an agent-driven reviewer for engineering decisions. Instead of asking whether code works, it checks whether an implementation reuses what the repository already has, keeps responsibilities and state in the right place, and backs its technical claims with evidence.

It ships Codex skills, scoring rubrics, finding schemas, and regression fixtures.

## What it checks

- **Repository context:** existing capabilities, extension points, boundaries, change scope
- **Design:** responsibility, dependencies, abstractions, control flow, contracts
- **Area-specific:** frontend state and lifecycle; backend data access, concurrency, I/O, caching, performance

Core checks apply to every analyzable area. Frontend and Backend profiles apply where repository evidence supports them. Spring, Python, and Node.js specializations refine Backend checks.

Each finding is labeled `VERIFIED` (reproduced), `CODE_PROVEN` (established from code), or `SUSPECTED` (needs more evidence). Performance claims require measurement. Style preferences don't affect the score.

## Get started

You need Bash, Git, and a Codex agent. From the RepoProof root:

```sh
./scripts/audit-target.sh https://github.com/OWNER/REPOSITORY.git
```

This clones the target into `workspaces/<owner>-<repository>/` and prepares `reports/<repository>/`. It stops if the workspace already exists, and it does not install or run target code. Then ask Codex:

```text
Audit https://github.com/OWNER/REPOSITORY.git in Repository Audit mode.
Follow AGENTS.md and docs/orchestration.md and generate the final reports.
```

Treat targets as untrusted: before running their builds or tests, follow the execution rules in [AGENTS.md](AGENTS.md). For **Change Review**, give a prepared workspace and explicit base and head refs; only introduced or materially worsened decisions are scored. See [docs/orchestration.md](docs/orchestration.md).

Reports land in `reports/<repository>/`: `summary.md`, `findings.md`, `scorecard.json`, `evidence.json`, and `repository-context.json`.

## Documentation

- [Agent principles and execution rules](AGENTS.md)
- [Analysis order, profiles, report contracts](docs/orchestration.md)
- [Rubrics](rubrics) · [Schemas](schemas)
- [Fixture regression](fixtures/README.md) · [Real-repository calibration](calibration/README.md)

## License

No LICENSE file yet; license terms need confirmation.
