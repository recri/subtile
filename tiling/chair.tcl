########################################################################
##
## Chair tiling
##
lappend subtile(tilings) {Chair chair};

namespace eval ::chair:: {
    set c [make-tile-from-type-and-vertices chair-c {1 1} {2 1} {2 0} {0 0} {0 2} {1 2}]
}

define-tile chair-c c ${::chair::c} 6

set subtile(chair-ops-menu) {};

set subtile(chair-start-menu) \
    [list \
         [list Chair [chair-c tiling]] \
	];

proc chair-make {tiles divide partials} {
    if {$divide == 0} {
        return [list chair $tiles];
    } else {
        set newt {};
        foreach t1 $tiles {
            pset type a f e d c b $t1
            set r [vscale 1/2.0 [vadd $a $b]];
            set s [vscale 1/2.0 [vadd $d $c]];
            set t [vscale 1/2.0 [vadd $d $e]];
            set u [vscale 1/2.0 [vadd $a $f]];
            set v [vscale 1/8.0 [vsum [vscale 3 $c] $d [vscale 2 [vadd $a $b]]]];
            set w [vscale 1/8.0 [vsum [vscale 2 $a] [vscale 4 $d] $c $e]];
            set x [vscale 1/8.0 [vsum [vscale 2 [vadd $a $f]] $d [vscale 3 $e]]];
            set y [vscale 1/4.0 [vsum [vscale 2 $a] $c $d]];
            set z [vscale 1/4.0 [vsum [vscale 2 $a] $d $e]];
            lappend newt [chair-c make $a $u $x $w $v $r]
            lappend newt [chair-c make $v $y $s $c $b $r]
            lappend newt [chair-c make $w $z $t $d $s $y]
            lappend newt [chair-c make $x $u $f $e $t $z]
        }
        return [list chair $newt];
    }
}
