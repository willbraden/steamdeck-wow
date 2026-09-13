# Addons

Two ways to manage addons. Pick one and stick with it (mixing managers causes
duplicate/older copies).

## Option A — instawow (CLI, reproducible) — recommended for a repo

`instawow` is a command-line addon manager. Your addon set lives in
`config/addons.txt`, so it's version-controlled and reproducible across
reinstalls.

```bash
./scripts/addons.sh setup     # install instawow + locate WoW folders
# edit config/addons.txt to taste
./scripts/addons.sh sync      # install everything in the list
./scripts/addons.sh update    # update all addons
./scripts/addons.sh list      # what's installed
```

`config/addons.txt` format — one per line, `source:slug`:

```
curse:weakauras-2
curse:details
github:owner/repo
```

Sources: `curse` (CurseForge), `wowi` (WoWInterface), `github`, `wago`. Find
slugs in the URL on curseforge.com/wow/addons.

> CurseForge sometimes requires an API key for `curse:` sources. If a sync
> fails with an auth error, run `instawow configure` and follow the prompt, or
> switch that addon to another source. See the instawow README.

## Option B — WowUp.CF / CurseForge app (GUI)

If you prefer clicking:

- **WowUp.CF** — community fork of WowUp, ships a Linux AppImage. Point it at
  your `_retail_` folder.
- **CurseForge app** — official; heavier, works under the same folder.

Add either as a Non-Steam game or run from Desktop Mode. Fine, but not
reproducible — you re-click everything after a wipe. That's why this repo
defaults to instawow.

## Where addons live

```
…/World of Warcraft/_retail_/Interface/AddOns/
…/World of Warcraft/_classic_era_/Interface/AddOns/
```

Each WoW flavor (Retail, Classic Era, Cataclysm Classic) has its own AddOns
folder. `scripts/addons.sh` targets `_retail_` by default — edit the script's
`find_wow_dir` calls if you main Classic.

## Starter set

See the annotated list in `config/addons.txt`: DBM, Details, WeakAuras, Bagnon,
Leatrix Plus, and **ConsolePort** (essential for handheld — see
[controls.md](controls.md)).
