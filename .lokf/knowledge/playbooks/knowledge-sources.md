---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/knowledge-sources
title: Knowledge sources
description: Map of the repository locations this bundle was derived from, and how to re-check each on a future refresh.
genre: how-to
resource: .
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
---

# Sources swept for this bootstrap discovery pass

| Source | Yields | Re-check by |
|---|---|---|
| `skills/*/SKILL.md` | the four skill Playbooks | re-read each router; a changed step list, guardrail, or frontmatter `description` is a drift signal |
| `skills/*/references/*.md` | detail behind each skill Playbook | diff against the claims in the corresponding concept body |
| `skills/lokf-scaffolding/templates/` | what scaffolding actually writes; the toolkit dependency and its `[build]` extra | diff `pyproject.toml` (the `lokf` floor) and the template list in the skill's Step 1 table |
| `README.md` | project identity, the four-role narrative, versioning policy, install commands | diff the roles table and the Versioning section |
| `CONTRIBUTING.md` | the contributing playbook | diff the layout table and the pre-PR checklist |
| `SECURITY.md` | the security policy | diff the hardening bullets |
| `AI_COVENANT.md`, `CODE_OF_CONDUCT.md` | governance policies | diff each; both are adapted from upstream documents that may themselves change |
| `.github/workflows/validate.yml`, `publish.yml` | the validation and releasing playbooks | diff job names, triggers, and the pinned action SHAs |
| `scripts/*.sh` | what the validation playbook claims CI enforces | re-read the assertions; a new check is a gap in the playbook |
| `CHANGELOG.md` | what changed between releases | read the `[Unreleased]` section for behaviour changes not yet reflected in concepts |
| external URLs cited across the repo | the seven Reference concepts | confirm each still resolves and still says what the concept claims |

# Notes for the next run

- **No `Service`, `Dataset`, `Table`, `Metric`, or `AttestedComputation`
  concepts exist**, and that is correct: this repository ships documentation,
  agent skills, and CI - it runs no API, stores no data, and defines no
  measured quantity. The scaffolded `services/` directory and its two dummy
  concepts were removed rather than filled. If a hosted docs site or a
  published package ever appears, that changes.
- **No `Person`/`Organization` concept.** The maintainer is recorded once as
  the bundle's `publisher` in `index.md`; nothing else links to a person, and
  the skill says to add such concepts only when something does.
- **`base_iri` is a placeholder** (`lokf-agent-skills.example`, an RFC 2606
  reserved domain) pending a namespace the project actually controls. It mints
  every concept `@id` here, so migrating it later rewrites all of them - cheap
  now, expensive once anything external links in.
- The repository has **no published release yet**, so the `v1.0.0` in the
  install examples is illustrative. Re-check once a tag exists.
