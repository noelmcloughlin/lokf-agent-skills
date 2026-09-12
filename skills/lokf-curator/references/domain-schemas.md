# When the built-in vocabulary stops fitting

LOKF ships a deliberately small vocabulary: 15 classes, ten typed relations, and a handful of trust fields. That is enough for most repositories and is what keeps bundles portable. It is not enough forever.

## The signs

- The report's **vocabulary fit** line keeps growing - concepts whose `type` isn't one of the 15 classes, tolerated as generic concepts (Golden Rule 7) but carrying no agreed meaning.
- Concepts sprout many producer-defined keys (`dosage`, `contraindication`, `jurisdiction`, `failure_mode`) that no validator checks and no other bundle understands.
- The domain is one where a wrong or ambiguous field has real consequences: medicine, law, finance, safety engineering, anything regulated.

## What to do about it (loose guidance)

Keep the OKF/LOKF mechanics - one Markdown file per concept, frontmatter, the trust fields, the bundle-root header - and give the *domain* its own schema. LOKF's schema is written in [LinkML](https://linkml.io/linkml/); LinkML schemas can import another schema and add classes and slots, and the same LinkML tooling then generates the JSON Schema, JSON-LD context, and SHACL shapes for the extended vocabulary. Check the [linkml](https://linkml.io) and [`lokf` project](https://github.com/nicholsn/lokf) for the supported extension path before designing one - don't invent a mechanism.

## You already have the tooling

The scaffolded sidecar depends on `lokf[build]`, and that `[build]` extra pulls in the `linkml` package - the full generator suite, not just the runtime So a domain schema costs no new installation; from `.lokf/`:

```bash
uv run gen-json-schema domain.yaml > domain.schema.json   # what validators check
uv run gen-pydantic    domain.yaml > domain_models.py     # typed Python models
uv run gen-doc -d docs domain.yaml                        # browsable reference docs
uv run gen-shacl       domain.yaml                        # shapes for the projected graph
```

The same schema serves the people who think in JSON, Python, or docs pages and the people who think in graphs - which is the point of writing it in LinkML rather than in any one of those. If your sidecar pins plain `lokf` without the `[build]` extra, add the extra rather than installing `linkml` separately, so the two stay version-compatible.

## Validating values against an external vocabulary

A domain schema often binds a slot to codes from an external controlled vocabulary - a `diagnosis` slot's permissible values `meaning`-bound to SNOMED CT terms, say. That binding is a LinkML concern; neither LOKF's schema nor `lokf validate` checks it - schema validation confirms the *shape* is right, not that a bound term still exists, isn't obsolete, or carries the label a concept assumes.

[`linkml-term-validator`](https://github.com/linkml/linkml-term-validator), backed by the [Ontology Access Kit](https://github.com/INCATools/ontology-access-kit), checks that gap: it queries the live ontology behind a `meaning:` binding and reports whether the term still exists, isn't deprecated, and matches the expected label. Run it as an additional, optional gate alongside `lokf validate`, never a replacement for it, and treat "the ontology service was unreachable" as its own non-passing result rather than a silent pass. It only applies once a domain schema introduces a binding like this - a bundle using LOKF's built-in vocabulary alone has nothing for it to check.

Roles stay as they are:

- **The curator raises it.** A rising vocabulary-fit count, or a critical domain, is a report line and a conversation with the team - not something this skill fixes.
- **The team decides** whether a domain schema is worth owning (it is a small piece of governed software).
- **The librarian applies it**, validating concepts against the extended schema through the same `lokf` toolkit.

Until then, tolerate the misfits: the spec says consumers MUST NOT reject unknown types. A misfit concept is still knowledge - it just isn't yet *checkable* knowledge.
