########################################################################
##
## Pinwheel tiling
##
lappend subtile(tilings) {Pinwheel pinwheel}

set pinwheel {{pinwheel {0 0} {3 0} {0 1.5}}};

set subtile(pinwheel-ops-menu) {};
set subtile(pinwheel-start-menu) \
    [list \
	 [list Pinwheel $pinwheel] \
	];

proc pinwheel-make {tiles divide} {
    if {$divide == 0} {
	return [list pinwheel $tiles];
    } else {
	set newt {};
	foreach t1 $tiles {
	    eval lappend newt [eval pinwheel-dissect $t1];
	}
	return [list pinwheel $newt];
    }
}

proc pinwheel-dissect {type a b c} {
    set w [vscale 1/2.0 [vadd $a $b]];
    set x [vscale 1/5.0 [vadd [vscale 3 $b] [vscale 2 $c]]];
    set y [vscale 1/5.0 [vadd $b [vscale 4 $c]]];
    set z [vscale 1/2.0 [vadd $a $y]];
    return [list\
		[list pinwheel $y $a $c]\
		[list pinwheel $z $w $a]\
		[list pinwheel $x $y $w]\
		[list pinwheel $x $b $w]\
		[list pinwheel $z $w $y]\
	       ];
}


