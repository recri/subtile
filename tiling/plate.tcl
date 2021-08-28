########################################################################
##
## dodecagonal plate tiling
##
lappend subtile(tilings) {{Dodecagonal plate} plate}

namespace eval ::plate:: {
    set plate4l [make-tile-from-type-and-vertices plate-4l {0 1} {0.866025 1.5} {0.866025 0.5} {0 0} ]
    set plate8l [make-tile-from-type-and-vertices plate-8l {0 1} {0.866025 1.5} {1.866025 1.5} \
                    {2.366025 0.633974} {2.366025 -0.366025} {1.5 -0.866025} {0.5 -0.866025} {0 0}]
    set plate12l [make-tile-from-type-and-vertices plate-12l {0 1} {0.866025 1.5} {1.866025 1.5} \
                     {2.366025 0.633974} {3.23205 0.133974} {3.23205 -0.866025} {2.73205 -1.73205} \
                     {1.73205 -1.73205} {0.866025 -2.23205} {0 -1.73205} {-0.5 -0.866025} {0 0} ]
    set plate4r [make-tile-from-type-and-vertices plate-4r {0 1} {0.866025 1.5} {0.866025 0.5} {0 0} ]
    set plate8r [make-tile-from-type-and-vertices plate-8r {0 1} {0.866025 1.5} {1.866025 1.5} \
                    {2.366025 0.633974} {2.366025 -0.366025} {1.5 -0.866025} {0.5 -0.866025} {0 0}]
    set plate12r [make-tile-from-type-and-vertices plate-12r {0 1} {0.866025 1.5} {1.866025 1.5} \
                     {2.366025 0.633974} {3.23205 0.133974} {3.23205 -0.866025} {2.73205 -1.73205} \
                     {1.73205 -1.73205} {0.866025 -2.23205} {0 -1.73205} {-0.5 -0.866025} {0 0} ]
}

define-tile plate-4l 4l ${::plate::plate4l} 4
define-tile plate-8l 8l ${::plate::plate8l} 8
define-tile plate-12l 12l ${::plate::plate12l} 12
define-tile plate-4r 4r ${::plate::plate4r} 4
define-tile plate-8r 8r ${::plate::plate8r} 8
define-tile plate-12r 12r ${::plate::plate12r} 12

set subtile(plate-ops-menu) {
    {{convert to Socolar} plate-do-convert-to-socolar}
};

set subtile(plate-start-menu) \
    [list \
         [list plate4l [plate-4l tiling]] \
         [list plate4r [plate-4r tiling]] \
         [list plate8l [plate-8l tiling]] \
         [list plate8r [plate-8r tiling]] \
         [list plate12l [plate-12l tiling]] \
         [list plate12r [plate-12r tiling]] \
	];

proc plate-make {tiles divide partials} {
    if {$divide == 0} {
        return [list plate $tiles];
    } else {
        return [list plate [plate-subdivide $tiles $partials]]
    }
}

proc plate-subdivide {tiles partials} {
    return [socolar-convert-to-plate [socolar-subdivide [plate-convert-to-socolar $tiles $partials] $partials] $partials]
}

proc plate-do-convert-to-socolar {tiles partial} {
    return [list socolar [plate-convert-to-socolar $tiles $partial]]
}

proc plate-convert-to-socolar {tiles partial} {
    set newt {}
    set alpha [radians 15];         # half interior angle in the pointy end of the socolar rhomb
    set rzb [expr {cos($alpha)}];   # center to vertex b in unit edge socolar rhomb
    set rbbp [expr {0.5/cos($alpha)}]; # plate vertex b to socolar vertex b
    set rzbp [expr {$rzb-$rbbp}];   # center to new punched in vertex b
    set rhomb [expr {$rzb/$rzbp}];  # punch out scale for long point of rhombs
    foreach tile $tiles {
        switch [tile-type $tile] {
            plate-4l -
            plate-4r {
                # extend the long points of the rhombs
                pset type a b c d $tile
                # center of rhomb
                set z [vmidpoint $a $c]
                # new b and d vertex
                set b [vadd $z [vscale $rhomb [vsub $b $z]]]
                set d [vadd $z [vscale $rhomb [vsub $d $z]]]
                lappend newt [socolar-r[string index $type end] make $a $b $c $d]
            }
            plate-8l -
            plate-8r {
                # discard the punched out midpoints of the edges
                pset type a ab b bc c cd d da $tile
                lappend newt [socolar-s[string index $type end] make $a $b $c $d]
            }
            plate-12l -
            plate-12r {
                # discard the punched in/out midpoints of the edges
                pset type a ab b bc c cd d de e ef f fa $tile
                lappend newt [socolar-h[string index $type end] make $a $b $c $d $e $f]
            }
        }
    }
    return $newt
}

