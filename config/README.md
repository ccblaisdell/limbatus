# limbatus ZMK firmware

ZMK config for **limbatus**, a monoblock (unibody, non-split) wireless keyboard
built on a single Seeed **XIAO BLE nRF52840** driving a logical **6×6 diode
matrix**. This is the shipping **34-key** layout.

Because limbatus is unibody, there is one firmware image (one `board + shield`
pair) — not the `_left` / `_right` split pair you'd see on a Dimetrodon-style
board.

## Layout

```
build.yaml                                   GitHub Actions build matrix
config/
  west.yml                                   ZMK + urob/zmk-helpers, both pinned
  limbatus.keymap                            34-key keymap (QWERTY / NAV / SYM / FUN)
  limbatus.conf                              user Kconfig (battery, sleep, logging)
  boards/shields/limbatus/
    limbatus.overlay                         kscan matrix + transform + chosen
    limbatus.conf                            shield requirement (NFC pins as GPIO)
    limbatus.yml                             shield metadata
    Kconfig.shield / Kconfig.defconfig       shield selection + name
.github/workflows/zmk-build.yml              firmware CI (pinned reusable workflow)
```

## Matrix ↔ pin mapping

The single source of truth for wiring is `ergogen/config.yaml`
(`pcbs.limbatus.footprints.xiao_ble`). This firmware mirrors it:

| Matrix | XIAO pin | ZMK reference | nRF pin |
| ------ | -------- | ------------- | ------- |
| C0 | D0  | `&xiao_d 0`  | P0.02 |
| C1 | D1  | `&xiao_d 1`  | P0.03 |
| C2 | D2  | `&xiao_d 2`  | P0.28 |
| C3 | D3  | `&xiao_d 3`  | P0.29 |
| C4 | D4  | `&xiao_d 4`  | P0.04 |
| C5 | D5  | `&xiao_d 5`  | P0.05 |
| R0 | D6  | `&xiao_d 6`  | P1.11 |
| R1 | D7  | `&xiao_d 7`  | P1.12 |
| R2 | D8  | `&xiao_d 8`  | P1.13 |
| R3 | D9  | `&xiao_d 9`  | P1.14 |
| R4 | D10 | `&xiao_d 10` | P1.15 |
| R5 | NFC1 | `&gpio0 9`  | P0.09 |

Diodes run switch→row with the anode on the column side, so
`diode-direction = "col2row"`: columns are strobed outputs, rows are sampled
inputs (pulled down).

**NFC pin:** R5 lives on P0.09, an NFC antenna pin by default.
`boards/shields/limbatus/limbatus.conf` sets `CONFIG_NFCT_PINS_AS_GPIOS=y` so
P0.09/P0.10 become plain GPIO. This is written into UICR on first flash; if the
sixth row is dead, confirm this landed. (Matches the CLAUDE.md decision: "disable
NFC and use NFC1 as GPIO for the sixth matrix row.")

## Building

CI (`.github/workflows/zmk-build.yml`) builds `xiao_ble//zmk` + `limbatus` on
every push that touches `config/**` or `build.yaml`, and uploads a `firmware`
artifact containing `limbatus.uf2`. Flash by double-tapping reset (via the case
tab) to enter the UF2 bootloader and dropping the `.uf2` onto the mass-storage
volume.

The board target is `xiao_ble//zmk` — the `//zmk` selects ZMK's board variant
(the SoC is omitted since nRF52840 is the only one). Plain `xiao_ble` builds the
bare Zephyr board and CI rejects it as "Missing ZMK Compat".

Local build:

```sh
west build -s zmk/app -b 'xiao_ble//zmk' -- -DSHIELD=limbatus -DZMK_CONFIG=$(pwd)/config
```

## Versions

ZMK and urob/zmk-helpers are pinned in `config/west.yml`; the reusable build
workflow in `.github/workflows/zmk-build.yml` is pinned to the **same** ZMK
commit. Bump them together. ZMK is currently tracking a `main` commit (there is
no release tag yet that ships the `xiao_ble` board id used here); if CI breaks
after a helper bump, re-pin to a known-good pair.

## 36-key variant (optional)

limbatus keeps a 36-key (3 thumbs/side) infrastructure path on the PCB side. To
build firmware for it you'd:

1. add the third thumb per side to the transform — left `RC(2,5)`, right
   `RC(5,5)` — in `limbatus.overlay`;
2. switch the keymap include to `zmk-helpers/key-labels/36.h` and restore the
   outer thumb keys (six-key thumb rows);
3. rename/duplicate the shield as needed.

The 34-key build above is the advertised default.
