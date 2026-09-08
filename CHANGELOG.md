# Changelog

All notable changes to this repository are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows the rules in [README.md](README.md#versioning). All  skills release together under one tag.

## [Unreleased]

### Added

- Initial publication of `lokf-scaffolding`, `lokf-librarian`, `lokf-curator`, and `lokf-docent` as a dedicated, installable Agent Skills repository.
- `lokf-docent` - the reader's side of the loop. Answers questions from the bundle first (TOC, then one to three concepts, then typed relations), states each concept's trust label in plain words, verifies exact values at the concept's `resource`, falls back to the repository only when the bundle has no answer, and - after asking once per session - records misses and disagreements in `.lokf/feedback.md` for the librarian to consume. Read-only on `.lokf/knowledge/`.
- `lokf-curator` - a human curator's assistant. A one-screen trust and freshness report computed from the bundle's frontmatter (confirmed by a person / checked by automation only / nobody has checked / drafts / past review date / edited since confirmed, plus the most relied-upon unchecked concepts); an opt-in review session that shows the source before the claim and records a person's Confirm, Wrong (send back or correct now), Retire, or Later as OKF v0.2 `verified`, `status`, `stale_after`, and `generated`; a curation-policy concept for review cadence; placeholders for reported gaps; loose guidance on domain schemas when the 14-class vocabulary stops fitting.
- `lokf-librarian` - the hand-off channel to the curator: concepts it creates start as `status: draft`; a concept it re-confirms against its source gets one `process:lokf-librarian` `verified` event; a claim it cannot settle gets `draft` plus a plain-prose `## Open questions` section; human-authored content (`generated.by: human:`) is never rewritten, only questioned; the PR/hand-off ends with a "For the curator" summary; every refresh first consumes `.lokf/feedback.md`, and the scheduled workflow commits that file alongside `knowledge/`.
- `lokf-scaffolding` - two trust queries in `queries.http`; the `llms.txt` and README-fragment templates tell consumers what `status: draft` means.
- `scripts/validate-repository.sh` - repository-contract checks (skill directories, frontmatter/directory name match, no duplicate `SKILL.md`, relative-link resolution, script linting).
- `scripts/smoke-test-install.sh` - isolated install smoke test via the open skills CLI.
- `.github/workflows/validate.yml` - repository contract, Agent Skills spec (`gh skill publish --dry-run`), ShellCheck, and Markdown/link checks on every pull request and push to `main`.
- `.github/workflows/publish.yml` - maintainer-gated release (`workflow_dispatch`), never tag-triggered.
