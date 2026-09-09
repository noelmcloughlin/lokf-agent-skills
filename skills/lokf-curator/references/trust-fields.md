# Trust fields - what each plain label means in frontmatter

The human-facing labels in SKILL.md map onto OKF v0.2 §5 / LOKF Golden Rule 6 fields. Everything is computed from frontmatter with an ordinary YAML parser - no toolkit, no graph. (For the curious, the last column is the RDF predicate the LOKF toolkit projects each field to; it is never needed here.)

| Label | Rule | Field(s) | RDF (optional) |
| --- | --- | --- | --- |
| Confirmed by a person | any `verified[].by` starts with `human:` | `verified` | `lokf:verified` -> `prov:wasAssociatedWith` |
| Checked by automation only | `verified` present, no `human:` actor | `verified` | same |
| Nobody has checked this yet | no `verified` key | `verified` | - |
| Still a draft | `status: draft` | `status` | `schema:creativeWorkStatus` |
| Retired | `status: deprecated` | `status` | same |
| Edited since a person last confirmed it | `generated.at` later than the latest `human:` `verified[].at` | `generated`, `verified` | `prov:wasGeneratedBy` -> `prov:endedAtTime` |
| Past its review date | `stale_after` <= today | `stale_after` | `schema:expires` |
| Due soon | today < `stale_after` <= today + 30 days | `stale_after` | same |
| *N* other concepts rely on this | count of concepts whose typed relations target this concept's `id` | the ten relation fields + `relations[].target` | various |
| Doesn't fit the built-in vocabulary | `type` not one of the 14 classes | `type` | `@type` |

## Parsing notes

- **Bare `verified` mapping** (`verified: { by, at }`) MUST be read as a one-element list (spec §5.2).
- **Absent `status`** means stable. Only `draft`, `stable`, `deprecated` are valid; anything else counts as "doesn't fit" for the vocabulary line.
- **Datetimes** are ISO 8601 with a UTC offset (`2026-09-08T14:00:00Z`); `stale_after` is a plain date (`YYYY-MM-DD`) in the LOKF schema. Compare dates as strings after normalising both to `YYYY-MM-DD` - it avoids timezone arithmetic and is exact for ISO forms.
- **Missing `generated.at`**: fall back to the v0.1 `timestamp`; if neither exists, the concept cannot be "edited since confirmed" - leave it out of that label rather than guessing.
- **Relation targets** may be full IRIs or bundle-relative ids. Normalise by resolving relative values against `base_iri` in `knowledge/index.md` before counting. The ten relation fields: `isPartOf`, `hasPart`, `references`, `dependsOn`, `derivedFrom`, `about`, `sameAs`, `relatedTo`, `definedBy`, `source`; plus each `relations[].target`.
- **The 14 classes**: `Dataset`, `Table`, `Metric`, `Service`, `Playbook`, `Tutorial`, `Explanation`, `Policy`, `GlossaryTerm`, `Reference`, `Document`, `Person`, `Organization`, `AttestedComputation`. Compare after removing spaces (`Attested Computation` normalises to `AttestedComputation`).
- Skip `index.md` and `log.md` at every level; they are reserved files, not concepts.
- **`## Open questions` is a heading, not a substring.** Match a line that *is* the heading (start of line, nothing else on it) - never a mention of it anywhere in the text. Concept bodies legitimately quote the string in prose (a bundle describing these very skills does it repeatedly), and a substring match then invents open questions that don't exist and pushes those concepts up the queue. The same applies when extracting the first bullet: read the lines *after* that heading, not around the match.
- **Retired concepts** (`status: deprecated`) are counted once, under *Retired*, and excluded from every other label and from the queue - nobody needs to re-check something that is no longer current. `N` in "*a* of *N*" counts every concept, retired ones included.
- **Labels overlap by design.** A concept can be confirmed by a person *and* past its review date. The health counts are not a partition - only `N` is a total - so don't expect them to add up.

## Ranking for "Worth ten minutes today"

Take at most five, in this order; within a group, most-relied-upon first, then newest `generated.at`:

1. Past its review date, or edited since a person last confirmed it.
2. Still a draft **with** an `## Open questions` heading (the librarian or a previous session asked for a human).
3. Nobody has checked this yet.
4. Still a draft without open questions; checked by automation only.

Never rank by class alone - a glossary term twelve concepts rely on outranks an unreferenced service.

## Report template

Fill every placeholder; keep the order; add nothing else. `<Source>` is the concept's `resource` or first `sources[].resource`, or "no source recorded".

```text
Knowledge bundle - <bundle title> - <YYYY-MM-DD>
Confirmed by a person: <a> of <N> · Checked by automation only: <b> · Nobody has checked: <c> · Drafts: <d> · Past review date: <e> · Edited since confirmed: <f> · Retired: <g>

Worth ten minutes today
1. <Title> (<Class>) - <why: e.g. "past its review date (2026-08-01)" / "4 other concepts rely on this; nobody has checked it"> - <Source>
2. ...
(up to 5)

Open questions the librarian left
- <Title>: <text of the first bullet under its ## Open questions, without the dash> (or: none)

Feedback from readers: <k> entries waiting in .lokf/feedback.md   | or: none

Vocabulary fit: <n> concept(s) don't fit the built-in vocabulary (<types>)   | or: fine

<remaining> more not yet checked. Run again anytime - every confirmation counts.
Want to go through these now?
```

The health line is the one number to watch over time: "confirmed by a person: *a* of *N*" rising is the bundle earning trust. It is derived every time, never stored - the spec deliberately keeps scores out of frontmatter.
