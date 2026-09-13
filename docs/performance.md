# Performance tuning — WoW on Steam Deck

WoW is **CPU/single-thread heavy**, especially in cities and raids. The Deck's
GPU is fine; the CPU is the bottleneck. Tune for a stable, cool, long-battery
experience rather than chasing 60 fps.

## The 40 Hz rule (do this first)

In **Game Mode**, open the **Quick Access menu** (⋯ button) → **Performance**:

- **Refresh Rate: 40 Hz**, **Frame Limit: 40 fps.**
  40 fps at 40 Hz feels dramatically smoother than an unlocked, fluctuating
  30–50, and sips far less battery. This is the single biggest win.
- Turn **on** per-game profile so it only applies to WoW.

## In-game graphics settings

Open WoW → **System → Graphics**:

- **Graphics API:** DirectX 12 (falls back to 11 if unstable under Proton).
- **Overall Quality preset:** start at **4**, then adjust below.
- **Render Scale:** ~75–85% (biggest FPS lever; pair with the sharpening below).
- **View Distance:** 5–6 (cheap visual win vs. cost).
- **Shadow Quality:** Low/Fair (very expensive; big savings).
- **Liquid Detail / Particle Density / SSAO:** Low.
- **Anti-Aliasing:** low MSAA or off; rely on FSR/render-scale sharpening.
- **VSync: Off** (let the Deck's frame limiter handle it).

## Upscaling / sharpening

Two independent options — use one:

- **In-game FSR / render scale** (above): set render scale <100% and enable the
  in-game sharpening.
- **Steam Deck FSR:** in Quick Access → Performance, enable **Scaling Filter →
  FSR** *only if* you run WoW below native 1280×800. For a game already at native
  res, in-game render scale is the better lever.

## TDP / battery

Quick Access → Performance:

- **TDP Limit:** WoW rarely needs full wattage. Try **~8–10 W** in the open
  world; raid/city may want 12–15 W. Lower TDP = cooler + longer battery.
- **Manual GPU clock:** usually unnecessary; leave auto unless troubleshooting
  stutter.

## Expectations

- Open world / questing: a locked **40 fps** at 8–12 W is very achievable.
- Dense cities (Valdrakken, Dornogal) and 20-man raids: expect dips into the
  low 30s. This is CPU-bound and normal on the Deck. Lowering graphics helps
  little there — it's the CPU, not the GPU.

## Storage note

WoW on a microSD works fine but zoning/load is slower than internal. If you
raid seriously, put it on internal storage.
