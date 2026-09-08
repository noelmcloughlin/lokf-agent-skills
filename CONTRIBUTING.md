# Contributing to LOKF Agent Skills

Thanks for your interest in improving `lokf-librarian` or `lokf-scaffolding`.

## Development setup

There is no build step - the skills are Markdown, YAML, and one shell script.

```bash
git clone https://github.com/noelmcloughlin/lokf-librarian-agent-skills.git
cd lokf-librarian-agent-skills
bash scripts/validate-repository.sh
```

To try a change end-to-end before publishing, install from your local clone
instead of GitHub:

```bash
gh skill install ./lokf-librarian-agent-skills lokf-scaffolding --from-local
# or:
npx skills add ./lokf-librarian-agent-skills --skill lokf-scaffolding
```

## Layout

| Path | Responsibility |
|---|---|
| `skills/lokf-scaffolding/SKILL.md` | One-shot bootstrap: creates `.lokf/` from `templates/`. Router only - see its `references/` for portability and automation detail. |
| `skills/lokf-scaffolding/templates/` | Every file scaffolding writes, copied verbatim - never inlined into `SKILL.md`. |
| `skills/lokf-librarian/SKILL.md` | Day-to-day: scrape, build, audit, and hand off `.lokf/` concepts. |
| `skills/*/references/*.md` | Detail loaded only when the router points to it - keeps each `SKILL.md` small. |
| `scripts/validate-repository.sh` | The repository-contract checks CI runs on every PR. |
| `scripts/smoke-test-install.sh` | Installs both skills into a throwaway repo and asserts the result. |

## Before opening a pull request

- Run `bash scripts/validate-repository.sh` - checks both `SKILL.md` files
  exist under the right names, frontmatter `name:` matches its directory,
  there's no stray duplicate `SKILL.md`, and every relative Markdown link
  under `skills/` still resolves.
- If you have the GitHub CLI installed, run `gh skill publish --dry-run` -
  this is the same Agent Skills spec check `validate.yml` runs in CI.
- If you changed a shell script, run `shellcheck` on it (CI runs this too).
- If your change alters what either skill actually *does* (not just wording),
  add an entry under `[Unreleased]` in `CHANGELOG.md`.

## Editing scope

This repository packages and distributes the two skills; it does not
second-guess their operational content on its own. If you're proposing a
change to what an agent should actually do (a new Golden Rule interpretation,
a different scaffolding step, etc.), explain the *why* in the PR - these
skills are dogfooded daily against a real `.lokf/` bundle in the
[LOKF Enforcer](https://github.com/noelmcloughlin/obsidian-lokf-enforcer)
plugin, so a change here should make sense there too.

## Release process

Releases are maintainer-gated via the `publish.yml` workflow
(`workflow_dispatch`, not tag-triggered - see that file's header comment for
why). Both skills always ship together under one tag. See
[README.md](README.md#versioning) for the version-bump rules.
