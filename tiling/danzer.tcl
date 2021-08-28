########################################################################
##
## Danzer's triangular prototiles with 7-fold symmetry
## triangle A - isoceles with sides b-a-a
## triangle B - scalene with sides a-c-b (in left and right handed versions)
## triangle C - isoceles with sides a-c-c
## edge b = 0.445041867913 * a
## edge c = 0.801937735804 * a
## 
## The edges scale by 0.356895867892 when dissecting
##
lappend subtile(tilings) {{Danzer triangular 7-fold} danzer};

set danzer(danzer-a) 1.0;
set danzer(danzer-b) [expr 0.445041867913 * $danzer(danzer-a)];
set danzer(danzer-c) [expr 0.801937735804 * $danzer(danzer-a)];
set danzer(danzer-x) [expr (1+pow($danzer(danzer-b),2)-pow($danzer(danzer-c),2))*$danzer(danzer-a)/2.0];
set danzer(danzer-y) [expr sqrt(pow($danzer(danzer-b),2)-pow($danzer(danzer-x),2))];
set danzer(danzer-g) 0.356895867892;

proc danzer-about {tiles} {
    about-something {About Danzer's 7-fold Tiling} {
	Danzer's 7-fold tiling is described in section 7.4.1 of
	Senechal (1995).
	
	It is remarkable because it is the first
	tiling to display 7-fold symmetry.
    }
    return $tiles;
}

set AL [list [list danzer-A\
		  {0 0}\
		  [vmake $danzer(danzer-b) 0]\
		  [vmake $danzer(danzer-b)/2.0 sqrt(1-pow($danzer(danzer-b)/2.0,2))]\
		 ]];
set AR [list [list danzer-A\
		  [vmake $danzer(danzer-b) 0]\
		  {0 0}\
		  [vmake $danzer(danzer-b)/2.0 sqrt(1-pow($danzer(danzer-b)/2.0,2))]\
		 ]];
set BL [list [list danzer-BL\
		  {0 0}\
		  [vmake $danzer(danzer-a) 0]\
		  [vmake $danzer(danzer-x) $danzer(danzer-y)]\
		 ]];
set BR [list [list danzer-BR\
		  [vmake $danzer(danzer-a) 0]\
		  {0 0}\
		  [vmake $danzer(danzer-a)-$danzer(danzer-x) $danzer(danzer-y)]\
		 ]];
set CL [list [list danzer-C\
		  {0 0}\
		  [vmake $danzer(danzer-a) 0]\
		  [vmake $danzer(danzer-a)/2.0 sqrt(pow($danzer(danzer-c),2)-pow($danzer(danzer-a)/2.0,2))]\
		 ]];
set CR [list [list danzer-C\
		  [vmake $danzer(danzer-a) 0]\
		  {0 0}\
		  [vmake $danzer(danzer-a)/2.0 sqrt(pow($danzer(danzer-c),2)-pow($danzer(danzer-a)/2.0,2))]\
		 ]];
set subtile(danzer-ops-menu) \
    [list \
	 {{About Danzer Tiles} danzer-about} \
	];
set subtile(danzer-start-menu) \
    [list \
	 [list {Small isosceles} $AL] \
	 [list {Mirrored small isoceles} $AR] \
	 [list {Scalene} $BL] \
	 [list {Mirrored scalene} $BR] \
	 [list {Large isosceles triangle} $CL] \
	 [list {Mirrored large isosceles} $CR] \
	];

proc danzer-make {tiles divide} {
    if {$divide == 0} {
	return [list danzer $tiles];
    } else {
	return [list danzer [danzer-dissect $tiles]];
    }
}

proc danzer-dissect {tiles} {
    set newt {};
    foreach t1 $tiles {
	set type [lindex $t1 0];
	set a [lindex $t1 1];
	set b [lindex $t1 2];
	set c [lindex $t1 3];
	switch -exact $type {
	    danzer-A {
		upvar \#0 danzer(danzer-g) g;
		set p [vadd $c [vscale $g [vsub $a $c]]];
		set r [vadd $a [vscale $g [vsub $c $a]]];
		set q [vadd $c [vscale $g [vsub $b $c]]];
		set s [vadd $b [vscale $g [vsub $c $b]]];
		set t [vadd $p [vsub $q $c]];
		set u [vadd $a [vscale $g [vsub $b $a]]];
		lappend newt\
		    [list danzer-A $q $p $c]\
		    [list danzer-A $q $p $t]\
		    [list danzer-A $t $s $b]\
		    [list danzer-A $t $r $a]\
		    [list danzer-BR $t $q $s]\
		    [list danzer-BR $a $t $u]\
		    [list danzer-BL $t $p $r]\
		    [list danzer-C $b $t $u];
	    }
	    danzer-BL -
	    danzer-BR {
		upvar \#0 danzer(danzer-g) g;
		upvar \#0 danzer(danzer-a) ka;
		upvar \#0 danzer(danzer-b) kb;
		upvar \#0 danzer(danzer-c) kc;
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
		    [list danzer-C $c $r $p]\
		    [list danzer-C $s $r $q];
	    }
	    danzer-C {
		upvar \#0 danzer(danzer-g) g;
		upvar \#0 danzer(danzer-a) ka;
		upvar \#0 danzer(danzer-b) kb;
		upvar \#0 danzer(danzer-c) kc;
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
		    [list danzer-C $q $u $p]\
		    [list danzer-C $s $v $r]\
		    [list danzer-C $w $u $v];
	    }
	    default {
		error "unknown tile type $type";
	    }
	}
    }
    return $newt;
}


