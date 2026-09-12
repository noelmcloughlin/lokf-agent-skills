---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/lokf-librarian-skill
title: lokf-librarian skill
description: Recurring procedure that scrapes the host repository, derives and maintains the .lokf/ concepts and their typed relations, audits the bundle, and hands off for human review.
genre: how-to
resource: skills/lokf-librarian/SKILL.md
generated:
  by: process:lokf-librarian
  at: "2026-09-12T15:00:00Z"
dependsOn:
- https://lokf-agent-skills.example/knowledge/playbooks/lokf-sidecar-skill
about:
  - https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
definedBy:
- https://lokf-agent-skills.example/knowledge/references/agent-skills-specification
references:
  - https://lokf-agent-skills.example/knowledge/references/lokf-specification
  - https://lokf-agent-skills.example/knowledge/references/okf-specification
verified:
- by: process:lokf-librarian
  at: "2026-09-12T15:00:00Z"
- by: human:noelmcloughlin
  at: "2026-09-09T18:36:00Z"
stale_after: 2027-09-09
---

# Overview

Runs **often**, including on a schedule. It carries the seven LOKF Golden Rules
(OKF-first; the bundle-root semantic header and `base_iri` authority test; the
15-class type vocabulary plus the Diátaxis `genre` facet; typed relationships
over bare links; core field-to-ontology mapping; trust, provenance and
lifecycle; permissiveness), then four sections: scrape and build, audit,
hand off for review, and the scheduled task.

It deals in **facts about the repository, never verdicts about truth**: it may
record that it re-checked a concept against its source (`verified` by
`process:lokf-librarian`), but only [lokf-curator](lokf-curator-skill.md)
writes a `human:` confirmation. Concepts it creates start as `status: draft`,
and a claim it cannot settle gets an `## Open questions` section instead of a
guess.

Two things it now leaves alone by rule (added 2026-09-12): the Obsidian
affordances LOKF Enforcer may write into a bundle - a marker-delimited
`<!-- lokf:related -->` block in a concept body and a `diataxis.md` Map of
Content (`type: Document`, `generated.by: lokf-enforcer/<version>`), which it
never edits, lists, audits as orphans, or counts - and the bundle's second
name: in lokf-sidecar's visible layout `.lokf/knowledge` is a link onto
`knowledge_bundle/`, so it addresses the bundle by the tools' name and names
both paths when scoping a diff or a PR.
