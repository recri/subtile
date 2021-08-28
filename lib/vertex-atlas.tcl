# this needs to reduce the resolution
# of vertex coordinates to allow easy
# matching
proc vadd-loresolution {u v} {
    return [vadd $u $v]
}

proc vertex-atlas-tiling {tiling} {

    # create a map of tiles incident to each vertex
    ## obsolete
    ## global tcl_precision;
    set z [vmake 0 0];
    foreach tile $tiling {
	# the tile type
	set type [lindex $tile 0];
	# the first vertex
	set pj [lindex $tile 1];
	# is this a clockwise tile
	set cw [clockwise-tile-p $tile];
	# from the 2nd to the last and on to the first
	# form the vector from pi to the previous vertex
	set vis {};
	set vijs {};
	foreach pi [concat [lrange $tile 2 end] [list $pj]] {
	    # compute the edge vector
	    set vij [vsub $pi $pj];
	    # normalize to unit length
	    set vij [vscale [expr 1/[vlength $vij]] $vij]
	    # remember the edge vector
	    lappend vijs $vij;
	    # remember the vertices at lower precision
	    ## obsolete
	    ## set tcl_precision 3;
	    lappend vis [vadd-loresolution $z $pi];
	    ## obsolete
	    ## set tcl_precision 6;
	    # step to the next vertex
	    set pj $pi;
	}
	# extend the vij list by the first
	lappend vijs [lindex $vijs 0];
	# make the list clockwise
	if { ! $cw } {
	    set vijs [lreverse $vijs];
	    set vis [lreverse $vis];
	}
	# now install the vertices
	for {set i 0} {$i < [llength $vis]} {incr i} {
	    lappend vertices([lindex $vis $i]) [list [lindex $vijs $i] [vneg [lindex $vijs [expr $i+1]]] $tile];
	    #puts "[lindex $vis $i], cw? $cw,  [lindex $vijs $i] [vneg [lindex $vijs [expr $i+1]]]\n\t$tile"
	}
    }

    # for each vertex found,
    # match the tiles incident to the vertex
    # by their edge vectors
    foreach vertex [array names vertices] {
	#puts "vertex $vertex";
	if {[llength $vertices($vertex)] < 3} {
	    unset vertices($vertex);
	    continue;
	}
	catch {unset edge};
	catch {unset vcw};
	catch {unset ang};
	set t 0;
	# find the edges radiating from the vertex
	foreach item $vertices($vertex) {
	    # get the edges incident to the vertex
	    pset vij vik tile $item;
	    #puts "$vertex -> $item"
	    # remember this tile as containing this edge
	    lappend edge($vij) $t;
	    lappend edge($vik) $t;
	    # remember the more clockwise edge and its angle
	    set vcw($t) $vik;
	    set ang($t) [format {%.2f} [expr 180 * [vangle $vij $vik] / 3.14159265359]];
	    # step to next tile
	    incr t;
	}
	# follow tiles around the vertex clockwise
	set inds {};
	set n 0;
	for {set last 0} {1} {set last $new} {
	    # accumulate the tile indexes
	    lappend inds $last;

	    # find the clockwise edge of the tile
	    set v $vcw($last);

	    #puts "$last $v $edge($v)"

	    # test for incomplete vertex, ie on edge of tiling
	    if {[llength $edge($v)] != 2} {
		unset inds;
		break;
	    }

	    # determine which of the tile indexes is new
	    foreach new $edge($v) {
		if {$new != $last} {
		    break;
		}
	    }

	    # see if we are finished, ie back to the start
	    if {$new == [lindex $inds 0]} {
		break;
	    }
	    # look out for endless loops
	    if {[incr n] > 30} {
		puts "endless loop: $inds\n[join $vertices($vertex) \n]";
		unset inds;
		break;
	    }
	}
	# test for complete vertex
	if { ! [info exists inds]} {
	    continue;
	}
	# build a descriptor
	set key {};
	set tiles {};
	foreach ix $inds {
	    pset vij vik tile [lindex $vertices($vertex) $ix];
	    lappend key $ang($ix)/[lindex $tile 0];
	    lappend tiles $tile;
	}
	set i [vertex-atlas-choose-key $key]
	set key [concat [lrange $key $i end] [lrange $key 0 [expr $i-1]]];
	set tiles [concat [lrange $tiles $i end] [lrange $tiles 0 [expr $i-1]]];
	if { ! [info exists atlas($key)]} {
	    set atlas($key) {};
	    lappend tilings [list $key $tiles];
	    #puts "installed $key [join $tiles \n]"
	}
    }
    return $tilings;
}

proc vertex-atlas-choose-key {key} {
    lappend list $key;
    for {set i 1} {$i < [llength $key]} {incr i} {
	lappend list [concat [lrange $key $i end] [lrange $key 0 [expr $i-1]]];
    }
    set sort [lsort $list];
    set i1 [lsearch $list [lindex $sort 0]];
    set i2 0;
    foreach item $list {
	if {"$item" == "[lindex $sort 0]"} {
	    break;
	}
	incr i2;
    }
    if {$i2 != $i1} {
	puts "lsearch error";
    }
    return $i1;
}

