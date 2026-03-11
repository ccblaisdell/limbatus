# Parametric Wedge Case Generator

## Summary
Build a code-generated case pipeline that uses Ergogen as the geometry source of truth and OpenSCAD as the solid-modeling layer. The repo will generate:

- board and cavity outlines as DXF from `ergogen/config.yaml`
- a two-part printable case as STL
- STEP exports via a scripted FreeCAD conversion step

The case will be a rectangular top view with a wedge side profile, split into a `top shell` and `bottom tray`. The top shell will act as a switch plate with top openings for switches/keycaps. The interior will include cavities for the XIAO, battery, and power switch, with rear openings for USB and the power switch. The bottom tray will include underside cutouts for the XIAO and hotswap hardware.

## Implementation Changes
### Geometry source
- Extend `ergogen/config.yaml` with named case-driving outlines for:
  - outer board/case perimeter
  - switch opening pattern / plate geometry
  - diode clearance envelope if top-side diode placement requires local extra case depth or relief
  - battery cavity footprint
  - XIAO cavity footprint
  - power-switch cavity footprint
  - rear USB opening footprint
  - rear power-switch opening footprint
  - underside XIAO clearance
  - underside hotswap clearance
  - split reference geometry for top shell vs bottom tray
- Keep Ergogen as the single source of truth for all 2D placement data. No separate hand-authored cavity DXFs.

### Case generator
- Add an OpenSCAD-based case generator under a dedicated case area, with inputs pointing at generated DXFs from `outlines/`.
- Model the case as a rectangular planform extruded into a wedge profile:
  - rear height sized to clear the tallest enclosed components: XIAO and battery
  - front height tapered to near-PCB coverage
  - front overhang extends `10 mm` beyond the PCB after the taper
- Generate two solids:
  - `top_shell`: top plate + wedge exterior + internal cavity ceiling/walls + rear openings
  - `bottom_tray`: mating lower shell with underside cutouts and hardware bosses
- Top shell behavior:
  - switch-plate-style top openings sized for switch retention
  - keycap clearance windows above the switch pattern
  - local clearance or relief for top-side diodes if the final PCB keeps them on the switch side
  - internal cavities for XIAO, battery, and power switch
  - rear openings for USB and power switch actuation/access
- Bottom tray behavior:
  - mating lip or alignment geometry against the top shell
  - underside cutouts for XIAO protrusion and hotswap/socket clearance
  - internal support geometry that does not interfere with switches, battery, or wiring
- Join method:
  - heat-set insert bosses designed into one half
  - matching screw clearance holes in the other half
  - screw positions must avoid switch openings, battery cavity, MCU cavity, and edge openings

### Build/export pipeline
- Add a case build stage that:
  - runs Ergogen to regenerate all DXF inputs
  - runs OpenSCAD to emit STL for both halves
  - runs scripted FreeCAD conversion to emit STEP for both halves
- Default outputs:
  - STL for direct printing
  - STEP for graphical CAD import
- Keep the case artifacts reproducible outputs, not hand-edited sources.

### Interfaces and parameters
- Add a small, explicit set of case parameters for things not already in Ergogen:
  - rear case height
  - front case height / PCB-cover thickness
  - wall thickness
  - floor thickness
  - top shell thickness / plate thickness
  - cavity clearance margins per component class
  - front overhang (`10 mm` default)
  - screw size / insert size / boss diameter
- Do not infer these from KiCad. They should be repo-controlled parameters in code/config so the case stays printable and tunable.

## Test Plan
- Geometry generation:
  - `make build` still succeeds and emits all required DXFs
  - case build emits both STL and STEP files for top shell and bottom tray
- Fit checks:
  - top shell encloses current XIAO, 60 mm battery footprint, and power switch with explicit clearance
  - bottom tray underside cutouts align with XIAO underside features and hotswap interference zones
  - rear openings align with XIAO USB position and power switch location
- Printability checks:
  - both halves are manifold solids
  - no trapped impossible-overhang cavities for normal FDM printing
  - heat-set bosses have sufficient surrounding material and do not break through cavity walls
- Mode compatibility:
  - case generation works for both 34-key and 36-key layouts
  - switch openings and external perimeter remain valid in both modes
- CAD interoperability:
  - STEP files open in graphical CAD software without missing bodies
  - STL and STEP shapes are visually consistent

## Assumptions and defaults
- Modeling stack: OpenSCAD source, FreeCAD used only as a conversion/export stage for STEP.
- Split strategy: top shell + bottom tray.
- Top surface role: switch-plate-style retention, not a cosmetic shell.
- Cavity/opening source: Ergogen-generated DXFs in this repo.
- Export targets: STL and STEP are both required by default.
- Front lip: extends `10 mm` beyond the PCB after taper, as requested.
- “Tall enough to cover the XIAO and battery” means rear wedge height is driven by the current tallest installed component plus configurable clearance, not hardcoded to today’s dimensions.
