// Copyright (c) 2026 Colby Blaisdell
//
// SPDX-License-Identifier: MIT
//
// Description:
//  A single tented stitching via for tying the front and back GND copper pours
//  together. Modelled as a plated through-hole pad on all copper layers with no
//  solder-mask opening (so it is covered/tented), carrying the GND net. Placed
//  inside both gnd_pour_front and gnd_pour_back, it shorts the two planes through
//  its barrel -- improving ground integrity and giving cleaner RF return paths on
//  this 2.4GHz BLE board. Purely mechanical/electrical: excluded from BOM and
//  position files so it does not appear as an assembly component.
//
// Params
//    net: default net "GND"
//      net connected to the via (both planes use GND).
//    size: default 0.6
//      annular pad diameter, in mm.
//    drill: default 0.3
//      finished hole diameter, in mm (0.3 is a JLCPCB-friendly minimum).

module.exports = {
  params: {
    designator: 'V',
    net: { type: 'net', value: 'GND' },
    size: 0.6,
    drill: 0.3,
  },
  body: p => `
  (footprint "local:stitching_via"
    (layer "F.Cu")
    ${p.at}
    (attr exclude_from_pos_files exclude_from_bom allow_missing_courtyard)
    (property "Reference" "${p.ref}"
      (at 0 0 ${p.r})
      (layer "F.SilkS")
      ${p.ref_hide}
      (effects (font (size 1 1) (thickness 0.15)))
    )
    (pad "1" thru_hole circle
      (at 0 0 ${p.r})
      (size ${p.size} ${p.size})
      (drill ${p.drill})
      (layers "*.Cu")
      (remove_unused_layers no)
      ${p.net.str}
    )
  )
  `
}
