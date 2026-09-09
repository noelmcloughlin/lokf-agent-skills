# Changelog

All notable changes to this repository are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows the rules in [CONTRIBUTING.md](CONTRIBUTING.md#release-process). All skills release together under one tag.

## [0.9.0] - 2026-09-09

Initial release: four [Agent Skills](https://agentskills.io/home) that turn a repository's scattered knowledge into a maintained, trusted [LOKF](https://lokf.nolan-nichols.com/) knowledge bundle - built once, kept current, and reviewed by a person, rather than rediscovered every session.

- `lokf-scaffolding` - bootstraps a fresh `.lokf/` sidecar into a repository that has none: tooling, docs, and a dummy skeleton from bundled templates.
- `lokf-librarian` - scrapes the repository, derives concepts with their sources, wires typed relationships, audits the bundle against the LOKF schema, and hands off for review. Runs often, including on a schedule; deals in facts about the repository, never in verdicts about truth.
- `lokf-curator` - a human curator's assistant: a one-screen trust and freshness report, and an opt-in review session that records a person's confirm/correct/retire/send-back verdict directly in the bundle's frontmatter.
- `lokf-docent` - the reader's entry point. Answers questions from the bundle first, states each concept's trust label in plain words, verifies exact values at the source, and - when the bundle has no answer - explores the repository directly and records the gap in `.lokf/feedback.md` for the librarian to pick up. See [`EXAMPLES.md`](EXAMPLES.md) for real question-and-answer transcripts.

This repository dogfoods its own skills: `.lokf/` here is a real bundle built by `lokf-scaffolding` and `lokf-librarian`, self-describing all four skills, this repository's own governance, and its CI.
