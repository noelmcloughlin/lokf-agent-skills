# Portability - reusing lokf-scaffolding in another repo

This skill is repo-agnostic; run it in any repository, including an empty one.

## It pairs with lokf-librarian

The scaffolded wrapper script resolves `lokf-librarian/SKILL.md` from the repo's skill directory, checking `.claude/skills/` (Claude Code), then
`.github/skills/` (Copilot-style agents), `.agents/skills/` (a generic, tool-agnostic convention), then bare `skills/` (a repo that publishes the
skills it also uses). Install **all four** - `lokf-scaffolding`, `lokf-librarian`, `lokf-curator`, `lokf-docent` - each is a directory,
including `templates/` and `references/` - into whichever of those the new repo uses. If none fits, add that directory to the wrapper's `candidate` list rather than leaving a fourth, silently-unchecked convention. All skills are generic: copy them unmodified; the librarian's first run discovers the project's knowledge sources itself.

This repository ([`lokf-agent-skills`](https://github.com/noelmcloughlin/lokf-agent-skills)) is the sole, canonical source of all four LOKF skills - install from it via `gh skill install` / `npx skills add` rather than copy-pasting, and pin them all to the same release.

## Tooling

Validation uses [`uv`](https://docs.astral.sh/uv/) + the `lokf` PyPI package ([`just`](https://just.systems/) is optional). The files scaffold fine without them; only Step 4's validation needs them installed - see Step 4 for the raw-schema fallback when Python is unavailable.

## The host need not be git, GitHub, or Linux

The scaffold is just files, so any directory tree works: a local or shared filesystem, or Storage-as-a-Service content mounted/synced locally (Drive,
Dropbox, an S3/blob mount, ...).

- **No git** - `.lokf/.gitignore` is inert: keep it (a VCS may arrive later) or drop it. Skip the "commit" instructions, rely on the platform's own versioning/backup, and review changes by whatever mechanism the host offers instead of PRs. Step 5 does not apply.
- **Not GitHub** (other forges, or none) - Step 5's workflow files are GitHub Actions-specific. Scaffold only the wrapper script and schedule it, plus `lokf validate` as the gate, with the platform's equivalent: another CI's pipeline, cron, or a systemd timer. The wrapper needs only `bash` and the
  lokf-librarian skill file.
- **Not Linux/POSIX** - run the `justfile` recipes and the wrapper from a POSIX shell (Windows: WSL or Git Bash), or bypass them and call `uv run lokf ...` directly; `uv` and the toolkit are cross-platform. The Step 2 `knowledge_bundle` symlink (`ln -s`) needs the same POSIX shell, or Windows Developer Mode plus `mklink /D knowledge_bundle .lokf\knowledge`; a filesystem that doesn't support symlinks at all (some FAT32/exFAT or older network mounts) just skips it too - it's a convenience pointer, and every skill and toolkit command still addresses `.lokf/knowledge` directly.
