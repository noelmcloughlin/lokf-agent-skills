# Change Log

## 2026-09-09

* **`SECURITY.md` gained an "Interactive use: scope is advisory, not
  enforced" section**: prompted by a user question about `npx skills add`'s
  generic post-install warning ("review skills before use; they run with
  full agent permissions"). The warning is boilerplate - the Agent Skills
  format has no permission manifest, so it applies to any skill regardless
  of content - but it surfaced a real, honest gap: each skill's `Scope:`
  line is prose an agent is expected to follow, not a checked boundary,
  except on the one path that's actually unattended (the scheduled
  workflow, per the write-scope enforcement above). Interactive sessions -
  the far more common case - rely entirely on a person reviewing what the
  agent changed. Made that explicit rather than letting `Scope:` read as a
  stronger guarantee than it is. Updated `policies/security.md` to match.
* **Security hardening on `knowledge-librarian.yaml`**: prompted by an
  external security scan of the scaffolding templates. Two findings: (1,
  MEDIUM) the agent step let a repository variable's *content* become the
  executed shell command (`bash -c "${KNOWLEDGE_LIBRARIAN_CMD}"`), wider than
  needed under that job's `contents: write` scope - fixed by removing that
  variable entirely; the workflow now always invokes the pinned, reviewed
  `.lokf/scripts/knowledge-librarian.sh` directly, and `AGENT_CLI` only
  selects which agent runs, never what command runs. (2, LOW) the wrapper
  script's contract - only touch `.lokf/knowledge/`, never run git - was
  advisory, unenforced - fixed by a new "Enforce the agent's write scope"
  step that fails the job before any commit if anything else changed
  (excluding `.lokf/uv.lock`, a known `uv sync` side effect). Applied to the
  scaffolding template and this repository's dogfooded copy in lockstep (both
  `.yaml` and `.sh`), plus `SECURITY.md`, `scheduled-task.md`, and
  `automation.md`. Updated `policies/security.md` to match.
* **Curation**: human:noelmcloughlin confirmed 5 concepts (the ones most
  relied-upon and least-checked per the Step 1 report): `references/agent-skills-specification`,
  `references/okf-specification`, `glossary/knowledge-bundle`,
  `playbooks/lokf-librarian-skill`, `references/lokf-specification`. Sent 0
  back, corrected 0, retired 0. One evidence-citation error caught mid-session
  (a quote presented as coming from a single "Section 1" of
  `lokf-librarian/SKILL.md` was actually a synthesis drawn from three separate
  places in the file) - re-quoted properly and the underlying claim held; a
  one-off slip in how evidence was presented, not a defect in the concept or
  a pattern worth changing lokf-librarian's instructions over.
* **AI_COVENANT.md gained a "Repository-Owned Agent Automation" section**:
  raised by the maintainer after noticing this same run's own commit carried
  an AI co-authorship trailer the covenant already discourages (fixed by
  amending that commit). The deeper gap: the covenant's model is a person
  drafting with AI help then submitting, but `lokf-librarian` (scheduled or
  interactive) and `lokf-curator` both have an *agent* executing the actual
  commit/PR. The scheduled workflow already gets this right by convention
  (bot identity, no trailer, mandatory review) but the convention was never
  written down. New section makes it explicit: bot-or-maintainer identity
  with no trailer either way, every change lands as a human-reviewed PR
  (never an agent's own approval), and a curator-recorded human verdict must
  trace to that person's real-time answer to that specific item. Updated
  `policies/ai-covenant.md` to match.
* **Steady-state refresh, second pass**: re-verified all 18 internal-resource
  concepts (no drift - the two upstream commits since the prior pass,
  `e6d5633` and `b743c84`, were prose tidying with no facts this bundle
  asserts) and, for the first time since bootstrap, fetched and checked all
  seven external Reference concepts against their live sources - all still
  accurate. Details and the one loose end (an unconfirmed GitHub CLI version
  number) are in `playbooks/knowledge-sources.md`.
* **Correctness bug found and fixed**: a same-day commit (`e6d5633`) had
  flipped the `sameAs` typed-relation's RDF predicate from the correct
  `schema:sameAs` to `owl:sameAs` in `lokf-librarian/SKILL.md`'s Golden Rule
  4 - confirmed wrong against both the LOKF specification site and the raw
  `lokf.yaml` schema. Not just documentation: `just lokf-check-refs`'s SPARQL
  query filtered on the same wrong predicate in both `.lokf/justfile` and the
  `lokf-scaffolding` template it's copied from, so a `sameAs` relation's
  target would have silently never been checked for existing. Fixed all
  three; `lokf validate` and `lokf-check-refs` still pass.
* **Tooling floor bumped**: `lokf` reached 0.7.0 on PyPI (floor was
  `>=0.5.0`, already resolving to 0.7.0 with no upper bound). Reviewed
  0.6.0/0.7.0 release notes for breaking changes affecting this sidecar -
  none found. Bumped the floor to `>=0.7.0` to match what's actually locked.
* **Feedback consumed, no bundle change**: the one open `.lokf/feedback.md`
  entry asked about a roadmap for a fifth skill; re-searched the repository
  and found nothing to derive a concept from, so cleared it rather than
  inventing one, per the docent's own note.
* **Orphan sweep**: `LICENSE`, `llms.txt`, and `EXAMPLES.md` had no
  source-map row; added one, all three staying excluded as concepts (see
  `playbooks/knowledge-sources.md` for why).
* **Initialization**: Scaffolded the LOKF bundle for LOKF Agent Skills, then
  ran a bootstrap discovery pass over the repository. Populated it with 25
  concepts: 8 playbooks (the four skills, the source map, contributing,
  releasing, repository validation), 7 references (the LOKF, OKF and Agent
  Skills specifications, the lokf toolkit, LinkML, and the two installer
  CLIs), 4 glossary terms, 4 policies, and 2 explanations. `base_iri` is a
  placeholder (`lokf-agent-skills.example`) pending a namespace the project
  controls.
* **Removed**: the scaffolded `services/` directory and its two dummy
  concepts - this repository ships documentation, agent skills, and CI, and
  has no `Service`, `Dataset`, `Table`, or `Metric` assets to describe.
* **Steady-state refresh**: re-verified all 17 internal-resource concepts
  against their current files (no factual drift found) and added a
  `process:lokf-librarian` `verified` event to each. Consciously excluded a
  new decorative asset, `.assets/lokf-agent-skills-card.svg`, recording it
  in `playbooks/knowledge-sources.md` instead of as a concept.
* **Audit**: `uv run lokf validate knowledge` (previously unavailable) found
  12 of 25 concepts using a bare scalar on a multivalued relation slot
  (`dependsOn`/`definedBy`/`relatedTo`) - schema-invalid despite reading
  naturally. Fixed by wrapping each as a one-item list, content unchanged.
  Same failure was independently visible in this repository's own
  `Knowledge Bundle Validation` GitHub Actions run. Clarified
  `lokf-librarian/SKILL.md` Golden Rule 4 and section 2 so it doesn't recur.
* **Source map extended**: an orphan sweep found three `.github/` surfaces
  accounted for by neither a concept nor a source-map row - the two dogfooded
  `knowledge-*.yaml` workflows, and the issue/pull-request templates alongside
  `dependabot.yml`. Added a row for each in
  `playbooks/knowledge-sources.md`, keeping all of them excluded as concepts
  (intake forms and maintenance config carry no reusable knowledge), and
  recorded the defects the sweep turned up in each.
* **Versioning policy re-sourced**: the `vMAJOR.MINOR.PATCH` bump definitions
  moved out of `README.md` (slimmed) into `CONTRIBUTING.md`'s release-process
  section, where the rest of the release mechanics already live. Repointed
  `policies/versioning.md`'s `resource` to follow them - its body was
  asserting definitions its stated source no longer carried - along with the
  cross-references in `README.md` and `CHANGELOG.md`.
* **Prompt-injection guards added and documented**: a synergy review against
  an external curation-patterns catalog (ai4curation.io) found that
  `.lokf/feedback.md` reached the scheduled librarian agent with no guard
  against a reader-submitted entry phrased as a directive. Added an explicit
  guard to `lokf-librarian/SKILL.md` (resolve only from the source an entry
  names, never its wording), and the same guard for the other two content-
  fetching paths in `lokf-curator/SKILL.md` and `lokf-docent/SKILL.md`.
  `SECURITY.md` gained a **Prompt-injection guards** section naming all three
  plus the unattended-write-path blast-radius containment and what remains
  unguarded (ordinary repository content, a reader's own phrasing); refreshed
  `policies/security.md` to match.
