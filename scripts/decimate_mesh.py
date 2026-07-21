"""Headless Blender: import an STL, decimate (collapse), export STL.

Used by `make onshape-mesh` to shrink KiCad's ~3.3M-triangle board export into a
light mesh that Onshape's UI can handle, while keeping the overall shape and
exact dimensions (quadric collapse preserves the silhouette and never scales).

Usage:
    blender -b -P scripts/decimate_mesh.py -- <in.stl> <out.stl> [ratio]

`ratio` is the fraction of triangles to KEEP (Blender Decimate/Collapse), default
0.08 (~8%). Deterministic for a fixed ratio + input.
"""
import sys
import bpy


def main():
    argv = sys.argv
    argv = argv[argv.index("--") + 1:] if "--" in argv else []
    if len(argv) < 2:
        raise SystemExit("usage: blender -b -P decimate_mesh.py -- <in.stl> <out.stl> [ratio]")
    in_path, out_path = argv[0], argv[1]
    ratio = float(argv[2]) if len(argv) > 2 else 0.08

    # Start from a clean, empty scene.
    bpy.ops.wm.read_factory_settings(use_empty=True)

    # Import (Blender 4.0+/5.x native STL importer, with legacy fallback).
    try:
        bpy.ops.wm.stl_import(filepath=in_path)
    except AttributeError:
        bpy.ops.import_mesh.stl(filepath=in_path)

    meshes = [o for o in bpy.context.scene.objects if o.type == "MESH"]
    if not meshes:
        raise SystemExit("no mesh imported from " + in_path)
    faces_before = sum(len(o.data.polygons) for o in meshes)

    for o in meshes:
        bpy.ops.object.select_all(action="DESELECT")
        o.select_set(True)
        bpy.context.view_layer.objects.active = o
        mod = o.modifiers.new(name="decimate", type="DECIMATE")
        mod.decimate_type = "COLLAPSE"
        mod.ratio = ratio
        bpy.ops.object.modifier_apply(modifier=mod.name)

    faces_after = sum(len(o.data.polygons) for o in bpy.context.scene.objects if o.type == "MESH")

    # Export all objects (native exporter, with legacy fallback).
    try:
        bpy.ops.wm.stl_export(filepath=out_path, export_selected_objects=False)
    except AttributeError:
        bpy.ops.object.select_all(action="SELECT")
        bpy.ops.export_mesh.stl(filepath=out_path)

    print(f"[decimate] ratio={ratio}  faces {faces_before:,} -> {faces_after:,}")
    print(f"[decimate] wrote {out_path}")


if __name__ == "__main__":
    main()
