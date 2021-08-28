########################################################################
##
## Definitely not Danzer's triangular prototiles with 7-fold symmetry.
##
## This is an erroneous dissection rule for Danzer's tiling.
## In short, it isn't an aperiodic tiling at all, it's just
## a recursive subdivision of the plane, of which there are
## many.
## The error is in failing to see that the large and small
## isosceles triangles appear in left and right handed forms
## in the substitution atlas.  The rule reproduced here always
## uses the same handed form of the A and C triangles.
##
lappend subtile(tilings) {{Danzer triangular 7-fold - NOT} xdanzer};

set xdanzer(danzer-a) 1.0;
set xdanzer(danzer-b) [expr 0.445041867913 * $xdanzer(danzer-a)];
set xdanzer(danzer-c) [expr 0.801937735804 * $xdanzer(danzer-a)];
set xdanzer(danzer-x) [expr (1+pow($xdanzer(danzer-b),2)-pow($xdanzer(danzer-c),2))*$xdanzer(danzer-a)/2.0];
set xdanzer(danzer-y) [expr sqrt(pow($xdanzer(danzer-b),2)-pow($xdanzer(danzer-x),2))];
set xdanzer(danzer-g) 0.356895867892;

proc xdanzer-about {tiles} {
    about-something {About Danzer NOT} {
	This tiling isn't even a tiling.  It's a mistake that I made
	when transcribing the Danzer 7-fold tiling from Senechal's
	book.  It was an instructive mistake because I hadn't yet
	recognized that aperiodic substitution tilings are a very
	small subset of	the set recursive planar subdivisions.
	
	It's interesting, too, because you can't distinguish this
	substitution rule from the true Danzer 7-fold rule without the
	edge markings.

	It's also interesting because it's fourier transform is very
	different from the others.
    }
    return $tiles;
}

set subtile(xdanzer-ops-menu) \
    [list \
	 {{About Danzer NOT} xdanzer-about} \
	];

set A [list [list danzer-A\
		 {0 0}\
		 [vmake $xdanzer(danzer-b) 0]\
		 [vmake $xdanzer(danzer-b)/2.0 sqrt(1-pow($xdanzer(danzer-b)/2.0,2))]\
		]];
set BL [list [list danzer-BL\
		  {0 0}\
		  [vmake $xdanzer(danzer-a) 0]\
		  [vmake $xdanzer(danzer-x) $xdanzer(danzer-y)]\
		 ]];
set BR [list [list danzer-BR\
		  [vmake $xdanzer(danzer-a) 0]\
		  {0 0}\
		  [vmake $xdanzer(danzer-a)-$xdanzer(danzer-x) $xdanzer(danzer-y)]\
		 ]];
set C [list [list danzer-C\
		 {0 0}\
		 [vmake $xdanzer(danzer-a) 0]\
		 [vmake $xdanzer(danzer-a)/2.0 sqrt(pow($xdanzer(danzer-c),2)-pow($xdanzer(danzer-a)/2.0,2))]\
		]];

set subtile(xdanzer-start-menu) \
    [list \
	 [list {Small isosceles triangle} $A]\
	 [list {Scalene triangle 1} $BL]\
	 [list {Scalene triangle 2} $BR]\
	 [list {Large isosceles triangle} $C]\
	];


proc xdanzer-make {tiles divide} {
    if {$divide == 0} {
	return [list xdanzer $tiles];
    } else {
	return [list xdanzer [xdanzer-dissect $tiles]];
    }
}

proc xdanzer-dissect {tiles} {
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	set a [lindex $t1 1];
	set b [lindex $t1 2];
	set c [lindex $t1 3];
	switch -exact $type {
	    danzer-A {
		upvar \#0 xdanzer(danzer-g) g;
		set p [vadd $c [vscale $g [vsub $a $c]]];
		set r [vadd $a [vscale $g [vsub $c $a]]];
		set q [vadd $c [vscale $g [vsub $b $c]]];
		set s [vadd $b [vscale $g [vsub $c $b]]];
		set t [vadd $p [vsub $q $c]];
		set u [vadd $a [vscale $g [vsub $b $a]]];
		lappend newt\
		    [list danzer-A $p $q $c]\
		    [list danzer-A $q $p $t]\
		    [list danzer-A $s $t $b]\
		    [list danzer-A $t $r $a]\
		    [list danzer-BR $t $q $s]\
		    [list danzer-BR $a $t $u]\
		    [list danzer-BL $t $p $r]\
		    [list danzer-C $b $t $u];
	    }
	    danzer-BL -
	    danzer-BR {
		upvar \#0 xdanzer(danzer-g) g;
		upvar \#0 xdanzer(danzer-a) ka;
		upvar \#0 xdanzer(danzer-b) kb;
		upvar \#0 xdanzer(danzer-c) kc;
		set p [vadd $a [vscale $g [vsub $c $a]]];
		set q [vadd $c [vscale $g*$kb/$kc [vsub $b $c]]];
		set r [vadd $a [vscale $g [vsub $b $a]]];
		set s [vadd $b [vscale $g*$ka/$kc [vsub $c $b]]];
		set t [vadd $b [vscale $g [vsub $a $b]]];
		lappend newt\
		    [list danzer-A $s $t $b]\
		    [list $type $a $r $p]\
		    [list $type $c $r $q]\
		    [list $type $s $r $t]\
		    [list danzer-C $r $c $p]\
		    [list danzer-C $r $s $q];
	    }
	    danzer-C {
		upvar \#0 xdanzer(danzer-g) g;
		upvar \#0 xdanzer(danzer-a) ka;
		upvar \#0 xdanzer(danzer-b) kb;
		upvar \#0 xdanzer(danzer-c) kc;
		set p [vadd $a [vscale $g*$kb/$kc [vsub $c $a]]];
		set q [vadd $c [vscale $g*$ka/$kc [vsub $a $c]]];
		set r [vadd $c [vscale $g*$kb/$kc [vsub $b $c]]];
		set s [vadd $b [vscale $g*$ka/$kc [vsub $c $b]]];
		set t [vadd $b [vscale $g [vsub $a $b]]];
		set u [vadd $a [vscale $g [vsub $b $a]]];
		set v [vadd $q [vscale $g*$kb/$kc [vsub $b $q]]];
		set w [vadd $b [vscale $g*$ka/$kc [vsub $q $b]]];
		lappend newt\
		    [list danzer-A $q $v $c]\
		    [list danzer-A $s $w $b]\
		    [list danzer-A $w $t $b]\
		    [list danzer-BL $a $u $p]\
		    [list danzer-BL $q $u $v]\
		    [list danzer-BL $c $v $r]\
		    [list danzer-BL $s $v $w]\
		    [list danzer-BL $w $u $t]\
		    [list danzer-C $u $q $p]\
		    [list danzer-C $v $s $r]\
		    [list danzer-C $u $w $v];
	    }
	    default {
		error "unknown tile type $type";
	    }
	}
    }
    return $newt;
}


