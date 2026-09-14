# limbatus

A 36-key wireless monoblock ergonomic keyboard derived from Dimetrodon.

## Current status
- Ships as a **36-key** layout (3 thumb keys per side).
- Matrix is organized as a XIAO BLE-compatible logical `6 x 6` scan.
- `NFC1` is reserved for matrix use and must be configured as GPIO in firmware.
- The thumb cluster's anchor/shift/splay values match Dimetrodon's thumb
  cluster exactly (same fan shape, ported into limbatus's mirrored monoblock
  frame).

## Latest PCB Images
- Top view: https://ccblaisdell.github.io/limbatus/limbatus-top.png
- Bottom view: https://ccblaisdell.github.io/limbatus/limbatus-bottom.png

[![Limbatus top view](https://ccblaisdell.github.io/limbatus/limbatus-top.png)](https://ccblaisdell.github.io/limbatus/limbatus-top.png)
[![Limbatus bottom view](https://ccblaisdell.github.io/limbatus/limbatus-bottom.png)](https://ccblaisdell.github.io/limbatus/limbatus-bottom.png)

## Build
1. Install dependencies:
   - `npm install`
2. Generate artifacts:
   - `make build`

For hand-assembly (soldering and case), see [`BUILD.md`](BUILD.md). Parts list is in [`BOM.md`](BOM.md).

## Firmware
Runs [ZMK](https://zmk.dev) as a single (non-split) XIAO BLE image. The config,
keymaps, pin map, and build/flash notes live in [`config/`](config/README.md);
CI builds the `limbatus` shield and uploads a `.uf2` artifact.

Default keymap (rendered by [keymap-drawer](https://github.com/caksoylar/keymap-drawer)):

![limbatus keymap](keymap-drawer/limbatus.svg)

## Verify Ergogen Changes
Run this whenever you change `ergogen/config.yaml`.

1. Build:
   - `make build`
2. Verify generated artifacts exist:
   - `ls outlines`
   - `ls pcbs`
3. Check what changed:
   - `git status --short`
4. In KiCad, open the generated board and confirm:
   - no missing footprints
   - 36 keys present
   - MCU footprint placement still valid
   - no obvious overlap/regression in thumb cluster or center bridge

## Keyboard References
- https://github.com/ceoloide/corney-island for its GitHub Actions and workflows.
- https://github.com/ccblaisdell/dimetrodon for your previous keyboard iteration.

## Notes
- Target MCU is XIAO BLE nRF52840.
- Matrix pin map target: `P0..P5` for columns, `P6..P10` plus `NFC1` for rows.
- Includes a dedicated power switch footprint.
- No JST footprint; battery uses two direct-solder SMD pads (`local/battery_pads_solder`).
- No external reset switch footprint; rely on the onboard XIAO reset button.
- The current code-generated case approach is documented in `case/README.md` and is intended to use Ergogen DXFs plus an OpenSCAD/FreeCAD export flow.

## TODO
- Add 3d models for parts where possible
- Implement the code-generated case plan in `case/README.md`
- Design a second case with embedded apple magic trackpad
