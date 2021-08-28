########################################################################
##
## Ammann tilings
##
lappend subtile(tilings) \
    {{Ammann A2} ammann-A2} \
    {{Ammann A3} ammann-A3} \
    {{Ammann A4} ammann-A4} \
    {{Ammann A5 - square and rhomb} ammann-A5} \
    {{Ammann A5 - triangles and rhomb } ammann-A5T};

set ammann(ammann-g) [expr sqrt(2)/(1+sqrt(2))];
set ammann(ammann-h) [expr 2*sin(3*$Pi/8)/(4*sin(3*$Pi/8)+2*cos(3*$Pi/8))];
set ammann(ammann-i) [expr 1/(2+sqrt(2))];


proc ammann-about {tiles} {
    about-something {About Ammann Tilings} {
	The Ammann tilings are described in Gruenbaum and Shephard (1987) in
	section 10.4.  The Ammann octagonal tiling, A5, is also discussed in
	Senechal (1995) section 7.3.

	The A3 tiling composition rule is not yet implemented.

	There's an error in the	description of the A4 tiling - the tiling has
	a self-similar composition rule when p/q = sqrt(2)/2, not sqrt(2).

	The A5/octagonal tiling has a composition rule which requires half
	squares.
    }
    return $tiles;
}

########################################################################
#
# the golden^2 A2 where p/q = r/s = Tau and r/p = sqrt(Tau)
#
set p $Tau;
set q 1;
set r [expr $Tau*sqrt($Tau)];
set s [expr sqrt($Tau)];
set S [list [list ammann-A2-s\
		 [vmake 0 0]\
		 [vmake $p 0]\
		 [vmake $p $s]\
		 [vmake $p+$q $s]\
		 [vmake $p+$q $r+$s]\
		 [vmake 0 $r+$s]\
		]];
set L [list [list ammann-A2-l\
		 [vmake 0 0]\
		 [vmake $p+$q 0]\
		 [vmake $p+$q $s]\
		 [vmake $p+$q+$p $s]\
		 [vmake $p+$q+$p $r+$s]\
		 [vmake 0 $r+$s]\
		]];
set subtile(ammann-A2-ops-menu) \
    [list \
	 {{About Amman Tilings} ammann-about} \
	];
set subtile(ammann-A2-start-menu) \
    [list \
	 [list Small $S] \
	 [list Large $L] \
	];

proc ammann-A2-make {tiles divide} {
    if {$divide == 0} {
	return [list ammann-A2 $tiles];
    } else {
	return [list ammann-A2 [ammann-A2-dissect $tiles]];
    }
}
proc ammann-A2-dissect {tiles} {
    global Tau;
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	set a [lindex $t1 1];
	set b [lindex $t1 2];
	set c [lindex $t1 3];
	set d [lindex $t1 4];
	set e [lindex $t1 5];
	set f [lindex $t1 6];
	switch -exact $type {
	    ammann-A2-s {
		set p [vadd $c [vscale 1/$Tau [vsub $c $d]]];
		set q [vadd $a [vscale 1/$Tau [vsub $f $a]]];
		set r [vadd $p [vscale 1/$Tau [vsub $c $b]]];
		lappend newt\
		    [list ammann-A2-s $q $r $p $c $b $a]\
		    [list ammann-A2-l $d $p $r $q $f $e];
	    }
	    ammann-A2-l {
		set q [vadd $f [vscale 1/$Tau [vsub $a $f]]];
		set p [vadd $q [vscale 1/$Tau [vsub $d $c]]];
		set r [vadd $p [vscale 1/$Tau [vsub $c $b]]];
		set s [vadd $r [vsub [vsub $d $c] [vsub $p $q]]];
		set t [vadd $b [vsub $f $q]];
		set u [vadd $f [vsub $d $c]];
		lappend newt\
		    [list ammann-A2-s $q $p $r $s $u $f]\
		    [list ammann-A2-l $d $c $t $s $u $e]\
		    [list ammann-A2-l $t $r $p $q $a $b];
	    }
	    default {
		error "unknown tile type $type";
	    }
	}
    }
    return $newt;
}
########################################################################
#
# The A3 tiling from G&S.
# the dissection is not done yet.
#
set Tau2 [expr $Tau*$Tau];
set Tau3 [expr $Tau2*$Tau];
set A [list [list ammann-A3-a\
		 [vmake 0 1+$Tau]\
		 [vmake 0 1]\
		 [vmake $Tau 1]\
		 [vmake $Tau 0]\
		 [vmake $Tau3 0]\
		 [vmake $Tau3 $Tau2]]];
set B [list [list ammann-A3-b\
		 [vmake 0 $Tau3]\
		 [vmake 0 $Tau]\
		 [vmake $Tau2 $Tau]\
		 [vmake $Tau2 0]\
		 [vmake $Tau3 0]\
		 [vmake $Tau3 $Tau2]\
		 [vmake 2*$Tau2 $Tau2]\
		 [vmake 2*$Tau2 $Tau3]]];
set C [list [list ammann-A3-c\
		 [vmake $Tau-1 $Tau3]\
		 [vmake $Tau-1 $Tau2]\
		 [vmake 0 $Tau2]\
		 [vmake 0 $Tau]\
		 [vmake $Tau $Tau]\
		 [vmake $Tau 0]\
		 [vmake 2*$Tau 0]\
		 [vmake 2*$Tau $Tau2]\
		 [vmake 2*$Tau+1 $Tau2]\
		 [vmake 2*$Tau+1 $Tau3]]];
set subtile(ammann-A3-ops-menu) \
    [list \
	 {{About Amman Tilings} ammann-about} \
	];

set subtile(ammann-A3-start-menu) \
    [list \
	 [list Small $A] \
	 [list Medium $C] \
	 [list Large $B] \
	];

proc ammann-A3-make {tiles divide} {
    if {$divide == 0} {
	return [list ammann-A3 $tiles];
    } else {
	return [list ammann-A3 [ammann-A3-dissect $tiles]];
    }
}

# this isn't done, yet
proc ammann-A3-dissect {tiles} {
    global Tau;
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	set a [lindex $t1 1];
	set b [lindex $t1 2];
	set c [lindex $t1 3];
	set d [lindex $t1 4];
	set e [lindex $t1 5];
	set f [lindex $t1 6];
	switch -exact $type {
	    ammann-A3-a {
		set g [vadd $e [vsub $b $c]];
		set h [vadd $f [vsub $d $g]];
		set j [vadd $g [vsub $a $b]];
		set i [vadd $h [vsub $d $c]];
		lappend newt [list ammann-A3-b $a $b $c $d $g $j $i $h];
		lappend newt [list ammann-A3-a $f $h $i $j $g $e];
	    }
	    ammann-A3-b {
		# remaining input vertices
		set g [lindex $t1 7];
		set h [lindex $t1 8];
		# new vertices
		set i [vadd $c [vsub $d $e]];
		set k [vadd $a [vsub $e $d]];
		set m [vadd $k [vsub $d $c]];
		set j [vadd $k [vsub $i $b]];
		set o [vadd $f [vsub $k $j]];
		set l [vsum $i [vsub $a $b] [vsub $m $k]];
		set p [vsum $j [vsub $b $a] [vsub $k $m]];
		set n [vsum $o [vsub $e $f] [vsub $c $d]];
		set r [vadd $p [vsub $j $k]];
		set q [vsum $r [vsub $j $p] [vsub $g $h]];
		lappend newt [list ammann-A3-a $b $i $l $m $k $a];
		lappend newt [list ammann-A3-c $n $o $q $r $p $j $k $m $l $i];
		lappend newt [list ammann-A3-a $f $o $n $c $d $e];
		lappend newt [list ammann-A3-a $j $p $r $q $g $h];
	    }
	    ammann-A3-c {
		# remaining input vertices
		set g [lindex $t1 7];
		set h [lindex $t1 8];
		set i [lindex $t1 9];
		set j [lindex $t1 10];
		# new vertices
		set k [vadd $a [vscale 0.5 [vadd [vsub $j $a] [vsub $f $g]]]];
		set l [vadd $k [vsub $d $c]];
		set m [vsum $l [vsub $k $a]];
		set n [vsum $m [vsub $i $j] [vsub $k $l]];
		set o [vadd $h [vsub $a $k]];
		set p [vsum $e [vsub $g $f] [vsub $o $h]];
		lappend newt [list ammann-A3-c $p $o $n $m $l $k $a $b $c $d];
		lappend newt [list ammann-A3-a $h $o $p $e $f $g];
		lappend newt [list ammann-A3-a $k $l $m $n $i $j];
	    }
	    default {
		error "unknown tile type $type";
	    }
	}
    }
    return $newt;
}
	    
########################################################################
#
# the block and key (?) tiling
#
# there appears to be a repeated error in Gruenbaum and Shephard
# that claims this tiling has a self similar composition when p/q = sqrt(2),
# but it really should be p/q = sqrt(2)/2.
#
set p $Sqrt2/2;
set q 1;
set S [list [list ammann-A4-s\
		 [vmake 0 $p+$q+$p]\
		 [vmake 0 $p]\
		 [vmake $q $p]\
		 [vmake $q 0]\
		 [vmake $q+$p 0]\
		 [vmake $q+$p $p+$q+$p]]];
set L [list [list ammann-A4-l\
		 [vmake 0 $p+$q+$p]\
		 [vmake 0 $p]\
		 [vmake $p $p]\
		 [vmake $p 0]\
		 [vmake $p+$q+$p 0]\
		 [vmake $p+$q+$p $p+$q]\
		 [vmake $p+$q $p+$q]\
		 [vmake $p+$q $p+$q+$p]]];
set subtile(ammann-A4-ops-menu) \
    [list \
	 {{About Amman Tilings} ammann-about} \
	];
set subtile(ammann-A4-start-menu) \
    [list \
	 [list Small $S] \
	 [list Large $L] \
	];

proc ammann-A4-make {tiles divide} {
    if {$divide == 0} {
	return [list ammann-A4 $tiles];
    } else {
	return [list ammann-A4 [ammann-A4-dissect $tiles]];
    }
}

proc ammann-A4-dissect {tiles} {
    global Sqrt2;
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	set a [lindex $t1 1];
	set b [lindex $t1 2];
	set c [lindex $t1 3];
	set d [lindex $t1 4];
	set e [lindex $t1 5];
	set f [lindex $t1 6];
	switch -exact $type {
	    ammann-A4-s {
		# basic edges in subdivided tile
		set pqh [vsub $e $d];
		set pqv [vsub $d $c];
		set ph [vsub [vsub $f $a] [vscale 2 $pqh]];
		set pv [vsub [vsub $b $a] [vscale 2 $pqv]];
		# clockwise from a around the edge
		set p [vadd $a $pqv];
		set q [vadd $b $pqh];
		set s [vadd $f $pqv];
		set r [vadd $s $pqv];
		set t [vadd $a $pqh];
		# jogs in
		set p1 [vadd $p $ph];
		set p11 [vadd $p1 $pv];
		set q1 [vsub $q $pqv];
		set q2 [vadd $q $pqh]
		set r1 [vsub $r $ph];
		set s1 [vsub $s $pqh];
		set t1 [vadd $t $pv];
		set t11 [vadd $t1 $ph];
		lappend newt [list ammann-A4-s $q $q1 $p11 $p1 $p $b];
		lappend newt [list ammann-A4-s $d $c $q2 $r1 $r $e];
		lappend newt [list ammann-A4-s $s $s1 $t11 $t1 $t $f];
		lappend newt [list ammann-A4-l $a $p $p1 $p11 [vadd $p11 $pqh] $t11 $t1 $t];
		lappend newt [list ammann-A4-l $q $q2 $r1 $r $s $s1 [vadd $p11 $pqh] $q1];
	    }
	    ammann-A4-l {
		# remaining input vertices
		set g [lindex $t1 7];
		set h [lindex $t1 8];
		# basic edges in subdivided tiles
		set pqh [vsub $c $b];
		set pqv [vsub $d $c];
		set ph [vsub [vsub $e $d] [vscale 2 $pqh]];
		set pv [vsub [vsub $b $a] [vscale 2 $pqv]];
		# clockwise from a around the edge
		set p [vadd $a $pqv];
		set q [vsub $e $pqh];
		set r [vsub $e $pqv];
		set s [vadd $a $pqh];
		# jogs in from from edge
		set p1 [vadd $p $ph];
		set p11 [vadd $p1 $pv];
		set c1 [vsub $c $pqv];
		set c2 [vadd $c $pqh];
		set q1 [vsub $q $pv];
		set q11 [vsub $q1 $ph];
		set r1 [vsub $r $ph];
		set r11 [vsub $r1 $pv];
		set g1 [vadd $g $pqv];
		set g2 [vsub $g $pqh];
		set s1 [vadd $s $pv];
		set s11 [vadd $s1 $ph];
		lappend newt [list ammann-A4-s $c $c1 $p11 $p1 $p $b];
		lappend newt [list ammann-A4-s $c $c2 $q11 $q1 $q $d];
		lappend newt [list ammann-A4-s $g $g2 $s11 $s1 $s $h];
		lappend newt [list ammann-A4-s $g $g1 $r11 $r1 $r $f];
		lappend newt [list ammann-A4-l $a $p $p1 $p11 [vadd $p11 $pqh] $s11 $s1 $s];
		lappend newt [list ammann-A4-l $e $r $r1 $r11 [vsub $r11 $pqh] $q11 $q1 $q];
		lappend newt [list ammann-A4-l $c $c2 [vsub $r11 $pqh] $g1 $g $g2 [vadd $p11 $pqh] $c1];
	    }
	    default {
		error "unknown tile type $type";
	    }
	}
    }
    return $newt;
}

########################################################################
#
# the octagonal tiling
#
set r [list [list ammann-A5-r\
		 [vmake 0 sin(3*$Pi/8)]\
		 [vmake cos(3*$Pi/8) 0]\
		 [vmake 2*cos(3*$Pi/8) sin(3*$Pi/8)]\
		 [vmake cos(3*$Pi/8) 2*sin(3*$Pi/8)]]];
set s [list [list ammann-A5-s\
		 [vmake 0 $Sqrt2/2]\
		 [vmake $Sqrt2/2 $Sqrt2]\
		 [vmake $Sqrt2 $Sqrt2/2]\
		 [vmake $Sqrt2/2 0]\
		]];
set subtile(ammann-A5-ops-menu) \
    [list \
	 {{About Amman Tilings} ammann-about} \
	 {{Convert to triangles and rhomb} ammann-do-A5-dissect-to-A5T} \
	];
set subtile(ammann-A5-start-menu) \
    [list \
	 [list Rhomb $r] \
	 [list Square $s] \
	];

proc ammann-do-A5-dissect-to-A5T {tiles} {
    return [list ammann-A5T [ammann-A5-dissect-to-A5T $tiles]];
}
proc ammann-A5-make {tiles divide} {
    if {$divide == 0} {
	return [list ammann-A5 $tiles];
    } else {
	return [list ammann-A5 [ammann-A5T-anneal-to-A5 [ammann-A5T-dissect [ammann-A5-dissect-to-A5T $tiles]]]];
    }
}
proc ammann-A5-dissect-to-A5T {tiles} {
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	switch -exact $type {
	    ammann-A5-r {
		lappend newt $t1;
	    }
	    ammann-A5-s {
		set a [lindex $t1 1];
		set b [lindex $t1 2];
		set c [lindex $t1 3];
		set d [lindex $t1 4];
		lappend newt\
		    [list ammann-A5T-tL $a $b $d]\
		    [list ammann-A5T-tR $c $b $d];
	    }
	}
    }
    return $newt;
}

set r [list [list ammann-A5-r\
		 [vmake 0 sin(3*$Pi/8)]\
		 [vmake cos(3*$Pi/8) 0]\
		 [vmake 2*cos(3*$Pi/8) sin(3*$Pi/8)]\
		 [vmake cos(3*$Pi/8) 2*sin(3*$Pi/8)]]];
set tL [list [list ammann-A5T-tL\
		  [vmake 0 $Sqrt2/2]\
		  [vmake $Sqrt2/2 $Sqrt2]\
		  [vmake $Sqrt2/2 0]\
		 ]];
set tR [list [list ammann-A5T-tR\
		  [vmake $Sqrt2 $Sqrt2/2]\
		  [vmake $Sqrt2/2 $Sqrt2]\
		  [vmake $Sqrt2/2 0]\
		 ]];
set subtile(ammann-A5T-ops-menu) \
    [list \
	 {{About Amman Tilings} ammann-about} \
	 {{Anneal to A5 square and rhomb} ammann-do-A5T-anneal-to-A5} \
	];
set subtile(ammann-A5T-start-menu) \
    [list \
	 [list Rhomb $r] \
	 [list {Left half-square} $tL] \
	 [list {Right half-square} $tR] \
	];

proc ammann-do-A5T-anneal-to-A5 {tiles} {
    return [list ammann-A5 [ammann-A5T-anneal-to-A5 $tiles]];
}
proc ammann-A5T-make {tiles divide} {
    if {$divide == 0} {
	return [list ammann-A5T $tiles];
    } else {
	return [list ammann-A5T [ammann-A5T-dissect $tiles]];
    }
}
proc ammann-A5T-dissect {tiles} {
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	set a [lindex $t1 1];
	set b [lindex $t1 2];
	set c [lindex $t1 3];
	switch -exact $type {
	    ammann-A5-r {
		set d [lindex $t1 4];
		upvar \#0 ammann(ammann-g) g;
		upvar \#0 ammann(ammann-h) h;
		set p [vadd $a [vscale $g [vsub $b $a]]];
		set q [vadd $c [vscale $g [vsub $b $c]]];
		set r [vadd $c [vscale $g [vsub $d $c]]];
		set s [vadd $a [vscale $g [vsub $d $a]]];
		set t [vadd $b [vscale $h [vsub $d $b]]];
		set u [vadd $d [vscale $h [vsub $b $d]]];
		lappend newt\
		    [list ammann-A5-r $p $b $q $t]\
		    [list ammann-A5-r $t $c $u $a]\
		    [list ammann-A5-r $s $u $r $d]\
		    [list ammann-A5T-tR $t $p $a]\
		    [list ammann-A5T-tL $u $s $a]\
		    [list ammann-A5T-tL $t $q $c]\
		    [list ammann-A5T-tR $u $r $c];
	    }
	    ammann-A5T-tL -
	    ammann-A5T-tR {
		if {"$type" == {ammann-A5T-tL}} {
		    set othertype ammann-A5T-tR;
		} else {
		    set othertype ammann-A5T-tL;
		}
		upvar \#0 ammann(ammann-g) g;
		upvar \#0 ammann(ammann-h) h;
		upvar \#0 ammann(ammann-i) i;
		set p [vadd $b [vscale $g [vsub $a $b]]];
		set q [vadd $b [vscale $i [vsub $c $b]]];
		set r [vadd $c [vscale $i [vsub $b $c]]];
		set s [vadd $a [vscale $g [vsub $c $a]]];
		set t [vadd $r [vsub $s $c]];
		lappend newt\
		    [list ammann-A5-r $p $a $t $q]\
		    [list ammann-A5-r $r $t $s $c]\
		    [list $type $t $r $q]\
		    [list $othertype $q $p $b]\
		    [list $othertype $t $s $a];
	    }
	    default {
		error "unknown tile type $type";
	    }
	}
    }
    return $newt;
}
proc ammann-A5T-anneal-to-A5 {tiles} {
    set newt {};
    foreach t1 $tiles {
	switch [lindex $t1 0] {
	    ammann-A5-r {
		lappend newt $t1;
	    }
	    ammann-A5T-tL {
		set point [lindex $t1 2],[lindex $t1 3];
		if {[info exists t($point)]} {
		    set t2 [lindex $t($point) 0];
		    lappend newt [list ammann-A5-s [lindex $t1 1] [lindex $t1 2] [lindex $t2 1] [lindex $t2 3]];
		    unset t($point);
		} else {
		    lappend t($point) $t1;
		}
	    }
	    ammann-A5T-tR {
		set point [lindex $t1 2],[lindex $t1 3];
		if {[info exists t($point)]} {
		    set t2 [lindex $t($point) 0];
		    lappend newt [list ammann-A5-s [lindex $t2 1] [lindex $t2 2] [lindex $t1 1] [lindex $t1 3]];
		    unset t($point);
		} else {
		    lappend t($point) $t1;
		}
	    }
	}
    }
    return $newt;
}


