#!/usr/bin/env bash
# install.sh — prepare a Steam Deck to run official Battle.net + World of Warcraft.
#
# What this DOES automate (Desktop Mode):
#   1. Ensure Flathub + ProtonUp-Qt are installed.
#   2. Install the latest GE-Proton via ProtonUp-Qt's CLI.
#   3. Download the official Battle.net installer into the cache.
#
# What it CANNOT automate (Steam has no stable CLI for this — do it in the UI):
#   4. Add Battle.net-Setup.exe to Steam as a Non-Steam Game.
#   5. Force the GE-Proton compatibility tool on that shortcut.
#   6. Run the shortcut once to install Battle.net, then repoint it (see docs).
#
# Steps 4–6 are printed as a checklist at the end and documented fully in
# docs/install-guide.md. Re-running this script is safe (idempotent).

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

# Official Battle.net installer. Verify in docs/install-guide.md if this 404s.
BNET_URL="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
BNET_EXE="$WOWDECK_CACHE/Battle.net-Setup.exe"

main() {
  require_not_root
  need_cmd flatpak
  need_cmd curl

  is_steam_deck || warn "This doesn't look like SteamOS — continuing anyway (works on most Linux)."

  step "1/3  ProtonUp-Qt (GE-Proton manager)"
  ensure_flathub
  if flatpak_installed "$FLATPAK_PROTONUP"; then
    ok "ProtonUp-Qt already installed."
  else
    info "Installing ProtonUp-Qt…"
    flatpak install -y --user flathub "$FLATPAK_PROTONUP"
    ok "ProtonUp-Qt installed."
  fi

  step "2/3  GE-Proton (recommended runtime for Battle.net)"
  # pupgui2 ships a headless installer that grabs the latest GE-Proton for Steam.
  if flatpak run --command=pupgui2-ctl "$FLATPAK_PROTONUP" -h >/dev/null 2>&1; then
    info "Installing latest GE-Proton for Steam…"
    flatpak run --command=pupgui2-ctl "$FLATPAK_PROTONUP" -i "GE-Proton" -y \
      || warn "Headless GE-Proton install failed — open ProtonUp-Qt from the app grid and install GE-Proton manually."
    ok "GE-Proton step done (verify in ProtonUp-Qt)."
  else
    warn "pupgui2-ctl not available in this build."
    warn "Open ProtonUp-Qt from the app grid → Add version → GE-Proton → latest → Install."
  fi

  step "3/3  Download the Battle.net installer"
  if [[ -s "$BNET_EXE" ]]; then
    ok "Already downloaded: $BNET_EXE"
  else
    info "Downloading Battle.net installer…"
    curl -fL --retry 3 -o "$BNET_EXE.part" "$BNET_URL" \
      && mv "$BNET_EXE.part" "$BNET_EXE" \
      || die "Download failed. Check the URL in docs/install-guide.md (Blizzard changes it occasionally)."
    ok "Saved: $BNET_EXE"
  fi

  print_manual_steps
}

print_manual_steps() {
  cat <<EOF

${GRN}${BOLD}Automated setup complete.${RST} Now finish in the Steam UI (Desktop Mode):

${BOLD}A. Add the installer to Steam${RST}
   Steam → Games → Add a Non-Steam Game to My Library → Browse →
   navigate to:  ${BOLD}$BNET_EXE${RST}
   (In the file picker set filter to "All Files" so the .exe shows up.)

${BOLD}B. Force GE-Proton on it${RST}
   Right-click the new "Battle.net-Setup.exe" entry → Properties →
   Compatibility → tick "Force the use of a specific Steam Play tool" →
   choose the ${BOLD}GE-Proton${RST} version you just installed.

${BOLD}C. Install Battle.net, then repoint the shortcut${RST}
   Launch it once → complete the Battle.net install → let it close.
   Then edit the shortcut Target/Start-In to the installed launcher and set
   launch options.  Full copy-paste values are in:
     ${BOLD}docs/install-guide.md${RST}  (section "Repoint the shortcut")

${BOLD}D. Install WoW${RST}
   Open Battle.net → log in → install World of Warcraft (Retail and/or Classic).

Then:
   • Addons:        ${BOLD}scripts/addons.sh${RST}   (and docs/addons.md)
   • Performance:   ${BOLD}docs/performance.md${RST}
   • Controller:    ${BOLD}docs/controls.md${RST}
   • Keep updated:  ${BOLD}scripts/update.sh${RST}   (and docs/maintenance.md)
EOF
}

main "$@"
