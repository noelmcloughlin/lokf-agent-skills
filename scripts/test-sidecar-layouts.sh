#!/usr/bin/env bash
# Layout tests for the two ways lokf-sidecar lays a bundle down (SKILL.md Step 0).
#
# The bundle has two names - `.lokf/knowledge`, which the tools address, and
# `knowledge_bundle`, which people and Obsidian open - and one is always a link
# onto the other: the doorway link in a code repository (the default layout),
# the tools' link in a notes vault or shared folder (the visible layout). A git
# pathspec never traverses a symlink, so anything that scopes a diff to the
# bundle must name both paths or it silently misses one layout. These tests pin
# that for the template files that do so, and for the `just lokf-link` recipe:
#
#   1. the librarian wrapper's boundary check accepts an edit made under either
#      name, in either layout, and still refuses one outside the bundle;
#   2. the librarian workflow's change detection sees a bundle edit in either
#      layout, and its packaging step stages it without failing when the
#      visible name does not exist;
#   3. the registrar workflow triggers on, and diffs, both names;
#   4. `just lokf-link` recreates the tools' link, is a no-op when the folder is
#      present, refuses a dangling link, and follows the `visible` variable when
#      the real folder lives inside a vault subfolder.
#
# Needs bash and git. `just` is optional: without it, test 4 is skipped and says so.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
templates="$repo_root/skills/lokf-sidecar/templates"
wrapper="$templates/scripts/knowledge-librarian.sh"
librarian_yaml="$templates/github/knowledge-librarian.yaml"
registrar_yaml="$templates/github/knowledge-registrar.yaml"
justfile="$templates/justfile"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

fail=0
ok()  { printf 'OK:   %s\n' "$*"; }
err() { printf 'FAIL: %s\n' "$*" >&2; fail=1; }

# Stands in for AGENT_CLI: ignores the prompt it is handed and appends a line to
# the file named in EDIT_PATH (relative to the repo root the wrapper cd's to).
fake_agent="$work/fake-agent.sh"
cat > "$fake_agent" <<'AGENT'
#!/usr/bin/env bash
printf '\nedited by the fake agent\n' >> "$EDIT_PATH"
AGENT
chmod +x "$fake_agent"

# make_host <dir> <hidden|no-doorway|visible|visible-sub>
# A minimal host repository: the wrapper and justfile in place, one concept in
# the bundle, and the two names wired the way the layout says.
make_host() {
  local dir="$1" layout="$2"
  mkdir -p "$dir"
  (
    cd "$dir"
    git init -q -b main .
    git config user.email "layout-test@example.invalid"
    git config user.name "layout test"
    mkdir -p .lokf/scripts skills/lokf-librarian
    cp "$wrapper" .lokf/scripts/knowledge-librarian.sh
    chmod +x .lokf/scripts/knowledge-librarian.sh
    cp "$justfile" .lokf/justfile
    printf '# stub skill\n' > skills/lokf-librarian/SKILL.md
    case "$layout" in
      hidden)      mkdir -p .lokf/knowledge; ln -s .lokf/knowledge knowledge_bundle ;;
      no-doorway)  mkdir -p .lokf/knowledge ;;
      visible)     mkdir -p knowledge_bundle; ln -s ../knowledge_bundle .lokf/knowledge ;;
      visible-sub) mkdir -p vault/knowledge_bundle; ln -s ../vault/knowledge_bundle .lokf/knowledge ;;
      *) echo "unknown layout $layout" >&2; exit 2 ;;
    esac
    printf -- '---\ntype: Service\ntitle: A\n---\n\n# A\n' > .lokf/knowledge/a.md
    printf '# host\n' > README.md
    git add -A .
    git commit -q -m "init ($layout layout)"
  )
}

# run_wrapper <dir> <path the fake agent edits> - prints the wrapper's exit status
# and resets the working tree for the next case.
run_wrapper() {
  local dir="$1" edit="$2" status=0
  ( cd "$dir" && AGENT_CLI="$fake_agent" EDIT_PATH="$edit" bash .lokf/scripts/knowledge-librarian.sh >/dev/null 2>&1 ) || status=$?
  git -C "$dir" checkout -q -- .
  printf '%s' "$status"
}

echo "1. the librarian wrapper's boundary check"
for layout in hidden visible; do
  host="$work/wrapper-$layout"
  make_host "$host" "$layout"
  for edit in .lokf/knowledge/a.md knowledge_bundle/a.md; do
    status="$(run_wrapper "$host" "$edit")"
    if [ "$status" = 0 ]; then ok "$layout layout: an edit via $edit is inside the bundle (exit 0)"
    else err "$layout layout: an edit via $edit was refused (exit $status)"; fi
  done
  status="$(run_wrapper "$host" README.md)"
  if [ "$status" = 3 ]; then ok "$layout layout: an edit to README.md is refused (exit 3)"
  else err "$layout layout: an edit outside the bundle was not refused (exit $status)"; fi
done

echo "2. the librarian workflow's change detection and packaging"
detect='git status --porcelain -- .lokf/knowledge knowledge_bundle'
if grep -qF "$detect" "$librarian_yaml"; then ok "template detects changes with: $detect"
else err "knowledge-librarian.yaml no longer contains: $detect"; fi
stage_visible='[ -e knowledge_bundle ] && git add -A -- knowledge_bundle || true'
if grep -qF 'git add -A -- .lokf/knowledge' "$librarian_yaml" && grep -qF "$stage_visible" "$librarian_yaml"; then
  ok "template stages both names and guards the visible one"
else err "knowledge-librarian.yaml packaging lines changed"; fi
for layout in hidden visible no-doorway; do
  host="$work/workflow-$layout"
  make_host "$host" "$layout"
  printf '\nchanged\n' >> "$host/.lokf/knowledge/a.md"
  printf '\nchanged\n' >> "$host/README.md"
  seen="$(cd "$host" && git status --porcelain -- .lokf/knowledge knowledge_bundle | cut -c4- | tr '\n' ' ')"
  case "$seen" in
    *a.md*README*|*README*a.md*) err "$layout layout: change detection leaked a file outside the bundle ($seen)" ;;
    *a.md*) ok "$layout layout: change detection sees the bundle edit and nothing else ($seen)" ;;
    *) err "$layout layout: change detection saw nothing" ;;
  esac
  staged="$(cd "$host" && set -e && git add -A -- .lokf/knowledge && { [ -e knowledge_bundle ] && git add -A -- knowledge_bundle || true; } && git diff --cached --name-only | tr '\n' ' ')"
  case "$staged" in
    *README*) err "$layout layout: packaging staged a file outside the bundle ($staged)" ;;
    *a.md*)   ok "$layout layout: packaging stages the edited concept ($staged)" ;;
    *)        err "$layout layout: packaging staged nothing" ;;
  esac
done

echo "3. the registrar workflow"
if grep -qE '^\s*-\s*"\.lokf/\*\*"' "$registrar_yaml" && grep -qE '^\s*-\s*"knowledge_bundle/\*\*"' "$registrar_yaml"; then
  ok "registrar triggers on .lokf/** and knowledge_bundle/**"
else err "knowledge-registrar.yaml paths: must list both .lokf/** and knowledge_bundle/**"; fi
pathspecs="$(grep -c -- '-- .lokf/knowledge knowledge_bundle' "$registrar_yaml" || true)"
single="$(grep -cE -- '-- \.lokf/knowledge *$|-- \.lokf/knowledge \|' "$registrar_yaml" || true)"
if [ "$pathspecs" -ge 3 ] && [ "$single" -eq 0 ]; then ok "provenance job names both paths in all $pathspecs of its git pathspecs"
else err "knowledge-registrar.yaml: $pathspecs pathspecs name both paths, $single name only .lokf/knowledge"; fi

echo "4. just lokf-link"
if command -v just >/dev/null 2>&1; then
  host="$work/link-visible"
  make_host "$host" visible
  if ( cd "$host/.lokf" && rm knowledge && just --quiet lokf-link >/dev/null && [ "$(readlink knowledge)" = "../knowledge_bundle" ] ); then
    ok "recreates .lokf/knowledge -> ../knowledge_bundle"
  else err "did not recreate the tools' link"; fi
  if ( cd "$host/.lokf" && just --quiet lokf-link | grep -q "already present" ); then ok "is a no-op when the link is present"
  else err "a second run was not a no-op"; fi
  if ( cd "$host/.lokf" && rm knowledge && ln -s ../nowhere knowledge && ! just --quiet lokf-link >/dev/null 2>&1 ); then ok "refuses a dangling link"
  else err "a dangling link was not refused"; fi
  host="$work/link-sub"
  make_host "$host" visible-sub
  if ( cd "$host/.lokf" && rm knowledge && just --quiet visible=../vault/knowledge_bundle lokf-link >/dev/null && [ "$(readlink knowledge)" = "../vault/knowledge_bundle" ] ); then
    ok "follows visible=<path> when the real folder sits inside a vault subfolder"
  else err "the visible variable was ignored"; fi
  host="$work/link-none"
  make_host "$host" no-doorway
  if ( cd "$host/.lokf" && rm -r knowledge && ! just --quiet lokf-link >/dev/null 2>&1 ); then ok "exits 1 when there is no folder to link to"
  else err "did not fail with no folder to link to"; fi
else
  echo "SKIP: just is not installed - the lokf-link recipe tests need it"
fi

echo ""
if [ "$fail" -eq 0 ]; then echo "Layout tests: PASS"; exit 0; else echo "Layout tests: FAIL"; exit 1; fi
