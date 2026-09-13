# Troubleshooting

Most WoW-on-Deck breakage is one of: wrong/old Proton, a SteamOS update resetting
things, or Battle.net's launcher quirks. Work top to bottom.

## First move after *anything* breaks

```bash
./scripts/update.sh
```

Updates Flatpaks + GE-Proton + addons. A new GE-Proton fixes most
post-patch breakage. **After it installs a new GE-Proton, re-select that version
on the Battle.net shortcut (Properties → Compatibility) and restart Steam.**

---

## Battle.net won't launch / relaunches the installer

Cause: the shortcut still points at `Battle.net-Setup.exe` instead of the
installed launcher.

- Fix: repoint Target/Start-In to `Battle.net Launcher.exe` — see
  [install-guide.md](install-guide.md) §6 and `config/launch-options.txt`.

## Battle.net opens then immediately closes; Steam shows "Stopped"

- Common with the helper process. Try adding to Launch Options:
  ```
  %command% --exec="launch WoW"
  ```
- Or toggle Battle.net → Settings → **"When I close Battle.net" → Exit
  completely** (not minimize to tray) so Proton sees the process end cleanly.

## Black screen / white window on launch

- Make sure a **GE-Proton** (not stock Proton) is forced on the shortcut.
- Update GE-Proton (`scripts/update.sh`), reselect it, restart Steam.
- As a last resort, delete the prefix and reinstall Battle.net (WoW's game files
  can be kept if installed to a separate folder). See "Nuke the prefix" below.

## Login page is blank / can't type credentials

- Battle.net's embedded browser sometimes needs a click into the field first via
  the **right trackpad as mouse**. Use Steam Input, don't rely on touch.
- Never store your Blizzard password in this repo or any script. Type it in the
  Battle.net window yourself.

## WoW updates but then won't start / "unable to initialize"

- Usually a Proton mismatch after a big WoW patch. Update + reselect GE-Proton.
- Verify game files: Battle.net → WoW → gear icon → **Scan and Repair**.

## Terrible FPS in cities/raids

Expected — it's CPU-bound. See [performance.md](performance.md). Lowering
graphics won't help much there; it helps everywhere else.

## Addon sync fails (CurseForge auth)

- Run `instawow configure` and add a CurseForge API key, or switch that addon to
  a different source in `config/addons.txt`. See [addons.md](addons.md).

## SteamOS update seemingly reset everything

SteamOS updates are immutable-image based; they don't wipe your home dir, but can
reset some system tweaks. Flatpaks, GE-Proton, prefixes, and WoW (all in `$HOME`)
survive. Just run `scripts/update.sh` and reselect GE-Proton if needed.

---

## Nuke the prefix (clean reinstall of Battle.net, keep WoW)

If Battle.net's prefix is corrupt:

1. Note your WoW install folder (Battle.net → WoW → gear → Show in Explorer).
   If it's outside the prefix, it's safe.
2. Delete the compatdata prefix:
   ```bash
   rm -rf ~/.steam/steam/steamapps/compatdata/<APPID>
   ```
3. Re-run `./scripts/install.sh` and redo install-guide.md §2–7.
4. In Battle.net, use **Locate** to point WoW at your existing game folder
   instead of re-downloading 90 GB.

## Getting logs

```bash
# Proton/Wine log for a run (enable, then launch from Steam):
#   add to Launch Options:  PROTON_LOG=1 %command%
# log lands in ~/steam-<APPID>.log
ls -t ~/steam-*.log | head
```
