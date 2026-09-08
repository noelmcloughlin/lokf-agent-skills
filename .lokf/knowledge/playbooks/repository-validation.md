---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/repository-validation
title: Repository validation
description: What CI checks on every pull request and weekly - the repository contract, the Agent Skills spec, shell and workflow linting, the install smoke test, and Markdown/link/spelling checks.
genre: how-to
resource: .github/workflows/validate.yml
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
references:
  - https://lokf-agent-skills.example/knowledge/references/agent-skills-specification
  - https://lokf-agent-skills.example/knowledge/references/open-skills-cli
---

# Overview

`validate.yml` runs five jobs on every pull request, every push to `main`,
weekly, and on demand. `validate-skills` runs
`scripts/validate-repository.sh` (exactly four skill directories, a
case-correct `SKILL.md` in each, frontmatter `name` matching its directory, no
duplicate `SKILL.md`, and every relative Markdown link under `skills/`
resolving - fenced examples excluded) and then `gh skill publish --dry-run`.

`lint-scripts` runs ShellCheck; `lint-workflows` runs `actionlint`, which also
reaches the two workflow templates that get copied into other repositories;
`smoke-test` installs all four skills from the checkout into a throwaway
consumer repo via `scripts/smoke-test-install.sh`; `validate-markdown` runs
markdownlint, lychee, and codespell.

The weekly schedule exists because link rot, an upstream `gh skill` change, or
install-path drift would otherwise surface only on the next incidental pull
request.
