include <params.scad>
include <lib/wedge.scad>
include <lib/utils.scad>

// DXF paths (relative to this file)
DXF_PERIMETER     = "../outlines/case_perimeter.dxf";
DXF_USB_OPENING   = "../outlines/case_usb_opening.dxf";
DXF_POWER_SW_OPEN = "../outlines/case_power_switch_opening.dxf";

// Y extents of perimeter bounding box derived from ergogen geometry.
// Manual sync point: update if board geometry changes significantly.
PERIMETER_Y_FRONT = -21.89;
PERIMETER_Y_REAR  =  88.36;

module top_shell() {
    difference() {
        // Outer wedge body
        intersection() {
            linear_extrude(height = rear_height)
                import(DXF_PERIMETER, convexity = 4);
            wedge_clip(PERIMETER_Y_FRONT, PERIMETER_Y_REAR, front_height, rear_height);
        }

        // Interior hollow — open top, walls only
        translate([0, 0, floor_thickness])
            linear_extrude(height = rear_height)
                offset(delta = -wall_thickness)
                    import(DXF_PERIMETER, convexity = 4);

        // Rear USB opening
        linear_extrude(height = rear_height)
            import(DXF_USB_OPENING, convexity = 4);

        // Rear power switch opening
        linear_extrude(height = rear_height)
            import(DXF_POWER_SW_OPEN, convexity = 4);
    }
}
