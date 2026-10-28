# RepoProof

RepoProof helps reviewers assess engineering decisions with repository evidence: whether an implementation reuses existing capabilities, respects responsibilities and boundaries, and supports its technical claims.

It ships Codex skills, scoring rubrics, finding schemas, and regression fixtures. An audit produces a summary, findings with evidence and verification levels, and a scorecard in `reports/<repository>/`.

## Get started

You need Bash, Git, and a Codex agent with access to the target GitHub repository. From the RepoProof root, replace `OWNER/REPOSITORY` with your target:

```sh
./scripts/audit-target.sh https://github.com/OWNER/REPOSITORY.git
```

This prepares the workspace and report directory. Then ask Codex in the same RepoProof checkout, using the same target URL:

```text
Audit https://github.com/OWNER/REPOSITORY.git in Repository Audit mode.
Follow AGENTS.md and docs/orchestration.md and generate the final reports.
```

## Documentation

- [Agent principles and execution rules](AGENTS.md)
- [Audit and Change workflows, profiles, and report contracts](docs/orchestration.md)
- [Scoring rubrics](rubrics) · [Finding and report schemas](schemas)
- [Fixture regression](fixtures/README.md)
- [Real-repository calibration](calibration/README.md)

## License

No LICENSE file yet; license terms need confirmation.
