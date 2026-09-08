---
lokf_version: "0.2"
okf_version: "0.2"
base_iri: https://lokf-agent-skills.example/knowledge/
context: https://w3id.org/lokf/context.jsonld
title: LOKF Agent Skills Knowledge Bundle
description: Four Agent Skills that turn a repository's scattered knowledge into a maintained, trusted LOKF knowledge bundle.
license: https://creativecommons.org/licenses/by/4.0/
publisher:
  type: Person
  id: https://lokf-agent-skills.example/knowledge/person/noel-mcloughlin
  name: Noel McLoughlin
---

# LOKF Agent Skills Knowledge Bundle

A [LOKF](https://lokf.nolan-nichols.com) knowledge base for LOKF Agent Skills. Every Markdown file under `knowledge/` is one concept; together they form a queryable knowledge graph, derived from this repository's code and docs.

# Playbooks

* [lokf-scaffolding skill](playbooks/lokf-scaffolding-skill.md) - one-shot bootstrap of a `.lokf/` sidecar from templates.
* [lokf-librarian skill](playbooks/lokf-librarian-skill.md) - derives and maintains the concepts; facts, never verdicts.
* [lokf-curator skill](playbooks/lokf-curator-skill.md) - a human curator's assistant; verdicts, never facts.
* [lokf-docent skill](playbooks/lokf-docent-skill.md) - answers from the bundle and records what it lacked.
* [Knowledge sources](playbooks/knowledge-sources.md) - where this bundle was derived from, and how to re-check it.
* [Contributing](playbooks/contributing.md) - local checks and the role boundary a change must respect.
* [Releasing](playbooks/releasing.md) - the maintainer-gated publish path.
* [Repository validation](playbooks/repository-validation.md) - what CI enforces on every pull request.

# References

* [LOKF specification](references/lokf-specification.md)
* [OKF specification (v0.2)](references/okf-specification.md)
* [Agent Skills specification](references/agent-skills-specification.md)
* [LOKF toolkit (lokf on PyPI)](references/lokf-toolkit.md)
* [LinkML](references/linkml.md)
* [gh skill (GitHub CLI)](references/gh-skill-cli.md)
* [Open Skills CLI (npx skills)](references/open-skills-cli.md)

# Glossary

* [LOKF](glossary/lokf.md)
* [OKF](glossary/okf.md)
* [Knowledge bundle](glossary/knowledge-bundle.md)
* [Trust label](glossary/trust-label.md)

# Policies

* [AI covenant](policies/ai-covenant.md)
* [Security policy](policies/security.md)
* [Versioning policy](policies/versioning.md)
* [Code of conduct](policies/code-of-conduct.md)

# Explanation

* [Why four roles rather than one skill](explanation/why-four-roles.md)
* [Why the skills live in their own repository](explanation/why-a-distribution-repository.md)
