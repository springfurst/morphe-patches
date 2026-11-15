#!/usr/bin/env bash
# Publish one app directory as its own standalone repo (Morphe's add-source needs one repo
# per bundle). Usage:
#   ./scripts/publish-app.sh nova-launcher git@github.com:OWNER/nova-launcher-patches.git
set -euo pipefail

app="${1:?usage: publish-app.sh <app-dir> <git-remote-url>}"
remote="${2:?usage: publish-app.sh <app-dir> <git-remote-url>}"

[[ -d "apps/$app" ]] || { echo "no such app directory: apps/$app" >&2; exit 1; }

branch="standalone-$app"

echo "==> splitting apps/$app into branch $branch"
git subtree split --prefix="apps/$app" -b "$branch" >/dev/null

echo "==> pushing $branch -> $remote (main)"
git push "$remote" "$branch:main"

cat <<EOF

Done. Add it to Morphe:

  https://morphe.software/add-source?github=OWNER/REPO

Then in Morphe: patch a stock APK of the supported version with the patches enabled.
(Release the .mpp first: tag a commit in that repo, or upload a release with the
patches-*.mpp and patches-bundle.json that :patches:buildAndroid produces.)
EOF
