include <params.scad>
include <lib/utils.scad>

// DXF paths (relative to this file)
DXF_PERIMETER   = "../outlines/case_perimeter.dxf";
DXF_XIAO_CAVITY = "../outlines/case_xiao_cavity.dxf";
DXF_MOUNT       = "../outlines/case_mounting_holes.dxf";

// Offsets from the pcb_mounting_hole_diameter circles in the mount DXF.
BOSS_OFFSET   = (boss_diameter   - pcb_mounting_hole_diameter) / 2;  // -> boss OD
INSERT_OFFSET = (insert_diameter - pcb_mounting_hole_diameter) / 2;  // -> insert pocket

module bottom_tray() {
    difference() {
        union() {
            // Tray body: outer flat body with interior hollow and cavities.
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

            // Mounting bosses: solid pillars from the tray floor up through the
            // PCB clearance hole, protruding above the split plane.
            linear_extrude(height = boss_top_z)
                offset(delta = BOSS_OFFSET)
                    import(DXF_MOUNT, convexity = 4);
        }

        // Heat-set insert pockets, opening upward at the boss top.
        translate([0, 0, boss_top_z - insert_depth])
            linear_extrude(height = insert_depth + EPSILON)
                offset(delta = INSERT_OFFSET)
                    import(DXF_MOUNT, convexity = 4);
    }
}
