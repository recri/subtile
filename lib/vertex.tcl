# hash a vertex by reducing the precision of its coordinates
proc vertex-hash {v} {
    return [eval format {{%.5g %.5g}} $v]
}

