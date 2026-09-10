---
type: Explanation
id: https://lokf-agent-skills.example/knowledge/explanation/why-a-registrar-role
title: Why a registrar role, and why it is not a fifth skill
description: The job none of the four skills does - keeping bundle records themselves well-formed and provenanced - and why it is enforced by tooling (the `lokf` toolkit, CI, and two companion Obsidian plugins) rather than by an agent.
genre: explanation
resource: README.md
generated:
  by: process:lokf-librarian
  at: "2026-09-10T00:00:00Z"
status: draft
relatedTo:
- https://lokf-agent-skills.example/knowledge/explanation/why-four-roles
about:
- https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
verified:
- by: process:lokf-librarian
  at: "2026-09-10T00:00:00Z"
---

# Overview

A museum registrar keeps accession records themselves in order - each entry
properly documented, provenance paperwork filed, nothing entered in a form
the catalogue cannot read - without ever judging whether an object is
authentic. That is a distinct job from the four this repository already
splits out ([why four roles](why-four-roles.md)): it does not derive facts
(librarian), does not decide what is trusted (curator), and does not answer
questions (docent). It is not a fifth skill here because, in a repository,
tooling already does it on every change: the `lokf` toolkit (`just
lokf-validate`, `just lokf-check-refs`) and CI's `Knowledge Bundle Validation`
gate.

Where a bundle is edited by hand instead - in [Obsidian](https://obsidian.md/),
with no CI to catch a malformed record - two companion plugins do the same
job at the desk rather than after a commit:

- [LOKF Enforcer](https://github.com/noelmcloughlin/obsidian-lokf-enforcer) -
  checks a record is well-formed as it is written, live in the editor.
- [LOKF Curator](https://github.com/noelmcloughlin/obsidian-lokf-curator) -
  puts a source beside a claim and records what a person decided, running
  this repository's `lokf-curator` review session without an agent in the
  loop.

Neither plugin reaches a verdict of its own - a registrar keeps the
provenance honest and leaves judging to the curator (human, or the plugin
that carries that name). Both directions are optional companions rather than
a dependency: the plugins work on any LOKF bundle however it was produced,
and these four skills need no plugin, since `lokf validate` remains the gate
they rely on. The only thing every path shares is the LOKF specification
itself.
