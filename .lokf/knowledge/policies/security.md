---
type: Policy
id: https://lokf-agent-skills.example/knowledge/policies/security
title: Security policy
description: What the actual attack surface is (the copied-into-other-repositories templates and this repo's own CI), how to report privately, and the hardening this repository applies.
genre: reference
resource: SECURITY.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
references:
  - https://lokf-agent-skills.example/knowledge/playbooks/repository-validation
verified:
- by: process:lokf-librarian
  at: "2026-09-09T12:00:00Z"
---

# Overview

Two things execute: the wrapper script and workflow templates that get copied
into *other* repositories and run there, and this repository's own workflows.
Vulnerabilities go through GitHub private vulnerability reporting, not public
issues.

Hardening: third-party Actions pinned to reviewed commit SHAs everywhere
including the templates, `persist-credentials: false`, least-privilege
`permissions`, harden-runner in audit mode, and a maintainer-approved
`release` environment gating the only write scope. Dependabot covers this
repository's own workflows but cannot reach the templates - a documented
upstream limitation, so those pins are bumped by hand. Dependency review and
CodeQL are deliberately absent: there is no dependency manifest or compiled
code here to scan.
