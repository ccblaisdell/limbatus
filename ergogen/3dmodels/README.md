# 3D models

STEP models used for **design-time visualization** of the PCB in KiCad's 3D
viewer. They are *not* fabrication data — gerbers, drills, and the netlist do
not reference them, so nothing here affects what gets manufactured.

## How they are wired up

`ergogen/config.yaml` sets each footprint's `*_3dmodel_filename` parameter to a
path rooted at KiCad's built-in **`${KIPRJMOD}`** variable — the directory that
holds the open `.kicad_pcb`, i.e. `pcbs/`:

```
${KIPRJMOD}/../ergogen/3dmodels/<File>.step
```

Because `${KIPRJMOD}` is resolved by KiCad automatically, **no Preferences →
Configure Paths setup is required** — open `pcbs/limbatus.kicad_pcb` and the
models load. (The ceoloide switch / diode / power-switch footprints already
support `*_3dmodel_filename`; the `local/xiao_ble` footprint was extended with
an `xiao_3dmodel_filename` parameter to do the same.)

Ergogen passes the `${KIPRJMOD}` string through verbatim into the generated
`.kicad_pcb`; there is no build/post-processing step.

Note: the frozen bundles under `production/<order-id>/` copy the `.kicad_pcb`
into their own directory, so `${KIPRJMOD}/../ergogen/3dmodels` will not resolve
there. That is intentional — those are fab records for gerber review, not 3D
previews.

## Placement note (XIAO — orientation is baked in)

`XIAO-nRF52840.step` is Seeed's official mechanical export, authored in a **Y-up**
frame (length along X, width along Z) offset from the origin — not aligned to
KiCad's footprint origin. It needs a two-axis rotation to sit correctly, and
that's where a KiCad quirk bites: **the 3D viewer and the STEP/mesh exporter
compose multi-axis `(rotate …)` values in different orders**, so a rotation tuned
in the viewer comes out *flipped* in the STEP/STL export (only the XIAO is
affected — every other part uses a single-axis or identity rotation).

Fix: the orientation is **baked into the model geometry**. `make bake-xiao` runs
`scripts/bake_xiao_rotation.py` (headless FreeCAD) to transform the raw
`XIAO-nRF52840.step` into **`XIAO-nRF52840-kicad.step`**, which `config.yaml`
references with an **identity** transform (rotation `[0,0,0]`, offset `[0,0,0]`).
An identity transform has no order to disagree on, so the viewer and every export
match. Regenerate only if the raw Seeed model is replaced. Trade-off: the bake is
geometry-only, so the baked XIAO renders a single flat color (invisible in the
monochrome Onshape mesh; minor in the KiCad viewer).

The switch, hotswap, keycap, and power-switch transforms are the community-tuned
values from the ceoloide/infused-kim footprints and need no baking.

## Exporting the board for case design

Two paths, depending on what you need. Both require `KIPRJMOD` to be defined so
the component models resolve (KiCad sets it automatically in the GUI; the CLI
does not — pass `-D KIPRJMOD="$PWD/pcbs"`).

- **Full-detail STEP** (exact BREP, editable geometry):
  ```
  kicad-cli pcb export step --force -D KIPRJMOD="$PWD/pcbs" \
    -o limbatus-3d.step pcbs/limbatus.kicad_pcb
  ```
  (Don't add `--no-unspecified` — the diodes are "unspecified" type and would be
  dropped.)

- **Light decimated mesh for Onshape** — the full STEP/mesh (~653k triangles)
  lags Onshape's UI, so `make onshape-mesh` exports an STL and uses Blender to
  collapse it to `ONSHAPE_RATIO` (~8% → ~52k triangles), keeping the overall
  shape and exact dimensions. Output: `export3d/limbatus-onshape.stl` (gitignored).
  Import it into Onshape as a mesh reference. Requires Blender
  (`brew install --cask blender`); dev-only, not part of `make build`/CI.
  Tune density with `make onshape-mesh ONSHAPE_RATIO=0.15`.

For **precise** board geometry in Onshape (crisp edges for case fitting), prefer
the exact `outlines/board.dxf` over the mesh; use the mesh only as the component
clearance envelope.

## Model sources & licenses

Each file keeps the license of its upstream source. This directory aggregates
third-party models for convenience; it does not relicense them.

| File | Part | Source |
|------|------|--------|
| `XIAO-nRF52840.step` | Seeed XIAO nRF52840 (incl. BLE antenna + USB-C) — raw source | Seeed Studio official 3D model — <https://wiki.seeedstudio.com/XIAO_BLE/> |
| `XIAO-nRF52840-kicad.step` | Same, re-oriented for KiCad (used by config) | Generated from the row above by `make bake-xiao` |
| `Choc_V1_Switch.step` | Kailh Choc v1 switch | Joe Scotto, ScottoKeebs — <https://github.com/joe-scotto/scottokeebs> |
| `Choc_V1_Hotswap.step` | Choc v1 hotswap socket | Joe Scotto, ScottoKeebs — <https://github.com/joe-scotto/scottokeebs> |
| `Choc_V1_Keycap_MBK_White_1u.step` | MBK 1u keycap | Darryldh (Thingiverse thing:4564253); color variant by @infused-kim |
| `Diode_1N4148W.step` | 1N4148W diode (SOD-123) | SnapEDA — <https://www.snapeda.com/parts/1N4148W-13-F/Diodes%20Inc./view-part/> |
| `Switch_Power.step` | C&K PCM12SMTR slide switch | SnapEDA — <https://www.snapeda.com/parts/PCM12SMTR/C&K/view-part/> |

The choc / diode / power-switch models were vendored from the
`ceoloide/ergogen-footprints` + `infused-kim` model collections (see that
project's `3d_models/README.md` for the same attribution).
