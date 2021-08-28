########################################################################
##
## binary prototiles
##

lappend subtile(tilings) {Binary binary};

namespace eval ::binary:: {
    set d1 [expr {sqrt(2+$Tau)}]
    set a1 [vrotate-make $Pi/10];
    set a2 [vrotate-make -$Pi/10];

    set c [vmake cos($Pi/5) sin($Pi/5)];
    set e [vmake cos(2*$Pi/5) sin(2*$Pi/5)];
    set thin [list binary-t {0 0} [vscale 1.5 $c] [vscale 1.5 [vadd {1 0} $c]] {1.5 0}]
    set thick [list binary-T {0 0} [vscale 1.5 $e] [vscale 1.5 [vadd {1 0} $e]] {1.5 0}]
}

define-tile binary-t t ${::binary::thin} 4
define-tile binary-T T ${::binary::thick} 4

set subtile(binary-ops-menu) {};

set subtile(binary-start-menu) \
    [list \
         [list {Thick rhomb} [binary-T tiling]] \
         [list {Thin rhomb} [binary-t tiling]] \
	];

proc binary-make {tiles divide partials} {
    if {$divide == 0} {
        return [list binary $tiles];
    } else {
        upvar \#0 ::binary::d1 d1;
        upvar \#0 ::binary::a1 a1
        upvar \#0 ::binary::a2 a2
        set newt {};
        foreach t1 $tiles {
            pset type a d c b $t1
            switch -exact $type {
                binary-t {
                    set w [vadd $a [vrotate $a2 [vscale 1/$d1 [vsub $b $a]]]];
                    set y [vadd $a [vrotate $a1 [vscale 1/$d1 [vsub $d $a]]]];
                    set z [vsub [vadd $w $y] $a];
                    set u [vsub [vadd $z $d] $y];
                    lappend newt [binary-T make $z $w $a $y] 
                    lappend newt [binary-t make $w $z $u $b]
                    lappend newt [binary-t make $u $z $y $d]
                }
                binary-T {
                    set w [vadd $a [vrotate $a2 [vscale 1/$d1 [vsub $b $a]]]];
                    set y [vadd $a [vrotate $a2 [vscale 1/$d1 [vsub $d $a]]]];
                    set z [vsub [vadd $w $y] $a];
                    set u [vsub [vadd $z $d] $y];
                    set v [vsub [vadd $b $z] $w];
                    lappend newt [binary-T make $z $w $a $y] 
                    lappend newt [binary-T make $z $y $d $u]
                    lappend newt [binary-T make $z $u $c $v]
                    lappend newt [binary-t make $w $z $v $b]
                }
                default {
                    error "unknown tile type $type";
                }
            }
        }
        return [list binary $newt];
    }
}


