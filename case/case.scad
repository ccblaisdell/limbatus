include <params.scad>
use <top_shell.scad>
use <bottom_tray.scad>

// Render a single part or both in exploded view.
// Override from CLI: openscad -D 'part="top_shell"' ...
part = "both";

EXPLODE_Z = 30;

if (part == "top_shell") {
    top_shell();
} else if (part == "bottom_tray") {
    bottom_tray();
} else {
    bottom_tray();
    translate([0, 0, split_height + EXPLODE_Z])
        top_shell();
}
