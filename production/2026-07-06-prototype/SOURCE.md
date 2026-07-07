# Production bundle: 2026-07-06-prototype

A self-contained, frozen snapshot of the fabrication artifacts and the exact
board they were generated from. Do not edit these files — they are a record of
one build/order.

| Field         | Value |
|---------------|-------|
| Status        | **prototype — NOT physically ordered** |
| Source commit | `00dc192` ("Commit gerbers and pcbs from latest successful build") |
| Generated     | 2026-07-06 (CI build) |
| Fab / order   | none |
| Tag           | none |

## Contents

- `gerbers/limbatus/` + `gerbers/limbatus.zip` — gerbers for the base board.
- `gerbers/limbatus_autorouted/` + `.zip` — gerbers for the autorouted board.
- `limbatus.kicad_pcb` — the PCB these gerbers were generated from (from `00dc192`).
- `outlines/` — the board/case outlines from the same commit.

## Notes

This predates the power-switch reposition, GND stitching vias, and logo/silk
changes now on `main`, so it does **not** reflect the current design. It is kept
only as a reference build. When you place a real fab order, cut a fresh bundle
(see `production/README.md`); this prototype can be deleted at that point.
