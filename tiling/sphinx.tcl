########################################################################
##
## Sphinx tiling
##
lappend subtile(tilings) {Sphinx sphinx}

namespace eval ::sphinx:: {
    set q [expr sqrt(3)];

    set ccw [make-tile-from-type-and-vertices sphinx-ccw [vmake 2.0 0] [vmake 1.5  $q/2.0] [vmake 0.5 $q/2.0] [vmake 0 $q] [vmake 3 $q]]
    set cw [make-tile-from-type-and-vertices sphinx-cw [vmake -1.5  $q/2.0] [vmake -2.0 0] [vmake -3 $q] [vmake 0 $q] [vmake -0.5 $q/2.0]]
}

define-tile sphinx-ccw ccw ${::sphinx::ccw} 5
define-tile sphinx-cw cw ${::sphinx::cw} 5

set subtile(sphinx-ops-menu) {};

set subtile(sphinx-start-menu) \
    [list \
         [list {Sphinx ccw} [sphinx-ccw tiling] ] \
         [list {Sphinx cw} [sphinx-cw tiling] ] \
	];


proc sphinx-make {tiles divide partial} {
    if {$divide == 0} {
        return [list sphinx $tiles];
    } else {
        set newt {};
        foreach t1 $tiles {
            pset type a b c d e $t1
            switch $type {
                sphinx-ccw {
                    set x1 [vscale 1/2.0 [vadd $d $b]]; 
                    set x2 [vscale 1/6.0 [vsum [vscale 2 $d] $e [vscale 3 $b]]]; 
                    set x3 [vscale 1/12.0 [vsum [vscale 2 $d] [vscale 4 $e] [vscale 3 $a] [vscale 3 $e]]];
                    set x4 [vscale 1/4.0 [vadd [vscale 3 $e] $a]]; 
                    set x5 [vscale 1/4.0 [vsum [vscale 2 $b] $a $e]];
                    set x6 [vscale 1/2.0 [vadd $d $e]]; 
                    lappend newt [sphinx-cw  make $x1  $c  $d $x6 $x2]; # cd - x1 c d x6 x2
                    lappend newt [sphinx-cw  make $x2 $x6 $x5  $c $x1]; # c  - x2 x6 x5 c x1
                    lappend newt [sphinx-ccw make  $b $x5 $x3 $x4  $a]; # ab - b x5 x3 x4 a
                    lappend newt [sphinx-cw  make $x3 $x5 $x6  $e $x4]; # e  - x3 x5 x6 e x4
                }
                sphinx-cw {
                    pset type b a e d c $t1
                    set x1 [vscale 1/2.0 [vadd $d $b]]; 
                    set x2 [vscale 1/6.0 [vsum [vscale 2 $d] $e [vscale 3 $b]]]; 
                    set x3 [vscale 1/12.0 [vsum [vscale 2 $d] [vscale 4 $e] [vscale 3 $a] [vscale 3 $e]]];
                    set x4 [vscale 1/4.0 [vadd [vscale 3 $e] $a]]; 
                    set x5 [vscale 1/4.0 [vsum [vscale 2 $b] $a $e]];
                    set x6 [vscale 1/2.0 [vadd $d $e]]; 
                    lappend newt [sphinx-ccw make  $c $x1 $x2 $x6  $d]; # cd - c x1 x2 x6 d
                    lappend newt [sphinx-ccw make $x6 $x2 $x1  $c $x5]; # c  - c6 x2 x1 c x5
                    lappend newt [sphinx-cw  make  $x5 $b  $a $x4 $x3]; # ab - x5 b a x4 x3
                    lappend newt [sphinx-ccw make $x5 $x3 $x4  $e $x6]; # e  - x5 x3 x4 e x6
                }
            }
        }
        return [list sphinx $newt];
    }
}
