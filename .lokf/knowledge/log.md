# Change Log

## 2026-09-09

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
