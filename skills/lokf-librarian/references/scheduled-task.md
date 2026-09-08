# Scheduled librarian task (Karpathy rule) - operating manual

**Everything here assumes `.lokf/` is git-tracked** (lokf-scaffolding's
Step 0). If it's gitignored, don't scaffold or rely on any of this:
`knowledge-validate.yaml` never triggers, since nothing under `.lokf/**` is
ever part of a PR diff, and `knowledge-librarian.yaml`'s change-detection step
(`git status --porcelain -- .lokf/knowledge`, in the workflow) silently reports no
changes for an ignored path - not a failure you'd notice, just a scheduled job
that quietly does nothing, forever. Get periodic freshness in that mode from a
scheduler that isn't gated on git history instead - cron, a systemd timer, or
just re-running this skill by hand.

Keep the graph continuously accurate rather than rewriting it in bursts. Three
pieces automate this rebuild loop - the **lokf-scaffolding** skill's Step 5
scaffolds them from `../../lokf-scaffolding/templates/` (`github/*.yaml`, `scripts/knowledge-librarian.sh`); this file is their operating manual:

**`.github/workflows/knowledge-librarian.yaml`** - the rebuild workflow. Runs weekly (Mondays, 05:00 UTC) and on demand (`workflow_dispatch`). Each run: checks out full history -> sets up `uv` -> installs the `lokf` sidecar -> runs the agent -> validates -> diffs `.lokf/knowledge/` (only the bundle, so tool artifacts never trigger a PR) -> if anything changed, commits to a fresh `knowledge-librarian/<date>-<run_id>` branch and opens a review PR via `github-script`. Guardrails: it holds only `contents: write` + `pull-requests: write`, never pushes to the default branch, never auto-merges, and opens no PR when nothing changed. A no-change run must leave the bundle byte-for-byte untouched, including `log.md` (section 1's log policy).

**`.lokf/scripts/knowledge-librarian.sh`** - the agent wrapper the workflow invokes. Point the `KNOWLEDGE_LIBRARIAN_CMD` repository variable at `bash .lokf/scripts/knowledge-librarian.sh` and set `AGENT_CLI` to your non-interactive agent command. The script selects the lokf-librarian skill, builds a prompt telling the agent to follow it and re-scrape the repo, then calls `AGENT_CLI`. Its contract: it edits **only** files under `.lokf/knowledge/` and performs no git/PR operations - the workflow owns branch/commit/PR. If `KNOWLEDGE_LIBRARIAN_CMD` is unset, the workflow's agent step is a safe no-op, so the workflow is harmless until you wire the agent up.

**`.github/workflows/knowledge-validate.yaml`** - the gate. Its `validate` job runs `uv run lokf validate knowledge` on the librarian PR (and on every `.lokf/**` PR and its own weekly schedule); keep it green. The bar: the projected RDF graph should always describe the repository as it is *today*.
