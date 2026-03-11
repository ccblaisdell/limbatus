# limbatus

Wireless monoblock ergonomic keyboard derived from Dimetrodon.

## Current status
- Ergogen scaffold created.
- `thumb_keys_per_side` parameter exists in `ergogen/config.yaml`.
  - `3` => 36-key target
  - `2` => 34-key target
- Matrix is now organized as a XIAO BLE-compatible logical `6 x 6` scan.
- `NFC1` is reserved for matrix use and must be configured as GPIO in firmware.

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

## Verify Ergogen Changes
Run this whenever you change `ergogen/config.yaml`.

1. Confirm current thumb mode value:
   - `rg -n "thumb_keys_per_side" ergogen/config.yaml`
2. Build with current mode:
   - `make build`
3. Verify generated artifacts exist:
   - `ls outlines`
   - `ls pcbs`
4. Check what changed:
   - `git status --short`
5. Validate both key-count modes before merging layout changes:
   - 34-key mode: set `thumb_keys_per_side: 2` and set both reachy `skip` fields to `true`, then run `make build`
   - 36-key mode: set `thumb_keys_per_side: 3` and set both reachy `skip` fields to `false`, then run `make build`
6. In KiCad, open the generated board and confirm:
   - no missing footprints
   - expected key count (34 or 36)
   - MCU footprint placement still valid
   - no obvious overlap/regression in thumb cluster or center bridge

## Keyboard References
- https://github.com/ceoloide/corney-island for its GitHub Actions and workflows.
- https://github.com/ccblaisdell/dimetrodon for your previous keyboard iteration.

## Notes
- Target MCU is XIAO BLE nRF52840.
- Matrix pin map target: `P0..P5` for columns, `P6..P10` plus `NFC1` for rows.
- Includes the same power switch footprint used in `dimetrodon` (`ceoloide/power_switch_smd_side`).
- No JST footprint; battery is intended for direct-solder pads (not yet added in the scaffold).
- No external reset switch footprint; rely on the onboard XIAO reset button.
- The current code-generated case approach is documented in `case/PLAN.md` and is intended to use Ergogen DXFs plus an OpenSCAD/FreeCAD export flow.

## TODO
- Connect nets and route the keyboard
- Add 3d models for parts where possible
- Implement the code-generated case plan in `case/PLAN.md`
