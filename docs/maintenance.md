# Maintenance — keeping it playable

WoW + Deck is a moving target: SteamOS updates, monthly WoW patches, Proton
releases, and addon churn. The goal is a **2-minute routine** that keeps it
healthy, plus knowing what breaks when.

## Routine (every ~2 weeks, or after a big patch)

Two ways to run the exact same thing:

**From Game Mode (no Desktop Mode needed) — recommended.** Launch the **"WoW
Maintenance"** entry in your library. It opens a terminal, runs everything, and
pauses so you can read the result. Set this up once with
`scripts/setup-maintenance-shortcut.sh` (see below).

**From Desktop Mode / Konsole:**

```bash
cd ~/steamdeck-wow
./scripts/update.sh
```

Either way it updates Flatpaks, GE-Proton, addons, and this repo. If it installs
a new GE-Proton, **reselect it** on the Battle.net shortcut and restart Steam.

### One-time: add the Game-Mode maintenance button

In Desktop Mode:

```bash
./scripts/setup-maintenance-shortcut.sh
```

Then Steam → Games → **Add a Non-Steam Game** → tick **"WoW Maintenance (Steam
Deck)"** → Add Selected. It now lives in your Game Mode library next to WoW, and
you never have to open Konsole for routine updates again.

## What updates itself (no action needed)

- **WoW game patches** — via the Battle.net launcher.
- **Battle.net app** — self-updates on launch.

## What YOU keep updated

| Thing        | How                                   | When                          |
|--------------|---------------------------------------|-------------------------------|
| GE-Proton    | `scripts/update.sh` / ProtonUp-Qt     | Every couple weeks; if broken |
| Addons       | `scripts/addons.sh update`            | After each WoW content patch  |
| SteamOS      | Settings → System → Updates           | When prompted                 |
| This repo    | `git pull` (or `scripts/update.sh`)   | Whenever you tweak it         |

## The golden rules

1. **Big WoW patch → update addons.** Addons break on `.x` patches. Run
   `scripts/addons.sh update`; disable any that still error until they update.
2. **Something won't launch → update + reselect GE-Proton.** 90% of launch
   breakage is a stale Proton after a patch.
3. **Keep your addon list in git.** `config/addons.txt` is your source of truth;
   a wipe/reinstall is then `addons.sh sync`, not an afternoon of clicking.
4. **Don't store credentials anywhere in this repo.** Log in through the
   Battle.net window each time (or use its own remembered-login).

## Backing up your setup

Worth committing to the repo / copying off-device:

- `config/addons.txt` — your addon set.
- Your WoW settings live in-prefix and per-account; the important ones
  (`WTF/` folder — keybinds, addon settings, WeakAuras) can be backed up:
  ```bash
  # find your WoW dir, then:
  cp -r "…/World of Warcraft/_retail_/WTF" ~/wow-wtf-backup-$(date +%Y%m%d)
  ```
  Restore by copying it back after a reinstall.

## Reinstalling from scratch (new Deck / wiped Deck)

1. `git clone <repo>` → `./scripts/install.sh`
2. Follow [install-guide.md](install-guide.md) §2–7.
3. In Battle.net, **Locate** existing WoW files if kept, else install.
4. `./scripts/addons.sh setup && ./scripts/addons.sh sync`
5. Restore `WTF/` backup if you have one.

Total hands-on time: ~15 min + download.
