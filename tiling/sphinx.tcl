########################################################################
##
## Sphinx tiling
##
lappend subtile(tilings) {Sphinx sphinx}

set subtile(sphinx-ops-menu) {};

set q [expr sqrt(3)];

set sphinx [list [list sphinx [vmake 2.0 $q] [vmake 1.5  $q/2.0] [vmake 0.5 $q/2.0] {0 0} {3 0}]];

set subtile(sphinx-start-menu) \
    [list \
	 [list Sphinx $sphinx] \
	];


proc sphinx-make {tiles divide} {
    if {$divide == 0} {
	return [list sphinx $tiles];
    } else {
	set newt {};
	foreach t1 $tiles {
	    eval lappend newt [eval sphinx-dissect $t1];
	}
	return [list sphinx $newt];
    }
}

proc sphinx-dissect {type a b c d e} {
    set x1 [vscale 1/2.0 [vadd $d $b]]; 
    set x2 [vscale 1/6.0 [vsum [vscale 2 $d] $e [vscale 3 $b]]]; 
    set x3 [vscale 1/12.0 [vsum [vscale 2 $d] [vscale 4 $e] [vscale 3 $a] [vscale 3 $e]]];
    set x4 [vscale 1/4.0 [vadd [vscale 3 $e] $a]]; 
    set x5 [vscale 1/4.0 [vsum [vscale 2 $b] $a $e]];
    set x6 [vscale 1/2.0 [vadd $d $e]]; 
    return [list\
		[list sphinx  $c $x1 $x2 $x6  $d]\
		[list sphinx $x6 $x2 $x1  $c $x5]\
		[list sphinx  $b $x5 $x3 $x4  $a]\
		[list sphinx $x5 $x3 $x4  $e $x6]\
	       ];
}


