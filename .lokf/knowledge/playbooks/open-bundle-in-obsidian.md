---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/open-bundle-in-obsidian
title: Open the knowledge bundle in Obsidian
description: Open .lokf/knowledge as an Obsidian vault via the root-level knowledge_bundle symlink, since Obsidian's "Open folder as vault" picker (like most OS file pickers) hides dot-directories by default.
genre: how-to
resource: skills/lokf-scaffolding/SKILL.md
generated:
  by: process:lokf-librarian
  at: "2026-09-11T09:42:00Z"
status: draft
isPartOf:
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-scaffolding-skill
about:
  - https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
verified:
- by: process:lokf-librarian
  at: "2026-09-11T09:42:00Z"
---

# Overview

`lokf-scaffolding` Step 2 creates a `knowledge_bundle` symlink at the repo root, pointing at
`.lokf/knowledge`. It exists because `.lokf/` is a dot-directory and Obsidian's "Open folder as
vault" picker - like most OS folder pickers - hides those by default, so `.lokf/knowledge` is easy
to open by typing the path but awkward to browse to. Point Obsidian at `knowledge_bundle` instead
and it opens the same directory under an ordinary, visible name.

POSIX only (`ln -s`); on Windows without WSL/Git Bash, or a filesystem without symlink support, the
link is skipped and the bundle is opened by typing `.lokf/knowledge` directly instead. Opening
`knowledge_bundle` as a vault makes Obsidian write its workspace state through the link, landing it
in the real `.lokf/knowledge/.obsidian/` - harmless to `lokf validate` (it reads only `*.md`), and
excluded from git by `.lokf/.gitignore`.

If the symlink is missing on an older bundle, it is safe to add by hand: `ln -s .lokf/knowledge
knowledge_bundle` from the repo root.
