#!/usr/bin/env bash
# setup-maintenance-shortcut.sh — register a "WoW Maintenance" launcher so you
# can run updates from Game Mode without opening Konsole.
#
# Run this ONCE in Desktop Mode:
#   ./scripts/setup-maintenance-shortcut.sh
#
# It writes a .desktop entry into your applications menu. After that, in
# Desktop Mode: Steam → Games → Add a Non-Steam Game → tick "WoW Maintenance"
# → Add Selected. It then appears in your Game Mode library; launching it runs
# scripts/update.sh in a terminal window and pauses at the end.

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

GUI="$REPO_ROOT/scripts/maintenance-gui.sh"
APPS_DIR="$HOME/.local/share/applications"
DESKTOP="$APPS_DIR/wow-maintenance.desktop"

main() {
  require_not_root
  [[ -f "$GUI" ]] || die "Missing $GUI"
  chmod +x "$GUI"
  mkdir -p "$APPS_DIR"

  cat > "$DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=WoW Maintenance (Steam Deck)
Comment=Update GE-Proton, addons, and the steamdeck-wow repo
Exec=$GUI
Icon=applications-games
Terminal=true
Categories=Game;Utility;
EOF
  chmod +x "$DESKTOP"
  update-desktop-database "$APPS_DIR" >/dev/null 2>&1 || true

  ok "Registered: $DESKTOP"
  cat <<EOF

${BOLD}Next (one time, Desktop Mode):${RST}
  1. Steam → Games → ${BOLD}Add a Non-Steam Game to My Library${RST}.
  2. Tick ${BOLD}"WoW Maintenance (Steam Deck)"${RST} in the list → ${BOLD}Add Selected${RST}.
     (If it's not listed, click Browse → ${BOLD}$GUI${RST}, set filter to All Files.)
  3. (Optional) Rename it / add art like any Steam entry.

After that, from ${BOLD}Game Mode${RST}: just launch "WoW Maintenance" whenever you
want to update — it opens a terminal, runs everything, and pauses so you can
read the result. No Desktop Mode needed.

${DIM}Note: if an update installs a NEW GE-Proton, you still reselect it on the
Battle.net shortcut (Properties → Compatibility) and restart Steam — that one
step can't be automated. See docs/maintenance.md.${RST}
EOF
}

main "$@"
