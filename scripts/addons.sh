#!/usr/bin/env bash
# addons.sh — scriptable WoW addon management on the Deck via `instawow`.
#
# Why instawow: it's a CLI addon manager (CurseForge/WoWInterface/GitHub/Wago),
# so your addon set lives in this repo as a plain list and is reproducible —
# no clicking through a GUI on a 7" screen. GUI alternatives (WowUp.CF,
# CurseForge app) are noted in docs/addons.md.
#
# Usage:
#   scripts/addons.sh setup      # install instawow + point it at your WoW dirs
#   scripts/addons.sh sync       # install/refresh everything in config/addons.txt
#   scripts/addons.sh update     # update all installed addons
#   scripts/addons.sh list       # show what's installed

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

ADDON_LIST="$REPO_ROOT/config/addons.txt"

# Common WoW install paths under a Steam+Proton Battle.net prefix. The prefix
# id varies, so we search for it. Retail = _retail_, Classic = _classic_era_
# / _classic_ (Cataclysm-era). Adjust if yours differs.
find_wow_dir() {
  local flavor="$1"  # _retail_ | _classic_ | _classic_era_
  find "$HOME/.steam" "$HOME/.local/share/Steam" -maxdepth 12 \
       -type d -path "*/World of Warcraft/$flavor" 2>/dev/null | head -n1
}

ensure_instawow() {
  if have_cmd instawow; then ok "instawow present."; return; fi
  info "Installing instawow…"
  if have_cmd pipx; then
    pipx install instawow
  elif have_cmd flatpak; then
    warn "pipx not found. Install it first:  (Discover → 'pipx') or:"
    warn "  python3 -m pip install --user pipx && python3 -m pipx ensurepath"
    die  "Re-run after pipx is on PATH."
  else
    die "Need pipx (recommended) to install instawow. See docs/addons.md."
  fi
  ok "instawow installed."
}

cmd_setup() {
  ensure_instawow
  local retail classic
  retail="$(find_wow_dir _retail_ || true)"
  classic="$(find_wow_dir _classic_ || find_wow_dir _classic_era_ || true)"

  [[ -n "$retail" ]]  && { info "Retail:  $retail";  instawow -p "$retail"  config 2>/dev/null || true; }
  [[ -n "$classic" ]] && { info "Classic: $classic"; }
  [[ -z "$retail$classic" ]] && warn "No WoW install found yet. Install WoW via Battle.net first, then re-run."
  ok "Addon setup done. Edit config/addons.txt, then: scripts/addons.sh sync"
}

cmd_sync() {
  have_cmd instawow || die "Run 'scripts/addons.sh setup' first."
  [[ -f "$ADDON_LIST" ]] || die "Missing $ADDON_LIST"
  local dir; dir="$(find_wow_dir _retail_ || true)"
  [[ -n "$dir" ]] || die "No _retail_ WoW dir found. Install WoW first."
  info "Installing addons from $ADDON_LIST into $dir"
  # Lines: "source:slug" e.g. curse:deadly-boss-mods ; '#' comments ignored.
  grep -vE '^\s*(#|$)' "$ADDON_LIST" | while read -r pkg _; do
    info "  + $pkg"
    instawow -p "$dir" install "$pkg" 2>&1 | sed 's/^/      /' || warn "    failed: $pkg"
  done
  ok "Sync complete."
}

cmd_update() { have_cmd instawow || die "instawow not installed."; instawow update; }
cmd_list()   { have_cmd instawow || die "instawow not installed."; instawow list; }

case "${1:-}" in
  setup)  cmd_setup ;;
  sync)   cmd_sync ;;
  update) cmd_update ;;
  list)   cmd_list ;;
  *) cat <<EOF
Usage: scripts/addons.sh {setup|sync|update|list}
  setup   install instawow and locate your WoW folders
  sync    install/refresh every addon in config/addons.txt
  update  update all installed addons
  list    list installed addons
EOF
  ;;
esac
