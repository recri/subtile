########################################################################
#
# the golden^2 A2 where p/q = r/s = Tau and r/p = sqrt(Tau)
#
#
namespace eval ::ammann-A2:: {
    set p $Tau;
    set q 1;
    set r [expr $Tau*sqrt($Tau)];
    set s [expr sqrt($Tau)];
    set SL [make-tile-from-type-and-vertices ammann-A2-sL\
                     [vmake 0 0]\
                     [vmake 0 $r+$s]\
                     [vmake $p+$q $r+$s]\
                     [vmake $p+$q $s]\
                     [vmake $p $s]\
                     [vmake $p 0]\
                    ]
    set LL [make-tile-from-type-and-vertices ammann-A2-lL\
                     [vmake 0 0]\
                     [vmake 0 $r+$s]\
                     [vmake $p+$q+$p $r+$s]\
                     [vmake $p+$q+$p $s]\
                     [vmake $p+$q $s]\
                     [vmake $p+$q 0]\
                    ]
    # from a b c d e f go to b a f e d c
    # or since we already munged the vertices to a f e d c b
    # from a f e d c b go to f a b c d e
    set SR [make-tile-from-type-and-vertices ammann-A2-sR\
                     [vmake 0 $r+$s]\
                     [vmake 0 0]\
                     [vmake -$p 0]\
                     [vmake -$p $s]\
                     [vmake -$p-$q $s]\
                     [vmake -$p-$q $r+$s]\
                    ]
    set LR [make-tile-from-type-and-vertices ammann-A2-lR\
                     [vmake 0 $r+$s]\
                     [vmake 0 0]\
                     [vmake -$p-$q 0]\
                     [vmake -$p-$q $s]\
                     [vmake -$p-$q-$p $s]\
                     [vmake -$p-$q-$p $r+$s]\
                    ]
}

define-tile ammann-A2-sL sL ${::ammann-A2::SL} 6
define-tile ammann-A2-lL lL ${::ammann-A2::LL} 6
define-tile ammann-A2-sR sR ${::ammann-A2::SR} 6
define-tile ammann-A2-lR lR ${::ammann-A2::LR} 6

set subtile(ammann-A2-ops-menu) \
    [list \
         {{About Amman Tilings} ammann-about} \
        ];
set subtile(ammann-A2-start-menu) \
    [list \
         [list {Small Left} [ammann-A2-sL tiling]] \
         [list {Large Left} [ammann-A2-lL tiling]] \
         [list {Small Right} [ammann-A2-sR tiling]] \
         [list {Large Right} [ammann-A2-lR tiling]] \
        ];

proc ammann-A2-make {tiles divide partial} {
    if {$divide == 0} {
        return [list ammann-A2 $tiles];
    } else {
        return [list ammann-A2 [ammann-A2-dissect $tiles $partial]];
    }
}
proc ammann-A2-dissect {tiles partial} {
    global Tau;
    set newt {};
    foreach t1 $tiles {
        pset type a f e d c b $t1
        # for reference -
        # s -> s-mirror + l-mirror
        # l -> l + s + l-mirror
        # so if s == sL and l == lL
        # then sL -> sR + lR, lL -> sL + lL + lR
        # and  sR -> sL + lL, lR -> sR + lR + lL
        
        switch -exact $type {
            ammann-A2-sL {
                set p [vadd $c [vscale 1/$Tau [vsub $c $d]]]
                set q [vadd $a [vscale 1/$Tau [vsub $f $a]]]
                set r [vadd $p [vscale 1/$Tau [vsub $c $b]]]
                lappend newt [ammann-A2-sR make $a $q $r $p $c $b]; # sL -> sR (aqrpcb)
                lappend newt [ammann-A2-lR make $e $d $p $r $q $f]; # sL -> lR (edprqf)
            }
            ammann-A2-sR {
                pset type f a b c d e $t1
                set p [vadd $c [vscale 1/$Tau [vsub $c $d]]]
                set q [vadd $a [vscale 1/$Tau [vsub $f $a]]]
                set r [vadd $p [vscale 1/$Tau [vsub $c $b]]]
                lappend newt [ammann-A2-sL make $q $a $b $c $p $r]; # sR -> sL (qabcpr)
                lappend newt [ammann-A2-lL make $d $e $f $q $r $p]; # sR -> lL (defqrp)
            }
            ammann-A2-lL {
                set q [vadd $f [vscale 1/$Tau [vsub $a $f]]]
                set p [vadd $q [vscale 1/$Tau [vsub $d $c]]]
                set r [vadd $p [vscale 1/$Tau [vsub $c $b]]]
                set s [vadd $r [vsub [vsub $d $c] [vsub $p $q]]]
                set t [vadd $b [vsub $f $q]]
                set u [vadd $f [vsub $d $c]]
                lappend newt [ammann-A2-sL make $q $f $u $s $r $p]; # lL -> sL (qfusrp)
                lappend newt [ammann-A2-lR make $e $d $c $t $s $u]; # lL -> lR (3 original vertices, c d e) (edctsu)
                lappend newt [ammann-A2-lL make $t $b $a $q $p $r]; # lL -> lL (2 original vertices, b a) (tbaqpr)
            }
            ammann-A2-lR {
                pset type f a b c d e $t1
                set q [vadd $f [vscale 1/$Tau [vsub $a $f]]];
                set p [vadd $q [vscale 1/$Tau [vsub $d $c]]];
                set r [vadd $p [vscale 1/$Tau [vsub $c $b]]];
                set s [vadd $r [vsub [vsub $d $c] [vsub $p $q]]];
                set t [vadd $b [vsub $f $q]];
                set u [vadd $f [vsub $d $c]];
                lappend newt [ammann-A2-sR make $f $q $p $r $s $u]; # lR -> sR (fqprsu)
                lappend newt [ammann-A2-lL make $d $e $u $s $t $c]; # lR -> lL (3 original vertices, c d e) (deustc)
                lappend newt [ammann-A2-lR make $b $t $r $p $q $a]; # lR -> lR (2 original vertices, b a) (btrpqa)
            }
            default {
                error "unknown tile type $type";
            }
        }
    }
    return $newt;
}
