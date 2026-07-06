# Gerber provenance

`gerbers/` holds **production** fabrication outputs — a pinned snapshot that
should correspond to boards you have actually ordered. They are NOT live build
outputs and are intentionally decoupled from `outlines/` and `pcbs/`, which
track the current design. Expect `gerbers/` to lag the rest of the repo between
orders; the artifacts are only guaranteed to agree at a tagged fab commit.

Refresh `gerbers/` only when placing a fab order: regenerate, commit them in a
dedicated commit, update the record below, and tag the commit (`fab-YYYY-MM-DD`
or by fab/order id).

## Current snapshot

| Field         | Value |
|---------------|-------|
| Status        | pre-production placeholder (not yet ordered) |
| Source commit | 00dc192 ("Commit gerbers and pcbs from latest successful build") |
| Generated     | 2026-07-06 (CI build, not physically fabricated) |
| Fab / order   | none |
| Tag           | none |

These predate the power-switch reposition, GND stitching vias, and logo/silk
changes now on `main`, so they do not match the current `pcbs/limbatus.kicad_pcb`.
Replace them with a real production snapshot at first order.
