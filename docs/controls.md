# Controller & controls — WoW on Steam Deck

WoW has no real native gamepad support. Two layers make it genuinely playable
(and even great) on the Deck:

## 1. ConsolePort (in-game addon) — the big one

**ConsolePort** rebuilds WoW's UI for a controller: radial action wheels,
targeting, an interact-key, and menu navigation designed for a gamepad.

- Installed automatically if you keep `curse:consoleport` in
  `config/addons.txt` and run `scripts/addons.sh sync`.
- On first launch in WoW, its setup wizard walks you through binding. Choose the
  **Xbox / generic gamepad** layout (the Deck reports as one).
- Enable WoW's own **Interact Key** (Options → Gameplay → Controls) — modern WoW
  has soft controller support that ConsolePort builds on.

## 2. Steam Input layout (outside the game)

Even with ConsolePort, use Steam Input for chat, modifiers, and the trackpads.

- In **Game Mode**, open the controller icon on the WoW/Battle.net entry →
  **Browse community layouts** and pick a well-rated **"WoW + ConsolePort"** or
  "World of Warcraft" template as a starting point.
- Essentials to map:
  - **Right trackpad → mouse** (camera + clicking UI/addons).
  - **Left/right trackpad click → left/right mouse button.**
  - A **hold-modifier** (e.g. left grip) to double your action-bar access.
  - **On-screen keyboard** on a grip button (Steam + X by default) for chat.

## Recommended split

- Combat & abilities → **ConsolePort** action wheels.
- Camera & mouse-driven UI (map, bags, addon config) → **right trackpad**.
- Text chat → Steam **on-screen keyboard**.

## Docked / keyboard+mouse

Everything above is for handheld. Docked, just plug in a real keyboard + mouse
and play normally — WoW doesn't care. You can keep ConsolePort installed; it
stays out of the way with kbm.
