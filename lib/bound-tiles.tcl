#
# bound a tile
#
proc bound-tile {tile} {
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
    return "$xmin $ymin $xmax $ymax";
}

#
# bound a tiling
#
proc bound-tiling {tiles} {
    pset xmin ymin xmax ymax [bound-tile [lindex $tiles 0]];
    foreach tile [lrange $tiles 1 end] {
	pset x0 y0 x1 y1 [bound-tile $tile];
	if {$x0 < $xmin} {
	    set xmin $x0;
	}
	if {$x1 > $xmax} {
	    set xmax $x1;
	}
	if {$y0 < $ymin} {
	    set ymin $y0;
	}
	if {$y1 > $ymax} {
	    set ymax $y1;
	}
    }
    return "$xmin $ymin $xmax $ymax";
}

#
# bound a tile collection
#
proc bound-collection {collection} {
    pset xmin ymin xmax ymax [bound-tiling [lindex [lindex $collection 0] 1]]
    foreach item [lrange $collection 1 end] {
	pset x0 y0 x1 y1 [bound-tiling [lindex $item 1]];
	if {$x0 < $xmin} {
	    set xmin $x0;
	}
	if {$x1 > $xmax} {
	    set xmax $x1;
	}
	if {$y0 < $ymin} {
	    set ymin $y0;
	}
	if {$y1 > $ymax} {
	    set ymax $y1;
	}
    }
    return "$xmin $ymin $xmax $ymax";
}


