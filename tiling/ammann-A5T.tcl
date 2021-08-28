########################################################################
#
# the octagonal tiling - A5 - triangular dissection
#
namespace eval ::ammann-A5T:: {
    set g [expr sqrt(2)/(1+sqrt(2))];
    set h [expr 2*sin(3*$Pi/8)/(4*sin(3*$Pi/8)+2*cos(3*$Pi/8))];
    set i [expr 1/(2+sqrt(2))];

    set rl [make-tile-from-type-and-vertices ammann-A5T-rl\
                [vmake 0 sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 2*sin(3*$Pi/8)]\
                [vmake 2*cos(3*$Pi/8) sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 0]\
               ]
    set rr [make-tile-from-type-and-vertices ammann-A5T-rr\
                [vmake 0 sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 2*sin(3*$Pi/8)]\
                [vmake 2*cos(3*$Pi/8) sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 0]\
               ]
    set tL [make-tile-from-type-and-vertices ammann-A5T-tL\
                [vmake 0 $Sqrt2/2]\
                [vmake $Sqrt2/2 $Sqrt2]\
                [vmake $Sqrt2/2 0]\
               ]
    set tR [make-tile-from-type-and-vertices ammann-A5T-tR\
                [vmake $Sqrt2 $Sqrt2/2]\
                [vmake $Sqrt2/2 0]\
                [vmake $Sqrt2/2 $Sqrt2]\
               ]
}

define-tile ammann-A5T-rl rl ${::ammann-A5T::rl} 2
define-tile ammann-A5T-rr rr ${::ammann-A5T::rr} 2
define-tile ammann-A5T-tL tL ${::ammann-A5T::tL} 3
define-tile ammann-A5T-tR tR ${::ammann-A5T::tR} 3

set subtile(ammann-A5T-ops-menu) \
    [list \
         {{About Amman Tilings} ammann-about} \
         {{Anneal to A5 square and rhomb} ammann-do-A5T-anneal-to-A5} \
        ];
set subtile(ammann-A5T-start-menu) \
    [list \
         [list {Left Rhomb} [ammann-A5T-rl tiling]] \
         [list {Right Rhomb} [ammann-A5T-rr tiling]] \
         [list {Left half-square} [ammann-A5T-tL tiling]] \
         [list {Right half-square} [ammann-A5T-tR tiling]] \
        ];

proc ammann-do-A5T-anneal-to-A5 {tiles partials} {
    return [list ammann-A5 [ammann-A5T-anneal-to-A5 $tiles $partials]];
}
proc ammann-A5T-make {tiles divide partials} {
    if {$divide == 0} {
        return [list ammann-A5T $tiles];
    } else {
        return [list ammann-A5T [ammann-A5T-dissect $tiles $partials]];
    }
}

proc ammann-A5T-dissect {tiles partials} {
    upvar \#0 ::ammann-A5T::g g;
    upvar \#0 ::ammann-A5T::h h;
    upvar \#0 ::ammann-A5T::i i;
    set newt {};
    foreach t1 $tiles {
        pset type a b c $t1
        switch -exact $type {
            ammann-A5T-rl {
                set d [tile-vertex $t1 3];
                set p [vadd $a [vscale $g [vsub $b $a]]];
                set q [vadd $c [vscale $g [vsub $b $c]]];
                set r [vadd $c [vscale $g [vsub $d $c]]];
                set s [vadd $a [vscale $g [vsub $d $a]]];
                set t [vadd $b [vscale $h [vsub $d $b]]];
                set u [vadd $d [vscale $h [vsub $b $d]]];
                lappend newt [ammann-A5T-rl make $q $t $p $b]
                lappend newt [ammann-A5T-rr make $u $a $t $c]
                lappend newt [ammann-A5T-rr make $s $u $r $d]
                lappend newt [ammann-A5T-tL make $t $a $p]
                lappend newt [ammann-A5T-tR make $u $s $a]
                lappend newt [ammann-A5T-tR make $t $q $c]
                lappend newt [ammann-A5T-tL make $u $c $r]
            }
            ammann-A5T-rr {
                set d [tile-vertex $t1 3];
                set p [vadd $a [vscale $g [vsub $b $a]]];
                set q [vadd $c [vscale $g [vsub $b $c]]];
                set r [vadd $c [vscale $g [vsub $d $c]]];
                set s [vadd $a [vscale $g [vsub $d $a]]];
                set t [vadd $b [vscale $h [vsub $d $b]]];
                set u [vadd $d [vscale $h [vsub $b $d]]];
                lappend newt [ammann-A5T-rr make $q $t $p $b]
                lappend newt [ammann-A5T-rl make $t $c $u $a]
                lappend newt [ammann-A5T-rl make $s $u $r $d]
                lappend newt [ammann-A5T-tL make $t $a $p]
                lappend newt [ammann-A5T-tR make $u $s $a]
                lappend newt [ammann-A5T-tR make $t $q $c]
                lappend newt [ammann-A5T-tL make $u $c $r]
            }
            ammann-A5T-tL {
                pset b c [list $c $b]
                set p [vadd $b [vscale $g [vsub $a $b]]];
                set q [vadd $b [vscale $i [vsub $c $b]]];
                set r [vadd $c [vscale $i [vsub $b $c]]];
                set s [vadd $a [vscale $g [vsub $c $a]]];
                set t [vadd $r [vsub $s $c]];
                lappend newt [ammann-A5T-rr make $t $q $p $a]
                lappend newt [ammann-A5T-rr make $r $t $s $c]
                lappend newt [ammann-A5T-tR make $t $r $q]
                lappend newt [ammann-A5T-tL make $q $b $p]
                lappend newt [ammann-A5T-tL make $t $a $s]
            }
            ammann-A5T-tR {
                set p [vadd $b [vscale $g [vsub $a $b]]];
                set q [vadd $b [vscale $i [vsub $c $b]]];
                set r [vadd $c [vscale $i [vsub $b $c]]];
                set s [vadd $a [vscale $g [vsub $c $a]]];
                set t [vadd $r [vsub $s $c]];
                lappend newt [ammann-A5T-rl make $p $q $t $a]
                lappend newt [ammann-A5T-rl make $s $t $r $c]
                lappend newt [ammann-A5T-tL make $t $q $r]
                lappend newt [ammann-A5T-tR make $q $p $b]
                lappend newt [ammann-A5T-tR make $t $s $a]
            }
            default {
                error "unknown tile type $type";
            }
        }
    }
    return $newt;
}

proc ammann-A5T-anneal-to-A5 {tiles partials} {
    set newt {};
    foreach t1 $tiles {
        switch [tile-type $t1] {
            ammann-A5T-rl {
                pset type a b c d $t1
                lappend newt [ammann-A5-rl make $a $b $c $d];
            }
            ammann-A5T-rr {
                pset type a b c d $t1
                lappend newt [ammann-A5-rr make $a $b $c $d];
            }
            ammann-A5T-tL {
                pset type a b c $t1
                set edge [edge-hash $b $c];
                if {[info exists t($edge)]} {
                    set t2 [lindex $t($edge) 0];
                    lappend newt [ammann-A5-s make $a $b [lindex $t2 1] [lindex $t2 2]];
                    unset t($edge);
                } else {
                    lappend t($edge) $t1;
                }
            }
            ammann-A5T-tR {
                pset type a b c $t1
                set edge [edge-hash $b $c];
                if {[info exists t($edge)]} {
                    set t2 [lindex $t($edge) 0];
                    lappend newt [ammann-A5-s make [lindex $t2 1] [lindex $t2 2] $a $b];
                    unset t($edge);
                } else {
                    lappend t($edge) $t1;
                }
            }
        }
    }
    if {$partials} {
        foreach edge [array names t] {
            foreach tile $t($edge) {
                pset type a b c $tile
                set m [vscale 0.5 [vadd $b $c]]
                set d [vadd $m [vsub $m $a]]
                switch $type {
                    ammann-A5T-tL {
                        lappend newt [ammann-A5-s make $a $b $d $c]
                    }
                    ammann-A5T-tR {
                        lappend newt [ammann-A5-s make $d $c $a $b]
                    }
                    default {
                        puts "leftover tile $tile"
                    }
                }
            }
        }
    }
    return $newt;
}
