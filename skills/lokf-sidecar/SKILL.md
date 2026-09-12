---
name: lokf-sidecar
description: 'Lay down a `.lokf/` LOKF knowledge-bundle sidecar (tooling, docs, dummy skeleton, and a visible `knowledge_bundle` entry point for Obsidian) in the repository this skill sits in, from bundled templates. Use when: a repo has no `.lokf/` yet and someone asks to add, scaffold, bootstrap, or set up a LOKF/lokf sidecar, knowledge bundle, or machine-readable, SPARQL-queryable knowledge; or to repair a missing/broken sidecar file. Not for authoring or maintaining concepts - that is the lokf-librarian skill, which this one hands off to when done.'
license: Apache-2.0
---

# LOKF Sidecar

Create a fresh **`.lokf/` sidecar** - a machine-readable, SPARQL-queryable [LOKF](https://lokf.nolan-nichols.com/) knowledge bundle - inside the repository this skill is invoked from: directory, tooling, docs, and a small
**dummy** skeleton, then hand off to **lokf-librarian** to fill it with real knowledge. Every file is copied from `templates/` (paths below are relative to this skill's directory), never retyped.

> Sources: lokf.nolan-nichols.com is the canonical site for what LOKF *means*
> (spec, Golden Rules). The tooling this skill installs comes from the
> [`lokf` PyPI package](https://pypi.org/project/lokf/); with no Python, the
> raw schema <https://raw.githubusercontent.com/nicholsn/lokf/main/lokf.yaml>
> is the fallback (Step 4). Cite each for its own role in generated docs.

> Model: a small/mid-tier model is enough here - Step 1 copies templates and
> substitutes placeholders; Step 0 is structured file lookup. Mistakes are
> caught by Step 3's grep and Step 6's human sign-off. **lokf-librarian** is
> the opposite case: keep it on the calling agent's normal model.

## Scope

- **This skill** - run **once** to create `.lokf/`, or to **repair** a missing/broken sidecar file (anything in the Step 1/5 tables). Never authors real concepts.
- **lokf-librarian** - run **often** to scrape the repo and create, maintain, and audit the actual concepts and typed relations.

> Guardrails: if `.lokf/` exists and is healthy, use lokf-librarian instead.
> When repairing, (re)write only the missing/broken file - including a missing
> `llms.txt`/README pointer on an older bundle; **never overwrite concept
> files**. Non-git, non-GitHub, or non-POSIX host: see
> [references/portability.md](references/portability.md).

## Step 0 - Gather the host project's facts

Resolve every placeholder from real project sources before writing anything; never leave a `<...>` token or dummy value behind.

| Placeholder | Meaning | Where to find it |
| --- | --- | --- |
| `<PROJ_NAME>` | Human-readable project name | manifest `name` (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, ...), root `README.md` title, service catalog, or repo name |
| `<PROJ_DESC>` | One-sentence description | manifest `description`, README intro, or service catalog |
| `<PROJ_SLUG>` | lowercase-hyphenated slug | derive from `<PROJ_NAME>` (`Acme Platform` -> `acme-platform`) |
| `<BASE_IRI>` | Bundle base IRI, **must end with `/`** | (1) a persistent-identifier namespace the project already publishes under (w3id.org, purl.org, owned domain) + `/knowledge/`; (2) a stable URL the project controls (docs `site_url`, Pages, service catalog) + `/knowledge/`; (3) else `https://<PROJ_SLUG>.example/knowledge/`, flagged for review. **Never** the code-host repo URL (`https://github.com/<org>/<repo>/...`) - that path space isn't the project's, so the IDs could never resolve |
| `<OWNER_NAME>` | Owning team/org display name | `CODEOWNERS`, manifest authors, service catalog, or README |
| `<OWNER_SLUG>` | lowercase-hyphenated owner slug | derive from `<OWNER_NAME>` |
| `<TODAY>` | `YYYY-MM-DD` | system clock (for `log.md`) |

`<BASE_IRI>` is load-bearing: `base_iri` + concept path mints each concept's `@id`. It need not resolve today, but must be stable and in a namespace the project controls (lokf-librarian Rule 2 has the authority test and migration steps). A plain directory tree with no manifest/CODEOWNERS/repo: use the directory name, any document in the tree, and the `.example` fallback - and flag every guess in Step 6.

**Tracked or gitignored - decide now.** Check whether the root `.gitignore` already excludes `.lokf/` (ask if unclear). Committing `.lokf/` is the default four skills assume; gitignoring it is equally valid (personal bundle, or a policy against committing agent-authored content) but changes four things: still create every file (the bundle is filesystem-based either way); skip the commit in Step 4 and all of Step 5; add the Step 2 `knowledge_bundle` symlink to the root `.gitignore` instead of committing it; say so in the Step 6 handoff. This is unrelated to `.lokf/.gitignore` below, which only excludes tool build noise.

**Which name is real - decide now.** The bundle has two names: `.lokf/knowledge` (what every skill, the toolkit, CI and `llms.txt` address) and `knowledge_bundle` at the host root (what people, and Obsidian's *Open folder as vault*, open). One is the real folder, the other a link onto it, and the host decides which:

| Host | Real folder | Link | Why |
| --- | --- | --- | --- |
| **Code repository** (the default) | `.lokf/knowledge/` | `knowledge_bundle` → `.lokf/knowledge` (Step 2) | readers are developers, agents and CI; the bundle stays out of the way, and Obsidian is an occasional desk reached through the doorway |
| **Notes vault or shared folder** - an `.obsidian/` at the host root, or a path inside OneDrive/SharePoint, Dropbox, Drive or iCloud | `knowledge_bundle/` at the host root | `.lokf/knowledge` → `../knowledge_bundle` | readers live in Obsidian or a sync client: the bundle is an ordinary visible folder (explorer, graph, search, Sync, mobile), the LOKF Registrar and LOKF Curator plugins detect it with nothing to configure, and the tools still find it at the name they know |

Ask when the signals conflict. Everything below is written for the default; the **visible layout** differs only where marked ▸.

▸ **Vault in a subfolder of the host.** A repository whose root holds the README and the skills, with the vault one level down (`MSc-AI/`, say), is still the vault case: the real folder goes *inside the vault* - `MSc-AI/knowledge_bundle/`, so Obsidian sees it - and the link is `.lokf/knowledge` → `../MSc-AI/knowledge_bundle`. Set `visible := "../MSc-AI/knowledge_bundle"` in `.lokf/justfile` so `just lokf-link` knows the path, and write that path wherever Step 5's three files say `knowledge_bundle`.

> Repo hygiene note: if the host repo installs AI skills locally, the generated runtime directories `.agents/`, `.claude/`, and the lockfile `skills-lock.json` are not source content and should be excluded from the root `.gitignore` rather than committed as project changes.

## Step 1 - Create the skeleton and copy the templates

Copy each template to its destination, then substitute the placeholders it lists. Only these placeholders exist; `templates/gitignore` is written as
`.lokf/.gitignore`.

| Template | Destination | Placeholders |
| --- | --- | --- |
| `templates/pyproject.toml` | `.lokf/pyproject.toml` | PROJ_NAME, PROJ_SLUG |
| `templates/gitignore` | `.lokf/.gitignore` | - |
| `templates/justfile` | `.lokf/justfile` | PROJ_NAME |
| `templates/README.md` | `.lokf/README.md` | PROJ_NAME |
| `templates/knowledge/index.md` | `.lokf/knowledge/index.md` (semantic header + TOC, reserved) | PROJ_NAME, PROJ_DESC, BASE_IRI, OWNER_NAME, OWNER_SLUG |
| `templates/knowledge/log.md` | `.lokf/knowledge/log.md` (reserved) | PROJ_NAME, TODAY |
| `templates/knowledge/services/index.md` | `.lokf/knowledge/services/index.md` | - |
| `templates/knowledge/services/example-service-a.md`, `-b.md` | same paths under `.lokf/` (DUMMY - lokf-librarian replaces) | PROJ_NAME, PROJ_SLUG, BASE_IRI |
| `templates/queries.http` *(optional, default on)* | `.lokf/queries.http` | PROJ_NAME |

```bash
mkdir -p .lokf/knowledge/services
# ...copy the rows above, then e.g.:
grep -rl -e '<PROJ_' -e '<BASE_IRI>' -e '<OWNER_' -e '<TODAY>' .lokf \
  | xargs sed -i -e "s|<PROJ_NAME>|$PROJ_NAME|g" -e "s|<PROJ_DESC>|$PROJ_DESC|g" \
      -e "s|<PROJ_SLUG>|$PROJ_SLUG|g" -e "s|<BASE_IRI>|$BASE_IRI|g" \
      -e "s|<OWNER_NAME>|$OWNER_NAME|g" -e "s|<OWNER_SLUG>|$OWNER_SLUG|g" -e "s|<TODAY>|$TODAY|g"
```

(If a value contains `|`, substitute with your editor instead of sed.)

▸ **Visible layout:** create the real folder and the tools' link onto it *before* copying - `mkdir knowledge_bundle && ln -s ../knowledge_bundle .lokf/knowledge` (Windows: `mklink /J .lokf\knowledge %CD%\knowledge_bundle`) - then copy the `templates/knowledge/*` rows to their listed `.lokf/knowledge/...` destinations exactly as written; the link puts them in `knowledge_bundle/`. Every recipe, script and workflow addresses `.lokf/knowledge` and follows the link, and `just lokf-link` recreates it on a machine where a sync service dropped it (its `visible` variable names the folder; the default is `../knowledge_bundle`).

## Step 2 - Point agents and humans at the bundle (optional, root-level)

Three additions at the **repo root**, outside `.lokf/`. Add only, never overwrite, and check for an existing item first. All three stay true
**whether or not `.lokf/` exists later**, so nothing ever needs cleaning up if the bundle is removed - keep that self-qualifying phrasing (a dangling
symlink is harmless and easy to spot).

- **`llms.txt`** - copy `templates/llms.txt` (PROJ_NAME, PROJ_DESC) if absent. If it exists, leave it intact and append only the `## Agent context`
  section, and only if the file doesn't already mention `.lokf/`.
- **README pointer** - if `README.md` exists and doesn't already link to `.lokf/knowledge/` anywhere (check the path, not a heading string), insert
  `templates/readme-for-ai-agents.md` after the intro, before the first `##`. It is a one-paragraph blockquote aside, not a section: agents read the top of a README, a human skims past an aside, and the trust-weighing detail lives in `llms.txt` rather than being repeated here. Don't invent a README on a host that has none.
- **`knowledge_bundle` symlink** - a visible, ordinary-looking doorway into the hidden `.lokf/` directory for humans and their tools, most
  concretely Obsidian's **File → Open folder as vault**: OS folder pickers (Obsidian's included) hide dot-directories, so `.lokf/knowledge` is easy
  to open by typing the path but awkward to browse to. If nothing named `knowledge_bundle` already exists at the repo root:

  ```bash
  ln -s .lokf/knowledge knowledge_bundle
  ```

  Run from the repo root - the target is relative, which keeps the link valid after a clone or move. Mirror the Step 0 tracked/gitignored decision:
  commit it alongside a tracked `.lokf/`, or add `knowledge_bundle` to the root `.gitignore` alongside a gitignored one. POSIX only - on Windows
  without WSL/Git Bash, or on a filesystem without symlink support, skip it (see [references/portability.md](references/portability.md)); the
  bundle works identically without it.

  **How it is used.** The person opens `knowledge_bundle` *itself* as a vault (File → Open folder as vault): the bundle becomes a small vault of
  its own, and Obsidian writes its workspace state through the link into the real `.lokf/knowledge/.obsidian/` - invisible to `lokf validate`
  (Step 4 reads only `*.md`) and already excluded by `templates/gitignore`. A vault opened at the *repository root* does not list the bundle -
  Obsidian never indexes a dot-directory and skips a link that resolves back inside the vault it is indexing - so point people at the doorway, not
  the root; when the host is itself a notes vault, that same rule is what lets the sidecar sit inside it without the two ever indexing one file
  twice. On Windows a junction does the job with no elevated rights (`mklink /J knowledge_bundle .lokf\knowledge`); sync services such as OneDrive
  carry folders but not links, so on a synced host the doorway is recreated per machine or the bundle opened by path (see
  [references/portability.md](references/portability.md)). If the host repo lints, spell-checks, or link-checks `**/*.md` repo-wide, exclude
  `knowledge_bundle/` from that config - otherwise the same files under `.lokf/knowledge/` are processed twice, once at each path.

  ▸ **Visible layout:** no doorway link is needed - the bundle *is* the visible folder - so instead add `knowledge_bundle/.obsidian/` to the root
  `.gitignore` (add only, never overwrite): that is where Obsidian keeps its workspace state when someone opens the bundle as its own vault, and
  `templates/gitignore` covers only the default layout's `.lokf/knowledge/.obsidian/`. Opened as part of the host vault, the plugins detect
  `knowledge_bundle/` on their own (a top-level folder of that name with an `index.md`, in a vault whose root `index.md` carries no LOKF header).

## Step 3 - Verify the skeleton

Placeholder tokens only - the files legitimately contain other angle brackets:

```bash
grep -rn -e '<PROJ_' -e '<BASE_IRI>' -e '<OWNER_' -e '<TODAY>' .lokf/ knowledge_bundle/ llms.txt 2>/dev/null
```

Zero hits means fully resolved. (`knowledge_bundle/` is named because `grep -r` does not descend into a symlinked `.lokf/knowledge`; in the default layout it is the same files listed twice, harmlessly.) Leave the `example-service-*.md` dummies as dummies (or delete them for an empty bundle) - don't enumerate real services.

## Step 4 - Validate the skeleton

```bash
cd .lokf && just lokf-install && just lokf-validate   # uv sync; schema-valid
```

No `uv`/`lokf`? There's no substitute for the generated JSON Schema/SHACL checks, but fetch the raw schema (Sources note) and manually cross-check the
`Service` class and the slots you used - a structural sanity check, not a validation run. Report in Step 6 whether validation ran, ran as this manual
fallback, or was skipped. Never log this in `knowledge/log.md` (knowledge changes only). Fix findings, then commit - unless `.lokf/` is gitignored
(Step 0), in which case there is nothing to commit.

## Step 5 - Lay down the automation (optional)

**Skip entirely if `.lokf/` is gitignored** - both workflows need the bundle on a remote branch, and the librarian loop's `git status --porcelain` check
silently reports "no changes" for an ignored path forever. GitHub-only; other hosts: copy just the wrapper and schedule it with cron/CI (see
[references/portability.md](references/portability.md)). No placeholders.

| Template | Destination |
| --- | --- |
| `templates/github/knowledge-registrar.yaml` | `.github/workflows/knowledge-registrar.yaml` |
| `templates/github/knowledge-librarian.yaml` | `.github/workflows/knowledge-librarian.yaml` |
| `templates/scripts/knowledge-librarian.sh` | `.lokf/scripts/knowledge-librarian.sh` (`chmod +x`) |

Both workflows and the wrapper name the bundle under both of its names (`.lokf/knowledge` and `knowledge_bundle`), because a git pathspec never traverses a symlink - nothing here differs between the layouts, except when the real folder sits inside a vault subfolder (Step 0 ▸): then replace `knowledge_bundle` in all three files with that path. The registrar's `provenance` job needs no wiring, but check one thing and report it here: `git config --get commit.gpgsign`, and whether `HEAD` carries a signature (`git cat-file commit HEAD | grep -qE '^gpgsig'`). If signing is off, say so now - GitHub blocks self-approval, so a **solo maintainer**'s own curation PRs pass only if they sign, and otherwise every confirmation lokf-curator records will be rejected at the gate. Show the three `git config` lines from [references/automation.md](references/automation.md) and let them run those; do not run them yourself and never touch their `--global` config. The optional `KNOWLEDGE_CURATION_ENVIRONMENT` escape hatch is in the same file; it requires creating an Environment *with required reviewers* first, and is a no-op if that part is skipped.

The wrapper looks for `lokf-librarian/SKILL.md` under `.claude/skills/`, `.github/skills/`, `.agents/skills/`, then bare `skills/` (a repo that
publishes the skills it also uses) - if this repo uses another directory, add it to the script's `candidate` list now, and run the script once to confirm:
a mismatch otherwise fails at scheduled-run time, not now. What each file does, the repo variables to wire, and the runner/SHA-pin notes:
[references/automation.md](references/automation.md).

## Step 6 - Hand off to lokf-librarian

The sidecar ends here; lokf-librarian's first run is a **bootstrap discovery** pass that records the repo's knowledge sources as
`playbooks/knowledge-sources.md`; the librarian in turn hands off to **lokf-curator**, where a person confirms what it derived; and
**lokf-docent** answers readers from the bundle, recording what it lacked for the librarian's next run - so all four skills should be installed. In the
handoff, tell the user:

- which Step 0 values were **guessed** rather than found (a fallback `<BASE_IRI>` above all - it mints every `@id`, so it needs sign-off);
- whether Step 4 validation ran, ran as the manual fallback, or was skipped;
- which optional pieces (`queries.http`, Step 2 pointers, Step 5 automation) were added, appended to, or left alone because they already existed;
- whether `.lokf/` is **git-tracked or gitignored** - this decides whether lokf-librarian's PR-based review and any Step 5 automation apply at all;
- which **layout** was laid down - the default, or the visible layout with `.lokf/knowledge` as the link - and, for the latter on a sync service that drops links, that `just lokf-link` recreates the tools' link per machine.
