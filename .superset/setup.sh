#!/usr/bin/env bash
# Superset workspace setup for the statistics course site.
# Idempotent: safe to re-run.
set -euo pipefail

ROOT="${SUPERSET_ROOT_PATH:-}"
WS="${SUPERSET_WORKSPACE_PATH:-$(pwd)}"
cd "$WS"

# 1. utils/ (quiz2html.py, html_include.awk, ...) is declared in .gitmodules but
#    is NOT a tracked submodule, so new worktrees don't get it. Copy it from the
#    main checkout, or clone it if the main checkout doesn't have it.
if [ ! -d utils ]; then
  if [ -n "$ROOT" ] && [ -d "$ROOT/utils" ] && [ "$ROOT" != "$WS" ]; then
    echo "Copying utils/ from $ROOT"
    cp -R "$ROOT/utils" utils
  else
    echo "Cloning utils/ from GitHub"
    git clone --depth 1 "$(git config -f .gitmodules submodule.utils.url)" utils
  fi
fi

# 2. Copy untracked local files from the main checkout if they exist there
#    (env files, gitignored course materials). Never overwrite existing files.
if [ -n "$ROOT" ] && [ "$ROOT" != "$WS" ]; then
  for f in .env .env.local ScratchPad.xlsx; do
    if [ -e "$ROOT/$f" ] && [ ! -e "$f" ]; then
      echo "Copying $f"
      cp -R "$ROOT/$f" "$f"
    fi
  done
fi

# 3. Build the generated quiz includes (quizzes/*.qhtm, gitignored).
#    Non-fatal so a quiz parse error doesn't block workspace creation.
if command -v python3 >/dev/null 2>&1; then
  make -C quizzes all || echo "warning: quiz build failed (continuing)"
else
  echo "warning: python3 not found; skipping quiz build"
fi

echo "Setup complete. Click Run to start the dev server."
