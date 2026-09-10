# Review session - exact edits, identity, log, handoff

## Who is recording

Resolve once per session, in this order, and confirm aloud before the first write ("I'll record your answers as `human:<id>` - ok?"):

1. `gh api user --jq .login` (GitHub login - stable, matches `CODEOWNERS`).
2. `git config user.name`, slugified (`Ada Lovelace` -> `ada-lovelace`).
3. Ask.

Never use an email address - the bundle may be public. The actor string is `human:<id>` exactly (OKF §7); it is a literal, never turned into a link.  Timestamps are UTC, ISO 8601, quoted in YAML: `"2026-09-08T14:00:00Z"`.

## The verbs

Every example starts from this librarian-written frontmatter:

```yaml
type: Service
id: https://acme.example/knowledge/services/orders-api
title: Orders API
description: REST API serving order data to the CLI and web UI.
resource: services/orders/openapi.yaml
generated:
  by: process:lokf-librarian
  at: "2026-09-01T05:00:00Z"
verified:
  - by: process:lokf-librarian
    at: "2026-09-07T05:00:00Z"
status: draft
```

### Confirm

Append the person's event (keep every existing event; if `verified` is a bare mapping, turn it into a one-element list first), remove `status: draft`
(absent means stable), and propose `stale_after` from the curation policy - write it only after they accept or edit the date:

```yaml
verified:
  - by: process:lokf-librarian
    at: "2026-09-07T05:00:00Z"
  - by: human:ada-lovelace
    at: "2026-09-08T14:00:00Z"
stale_after: 2027-03-08
```

If the body has an `## Open questions` section and the person says those are answered, delete the section. Otherwise leave it.

### Wrong - send back (default)

Content untouched. Set `status: draft` (add it if absent) and add the person's note in plain prose under `## Open questions` at the end of the body, attributed and dated:

```markdown
## Open questions

- 2026-09-08, human:ada-lovelace: the endpoint moved to `/v2/orders` in July; this still shows the old path. Please re-derive from `services/orders/openapi.yaml`.
```

The librarian's next run reads this, fixes the fact from the source, and the concept comes back to the queue as a draft for re-confirmation.

### Wrong - correct now

Only when the person states the correct fact themselves. Make the smallest edit that expresses it (the one field, or the one sentence), then mark the content as human-authored and confirmed, and remove `draft`:

```yaml
endpoint: https://api.acme.example/v2/orders
generated:
  by: human:ada-lovelace
  at: "2026-09-08T14:05:00Z"
verified:
  - by: process:lokf-librarian
    at: "2026-09-07T05:00:00Z"
  - by: human:ada-lovelace
    at: "2026-09-08T14:05:00Z"
```

`generated` is replaced, not appended - it records who produced the *current* content. From now on the librarian will not rewrite this concept; if the repository later disagrees, it raises an open question instead (lokf-librarian, section 1). Never propose the correction yourself; if you think you know it, say so and let them decide.

### Retire

```yaml
status: deprecated
```

Nothing else changes. Retired concepts stay for links and history; the librarian leaves them alone.

### Later

Keep or set `status: draft`. If they name a date, write `stale_after`. No other edits.

## Log lines

Prepend under today's `## YYYY-MM-DD` heading in `.lokf/knowledge/log.md` (newest first, ISO date, matching the librarian's convention). One line for the session and one per retirement:

```markdown
## 2026-09-08

* **Curation**: human:ada-lovelace confirmed 4 concepts, sent 1 back, corrected 1, retired 1.
* **Deprecation**: [Legacy Orders Sync](../services/legacy-orders-sync.md) retired - replaced by the Orders API.
```

Write no log line for a session that changed nothing.

## The curation policy concept

Create `policies/knowledge-curation.md` on the first Step 3 request (or when the person asks "how often should we re-check things?"). It is a normal concept: the person reviews and confirms it like any other. Plain words; they edit the defaults:

```markdown
---
type: Policy
id: <BASE_IRI>policies/knowledge-curation
title: Knowledge curation policy
description: How often each kind of concept in this bundle is re-confirmed by a person, and who does it.
generated:
  by: human:<id>
  at: "<now>"
verified:
  - by: human:<id>
    at: "<now>"
---

# Who curates

<team or people, plain names - link to Person/Organization concepts if they exist>

# How often a person re-confirms

| Kind of concept | Re-confirm every |
| --- | --- |
| Services, datasets, tables, metrics, attested computations | 6 months |
| Policies, playbooks, tutorials, references, documents, people, organizations | 12 months |
| Glossary terms, explanations | 24 months |

The lokf-curator skill proposes `stale_after` from this table when a person confirms a concept. Change the table, not the skill.

# What "confirmed" means here

A named person opened the concept's source and agreed the concept still says what the source says. Automation re-checking that a file still exists is recorded separately and is not confirmation.
```

Derive `stale_after` as *confirmation date + the row's interval*, and always show the date before writing it.

## Recording something missing

When the person reports that the bundle lacks something ("there's no concept for the billing worker"), write a placeholder for the librarian - type, title, and one open question only. Never fill in facts you don't have:

```markdown
---
type: Service
id: <BASE_IRI>services/billing-worker
title: Billing worker
description: Placeholder - not yet derived from the repository.
status: draft
generated:
  by: human:<id>
  at: "<now>"
---

## Open questions

- <date>, human:<id>: reported missing. Librarian: derive from the repository (they mention `workers/billing/`).
```

Add a bullet to the nearest `index.md`? No - `index.md` is the librarian's; it will add the bullet when it fills the placeholder. Log the intake as part of the session's `**Curation**` line ("recorded 1 gap").

## Handing off

Git-tracked `.lokf/`: open a pull request scoped to `.lokf/` titled "Curation: <date>", body = the health line before and after, the verbs taken, and the `just lokf-validate` output (or "validation skipped - no `uv`"). The `knowledge-registrar.yaml` gate, if scaffolded, runs on it.

Gitignored `.lokf/`: there is no diff to show; hand the person the list of changed files and the health line instead.
