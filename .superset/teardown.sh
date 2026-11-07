#!/usr/bin/env bash
# Stop the dev server started by run.sh for this workspace.
WS="${SUPERSET_WORKSPACE_PATH:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$WS" || exit 0
PIDFILE=.superset/.server.pid
if [ -f "$PIDFILE" ]; then
  PID="$(cat "$PIDFILE")"
  if kill -0 "$PID" 2>/dev/null; then
    echo "Stopping dev server (pid $PID)"
    kill "$PID" 2>/dev/null || true
  fi
  rm -f "$PIDFILE"
fi
rm -f .superset/.port
exit 0
