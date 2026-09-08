# Step 5 automation - what the three files do and how to wire them

Scaffolding these is one-time setup; how they behave at run time is lokf-librarian's operating manual ([`../../lokf-librarian/references/scheduled-task.md`](../../lokf-librarian/references/scheduled-task.md)). Applies only to a **git-tracked** `.lokf/` on **GitHub** - see SKILL.md Step 5 for why a gitignored bundle makes both workflows a permanent no-op.

## `knowledge-validate.yaml` - the validation gate

Runs `uv run lokf validate knowledge` on every pull request touching `.lokf/**` (or the workflow itself), weekly (Mondays 06:00 UTC), and on demand. Read-only (`contents: read`); superseded runs on the same ref are cancelled. Keep it green: the bar is that the projected graph describes the repository as it is today.

## `knowledge-librarian.yaml` - the scheduled refresh loop

Weekly (Mondays 05:00 UTC) and on demand. Checks out full history, sets up `uv`, installs the sidecar, runs the librarian agent, validates, diffs `.lokf/knowledge/` only (so tool artifacts such as a fresh `uv.lock` never trigger a PR), and if anything changed commits it - together with `.lokf/feedback.md`, the reader-feedback file lokf-docent writes and the librarian consumes - to a fresh `knowledge-librarian/<date>-<run_id>` branch and opens a review PR via `github-script`. Guardrails: `contents: write` + `pull-requests: write` only; never pushes to the default branch; never auto-merges; no PR when nothing
changed. It is **inert until wired**:

| Repository variable | Value |
|---|---|
| `KNOWLEDGE_LIBRARIAN_CMD` | `bash .lokf/scripts/knowledge-librarian.sh` |
| `AGENT_CLI` | your non-interactive agent command, accepting a prompt via `-p` (use a repo *secret* instead if it embeds a token, and read `secrets.AGENT_CLI` in the workflow) |

With `KNOWLEDGE_LIBRARIAN_CMD` unset the agent step is a safe no-op, so the workflow is harmless until you wire it up.

## `knowledge-librarian.sh` - the agent wrapper

Generic, no placeholders. Resolves the repo root from its own location, finds `lokf-librarian/SKILL.md` (`.claude/skills/`, `.github/skills/`, `.agents/skills/`, `skills/` - extend the `candidate` list if your repo differs, and run the script once to confirm), builds a prompt telling the agent to follow that skill, and calls `$AGENT_CLI -p`. Contract the workflow relies on: it only reads the repo and writes under `.lokf/knowledge/`; it never commits, pushes, or opens PRs; it exits 0 whether or not anything changed (the workflow diffs the tree to decide about a PR).

## Customising

Runner: `ubuntu-latest` is the only project-specific choice - swap in a self-hosted runner group and internal-CA env if your org needs them. Actions are pinned to commit SHAs with a version comment; bump them with your usual update tooling (Dependabot/Renovate handle SHA pins).
