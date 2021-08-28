########################################################################
##
## dodecagonal wheel tiling
##
lappend subtile(tilings) {{Dodecagonal wheel} wheel}

namespace eval ::wheel:: {
    set wheel8l [make-tile-from-type-and-vertices wheel-8l \
                    {0 0} {0 1} {1 1} {1.5 0.133974} \
                    {0.633974 -0.366025} {0.633974 -1.366025} {-0.366025 -1.366025} {-0.866025 -0.5} ]
    set wheel8r [make-tile-from-type-and-vertices wheel-8r \
                    {0 0} {0 1} {1 1} {1.5 0.133974} \
                    {0.633974 -0.366025} {0.633974 -1.366025} {-0.366025 -1.366025} {-0.866025 -0.5} ]
    set wheel12l [make-tile-from-type-and-vertices wheel-12l \
                     {-1 0} {0 0} {0 1} {0.866025 1.5} {1.366025 0.633974} {0.866025 -0.23205} \
                     {1.73205 -0.73205} {1.73205 -1.73205} {0.73205 -1.73205} {0.23205 -0.866025} \
                     {-0.633974 -1.366025} {-1.5 -0.866025} ]
    set wheel12r [make-tile-from-type-and-vertices wheel-12r \
                     {-1 0} {0 0} {0 1} {0.866025 1.5} {1.366025 0.633974} {0.866025 -0.23205} \
                     {1.73205 -0.73205} {1.73205 -1.73205} {0.73205 -1.73205} {0.23205 -0.866025} \
                     {-0.633974 -1.366025} {-1.5 -0.866025} ]
}

define-tile wheel-8l 8l ${::wheel::wheel8l} 8
define-tile wheel-8r 8r ${::wheel::wheel8r} 8
define-tile wheel-12l 12l ${::wheel::wheel12l} 12
define-tile wheel-12r 12r ${::wheel::wheel12r} 12

set subtile(wheel-ops-menu) {
    {{convert to Socolar} wheel-do-convert-to-socolar}
};
set subtile(wheel-start-menu) \
    [list \
         [list wheel-8l [wheel-8l tiling]] \
         [list wheel-8r [wheel-8r tiling]] \
         [list wheel-12l [wheel-12l tiling]] \
         [list wheel-12r [wheel-12r tiling]] \
        ];

proc wheel-make {tiles divide partials} {
    if {$divide == 0} {
        return [list wheel $tiles];
    } else {
        return [list wheel [wheel-subdivide $tiles $partials]]
    }
}

proc wheel-subdivide {tiles partials} {
    return [socolar-convert-to-wheel [socolar-subdivide [wheel-convert-to-socolar $tiles $partials] $partials] $partials]
}

proc wheel-do-convert-to-socolar {tiles partial} {
    return [list socolar [wheel-convert-to-socolar $tiles $partial]]
}

proc wheel-convert-to-socolar {tiles partial} {
    set newt {};
    foreach t1 $tiles {
        switch [tile-type $t1] {
            wheel-8l -
            wheel-8r {
                pset type a b c d e f g h $t1
                # regenerate the appropriate rhomb
                lappend newt [socolar-r[string index $type end] make $a $c $e $g]
            }
            wheel-12l -
            wheel-12r {
                pset type a b c d e f g h i j k l $t1
                # regenerate the appropriate hexagon
                lappend newt [socolar-h[string index $type end] make $a $c $e $g $i $k]
            }
            default {
                error "found tile of type $type";
            }
        }    
        # now figure out where the squares go and what their orientation is
    }
    return $newt;
}

