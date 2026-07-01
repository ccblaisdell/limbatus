# limbatus — Build Guide

Hand-assembly guide for a **34-key** (`thumb_keys_per_side: 2`) monoblock wireless
build. This walks through soldering and assembly in the recommended order. Pair it
with [`BOM.md`](BOM.md) for the parts list.

> **Everything here is hand-soldered.** No reflow/PCBA step is assumed. The board
> mixes a few SMD parts (diodes, hotswap sockets, power switch) with one
> through-hole module (the XIAO) and direct-solder pads (battery). Work from the
> lowest/most-fragile parts to the tallest so nothing blocks your iron.

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
> (front) side of the board. It sits in the **top-left margin, just east of the
> XIAO**, actuator facing the top edge — grouped with the XIAO and battery pads so
> the battery→switch→XIAO power nets stay short and clear of the key matrix. It is
> in series in the battery **positive** line: battery + (`Braw`) → switch → `RAW` →
> XIAO BAT+ (see step 4).

## 4. XIAO BLE MCU (through-hole)

The board uses a **through-hole** XIAO footprint (`local/xiao_ble`): the 14 main
pins are plated through-holes on 2.54 mm / 0.1" pitch, so it's soldered with header
pins — the easier method for hand assembly. We are **direct-soldering** the XIAO
(not socketing it): lower profile and more rugged.

The XIAO ships with two 7-pin header strips in the box — that's all you need.

### Steps

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

### Orientation & fit

- **USB-C** exits the **left board edge** (the XIAO is rotated 90° in the config).
  Confirm against the case USB opening before soldering.
- Soldered direct, the XIAO body rides ~1.5 mm above the PCB on the pin shoulders.
  You _can_ solder the castellations straight into the through-holes (no headers) for
  the lowest possible profile, but headers are easier to get flat and to rework —
  keep the headers.

### BAT+/BAT− carry the battery feed — connect them

The board delivers battery power **through the XIAO's own BAT+/BAT− pads** so the
onboard charger/PMIC manages the LiPo (charging over USB-C, battery run otherwise).
The path is: battery direct-solder pads (step 5) → power switch → **XIAO BAT+**
(`RAW` net), and battery − → **XIAO BAT−** (`GND`). So these two inner pads **must be
connected**, not left open.

On the physical XIAO BLE, BAT+/BAT− are on the **module underside**. Solder a short
jumper from each of the module's BAT pads to the matching board through-hole
(`BAT_POS`/`BAT_NEG`) — easiest to do **before** final seating, while you can still
reach the underside. Observe polarity; a reversed BAT connection can damage the cell
and the XIAO.

### Leave these pads unpopulated

The footprint also exposes through-holes for **SWD, RST, and NFC**. None need to be
populated:

- **SWD / RST** — debug only; reset and reflashing are handled by the onboard button +
  UF2 bootloader.
- **NFC1** — already carried through the main pin array as the 6th matrix row (R5);
  nothing extra to wire.

## 5. Battery (direct-solder pads)

> _TODO: expand._ LiPo cell, **no JST connector**. Leads solder directly to the BAT
> pads: **`Braw` = + , `GND` = −** — observe polarity. The two direct-solder pads sit
> on solid copper **just west of the pocket** (grouped toward the XIAO/switch corner).
> From there, + runs through the power switch to the XIAO BAT+ pad and − ties to the
> ground plane, so the switch cuts power to the MCU. The cell drops into the PCB
> pocket and rests on the bottom-tray floor. Tin the pads, tin the leads, join.
> Consider soldering the battery **last**, and only after the continuity check, so
> you're not working near a live cell.

## 6. Continuity check & first power-on

> _TODO: expand._ Before connecting the battery, use a multimeter in continuity mode
> to spot-check for shorts (especially battery + to −, and adjacent XIAO pins). Then
> power on via USB-C first; confirm the XIAO enumerates before relying on battery.
>
> Note: both copper layers carry a **GND pour**, so every ground pad (battery −, XIAO
> GND, all switch/diode grounds) reads as continuous with each other — that's
> expected, not a short. A short is GND continuity to **`Braw`/`RAW` (battery +)**.

## 7. Firmware

> _TODO: expand._ Flash via the UF2 bootloader (double-tap reset → drag-and-drop).
> **NFC must be disabled** so `NFC1` works as the R5 row GPIO. Matrix pin map:
> `P0..P5` = columns, `P6..P10` + `NFC1` = rows. Firmware target/repo: TBD.

## 8. Case assembly

> _TODO: expand._ Press 6× M3 heat-set inserts into the bottom-tray bosses
> (`MH1`–`MH6`). Join shells with 6× M3 screws through the top shell into the
> inserts (length TBD after a test print). Front shells clip via the snap-fit lip.
> See [`case/README.md`](case/README.md).
