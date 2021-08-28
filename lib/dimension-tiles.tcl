#
# dimension of a tile
#
proc dimension-tile {tile} {
    pset xmin ymin [lindex $tile 1];
    pset xmax ymax "$xmin $ymin";
    foreach point [lrange $tile 2 end] {
	pset x y $point;
	if {$x < $xmin} {
	    set xmin $x;
	} elseif {$x > $xmax} {
	    set xmax $x;
	}
	if {$y < $ymin} {
	    set ymin $y;
	} elseif {$y > $ymax} {
	    set ymax $y;
	}
    }
    return [list [expr $xmax-$xmin] [expr $ymax-$ymin]];
}

#
# dimension a tiling
#
proc dimension-tiling {tiles} {
    pset x0 y0 x1 y1 [bound-tiling $tiles];
    return [list [expr $x1-$x0] [expr $y1-$y0]];
}

#
# dimension a tile collection
#
proc dimension-collection {collection} {
    pset dx dy [dimension-tiling [lindex [lindex $collection 0] 1]]
    foreach item [lrange $collection 1 end] {
	pset dx1 dy1 [dimension-tiling [lindex $item 1]];
	if {$dx < $dx1} {
	    set dx $dx1;
	}
	if {$dy < $dy1} {
	    set dy $dy1;
	}
    }
    return [list $dx $dy];
}


