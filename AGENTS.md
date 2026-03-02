# AGENTS.md

## Project Context
- Project name: `limbatus`
- Goal: wireless ergonomic keyboard derived from Dimetrodon geometry.
- Form factor: monoblock.

## MCU Options
- Primary target: Seeed Studio XIAO BLE nRF52840 (wireless-first).
- Also available: Seeed Studio XIAO RP2040 (fallback/alternate).
- Default assumption for this repo: BLE nRF52840 unless explicitly changed.

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
   - `thumb_keys_per_side: 2` then `make build`
   - `thumb_keys_per_side: 3` then `make build`
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
- Battery connector: direct solder pads (no JST).
- Power switch: omitted.
- Reset switch: include if practical need remains after XIAO placement.
- MCU preference order: XIAO BLE nRF52840, then XIAO RP2040.

## Agent Expectations
- Call out tradeoffs when changing thumb count, geometry, matrix dimensions, or MCU.
- Validate both 34-key and 36-key config modes when supported.
- Surface firmware implications early (BLE nRF52840 vs RP2040 differences).
