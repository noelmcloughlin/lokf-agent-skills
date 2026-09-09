---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/lokf-scaffolding-skill
title: lokf-scaffolding skill
description: One-shot procedure that creates a .lokf/ sidecar - tooling, docs, and a dummy skeleton - from bundled templates, then hands off to lokf-librarian.
genre: how-to
resource: skills/lokf-scaffolding/SKILL.md
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
about:
  - https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
definedBy:
- https://lokf-agent-skills.example/knowledge/references/agent-skills-specification
references:
  - https://lokf-agent-skills.example/knowledge/references/lokf-toolkit
verified:
- by: process:lokf-librarian
  at: "2026-09-09T12:00:00Z"
---

# Overview

Runs **once** per repository, or to repair a single missing scaffolding file;
it never authors concepts. Six steps: gather the host project's facts (Step 0),
copy each file from `templates/` and substitute placeholders (Step 1), add the
root-level `llms.txt`/README pointer (Step 2), verify no placeholder survives
(Step 3), validate (Step 4), optionally scaffold the CI automation (Step 5),
and hand off (Step 6).

Its detail lives in two reference files - `references/portability.md` (non-git,
non-GitHub, non-POSIX hosts) and `references/automation.md` (what the Step 5
files do) - so the router itself stays small. Every file it writes is copied
from `templates/`, never retyped, which is what keeps a scaffolded bundle
byte-identical to the reviewed template.
