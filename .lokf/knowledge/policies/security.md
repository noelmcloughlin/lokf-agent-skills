---
type: Policy
id: https://lokf-agent-skills.example/knowledge/policies/security
title: Security policy
description: The actual attack surface (copied-into-other-repositories templates, this repo's own CI, the four skills' own prose read by an LLM agent), that a skill's `Scope:` line is advisory except on the scheduled workflow, how to report privately, and this repository's hardening and prompt-injection guards.
genre: reference
resource: SECURITY.md
generated:
  by: process:lokf-librarian
  at: "2026-09-10T00:00:00Z"
status: draft
references:
  - https://lokf-agent-skills.example/knowledge/playbooks/repository-validation
verified:
- by: process:lokf-librarian
  at: "2026-09-10T00:00:00Z"
---

# Overview

Three things execute: the wrapper script and workflow templates that get
copied into *other* repositories and run there, this repository's own
workflows, and the four skills' `SKILL.md`/`references/` prose - executed by
whichever LLM agent runs it. Vulnerabilities go through GitHub private
vulnerability reporting, not public issues.

A skill's `Scope:` line is prose, not an enforced boundary - the Agent
Skills format has no permission manifest, so an installed skill runs with
whatever tool access the calling agent session has (the same warning
`npx skills` prints after every install). Only the scheduled workflow
technically checks its scope (below); interactive sessions rely on a person
reviewing what the agent changed before committing or merging.

Hardening: third-party Actions pinned to reviewed commit SHAs everywhere
including the templates, `persist-credentials: false`, least-privilege
`permissions`, harden-runner in audit mode (`validate.yml`, `publish.yml`), a
maintainer-approved `release` environment gating `publish.yml`'s write scope,
and `knowledge-librarian.yaml`'s agent step always running the pinned wrapper
script directly - the `AGENT_CLI` repository variable can only choose which
agent runs, never what command runs. That workflow is now split into two
jobs by least privilege: `refresh` runs the agent - third-party code - with
`contents: read` and no persisted git credentials, and hands its proposed
bundle change to `publish` as a patch artifact; only `publish`, which runs no
agent code, holds `contents: write` / `pull-requests: write`, so a compromised
agent cannot reach a write-scoped credential. Top-level workflow permissions
default to none. The run stays inert until the `KNOWLEDGE_LIBRARIAN_ENABLED`
repository variable is set to `true`. Dependabot covers this repository's own
workflows but cannot reach the templates - a documented upstream limitation,
so those pins are bumped by hand. Dependency review and CodeQL are
deliberately absent: there is no dependency manifest or compiled code here to
scan.

Prompt-injection guards, one per input path an agent reads but didn't author:
lokf-librarian resolves a `.lokf/feedback.md` entry only from the source it
names, never from the entry's own wording; lokf-curator quotes a fetched
`resource`/`sources` to the human rather than ever acting on it itself; lokf-docent
treats fetched source or repository content as text to quote, never as
instructions, and is read-only on the bundle besides. If any guard fails, the
one unattended write path (`knowledge-librarian.yaml`) contains the damage:
the wrapper script itself now enforces the bundle boundary after the agent
runs, exiting non-zero (failing the job, no commit, no PR) if the agent
touched anything outside `.lokf/knowledge/` (`.lokf/feedback.md` allowed) -
enforced, not merely requested by the wrapper's own contract - and even a
successful commit still touches only those same paths, never pushes to the
default branch, and always ends at a human-reviewed PR. Ordinary repository
content the librarian scrapes has no equivalent per-entry guard - it relies
on the same branch protection gating every other change to `main`, a
materially higher trust level than unreviewed reader feedback.

## Open questions

`SECURITY.md` itself (this concept's `resource`) still describes the
pre-2026-09-10 single-job design in one place - it says the arbitrary-command
surface was closed "under that job's `contents: write` scope", but the agent
now runs in the `refresh` job under `contents: read`; `contents: write` moved
to the separate `publish` job, which never runs agent code. Ground truth here
is `.github/workflows/knowledge-librarian.yaml`, `.lokf/scripts/knowledge-librarian.sh`,
and `CHANGELOG.md`'s `[0.10.0]` "Security" entries, which all agree with each
other and with this concept's body above. Out of this skill's scope to fix
(it owns only `.lokf/`, not `SECURITY.md`) - flagging for a maintainer to
bring `SECURITY.md`'s prose in line.
