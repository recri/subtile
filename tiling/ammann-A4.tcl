########################################################################
#
# the block and key (A4) tiling
#
# there appears to be a repeated error in Gruenbaum and Shephard
# that claims this tiling has a self similar composition when p/q = sqrt(2),
# but it really should be p/q = sqrt(2)/2.
#
namespace eval ::ammann-A4:: {
    set p $Sqrt2/2;
    set q 1;
    # in order a b c d e f
    set SL [make-tile-from-type-and-vertices ammann-A4-sL\
               [vmake 0 -($p+$q+$p)]\
               [vmake 0 -$p]\
               [vmake $q -$p]\
               [vmake $q 0]\
               [vmake $q+$p 0]\
               [vmake $q+$p -($p+$q+$p)]\
              ]
    # in order b a f e d c
    set SR [make-tile-from-type-and-vertices ammann-A4-sR\
                [vmake 0 -$p]\
                [vmake 0 -($p+$q+$p)]\
                [vmake -($q+$p) -($p+$q+$p)]\
                [vmake -($q+$p) 0]\
                [vmake -$q 0]\
                [vmake -$q -$p]\
               ]
    # in order a b c d e f g h 
    set LL [make-tile-from-type-and-vertices ammann-A4-lL\
               [vmake 0 -($p+$q+$p)]\
               [vmake 0 -$p]\
               [vmake $p -$p]\
               [vmake $p 0]\
               [vmake $p+$q+$p 0]\
               [vmake $p+$q+$p -($p+$q)]\
               [vmake $p+$q -($p+$q)]\
               [vmake $p+$q -($p+$q+$p)]\
              ]
    # in order b a h g f e d c
    set LR [make-tile-from-type-and-vertices ammann-A4-lR\
               [vmake 0 -$p]\
               [vmake 0 -($p+$q+$p)]\
               [vmake -($p+$q) -($p+$q+$p)]\
               [vmake -($p+$q) -($p+$q)]\
               [vmake -($p+$q+$p) -($p+$q)]\
               [vmake -($p+$q+$p) 0]\
               [vmake -$p 0]\
               [vmake -$p -$p]\
               ]
}

define-tile ammann-A4-sL sL ${::ammann-A4::SL} 6
define-tile ammann-A4-lL lL ${::ammann-A4::LL} 4
define-tile ammann-A4-sR sR ${::ammann-A4::SR} 6
define-tile ammann-A4-lR lR ${::ammann-A4::LR} 4

set subtile(ammann-A4-ops-menu) \
    [list \
         {{About Amman Tilings} ammann-about} \
        ];
set subtile(ammann-A4-start-menu) \
    [list \
         [list {Small Left} [ammann-A4-sL tiling]] \
         [list {Small Right} [ammann-A4-sR tiling]] \
         [list {Large Left} [ammann-A4-lL tiling]] \
         [list {Large Right} [ammann-A4-lR tiling]] \
        ];

proc ammann-A4-make {tiles divide partial} {
    if {$divide == 0} {
        return [list ammann-A4 $tiles];
    } else {
        global Sqrt2
        set newt {}
        foreach t1 $tiles {
            switch -exact [tile-type $t1] {
                ammann-A4-sL {
                    pset type a b c d e f $t1
                    # basic edges in subdivided tile
                    set pqh [vsub $e $d]
                    set pqv [vsub $d $c]
                    set ph [vsub [vsub $f $a] [vscale 2 $pqh]]
                    set pv [vsub [vsub $b $a] [vscale 2 $pqv]]
                    # clockwise from a around the edge
                    set p [vadd $a $pqv]
                    set q [vadd $b $pqh]
                    set s [vadd $f $pqv]
                    set r [vadd $s $pqv]
                    set t [vadd $a $pqh]
                    # jogs in
                    set p1 [vadd $p $ph]
                    set p11 [vadd $p1 $pv]
                    set q1 [vsub $q $pqv]
                    set q2 [vadd $q $pqh]
                    set r1 [vsub $r $ph]
                    set s1 [vsub $s $pqh]
                    set t1 [vadd $t $pv]
                    set t11 [vadd $t1 $ph]
                    lappend newt [ammann-A4-sL make $q $q1 $p11 $p1 $p $b]; # sL
                    lappend newt [ammann-A4-sR make $c $d $e $r $r1 $q2]; # sR c d e r r1 q2
                    lappend newt [ammann-A4-sR make $s1 $s $f $t $t1 $t11]; # sR s1 s f t t1 t11
                    lappend newt [ammann-A4-lL make $a $p $p1 $p11 [vadd $p11 $pqh] $t11 $t1 $t]; # lL 
                    lappend newt [ammann-A4-lL make $q $q2 $r1 $r $s $s1 [vadd $p11 $pqh] $q1]; # lL
                }
                ammann-A4-sR {
                    pset type b a f e d c $t1
                    # basic edges in subdivided tile
                    set pqh [vsub $e $d]
                    set pqv [vsub $d $c]
                    set ph [vsub [vsub $f $a] [vscale 2 $pqh]]
                    set pv [vsub [vsub $b $a] [vscale 2 $pqv]]
                    # clockwise from a around the edge
                    set p [vadd $a $pqv]
                    set q [vadd $b $pqh]
                    set s [vadd $f $pqv]
                    set r [vadd $s $pqv]
                    set t [vadd $a $pqh]
                    # jogs in
                    set p1 [vadd $p $ph]
                    set p11 [vadd $p1 $pv]
                    set q1 [vsub $q $pqv]
                    set q2 [vadd $q $pqh]
                    set r1 [vsub $r $ph]
                    set s1 [vsub $s $pqh]
                    set t1 [vadd $t $pv]
                    set t11 [vadd $t1 $ph]
                    lappend newt [ammann-A4-sR make $q1 $q $b $p $p1 $p11]; # sR q1 q b p p1 p11
                    lappend newt [ammann-A4-sL make $d $c $q2 $r1 $r $e]; # sL
                    lappend newt [ammann-A4-sL make $s $s1 $t11 $t1 $t $f]; # sL
                    lappend newt [ammann-A4-lR make $p $a $t $t1 $t11 [vadd $p11 $pqh] $p11 $p1]; # lR p a t t1 t11 vadd p11 p1
                    lappend newt [ammann-A4-lR make $q2 $q $q1 [vadd $p11 $pqh] $s1 $s $r $r1]; # lR q2 q q1 vadd s1 s r r1
                }
                ammann-A4-lL {
                    pset type a b c d e f g h $t1
                    # basic edges in subdivided tiles
                    set pqh [vsub $c $b]
                    set pqv [vsub $d $c]
                    set ph [vsub [vsub $e $d] [vscale 2 $pqh]]
                    set pv [vsub [vsub $b $a] [vscale 2 $pqv]]
                    # clockwise from a around the edge
                    set p [vadd $a $pqv]
                    set q [vsub $e $pqh]
                    set r [vsub $e $pqv]
                    set s [vadd $a $pqh]
                    # jogs in from from edge
                    set p1 [vadd $p $ph]
                    set p11 [vadd $p1 $pv]
                    set c1 [vsub $c $pqv]
                    set c2 [vadd $c $pqh]
                    set q1 [vsub $q $pv]
                    set q11 [vsub $q1 $ph]
                    set r1 [vsub $r $ph]
                    set r11 [vsub $r1 $pv]
                    set g1 [vadd $g $pqv]
                    set g2 [vsub $g $pqh]
                    set s1 [vadd $s $pv]
                    set s11 [vadd $s1 $ph]
                    lappend newt [ammann-A4-sL make $c $c1 $p11 $p1 $p $b]; # sL
                    lappend newt [ammann-A4-sR make $c2 $c $d $q $q1 $q11]; # sR c2 c d q q1 q11
                    lappend newt [ammann-A4-sR make $g2 $g $h $s $s1 $s11]; # sR g2 g h s s1 s11
                    lappend newt [ammann-A4-sL make $g $g1 $r11 $r1 $r $f]; # sL
                    lappend newt [ammann-A4-lL make $a $p $p1 $p11 [vadd $p11 $pqh] $s11 $s1 $s]; # lL
                    lappend newt [ammann-A4-lL make $e $r $r1 $r11 [vsub $r11 $pqh] $q11 $q1 $q]; # lL
                    lappend newt [ammann-A4-lL make $c $c2 [vsub $r11 $pqh] $g1 $g $g2 [vadd $p11 $pqh] $c1]; # lL
                }
                ammann-A4-lR {
                    pset type b a h g f e d c $t1
                    # basic edges in subdivided tiles
                    set pqh [vsub $c $b]
                    set pqv [vsub $d $c]
                    set ph [vsub [vsub $e $d] [vscale 2 $pqh]]
                    set pv [vsub [vsub $b $a] [vscale 2 $pqv]]
                    # clockwise from a around the edge
                    set p [vadd $a $pqv]
                    set q [vsub $e $pqh]
                    set r [vsub $e $pqv]
                    set s [vadd $a $pqh]
                    # jogs in from from edge
                    set p1 [vadd $p $ph]
                    set p11 [vadd $p1 $pv]
                    set c1 [vsub $c $pqv]
                    set c2 [vadd $c $pqh]
                    set q1 [vsub $q $pv]
                    set q11 [vsub $q1 $ph]
                    set r1 [vsub $r $ph]
                    set r11 [vsub $r1 $pv]
                    set g1 [vadd $g $pqv]
                    set g2 [vsub $g $pqh]
                    set s1 [vadd $s $pv]
                    set s11 [vadd $s1 $ph]
                    lappend newt [ammann-A4-sR make $c1 $c $b $p $p1 $p11]; # sR c1 c b p p1 p11
                    lappend newt [ammann-A4-sL make $c $c2 $q11 $q1 $q $d]; # sL
                    lappend newt [ammann-A4-sL make $g $g2 $s11 $s1 $s $h]; # sL
                    lappend newt [ammann-A4-sR make $g1 $g $f $r $r1 $r11]; # sR g1 g f r r1 r11
                    lappend newt [ammann-A4-lR make $p $a $s $s1 $s11 [vadd $p11 $pqh] $p11 $p1]; # lR p a s s1 s11 vadd p11 p1
                    lappend newt [ammann-A4-lR make $r $e $q $q1 $q11 [vsub $r11 $pqh] $r11 $r1]; # lR r e q q1 q11 vsub r11 r1
                    lappend newt [ammann-A4-lR make $c2 $c $c1 [vadd $p11 $pqh] $g2 $g $g1 [vsub $r11 $pqh]]; # lR c2 c c1 vadd g2 g g1 vsub
                }
                default {
                    error "unknown tile type $type"
                }
            }
        }
        return [list ammann-A4 $newt]
    }
}

