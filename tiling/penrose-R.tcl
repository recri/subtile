#
# rhomb tilings
#
namespace eval ::penrose-R:: {
    set r [make-tile-from-type-and-vertices penrose-R-r\
                     [vmake 0 $Tau*sin(2*$Pi/5)] \
                     [vmake 0.5 2*$Tau*sin(2*$Pi/5)] \
                     [vmake 1 $Tau*sin(2*$Pi/5)]\
                     [vmake 0.5 0]\
                    ]
    set R [make-tile-from-type-and-vertices penrose-R-R\
                     [vmake 0 $Tau*sin($Pi/5)]\
                     [vmake ($Tau+1)/2 2*$Tau*sin($Pi/5)]\
                     [vmake $Tau+1 $Tau*sin($Pi/5)]\
                     [vmake ($Tau+1)/2 0]\
                    ]
    set edgematch {
        R-0 {R-3 r-0}
        R-1 {R-2 r-2}
        R-2 {R-1 r-1}
        R-3 {R-0 r-3}
        r-0 {R-0}
        r-1 {R-2 r-2}
        r-2 {R-1 r-1}
        r-3 {R-3}
    }
    set vmatch {
        R {
            {{R-0 R-0 R-0 R-0} {R-3 r-1 R-0 r-3} {r-2 r-2} {r-1 R-0 r-3 R-1}}
            {{R-0 R-0 R-0 r-3 r-1} {r-0 R-3} {R-2 R-2 r-2} {r-1 R-0 r-3 R-1}}
            {{R-0 R-0 r-3 r-1 R-0} {R-3 r-1 R-0 r-3} {r-2 r-2} {r-1 R-0 r-3 R-1}}
            {{R-0 r-3 r-1 R-0 R-0} {R-3 r-1 R-0 r-3} {r-2 r-2} {r-1 R-0 r-3 R-1}}
            {{R-0 r-3 r-1 R-0 r-3 r-1} {r-0 R-3} {R-2 R-2 r-2} {r-1 R-0 r-3 R-1}}
            {{r-3 R-1 R-3 r-1} {r-0 R-3} {R-2 R-2 R-2 R-2} {R-1 r-0}}
            {{r-3 R-1 R-3 r-1} {r-0 R-3} {R-2 r-2 R-2} {R-1 r-0}}
            {{r-3 r-1 R-0 R-0 R-0} {R-3 r-1 R-0 r-3} {r-2 R-2 R-2} {R-1 r-0}}
            {{r-3 r-1 R-0 R-0 r-3 r-1} {r-0 R-3} {R-2 R-2 R-2 R-2} {R-1 r-0}}
            {{r-3 r-1 R-0 r-3 r-1 R-0} {R-3 r-1 R-0 r-3} {r-2 R-2 R-2} {R-1 r-0}}
        }
        r {
            {{R-3 R-1} {R-0 R-0 R-0 R-0 r-3} {r-2 R-2} {R-1 R-3 r-1 R-0}}
            {{R-3 R-1} {R-0 R-0 r-3 r-1 R-0 r-3} {r-2 R-2} {R-1 R-3 r-1 R-0}}
            {{R-3 R-1} {R-0 r-3 R-1 R-3} {R-2 R-2 R-2} {R-1 R-3 r-1 R-0}}
            {{R-3 R-1} {R-0 r-3 R-1 R-3} {R-2 r-2} {r-1 R-0 R-0 R-0 R-0}}
            {{R-3 R-1} {R-0 r-3 R-1 R-3} {R-2 r-2} {r-1 R-0 R-0 r-3 r-1 R-0}}
            {{R-3 R-1} {R-0 r-3 R-1 R-3} {R-2 r-2} {r-1 R-0 r-3 r-1 R-0 R-0}}
            {{R-3 R-1} {R-0 r-3 r-1 R-0 R-0 r-3} {r-2 R-2} {R-1 R-3 r-1 R-0}}
        }
    }
}

define-tile penrose-R-r r ${::penrose-R::r} 2 penrose-R-decorate
define-tile penrose-R-R R ${::penrose-R::R} 2 penrose-R-decorate

proc penrose-R-edgematch {} {
    global ::penrose-R::edgematch
    return ${::penrose-R::edgematch}
}

proc penrose-R-vertex-matching-atlas {} {
    global ::penrose-R::vmatch
    return ${::penrose-R::vmatch}
}

proc penrose-R-decorate {tile w tags} {
    # the decorations are the little left/right turning arrow
    # the half arrow heads on the edges
    # and the vertex keys
    set id [tag-generate]
    set tags "$tags $id"
    set vs [tile-vertices $tile]
    set z [tile-center $tile]
    switch [tile-type $tile] {
        penrose-R-r {
            # straight arrow from vertex 0 to vertex 2
            tile-arrow $w $tags [lindex $vs 0] $z [lindex $vs 2]
            # edge matching half arrows
            # tile-edge-half-arrow $w $tags $tile f r f r
        }
        penrose-R-R {
            # straight arrow from vertex 0 to vertex 2
            tile-arrow $w $tags [lindex $vs 0] $z [lindex $vs 2]
            # edge matching half arrows 
            # tile-edge-half-arrow $w $tags $tile f r f r
        }
    }
    return $id
}

set subtile(penrose-R-ops-menu) \
    [list \
         {{About Penrose Tilings} penrose-about} \
         {{Dissect to B triangles} penrose-do-R-dissect-to-B} \
	];
set subtile(penrose-R-start-menu) \
    [list \
         [list {Large rhomb} [penrose-R-R tiling]] \
         [list {Small rhomb} [penrose-R-r tiling]] \
	];

proc penrose-do-R-dissect-to-B {tiles partials} {
    return [list penrose-B [penrose-R-dissect-to-B $tiles $partials]];
}

proc penrose-R-make {tiles divide partials} {
    if {$divide == 0} {
        return [list penrose-R $tiles];
    } else {
        return [list penrose-R \
                    [penrose-B-anneal-to-R \
                         [penrose-A-dissect-to-B \
                              [penrose-B-dissect-to-A \
                                   [penrose-R-dissect-to-B $tiles $partials] \
                                   $partials] \
                              $partials] \
                         $partials] \
                   ];
    }
}

#
# dissect a list of penrose-R tiles to a list of penrose-B tiles
#
proc penrose-R-dissect-to-B {tiles partials} {
    set newt {};
    foreach tile $tiles {
        pset type a b c d $tile
        switch -exact $type {
            penrose-R-R {
                lappend newt [penrose-B-TL make $a $c $d] [penrose-B-TR make $c $a $b];
            }
            penrose-R-r {
                lappend newt [penrose-B-tL make $a $c $d] [penrose-B-tR make $c $a $b];
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    return $newt;
}

