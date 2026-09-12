---
type: Explanation
id: https://lokf-agent-skills.example/knowledge/explanation/hosts-and-doorways
title: Hosts and doorways - where the bundle's real folder lives
description: The sidecar has two names, `.lokf/knowledge` for tools and `knowledge_bundle` for people, and one of them is a link. In a code repository the hidden name is the real folder; in a notes vault or shared folder the visible one is, and the tools reach it through the link. Adopted in lokf-sidecar on 2026-09-12.
genre: explanation
resource: skills/lokf-sidecar/SKILL.md
generated:
  by: process:lokf-librarian
  at: "2026-09-12T15:30:00Z"
status: draft
about:
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-sidecar-skill
  - https://lokf-agent-skills.example/knowledge/playbooks/open-bundle-in-obsidian
relatedTo:
  - https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
  - https://lokf-agent-skills.example/knowledge/explanation/why-a-registrar-role
---

# The pattern

A LOKF bundle is a **sidecar**: it sits beside the raw sources it distils, in the same folder tree
and normally the same git repository, and never inside the host's build. The sidecar is `.lokf/`; the
bundle is `.lokf/knowledge/`; the tooling (`pyproject.toml`, `justfile`, `scripts/`, `feedback.md`)
sits next to the bundle. This is the same shape as `.git/`, `.github/`, `.devcontainer/` - and, for an
Obsidian user, `.obsidian/`: a dot-folder the tools own, kept beside the content people own.

Because the dot-folder is hidden from folder pickers, `lokf-sidecar` Step 2 adds a **doorway**:
`knowledge_bundle`, a link at the host root onto the bundle. The bundle therefore has **two names**:

| Name | Who addresses it | Today |
| --- | --- | --- |
| `.lokf/knowledge` | the four skills, the `lokf` toolkit, CI's `knowledge-registrar.yaml`, `llms.txt` | the real folder |
| `knowledge_bundle` | people, and Obsidian's *Open folder as vault* | a symlink (junction on Windows) |

Every tool and every person finds the bundle at the name they know. Which of the two is the real
folder is an implementation choice, and today it is always the hidden one.

# Hosts

- **Code repository** - readers are developers, agents, and CI. The hidden real folder keeps the
  bundle out of the way; Obsidian is an occasional desk, reached through the doorway. Right as it is.
- **Notes vault kept in git** (the maintainer's own MSc-AI case) - the sidecar lands beside the notes.
  The main vault never indexes `.lokf/`, and skips the doorway too (its target resolves inside the vault
  being indexed - see [Open the knowledge bundle in Obsidian](../playbooks/open-bundle-in-obsidian.md)),
  so notes and bundle never collide; the person curates in a second, focused vault opened through the
  doorway. Works, and is in daily use. What it does *not* give is the bundle inside the main vault's
  graph, search, Obsidian Sync, or mobile.
- **Shared drive or SharePoint library** - readers are whoever the service shows the folder to.
  Microsoft's restricted-name list has nothing against a leading dot, so `.lokf/` syncs; but OneDrive
  syncs neither symbolic links nor junctions, so the doorway is per-machine and the visible thing the
  service shows is a hidden folder nobody browses to.

# The rule, as adopted on 2026-09-12: the host decides which name is real

Both names always exist. `lokf-sidecar` Step 0 now asks which kind of host it is in, and lays the
sidecar down accordingly:

| Host | Real folder | Link |
| --- | --- | --- |
| Code repository (default) | `.lokf/knowledge/` | `knowledge_bundle` → `.lokf/knowledge` |
| Notes vault or shared folder (an `.obsidian/` at the host root, or a synced path) | `knowledge_bundle/` at the host root | `.lokf/knowledge` → `../knowledge_bundle` |
| Vault in a subfolder of the host (a repository whose root holds the README and skills, the vault in `MSc-AI/`) | `MSc-AI/knowledge_bundle/`, inside the vault so Obsidian sees it | `.lokf/knowledge` → `../MSc-AI/knowledge_bundle`; `visible := "../MSc-AI/knowledge_bundle"` in the justfile |

In the visible layout the bundle is a plain folder in the vault - explorer, graph, search, Sync,
mobile - and the two plugins detect it with nothing to configure: a top-level `knowledge_bundle/`
with its own `index.md`, in a vault whose root `index.md` carries no LOKF header, becomes the bundle
root and every other note is left alone. It can still be opened on its own as the focused curator's
vault, now with no link involved. The skills and toolkit are unchanged - they address `.lokf/knowledge`
and follow the link, which git carries and `just lokf-link` recreates where a sync service drops it (its `visible` variable names the folder when it is not `../knowledge_bundle`).

What it cost: the wrapper's boundary check and both workflows' pathspecs (`git status`, `git add`,
`git diff`, `git log`, `git show`) name `knowledge_bundle` as well as `.lokf/knowledge`, because a git
pathspec never traverses a symlink (and `git add` refuses a pathspec that matches nothing, hence a
guard); the registrar workflow also triggers on `knowledge_bundle/**`; the root `.gitignore` gains
`knowledge_bundle/.obsidian/`; `scripts/test-sidecar-layouts.sh` pins all of that against both layouts (the
wrapper, both workflows, and the recipe) and runs from the repository-contract check; the plugins gained the auto-detection above, and their *Bundle root
folders* setting now accepts a dot-folder entry (warning if Obsidian's index does not list it today,
so a vault running the community plugin *Hidden Folders Access* can name `.lokf/knowledge` directly)
instead of refusing it. On Windows a junction (`mklink /J`, no elevated rights) is the preferred
link in either direction.

The alternative the maintainer floated - renaming the whole sidecar `.lokf/` to `knowledge_bundle/`
on such hosts - would keep one name instead of two but need the skills to accept a configurable
sidecar path; the two-name form needs no such knob, which is why it was chosen.
