#
# force a tile to anti-clockwise vertex order
#
proc tile-signed-area {tile} {
    set a 0;
    set pi [tile-vertex $tile 0];
    set pj [tile-vertex $tile 1];
    set vij [vsub $pj $pi];
    for {set i 2} {$i < [tile-size $tile]} {incr i} {
        set pk [tile-vertex $tile $i];
        set vik [vsub $pk $pi];
        set a [expr $a + [vcross $vij $vik]];
        set vij $vik;
    }
    return $a;
}

proc clockwise-tile-p {tile} {
    if {[tile-signed-area $tile] < 0} {
        return 1;
    } else {
        return 0;
    }
}

proc anti-clockwise-tile-p {tile} {
    if {[tile-signed-area $tile] > 0} {
        return 1;
    } else {
        return 0;
    }
}

proc anti-clockwise-tile {tile} {
    if {[anti-clockwise-tile-p $tile]} {
        return $tile;
    } else {
        return [make-tile-from-type-and-list-of-vertices [tile-type $tile] [lreverse [tile-vertices $tile]]]
    }
}

#
# force a tiling to anti-clockwise vertex order
#
proc anti-clockwise-tiling {tiles} {
    set newts {};
    foreach tile $tiles {
        lappend newts [anti-clockwise-tile $tile];
    }
    return $newts;
}

#
# force a collection to anti-clockwise vertex order
#
proc anti-clockwise-collection {collection} {
    set newc {};
    foreach item $collection {
        lappend newc [list [lindex $item 0] [anti-clockwise-tiling [lindex $item 1]]];
    }
    return $newc;
}


