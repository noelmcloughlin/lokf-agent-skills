## Summary

## Which skill(s) changed?

- [ ] lokf-librarian
- [ ] lokf-scaffolding
- [ ] repository packaging only (CI, docs, templates unrelated to skill content)

## Checklist

- [ ] `bash scripts/validate-repository.sh` passes locally
- [ ] `gh skill publish --dry-run` passes locally (or CI's `validate-skills` job is green)
- [ ] If `SKILL.md` frontmatter or a `references/`/`templates/` cross-reference changed, links still resolve
- [ ] `CHANGELOG.md` updated under `[Unreleased]` if this changes skill behavior
