#
# define a collection of tilings
# it is simply a list of tilings
#

#
# rescale a tile collection
#
proc collection-rescale {s collection} {
    set newc {};
    foreach item $collection {
        lappend newc [list [lindex $item 0] [tiling-rescale $s [lindex $item 1]]];
    }
    return $newc;
}

#
# recenter a collection of tilings
#
proc collection-recenter {collection} {
    set newc {};
    foreach item $collection {
        lappend newc [list [lindex $item 0] [tiling-recenter [lindex $item 1]]];
    }
    return $newc;
}

#
# bound a tile collection
#
proc collection-bound {collection} {
    pset xmin ymin xmax ymax [tiling-bound [lindex [lindex $collection 0] 1]]
    foreach item [lrange $collection 1 end] {
        pset x0 y0 x1 y1 [tiling-bound [lindex $item 1]];
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
# dimension a tile collection
#
proc collection-dimension {collection} {
    pset dx dy [tiling-dimension [lindex [lindex $collection 0] 1]]
    foreach item [lrange $collection 1 end] {
        pset dx1 dy1 [tiling-dimension [lindex $item 1]];
        if {$dx < $dx1} {
            set dx $dx1;
        }
        if {$dy < $dy1} {
            set dy $dy1;
        }
    }
    return [list $dx $dy];
}

#
# normalize a tiling collection.
# the tilings are rescaled by a common factor such that the largest member
# fills the unit square, and all are centered in the unit square.
#
proc collection-normalize {collection} {
    pset dx dy [collection-dimension $collection];
    if {$dx > $dy} {
        set s [expr 0.9/$dx]
    } else {
        set s [expr 0.9/$dy]
    }
    return [collection-recenter [collection-rescale $s $collection]];
}

