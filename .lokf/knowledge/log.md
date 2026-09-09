# Change Log

## 2026-09-09

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
