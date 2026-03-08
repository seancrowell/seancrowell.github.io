#!/usr/bin/env bash
set -euo pipefail

# render on main
git switch main
quarto render
git add -A
git commit -m "Update site source" || true
git push

# publish to gh-pages
git switch gh-pages
git rm -r --ignore-unmatch .
cp -R _site/* .
touch .nojekyll
git add -A
git commit -m "Publish site" || true
git push

git switch main
echo "Done."
