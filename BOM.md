# limbatus — Bill of Materials

34-key (`thumb_keys_per_side: 2`) monoblock wireless build. Quantities below are
for **one** keyboard.

> Generated from `ergogen/config.yaml`. The switches, keycaps, battery, and case
> hardware are **not** on the PCB netlist, so a KiCad-derived BOM would only list
> the XIAO, hotswap sockets, diodes, and power switch — the rest is tracked here
> by hand.

## On-PCB electronics

| Ref | Qty | Component | Package / footprint | Notes |
|-----|-----|-----------|---------------------|-------|
| MCU1 | 1 | Seeed Studio XIAO BLE nRF52840 | through-hole module (`local/xiao_ble`) | Wireless MCU. NFC must be disabled in firmware so `NFC1` works as the R5 row GPIO. Battery power enters via the XIAO's **BAT+/BAT−** pads (`BAT_POS`→`RAW`, `BAT_NEG`→`GND`) so the onboard charger manages the cell — these pads must be connected (see BUILD.md). |
| D1–D34 | 34 | 1N4148W switch diode | SOD-123, **SMD**, front side (`ceoloide/diode_tht_sod123`) | One per key. Cathode toward the row net. |
| — (per switch) | 34 | Kailh Choc hotswap socket | Choc v1 hotswap, SMD (`ceoloide/switch_choc_v1_v2`) | Soldered to the PCB; switches drop in. |
| PWR1 | 1 | Alps SSSS811101 slide switch | SMD side-operated (`ceoloide/power_switch_smd_side`) | On/off, in series in the battery + line (`Braw`→`RAW`). In the **top-left margin next to the XIAO** (grouped with the battery pads to keep power routing short). Shorter than the hotswap sockets, mounted on the same (front) side. (e.g. Typeractive / LCSC) |
| BAT1 | 1 | LiPo cell, direct-solder | 2 solder pads (`local/battery_pads_solder`) | ~80 × 20 × 4 mm cell (footprint must stay ≤ ~82 × 23 mm). **No JST connector** — leads solder directly to BAT pads (`Braw` = +, `GND` = −). The cell drops into a **PCB pocket** (full-footprint cutout) and rests on the bottom-tray floor, sitting ~1 board thickness lower; pads are on solid copper just west of the pocket (toward the XIAO/switch corner). |

## Switches & keycaps (hand-fitted, not on netlist)

| Qty | Component | Notes |
|-----|-----------|-------|
| 34 | Kailh Choc v1 switches | Drop into the hotswap sockets. |
| 34 | Choc keycaps (1u) | Spacing is 18 × 17 mm. |

## Case hardware (mechanical)

| Qty | Component | Notes |
|-----|-----------|-------|
| 6 | M3 heat-set threaded inserts | Pressed into the bottom-tray bosses (`MH1`–`MH6` positions). |
| 6 | M3 screws | Join the shells through the top shell into the inserts. Length TBD after a test print. |
| — | 3D-printed case | `top_shell` + `bottom_tray` (see `case/`). Front shells clip via the snap-fit lip. |

## Notes

- **Hotswap:** switches are not soldered — only the 34 Choc hotswap sockets are.
- **PCBA option:** if having JLCPCB assemble the SMD parts (sockets, diodes,
  power switch), generate a position/CPL file from KiBot — not currently emitted.
- **Diodes are SMD** (SOD-123) on the **front**; confirm orientation before reflow/hand-soldering.
- **Battery:** direct-solder pads only; observe polarity (`Braw` = +, `GND` = −). Path
  is battery + → power switch → XIAO BAT+; battery − → GND plane.
- **Ground plane:** both copper layers have a `GND` pour, so GND is a plane rather than
  routed traces (also frees the autorouter and improves the return path).
- **Insert/screw lengths** depend on the printed case and want a test print to finalize.
