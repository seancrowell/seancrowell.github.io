#!/usr/bin/env bash
set -euo pipefail

# Remember repo root
ROOT="$(pwd)"
TMP="$(mktemp -d)"

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Rendering on main..."
git switch main
quarto render

# Stash the rendered site outside the git working tree
echo "Staging rendered site..."
rsync -a --delete "_site/" "$TMP/site/"

echo "Publishing to gh-pages..."
git switch gh-pages

# Remove everything tracked in gh-pages (but keep .git)
git rm -r --ignore-unmatch .

# Copy staged site into repo root
rsync -a --delete "$TMP/site/" "$ROOT/"

# Recommended for GitHub Pages static sites
touch .nojekyll

git add -A
git commit -m "Publish site" || echo "No changes to publish."
git push origin gh-pages

# Go back to main for editing
git switch main
echo "Done."
