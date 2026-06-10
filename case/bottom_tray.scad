include <params.scad>
include <lib/utils.scad>

// DXF paths (relative to this file)
DXF_PERIMETER   = "../outlines/case_perimeter.dxf";
DXF_XIAO_CAVITY = "../outlines/case_xiao_cavity.dxf";

module bottom_tray() {
    difference() {
        // Outer flat body
        linear_extrude(height = split_height)
            import(DXF_PERIMETER, convexity = 4);

        // Interior hollow
        translate([0, 0, floor_thickness])
            linear_extrude(height = split_height)
                offset(delta = -wall_thickness)
                    import(DXF_PERIMETER, convexity = 4);

        // XIAO underside protrusion clearance
        translate([0, 0, -EPSILON])
            linear_extrude(height = floor_thickness + EPSILON)
                import(DXF_XIAO_CAVITY, convexity = 4);

        // TODO: hotswap socket underside clearance (needs case_hotswap_clearance.dxf
        //       from ergogen — Choc hotswap sockets protrude ~2mm below PCB)
    }

    // TODO: heat-set insert bosses at validated screw positions
}
