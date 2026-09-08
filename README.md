# LOKF Agent Skills

Two [Agent Skills](https://agentskills.io/home) for working with **[LOKF](https://lokf.nolan-nichols.com/)** (Linked Open Knowledge Format) - a semantic profile of OKF that binds every field to a public vocabulary (schema.org / DCAT / PROV-O), so a plain folder of Markdown concept files is also a valid, SPARQL-queryable RDF graph.

| Skill | Use it to... |
|---|---|
| [`lokf-scaffolding`](skills/lokf-scaffolding/SKILL.md) | Bootstrap a fresh `.lokf/` sidecar (tooling, docs, dummy skeleton) into a repository that doesn't have one yet, or repair a broken scaffolding file. Runs **once**. |
| [`lokf-librarian`](skills/lokf-librarian/SKILL.md) | Scrape a repository and build, maintain, and audit the real `.lokf/` concept files and typed relationships. Runs **often** - including on a schedule (see `lokf-scaffolding`'s automation templates). |

Run scaffolding first on a repo with no `.lokf/`; it hands off to the
librarian to fill the bundle with real knowledge. On a repo that already has a
healthy `.lokf/`, install and run only the librarian.

## Install

Both skills must be installed **explicitly** - installing one does not pull
in the other. Current installers have no cross-skill dependency mechanism.

**GitHub CLI** ([`gh skill`](https://cli.github.com/manual/gh_skill_install), GitHub CLI v2.90.0+):

```bash
gh skill install noelmcloughlin/lokf-librarian-agent-skills lokf-librarian
gh skill install noelmcloughlin/lokf-librarian-agent-skills lokf-scaffolding
```

Pin both to the same release for reproducibility:

```bash
gh skill install noelmcloughlin/lokf-librarian-agent-skills lokf-librarian@v1.0.0
gh skill install noelmcloughlin/lokf-librarian-agent-skills lokf-scaffolding@v1.0.0
```

**Open Skills CLI** ([`npx skills`](https://github.com/vercel-labs/skills)):

```bash
npx skills add noelmcloughlin/lokf-librarian-agent-skills \
  --skill lokf-librarian \
  --skill lokf-scaffolding
```

## Repository layout

```text
skills/
  lokf-librarian/      SKILL.md + references/  (~5.5k tokens loaded on trigger)
  lokf-scaffolding/     SKILL.md + references/ + templates/  (~2.5k tokens loaded on trigger)
.github/workflows/
  validate.yml          repository contract + Agent Skills spec + Markdown/link checks (every PR)
  publish.yml           maintainer-gated release (workflow_dispatch only)
scripts/
  validate-repository.sh   the checks validate.yml runs
  smoke-test-install.sh    installs both skills into a throwaway consumer repo and asserts the result
```

Each `SKILL.md` is a lean router; anything not needed on every invocation
lives in that skill's `references/` (loaded only when the router points to
it) so the always-resident cost stays small. `lokf-scaffolding/templates/`
holds the actual files it scaffolds - copied verbatim, never retyped inline.

## Versioning

Both skills ship from this repository under one semantic version - `vMAJOR.MINOR.PATCH`,
released together:

- **Patch** - corrections that don't materially change expected behavior.
- **Minor** - backward-compatible additions or broader supported workflows.
- **Major** - breaking changes to behavior, structure, assumptions, or interoperability.

See [CHANGELOG.md](CHANGELOG.md) for what changed in each release.

## Canonical source

This repository is the canonical, publicly distributed copy of both skills.
They originate from, and are dogfooded in, the
[LOKF Enforcer](https://github.com/noelmcloughlin/obsidian-lokf-enforcer)
Obsidian plugin's own `.agents/skills/`; changes should land here first, then
sync there.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Security issues: see [SECURITY.md](SECURITY.md).

## License

[Apache License 2.0](LICENSE).
