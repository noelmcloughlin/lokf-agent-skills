---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/releasing
title: Releasing
description: The maintainer-gated release path - a workflow_dispatch run of publish.yml that validates the version, re-checks the contract and spec, then lets gh skill publish create the tag and release.
genre: how-to
resource: .github/workflows/publish.yml
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
dependsOn:
- https://lokf-agent-skills.example/knowledge/references/gh-skill-cli
references:
  - https://lokf-agent-skills.example/knowledge/policies/versioning
  - https://lokf-agent-skills.example/knowledge/playbooks/repository-validation
verified:
- by: process:lokf-librarian
  at: "2026-09-09T12:00:00Z"
---

# Overview

Releases are never tag-triggered. `gh skill publish` creates the tag *and* the
GitHub release itself, so a tag-push trigger would race the tag the command is
about to create; `workflow_dispatch` keeps the timing an explicit human
decision, and the `release` environment adds a maintainer-approval gate in
front of the `contents: write` scope.

Each run validates that the input is `vMAJOR.MINOR.PATCH` and that the tag does
not already exist, re-runs the repository contract and `gh skill publish
--dry-run`, and only then publishes. All four skills ship together under one
tag, so a consumer can pin them to a single release.
