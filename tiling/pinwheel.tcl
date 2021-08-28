########################################################################
##
## Pinwheel tiling
##
## amended to keep all tiles cw
##
lappend subtile(tilings) {Pinwheel pinwheel}

namespace eval ::pinwheel:: {
    set cw [make-tile-from-type-and-vertices pinwheel-cw {0 0} {3 0} {0 -1.5}]
    set ccw [make-tile-from-type-and-vertices pinwheel-ccw {-3 0} {0 0} {0 -1.5}]
}

define-tile pinwheel-cw cw ${::pinwheel::cw} 3 
define-tile pinwheel-ccw ccw ${::pinwheel::ccw} 3

set subtile(pinwheel-ops-menu) {};
set subtile(pinwheel-start-menu) \
    [list \
         [list {Pinwheel clockwise} [pinwheel-cw tiling]] \
         [list {Pinwheel counterclockwise} [pinwheel-ccw tiling]] \
	];

proc pinwheel-make {tiles divide partials} {
    if {$divide == 0} {
        return [list pinwheel $tiles];
    } else {
        set newt {};
        foreach t1 $tiles {
            pset type a b c $t1
            switch $type {
                pinwheel-cw {
                    set w [vscale 1/2.0 [vadd $a $b]];
                    set x [vscale 1/5.0 [vadd [vscale 3 $b] [vscale 2 $c]]];
                    set y [vscale 1/5.0 [vadd $b [vscale 4 $c]]];
                    set z [vscale 1/2.0 [vadd $a $y]];
                    lappend newt [pinwheel-ccw make $a $y $c]
                    lappend newt [pinwheel-ccw make $w $z $a]
                    lappend newt [pinwheel-cw  make $z $w $y]
                    lappend newt [pinwheel-cw  make $x $y $w]
                    lappend newt [pinwheel-ccw make $b $x $w]
                }
                pinwheel-ccw {
                    pset type b a c $t1
                    set w [vscale 1/2.0 [vadd $a $b]];
                    set x [vscale 1/5.0 [vadd [vscale 3 $b] [vscale 2 $c]]];
                    set y [vscale 1/5.0 [vadd $b [vscale 4 $c]]];
                    set z [vscale 1/2.0 [vadd $a $y]];
                    lappend newt [pinwheel-cw make $y $a $c]
                    lappend newt [pinwheel-cw make $z $w $a]
                    lappend newt [pinwheel-ccw  make $w $z $y]
                    lappend newt [pinwheel-ccw  make $y $x $w]
                    lappend newt [pinwheel-cw make $x $b $w]
                }
                default {
                    error "found tile of type $type";
                }
            }
        }
        return [list pinwheel $newt];
    }
}
