# hash an edge by making a lower precision string
proc edge-hash {v1 v2} {
    return [lsort [list [vertex-hash $v1] [vertex-hash $v2]]];
}
