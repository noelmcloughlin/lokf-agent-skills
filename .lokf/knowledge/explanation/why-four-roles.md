---
type: Explanation
id: https://lokf-agent-skills.example/knowledge/explanation/why-four-roles
title: Why four roles rather than one skill
description: Why deriving, confirming, and reading knowledge are separated into distinct skills - schema checks can make a bundle consistent, but only a person can make it trusted.
genre: explanation
resource: README.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
about:
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-scaffolding-skill
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-librarian-skill
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-curator-skill
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-docent-skill
references:
  - https://lokf-agent-skills.example/knowledge/glossary/trust-label
verified:
- by: process:lokf-librarian
  at: "2026-09-09T17:00:00Z"
---

# Overview

A single "keep the docs current" agent would conflate two different acts:
finding out what the repository says, and deciding what the team accepts as
true. The first is mechanical and repeatable; the second requires
accountability. Validation cannot bridge the gap - JSON Schema and SHACL prove
a bundle is *consistent*, never that it is *correct*.

The split follows the professions the names come from. A librarian selects,
classifies, and maintains authority control, but catalogues without vouching:
a library shelves contradictory books. A museum curator authenticates, weighs
provenance, and decides what is exhibited as trusted. A docent guides visitors
and carries back what the collection could not answer.

The closest working analogue is a publishing chain - author, fact-checker,
editor, and readers writing in with corrections. The one place the analogy
needs care is that the curator hears only the librarian's case, with no
opposing counsel; that is why the review session shows the source *before* the
claim, never pre-fills a verdict, and treats reader feedback as the missing
adversary.

Each handoff is a frontmatter fact, not a convention: the librarian marks what
it creates `status: draft`, the curator's `verified` event by a `human:` actor
is what clears it, and the docent's `.lokf/feedback.md` entries are what the
librarian consumes next run.
