---
type: GlossaryTerm
id: https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
title: Knowledge bundle
definition: The `.lokf/` sidecar itself - a directory of one-concept-per-file Markdown under `knowledge/`, carrying a semantic header, that is simultaneously human-readable documentation and a queryable graph.
genre: reference
resource: skills/lokf-sidecar/templates/README.md
generated:
  by: process:lokf-librarian
  at: "2026-09-12T12:00:00Z"
about:
  - https://lokf-agent-skills.example/knowledge/glossary/lokf
verified:
- by: process:lokf-librarian
  at: "2026-09-12T12:00:00Z"
- by: human:noelmcloughlin
  at: "2026-09-09T18:33:00Z"
stale_after: 2028-09-09
---

# Overview

Strictly, the *bundle* is the `knowledge/` folder - one concept per Markdown
file under an `index.md` that names it - and the *sidecar* is `.lokf/`, the
bundle plus the tooling that validates it, kept out of the host project's
build. In a repository the two travel together, so the terms are used
loosely for each other here. To an Obsidian user a bundle is simply a folder
of notes: it can be a vault, a folder inside a vault, or a repository's
`knowledge_bundle` opened as a vault. `knowledge/index.md` carries the
semantic header (`base_iri`, `context`, versions, publisher) plus the table
of contents; `knowledge/log.md` records knowledge changes only. The bundle is
the durable layer between scattered sources and the next task - the thing that
stops each session re-finding, re-connecting, and re-judging the same material.
