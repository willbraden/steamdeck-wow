#!/usr/bin/env bash
# update.sh — routine maintenance to keep WoW playable after SteamOS/Proton/addon churn.
#
# Run this every couple of weeks, or whenever something breaks after an update:
#   scripts/update.sh
#
# It:
#   1. Updates Flatpaks (ProtonUp-Qt etc.).
#   2. Installs the latest GE-Proton (new versions fix Battle.net breakage).
#   3. Updates all instawow-managed addons (if instawow is set up).
#   4. Pulls the latest version of THIS repo (scripts + docs).
#
# WoW itself and the Battle.net app update themselves through the launcher —
# nothing to do here for game patches.

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

main() {
  require_not_root

  step "1/4  Flatpak apps"
  if have_cmd flatpak; then
    flatpak update -y || warn "flatpak update reported issues."
    ok "Flatpaks updated."
  else
    warn "flatpak not found — skipping."
  fi

  step "2/4  GE-Proton"
  if flatpak_installed "$FLATPAK_PROTONUP" \
     && flatpak run --command=pupgui2-ctl "$FLATPAK_PROTONUP" -h >/dev/null 2>&1; then
    flatpak run --command=pupgui2-ctl "$FLATPAK_PROTONUP" -i "GE-Proton" -y \
      || warn "Could not auto-install GE-Proton; do it in ProtonUp-Qt."
    warn "After a new GE-Proton installs: set it on the Battle.net shortcut (Properties → Compatibility) and restart Steam."
  else
    warn "ProtonUp-Qt CLI unavailable — update GE-Proton from the ProtonUp-Qt app."
  fi

  step "3/4  Addons"
  if have_cmd instawow; then
    instawow update || warn "Addon update reported issues."
    ok "Addons updated."
  else
    info "instawow not set up — skipping (see scripts/addons.sh)."
  fi

  step "4/4  This repo"
  if git -C "$REPO_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
    if [[ -z "$(git -C "$REPO_ROOT" status --porcelain)" ]]; then
      git -C "$REPO_ROOT" pull --ff-only 2>/dev/null && ok "Repo up to date." \
        || warn "Could not fast-forward (no remote, or diverged) — skipping."
    else
      warn "Local changes present in repo — skipping pull. Commit/stash first."
    fi
  fi

  step "Done"
  ok "Maintenance complete. If WoW misbehaves, see docs/troubleshooting.md."
}

main "$@"
