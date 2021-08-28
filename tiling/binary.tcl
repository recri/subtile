########################################################################
##
## binary prototiles
##
lappend subtile(tilings) {Binary binary};

set binary(binary-d1) [vmake sqrt(2+$Tau) 0];
set binary(binary-a1) [rmake $Pi/10];
set binary(binary-a2) [rmake -$Pi/10];

set c [vmake cos($Pi/5) sin($Pi/5)];
set e [vmake cos(2*$Pi/5) sin(2*$Pi/5)];
set t [list [list binary-t {0 0} {1.5 0} [vscale 1.5 [vadd 1 $c]] [vscale 1.5 $c]]];
set T [list [list binary-T {0 0} {1.5 0} [vscale 1.5 [vadd 1 $e]] [vscale 1.5 $e]]];
set subtile(binary-ops-menu) {};
set subtile(binary-start-menu) \
    [list \
	 [list {Thick rhomb} $T] \
	 [list {Thin rhomb} $t] \
	];

proc binary-make {tiles divide} {
    if {$divide == 0} {
	return [list binary $tiles];
    } else {
	set newt {};
	foreach t1 $tiles {
	    eval lappend newt [eval binary-dissect $t1];
	}
	return [list binary $newt];
    }
}

proc binary-dissect {type a b c d} {
    switch -exact $type {
	binary-t {
	    upvar \#0 binary(binary-d1) d1;
	    upvar \#0 binary(binary-a1) a1
	    upvar \#0 binary(binary-a2) a2
	    set w [vadd $a [vrotate $a2 [vscale 1/$d1 [vsub $b $a]]]];
	    set y [vadd $a [vrotate $a1 [vscale 1/$d1 [vsub $d $a]]]];
	    set z [vsub [vadd $w $y] $a];
	    set u [vsub [vadd $z $d] $y];
	    return [list\
			[list binary-T $z $y $a $w]\
			[list binary-t  $w $b $u $z]\
			[list binary-t  $u $d $y $z]\
		       ];
	}
	binary-T {
	    upvar \#0 binary(binary-d1) d1;
	    upvar \#0 binary(binary-a1) a1
	    upvar \#0 binary(binary-a2) a2
	    set w [vadd $a [vrotate $a2 [vscale 1/$d1 [vsub $b $a]]]];
	    set y [vadd $a [vrotate $a2 [vscale 1/$d1 [vsub $d $a]]]];
	    set z [vsub [vadd $w $y] $a];
	    set u [vsub [vadd $z $d] $y];
	    set v [vsub [vadd $b $z] $w];
	    return [list\
			[list binary-T $z $y $a $w]\
			[list binary-T $z $u $d $y]\
			[list binary-T $z $v $c $u]\
			[list binary-t  $w $b $v $z]\
		       ];
	}
	default {
	    error "unknown tile type $type";
	}
    }
}


