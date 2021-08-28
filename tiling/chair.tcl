########################################################################
##
## Chair tiling
##
lappend subtile(tilings) {Chair chair};

set subtile(chair-ops-menu) {};

set subtile(chair-start-menu) \
    [list \
	 [list Chair {{chair {1 1} {1 2} {0 2} {0 0} {2 0} {2 1}}}] \
	];

proc chair-make {tiles divide} {
    if {$divide == 0} {
	return [list chair $tiles];
    } else {
	set newt {};
	foreach t1 $tiles {
	    eval lappend newt [eval chair-dissect $t1];
	}
	return [list chair $newt];
    }
}

proc chair-dissect {type a b c d e f} {
    set r [vscale 1/2.0 [vadd $a $b]];
    set s [vscale 1/2.0 [vadd $d $c]];
    set t [vscale 1/2.0 [vadd $d $e]];
    set u [vscale 1/2.0 [vadd $a $f]];
    set v [vscale 1/8.0 [vsum [vscale 3 $c] $d [vscale 2 [vadd $a $b]]]];
    set w [vscale 1/8.0 [vsum [vscale 2 $a] [vscale 4 $d] $c $e]];
    set x [vscale 1/8.0 [vsum [vscale 2 [vadd $a $f]] $d [vscale 3 $e]]];
    set y [vscale 1/4.0 [vsum [vscale 2 $a] $c $d]];
    set z [vscale 1/4.0 [vsum [vscale 2 $a] $d $e]];
    return [list\
		[list chair $a $r $v $w $x $u]\
		[list chair $v $r $b $c $s $y]\
		[list chair $w $y $s $d $t $z]\
		[list chair $x $z $t $e $f $u]\
	       ];
}


