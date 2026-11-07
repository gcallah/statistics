#!/usr/bin/env bash
# Serve the static site on a free port unique to this workspace.
set -euo pipefail

WS="${SUPERSET_WORKSPACE_PATH:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$WS"
PIDFILE=.superset/.server.pid
PORTFILE=.superset/.port

# Stop a previous server from this workspace, if any.
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  kill "$(cat "$PIDFILE")" 2>/dev/null || true
  sleep 0.5
fi

# Pick a port: an explicit $PORT wins; otherwise start from a stable
# per-workspace offset in 8000-8999 and walk up to the first free one,
# so parallel workspaces don't collide.
PORT="$(python3 - "${PORT:-}" "${SUPERSET_WORKSPACE_NAME:-$WS}" <<'PY'
import socket, sys, zlib
explicit, name = sys.argv[1], sys.argv[2]
def free(p):
    s = socket.socket()
    try:
        s.bind(("127.0.0.1", p)); return True
    except OSError:
        return False
    finally:
        s.close()
if explicit:
    print(explicit); sys.exit()
start = 8000 + zlib.crc32(name.encode()) % 1000
for i in range(1000):
    p = 8000 + (start - 8000 + i) % 1000
    if free(p):
        print(p); break
else:
    sys.exit("no free port in 8000-8999")
PY
)"
echo "$PORT" > "$PORTFILE"

echo "Serving $WS at http://127.0.0.1:$PORT/"
python3 -m http.server "$PORT" --bind 127.0.0.1 &
echo $! > "$PIDFILE"
trap 'kill "$(cat "$PIDFILE")" 2>/dev/null; rm -f "$PIDFILE"' EXIT INT TERM
wait
