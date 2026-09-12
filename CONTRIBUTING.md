# Contributing to LOKF Agent Skills

Thanks for your interest in improving `lokf-agent-skills`.

## Development setup

There is no build step - the skills are Markdown, YAML, and one shell script.

```bash
git clone https://github.com/noelmcloughlin/lokf-agent-skills.git
cd lokf-agent-skills
bash scripts/validate-repository.sh
```

To try a change end-to-end before publishing, install from your local clone instead of GitHub:

```bash
gh skill install ./lokf-agent-skills lokf-sidecar --from-local
# or:
npx skills add ./lokf-agent-skills --skill lokf-sidecar
```

## Layout

| Path | Responsibility |
| --- | --- |
| `skills/lokf-sidecar/SKILL.md` | One-shot bootstrap: creates `.lokf/` from `templates/`. Router only - see its `references/` for portability and automation detail. |
| `skills/lokf-sidecar/templates/` | Every file the sidecar skill writes, copied verbatim - never inlined into `SKILL.md`. |
| `skills/lokf-librarian/SKILL.md` | Day-to-day: scrape, build, audit, and hand off `.lokf/` concepts. Facts, never verdicts. |
| `skills/lokf-curator/SKILL.md` | A human curator's assistant: the trust/freshness report and the review session that records a person's Confirm / Wrong / Retire / Later as frontmatter. Verdicts, never facts. |
| `skills/lokf-docent/SKILL.md` | The reader's side: answer from the bundle first with each concept's trust label, fall back to the repository deliberately, and record misses/disagreements in `.lokf/feedback.md`. Read-only on the bundle. |
| `skills/*/references/*.md` | Detail loaded only when the router points to it - keeps each `SKILL.md` small. |
| `scripts/validate-repository.sh` | The repository-contract checks CI runs on every PR. |
| `scripts/smoke-test-install.sh` | Installs all four skills into a throwaway repo and asserts the result. CI runs this on every PR against the checked-out branch. |

## Before opening a pull request

- Run `bash scripts/validate-repository.sh` - checks all four `SKILL.md` files exist under the right names, frontmatter `name:` matches its directory, there's no stray duplicate `SKILL.md`, and every relative Markdown link under `skills/` still resolves.
- If you have the GitHub CLI installed, run `gh skill publish --dry-run` - this is the same Agent Skills spec check `validate.yml` runs in CI.
- If you changed a shell script, run `shellcheck` on it (CI runs this too).
- If you changed a workflow (here or under `skills/lokf-sidecar/templates/github/`), CI lints it with `actionlint` - a YAML parse alone won't catch a bad expression or context.
- If your change alters what either skill actually *does* (not just wording), add an entry under `[Unreleased]` in `CHANGELOG.md`.

## Editing scope

This repository packages and distributes the four skills; it does not second-guess their operational content on its own. If you're proposing a change to what an agent should actually do (a new Golden Rule interpretation, a different sidecar step, a new curator verb), explain the *why* in the PR and keep the role boundary intact: the librarian derives facts from the
repository and never vouches for them; the curator records a person's verdicts and never derives facts. A change that blurs that line needs a stronger argument than one that respects it.

## Release process

Releases are maintainer-gated via the `publish.yml` workflow (`workflow_dispatch`, not tag-triggered - see that file's header comment for why). All four skills always ship together under one tag, under one semantic version - `vMAJOR.MINOR.PATCH`:

- **Patch** - corrections that don't materially change expected behavior.
- **Minor** - backward-compatible additions or broader supported workflows.
- **Major** - breaking changes to behavior, structure, assumptions, or interoperability.
