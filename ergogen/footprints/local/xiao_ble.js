// Local fork of ImStuBTW/xiao-ble.
//
// The upstream footprint stamps the XIAO module's castellation/USB outline
// onto the board's Edge.Cuts layer (a flush/in-board mount style). For limbatus
// the XIAO is top-mounted on the PCB and enclosed by a case cavity (see
// case/README.md), so those cuts are undesirable: they would slot the PCB under
// the MCU and they put the SWD/BAT/NFC through-hole pads 0-0.2mm from board
// edges, tripping KiBot's copper_edge_clearance DRC.
//
// This copy is identical to the upstream footprint except the "Drawings on
// Edge.Cuts" block has been removed. The Dwgs.User reference outline is kept.
module.exports = {
  params: {
    designator: 'MCU',
    side: 'F',
    P0: { type: 'net', value: 'P0' },
    P1: { type: 'net', value: 'P1' },
    P2: { type: 'net', value: 'P2' },
    P3: { type: 'net', value: 'P3' },
    P4: { type: 'net', value: 'P4' },
    P5: { type: 'net', value: 'P5' },
    P6: { type: 'net', value: 'P6' },
    P7: { type: 'net', value: 'P7' },
    P8: { type: 'net', value: 'P8' },
    P9: { type: 'net', value: 'P9' },
    P10: { type: 'net', value: 'P10' },
    RAW3V3: { type: 'net', value: '3V3' },
    GND: { type: 'net', value: 'GND' },
    RAW5V: { type: 'net', value: '5V' },
    SWCLK: { type: 'net', value: 'SWCLK' },
    SWDIO: { type: 'net', value: 'SWDIO' },
    RST: { type: 'net', value: 'RST' },
    BAT_POS: { type: 'net', value: 'BAT_POS' },
    BAT_NEG: { type: 'net', value: 'BAT_NEG' },
    NFC1: { type: 'net', value: 'NFC1' },
    NFC2: { type: 'net', value: 'NFC2' },
    // Optional 3D model for design-time visualization. Point the filename at a
    // STEP/WRL via a KiCad path variable (e.g. ${KIPRJMOD}/...); when empty no
    // (model ...) node is emitted. Mirrors the ceoloide footprints' convention.
    xiao_3dmodel_filename: { type: 'string', value: '' },
    xiao_3dmodel_xyz_offset: { type: 'array', value: [0, 0, 0] },
    xiao_3dmodel_xyz_rotation: { type: 'array', value: [0, 0, 0] },
    xiao_3dmodel_xyz_scale: { type: 'array', value: [1, 1, 1] },
  },
  body: p => {
    const fp = [];
    const flip = p.side === "B";
if (!flip && p.side !== "F") throw new Error('unsupported side: ' + p.side);

fp.push(`(footprint "XIAO-BLE"`);
fp.push(`(at ${p.x} ${p.y} ${flipR(flip, p.r)})`);
fp.push(`(layer "${(flip ? "B.Cu" : "F.Cu")}")`);
fp.push(`(property "Reference" "${p.ref}" ${p.ref_hide} (at 0 0 ${flipR(flip, p.r) % 180}) (layer "${p.side}.SilkS") (effects (font (size 1 1) (thickness 0.15))${ p.side === "B" ? " (justify mirror)" : ""}))`);
fp.push(`(property "Value" "" hide (at 0 0 ${flipR(flip, p.r) % 180}) (layer "${p.side}.Fab") (effects (font (size 1 1) (thickness 0.15))${ p.side === "B" ? " (justify mirror)" : ""}))`);
fp.push(`(property "Datasheet" "" hide (at 0 0 ${flipR(flip, p.r) % 180}) (layer "${p.side}.Fab") (effects (font (size 1 1) (thickness 0.15))${ p.side === "B" ? " (justify mirror)" : ""}))`);
fp.push(`(property "Description" "" hide (at 0 0 ${flipR(flip, p.r) % 180}) (layer "${p.side}.Fab") (effects (font (size 1 1) (thickness 0.15))${ p.side === "B" ? " (justify mirror)" : ""}))`);

fp.push(`(attr through_hole)`);

// Unknown to kicad2ergogen
fp.push(`(embedded_fonts no)`);

// Pads
fp.push(`(pad "1" thru_hole oval (at -7.62 ${flipN(flip, -7.62)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P0})`);
fp.push(`(pad "2" thru_hole oval (at -7.62 ${flipN(flip, -5.08)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P1})`);
fp.push(`(pad "3" thru_hole oval (at -7.62 ${flipN(flip, -2.54)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P2})`);
fp.push(`(pad "4" thru_hole oval (at -7.62 ${flipN(flip, 0)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P3})`);
fp.push(`(pad "5" thru_hole oval (at -7.62 ${flipN(flip, 2.54)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P4})`);
fp.push(`(pad "6" thru_hole oval (at -7.62 ${flipN(flip, 5.08)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P5})`);
fp.push(`(pad "7" thru_hole oval (at -7.62 ${flipN(flip, 7.62)} ${flipR(flip, p.r + 0)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P6})`);
fp.push(`(pad "8" thru_hole oval (at 7.62 ${flipN(flip, 7.62)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P7})`);
fp.push(`(pad "9" thru_hole oval (at 7.62 ${flipN(flip, 5.08)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P8})`);
fp.push(`(pad "10" thru_hole oval (at 7.62 ${flipN(flip, 2.54)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P9})`);
fp.push(`(pad "11" thru_hole oval (at 7.62 ${flipN(flip, 0)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.P10})`);
fp.push(`(pad "12" thru_hole oval (at 7.62 ${flipN(flip, -2.54)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.RAW3V3})`);
fp.push(`(pad "13" thru_hole oval (at 7.62 ${flipN(flip, -5.08)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.GND})`);
fp.push(`(pad "14" thru_hole oval (at 7.62 ${flipN(flip, -7.62)} ${flipR(flip, p.r + 180)}) (size 2.75 1.8) (drill 1 (offset -0.475 0)) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.RAW5V})`);
fp.push(`(pad "15" thru_hole circle (at -1.27 ${flipN(flip, -8.572)} ${flipR(flip, p.r + 90)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.SWCLK})`);
fp.push(`(pad "16" thru_hole circle (at 1.27 ${flipN(flip, -8.572)} ${flipR(flip, p.r + 90)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.SWDIO})`);
fp.push(`(pad "17" thru_hole circle (at -1.27 ${flipN(flip, -6.032)} ${flipR(flip, p.r + 90)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.GND})`);
fp.push(`(pad "18" thru_hole circle (at 1.27 ${flipN(flip, -6.032)} ${flipR(flip, p.r + 90)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.RST})`);
fp.push(`(pad "19" thru_hole circle (at -4.445 ${flipN(flip, -0.317)} ${flipR(flip, p.r + 180)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.BAT_POS})`);
fp.push(`(pad "20" thru_hole circle (at -4.445 ${flipN(flip, -2.222)} ${flipR(flip, p.r + 180)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.BAT_NEG})`);
fp.push(`(pad "21" thru_hole circle (at 3.802408 ${flipN(flip, 8.801408)} ${flipR(flip, p.r + 270)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.NFC1})`);
fp.push(`(pad "22" thru_hole circle (at 5.707408 ${flipN(flip, 8.801408)} ${flipR(flip, p.r + 270)}) (size 1.397 1.397) (drill 1.016) (layers "*.Cu" "*.Mask") (remove_unused_layers no)  ${p.NFC2})`);

// Optional 3D model (only emitted when a filename is provided).
if (p.xiao_3dmodel_filename) {
  const o = p.xiao_3dmodel_xyz_offset;
  const r = p.xiao_3dmodel_xyz_rotation;
  const s = p.xiao_3dmodel_xyz_scale;
  fp.push(`(model "${p.xiao_3dmodel_filename}"`);
  fp.push(`  (offset (xyz ${o[0]} ${o[1]} ${o[2]}))`);
  fp.push(`  (scale (xyz ${s[0]} ${s[1]} ${s[2]}))`);
  fp.push(`  (rotate (xyz ${r[0]} ${r[1]} ${r[2]})))`);
}

// NOTE: upstream "Drawings on Edge.Cuts" block intentionally omitted (see header).

// Drawings on Dwgs.User
fp.push(`(fp_rect (start -8.89 ${flipN(flip, 10.5)}) (end 8.89 ${flipN(flip, -10.5)}) (stroke (width 0.12) (type solid)) (fill no) (layer "Dwgs.User") )`);
fp.push(`(fp_rect (start -5.285811 ${flipN(flip, -6.785813)}) (end -3.507811 ${flipN(flip, -4.118813)}) (stroke (width 0.12) (type solid)) (fill no) (layer "Dwgs.User") )`);
fp.push(`(fp_rect (start -3.507811 ${flipN(flip, -8.182813)}) (end -5.285811 ${flipN(flip, -10.849813)}) (stroke (width 0.12) (type solid)) (fill no) (layer "Dwgs.User") )`);
fp.push(`(fp_rect (start 3.350197 ${flipN(flip, -10.849813)}) (end 5.128197 ${flipN(flip, -8.182813)}) (stroke (width 0.12) (type solid)) (fill no) (layer "Dwgs.User") )`);
fp.push(`(fp_rect (start 3.350197 ${flipN(flip, -6.785813)}) (end 5.128197 ${flipN(flip, -4.118813)}) (stroke (width 0.12) (type solid)) (fill no) (layer "Dwgs.User") )`);

    fp.push(')');
    return fp.join('\n');
  }
}
function normalizeAngle(angle) {
  angle = angle % 360;
  if (angle <= -180) angle += 360;
  else if (angle > 180) angle -= 360;
  return angle;
}
function flipR(flip, r) { return normalizeAngle(flip ? (180 - r) : r) }
function flipN(flip, n) { return flip ? -n : n }
