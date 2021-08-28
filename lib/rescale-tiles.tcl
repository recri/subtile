#
# rescale a tile
#
proc rescale-tile {s tile} {
    set newt [lindex $tile 0];
    foreach point [lrange $tile 1 end] {
	pset x y $point;
	lappend newt [list [expr $x*$s] [expr $y*$s]];
    }
    return $newt;
}

#
# rescale a tiling
#
proc rescale-tiling {s tiles} {
    set newts {}
    foreach tile $tiles {
	lappend newts [rescale-tile $s $tile];
    }
    return $newts;
}

#
# rescale a tile collection
#
proc rescale-collection {s collection} {
    set newc {};
    foreach item $collection {
	lappend newc [list [lindex $item 0] [rescale-tiling $s [lindex $item 1]]];
    }
    return $newc;
}


