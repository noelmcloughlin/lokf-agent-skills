---
type: Reference
id: https://lokf-agent-skills.example/knowledge/references/linkml
title: LinkML
description: The schema-modelling language LOKF is written in, and the generator suite that turns a schema into JSON Schema, Pydantic models, SHACL shapes, docs, and OWL.
genre: reference
resource: https://linkml.io/linkml/
generated:
  by: process:lokf-librarian
  at: "2026-09-09T10:00:00Z"
status: draft
verified:
- by: process:lokf-librarian
  at: "2026-09-09T17:00:00Z"
---

# Overview

LOKF is defined as a LinkML schema, which is why its JSON Schema, JSON-LD
context, SHACL shapes, and OWL ontology are all generated artifacts rather
than hand-maintained files.

It matters to a bundle owner at exactly one moment: when the 14-class
vocabulary stops fitting a deep or safety-critical domain. The answer is a
LinkML domain schema that extends LOKF's, which also yields Pydantic models,
JSON Schema, and rendered documentation from the same source - meeting people
who think in JSON or Python on their own ground rather than in RDF.
