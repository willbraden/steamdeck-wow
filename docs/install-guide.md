# Install guide — WoW on Steam Deck (official Battle.net)

This is the full walkthrough. `scripts/install.sh` automates the parts that can
be automated; the rest is Steam UI clicking that has no stable CLI. Do all of
this in **Desktop Mode** (hold Power → Switch to Desktop).

> Time: ~30 min of clicking + however long WoW takes to download (it's ~90 GB
> for Retail, so use good Wi-Fi or a dock + Ethernet).

---

## 0. Prep

- Switch to Desktop Mode.
- Open **Konsole** (terminal). Clone this repo somewhere in your home dir:
  ```bash
  git clone <your-repo-url> ~/steamdeck-wow
  cd ~/steamdeck-wow
  chmod +x scripts/*.sh
  ```
- (Optional but recommended) A microSD card or plenty of internal space for the
  ~90–100 GB install.

## 1. Run the installer script

```bash
./scripts/install.sh
```

This installs ProtonUp-Qt, pulls the latest **GE-Proton**, and downloads the
official Battle.net installer to `~/.cache/steamdeck-wow/Battle.net-Setup.exe`.
It finishes by printing the manual steps below.

> **If GE-Proton didn't auto-install:** open **ProtonUp-Qt** from the app grid →
> *Add version* → choose **GE-Proton** (latest) → *Install* → *Apply*. Then
> restart Steam.

## 2. Add Battle.net to Steam as a Non-Steam Game

1. Steam → **Games** menu → **Add a Non-Steam Game to My Library**.
2. Click **Browse** → navigate to
   `~/.cache/steamdeck-wow/Battle.net-Setup.exe`.
   - In the file dialog, change the filter to **All Files** if the `.exe`
     doesn't appear.
3. Tick it → **Add Selected Programs**.

## 3. Force GE-Proton on it

Right-click the new **Battle.net-Setup.exe** entry → **Properties** →
**Compatibility** → tick **Force the use of a specific Steam Play compatibility
tool** → select the **GE-Proton** version you installed.

## 4. First launch — install Battle.net

Press **Play**. The Battle.net installer runs inside a fresh Proton prefix.

- Complete the install normally.
- **Do not tick "auto-login"** on this first pass if it gives you trouble;
  just get it installed.
- When it finishes, Battle.net may open and then the Steam entry may "stop".
  That's expected — the installer and the installed app are different `.exe`s.

## 5. Find your prefix

The first launch created a Proton prefix. Find its APPID:

```bash
ls -dt ~/.steam/steam/steamapps/compatdata/*/ | head
```

The most recently modified numeric folder is almost certainly Battle.net.
Confirm the launcher exists:

```bash
APPID=<that-number>
ls "$HOME/.steam/steam/steamapps/compatdata/$APPID/pfx/drive_c/Program Files (x86)/Battle.net/"
```

You should see **Battle.net Launcher.exe**.

## 6. Repoint the shortcut

Right-click the Steam entry → **Properties** → **Shortcut**:

- **Target:**
  ```
  "Battle.net Launcher.exe"
  ```
- **Start In:**
  ```
  <prefix>/drive_c/Program Files (x86)/Battle.net/
  ```
  (Full path from step 5, e.g.
  `/home/deck/.steam/steam/steamapps/compatdata/<APPID>/pfx/drive_c/Program Files (x86)/Battle.net/`)
- Rename the entry from `Battle.net-Setup.exe` → **Battle.net**.

See `config/launch-options.txt` for optional launch-option tweaks.

## 7. Install World of Warcraft

Launch **Battle.net** from Steam → log in → select **World of Warcraft** →
choose Retail and/or a Classic flavor → **Install**. Let it download.

> Tip: install to internal storage or a formatted microSD. Battle.net lets you
> pick the install location in the game's install dialog.

## 8. Set up the rest

- **Addons:** `./scripts/addons.sh setup && ./scripts/addons.sh sync`
  (details in [addons.md](addons.md))
- **Performance:** [performance.md](performance.md) — 40 Hz cap, TDP, graphics.
- **Controller:** [controls.md](controls.md) — ConsolePort + Steam Input.
- **Game Mode:** switch back, and Battle.net/WoW is in your library. Add a nice
  banner via the community artwork picker.

---

## The Battle.net installer URL

`scripts/install.sh` uses:

```
https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe
```

Blizzard occasionally changes their download endpoints. If that 404s, get a
fresh link from <https://www.blizzard.com/download> (Battle.net App) on any
machine, copy the direct `.exe` link, and either drop the file into
`~/.cache/steamdeck-wow/Battle.net-Setup.exe` manually or update `BNET_URL` in
`scripts/install.sh`.

## Alternate route: Lutris

If the Non-Steam method fights you, Lutris has a maintained Battle.net install
script:

```bash
flatpak install -y --user flathub net.lutris.Lutris
# In Lutris: search "Battle.net" → Install → follow prompts.
```

Lutris manages its own prefix and is more self-contained, but has slightly worse
Game Mode integration than the Non-Steam method above. Pick one; don't run both
for the same install.
