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

## Notes
- Target MCU is XIAO BLE nRF52840 (XIAO RP2040 is an alternate option).
- No power switch footprint.
- No JST footprint; battery is intended for direct-solder pads (not yet added in the scaffold).
- Reset switch footprint is included.
