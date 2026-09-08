# Changelog

All notable changes to this repository are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows
the rules in [README.md](README.md#versioning). Both skills release together
under one tag.

## [Unreleased]

### Added

- Initial publication of `lokf-scaffolding` and `lokf-librarian` as a
  dedicated, installable Agent Skills repository, migrated from the
  `.agents/skills/` copy in the LOKF Enforcer Obsidian plugin.
- `scripts/validate-repository.sh` - repository-contract checks (skill
  directories, frontmatter/directory name match, no duplicate `SKILL.md`,
  relative-link resolution, script linting).
- `scripts/smoke-test-install.sh` - isolated install smoke test via the open
  skills CLI.
- `.github/workflows/validate.yml` - repository contract, Agent Skills spec
  (`gh skill publish --dry-run`), ShellCheck, and Markdown/link checks on
  every pull request and push to `main`.
- `.github/workflows/publish.yml` - maintainer-gated release
  (`workflow_dispatch`), never tag-triggered.
