include <params.scad>
include <lib/wedge.scad>
include <lib/utils.scad>

// DXF paths (relative to this file)
DXF_PERIMETER       = "../outlines/case_perimeter.dxf";
DXF_SWITCH_PLATE    = "../outlines/case_switch_plate.dxf";
DXF_XIAO_CAVITY     = "../outlines/case_xiao_cavity.dxf";
DXF_BATTERY_CAVITY  = "../outlines/case_battery_cavity.dxf";
DXF_POWER_SW_CAVITY = "../outlines/case_power_switch_cavity.dxf";
DXF_USB_OPENING     = "../outlines/case_usb_opening.dxf";
DXF_POWER_SW_OPEN   = "../outlines/case_power_switch_opening.dxf";

// Y extents of perimeter bounding box derived from ergogen geometry.
// Manual sync point: update if board geometry changes significantly.
PERIMETER_Y_FRONT = -21.89;
PERIMETER_Y_REAR  =  88.36;

module top_shell() {
    difference() {
        // Outer wedge body
        intersection() {
            linear_extrude(height = rear_height)
                import(DXF_PERIMETER);
            wedge_clip(PERIMETER_Y_FRONT, PERIMETER_Y_REAR, front_height, rear_height);
        }

        // Switch plate openings (through top plate)
        translate([0, 0, rear_height - top_plate_thickness])
            linear_extrude(height = top_plate_thickness + EPSILON)
                import(DXF_SWITCH_PLATE);

        // XIAO cavity
        translate([0, 0, floor_thickness])
            linear_extrude(height = xiao_height + xiao_z_clearance + EPSILON)
                import(DXF_XIAO_CAVITY);

        // Battery cavity
        translate([0, 0, floor_thickness])
            linear_extrude(height = battery_thickness + battery_z_clearance + EPSILON)
                import(DXF_BATTERY_CAVITY);

        // Power switch cavity
        translate([0, 0, floor_thickness])
            linear_extrude(height = rear_height)
                import(DXF_POWER_SW_CAVITY);

        // Rear USB opening
        linear_extrude(height = rear_height)
            import(DXF_USB_OPENING);

        // Rear power switch opening
        linear_extrude(height = rear_height)
            import(DXF_POWER_SW_OPEN);

        // TODO: interior hollow (needs case_inner_perimeter.dxf from ergogen —
        //       add inset outline using expand: -wall_thickness on _outer_rect)
    }
}
