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

## Placement note (XIAO)

`XIAO-nRF52840.step` is Seeed's official mechanical export. It is authored in a
**Y-up** frame (length along X, width along Z) and offset from the origin, so it
is not aligned to KiCad's footprint origin. The `xiao_3dmodel_xyz_rotation`
(`[90, 0, 90]`) / `_offset` (`[6.2, -1.6, 0]`) in `config.yaml` map it into
KiCad's Z-up footprint frame and were tuned and verified visually in KiCad's
footprint 3D tab. The switch, hotswap, keycap, and power-switch transforms are
the community-tuned values from the ceoloide/infused-kim footprints.

## Model sources & licenses

Each file keeps the license of its upstream source. This directory aggregates
third-party models for convenience; it does not relicense them.

| File | Part | Source |
|------|------|--------|
| `XIAO-nRF52840.step` | Seeed XIAO nRF52840 (incl. BLE antenna + USB-C) | Seeed Studio official 3D model — <https://wiki.seeedstudio.com/XIAO_BLE/> |
| `Choc_V1_Switch.step` | Kailh Choc v1 switch | Joe Scotto, ScottoKeebs — <https://github.com/joe-scotto/scottokeebs> |
| `Choc_V1_Hotswap.step` | Choc v1 hotswap socket | Joe Scotto, ScottoKeebs — <https://github.com/joe-scotto/scottokeebs> |
| `Choc_V1_Keycap_MBK_White_1u.step` | MBK 1u keycap | Darryldh (Thingiverse thing:4564253); color variant by @infused-kim |
| `Diode_1N4148W.step` | 1N4148W diode (SOD-123) | SnapEDA — <https://www.snapeda.com/parts/1N4148W-13-F/Diodes%20Inc./view-part/> |
| `Switch_Power.step` | C&K PCM12SMTR slide switch | SnapEDA — <https://www.snapeda.com/parts/PCM12SMTR/C&K/view-part/> |

The choc / diode / power-switch models were vendored from the
`ceoloide/ergogen-footprints` + `infused-kim` model collections (see that
project's `3d_models/README.md` for the same attribution).
