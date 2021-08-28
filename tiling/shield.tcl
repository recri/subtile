########################################################################
##
## shield dodecagonal tiling
##
lappend subtile(tilings) {{Dodecagaonal shield} shield}

# shield, square, and triangle
namespace eval ::shield:: {
    set shield3 [make-tile-from-type-and-vertices shield-3 {0 0} {0 1} {0.866025 0.5} ]
    set shield3l [make-tile-from-type-and-vertices shield-3l {0 0} {0 1} {0.866025 0.5} ]
    set shield3r [make-tile-from-type-and-vertices shield-3r {0 0} {0 1} {0.866025 0.5} ]
    set shield4l [make-tile-from-type-and-vertices shield-4l {0 0} {0 1} {1 1} {1 0} ]
    set shield4r [make-tile-from-type-and-vertices shield-4r {0 0} {0 1} {1 1} {1 0} ]
    set shield6l [make-tile-from-type-and-vertices shield-6l {0 1} {1 1} {1.866025 0.5} {1.366025 -0.366025} {0.5 -0.866025} {0 0} ]
    set shield6r [make-tile-from-type-and-vertices shield-6r {0 1} {1 1} {1.866025 0.5} {1.366025 -0.366025} {0.5 -0.866025} {0 0} ]
}

define-tile shield-3 3 ${::shield::shield3} 3
define-tile shield-3l 3l ${::shield::shield3l} 3
define-tile shield-3r 3r ${::shield::shield3r} 3
define-tile shield-4l 4l ${::shield::shield4l} 4
define-tile shield-4r 4r ${::shield::shield4r} 4
define-tile shield-6l 6l ${::shield::shield6l} 6
define-tile shield-6r 6r ${::shield::shield6r} 6

set subtile(shield-ops-menu) {
    {{convert to Socolar} shield-do-convert-to-socolar}
};

set subtile(shield-start-menu) \
    [list \
         [list shield-3 [shield-3 tiling]] \
         [list shield-3l [shield-3l tiling]] \
         [list shield-3r [shield-3r tiling]] \
         [list shield-4l [shield-4l tiling]] \
         [list shield-4r [shield-4r tiling]] \
         [list shield-6l [shield-6l tiling]] \
         [list shield-6r [shield-6r tiling]] \
	];

proc shield-make {tiles divide partials} {
    if {$divide == 0} {
        return [list shield $tiles];
    } else {
        return [list shield [shield-subdivide $tiles $partials]]
    }
}

proc shield-subdivide {tiles partials} {
    return [socolar-convert-to-shield [socolar-subdivide [shield-convert-to-socolar $tiles $partials] $partials] $partials]
}

proc shield-do-convert-to-socolar {tiles partial} {
    return [list socolar [shield-convert-to-socolar $tiles $partial]]
}

proc shield-convert-to-socolar {tiles partial} {
    #
    # The hexagons punch out the midpoints,
    # the squares punch out the midpoints,
    # and the back to back triangles punch out the midpoints.
    #
    # The center of an equilateral triangle is found by
    # r sin(30) from the midpoint of an edge, where r is
    # from the triangle vertex to the triangle center.
    # Find r by r cos(30) = 0.5, so r = 0.5/cos(30), and
    # the scale factor applied to the edge length is 0.5 tan(30).
    #
    # the four triangles over the vertices of each rhomb need to be
    # encoded on conversion to shield so we can determine the proper
    # orientation and handedness for the rhombs, or we can use the
    # same edge matching hole filler that the wheel tiling needs.
    #
    set s [expr {0.5*tan([radians 30])}]
    set r [vrotate-make [radians 90]]
    set newt {}
    set ntri 0
    foreach tile $tiles {
        switch [tile-type $tile] {
            shield-3 -
            shield-3l -
            shield-3r {
                # need four triangles to make a rhomb, so save them
                set vs [tile-vertices $tile]
                foreach u $vs v [list-roll-left $vs 1] {
                    lappend vertex([vertex-hash $u]) $tile
                    lappend edge([edge-hash $u $v]) $tile
                }
                incr ntri
            }
            shield-4l -
            shield-4r {
                pset type a b c d $tile
                set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                set bc [vadd [vmidpoint $b $c] [vscale $s [vrotate $r [vsub $c $b]]]]
                set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                set da [vadd [vmidpoint $d $a] [vscale $s [vrotate $r [vsub $a $d]]]]
                lappend newt [socolar-s[string index $type end] make $da $ab $bc $cd]
            }
            shield-6l -
            shield-6r {
                pset type a b c d e f $tile
                set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                set bc [vadd [vmidpoint $b $c] [vscale $s [vrotate $r [vsub $c $b]]]]
                set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                set de [vadd [vmidpoint $d $e] [vscale $s [vrotate $r [vsub $e $d]]]]
                set ef [vadd [vmidpoint $e $f] [vscale $s [vrotate $r [vsub $f $e]]]]
                set fa [vadd [vmidpoint $f $a] [vscale $s [vrotate $r [vsub $a $f]]]]
                lappend newt [socolar-h[string index $type end] make $fa $ab $bc $cd $de $ef]
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    # puts "$ntri triangles, [array size edge] edges, [array size vertex] vertices"
    foreach e [array names edge] {
        if {[llength $edge($e)] == 1} {
            continue
        } elseif {[llength $edge($e)] != 2} {
            error "more than two triangles on an edge?"
        }
        #
        pset t1 t3 $edge($e)
        if {[string equal [tile-type $t1] shield-3]} {
            pset t3 t1 [list $t1 $t3]
        }
        #
        pset type a b c $t1
        if {[llength $edge([edge-hash $b $c])] == 2} {
            pset type b c a $t1
        } elseif {[llength $edge([edge-hash $c $a])] == 2} {
            pset type c a b $t1
        } elseif {[llength $edge([edge-hash $a $b])] != 2} {
            error "none of t1's edges have 2 tiles?" 
        }
        #
        if {[llength $vertex([vertex-hash $a])] != 3 || [llength $vertex([vertex-hash $b])] != 3} {
            if {$partials == 0} { continue }
        }
        #
        foreach t2 $vertex([vertex-hash $a]) {
            if { ! [string equal $t2 $t1] && ! [string equal $t2 $t3]} { break }
            set t2 {}
        }
        foreach t4 $vertex([vertex-hash $b]) {
            if { ! [string equal $t4 $t1] && ! [string equal $t4 $t3]} { break }
            set t4 {}
        }
        # fix the partials
        set a [tile-center $t1]
        set c [tile-center $t3]
        set z [vmidpoint $a $c]
        if {[string length $t2] != 0} {
            set b [tile-center $t2]
        } elseif {[string length $t4] != 0} {
            set b [vadd $z [vsub $z [tile-center $t4]]]
        } else {
            continue;                   # FIX.ME - synthesize rhomb from two vertices
        }
        if {[string length $t4] != 0} {
            set d [tile-center $t4]
        } else {
            set d [vadd $z [vsub $z $b]]
        }
        #
        lappend newt [socolar-r[string index $type end] make $a $b $c $d]
    }
    return $newt;
}


