# LOKF Agent Skills

> "We lasso the world with networks of silver-coloured Italian hemp,\
> We bind down the world into some sort of order;\
> We balance the earth in a pair of scales of our own devising."\
> — Amy Lowell, *The Congressional Library* (1922)

Four [Agent Skills](https://agentskills.io/home) that turn a repository's scattered knowledge into a maintained, trusted asset using **[LOKF](https://lokf.nolan-nichols.com/)** (Linked Open Knowledge Format) - a semantic profile of OKF in which a plain folder of Markdown concept files carries enough meaning to be validated by schema, queried as a graph, and read by people and agents alike. The [lokf python](https://pypi.org/project/lokf) package provides schema and tooling. **An agent derives it. Deterministic tools check it. A named person vouches for it. The bundle records which of the three happened to every claim.**

<p align="center">
  <img src=".assets/lokf-agent-skills-card.svg" alt="LOKF Agent Skills overview graphic" width="720" />
</p>

> **Two ways in.** This README is one; the other is a docent. Install
> [`lokf-docent`](https://github.com/noelmcloughlin/lokf-agent-skills) into
> whatever agent you already use -
> `npx skills add noelmcloughlin/lokf-agent-skills --skill lokf-docent --yes` -
> and ask it anything about this project - *Which skill do I run first?*, say,
> or *How do lokf-librarian and lokf-curator relate?*
> ([EXAMPLES.md](EXAMPLES.md) shows eight such answers, captured, not invented).
> It answers from `.lokf/knowledge/`, the checked part of what the project
> knows, says how far each answer has been trusted (still a draft, checked by
> automation only, or confirmed by a named person), opens the source for exact
> values, and records what it couldn't answer so the gap gets filled. One door
> for a person at a prompt, an agent reading this file, or a chatbot that can
> load a skill. **Agents:** if `.lokf/knowledge/index.md` exists, read it first -
> `llms.txt` says how to weigh it.

## Why libraries have catalogues

The knowledge already exists - in code, documents, diagrams, policies, operational records. What's missing is a layer that sits between those sources and whoever needs them next, and stays put. Without it, every task starts the same way: find the material, work out how it connects, judge what's still true. That's real work, and the collected context dies with the task - the next person, or next conversation with an assistant, pays for it again.

A **knowledge bundle** - that folder of concept files - is that catalogue: it keeps the work instead of discarding it. Two more words this README keeps coming back to: the bundle is the **exhibition**, the hall visitors are shown into, and each concept in it an exhibit, as against the workshop of sources and notes it was distilled from. But an exhibition is only worth keeping if you can tell what's sound - otherwise you re-verify everything yourself, the very thing you were trying to avoid, and the files quietly rot.

So ask a question and the answer tells you where it came from and how far it has been checked, in plain words - *confirmed by a person*, or *nobody has checked this yet*. Those labels are computed from the files on every read, never stored, so they cannot drift from what they describe: against an unchanged bundle they are deterministic.

## Four roles, three lines of the poem

| Skill | Role | Runs |
| --- | --- | --- |
| [`lokf-sidecar`](skills/lokf-sidecar/SKILL.md) | **Lays the network.** Bootstraps a fresh `.lokf/` sidecar (tooling, docs, dummy skeleton) into a repository that doesn't have one, from bundled templates; repairs a broken sidecar file. | once |
| [`lokf-librarian`](skills/lokf-librarian/SKILL.md) | **Binds it into order.** Scrapes the repository, derives concepts with their sources, classifies them, wires typed relationships, audits, and hands off for review. Like a real librarian it catalogues without vouching - it deals in *facts about the repository*, never in verdicts about truth. | often, including on a schedule |
| [`lokf-curator`](skills/lokf-curator/SKILL.md) | **Holds the scales.** A human curator's assistant. Shows what needs a person's look, puts the source next to the claim, and records the person's verdict - confirm, correct, retire, send back - in the bundle's own frontmatter. It deals in *judgments a person made*, never in facts it derived. | a little, regularly |
| [`lokf-docent`](skills/lokf-docent/SKILL.md) ([examples](EXAMPLES.md)) | **Guides the visitors** - the role the poem leaves implicit, because the library exists for them. Answers questions from the bundle first, says how far each concept used has been trusted, verifies exact values at the source, and when the bundle has no answer explores the repository and records the miss so it becomes the librarian's next task. Read-only on the bundle. | whenever anyone asks |

*Curator* here is the museum sense - the one who authenticates, weighs provenance, and decides what is put on **exhibit**; not the data-management sense, which describes the librarian's job.

A *docent* is the museum's guide - the one who walks visitors through the exhibition and explains what they are seeing, without moving anything on the shelves. If it helps to place yourself: the librarian reports, the curator fact-checks and edits, the docent reads - and writes back with corrections.

On a fresh repository they run in that order: the sidecar once, then the librarian filling the bundle and marking everything it creates a draft, then the curator, where a person turns drafts into confirmed knowledge a few at a time. After that it stops being a sequence and becomes a loop - the librarian refreshes on a schedule, readers send back what the bundle missed, and the curator works through whatever that surfaces.

### The fifth role, which is not a skill

The one job none of the four does is the **registrar's**: keeping the records themselves in order - each accession properly documented, the provenance paperwork filed, nothing entered in a form the catalogue can't read. It is clerical work, and no person has to do it.

In a repository the `lokf` toolkit does that on every change, and CI's [`knowledge-registrar.yaml`](.github/workflows/knowledge-registrar.yaml) does it again on every pull request.

In [Obsidian](https://obsidian.md/), where people edit bundles by hand and there is no CI to catch them, one plugin does it in the editor - and a second brings the curator's session to the same desk:

| Plugin | Role at the desk |
| --- | --- |
| [LOKF Registrar](https://github.com/noelmcloughlin/obsidian-lokf-registrar) | The **registrar**: checks each record is well-formed as it is written - the schema-valid row below, live in the editor. |
| [LOKF Curator](https://github.com/noelmcloughlin/obsidian-lokf-curator) | The **curator's assistant**, not the curator: puts the source beside the claim and writes down what the person decided - the human-confirmed row below, running this repository's `lokf-curator` review session without an agent in the loop. |

The curator is always a person; the skill and the plugin that carry the name are that person's assistants, in a terminal and in Obsidian. Neither plugin reaches a verdict of its own: the registrar keeps the paperwork honest, the assistant keeps the record of the decisions, and the judging stays with the person. Both are optional companions in either direction - the plugins work on any LOKF bundle however it was produced, and these skills need no plugin, since `lokf validate` remains the gate they rely on. The only thing all of it shares is the LOKF specification.

### Where the skills meet an Obsidian vault

The four skills are built around a **sidecar**: `.lokf/` sits beside the raw sources it distils - the code in a repository, the notes in a vault, the documents in a shared folder - in the same tree and, almost always, the same git repository. The bundle inside it has two names: `.lokf/knowledge`, which the skills, the toolkit, CI and `llms.txt` address, and `knowledge_bundle`, which people and Obsidian's **File → Open folder as vault** open. One is the real folder and the other a link onto it, and `lokf-sidecar` decides which by the host (its Step 0): in a code repository the hidden folder is real and `knowledge_bundle` is the doorway, opened *itself* as a small vault with nothing to configure; in a notes vault or a shared folder `knowledge_bundle/` is a real folder among the notes - explorer, graph, search, sync - and `.lokf/knowledge` is the link the tools follow. Obsidian users already live with a sidecar - `.obsidian/` is one - so `.lokf/` beside the notes is a familiar shape, not a new one. The vault someone already has is never migrated: it stays the **workshop**, and the bundle is the **exhibition** beside it - the curated front door for teammates, CI, and agents alike. Plugin for skill:

| Role | Skill or tool | Obsidian plugin |
| --- | --- | --- |
| Lays the sidecar | `lokf-sidecar` | - |
| Librarian | `lokf-librarian` | - (deriving is an agent's job) |
| Registrar | `lokf validate`, `knowledge-registrar.yaml` | LOKF Registrar |
| Curator - always a person | `lokf-curator`, the person's assistant | LOKF Curator - the same assistant, at the desk |
| Docent | `lokf-docent`, `lokf serve` | - |

The plugin READMEs walk an Obsidian user through it host by host; this repository's own [Open the knowledge bundle in Obsidian](.lokf/knowledge/playbooks/open-bundle-in-obsidian.md) playbook records what Obsidian does with each layout, and [Hosts and doorways](.lokf/knowledge/explanation/hosts-and-doorways.md) why the rule is what it is.

## Trust stays visible

Every concept carries its own trust record, and the curator reports it in plain words rather than ontology terms:

- **Confirmed by a person** - a named person checked it against its source.
- **Checked by automation only** - automation re-checked that the source still matches; no person has.
- **Nobody has checked this yet** - no check of any kind is recorded.
- **Still a draft**, **edited since a person last confirmed it**, **past its review date**, **retired** - and, for prioritising, how many other concepts rely on each one.

The number to watch is **confirmed by a person: n of N**, and it is meant to rise slowly - a handful of concepts in a sitting, cumulative and partial by design. A small, young bundle can reach fully-confirmed quickly; a large or fast-growing one never quite does, and the report says so instead of pretending.

## Install

**Install what you need - each skill stands alone.** The sidecar plus the librarian is enough to see the idea: the bundle gets built, everything in it marked a draft. Add the curator once there is a bundle worth trusting; until then the librarian's pull requests keep pointing at it. Already have a healthy `.lokf/`? Skip the sidecar skill. The docent goes anywhere an agent only *reads* a bundle - this repository included: install it, ask a question, and compare the answer with [EXAMPLES.md](EXAMPLES.md).

**GitHub CLI** ([`gh skill`](https://cli.github.com/manual/gh_skill_install), GitHub CLI v2.90.0+):

```bash
gh skill install noelmcloughlin/lokf-agent-skills lokf-sidecar
gh skill install noelmcloughlin/lokf-agent-skills lokf-librarian
gh skill install noelmcloughlin/lokf-agent-skills lokf-curator
gh skill install noelmcloughlin/lokf-agent-skills lokf-docent
```

All four skills are released together, but you can append version (i.e. `@v0.13.0`) if needed.

**Open Skills CLI** ([`npx skills`](https://github.com/vercel-labs/skills)):

```bash
npx skills add noelmcloughlin/lokf-agent-skills \
  --skill lokf-sidecar \
  --skill lokf-librarian \
  --skill lokf-curator \
  --skill lokf-docent --yes
```

## For the curious: how a claim gets checked, and where the vocabulary ends

The sections above are everything you need to decide whether to install these. What follows is the mechanics, for anyone who wants to know exactly what "confirmed by a person" is standing on - and what to do when a bundle outgrows the built-in vocabulary.

### Four levels of checking

Each proves less than its name suggests. Only the third yields a claim someone has agreed to stand behind.

| Check | Who, when | What it proves | What it can't |
| --- | --- | --- | --- |
| Schema-valid | the `lokf` toolkit on every change (`just lokf-validate`, and `just lokf-check-refs` for relation targets); `lokf validate` again as the CI gate on every pull request that touches the bundle | the frontmatter is well-formed, the types and relations are ones the schema knows, and every typed relation points at a concept that exists | that anything in it is true |
| Source-consistent | `lokf-librarian` on every scheduled refresh - shown as *checked by automation only* | the concept still matches what its source says today | that the source is right, or that the concept says what the team means |
| Human-confirmed | a named person, through `lokf-curator` or the LOKF Curator plugin - shown as *confirmed by a person* | someone accountable read the source and agreed | that it stays true - which is what review dates are for |
| Proven in use | readers, through `lokf-docent`, which records misses and disagreements in `.lokf/feedback.md` | the bundle answered a real question - or didn't, and the gap became the librarian's next task | nothing further - this is the feedback loop that feeds the other three |

The first and third rows also run live, outside these skills and the CLI, for anyone maintaining a bundle in Obsidian rather than through an agent: LOKF Registrar for the first, LOKF Curator for the third - see [the fifth role](#the-fifth-role-which-is-not-a-skill).

### When the vocabulary stops fitting

LOKF's vocabulary is deliberately small - 15 classes, ten typed relations - which is what keeps bundles portable. When concepts stop fitting those classes, typically in a deep or safety-critical domain (medicine, law, finance, safety engineering), the answer is a domain schema written in [LinkML](https://linkml.io) that extends LOKF's, not a looser bundle. The curator flags the drift; the team decides; the librarian applies it. What it costs (no new tooling), how to write one, what to do when the domain already has a LinkML vocabulary of its own, and how to validate values it binds to an external domain ontology: [`lokf-curator/references/domain-schemas.md`](skills/lokf-curator/references/domain-schemas.md).

## Repository layout

```text
skills/
  lokf-sidecar/         SKILL.md + references/ + templates/  (~2.5k tokens loaded on trigger)
  lokf-librarian/       SKILL.md + references/               (~6k tokens loaded on trigger)
  lokf-curator/         SKILL.md + references/               (~2k tokens loaded on trigger)
  lokf-docent/          SKILL.md + references/               (~1.4k tokens loaded on trigger)
.github/workflows/
  validate.yml          repository contract + Agent Skills spec + Markdown/link checks (every PR)
  publish.yml           maintainer-gated release (workflow_dispatch only)
scripts/
  validate-repository.sh   the checks validate.yml runs
  smoke-test-install.sh    installs all four skills into a throwaway consumer repo and asserts the result
  test-sidecar-layouts.sh  both bundle layouts against the wrapper, both workflows, and the lokf-link recipe
```

Each `SKILL.md` is a lean router; anything not needed on every invocation lives in that skill's `references/` (loaded only when the router points to it) so the always-resident cost stays small. `lokf-sidecar/templates/` holds the actual files it lays down - copied verbatim, never retyped inline.

## Versioning

All four skills ship from this repository under one semantic version - `vMAJOR.MINOR.PATCH`, released together, so pinning them to the same tag always gives you a set that agrees with itself. What each level means: [CONTRIBUTING.md](CONTRIBUTING.md#release-process).  See [CHANGELOG.md](CHANGELOG.md) for what changed in each release.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Security issues: see [SECURITY.md](SECURITY.md).

## Credits

- [Nolan Nichols](https://lokf.nolan-nichols.com/), creator of [LOKF](https://lokf.nolan-nichols.com/specification/) (Linked Open Knowledge Format) and its [toolkit](https://github.com/nicholsn/lokf).
- The [LinkML Community](https://linkml.io/), creators of [LinkML](https://linkml.io/linkml/), the schema language LOKF is written in.

## License

[Apache License 2.0](LICENSE).
