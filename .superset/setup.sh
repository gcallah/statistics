#!/usr/bin/env bash
# Superset workspace setup for the statistics course site.
# Idempotent: safe to re-run.
set -euo pipefail

ROOT="${SUPERSET_ROOT_PATH:-}"
WS="${SUPERSET_WORKSPACE_PATH:-$(pwd)}"
cd "$WS"

# 1. utils/ (html_include.awk, quiz2html.py, ...) is declared in .gitmodules
#    but is NOT a tracked submodule, so new worktrees don't get it. Clone a
#    fresh copy (the main checkout's copy may be stale); if offline, fall
#    back to copying the main checkout's.
if [ ! -d utils ]; then
  if git clone --quiet --depth 1 "$(git config -f .gitmodules submodule.utils.url)" utils; then
    echo "Cloned utils/"
  elif [ -n "$ROOT" ] && [ -d "$ROOT/utils" ] && [ "$ROOT" != "$WS" ]; then
    echo "Clone failed; copying utils/ from $ROOT (may be out of date)"
    cp -R "$ROOT/utils" utils
  else
    echo "error: could not get utils/" >&2
    exit 1
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
  make -C quizzes all test || echo "warning: quiz build failed (continuing)"
else
  echo "warning: python3 not found; skipping quiz build"
fi

echo "Setup complete. Click Run to start the dev server."
