# AGENTS.md

## Project Context
- Project name: `limbatus`
- Goal: wireless ergonomic keyboard derived from Dimetrodon geometry.
- Form factor: monoblock.

## MCU
- Target MCU: Seeed Studio XIAO BLE nRF52840.

## Core Design Constraints
- Keep Dimetrodon-like columnar stagger and splay.
- Thumb cluster must support either:
  - `36-key` mode: 3 thumb keys per side, or
  - `34-key` mode: 2 thumb keys per side.
- Prefer parameterized Ergogen config so 34 vs 36 can be toggled with one variable.

## Power and Battery Requirements
- Wireless-first design assumptions:
  - Include battery support.
  - Include a dedicated power switch footprint.
  - No JST battery connector footprint.
  - Battery connection is direct-solder pads on the PCB.
  - Include reset switch footprint if needed beyond XIAO onboard reset access.

## Electrical Guidance
- Use a diode matrix suitable for single-XIAO IO limits.
- Keep row/column pin mapping explicit and centralized in config.
- Flag pin-budget issues immediately when changing matrix size or features.

## Repo and Workflow Guidance
- Keep Ergogen configuration as source of truth.
- Treat generated outlines/PCB/case artifacts as reproducible outputs.
- Do not manually edit generated files unless explicitly documented.
- `outlines/` and `pcbs/` track current design. When you change
  `ergogen/config.yaml`, run `make build` and commit the regenerated
  `outlines/pcbs` in the same commit. CI's Reproducibility job enforces this by
  failing if committed `outlines/pcbs` don't match a fresh build of the config.
- `gerbers/` are PRODUCTION artifacts, not live outputs. Treat them as a pinned
  release snapshot: only refresh and commit them when you are placing a physical
  fab order, and record provenance in `gerbers/SOURCE.md` (source commit, date,
  fab/order id). Tag each fab run (e.g. `fab-YYYY-MM-DD`). CI never regenerates
  or auto-commits `gerbers/` — the KiBot job's gerbers stay ephemeral build
  artifacts. `gerbers/` will lag `outlines/pcbs` between orders; that is expected.
  The three artifacts are guaranteed to agree only at a fab tag.
- The current case-generation spec lives in `case/README.md`; case work should follow that plan unless it is explicitly superseded.
- Keep `BUILD.md` (hand-assembly guide) and `BOM.md` up to date when making changes that affect them: component choices, footprints, orientation/placement (e.g. MCU rotation), pin mapping, battery/power, or case hardware. Treat them as part of the change, not a follow-up.
- Local reference repo: `~/dev/corney-island` (clone of `ceoloide/corney-island`) is available and useful for GitHub workflows, Ergogen patterns, and case-generation ideas.
- Prefer small, focused commits for:
  1. geometry/layout,
  2. electrical/netlist,
  3. case/mechanical,
  4. firmware/pinmap.

## Ergogen Verification Protocol
Use this protocol after any change to `ergogen/config.yaml`.

1. Run `make build` and ensure generation succeeds.
2. Confirm generated outputs are present in `outlines/` and `pcbs/`.
3. Check `git status --short` to review all changed generated artifacts.
4. For geometry or thumb-cluster changes, validate both modes:
   - 34-key: `thumb_keys_per_side: 2` with both reachy `skip` fields set to `true`, then `make build`
   - 36-key: `thumb_keys_per_side: 3` with both reachy `skip` fields set to `false`, then `make build`
5. Perform a KiCad visual check for each mode:
   - key count and footprint presence
   - no footprint overlaps
   - acceptable MCU/reset placement
   - monoblock bridge outline continuity
6. If either mode fails generation or visual checks, do not merge.

## Decision Log (Current)
- Wireless keyboard: yes.
- Form factor: monoblock.
- Key count: advertised and built as `34-key` (the shipping default). Config retains `36-key` mode as optional infrastructure — keep both build paths working, but document and market the keyboard as 34-key only.
- Matrix target: logical `6 x 6` matrix on XIAO BLE.
- Matrix pin allocation: `P0..P5` columns, `P6..P10` and `NFC1` rows.
- Firmware implication: disable NFC and use `NFC1` as GPIO for the sixth matrix row.
- Battery connector: direct solder pads (no JST).
- Power switch: dedicated footprint included.
- Reset switch: omitted; rely on the onboard XIAO reset button, actuated
  through a Forager-style flexible case tab (no PCB reset switch or test pads).
  The XIAO footprint still breaks out the unused `RST` pad as a free emergency
  fallback. Two constraints this imposes on the PCB, to honor before the case is
  finalized:
  - The tab must reach the XIAO's *component* face (reset button + RGB LED sit
    there, near the USB end). Whichever shell hosts the tab pins the XIAO's
    mounting face; if the tab comes from the bottom tray, the `xiao_ble`
    footprint flips to `side: B` (a real PCB edit that moves its pads/silk).
    Currently the XIAO is on `F.Cu` (component face toward the top shell).
  - After the 90deg rotation the reset button lands at the crowded west/USB
    corner (shared with `case_usb_opening` and the power switch 5mm south). The
    tab's travel path must clear the power-switch actuator and USB cutout. When
    case work begins, parameterize the reset-button XY as a reference point in
    `config.yaml` (like the USB/power-switch openings) so the tab and a keepout
    derive from ergogen as the single source of truth.
- Antenna keepout: the GND copper pours are excluded (copper-only, both layers)
  from the XIAO's onboard-antenna region at the west/USB end, so ground plane
  does not detune the BLE antenna. See `pcbs.limbatus.xiao_antenna_keepout`.
- GND plane stitching: front/back GND pours are tied together by tented
  stitching vias (`points.stitch` + `pcbs.limbatus.stitching_vias`).
- MCU target: XIAO BLE nRF52840.

## Agent Expectations
- Call out tradeoffs when changing thumb count, geometry, matrix dimensions, or MCU.
- Validate both 34-key and 36-key config modes when supported.
- Surface firmware and power implications early for BLE nRF52840.
