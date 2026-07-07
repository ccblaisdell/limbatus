.PHONY: build ergogen case case-top case-bottom stl-dir view-case

OPENSCAD := openscad
CASE_DIR := case
STL_DIR  := stl

build: ergogen case

ergogen:
	npm run build:ergogen
	@# Ergogen's kicad8 template stamps the current date into the PCB title
	@# block (new Date()), which makes the artifact change every calendar day.
	@# Normalize it to a fixed value so the generated PCB is byte-reproducible.
	perl -0pi -e 's/\(date "\d{4}-\d{2}-\d{2}"\)/(date "")/' pcbs/limbatus.kicad_pcb

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
