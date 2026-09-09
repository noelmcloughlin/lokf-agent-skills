---
type: Policy
id: https://lokf-agent-skills.example/knowledge/policies/security
title: Security policy
description: The actual attack surface (copied-into-other-repositories templates, this repo's own CI, the four skills' own prose read by an LLM agent), that a skill's `Scope:` line is advisory except on the scheduled workflow, how to report privately, and this repository's hardening and prompt-injection guards.
genre: reference
resource: SECURITY.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T21:00:00Z"
status: draft
references:
  - https://lokf-agent-skills.example/knowledge/playbooks/repository-validation
verified:
- by: process:lokf-librarian
  at: "2026-09-09T21:00:00Z"
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
`permissions`, harden-runner in audit mode, a maintainer-approved `release`
environment gating the only write scope, and `knowledge-librarian.yaml`'s
agent step always running the pinned wrapper script directly - the `AGENT_CLI`
repository variable can only choose which agent runs, never what command runs,
closing an earlier arbitrary-command-execution surface under that job's
`contents: write` scope. Dependabot covers this repository's own workflows
but cannot reach the templates - a documented upstream limitation, so those
pins are bumped by hand. Dependency review and CodeQL are deliberately
absent: there is no dependency manifest or compiled code here to scan.

Prompt-injection guards, one per input path an agent reads but didn't author:
lokf-librarian resolves a `.lokf/feedback.md` entry only from the source it
names, never from the entry's own wording; lokf-curator quotes a fetched
`resource`/`sources` to the human rather than ever acting on it itself; lokf-docent
treats fetched source or repository content as text to quote, never as
instructions, and is read-only on the bundle besides. If any guard fails, the
one unattended write path (`knowledge-librarian.yaml`) fails the job before
any commit if the agent touched anything outside `.lokf/knowledge` and
`.lokf/feedback.md` - the wrapper script's own write-scope contract is
advisory, so the workflow checks it rather than trusting it - and even a
successful commit still touches only those same paths, never pushes to the
default branch, and always ends at a human-reviewed PR. Ordinary repository
content the librarian scrapes has no equivalent per-entry guard - it relies
on the same branch protection gating every other change to `main`, a
materially higher trust level than unreviewed reader feedback.
