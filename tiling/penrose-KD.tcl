#
# kite and dart tilings
#
namespace eval ::penrose-KD:: {
    set a [vmake 0 $Tau*sin($Pi/5)];
    set b [vmake ($Tau+1)/2 0];
    set c [vmake $Tau+1 $Tau*sin($Pi/5)];
    set d [vmake ($Tau+1)/2 2*$Tau*sin($Pi/5)];
    set e [vadd $a [vscale $Tau/($Tau+1) [vsub $c $a]]];
    
    set K [make-tile-from-type-and-vertices penrose-KD-K $d $e $b $a]
    set D [make-tile-from-type-and-vertices penrose-KD-D $d $c $b $e]
    set edgematch {
        D-0 {D-1 K-2}
        D-1 {D-0 K-3}
        D-2 {K-0}
        D-3 {K-1}
        K-0 {D-2 K-1}
        K-1 {D-3 K-0}
        K-2 {D-0 K-3}
        K-3 {D-1 K-2}
    }
    set vmatch {
        D {
            {{K-1 D-2 K-3 K-3} {K-2 K-0 D-1 D-1} {D-0 K-1 K-1} {K-0 K-2}}
            {{K-1 D-2 K-3 K-3} {K-2 K-0 K-2 K-0} {K-3 K-3 D-0 K-1} {K-0 K-2}}
            {{K-1 K-1 D-2} {D-1 D-1 D-1 D-1} {D-0 K-1 K-1} {K-0 K-2}}
            {{K-1 K-1 D-2} {D-1 D-1 K-2 K-0} {K-3 K-3 D-0 K-1} {K-0 K-2}}
            {{K-1 K-1 D-2} {D-1 K-2 K-0 D-1} {D-0 K-1 K-1} {K-0 K-2}}
        }
        K {
            {{D-1 D-1 D-1 K-2} {K-1 D-2 D-0} {D-3 K-0} {K-3 D-0 K-1 D-2}}
            {{D-1 K-2 K-0 K-2} {K-1 D-2 D-0} {D-3 K-0} {K-3 D-0 K-1 D-2}}
            {{K-2 D-3} {D-2 D-0 K-1} {K-0 D-1 D-1 D-1} {D-0 K-1 D-2 K-3}}
            {{K-2 D-3} {D-2 D-0 K-1} {K-0 D-1 K-2 K-0} {K-3 K-3 K-3 K-3}}
            {{K-2 D-3} {D-2 D-0 K-1} {K-0 K-2 K-0 D-1} {D-0 K-1 D-2 K-3}}
            {{K-2 D-3} {D-2 K-3 K-3 D-0} {D-3 K-0} {K-3 K-3 K-3 K-3}}
            {{K-2 K-0 D-1 K-2} {K-1 D-2 D-0} {D-3 K-0} {K-3 K-3 K-3 K-3}}
        }
    } 
}

define-tile penrose-KD-K K ${::penrose-KD::K} 4
define-tile penrose-KD-D D ${::penrose-KD::D} 4

proc penrose-KD-edgematch {} {
    global ::penrose-KD::edgematch
    return ${::penrose-KD::edgematch}
}

proc penrose-KD-vertex-matching-atlas {} {
    global ::penrose-KD::vmatch
    return ${::penrose-KD::vmatch}
}

set subtile(penrose-KD-ops-menu) \
    [list \
         {{About Penrose Tilings} penrose-about} \
         {{Dissect to A triangles} penrose-do-KD-dissect-to-A} \
        ];
set subtile(penrose-KD-start-menu) \
    [list \
         [list Kite [penrose-KD-K tiling]]\
         [list Dart [penrose-KD-D tiling]] \
        ];

proc penrose-do-KD-dissect-to-A {tiles partials} {
    return [list penrose-A [penrose-KD-dissect-to-A $tiles $partials]];
}

proc penrose-KD-make {tiles divide partials} {
    if {$divide == 0} {
        return [list penrose-KD $tiles];
    } else {
        return [list penrose-KD \
                    [penrose-A-anneal-to-KD \
                         [penrose-B-dissect-to-A \
                              [penrose-A-dissect-to-B \
                                   [penrose-KD-dissect-to-A $tiles $partials] \
                                   $partials] \
                              $partials] \
                         $partials] \
                   ];
    }
}

#
# dissect a list of penrose-KD tiles into a list of penrose-A tiles
#
proc penrose-KD-dissect-to-A {tiles partials} {
    set newt {};
    foreach tile $tiles {
        pset type a b c d $tile
        switch -exact $type {
            penrose-KD-K {
                lappend newt [penrose-A-TL make $b $c $d] [penrose-A-TR make $a $b $d];
            }
            penrose-KD-D {
                lappend newt [penrose-A-tL make $b $c $d] [penrose-A-tR make $a $b $d];
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    return $newt;
}
