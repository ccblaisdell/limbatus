# Captive Power-Switch Actuator

A printed slider that bridges the tiny, recessed power-switch knob out to a
finger/nail-accessible paddle on the case wall.

## Why this is needed

The power switch is an **Alps SSSS811101** low-profile SMD side slide switch on
the board's **west** edge (see `ergogen/config.yaml` `power_switch`). Its knob:

- protrudes only **~0.5–0.8 mm** past the board's west edge,
- sits **low** against the PCB top face (switch body is 1.4 mm tall), and
- moves with only **1.5 mm** of slide travel.

Through a **2.5 mm** case wall the knob is recessed well inside the opening and
cannot be reached, let alone thrown, by a fingertip. The captive slider solves
this: it lives in the wall, grips the knob on the inside, and presents a larger
grip on the outside.

## Switch facts (single source of truth)

Geometry is derived from `ergogen/config.yaml` and the Alps datasheet. Do not
re-key these; if they change, change them there and re-derive.

| Property | Value | Source |
|---|---|---|
| Part | Alps SSSS811101 (SPDT SMD slide) | `ceoloide/power_switch_smd_side` |
| Body (L × W × H) | 6.7 × 2.6 × 1.4 mm | datasheet |
| Slide travel | **1.5 mm** | datasheet |
| Actuator | horizontal, ~1.1 mm thick | datasheet |
| Knob width (along slide) | ~1.3 mm | footprint F.Fab |
| Knob protrusion past board edge | ~0.5–0.8 mm | footprint + geometry |
| Mount face | **top (F.Cu)** — knob near PCB top plane | `pcbs.power_switch` |
| Body inset from west edge | 1.0 mm (`power_switch_west_clearance`) | config |

### Position on the wall (measured from the board's REAR/back edge)

| Feature | Distance from back edge |
|---|---|
| `case_power_switch_opening` top edge | 25.60 mm |
| **opening center** | **29.85 mm** |
| `case_power_switch_opening` bottom edge | 34.10 mm |
| knob center (≈ 0.75 mm south of opening center) | ~30.6 mm |

- West board edge: `x = -124.76` (board half-width 124.76 mm).
- Solid wall strip between the USB opening and this opening: **~7.85 mm** — keep it.
- The knob slides **N–S** (up/down the wall), so the slider travels N–S too.

## Mechanism

A single printed slider in a shallow channel milled into the **inner** face of
the west wall:

```
  TOP VIEW (looking down; +x = EAST/inward, -x = WEST/outward through wall)

        outside                wall (2.5)              inside / PCB
        (finger)          |################|
                          |###        #####|
      paddle  ===========>|== window ==|   |
      (ridged) proud ~1.5 |            |   |###  <- FLANGE (wider than window;
                          |            |   |###     can't pass out => CAPTIVE)
                          |################|   [slot] )==> switch KNOB sits here
                          |               (inner channel recess)

  The paddle passes through a narrow WINDOW; the wider FLANGE stays trapped in
  the inner CHANNEL. A SLOT in the flange straddles the knob, so pushing the
  paddle N/S drags the knob N/S and throws the switch.
```

```
  SIDE VIEW (looking west along -x; +y = NORTH, +z = UP)

     ^ z
     |   +--------+           channel is TALLER than the flange by the
     |   | flange |  ^        travel (1.5 mm) so the slider can slide;
     |   |        |  | travel channel ends are the ON/OFF hard stops.
     |   +--------+  v
     +---------------------> y (N-S, slide axis)
```

- **Captivity:** the flange (≈5 mm wide) cannot exit the narrower window
  (≈2.4 mm), so the slider is retained against the wall from the inside.
- **Assembly trap:** the top shell is open along the split plane; drop the
  slider into the channel and engage the knob, then the bottom tray closes
  under it and traps it. No snap features required.
- **Hard stops / detents:** the channel is 1.5 mm taller than the flange, so
  the flange bottoms out at each end = ON and OFF. Optional shallow detent bumps
  can be added at the ends once travel is confirmed.

## Nominal dimensions (first pass)

These live as parameters in `case/lib/power_switch_actuator.scad`. Treat them as
a **starting point to tune against a test print** (same disclaimer as the
front-snap lip in `case/params.scad`).

| Feature | Dim | Value |
|---|---|---|
| Paddle | W (y) × H (z) | 2.0 × 3.0 mm |
| Paddle protrusion past outer wall face | x | 1.5 mm |
| Flange | W (y) × H (z) × T (x) | 5.0 × 5.0 × 0.9 mm |
| Knob slot in flange | width (y) | knob 1.3 + 2 × 0.10 grip = 1.5 mm |
| Wall window (cut) | W (y) × H (z) | 2.5 × 5.5 mm |
| Inner channel (cut) | W (y) × H (z) × depth (x) | 5.5 × 7.5 × 1.15 mm |
| General sliding clearance | `psa_fit` | 0.25 mm |
| Knob-slot clearance | `psa_grip_fit` | 0.10 mm |

The flange thickness is capped at `body_inset − 0.1 = 0.9 mm` so it clears the
switch body's west face. That leaves only ~0.9 mm of knob engagement depth — the
one tight spot. If the switch drives unreliably, the cleanest fix is a PCB
change: bump `power_switch_west_clearance` (currently 1.0 mm) to seat the body
~0.5 mm further inland and deepen the flange to match. Flag before doing it —
that moves the switch pads and re-checks edge-copper DRC.

## Print orientation & tolerances (FDM)

- **Orientation:** flange flat on the bed, **knob slot facing up** — no support
  in the slot, paddle prints as an overhang-free horizontal bar.
- **Clearances:** 0.25 mm sliding / 0.10 mm grip suit a well-tuned 0.4 mm nozzle.
  Loosen both ~0.05–0.1 mm for a first print, then tighten.
- **Layer height:** 0.15 mm or finer — the paddle and slot are small.
- The channel + window are the **negatives**; `power_switch_actuator_cavity()`
  in the SCAD is the exact solid to subtract from your wall.

## Build / preview

```sh
make power-switch-actuator      # -> stl/power_switch_actuator.stl (printable part)
openscad case/lib/power_switch_actuator.scad   # slider seated in a demo wall + knob
```

`stl/` is a gitignored build product; regenerate rather than commit it.

## Modeling in Onshape

The switch position is authoritative in Ergogen; import it, don't re-key it.

1. Import `outlines/case_power_switch_opening.dxf` (or the `_aligned` variant for
   self-registration) so the window lands exactly where the switch is.
2. Cut the **window** through the wall (2.5 × 5.5 mm nominal, centered on the
   opening) and the wider **inner channel** recess behind it.
3. Model the **slider** to the table above (or import the STEP/STL of the SCAD
   part once a FreeCAD export is available — no local FreeCAD yet).
4. Verify against your placed switch 3D model: the slot must straddle the knob
   at the knob's Z, and 1.5 mm of travel must fully throw it with margin.

## Tuning checklist (test print)

- [ ] Slider slides freely but without slop in the channel.
- [ ] Flange truly captive — cannot pull out through the window.
- [ ] Knob slot drives the switch through its full 1.5 mm without skipping.
- [ ] Paddle reachable and grippable proud of the wall.
- [ ] Bottom tray traps the slider after assembly (no escape at the split plane).
- [ ] ON/OFF end stops land on the switch detents.

## References / prior art

Switch + datasheet:

- [Alps SSSS811101 product page](https://tech.alpsalpine.com/e/products/detail/SSSS811101/) — 1.5 mm travel, 1.4 mm profile.
- [SSSS811101 datasheet (PDF, ALPS)](https://www.alldatasheet.com/datasheet-pdf/pdf/796638/ALPS/SSSS811101.html)
- [SnapMagic (SnapEDA) footprint/3D model](https://www.snapeda.com/parts/SSSS811101/ALPS/view-part/) — grab the STEP for Onshape.
- [JLCPCB part C109335](https://jlcpcb.com/partdetail/ALPSALPINE-SSSS811101/C109335) / [Digi-Key 19529062](https://www.digikey.com/en/products/detail/alps-alpine/SSSS811101/19529062)

Captive-slider / wireless power-switch design context:

- [ebastler/zmk-designguide](https://github.com/ebastler/zmk-designguide) — hardware design guide for ZMK boards incl. power-switch handling.
- [duckyb/urchin](https://github.com/duckyb/urchin) — 34-key ZMK board with printed case/plate; slide-switch power cutoff.
- [customMK: Engikeeb](https://shop.custommk.com/blogs/news/engikeeb-an-experimental-ultra-low-cost-keyboard) — printed actuator patterns for low-cost wireless builds.
- The `ceoloide/power_switch_smd_side` footprint header (this repo,
  `ergogen/footprints/ceoloide/`) documents the switch and Typeractive/LCSC
  sourcing.
