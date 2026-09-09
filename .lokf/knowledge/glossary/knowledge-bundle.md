---
type: GlossaryTerm
id: https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
title: Knowledge bundle
definition: The `.lokf/` sidecar itself - a directory of one-concept-per-file Markdown under `knowledge/`, carrying a semantic header, that is simultaneously human-readable documentation and a queryable graph.
genre: reference
resource: skills/lokf-scaffolding/templates/README.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
about:
  - https://lokf-agent-skills.example/knowledge/glossary/lokf
verified:
- by: process:lokf-librarian
  at: "2026-09-09T17:00:00Z"
---

# Overview

A sidecar, not part of the host project's build. `knowledge/index.md` carries
the semantic header (`base_iri`, `context`, versions, publisher) plus the table
of contents; `knowledge/log.md` records knowledge changes only. The bundle is
the durable layer between scattered sources and the next task - the thing that
stops each session re-finding, re-connecting, and re-judging the same material.
