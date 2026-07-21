"""Bake a fixed linear transform into a STEP model's geometry (headless FreeCAD).

Why: KiCad's 3D viewer and its STEP/STL *exporter* compose multi-axis
`(model ... (rotate ...))` transforms in different orders, so a compound rotation
tuned to look right in the viewer comes out flipped in exports. The XIAO is the
only part needing a two-axis rotation (Seeed authors its model in a non-KiCad
frame), so it's the only one affected. Baking the orientation into the model
geometry lets the footprint use an identity transform (rotation [0,0,0], offset
[0,0,0]) -- with nothing to reorder, the viewer and every export agree.

The transform is given as an explicit 3x3 rotation matrix + translation (mm),
which sidesteps every Euler-order/sign convention (KiCad's *and* FreeCAD's). The
rotation used for the XIAO maps Seeed's frame to KiCad's: model length -> board Y,
width -> board X, component side -> +Z, i.e. R = [[0,0,1],[1,0,0],[0,1,0]], with
a centering translation.

The transform is baked into the geometry (Part.Shape.transformGeometry) rather
than set as an assembly placement -- the latter is not honored consistently by
KiCad's importer. Trade-off: this reads geometry only, so the model becomes a
single uniform color. That's invisible in the (monochrome) Onshape mesh and only
lightly affects the KiCad 3D viewer.

Usage (FreeCADCmd):
    FreeCADCmd bake_xiao_rotation.py -- <in.step> <out.step> \\
        r11 r12 r13  r21 r22 r23  r31 r32 r33  tx ty tz
"""
import sys

import Part
from FreeCAD import Matrix


def main():
    a = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else sys.argv[1:]
    inp, outp = a[0], a[1]
    m = [float(x) for x in a[2:14]]  # 9 rotation entries (row-major) + 3 translation
    mat = Matrix(m[0], m[1], m[2], m[9],
                 m[3], m[4], m[5], m[10],
                 m[6], m[7], m[8], m[11],
                 0, 0, 0, 1)
    shape = Part.Shape()
    shape.read(inp)
    shape.transformGeometry(mat).exportStep(outp)
    print(f"[bake] {inp} -> {outp}")


main()
