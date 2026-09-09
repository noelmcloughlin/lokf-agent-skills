---
type: Playbook
id: https://lokf-agent-skills.example/knowledge/playbooks/knowledge-sources
title: Knowledge sources
description: Map of the repository locations this bundle was derived from, and how to re-check each on a future refresh.
genre: how-to
resource: .
generated:
  by: process:lokf-librarian
  at: "2026-09-09T12:00:00Z"
status: draft
verified:
- by: process:lokf-librarian
  at: "2026-09-09T12:00:00Z"
---

# Sources swept for this bootstrap discovery pass

| Source | Yields | Re-check by |
| --- | --- | --- |
| `skills/*/SKILL.md` | the four skill Playbooks | re-read each router; a changed step list, guardrail, or frontmatter `description` is a drift signal |
| `skills/*/references/*.md` | detail behind each skill Playbook | diff against the claims in the corresponding concept body |
| `skills/lokf-scaffolding/templates/` | what scaffolding actually writes; the toolkit dependency and its `[build]` extra | diff `pyproject.toml` (the `lokf` floor) and the template list in the skill's Step 1 table |
| `README.md` | project identity, the four-role narrative, versioning policy, install commands | diff the roles table and the Versioning section |
| `CONTRIBUTING.md` | the contributing playbook | diff the layout table and the pre-PR checklist |
| `SECURITY.md` | the security policy | diff the hardening bullets |
| `AI_COVENANT.md`, `CODE_OF_CONDUCT.md` | governance policies | diff each; both are adapted from upstream documents that may themselves change |
| `.github/workflows/validate.yml`, `publish.yml` | the validation and releasing playbooks | diff job names, triggers, and the pinned action SHAs |
| `.github/workflows/knowledge-validate.yaml`, `knowledge-librarian.yaml` | this repository's dogfooded copies of the two workflow templates scaffolding ships | diff each against its counterpart under `skills/lokf-scaffolding/templates/github/`; they are deliberately kept byte-identical, so any difference is either a template bump not yet copied across or a divergence `.github/dependabot.yml` should explain |
| `.github/ISSUE_TEMPLATE/*.md`, `.github/pull_request_template.md`, `.github/dependabot.yml` | contributor intake forms and pin maintenance | consciously excluded as concepts - see note below; re-check only that each template still names all four skills and that its `AI_COVENANT.md` link is absolute |
| `scripts/*.sh` | what the validation playbook claims CI enforces | re-read the assertions; a new check is a gap in the playbook |
| `CHANGELOG.md` | what changed between releases | read the `[Unreleased]` section for behaviour changes not yet reflected in concepts |
| external URLs cited across the repo | the seven Reference concepts | confirm each still resolves and still says what the concept claims |
| `.assets/*.svg` | decorative images (e.g. the README social-preview card) | consciously excluded - see note below; re-check only that the row still applies if the asset's purpose changes |

# Notes for the next run

- **Steady-state refresh (this run)**: re-verified all 17 internal-resource
  concepts against their current files - all still accurate; no body
  changes needed. Consciously skipped `.assets/lokf-agent-skills-card.svg`,
  a new decorative image added to `README.md` since the bootstrap pass: it
  carries no reusable knowledge, so it gets a source-map row (above) instead
  of a concept, the same treatment as `.markdownlint-cli2.jsonc`/`lychee.toml`.
- **Audit finding, fixed this run**: 12 of 25 concepts had a bare-scalar
  value on a multivalued relation slot (`dependsOn`/`definedBy`/`relatedTo`),
  which is schema-invalid even though it reads naturally - `uv run lokf
  validate knowledge` failed with exactly this error before the fix, and the
  same failure was independently visible in this repository's own
  `Knowledge Bundle Validation` GitHub Actions run. Fixed by wrapping each as
  a one-item list (content unchanged); `lokf-librarian/SKILL.md` Golden Rule
  4 and section 2 now say so explicitly, so it should not recur.
- **Orphan sweep (this run)**: three `.github/` surfaces had no source-map row
  and no concept - the two dogfooded `knowledge-*.yaml` workflows, the issue
  and pull-request templates, and `dependabot.yml`. They now have rows (above)
  and stay excluded as concepts: they are intake forms and maintenance config,
  not reusable knowledge. The sweep found real defects in them, fixed the
  same run (not separately itemized in `CHANGELOG.md`, which for this
  first release describes the shipped feature rather than its pre-release
  fix history): both issue templates offered only
  `lokf-librarian` and `lokf-scaffolding` under "Which skill?", all three
  templates linked `AI_COVENANT.md` relatively (which 404s in GitHub's
  rendered forms), and the two shipped workflow templates lagged the pins
  Dependabot had already applied to the dogfooded copies.
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
