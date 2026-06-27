// Front snap-fit lip — shared geometry for the top shell (skirt + bead) and the
// bottom tray (groove). The thin wedge front can't take screws, so the shells
// clip together: a continuous skirt on the top shell drops into the tray, and a
// bead on the skirt's outer face snaps into a groove in the tray inner wall.
//
// Pass the 2D case perimeter as the child, e.g.:
//     front_snap_skirt() import(DXF_PERIMETER, convexity = 4);
//
// Uses globals from params.scad (wall_thickness, split_height, snap_*).
// Radial offsets are measured inward from the perimeter:
//     tray inner wall face : -wall_thickness
//     skirt outer face     : -(wall_thickness + snap_gap)
//     skirt inner face     : skirt_outer - snap_skirt_thickness
//     bead reaches outward to skirt_outer + snap_bead_size (into the groove)

SNAP_EPS = 0.01;

// 2D mask selecting the front band (DXF +y <= snap_front_y). Generously sized.
module _snap_front_mask() {
    translate([-300, -300]) square([600, 300 + snap_front_y]);
}

// Top-shell skirt + bead, in top-shell-LOCAL z (the split plane is z = 0, so the
// skirt occupies negative z and plugs down into the tray once assembled).
module front_snap_skirt() {
    skirt_outer = -(wall_thickness + snap_gap);
    skirt_inner = skirt_outer - snap_skirt_thickness;
    bead_outer  = skirt_outer + snap_bead_size;

    // Flexing skirt wall (overlaps the plate slightly at the top to bond).
    translate([0, 0, -snap_skirt_depth])
        linear_extrude(height = snap_skirt_depth + SNAP_EPS)
            intersection() {
                difference() {
                    offset(delta = skirt_outer) children(0);
                    offset(delta = skirt_inner) children(0);
                }
                _snap_front_mask();
            }

    // Snap bead protruding from the skirt's outer face.
    translate([0, 0, -snap_skirt_depth + snap_bead_inset - snap_bead_height / 2])
        linear_extrude(height = snap_bead_height)
            intersection() {
                difference() {
                    offset(delta = bead_outer) children(0);
                    offset(delta = skirt_outer) children(0);
                }
                _snap_front_mask();
            }
}

// Tray groove (to subtract), in GLOBAL z. Sits at the assembled bead height so
// the bead seats into it; the tray wall above the groove is solid, so the bead
// must flex past it during assembly.
module front_snap_groove() {
    skirt_outer = -(wall_thickness + snap_gap);
    bead_outer  = skirt_outer + snap_bead_size;
    groove_out  = bead_outer + snap_gap;   // a touch past the bead tip
    groove_in   = skirt_outer - snap_gap;  // a touch inside the skirt outer face
    gz = split_height - snap_skirt_depth + snap_bead_inset;  // bead center (global)
    gh = snap_bead_height + 2 * snap_gap;                    // groove a bit taller

    translate([0, 0, gz - gh / 2])
        linear_extrude(height = gh)
            intersection() {
                difference() {
                    offset(delta = groove_out) children(0);
                    offset(delta = groove_in)  children(0);
                }
                _snap_front_mask();
            }
}
