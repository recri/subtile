#
# recenter a tile
#
proc recenter-tile {dx dy tile} {
    set newt [lindex $tile 0];
    foreach point [lrange $tile 1 end] {
	pset x y $point;
	lappend newt [list [expr $x+$dx] [expr $y+$dy]];
    }
    return $newt;
}

#
# recenter a tiling
#
proc recenter-tiling {tiles} {
    pset xmin ymin xmax ymax [bound-tiling $tiles];
    set dx [expr -$xmin+(1-($xmax-$xmin))/2];
    set dy [expr -$ymin+(1-($ymax-$ymin))/2];
    set newts {};
    foreach tile $tiles {
	lappend newts [recenter-tile $dx $dy $tile];
    }
    return $newts;
}

#
# recenter a collection of tilings
#
proc recenter-collection {collection} {
    set newc {};
    foreach item $collection {
	lappend newc [list [lindex $item 0] [recenter-tiling [lindex $item 1]]];
    }
    return $newc;
}


