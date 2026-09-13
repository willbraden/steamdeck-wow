# steamdeck-wow

Spin up **World of Warcraft** (official Battle.net — Retail & Classic) on a
**Steam Deck**, and keep it updated and playable. Scripts automate what can be
automated; the docs cover the Steam-UI steps that can't.

> **Scope:** official Blizzard client on official servers. Not a private-server
> setup. WoW is a subscription game — you need an active Blizzard account.

## What you get

| Path | What it does |
|------|--------------|
| `scripts/install.sh` | Installs ProtonUp-Qt + latest **GE-Proton**, downloads the Battle.net installer, prints the exact Steam-UI steps to finish. |
| `scripts/addons.sh`  | Reproducible addon management via **instawow** — your addon list lives in `config/addons.txt`. |
| `scripts/update.sh`  | 2-minute maintenance: updates Flatpaks, GE-Proton, addons, and this repo. |
| `scripts/setup-maintenance-shortcut.sh` | Registers a **"WoW Maintenance"** entry so you can run updates from **Game Mode** — no Desktop Mode needed. |
| `scripts/maintenance-gui.sh` | The wrapper that shortcut launches (opens a terminal, runs `update.sh`, pauses). |
| `config/addons.txt`  | Your version-controlled addon set (DBM, WeakAuras, ConsolePort, …). |
| `config/launch-options.txt` | Copy-paste Steam shortcut targets & launch options. |
| `docs/` | Full walkthroughs — install, performance, controller, troubleshooting, maintenance. |

## Quick start (on the Deck, Desktop Mode)

```bash
git clone <your-repo-url> ~/steamdeck-wow
cd ~/steamdeck-wow
chmod +x scripts/*.sh
./scripts/install.sh          # then follow the printed Steam-UI steps
```

Then, in order:

1. **Install** — [docs/install-guide.md](docs/install-guide.md) (add Battle.net
   to Steam, force GE-Proton, install WoW).
2. **Addons** — `./scripts/addons.sh setup && ./scripts/addons.sh sync`
   ([docs/addons.md](docs/addons.md)).
3. **Tune** — [docs/performance.md](docs/performance.md) (40 Hz, TDP, graphics).
4. **Controller** — [docs/controls.md](docs/controls.md) (ConsolePort + Steam Input).
5. **Maintain** — register a one-tap Game-Mode updater:
   ```bash
   ./scripts/setup-maintenance-shortcut.sh
   ```
   then add "WoW Maintenance" via Add-a-Non-Steam-Game. After that, run updates
   from Game Mode every couple weeks — no Desktop Mode
   ([docs/maintenance.md](docs/maintenance.md)).

## How it works (the honest version)

- **Runtime:** Battle.net runs under **GE-Proton** (Glorious Eggroll's Proton
  fork) — the community build with the fixes Battle.net needs.
- **Two install routes:** this repo defaults to **Battle.net as a Non-Steam
  Game** (best Game Mode integration). A **Lutris** alternative is documented in
  the install guide if the default fights you.
- **The un-automatable bit:** Steam has no stable CLI to add a Non-Steam game,
  force a Proton version, or edit a shortcut. Those ~5 clicks are documented
  step-by-step with exact values instead.
- **Updates:** WoW and Battle.net self-update through the launcher. You keep
  *GE-Proton* and *addons* current — that's what `scripts/update.sh` is for.

## Requirements

- Steam Deck on SteamOS (scripts also work on most Linux distros with Flatpak).
- An active WoW subscription / Blizzard account.
- ~90–100 GB free (internal or microSD) for Retail.
- Patience for the first-run Battle.net shortcut repointing (documented).

## Troubleshooting

Start with `./scripts/update.sh`, then
[docs/troubleshooting.md](docs/troubleshooting.md). The top three fixes cover
almost everything: update GE-Proton, reselect it on the shortcut, repoint the
launcher.

## Security / good hygiene

- **No credentials in this repo.** Ever. Log in through the Battle.net window.
- Scripts run as the `deck` user, never root, and only touch `$HOME`.
- The only network downloads are the official Battle.net installer (Blizzard)
  and Flatpaks (Flathub). URLs are visible in `scripts/install.sh`.
