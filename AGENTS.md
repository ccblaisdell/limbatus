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
  - No dedicated power switch footprint.
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
- The current case-generation spec lives in `case/PLAN.md`; case work should follow that plan unless it is explicitly superseded.
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
- Key count: undecided between 34 and 36; config should support both.
- Matrix target: logical `6 x 6` matrix on XIAO BLE.
- Matrix pin allocation: `P0..P5` columns, `P6..P10` and `NFC1` rows.
- Firmware implication: disable NFC and use `NFC1` as GPIO for the sixth matrix row.
- Battery connector: direct solder pads (no JST).
- Power switch: omitted.
- Reset switch: omitted; rely on the onboard XIAO reset button.
- MCU target: XIAO BLE nRF52840.

## Agent Expectations
- Call out tradeoffs when changing thumb count, geometry, matrix dimensions, or MCU.
- Validate both 34-key and 36-key config modes when supported.
- Surface firmware and power implications early for BLE nRF52840.
