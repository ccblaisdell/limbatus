// wedge_clip: clips a vertical extrusion into a taper along Y.
//
// Uses polyhedron + intersection() (not hull()) so the DXF planform
// is preserved exactly, including any corner fillets.
//
// y_front / y_rear: Y extents of the perimeter bounding box.
// h_front / h_rear: desired Z height at front and rear edges.
// oversize: half-width in X — must exceed the board width.
//
// NOTE: y_front/y_rear must stay in sync with ergogen geometry.
// Current values: y_front = -21.89, y_rear = 88.36.
// Update here and in top_shell.scad / bottom_tray.scad if board
// geometry changes significantly.

module wedge_clip(y_front, y_rear, h_front, h_rear, oversize = 200) {
    W = oversize;
    polyhedron(
        points = [
            [ W, y_front, 0],        // 0
            [ W, y_rear,  0],        // 1
            [ W, y_rear,  h_rear],   // 2
            [ W, y_front, h_front],  // 3
            [-W, y_front, 0],        // 4
            [-W, y_rear,  0],        // 5
            [-W, y_rear,  h_rear],   // 6
            [-W, y_front, h_front],  // 7
        ],
        faces = [
            [0,1,2,3],  // +X face
            [4,7,6,5],  // -X face
            [0,3,7,4],  // front face
            [1,5,6,2],  // rear face
            [0,4,5,1],  // bottom face
            [3,2,6,7],  // top face (sloped)
        ]
    );
}
