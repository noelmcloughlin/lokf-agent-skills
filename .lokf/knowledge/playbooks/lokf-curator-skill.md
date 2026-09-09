---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/lokf-curator-skill
title: lokf-curator skill
description: A human curator's assistant - reports what needs a person's attention, then records that person's confirm/correct/retire/send-back verdicts into the bundle's frontmatter.
genre: how-to
resource: skills/lokf-curator/SKILL.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
dependsOn:
- https://lokf-agent-skills.example/knowledge/playbooks/lokf-librarian-skill
about:
  - https://lokf-agent-skills.example/knowledge/glossary/trust-label
definedBy:
- https://lokf-agent-skills.example/knowledge/references/agent-skills-specification
verified:
- by: process:lokf-librarian
  at: "2026-09-09T12:00:00Z"
---

# Overview

Runs **a little, regularly**. Step 1 is always a read-only one-screen report
computed from frontmatter alone (no toolkit needed): a health line, at most
five items "worth ten minutes today", the librarian's open questions, waiting
reader feedback, and vocabulary fit. Step 2 is an opt-in review session that
shows the source *before* the claim and takes one verb per item. Step 3 covers
the curation policy, gap intake, and domain-schema guidance.

It deals in **judgments a person made, never facts it derived**. It writes only
`verified` (human events), `status`, `stale_after`, `generated` (on a dictated
correction), and an `## Open questions` section - and never without an explicit
per-item answer. There is deliberately no "confirm everything".
