# limbatus

Wireless monoblock ergonomic keyboard derived from Dimetrodon.

## Current status
- Ergogen scaffold created.
- `thumb_keys_per_side` parameter exists in `ergogen/config.yaml`.
  - `3` => 36-key target
  - `2` => 34-key target
- Matrix + diode wiring is scaffolded and needs final pin-budget review for XIAO BLE nRF52840.

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
   - set `thumb_keys_per_side: 2`, run `make build`
   - set `thumb_keys_per_side: 3`, run `make build`
6. In KiCad, open the generated board and confirm:
   - no missing footprints
   - expected key count (34 or 36)
   - MCU/reset footprint placement still valid
   - no obvious overlap/regression in thumb cluster or center bridge

## Notes
- Target MCU is XIAO BLE nRF52840 (XIAO RP2040 is an alternate option).
- No power switch footprint.
- No JST footprint; battery is intended for direct-solder pads (not yet added in the scaffold).
- Reset switch footprint is included.
