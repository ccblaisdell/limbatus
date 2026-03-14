// All dimensions in mm.
// Ergogen-derived component values are mirrors of ergogen/config.yaml.

// Shell thickness
wall_thickness      = 2.5;
floor_thickness     = 1.5;
top_plate_thickness = 3.5;

// Wedge heights (rear = XIAO/battery side, front = thumb cluster side)
rear_height  = 14.0;
front_height =  6.0;

// Front lip overhang beyond PCB perimeter
front_overhang = 10.0;

// Shell split height (bottom tray top / top shell bottom interface)
split_height = floor_thickness + 6.5;  // ~PCB + hotswap clearance; tune after fit check

// PCB retaining ledge
ledge_width  = 1.5;
ledge_height = 1.2;

// Z-axis component clearances (ergogen DXF already has XY clearance)
xiao_z_clearance    = 1.0;
battery_z_clearance = 1.0;

// Component heights (mirrors of ergogen/config.yaml)
xiao_height       = 4.5;
battery_thickness = 5.5;

// Fasteners
screw_diameter           = 3.0;
screw_head_diameter      = 5.5;
insert_diameter          = 4.5;
insert_depth             = 5.0;
boss_diameter            = insert_diameter + 2.0;
boss_height              = insert_depth + 1.0;
screw_clearance_diameter = screw_diameter + 0.4;

$fn = 64;
