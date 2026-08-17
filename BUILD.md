# limbatus — Build Guide

Hand-assembly guide for a **34-key** (`thumb_keys_per_side: 2`) monoblock wireless
build. This walks through soldering and assembly in the recommended order. Pair it
with [`BOM.md`](BOM.md) for the parts list.

> **Everything here is hand-soldered.** No reflow/PCBA step is assumed. The board
> mixes a few SMD parts (diodes, hotswap sockets, power switch) with one
> through-hole module (the XIAO) and direct-solder pads (battery). Work from the
> lowest/most-fragile parts to the tallest so nothing blocks your iron.
>
> **Heads-up on GND pads:** the ground pads — the XIAO's GND castellations and the
> battery **−** (`GND`) pad — are tied **solidly** to the board-wide ground plane
> (no thermal-relief spokes), so they sink heat fast. Give them extra dwell, plenty
> of flux, and bump the iron ~20–30 °C hotter than for signal pads; a chisel tip
> helps. (Solid GND connections keep the autorouted plane fill clean; see CLAUDE.md.)

## Tools & supplies

- Temperature-controlled soldering iron, fine conical or chisel tip
- Thin solder (0.5–0.8 mm), leaded is easiest for hand work
- Flux (paste or pen) — makes the SMD work far more forgiving
- Fine tweezers, flush cutters
- Solder wick + iso alcohol for cleanup
- Multimeter (continuity mode) for checking joints before powering on
- Optional: helping hands / PCB holder, breadboard (for the XIAO step)

## Recommended assembly order

1. [Diodes](#1-diodes-smd) — SMD, flattest parts, do them first
2. [Hotswap sockets](#2-hotswap-sockets-smd) — SMD
3. [Power switch](#3-power-switch-smd) — SMD
4. [XIAO BLE MCU](#4-xiao-ble-mcu-through-hole) — through-hole, direct solder
5. [Battery](#5-battery-direct-solder-pads) — direct-solder pads
6. [Continuity check & first power-on](#6-continuity-check--first-power-on)
7. [Firmware](#7-firmware) — flash + disable NFC
8. [Case assembly](#8-case-assembly)

---

## 1. Diodes (SMD)

> _TODO: expand._ 34× 1N4148W (SOD-123) on the **front** side. Cathode (the bar on
> the package and the silkscreen) faces the **row** net — confirm orientation
> before soldering; they're directional. Technique: tin one pad, place the diode
> with tweezers while reheating, then solder the second end.

## 2. Hotswap sockets (SMD)

> _TODO: expand._ 34× Kailh Choc v1 hotswap sockets. Switches are **not** soldered
> — only the sockets are. Tin one pad, seat the socket flat, solder, then do the
> second pad. Make sure each socket sits flush so switches seat fully.

## 3. Power switch (SMD)

> _TODO: expand._ 1× Alps SSSS811101 side-operated slide switch
> (`power_switch_smd_side`), `Braw` → `RAW`. Shorter than the hotswap sockets, same
> (front) side of the board. It sits at the **west (left) board edge, just south
> of the USB port** (immediately below the XIAO), actuator facing **west** so it
> breaches the left case wall right under the USB opening. It is
> in series in the battery **positive** line: battery + (`Braw`) → switch → `RAW` →
> XIAO BAT+ (see step 4).

## 4. XIAO BLE MCU (through-hole)

The board uses a **through-hole** XIAO footprint (`local/xiao_ble`): the 14 main
pins are plated through-holes on 2.54 mm / 0.1" pitch. We are **direct-soldering**
the XIAO (not socketing it): lower profile and more rugged. Two mounting styles
both work with this footprint:

- **Header-mounted** — the XIAO's castellations are soldered to a pair of 7-pin
  header strips first, then the strip's pins drop into the board's through-holes.
  Easier to keep flat and easier to rework, but leaves the module ~1.5 mm proud
  of the PCB on the pin shoulders.
- **Flush-mounted (no headers)** — the XIAO's castellations sit directly against
  the board's plated through-holes with nothing in between; solder is flowed
  straight through each hole to bond module pad to board pad. Lowest possible
  profile, and it turns the BAT+/BAT−/NFC1 connections below into a plain
  flow-solder job instead of a hand-run jumper — but it's less forgiving to
  rework, since there's no gap to fall back into if a joint needs redoing. Get
  the dry-fit orientation right before tacking the first pin.

Pick one approach and use it consistently for the 14 main pins and for the
BAT+/BAT−/NFC1 pads below. The XIAO ships with two 7-pin header strips in the
box, needed only for the header-mounted approach.

### Steps (header-mounted)

1. **Solder the headers to the XIAO first.** Insert the two 7-pin strips up through
   the XIAO's castellated edges from the **bottom**, long pins pointing down, so the
   XIAO rests on the short stubs. Solder the castellations to the pins. (Soldering
   the XIAO first means you never have to reach past the PCB to its pads.)
2. **Seat the assembly into the PCB.** The down-pointing pins drop into the board's
   through-holes. The XIAO is rotated 90° so **USB-C must exit the LEFT board edge**
   (toward the case USB cutout on that side) — this lets the board sit on a laptop
   while plugged in without the cable fouling the screen hinge. It's easy to install
   rotated the wrong way, so dry-fit against the case first. Let it rest flat on the
   bench so it sits square.
3. **Tack one corner, check, then finish.** Solder a single corner pin, confirm the
   XIAO is flat and the USB-C lines up with the opening, then solder the remaining 13
   pins from the **underside** of the PCB.
4. **Trim flush.** Cut the pin stubs flush under the board so they don't foul the
   bottom-tray floor.
5. **BAT+/BAT−/NFC1.** See below — with headers in place there's a ~1.5 mm gap
   under the module, so these three pads need a short hand-run jumper wire rather
   than a direct flow-solder joint. Easiest to do **before** final seating, while
   you can still reach the module's underside directly.

### Steps (flush-mounted, no headers)

1. **Dry-fit first.** Rest the bare XIAO directly on the board pads (no headers),
   same rotation as above — **USB-C exits the LEFT board edge**. Confirm against
   the case USB opening before soldering anything; once a joint is tacked, there's
   no gap left to correct a rotation mistake without desoldering.
2. **Tack one corner, check, then finish.** Solder a single corner pin from the
   **underside** of the PCB, confirm the XIAO is flat and square, then solder the
   remaining 13 main pins the same way — solder flows up through each plated hole
   and bonds directly to the castellation sitting on top of it.
3. **BAT+/BAT−/NFC1.** See below — with the module flush against the board, these
   are just three more plated through-holes to flow solder into, using the same
   underside technique as the 14 main pins. No jumper wire needed.

### Orientation & fit

- **USB-C** exits the **left board edge** (the XIAO is rotated 90° in the config).
  Confirm against the case USB opening before soldering.
- Header-mounted, the XIAO body rides ~1.5 mm above the PCB on the pin shoulders.
  Flush-mounted, it sits directly on the board with no gap — lowest profile, but
  commit to the orientation before the first joint.

### BAT+/BAT−/NFC1 — required connections beyond the 14 main pins

Three of the footprint's extra through-holes carry live nets and **must be
connected** — don't treat them like the SWD/RST/NFC2 pads below.

- **BAT+/BAT−** carry the battery feed. The board delivers battery power
  **through the XIAO's own BAT+/BAT− pads** so the onboard charger/PMIC manages
  the LiPo (charging over USB-C, battery run otherwise). The path is: battery
  direct-solder pads (step 5) → power switch → **XIAO BAT+** (`RAW` net), and
  battery − → **XIAO BAT−** (`GND`). Leaving these open means the board gets no
  battery power at all.
- **NFC1** carries the **6th matrix row (`R5`)** — the entire bottom row of the
  right-hand half, plus a right thumb key. Firmware disables NFC
  (`CONFIG_NFCT_PINS_AS_GPIOS=y`) specifically so this pad can act as a plain
  GPIO row line instead. Leaving it open means that whole row goes dead.
  (`NFC2`, by contrast, is genuinely unused — see below.)

On the physical XIAO BLE, all three pads (`BAT+`, `BAT−`, `NFC1`) are on the
**module underside**, positioned over the board's `BAT_POS`/`BAT_NEG`/`NFC1`
through-holes but not part of the 14-pin header array — they need their own
connection regardless of mounting style:

- **Header-mounted:** solder a short jumper from each of the module's pads to
  the matching board through-hole. Do this **before** final seating, while you
  can still reach the module's underside.
- **Flush-mounted:** flow solder straight into the `BAT_POS`/`BAT_NEG`/`NFC1`
  through-holes from the underside of the main PCB, same technique as the 14
  main pins — the module's pad sits directly above each hole and the solder
  wicks up to bond them.

Two cautions either way:

- **Polarity on BAT+/BAT−** — a reversed connection can damage the cell and the
  XIAO.
- **`BAT_POS` and `BAT_NEG` sit only ~1.9 mm apart** — flux well, use fine
  solder, and do them as two separate deliberate joints, not one sweep. After
  soldering, probe continuity directly between the two holes — it must read
  **open**; continuity there means a solder bridge shorting the battery.
  (`BAT_NEG` *will* show continuity to other GND points — expected, see the
  continuity check below — but `BAT_POS` should not.)

### Leave these pads unpopulated

The footprint also exposes through-holes for **SWD, RST, and NFC2**. None carry
a connected net, so none need to be populated:

- **SWD / RST** — debug only; reset and reflashing are handled by the onboard
  button + UF2 bootloader.
- **NFC2** — not assigned to any net in `ergogen/config.yaml`; no trace expects
  a connection here.

## 5. Battery (direct-solder pads)

> _TODO: expand._ LiPo cell, **no JST connector**. Leads solder directly to the BAT
> pads: **`Braw` = + , `GND` = −** — observe polarity. The two direct-solder pads sit
> on solid copper **just west of the pocket** (grouped toward the XIAO/switch corner).
> From there, + runs through the power switch to the XIAO BAT+ pad and − ties to the
> ground plane, so the switch cuts power to the MCU. The cell drops into the PCB
> pocket and rests on the bottom-tray floor. Tin the pads, tin the leads, join.
> Consider soldering the battery **last**, and only after the continuity check, so
> you're not working near a live cell.
>
> **Keep the protection board — cut at the connector, not the cell.** Most cells
> ship as: pouch → protection board (PCM, under Kapton tape at the wire end) →
> leads → JST plug. Snip the **leads just before the JST plug** to remove only the
> connector; the PCM stays bonded to the cell (this is what you want — it guards
> against over-discharge/over-current/short). Cut **one lead at a time** so the
> snips never bridge + and − (that would short the cell). Peek under the tape first
> to confirm a PCM is actually present; some bare cells have none. Orient the cell
> so its **wire/PCM end faces the pads** (west) for the shortest leads — the pad gap
> is sized to host the PCM there. Red = `Braw` (+), black = `GND` (−).

## 6. Continuity check & first power-on

> _TODO: expand._ Before connecting the battery, use a multimeter in continuity mode
> to spot-check for shorts (especially battery + to −, and adjacent XIAO pins). Then
> power on via USB-C first; confirm the XIAO enumerates before relying on battery.
>
> Note: both copper layers carry a **GND pour**, so every ground pad (battery −, XIAO
> GND, all switch/diode grounds) reads as continuous with each other — that's
> expected, not a short. A short is GND continuity to **`Braw`/`RAW` (battery +)**.

## 7. Firmware

> Firmware is **ZMK**, in-tree under [`config/`](config/) (see
> [`config/README.md`](config/README.md) for the full pin map and build notes).
> It builds a single unibody image — board `xiao_ble//zmk`, shield `limbatus` —
> via GitHub Actions ([`.github/workflows/zmk-build.yml`](.github/workflows/zmk-build.yml)),
> which uploads a `firmware` artifact containing `limbatus.uf2`.
>
> Flash via the UF2 bootloader (double-tap reset → drag-and-drop the `.uf2` onto
> the mass-storage volume). The reset button is reached through the case tab.
>
> **NFC is disabled in firmware** (`CONFIG_NFCT_PINS_AS_GPIOS=y`) so `NFC1`
> (P0.09) works as the R5 row GPIO. Matrix pin map: `P0..P5` = columns C0–C5,
> `P6..P10` + `NFC1` = rows R0–R5, `col2row` diode direction.

## 8. Case assembly

> _TODO: expand._ Press 6× M3 heat-set inserts into the bottom-tray bosses
> (`MH1`–`MH6`). Join shells with 6× M3 screws through the top shell into the
> inserts (length TBD after a test print). Front shells clip via the snap-fit lip.
> See [`case/README.md`](case/README.md).
