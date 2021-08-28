#
# force a tile to anti-clockwise vertex order
#
proc tile-signed-area {tile} {
    set a 0;
    set pi [lindex $tile 1];
    set pj [lindex $tile 2];
    set vij [vsub $pj $pi];
    for {set i 3} {$i < [llength $tile]} {incr i} {
	set pk [lindex $tile $i];
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
	set newt [lindex $tile 0];
	for {set i [llength $tile]} {[incr i -1] > 0} {} {
	    lappend newt [lindex $tile $i];
	}
	return $newt;
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


