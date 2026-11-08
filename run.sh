#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ ! -x .venv/bin/python ]]; then python3 -m venv .venv; fi
.venv/bin/python -m pip install -r backend/requirements.txt
.venv/bin/python backend/app.py &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true' EXIT INT TERM
for _ in {1..30}; do
  if curl -fsS http://127.0.0.1:5000/ >/dev/null; then break; fi
  sleep 1
done
if command -v chromium >/dev/null 2>&1; then
  chromium --kiosk http://localhost:5000 &
elif command -v google-chrome >/dev/null 2>&1; then
  google-chrome --kiosk http://localhost:5000 &
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open http://localhost:5000
elif command -v open >/dev/null 2>&1; then
  open -a "Google Chrome" --args --kiosk http://localhost:5000 || open http://localhost:5000
fi
wait "$server_pid"
