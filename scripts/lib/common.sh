#!/usr/bin/env bash
# Shared helpers for steamdeck-wow scripts. Source this, don't run it.
# Intended to run in Steam Deck *Desktop Mode* (KDE Plasma / bash).

set -euo pipefail

# --- pretty output ---------------------------------------------------------
_c() { printf '\033[%sm' "$1"; }
BOLD="$(_c 1)"; DIM="$(_c 2)"; RED="$(_c 31)"; GRN="$(_c 32)"; YLW="$(_c 33)"; BLU="$(_c 34)"; RST="$(_c 0)"

info()  { printf '%s==>%s %s\n' "$BLU$BOLD" "$RST" "$*"; }
ok()    { printf '%s ok %s %s\n' "$GRN$BOLD" "$RST" "$*"; }
warn()  { printf '%swarn%s %s\n' "$YLW$BOLD" "$RST" "$*" >&2; }
err()   { printf '%serr %s %s\n' "$RED$BOLD" "$RST" "$*" >&2; }
die()   { err "$*"; exit 1; }

step()  { printf '\n%s%s%s\n' "$BOLD" "$*" "$RST"; }

confirm() {
  # confirm "Question?"  -> returns 0 on yes
  local q="${1:-Continue?}" ans
  read -r -p "$(printf '%s%s%s [y/N] ' "$BOLD" "$q" "$RST")" ans || true
  [[ "$ans" =~ ^[Yy]$ ]]
}

# --- environment checks ----------------------------------------------------
need_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }

is_steam_deck() {
  # SteamOS reports this; non-fatal signal only.
  [[ -f /etc/os-release ]] && grep -qi 'steamos' /etc/os-release
}

require_not_root() {
  [[ "${EUID:-$(id -u)}" -ne 0 ]] || die "do not run this as root; run as the 'deck' user"
}

# --- paths -----------------------------------------------------------------
# Repo root (this file lives in scripts/lib/)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export REPO_ROOT

# Where we stash downloaded installers etc.
WOWDECK_CACHE="${WOWDECK_CACHE:-$HOME/.cache/steamdeck-wow}"
export WOWDECK_CACHE
mkdir -p "$WOWDECK_CACHE"

# Flatpak app IDs we rely on
FLATPAK_PROTONUP="net.davidotek.pupgui2"   # ProtonUp-Qt: manage GE-Proton
FLATPAK_LUTRIS="net.lutris.Lutris"          # optional alternate install route
export FLATPAK_PROTONUP FLATPAK_LUTRIS

flatpak_installed() { flatpak info "$1" >/dev/null 2>&1; }

ensure_flathub() {
  need_cmd flatpak
  if ! flatpak remotes --user 2>/dev/null | grep -qi flathub \
     && ! flatpak remotes 2>/dev/null | grep -qi flathub; then
    info "Adding Flathub remote (user scope)…"
    flatpak remote-add --user --if-not-exists flathub \
      https://dl.flathub.org/repo/flathub.flatpakrepo
  fi
}
