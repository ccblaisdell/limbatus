// Copyright (c) 2026 Colby Blaisdell
//
// SPDX-License-Identifier: MIT
//
// Description:
//  A pair of direct-solder battery pads. Two rectangular SMD pads on the
//  selected copper layer with polarity silkscreen markers. Intended for
//  hand-soldered LiPo battery leads — no connector is used.
//
// Params
//    side: default is F
//      side on which to place the pads, either F or B.
//    pad_width: default 2.5
//      width (X) of each rectangular pad, in mm.
//    pad_height: default 3.0
//      height (Y) of each rectangular pad, in mm.
//    pad_spacing: default 3.5
//      center-to-center distance between the two pads, in mm.
//    include_silkscreen: default true
//      if true, draws + / - polarity markers on the silkscreen layer.
//    include_courtyard: default true
//      if true, draws a courtyard rectangle around the pad pair.
//    BAT_P: default net "BAT_P"
//      net connected to the positive pad.
//    BAT_N: default net "GND"
//      net connected to the negative pad.

module.exports = {
  params: {
    designator: 'BAT',
    side: 'F',
    pad_width: 2.5,
    pad_height: 3.0,
    pad_spacing: 3.5,
    include_silkscreen: true,
    include_courtyard: true,
    BAT_P: { type: 'net', value: 'BAT_P' },
    BAT_N: { type: 'net', value: 'GND' },
  },
  body: p => {
    const layer = p.side;
    const half_spacing = p.pad_spacing / 2;
    const silk_y = p.pad_height / 2 + 0.9;
    const ref_y = -(p.pad_height / 2 + 1.4);
    const ct_x = half_spacing + p.pad_width / 2 + 0.25;
    const ct_y = p.pad_height / 2 + 0.25;
    const silk_justify = layer === 'B' ? ' (justify mirror)' : '';

    const opening = `
    (footprint "local:battery_pads_solder"
        (layer "${layer}.Cu")
        ${p.at}
        (property "Reference" "${p.ref}"
            (at 0 ${ref_y} ${p.r})
            (layer "${layer}.SilkS")
            ${p.ref_hide}
            (effects (font (size 1 1) (thickness 0.15))${silk_justify})
        )
    `;

    const pads = `
        (pad "1" smd rect (at ${-half_spacing} 0 ${p.r}) (size ${p.pad_width} ${p.pad_height}) (layers "${layer}.Cu" "${layer}.Mask") ${p.BAT_P.str})
        (pad "2" smd rect (at ${half_spacing} 0 ${p.r}) (size ${p.pad_width} ${p.pad_height}) (layers "${layer}.Cu" "${layer}.Mask") ${p.BAT_N.str})
    `;

    const silkscreen = `
        (fp_text user "+" (at ${-half_spacing} ${silk_y} ${p.r}) (layer "${layer}.SilkS")
            (effects (font (size 1.0 1.0) (thickness 0.18))${silk_justify}))
        (fp_text user "-" (at ${half_spacing} ${silk_y} ${p.r}) (layer "${layer}.SilkS")
            (effects (font (size 1.2 1.2) (thickness 0.2))${silk_justify}))
    `;

    const courtyard = `
        (fp_line (start ${-ct_x} ${-ct_y}) (end ${ct_x} ${-ct_y}) (stroke (width 0.05) (type solid)) (layer "${layer}.CrtYd"))
        (fp_line (start ${ct_x} ${-ct_y}) (end ${ct_x} ${ct_y}) (stroke (width 0.05) (type solid)) (layer "${layer}.CrtYd"))
        (fp_line (start ${ct_x} ${ct_y}) (end ${-ct_x} ${ct_y}) (stroke (width 0.05) (type solid)) (layer "${layer}.CrtYd"))
        (fp_line (start ${-ct_x} ${ct_y}) (end ${-ct_x} ${-ct_y}) (stroke (width 0.05) (type solid)) (layer "${layer}.CrtYd"))
    `;

    const closing = `
    )
    `;

    let final = opening;
    final += pads;
    if (p.include_silkscreen) final += silkscreen;
    if (p.include_courtyard) final += courtyard;
    final += closing;
    return final;
  }
};
