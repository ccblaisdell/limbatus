.PHONY: build ergogen case case-top case-bottom stl-dir view-case onshape-mesh

OPENSCAD := openscad
CASE_DIR := case
STL_DIR  := stl

# Dev-only tooling for the Onshape reference mesh (not part of `build`/CI).
KICAD_CLI     ?= /Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
BLENDER       ?= /Applications/Blender.app/Contents/MacOS/Blender
PCB           ?= pcbs/limbatus.kicad_pcb
EXPORT_DIR    := export3d
ONSHAPE_RATIO ?= 0.08

build: ergogen case

ergogen:
	npm run build:ergogen

# Light, decimated mesh of the whole board + components for case design in
# Onshape (a mesh imports far lighter than the full-detail BREP STEP). KiCad's
# raw STL is ~3.3M triangles; Blender collapses it to ONSHAPE_RATIO of that
# (~8% default) while keeping the overall shape and exact dimensions.
# Requires KiCad + Blender; regenerate after layout changes. KIPRJMOD must be
# set or the component 3D models don't resolve. For PRECISE board geometry,
# prefer outlines/board.dxf instead of this mesh.
onshape-mesh: ergogen
	mkdir -p $(EXPORT_DIR)
	$(KICAD_CLI) pcb export stl --force \
	    -D KIPRJMOD="$(abspath pcbs)" \
	    -o $(EXPORT_DIR)/limbatus-full.stl $(PCB)
	$(BLENDER) -b -P scripts/decimate_mesh.py -- \
	    $(EXPORT_DIR)/limbatus-full.stl \
	    $(EXPORT_DIR)/limbatus-onshape.stl \
	    $(ONSHAPE_RATIO)
	@echo "Onshape mesh ready: $(EXPORT_DIR)/limbatus-onshape.stl"

case: case-top case-bottom

stl-dir:
	mkdir -p $(STL_DIR)

case-top: stl-dir
	$(OPENSCAD) -D 'part="top_shell"' \
	    -o $(STL_DIR)/top_shell.stl \
	    $(CASE_DIR)/case.scad

case-bottom: stl-dir
	$(OPENSCAD) -D 'part="bottom_tray"' \
	    -o $(STL_DIR)/bottom_tray.stl \
	    $(CASE_DIR)/case.scad

view-case:
	open /Applications/OpenSCAD-2021.01.app --args $(abspath $(CASE_DIR)/case.scad)
