// Captive power-switch actuator slider for the Alps SSSS811101.
//
// The SSSS811101 is a low-profile SMD side slide switch (6.7 x 2.6 x 1.4 mm,
// 1.5 mm slide travel, ~1.1 mm-thick horizontal actuator). Its knob protrudes
// only ~0.6 mm past the board's WEST edge and sits low against the PCB, so
// through a 2.5 mm case wall it is recessed and unreachable by a finger. This
// part bridges the tiny recessed knob out to a finger/nail-accessible paddle.
//
// Mechanism: a printed slider rides in a shallow channel milled into the INNER
// face of the west wall. A PADDLE pokes out through a narrow window slot in the
// wall (finger side); a wider FLANGE stays inside the channel so the slider
// cannot fall out the window (captive). A SLOT in the flange straddles the
// switch knob, so sliding the paddle drives the switch. The slider is dropped
// into the channel at assembly and trapped when the bottom tray closes under
// the top shell.
//
// Local frame (matches the board, top-shell convention):
//   +x = EAST  (inward, toward the PCB / switch body)
//   -x = WEST  (outward, through the wall, toward the user)
//   +y = NORTH (toward the board's rear/back edge), slide axis is along y
//   +z = UP
//   Origin: on the board WEST edge (wall inner face), at the knob's Z center,
//           on the switch/opening N-S center line.
//
// FIRST PASS -- like the front snap lip in params.scad, the fit numbers below
// are meant to be tuned against a test print. Print the slider flat (flange on
// the bed, slot facing up) so no support is needed in the knob slot.

// ---- Alps SSSS811101 facts (mirror ergogen/config.yaml + datasheet) --------
psa_wall_thickness = 2.5;   // case wall (mirror params.scad wall_thickness)
psa_travel         = 1.5;   // datasheet slide stroke
psa_knob_w         = 1.3;   // knob size along the slide axis (y), from footprint
psa_knob_proud     = 0.6;   // knob protrusion WEST past the board edge
psa_body_inset     = 1.0;   // switch body west face, EAST of board edge
                            // (= ergogen power_switch_west_clearance)

// ---- Fit clearances (TUNE against a test print) ----------------------------
psa_fit      = 0.25;  // general sliding clearance (paddle<->window, flange<->channel)
psa_grip_fit = 0.10;  // knob-slot clearance -- tighter; this drives the switch

// ---- Slider dimensions -----------------------------------------------------
psa_paddle_w   = 2.0;   // paddle width, y (along wall)
psa_paddle_h   = 3.0;   // paddle height, z
psa_paddle_out = 1.5;   // paddle protrusion past the OUTER wall face

psa_flange_w   = 5.0;   // flange width, y  (> window width => captive)
psa_flange_h   = 5.0;   // flange height, z
// Flange thickness (x) is capped so it clears the switch body west face.
psa_flange_t   = min(0.9, psa_body_inset - 0.1);

psa_fork_depth = psa_flange_t;                 // knob-slot depth into the flange (x)
psa_grip_relief = 0.4;                         // knob nub clearance west of the flange

$fn = 48;

// The slider (positive, printable / importable part).
module power_switch_actuator() {
    difference() {
        union() {
            // Flange: rides in the inner-wall channel, holds the slider captive.
            translate([0, -psa_flange_w/2, -psa_flange_h/2])
                cube([psa_flange_t, psa_flange_w, psa_flange_h]);

            // Paddle: through the wall window and proud of the outer face.
            translate([-(psa_wall_thickness + psa_paddle_out), -psa_paddle_w/2, -psa_paddle_h/2])
                cube([psa_wall_thickness + psa_paddle_out + 0.01, psa_paddle_w, psa_paddle_h]);
        }
        // Knob slot: straddles the switch knob (open toward the switch, +x).
        translate([-0.01, -(psa_knob_w + 2*psa_grip_fit)/2, -(psa_knob_w + 2*psa_grip_fit)/2])
            cube([psa_fork_depth + 0.02,
                  psa_knob_w + 2*psa_grip_fit,
                  psa_knob_w + 2*psa_grip_fit + 2]);  // tall slot; knob Z tolerant
    }
    // Vertical grip ridges across the paddle face (perpendicular to the
    // slide axis, so a fingernail catches them when you push the paddle).
    translate([-(psa_wall_thickness + psa_paddle_out), 0, 0])
        for (dy = [-0.55, 0, 0.55])
            translate([0, dy, 0])
                cylinder(h = psa_paddle_h, r = 0.2, center = true, $fn = 12);
}

// The NEGATIVE to subtract from a wall solid to form the window + channel.
// Subtract this from your wall (in the same local frame) to get a pocket the
// slider drops into. Window through the wall; channel is the wider inner recess.
module power_switch_actuator_cavity() {
    // Window slot through the wall (paddle passes through; tall enough for travel).
    translate([-(psa_wall_thickness + 0.5), -(psa_paddle_w + 2*psa_fit)/2,
               -(psa_paddle_h + psa_travel + 2*psa_fit)/2])
        cube([psa_wall_thickness + 1.0,
              psa_paddle_w + 2*psa_fit,
              psa_paddle_h + psa_travel + 2*psa_fit]);

    // Inner channel recess (captures the wider flange; limits travel via ends).
    translate([-0.01, -(psa_flange_w + 2*psa_fit)/2,
               -(psa_flange_h + psa_travel + 2*psa_fit)/2])
        cube([psa_flange_t + psa_fit,
              psa_flange_w + 2*psa_fit,
              psa_flange_h + psa_travel + 2*psa_fit]);
}

// ---- Demo: slider seated in a slice of wall, plus the switch knob ----------
module _psa_demo() {
    // Wall slice (west of x=0), with the cavity subtracted.
    color("Silver", 0.35)
    difference() {
        translate([-psa_wall_thickness, -6, -6]) cube([psa_wall_thickness, 12, 12]);
        power_switch_actuator_cavity();
    }
    // Switch knob nub (what we grip), east of / across x=0.
    color("Gold")
        translate([-psa_knob_proud, -psa_knob_w/2, -psa_knob_w/2])
            cube([psa_knob_proud + psa_body_inset, psa_knob_w, psa_knob_w]);
    // Slider.
    color("SteelBlue") power_switch_actuator();
}

_psa_demo();
