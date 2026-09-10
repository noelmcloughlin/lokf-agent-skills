# Changelog

All notable changes to this repository are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows the rules in [README.md](README.md#versioning). All skills release together under one tag.

## [Unreleased]

## [0.12.0] - 2026-09-10

### Changed

- Renamed the `knowledge-validate.yaml` CI gate (and its scaffolding template counterpart) to `knowledge-registrar.yaml`, to name it for the registrar role it actually performs - keeping bundle records well-formed, never judging whether their content is true. Updated every cross-reference, including `README.md`'s own "fifth role" paragraph, which now names the gate directly. A repo that already scaffolded the old filename keeps working; re-scaffolding (or a manual rename) picks up the new name.

### Fixed

- Each `SKILL.md` (`lokf-curator`, `lokf-docent`, `lokf-librarian`, `lokf-scaffolding`) now declares `license: Apache-2.0` in its frontmatter, matching this repository's `LICENSE`. Fixes the `recommended field missing: license` warning `gh skill publish` raised on all four skills during the `v0.11.0` release.

## [0.11.0] - 2026-09-10

### Security

- `knowledge-librarian` workflow now runs a fixed, reviewed in-repo script (`bash .lokf/scripts/knowledge-librarian.sh`) instead of an arbitrary command string from a repository variable, so changing *what executes* goes through code review rather than an unreviewed Settings edit.
- `knowledge-librarian` workflow split into two jobs: the agent (third-party code) runs in a `contents: read` job with no persisted git credentials and hands its proposed change to a separate privileged job - which runs no agent code - as a patch artifact. Only that job holds `contents: write` / `pull-requests: write`, so a compromised agent cannot reach a write-scoped credential. Top-level workflow permissions now default to none.
- `knowledge-librarian.sh` wrapper now parses `AGENT_CLI` into a quoted argv array (removing the unquoted expansion that word-split the value at the command position) and enforces the bundle boundary after the agent runs: it fails if the agent modified any path outside `.lokf/knowledge/` (`.lokf/feedback.md` allowed), so the "edit only the bundle" contract is enforced, not merely requested.

### Changed

- Arm the scheduled librarian run with the `KNOWLEDGE_LIBRARIAN_ENABLED` repository variable set to `true` (replaces `KNOWLEDGE_LIBRARIAN_CMD`); `AGENT_CLI` is unchanged. Updated the `lokf-scaffolding` templates, the dogfooded workflow, the wrapper-script header, and the `lokf-scaffolding`/`lokf-librarian` automation docs to match.

## [0.9.0] - 2026-09-09

Initial release: four [Agent Skills](https://agentskills.io/home) that turn a repository's scattered knowledge into a maintained, trusted [LOKF](https://lokf.nolan-nichols.com/) knowledge bundle - built once, kept current, and reviewed by a person, rather than rediscovered every session.

- `lokf-scaffolding` - bootstraps a fresh `.lokf/` sidecar into a repository that has none: tooling, docs, and a dummy skeleton from bundled templates.
- `lokf-librarian` - scrapes the repository, derives concepts with their sources, wires typed relationships, audits the bundle against the LOKF schema, and hands off for review. Runs often, including on a schedule; deals in facts about the repository, never in verdicts about truth.
- `lokf-curator` - a human curator's assistant: a one-screen trust and freshness report, and an opt-in review session that records a person's confirm/correct/retire/send-back verdict directly in the bundle's frontmatter.
- `lokf-docent` - the reader's entry point. Answers questions from the bundle first, states each concept's trust label in plain words, verifies exact values at the source, and - when the bundle has no answer - explores the repository directly and records the gap in `.lokf/feedback.md` for the librarian to pick up. See [`EXAMPLES.md`](EXAMPLES.md) for real question-and-answer transcripts.

This repository dogfoods its own skills: `.lokf/` here is a real bundle built by `lokf-scaffolding` and `lokf-librarian`, self-describing all four skills, this repository's own governance, and its CI.
