// All dimensions in mm.
// Ergogen-derived component values are mirrors of ergogen/config.yaml.

// Shell thickness
wall_thickness  = 2.5;
floor_thickness = 1.5;

// PCB thickness
pcb_thickness = 1.6;

// Wall heights (rear = XIAO/battery side, front = thumb cluster side)
// Rear hides switch bodies (5.0mm) and XIAO (pcb_thickness + 4.5 = 6.1mm above PCB surface).
// Front is floor_thickness only — switches fully exposed.
rear_height  = 7.0;
front_height = 1.5;  // = floor_thickness

// Front lip overhang beyond PCB perimeter
front_overhang = 10.0;

// Shell split height (bottom tray top / top shell bottom interface)
// 1.5mm floor + ~2.5mm clearance for hotswap socket pins (~2mm below PCB)
split_height = 4.0;

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
