#!/usr/bin/env bash
# maintenance-gui.sh — run the maintenance routine in a VISIBLE terminal window,
# then pause so you can read the output.
#
# This is the file you add to Steam as a Non-Steam Game. Launched from Game
# Mode, Steam runs it with no terminal attached, so this wrapper opens one
# itself (konsole on SteamOS), runs update.sh, and waits for a keypress before
# closing. Run scripts/setup-maintenance-shortcut.sh once to register it.

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATE="$SELF_DIR/update.sh"

run_update() {
  bash "$UPDATE"
  local status=$?
  echo
  if [[ $status -eq 0 ]]; then
    echo "Maintenance finished OK."
  else
    echo "Maintenance exited with status $status — see docs/troubleshooting.md."
  fi
  echo "Press any key to close…"
  read -r -n1 -s || true
}

# Already have a terminal (ran from Konsole)? Just go.
if [[ -t 1 ]]; then
  run_update
  exit
fi

# Launched from Steam/.desktop with no tty — open a terminal and re-run self.
for term in konsole x-terminal-emulator xterm; do
  if command -v "$term" >/dev/null 2>&1; then
    exec "$term" -e bash -lc "$(printf '%q' "$0")"
  fi
done

# No terminal emulator found — run headless as a last resort.
run_update
