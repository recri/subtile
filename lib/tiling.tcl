#
# define a tiling, both as an abstract set of rules
# and as a collection of concrete tiles
#

#
# rescale a tiling
#
proc tiling-rescale {s tiles} {
    set newts {}
    foreach tile $tiles {
        lappend newts [tile-rescale $s $tile];
    }
    return $newts;
}

#
# recenter a tiling
#
proc tiling-recenter {tiles} {
    pset xmin ymin xmax ymax [tiling-bound $tiles];
    set dx [expr -$xmin+(1-($xmax-$xmin))/2];
    set dy [expr -$ymin+(1-($ymax-$ymin))/2];
    set newts {};
    foreach tile $tiles {
        lappend newts [tile-recenter $dx $dy $tile];
    }
    return $newts;
}

#
# bound a tiling
#
proc tiling-bound {tiles} {
    pset xmin ymin xmax ymax [tile-bound [lindex $tiles 0]];
    foreach tile [lrange $tiles 1 end] {
        pset x0 y0 x1 y1 [tile-bound $tile];
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
# dimension a tiling
#
proc tiling-dimension {tiles} {
    pset x0 y0 x1 y1 [tiling-bound $tiles];
    return [list [expr $x1-$x0] [expr $y1-$y0]];
}

#
# normalize a tiling
# rescale to fill unit square and center in square
#
proc tiling-normalize {tiles} {
    pset dx dy [tiling-dimension $tiles]
    if {$dx > $dy} {
        set s [expr 0.9/$dx]
    } else {
        set s [expr 0.9/$dy]
    }
    return [tiling-recenter [tiling-rescale $s $tiles]]
}

