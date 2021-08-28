########################################################################
##
## Tuebingen triangular tiling
##
lappend subtile(tilings) {{Tuebingen triangular tiling} ttt}

namespace eval ::ttt:: {
    set pt [expr (1/$Tau)/(1+1/$Tau)];
    set pT [expr 1/(1+$Tau)];
    set pT2 [expr 1/($Tau*$Tau)];

    # this is all reversed, because drawn in canvas coordinates
    # with y=0 at top of window.

    # tall, base 1, altitude 1.5, ccw point up
    set TL [make-tile-from-type-and-vertices ttt-TL\
                [vmake 0 $Tau*sin(2*$Pi/5)]\
                [vmake 1 $Tau*sin(2*$Pi/5)]\
                [vmake 0.5 0]]
    # tall, base 1, altitude 1.5, ccw point down
    set TR [make-tile-from-type-and-vertices ttt-TR\
                [vmake 1 $Tau*sin(2*$Pi/5)]\
                [vmake 0 $Tau*sin(2*$Pi/5)]\
                [vmake 0.5 2*$Tau*sin(2*$Pi/5)]]
    # short, base 1.6, altitude 0.6, ccw point up
    set tL [make-tile-from-type-and-vertices ttt-tL\
                [vmake 0 sin($Pi/5)]\
                [vmake $Tau sin($Pi/5)]\
                [vmake $Tau/2 0]]
    # short, base 1.6, altitude 0.6, ccw point down
    set tR [make-tile-from-type-and-vertices ttt-tR\
                [vmake $Tau sin($Pi/5)]\
                [vmake 0 sin($Pi/5)]\
                [vmake $Tau/2 2*sin($Pi/5)]]
}

define-tile ttt-TL TL ${::ttt::TL} 3
define-tile ttt-TR TR ${::ttt::TR} 3
define-tile ttt-tL tL ${::ttt::tL} 3
define-tile ttt-tR tR ${::ttt::tR} 3

set subtile(ttt-ops-menu) \
    [list \
         {{About Tuebingen Triangular Tiling} ttt-about} \
        ];

set subtile(ttt-start-menu) \
    [list \
         [list {Small ttt Left} [ttt-tL tiling]] \
         [list {Small ttt Right} [ttt-tR tiling]] \
         [list {Large ttt Left} [ttt-TL tiling]] \
         [list {Large ttt Right} [ttt-TR tiling]] \
        ];

proc ttt-about {tiles} {
    about-something {About Tuebingen Triangular Tiling} {
        The Tuebingen Triangular Tiling was first described by
        Baake, et al. (1990) in a paper which I cannot find on
        the web.  This implementation is based on Baake (1999)
        (arXiv:math-ph/99010114 V1 20 Jan 1999).

        The Tuebingen tiling uses the same triangles as the
        Penrose-A tiling but uses a different substitution rule.
        The results are very similar.
    }
    return $tiles;
}

proc ttt-make {tiles divide partials} {
    if {$divide == 0} {
        return [list ttt $tiles];
    } else {
        upvar \#0 ::ttt::pT pT;
        upvar \#0 ::ttt::pT2 pT2;
        set newt {}
        foreach t1 $tiles {
            pset type a b c $t1
            switch -exact $type {
                ttt-tL {
                    # short, two pieces
                    set d [vadd $b [vscale $pT [vsub $a $b]]];
                    lappend newt [ttt-TR make $d $c $a]
                    lappend newt [ttt-tL make $b $c $d]
                }
                ttt-tR {
                    # short, two pieces
                    set d [vadd $a [vscale $pT [vsub $b $a]]];
                    lappend newt [ttt-TL make $c $d $b]
                    lappend newt [ttt-tR make $c $a $d]
                }
                ttt-TL {
                    # tall, three pieces
                    set d [vadd $b [vscale $pT2 [vsub $c $b]]];
                    set e [vadd $a [vscale $pT2 [vsub $c $a]]];
                    lappend newt [ttt-TR make $e $d $c]
                    lappend newt [ttt-tL make $a $d $e]
                    lappend newt [ttt-TL make $b $d $a]
                }
                ttt-TR {
                    # tall, three pieces
                    set d [vadd $a [vscale $pT2 [vsub $c $a]]];
                    set e [vadd $b [vscale $pT2 [vsub $c $b]]];
                    lappend newt [ttt-TL make $d $e $c]
                    lappend newt [ttt-tR make $d $b $e]
                    lappend newt [ttt-TR make $d $a $b]
                }
                default {
                    error "found tile of type $type";
                }
            }
        }
        return [list ttt $newt];
    }
}
