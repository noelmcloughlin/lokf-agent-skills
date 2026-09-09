# LOKF Agent Skills

> "We lasso the world with networks of silver-coloured Italian hemp,\
> We bind down the world into some sort of order;\
> We balance the earth in a pair of scales of our own devising."\
> — Amy Lowell, *The Congressional Library* (1922)

<p align="center">
  <img src=".assets/lokf-agent-skills-card.svg" alt="LOKF Agent Skills overview graphic" width="720" />
</p>

Four [Agent Skills](https://agentskills.io/home) that turn a repository's scattered knowledge into a maintained, trusted asset using **[LOKF's](https://lokf.nolan-nichols.com/)** (Linked Open Knowledge Format)  - a semantic profile of OKF in which a plain folder of Markdown concept files carries enough meaning to be validated by schema, queried as a graph, and read by people and agents alike. The [lokf python](https://pypi.org/project/lokf) package provides schema and tooling.

> **For AI agents:** if `.lokf/knowledge/index.md` exists in this repository,
> read it first - it is a queryable [LOKF](https://lokf.nolan-nichols.com)
> knowledge bundle of repository-specific context; `llms.txt` says how to weigh
> what you find there (drafts vs. person-confirmed) and names the `lokf-docent`
> skill for answering from it.

## The problem they solve

The knowledge already exists - in code, documents, diagrams, policies, operational records. What is missing is a durable layer *between* those sources and the next task. Every new session re-finds the material, re-connects the pieces, and re-judges whether they can be trusted; the useful interpretation evaporates when the task ends. A knowledge bundle keeps the selected context once, keeps it current, and keeps its provenance and trust signals visible so that people and AI assistants can reuse it instead of rediscovering it.

Schema checks make a bundle *consistent*. They cannot make it *true*. That takes a person - which is why there are four roles here, not one.

## Four roles, three lines of the poem

| Skill | Role | Runs |
| --- | --- | --- |
| [`lokf-scaffolding`](skills/lokf-scaffolding/SKILL.md) | **Lays the network.** Bootstraps a fresh `.lokf/` sidecar (tooling, docs, dummy skeleton) into a repository that doesn't have one, from bundled templates; repairs a broken scaffolding file. | once |
| [`lokf-librarian`](skills/lokf-librarian/SKILL.md) | **Binds it into order.** Scrapes the repository, derives concepts with their sources, classifies them, wires typed relationships, audits, and hands off for review. Like a real librarian it catalogues without vouching - it deals in *facts about the repository*, never in verdicts about truth. | often, including on a schedule |
| [`lokf-curator`](skills/lokf-curator/SKILL.md) | **Holds the scales.** A human curator's assistant. Shows what needs a person's look, puts the source next to the claim, and records the person's verdict - confirm, correct, retire, send back - in the bundle's own frontmatter. It deals in *judgments a person made*, never in facts it derived. | a little, regularly |
| [`lokf-docent`](skills/lokf-docent/SKILL.md) ([examples](EXAMPLES.md)) | **Guides the visitors** - the role the poem leaves implicit, because the library exists for them. Answers questions from the bundle first, says how far each concept used has been trusted, verifies exact values at the source, and when the bundle has no answer explores the repository and records the miss so it becomes the librarian's next task. Read-only on the bundle. | whenever anyone asks |

*Curator* here is meant in the museum sense - the person who authenticates, weighs provenance, and decides what is exhibited as trusted. (In data-management usage "curation" describes the librarian's work; that is not what the third skill does.) If it helps to place yourself: the librarian is the reporter, the curator is the fact-checker and editor, and the docent is the reader - who also writes in with corrections.

Run scaffolding once on a repository with no `.lokf/`; it hands off to the librarian, which fills the bundle and marks everything it creates as a draft; the librarian hands off to the curator, where a person turns drafts into confirmed knowledge a few at a time. On a repository that already has a healthy `.lokf/`, install the librarian and the curator. Install the docent wherever an agent will *read* a bundle - including repositories and agents that only ever consume one.

## Trust stays visible

Every concept carries its own trust record, and the curator reports it in plain words rather than ontology terms:

- **Confirmed by a person** - a named person checked it against its source.
- **Checked by automation only** - the librarian re-checked that the source still matches; no person has.
- **Nobody has checked this yet** - no check of any kind is recorded.
- **Still a draft**, **edited since a person last confirmed it**, **past its review date**, **retired** - and, for prioritising, how many other concepts rely on each one.

The docent carries the label into every answer it gives from a concept, so a reader always knows which rung an answer stands on.

The number to watch is *confirmed by a person: n of N*. It is computed from the bundle every time, never stored, and it is meant to rise slowly. Curation is cumulative and partial by design: a busy person confirms a handful of concepts per session, the librarian's next scheduled run re-prompts with what changed, and end users who lean on the bundle report what it got wrong or missed. A small, young bundle can reach fully-confirmed quickly; a large or fast-growing one never quite does - and the report says so honestly instead of pretending.

### How a claim gets checked

Four levels, each answering a narrower question than it sounds like it answers. Schema checks make a bundle *consistent*; only the third rung makes it *trusted*.

| Check | Who, when | What it proves | What it can't |
| --- | --- | --- | --- |
| Schema-valid | the `lokf` toolkit (`just lokf-validate`) on every change, and the CI gate on every `.lokf/**` pull request | the frontmatter is well-formed, the types and relations are ones the schema knows, the graph is consistent | that anything in it is true |
| Source-consistent | `lokf-librarian` on every scheduled refresh - shown as *checked by automation only* | the concept still matches what its source says today | that the source is right, or that the concept says what the team means |
| Human-confirmed | a named person, through `lokf-curator` - shown as *confirmed by a person* | someone accountable read the source and agreed | that it stays true - which is what review dates are for |
| Proven in use | readers, through `lokf-docent`, which records misses and disagreements in `.lokf/feedback.md` | the bundle answered a real question - or didn't, and the gap became the librarian's next task | nothing further - this is the feedback loop that feeds the other three |

## When the vocabulary stops fitting

LOKF's vocabulary is deliberately small - 14 classes, ten typed relations - which is what keeps bundles portable. When a bundle drifts into a deep or safety-critical domain (medicine, law, finance, safety engineering) and concepts start not fitting those classes, the answer is a domain schema written in [LinkML](https://linkml.io) that extends LOKF's, not a looser bundle. The curator flags the drift; the team decides; the librarian applies it. It costs no new tooling: the sidecar's `lokf[build]` dependency already includes the LinkML generators, so the same domain schema also gives you Pydantic models, JSON Schema, and rendered documentation. Examples in [`lokf-curator/references/domain-schemas.md`](skills/lokf-curator/references/domain-schemas.md).

## Install

All four skills must be installed **explicitly** - installing one does not pull in the others. Current installers have no cross-skill dependency mechanism.

**Start small if you like.** Scaffolding plus the librarian is enough to see the idea: the bundle gets built, and everything in it is marked as a draft.  Add the curator once there is a bundle worth trusting; until then the librarian's pull requests will keep pointing at it. The curator's cost is one short description in your agent's always-loaded context, and about 1.8k tokens only when you invoke it. The docent is the one to install in any repository or agent that merely *reads* a bundle.

**GitHub CLI** ([`gh skill`](https://cli.github.com/manual/gh_skill_install), GitHub CLI v2.90.0+):

```bash
gh skill install noelmcloughlin/lokf-agent-skills lokf-scaffolding
gh skill install noelmcloughlin/lokf-agent-skills lokf-librarian
gh skill install noelmcloughlin/lokf-agent-skills lokf-curator
gh skill install noelmcloughlin/lokf-agent-skills lokf-docent
```

Pin all four to the same release for reproducibility:

```bash
gh skill install noelmcloughlin/lokf-agent-skills lokf-scaffolding@v1.0.0
gh skill install noelmcloughlin/lokf-agent-skills lokf-librarian@v1.0.0
gh skill install noelmcloughlin/lokf-agent-skills lokf-curator@v1.0.0
gh skill install noelmcloughlin/lokf-agent-skills lokf-docent@v1.0.0
```

**Open Skills CLI** ([`npx skills`](https://github.com/vercel-labs/skills)):

```bash
npx skills add noelmcloughlin/lokf-agent-skills \
  --skill lokf-scaffolding \
  --skill lokf-librarian \
  --skill lokf-curator \
  --skill lokf-docent
```

## Repository layout

```text
skills/
  lokf-scaffolding/     SKILL.md + references/ + templates/  (~2.5k tokens loaded on trigger)
  lokf-librarian/       SKILL.md + references/               (~6k tokens loaded on trigger)
  lokf-curator/         SKILL.md + references/               (~2k tokens loaded on trigger)
  lokf-docent/          SKILL.md + references/               (~1.4k tokens loaded on trigger)
.github/workflows/
  validate.yml          repository contract + Agent Skills spec + Markdown/link checks (every PR)
  publish.yml           maintainer-gated release (workflow_dispatch only)
scripts/
  validate-repository.sh   the checks validate.yml runs
  smoke-test-install.sh    installs all four skills into a throwaway consumer repo and asserts the result
```

Each `SKILL.md` is a lean router; anything not needed on every invocation lives in that skill's `references/` (loaded only when the router points to it) so the always-resident cost stays small. `lokf-scaffolding/templates/` holds the actual files it scaffolds - copied verbatim, never retyped inline.

## Versioning

All four skills ship from this repository under one semantic version - `vMAJOR.MINOR.PATCH`, released together:

- **Patch** - corrections that don't materially change expected behavior.
- **Minor** - backward-compatible additions or broader supported workflows.
- **Major** - breaking changes to behavior, structure, assumptions, or interoperability.

See [CHANGELOG.md](CHANGELOG.md) for what changed in each release.

## Canonical source

This repository is the sole, canonical source of all four skills. Install from it rather than copying, and pin them all to the same release.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Security issues: see [SECURITY.md](SECURITY.md).

## License

[Apache License 2.0](LICENSE).
