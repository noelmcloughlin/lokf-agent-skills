## Summary

## Which skill(s) changed?

- [ ] lokf-librarian
- [ ] lokf-scaffolding
- [ ] lokf-curator
- [ ] lokf-docent
- [ ] repository packaging only (CI, docs, templates unrelated to skill content)

## Checklist

- [ ] `bash scripts/validate-repository.sh` passes locally
- [ ] `gh skill publish --dry-run` passes locally (or CI's `validate-skills` job is green)
- [ ] If `SKILL.md` frontmatter or a `references/`/`templates/` cross-reference changed, links still resolve
- [ ] `CHANGELOG.md` updated under `[Unreleased]` if this changes skill behavior

## AI Assistance

If you used AI tools while preparing this PR, you are still the author and responsible for understanding, verifying, and defending your submission. Please engage with reviewers personally rather than through your agent during feedback and revisions. Don't dump LLM
output into this PR without curation. See our [AI Covenant](AI_COVENANT.md) for details.
