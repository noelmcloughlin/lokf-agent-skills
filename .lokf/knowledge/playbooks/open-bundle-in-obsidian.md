---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/open-bundle-in-obsidian
title: Open the knowledge bundle in Obsidian
description: How a knowledge bundle meets an Obsidian vault - open the root-level knowledge_bundle doorway as its own vault, or, in the visible layout for vault and shared-folder hosts, find it as an ordinary folder the plugins detect - with what Obsidian does with a link on each host, verified against Obsidian 1.13.7's file reconciler.
genre: how-to
resource: skills/lokf-sidecar/SKILL.md
generated:
  by: process:lokf-librarian
  at: "2026-09-12T15:00:00Z"
status: draft
isPartOf:
  - https://lokf-agent-skills.example/knowledge/playbooks/lokf-sidecar-skill
about:
  - https://lokf-agent-skills.example/knowledge/glossary/knowledge-bundle
relatedTo:
  - https://lokf-agent-skills.example/knowledge/explanation/hosts-and-doorways
verified:
- by: process:lokf-librarian
  at: "2026-09-12T12:00:00Z"
---

# Overview

`lokf-sidecar` Step 2 creates a `knowledge_bundle` symlink at the repo root, pointing at
`.lokf/knowledge`. It exists because `.lokf/` is a dot-directory and Obsidian's **File → Open
folder as vault** picker - like most OS folder pickers - hides those by default, so `.lokf/knowledge`
is easy to open by typing the path but awkward to browse to. The link is the **doorway**: the one
name a person needs to know.

# How it is opened

Open **`knowledge_bundle` itself** as a vault. The bundle becomes a small vault of its own - one
bundle, every note a concept, nothing to configure in either Obsidian plugin (LOKF Enforcer, LOKF
Curator), since both default to "the vault root is the bundle root". Obsidian treats the linked folder
like any other vault and writes its workspace state through the link, landing it in the real
`.lokf/knowledge/.obsidian/` - harmless to `lokf validate` (it reads only `*.md`), and excluded from
git by `.lokf/.gitignore`. This is how the maintainer's own MSc-AI vault is used day to day.

Per host:

- **Windows** - a junction does the same job with no administrator rights or Developer Mode:
  `mklink /J knowledge_bundle .lokf\knowledge`. Obsidian follows junctions as it follows symlinks.
- **No link at all** (a filesystem without them, or a sync service that carries folders but not
  links - OneDrive syncs neither symbolic links nor junctions) - open `.lokf/knowledge` directly by
  typing the path into the picker, or recreate the link on each machine. Everything else is identical.
- **Git** carries the symlink as a symlink; a Windows checkout without `core.symlinks` materialises it
  as a small text file, which is the cue to make the junction.

# What Obsidian does with the link on each host

Obsidian 1.13.7's file reconciler (`reconcileSymbolicLinkCreation`, read from the installed
application bundle on 2026-09-12) resolves a link's real path and **skips the link when that path
equals, contains, or lies inside a folder it is already watching** - the vault root always being one.
Its help page says the same in words: it ignores "a symlink to a parent folder of the vault, or from
one folder in the vault to another folder in the same vault", as a safeguard against a note being
indexed twice. Dot-directories are never indexed at all. Two consequences, both benign:

- **From a vault opened at the host's root** (a code repository, or a notes vault kept in git that
  the sidecar was laid into), neither `.lokf/` nor `knowledge_bundle` appears - the sidecar is
  invisible to that vault by the same rule that hides `.obsidian/` and `.git/`. So point people at the
  doorway, not the root. For a notes vault this is the feature that makes the sidecar safe to keep
  *inside* the vault folder: the notes vault and the bundle vault never index the same file, which is
  the one hazard Obsidian's caution about nested vaults names.
- **A link whose target lies outside the vault is followed.** An Obsidian user with one vault and many
  repositories can link each repository's `.lokf/knowledge` into a folder of that vault
  (`projects/acme-knowledge -> ~/git/acme/.lokf/knowledge`) and list those folders under the plugins'
  *Bundle root folders* setting - Obsidian's ordinary "one vault, many project folders" shape, fed by
  repository sidecars, with the sources now inside the vault for the review card to open. Obsidian
  Sync does not carry such links, so keep them out of a synced vault.

# The visible layout, for a vault or shared folder as host

When the host is itself a notes vault or a synced folder, `lokf-sidecar` (Step 0) lays the sidecar
down the other way round: `knowledge_bundle/` is the real folder - at the host root, or inside the vault
when the vault is a subfolder of the host (`MSc-AI/knowledge_bundle/`) - and `.lokf/knowledge` the link
onto it. The bundle then sits in the host vault like any folder - explorer, graph, search,
Sync, mobile - and both plugins detect it with nothing to configure (a top-level `knowledge_bundle/`
with its own `index.md`, in a vault whose root `index.md` carries no LOKF header). It can still be
opened on its own for a focused desk, now with no link involved. Why the two layouts exist, and what
each costs: [Hosts and doorways](../explanation/hosts-and-doorways.md).

If the symlink is missing on an older bundle, it is safe to add by hand: `ln -s .lokf/knowledge
knowledge_bundle` from the repo root.
