---
type: Policy
id: https://lokf-agent-skills.example/knowledge/policies/security
title: Security policy
description: What the actual attack surface is (the copied-into-other-repositories templates, this repo's own CI, and the four skills' own prose read by an LLM agent), how to report privately, and the hardening and prompt-injection guards this repository applies.
genre: reference
resource: SECURITY.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T19:00:00Z"
status: draft
references:
  - https://lokf-agent-skills.example/knowledge/playbooks/repository-validation
verified:
- by: process:lokf-librarian
  at: "2026-09-09T19:00:00Z"
---

# Overview

Three things execute: the wrapper script and workflow templates that get
copied into *other* repositories and run there, this repository's own
workflows, and the four skills' `SKILL.md`/`references/` prose - executed by
whichever LLM agent runs it. Vulnerabilities go through GitHub private
vulnerability reporting, not public issues.

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
