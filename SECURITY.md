# Security Policy

## Scope

This repository is mostly Markdown. Two things in it execute or are executed
by other systems, and are the actual attack surface:

- `skills/lokf-scaffolding/templates/scripts/knowledge-librarian.sh` and the
  two GitHub Actions workflow templates next to it
  (`skills/lokf-scaffolding/templates/github/*.yaml`) - these get **copied
  into other repositories** by the scaffolding skill and run there.
- This repository's own `.github/workflows/*.yml`, which run with a
  `GITHUB_TOKEN` on every PR and (for `publish.yml`) with `contents: write`
  behind a maintainer-approval environment.

## Reporting a vulnerability

Please use GitHub's
[private vulnerability reporting](https://github.com/noelmcloughlin/lokf-librarian-agent-skills/security/advisories/new)
rather than a public issue. Include:

- which file (a workflow template, the wrapper script, or this repo's own
  CI) and why it's exploitable;
- for a template that gets copied elsewhere, whether the issue is in the
  template itself or only manifests after a consumer repo customizes it.

## Supported versions

Only the latest published tag receives fixes. Point releases (patch) are
issued for security corrections; see [CHANGELOG.md](CHANGELOG.md).

## Repository hardening

- Pull requests require passing validation before merge; force-pushes and
  branch deletion are blocked on `main`.
- Secret scanning and push protection are enabled.
- `publish.yml`'s write scope is gated behind a `release` environment with
  required reviewers - no workflow can create a release unattended.
- Third-party Actions are pinned to a reviewed commit SHA (not a floating tag)
  in every workflow, including the templates under
  `skills/lokf-scaffolding/templates/github/`.
- Dependency review, Dependabot, and CodeQL are intentionally **not**
  enabled: this repository has no dependency manifests or compiled code to
  scan. If that changes (e.g. the wrapper script grows a real dependency),
  add them then rather than carrying unused overhead now.
