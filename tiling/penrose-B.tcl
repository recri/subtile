#
# B triangle tilings - dissection of rhombs, dissection or annealing of A triangles.
#
namespace eval ::penrose-B:: {
    set pt [expr (1/$Tau)/(1+1/$Tau)];
    set pT [expr 1/(1+$Tau)];
    set pT2 [expr 1/($Tau*$Tau)];
    set tL [make-tile-from-type-and-vertices penrose-B-tL\
                      [vmake 0 $Tau*sin(2*$Pi/5)]\
                      [vmake 1 $Tau*sin(2*$Pi/5)]\
                      [vmake 0.5 0]]
    set tR [make-tile-from-type-and-vertices penrose-B-tR\
                      [vmake 1 $Tau*sin(2*$Pi/5)]\
                      [vmake 0 $Tau*sin(2*$Pi/5)]\
                      [vmake 0.5 2*$Tau*sin(2*$Pi/5)]]
    set TL [make-tile-from-type-and-vertices penrose-B-TL\
                      [vmake 0 $Tau*sin($Pi/5)]\
                      [vmake $Tau+1 $Tau*sin($Pi/5)]\
                      [vmake ($Tau+1)/2 0]]
    set TR [make-tile-from-type-and-vertices penrose-B-TR\
                      [vmake $Tau+1 $Tau*sin($Pi/5)]\
                      [vmake 0 $Tau*sin($Pi/5)]\
                      [vmake ($Tau+1)/2 2*$Tau*sin($Pi/5)]]
    set edgematch {
        TL-0 {TR-0}
        TL-1 {TR-2 tR-2}
        TL-2 {TR-1 tL-2}
        TR-0 {TL-0}
        TR-1 {TL-2 tR-1}
        TR-2 {TL-1 tL-1}
        tL-0 {tR-0}
        tL-1 {TR-2 tR-2}
        tL-2 {TL-2}
        tR-0 {tL-0}
        tR-1 {TR-1}
        tR-2 {TL-1 tL-1}
    }
    set vmatch {
        TL {
            {{TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 TR-1} {TR-0 tL-1 tR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 tL-2 TR-2}}
            {{TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 tL-2 tR-2 TR-1} {TR-0 TL-1 TR-0 TL-1 TR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 tL-2 TR-2}}
            {{TR-1 TL-0 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 TR-1} {TR-0 tL-1 tR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 tL-2 TR-2}}
            {{TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 TR-1 TL-0 TR-1} {TR-0 tL-1 tR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 tL-2 TR-2}}
            {{TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 tL-2 tR-2 TR-1} {TR-0 TL-1 TR-0 TL-1 TR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 tL-2 TR-2}}
            {{tL-2 TR-2 TL-2 tR-2 TR-1} {TR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0} {TR-2 tR-1 tL-0}}
            {{tL-2 TR-2 TL-2 tR-2 TR-1} {TR-0 TL-1 TR-0 tL-1 tR-0 TL-1 TR-0} {TR-2 tR-1 tL-0}}
            {{tL-2 tR-2 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 TR-1} {TR-0 tL-1 tR-0 TL-1 TR-0 TL-1 TR-0} {TR-2 tR-1 tL-0}}
            {{tL-2 tR-2 TR-1 TL-0 TR-1 TL-0 tL-2 tR-2 TR-1} {TR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0} {TR-2 tR-1 tL-0}}
            {{tL-2 tR-2 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 TR-1} {TR-0 tL-1 tR-0 TL-1 TR-0 TL-1 TR-0} {TR-2 tR-1 tL-0}}
        }
        TR {
            {{TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 TL-1} {TL-0 tL-2 TR-2 TL-2 tR-2} {tR-1 tL-0 TL-2}}
            {{TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 TL-1} {TL-0 tL-2 tR-2 TR-1 TL-0 TR-1 TL-0 tL-2 tR-2} {tR-1 tL-0 TL-2}}
            {{TL-1 TR-0 TL-1 TR-0 tL-1 tR-0 TL-1} {TL-0 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 tL-2 tR-2} {tR-1 tL-0 TL-2}}
            {{TL-1 TR-0 TL-1 TR-0 tL-1 tR-0 TL-1} {TL-0 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 tL-2 tR-2} {tR-1 tL-0 TL-2}}
            {{TL-1 TR-0 tL-1 tR-0 TL-1 TR-0 TL-1} {TL-0 tL-2 TR-2 TL-2 tR-2} {tR-1 tL-0 TL-2}}
            {{tL-1 tR-0 TL-1 TR-0 TL-1 TR-0 TL-1} {TL-0 tL-2 tR-2 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0} {TL-2 tR-2 TR-1 TL-0 tL-2}}
            {{tL-1 tR-0 TL-1 TR-0 TL-1 TR-0 TL-1} {TL-0 tL-2 tR-2 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0} {TL-2 tR-2 TR-1 TL-0 tL-2}}
            {{tL-1 tR-0 tL-1 tR-0 TL-1} {TL-0 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0} {TL-2 tR-2 TR-1 TL-0 tL-2}}
            {{tL-1 tR-0 tL-1 tR-0 TL-1} {TL-0 TR-1 TL-0 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0} {TL-2 tR-2 TR-1 TL-0 tL-2}}
            {{tL-1 tR-0 tL-1 tR-0 TL-1} {TL-0 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 TR-1 TL-0} {TL-2 tR-2 TR-1 TL-0 tL-2}}
        }
        tL {
            {{TL-2 TR-2 tR-1} {tR-0 TL-1 TR-0 TL-1 TR-0 TL-1 TR-0} {TR-2 TL-2 tR-2 TR-1 TL-0}}
            {{TL-2 TR-2 tR-1} {tR-0 TL-1 TR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0}}
            {{TL-2 TR-2 tR-1} {tR-0 TL-1 TR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0}}
            {{TL-2 TR-2 tR-1} {tR-0 TL-1 TR-0 tL-1 tR-0} {tR-2 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 TR-1 TL-0}}
            {{TL-2 TR-2 tR-1} {tR-0 tL-1 tR-0 TL-1 TR-0} {TR-2 TL-2 tR-2 TR-1 TL-0}}
        }
        tR {
            {{TL-1 TR-0 TL-1 TR-0 TL-1 TR-0 tL-1} {tL-0 TL-2 TR-2} {TR-1 TL-0 tL-2 TR-2 TL-2}}
            {{TL-1 TR-0 tL-1 tR-0 tL-1} {tL-0 TL-2 TR-2} {TR-1 TL-0 tL-2 TR-2 TL-2}}
            {{tL-1 tR-0 TL-1 TR-0 tL-1} {tL-0 TL-2 TR-2} {TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 TR-1 TL-0 tL-2}}
            {{tL-1 tR-0 TL-1 TR-0 tL-1} {tL-0 TL-2 TR-2} {TR-1 TL-0 TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 tL-2}}
            {{tL-1 tR-0 TL-1 TR-0 tL-1} {tL-0 TL-2 TR-2} {TR-1 TL-0 tL-2 tR-2 TR-1 TL-0 TR-1 TL-0 tL-2}}
        }
    }
}

define-tile penrose-B-tL tL ${::penrose-B::tL} 3
define-tile penrose-B-tR tR ${::penrose-B::tR} 3
define-tile penrose-B-TL TL ${::penrose-B::TL} 3
define-tile penrose-B-TR TR ${::penrose-B::TR} 3

proc penrose-B-edgematch {} {
    global ::penrose-B::edgematch
    return ${::penrose-B::edgematch}
}

proc penrose-B-vertex-matching-atlas {} {
    global ::penrose-B::vmatch
    return ${::penrose-B::vmatch}
}

set subtile(penrose-B-ops-menu) \
    [list \
         {{About Penrose Tilings} penrose-about} \
         {{Anneal to rhombs} penrose-do-B-anneal-to-R} \
         {{Dissect to A triangles} penrose-do-B-dissect-to-A} \
         {{Anneal to A triangles} penrose-do-B-anneal-to-A} \
        ]

set subtile(penrose-B-start-menu) \
    [list \
         [list {Small B Left} [penrose-B-tL tiling]] \
         [list {Small B Right} [penrose-B-tR tiling]] \
         [list {Large B Left} [penrose-B-TL tiling]] \
         [list {Large B Right} [penrose-B-TR tiling]] \
        ]

proc penrose-do-B-anneal-to-R {tiles partials} {
    return [list penrose-R [penrose-B-anneal-to-R $tiles $partials]];
}

proc penrose-do-B-dissect-to-A {tiles partials} {
    return [list penrose-A [penrose-B-dissect-to-A $tiles $partials]];
}

proc penrose-do-B-anneal-to-A {tiles partials} {
    return [list penrose-A [penrose-B-anneal-to-A $tiles $partials]];
}

proc penrose-B-make {tiles divide partials} {
    if {$divide == 0} {
        return [list penrose-B $tiles];
    } else {
        return [list penrose-B [penrose-A-dissect-to-B [penrose-B-dissect-to-A $tiles $partials] $partials]];
    }
}
    
#
# anneal a list of penrose-B tiles to a list of penrose-R tiles
#
proc penrose-B-anneal-to-R {tiles partials} {
    set newt {};
    foreach t1 $tiles {
        pset type a b c $t1
        switch -exact $type {
            penrose-B-tL {
                set edge [edge-hash $a $b]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-R-r make $y $z $b $c];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-B-tR {
                set edge [edge-hash $a $b]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-R-r make $b $c $y $z];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-B-TL {
                set edge [edge-hash $a $b]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-R-R make $y $z $b $c];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-B-TR {
                set edge [edge-hash $a $b]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-R-R make $b $c $y $z];
                } else {
                    set t($edge) $t1;
                }
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    if {$partials} {
        foreach edge [array names t] {
            pset type a b c $t($edge)
            switch -exact $type {
                penrose-B-tL {
                    # reflect c across a-b
                    lappend newt [penrose-R-r make $a [vreflect [vreflect-make $a $b] $c] $b $c];
                }
                penrose-B-tR {
                    # reflect c across a-b
                    lappend newt [penrose-R-r make $b $c $a [vreflect [vreflect-make $a $b] $c]];
                }
                penrose-B-TL {
                    # reflect c across a-b
                    lappend newt [penrose-R-R make $a [vreflect [vreflect-make $a $b] $c] $b $c];
                }
                penrose-B-TR {
                    # reflect c across a-b
                    lappend newt [penrose-R-R make $b $c $a [vreflect [vreflect-make $a $b] $c]];
                }
                default {
                    error "found tile of type $type";
                }
            }
        }
    }
    return $newt;
}

#
# dissect a list of penrose-B tiles to a list of penrose-A tiles
#
proc penrose-B-dissect-to-A {tiles partials} {
    upvar \#0 ::penrose-B::pT pT;
    set newt {};
    foreach tile $tiles {
        pset type a b c $tile
        switch -exact $type {
            penrose-B-tL {
                lappend newt [penrose-A-TL make $a $b $c];
            }
            penrose-B-tR {
                lappend newt [penrose-A-TR make $a $b $c];
            }
            penrose-B-TL {
                set d [vadd $b [vscale $pT [vsub $a $b]]];
                lappend newt [penrose-A-TR make $d $c $a] [penrose-A-tL make $b $c $d];
            }
            penrose-B-TR {
                set d [vadd $a [vscale $pT [vsub $b $a]]];
                lappend newt [penrose-A-TL make $c $d $b] [penrose-A-tR make $c $a $d];
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    return $newt;
}

#
# anneal a list of penrose-B tiles into a list of penrose-A tiles
#
proc penrose-B-anneal-to-A {tiles partials} {
    set newt {};
    foreach t1 $tiles {
        pset type a b c $t1
        switch -exact $type {
            penrose-B-tL {
                set edge [edge-hash $a $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-A-TL make $b $c $y];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-B-TL {
                set edge [edge-hash $a $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    if {[string equal $type penrose-B-TR]} {
                        lappend newt [penrose-A-tR make $x $y $z] [penrose-A-tL make $a $b $c]
                    } elseif {[string equal $type penrose-B-tL]} {
                        lappend newt [penrose-A-TL make $y $z $b];
                    } else {
                        error "penrose-B-anneal-to-A found $t($edge)"
                    }
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-B-tR {
                set edge [edge-hash $b $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-A-TR make $c $a $x];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-B-TR {
                set edge [edge-hash $b $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    if {[string equal $type penrose-B-TL]} {
                        lappend newt [penrose-A-tL make $x $y $z] [penrose-A-tR make $a $b $c]
                    } elseif {[string equal $type penrose-B-tR]} {
                        lappend newt [penrose-A-TR make $z $x $a];
                    } else {
                        error "penrose-B-anneal-to-A found $t($edge)"
                    }
                } else {
                    set t($edge) $t1;
                }
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    foreach edge [array names t] {
        pset type a b c $t($edge)
        switch -exact $type {
            penrose-B-TR {
                lappend newt [penrose-A-tR make $a $b $c];
            }
            penrose-B-TL {
                lappend newt [penrose-A-tL make $a $b $c];
            }
            default {
                puts stderr "leftover tile: $t1";
            }
        }
    }
    return $newt;
}
