# Security Policy

## Scope

This repository is mostly Markdown. Two things in it execute or are executed by other systems, and are the actual attack surface:

- `skills/lokf-scaffolding/templates/scripts/knowledge-librarian.sh` and the two GitHub Actions workflow templates next to it (`skills/lokf-scaffolding/templates/github/*.yaml`) - these get **copied into other repositories** by the scaffolding skill and run there.
- This repository's own `.github/workflows/*.yml`, which run with a `GITHUB_TOKEN` on every PR and (for `publish.yml`) with `contents: write` behind a maintainer-approval environment.
- The four skills' `SKILL.md`/`references/` prose **is executed too - by whichever LLM agent runs it**, here and in every consumer repository that installs the skills. Anywhere that prose sends an agent to read content it didn't author - a repository file, an external URL, a reader's question, `.lokf/feedback.md` - is a prompt-injection surface. See **Prompt-injection guards** below.

## Interactive use: scope is advisory, not enforced

A skill's `Scope:` line (e.g. `lokf-librarian` "owns only `.lokf/`") is prose, not a checked permission - the Agent Skills format has no manifest for that. Run interactively, an agent has whatever tool access your harness already grants it; that's the generic "runs with full agent permissions" warning `npx skills` prints after every install. Only the scheduled `knowledge-librarian.yaml` workflow technically enforces its scope (**Repository hardening**, below), because nothing is watching it run. For interactive use, review what the agent changed before committing or merging - the same discipline the scheduled path's mandatory PR review provides automatically.

## Reporting a vulnerability

Please use GitHub's [private vulnerability reporting](https://github.com/noelmcloughlin/lokf-agent-skills/security/advisories/new) rather than a public issue. Include:

- which file (a workflow template, the wrapper script, or this repo's own CI) and why it's exploitable;
- for a template that gets copied elsewhere, whether the issue is in the template itself or only manifests after a consumer repo customizes it.

## Supported versions

Only the latest published tag receives fixes. Point releases (patch) are issued for security corrections; see [CHANGELOG.md](CHANGELOG.md).

## Repository hardening

- Pull requests require passing validation before merge; force-pushes and branch deletion are blocked on `main`.
- Secret scanning and push protection are enabled.
- `publish.yml`'s write scope is gated behind a `release` environment with required reviewers - no workflow can create a release unattended.
- Third-party Actions are pinned to a reviewed commit SHA (not a floating tag) in every workflow, including the templates under `skills/lokf-scaffolding/templates/github/`.
- `.github/dependabot.yml` keeps this repository's own workflow pins current. It does **not** reach the two templates under `skills/lokf-scaffolding/templates/github/` - Dependabot's `github-actions` ecosystem only scans `.github/workflows/` (a known upstream limitation), so those pins are still bumped by hand; `lint-workflows`' `actionlint` step catches syntax drift there, not staleness.
- Dependency review and CodeQL are intentionally **not** enabled: this repository has no dependency manifests or compiled code to scan (the templates' `pyproject.toml` is a template for consumers, not this repo's own dependency). If that changes, add them then rather than carrying unused overhead now.
- `knowledge-librarian.yaml`'s agent step always runs the pinned, reviewed wrapper script directly - never a repository variable's content as a shell command. The `AGENT_CLI` variable can only choose *which* non-interactive agent runs, never *what command* runs, closing an earlier arbitrary-command-execution surface under that job's `contents: write` scope.

## Prompt-injection guards

The four skills read content they didn't author - repository files, external URLs, reader questions - and either act on it or hand it to a human. Each skill's own `SKILL.md` carries the guard for its own input path; this section is the map, not a restatement.

- **`.lokf/feedback.md` (lokf-librarian).** Written by lokf-docent from reader questions, consumed by the scheduled librarian agent - the one input path here that can originate from someone with no repository access, reaching an agent that runs with `contents: write` / `pull-requests: write` (below). `lokf-librarian/SKILL.md` requires resolving only the question or disagreement an entry names, from the source it points at - never from the entry's own wording - so a crafted entry phrased as a directive is read as the content it's reporting, not followed.
- **Fetched sources (lokf-curator).** The curator opens each concept's `resource`/`sources` and quotes it to a human before any verdict is recorded. `lokf-curator/SKILL.md` requires treating whatever a source contains as text to quote, never as instructions - and the verdict is always the human's ("does the source still say this?"), never the agent's own "looks consistent." An adversarial source can be quoted at a person; it cannot get itself accepted.
- **Fetched sources and the repository (lokf-docent).** Verifying an exact value, or falling back once the bundle has no answer, both mean opening something the skill didn't author. `lokf-docent/SKILL.md` requires treating that content as text to quote or summarize, never as instructions. Docent is also **read-only on `.lokf/knowledge/`**, and its only write path, `.lokf/feedback.md`, requires asking once per session first - never silent, never automatic.
- **Blast radius if a guard above ever fails.** The only unattended write path is `knowledge-librarian.yaml`: `contents: write` / `pull-requests: write` only (no broader scope); a dedicated step fails the job before any commit if the agent touched anything outside `.lokf/knowledge` and `.lokf/feedback.md` (the wrapper script's own contract is advisory - a misconfigured or compromised `AGENT_CLI` ignoring it is caught here, not trusted); commits, when they happen, still touch only those same paths (never `git add -A`); it never pushes to the default branch or auto-merges; and merging the resulting PR is a human decision like any other change here. The workflow also triggers only on `schedule`/`workflow_dispatch`, never on an issue comment or other event an outside contributor could fire directly.

**What this doesn't cover.** Ordinary repository content lokf-librarian scrapes while building or refreshing concepts (READMEs, docs, code) has no per-entry guard like feedback.md's - it relies on the same branch-protection and required checks that gate every other change to `main`, a materially higher trust level than unreviewed reader feedback, not an oversight. A reader's own phrasing to lokf-docent is likewise not filtered by anything in this repository - that boundary belongs to whichever agent harness runs the skill, not to a Markdown instruction file.
