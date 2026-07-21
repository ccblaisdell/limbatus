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
- Generated outputs are NOT committed. `outlines/`, `pcbs/`, and root `gerbers/`
  are gitignored build products — regenerate them with `make build`, or download
  the `Build` workflow's artifacts. `ergogen/config.yaml` is the single source of
  truth; there is no committed live copy of the board to keep in sync, and no
  reproducibility gate.
- The only committed fabrication artifacts live in `production/<order-id>/`:
  frozen bundles of the exact gerbers you ordered plus the matching
  `limbatus.kicad_pcb` and `outlines/`, with provenance in the bundle's
  `SOURCE.md`. Bundles are created and committed BY HAND when placing an order
  (never by CI) and tagged `fab-<order-id>`. See `production/README.md`. Each
  bundle is immutable and internally consistent; treat it as a release record.
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
- Antenna GND exclusion: REMOVED (2026-07-09). The GND pours now fill SOLID
  under the XIAO's onboard BLE antenna (east end of the module, ~x=-103.8, the
  short end OPPOSITE the USB-C). History: a plane under a chip antenna detunes
  it, so this was first an `xiao_antenna_keepout`, then a NOTCH in the pours
  (KiCad exports every rule-area keepout to the Specctra DSN as a fully
  track-blocking `(keepout)`, which stranded the NFC1/R5 pad at the antenna tip
  and made R5 permanently unroutable; the notch gave the same RF void without
  blocking routing). Both were then dropped by choice: the antenna already sits
  ~21mm inland (a compromised RF spot inherent to the west-USB exit that the
  small void only marginally helped), and a fully-continuous plane is simpler and
  does not fragment into isolated pour islands. Revisit with a XIAO reorientation
  if BLE range disappoints.
- GND fill robustness: both pours use `connect_pads: 'yes'` (SOLID pad
  connection, no thermal relief) and `remove_islands: 'always'`. This keeps the
  autorouted preview at 0 unconnected items regardless of how a given
  (non-deterministic) freerouting run slices the pour -- thermal-relief spokes
  could be fully blocked by tracks and drop a GND pad/via off the plane, and
  isolated pour fragments showed as floating "GND zone unconnected" islands.
  Trade-off: solid GND pads sink heat into the plane, so the XIAO castellations
  and the BAT- pad need a hotter iron / more dwell (see BUILD.md).
- GND plane stitching: front/back GND pours are tied together by tented
  stitching vias (`points.stitch` + `pcbs.limbatus.stitching_vias`), which use a
  solid zone connection (`zone_connect 2`) for a reliable plane tie.
- MCU target: XIAO BLE nRF52840.
- 3D models: footprints carry STEP models for KiCad 3D-view visualization only
  (not fabrication data). Models are committed in `ergogen/3dmodels/` and
  referenced from `config.yaml` via KiCad's built-in `${KIPRJMOD}` path
  (`${KIPRJMOD}/../ergogen/3dmodels/<File>.step`), so they resolve with no
  KiCad "Configure Paths" setup. The ceoloide switch/diode/power-switch
  footprints have native `*_3dmodel_filename` params; `local/xiao_ble.js` was
  extended with an `xiao_3dmodel_filename` param to match. The XIAO model is
  Seeed's official STEP; its offset/rotation are estimates to confirm once in
  KiCad (Seeed authors it in a non-KiCad Y-up frame). See
  `ergogen/3dmodels/README.md` for sources, licenses, and the placement note.
- Firmware: ZMK, in-tree under `config/` (unibody, non-split). Board target
  `xiao_ble//zmk`; two shields share `limbatus.dtsi` — `limbatus` (34-key,
  shipping) and `limbatus_36` (36-key, retained). Both build in CI
  (`.github/workflows/zmk-build.yml`). Matrix is `zmk,kscan-gpio-matrix`
  (`col2row`): columns C0–C5 on `&xiao_d 0..5`, rows R0–R5 on `&xiao_d 6..10` +
  `&gpio0 9` (NFC1). `CONFIG_NFCT_PINS_AS_GPIOS=y` frees NFC1 for R5. Transforms
  and keymaps follow urob zmk-helpers `34.h` / `36.h` labels (ported from
  `ccblaisdell/zmk-config`); the two 36-key reachy thumbs sit at C5,R2 (left) and
  C5,R5 (right). Keymap SVGs are rendered by keymap-drawer
  (`.github/workflows/draw-keymaps.yml`) into `keymap-drawer/`. ZMK +
  zmk-helpers pinned in `config/west.yml`; keep the reusable-workflow ref in
  `.github/workflows/zmk-build.yml` in sync with the ZMK SHA.

## Agent Expectations
- Call out tradeoffs when changing thumb count, geometry, matrix dimensions, or MCU.
- Validate both 34-key and 36-key config modes when supported.
- Surface firmware and power implications early for BLE nRF52840.
