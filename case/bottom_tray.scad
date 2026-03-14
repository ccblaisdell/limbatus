include <params.scad>
include <lib/wedge.scad>
include <lib/utils.scad>

// DXF paths (relative to this file)
DXF_PERIMETER   = "../outlines/case_perimeter.dxf";
DXF_XIAO_CAVITY = "../outlines/case_xiao_cavity.dxf";

// Y extents of perimeter bounding box derived from ergogen geometry.
// Manual sync point: update if board geometry changes significantly.
PERIMETER_Y_FRONT = -21.89;
PERIMETER_Y_REAR  =  88.36;

module bottom_tray() {
    difference() {
        // Outer wedge body (only up to split_height)
        intersection() {
            linear_extrude(height = split_height)
                import(DXF_PERIMETER);
            wedge_clip(
                PERIMETER_Y_FRONT, PERIMETER_Y_REAR,
                front_height * (split_height / rear_height),
                split_height
            );
        }

        // XIAO underside protrusion clearance
        translate([0, 0, -EPSILON])
            linear_extrude(height = floor_thickness + EPSILON)
                import(DXF_XIAO_CAVITY);

        // TODO: interior hollow
        // TODO: hotswap socket underside clearance (needs case_hotswap_clearance.dxf
        //       from ergogen — Choc hotswap sockets protrude ~2mm below PCB)
    }

    // TODO: heat-set insert bosses at validated screw positions
}
