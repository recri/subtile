#
# A triangle tilings - dissection of kite and dart
#
namespace eval ::penrose-A:: {
    set pt [expr (1/$Tau)/(1+1/$Tau)];
    set pT [expr 1/(1+$Tau)];
    set pT2 [expr 1/($Tau*$Tau)];

    set TL [make-tile-from-type-and-vertices penrose-A-TL\
                      [vmake 0 $Tau*sin(2*$Pi/5)]\
                      [vmake 1 $Tau*sin(2*$Pi/5)]\
                      [vmake 0.5 0]]
    set TR [make-tile-from-type-and-vertices penrose-A-TR\
                      [vmake 1 $Tau*sin(2*$Pi/5)]\
                      [vmake 0 $Tau*sin(2*$Pi/5)]\
                      [vmake 0.5 2*$Tau*sin(2*$Pi/5)]]
    set tL [make-tile-from-type-and-vertices penrose-A-tL\
                      [vmake 0 sin($Pi/5)]\
                      [vmake $Tau sin($Pi/5)]\
                      [vmake $Tau/2 0]]
    set tR [make-tile-from-type-and-vertices penrose-A-tR\
                      [vmake $Tau sin($Pi/5)]\
                      [vmake 0 sin($Pi/5)]\
                      [vmake $Tau/2 2*sin($Pi/5)]]
    set edgematch {
        TL-0 {TR-0 tR-2}
        TL-1 {TR-2 tR-0}
        TL-2 {TR-1}
        TR-0 {TL-0 tL-1}
        TR-1 {TL-2}
        TR-2 {TL-1 tL-0}
        tL-0 {TR-2 tR-0}
        tL-1 {TR-0}
        tL-2 {tR-1}
        tR-0 {TL-1 tL-0}
        tR-1 {tL-2}
        tR-2 {TL-0}
    }
    set vmatch {
        TL {
            {{TR-1 TL-0 TR-1 tL-1 tR-0} {tR-2 tL-2 TR-0} {TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2}}
            {{TR-1 TL-0 TR-1 tL-1 tR-0} {tR-2 tL-2 TR-0} {TR-2 TL-2 tR-0 TL-0 TR-1 tL-1 TR-2}}
            {{TR-1 tL-1 TR-2 TL-2 TR-2 TL-2 tR-0} {tR-2 tL-2 TR-0} {TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2}}
            {{TR-1 tL-1 tR-0 TL-0 TR-1} {TR-0 TL-1 TR-0 tL-0 tR-1} {tR-0 TL-0 TR-1 tL-1 TR-2 TL-2 TR-2}}
            {{TR-1 tL-1 tR-0 TL-0 TR-1} {TR-0 tL-0 tR-1 TL-1 TR-0} {TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2}}
            {{TR-1 tL-1 tR-0 TL-0 TR-1} {TR-0 tL-0 tR-1 tL-0 tR-1 tL-0 tR-1} {tR-0 TL-0 TR-1 tL-1 TR-2 TL-2 TR-2}}
        }
        TR {
            {{TL-1 TR-0 tL-0 tR-1 TL-1} {TL-0 TR-1 tL-1 tR-0 TL-0} {TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2}}
            {{TL-1 tR-2 tL-2} {tL-1 TR-2 TL-2 TR-2 TL-2 tR-0 TL-0} {TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2}}
            {{TL-1 tR-2 tL-2} {tL-1 tR-0 TL-0 TR-1 TL-0} {TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2 TR-2 TL-2}}
            {{TL-1 tR-2 tL-2} {tL-1 tR-0 TL-0 TR-1 TL-0} {TL-2 tR-0 TL-0 TR-1 tL-1 TR-2 TL-2}}
            {{tL-0 tR-1 TL-1 TR-0 TL-1} {TL-0 TR-1 tL-1 tR-0 TL-0} {TL-2 TR-2 TL-2 tR-0 TL-0 TR-1 tL-1}}
            {{tL-0 tR-1 tL-0 tR-1 tL-0 tR-1 TL-1} {TL-0 TR-1 tL-1 tR-0 TL-0} {TL-2 TR-2 TL-2 tR-0 TL-0 TR-1 tL-1}}
        }
        tL {
            {{tR-1 TL-1 TR-0 TL-1 TR-0} {TR-2 TL-2 TR-2 TL-2 tR-0 TL-0 TR-1} {TR-0 TL-1 tR-2}}
            {{tR-1 TL-1 TR-0 tL-0 tR-1 tL-0 tR-1} {tR-0 TL-0 TR-1 TL-0 TR-1} {TR-0 TL-1 tR-2}}
            {{tR-1 tL-0 tR-1 TL-1 TR-0 tL-0 tR-1} {tR-0 TL-0 TR-1 TL-0 TR-1} {TR-0 TL-1 tR-2}}
            {{tR-1 tL-0 tR-1 tL-0 tR-1 TL-1 TR-0} {TR-2 TL-2 TR-2 TL-2 tR-0 TL-0 TR-1} {TR-0 TL-1 tR-2}}
            {{tR-1 tL-0 tR-1 tL-0 tR-1 tL-0 tR-1 tL-0 tR-1} {tR-0 TL-0 TR-1 TL-0 TR-1} {TR-0 TL-1 tR-2}}
        }
        tR {
            {{TL-0 TR-1 TL-0 TR-1 tL-1} {tL-0 tR-1 TL-1 TR-0 tL-0 tR-1 tL-0} {tL-2 TR-0 TL-1}}
            {{TL-0 TR-1 TL-0 TR-1 tL-1} {tL-0 tR-1 tL-0 tR-1 TL-1 TR-0 tL-0} {tL-2 TR-0 TL-1}}
            {{TL-0 TR-1 TL-0 TR-1 tL-1} {tL-0 tR-1 tL-0 tR-1 tL-0 tR-1 tL-0 tR-1 tL-0} {tL-2 TR-0 TL-1}}
            {{TL-0 TR-1 tL-1 TR-2 TL-2 TR-2 TL-2} {TL-1 TR-0 TL-1 TR-0 tL-0} {tL-2 TR-0 TL-1}}
            {{TL-0 TR-1 tL-1 TR-2 TL-2 TR-2 TL-2} {TL-1 TR-0 tL-0 tR-1 tL-0 tR-1 tL-0} {tL-2 TR-0 TL-1}}
        }
    }
}

define-tile penrose-A-tL tL ${::penrose-A::tL} 3
define-tile penrose-A-tR tR ${::penrose-A::tR} 3
define-tile penrose-A-TL TL ${::penrose-A::TL} 3
define-tile penrose-A-TR TR ${::penrose-A::TR} 3

proc penrose-A-edgematch {} {
    global ::penrose-A::edgematch
    return ${::penrose-A::edgematch}
}

proc penrose-A-vertex-matching-atlas {} {
    global ::penrose-A::vmatch
    return ${::penrose-A::vmatch}
}

set subtile(penrose-A-ops-menu) \
    [list \
         {{About Penrose Tilings} penrose-about} \
         {{Anneal to kites and darts} penrose-do-A-anneal-to-KD} \
         {{Dissect to B triangles} penrose-do-A-dissect-to-B} \
         {{Anneal to B triangles} penrose-do-A-anneal-to-B} \
        ];

set subtile(penrose-A-start-menu) \
    [list \
         [list {Small A Left} [penrose-A-tL tiling]] \
         [list {Small A Right} [penrose-A-tR tiling]] \
         [list {Large A Left} [penrose-A-TL tiling]] \
         [list {Large A Right} [penrose-A-TR tiling]] \
        ];

proc penrose-do-A-anneal-to-KD {tiles partials} {
    return [list penrose-KD [penrose-A-anneal-to-KD $tiles $partials]];
}

proc penrose-do-A-dissect-to-B {tiles partials} {
    return [list penrose-B [penrose-A-dissect-to-B $tiles $partials]];
}

proc penrose-do-A-anneal-to-B {tiles partials} {
    return [list penrose-B [penrose-A-anneal-to-B $tiles $partials]];
}

proc penrose-A-make {tiles divide partials} {
    if {$divide == 0} {
        return [list penrose-A $tiles];
    } else {
        return [list penrose-A [penrose-B-dissect-to-A [penrose-A-dissect-to-B $tiles $partials] $partials]];
    }
}

#
# anneal a list of penrose-A tiles to a list of penrose-B tiles
#
proc penrose-A-anneal-to-B {tiles partials} {
    set newt {};
    foreach t1 $tiles {
        pset type a b c $t1
        switch -exact $type {
            penrose-A-tL {
                set edge [edge-hash $b $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-B-TL make $z $a $b];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-A-TR {
                set edge [edge-hash $a $b]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    if {[string equal penrose-A-tL $type]} {
                        lappend newt [penrose-B-TL make $c $x $y];
                    } elseif {[string equal penrose-A-TL $type]} {
                        lappend newt [penrose-B-tL make $x $y $z] [penrose-B-tR make $a $b $c]
                    } else {
                        error "penrose-A-anneal-to-B found $type matching penrose-A-TR"
                    }
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-A-TL {
                set edge [edge-hash $a $b]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    if {[string equal penrose-A-tR $type]} {
                        lappend newt [penrose-B-TR make $y $c $a];
                    } elseif {[string equal penrose-A-TR $type]} {
                        lappend newt [penrose-B-tR make $x $y $z] [penrose-B-tL make $a $b $c]
                    } else {
                        error "penrose-A-anneal-to-B found $type matching penrose-A-TL"
                    }
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-A-tR {
                set edge [edge-hash $a $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge)
                    lappend newt [penrose-B-TR make $b $z $x];
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
            penrose-A-TR {
                lappend newt [penrose-B-tR make $a $b $c];
            }
            penrose-A-TL {
                lappend newt [penrose-B-tL make $a $b $c];
            }
            default {
                puts stderr "leftover tile: $t($edge)";
            }
        }
    }
    return $newt;
}

#
# dissect a list of penrose-A tiles into a list of penrose-B tiles
#
proc penrose-A-dissect-to-B {tiles partials} {
    upvar \#0 ::penrose-A::pT2 pT2;
    set newt {};
    foreach tile $tiles {
        pset type a b c $tile
        switch -exact $type {
            penrose-A-tL {
                lappend newt [penrose-B-TL make $a $b $c];
            }
            penrose-A-tR {
                lappend newt [penrose-B-TR make $a $b $c];
            }
            penrose-A-TL {
                set d [vadd $a [vscale $pT2 [vsub $c $a]]];
                lappend newt [penrose-B-TL make $b $c $d] [penrose-B-tL make $d $a $b];
            }
            penrose-A-TR {
                set d [vadd $b [vscale $pT2 [vsub $c $b]]];
                lappend newt [penrose-B-TR make $c $a $d] [penrose-B-tR make $b $d $a];
            }
            default {
                error "found tile of type $type";
            }
        }
    }
    return $newt;
}

#
# anneal a list of penrose-A tiles into a list of penrose-A tiles
#
proc penrose-A-anneal-to-KD {tiles partials} {
    set newt {};
    foreach t1 $tiles {
        pset type a b c $t1
        switch -exact $type {
            penrose-A-tL {
                set edge [edge-hash $a $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge);
                    lappend newt [penrose-KD-D make $x $y $b $c];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-A-tR {
                set edge [edge-hash $b $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge);
                    lappend newt [penrose-KD-D make $a $b $y $z];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-A-TL {
                set edge [edge-hash $a $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge);
                    lappend newt [penrose-KD-K make $x $y $b $c];
                } else {
                    set t($edge) $t1;
                }
            }
            penrose-A-TR {
                set edge [edge-hash $b $c]
                if {[info exists t($edge)]} {
                    pset type x y z $t($edge)
                    unset t($edge);
                    lappend newt [penrose-KD-K make $a $b $y $z];
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
            switch $type {
                penrose-A-tL {
                    # reflect b across a-c, 
                    lappend newt [penrose-KD-D make [vreflect [vreflect-make $a $c] $b] $a $b $c];
                }
                penrose-A-tR {
                    # reflect a across b-c
                    lappend newt [penrose-KD-D make $a $b [vreflect [vreflect-make $b $c] $a] $c];
                }
                penrose-A-TL {
                    # reflect b across a-c
                    lappend newt [penrose-KD-K make [vreflect [vreflect-make $a $c] $b] $a $b $c];
                }
                penrose-A-TR {
                    # reflect a across b-c
                    lappend newt [penrose-KD-K make $a $b [vreflect [vreflect-make $b $c] $a] $c];
                }
            }
        }
    }
    return $newt;
}
