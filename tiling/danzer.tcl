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
## Corrected to identify RL for all subtriangles, but retaining mirrored
## vertices, ie half of the tiles are cw and half ccw.  The left handed
## need to be reversed.
##
lappend subtile(tilings) {{Danzer triangular 7-fold} danzer};

namespace eval ::danzer:: {
    set da 1.0;
    set db [expr 0.445041867913 * $da];
    set dc [expr 0.801937735804 * $da];
    set dx [expr (1+pow($db,2)-pow($dc,2))*$da/2.0];
    set dy [expr sqrt(pow($db,2)-pow($dx,2))];
    set dg 0.356895867892;

    set AL [make-tile-from-type-and-vertices danzer-AL\
                [vmake $db 0]\
                {0 0}\
                [vmake $db/2.0 sqrt(1-pow($db/2.0,2))]\
               ];
    set AR [make-tile-from-type-and-vertices danzer-AR\
                [vmake $db 0]\
                {0 0}\
                [vmake $db/2.0 sqrt(1-pow($db/2.0,2))]\
               ];
    set BL [make-tile-from-type-and-vertices danzer-BL\
                [vmake $da 0]\
                {0 0}\
                [vmake $dx $dy]\
               ];
    set BR [make-tile-from-type-and-vertices danzer-BR\
                [vmake $da 0]\
                {0 0}\
                [vmake $da-$dx $dy]\
               ];
    set CL [make-tile-from-type-and-vertices danzer-CL\
                [vmake $da 0]\
                {0 0}\
                [vmake $da/2.0 sqrt(pow($dc,2)-pow($da/2.0,2))]\
               ];
    set CR [make-tile-from-type-and-vertices danzer-CR\
                [vmake $da 0]\
                {0 0}\
                [vmake $da/2.0 sqrt(pow($dc,2)-pow($da/2.0,2))]\
               ];
}

define-tile danzer-AL AL ${::danzer::AL} 3
define-tile danzer-AR AR ${::danzer::AR} 3
define-tile danzer-BL BL ${::danzer::BL} 3
define-tile danzer-BR BR ${::danzer::BR} 3
define-tile danzer-CL CL ${::danzer::CL} 3
define-tile danzer-CR CR ${::danzer::CR} 3

proc danzer-about {tiles} {
    about-something {About Danzer's 7-fold Tiling} {
        Danzer's 7-fold tiling is described in section 7.4.1 of
        Senechal (1995).
	
        It is remarkable because it is the first
        tiling to display 7-fold symmetry.
    }
    return $tiles;
}

set subtile(danzer-ops-menu) \
    [list \
	 {{About Danzer Tiles} danzer-about} \
	];

set subtile(danzer-start-menu) \
    [list \
         [list {Small isosceles} [danzer-AL tiling]] \
         [list {Mirrored small isoceles} [danzer-AR tiling]] \
         [list {Scalene} [danzer-BL tiling]] \
         [list {Mirrored scalene} [danzer-BR tiling]] \
         [list {Large isosceles triangle} [danzer-CL tiling]] \
         [list {Mirrored large isosceles} [danzer-CR tiling]] \
	];

proc danzer-make {tiles divide partials} {
    if {$divide == 0} {
        return [list danzer $tiles];
    } else {
        return [list danzer [danzer-dissect $tiles $partials]];
    }
}

proc danzer-dissect {tiles partials} {
    set newt {};
    foreach t1 $tiles {
        pset type a b c $t1
        switch -exact $type {
            danzer-AL {
                upvar \#0 ::danzer::dg g;
                pset type b a c $t1
                set p [vadd $c [vscale $g [vsub $a $c]]];
                set r [vadd $a [vscale $g [vsub $c $a]]];
                set q [vadd $c [vscale $g [vsub $b $c]]];
                set s [vadd $b [vscale $g [vsub $c $b]]];
                set t [vadd $p [vsub $q $c]];
                set u [vadd $a [vscale $g [vsub $b $a]]];
                lappend newt [danzer-AR make $q $p $c]
                lappend newt [danzer-AL make $p $q $t]
                lappend newt [danzer-AR make $t $s $b]
                lappend newt [danzer-AL make $r $t $a]
                lappend newt [danzer-BR make $t $q $s]
                lappend newt [danzer-BR make $a $t $u]
                lappend newt [danzer-BL make $p $t $r]
                lappend newt [danzer-CL make $t $b $u]
            }
            danzer-AR {
                upvar \#0 ::danzer::dg g;
                set p [vadd $c [vscale $g [vsub $a $c]]];
                set r [vadd $a [vscale $g [vsub $c $a]]];
                set q [vadd $c [vscale $g [vsub $b $c]]];
                set s [vadd $b [vscale $g [vsub $c $b]]];
                set t [vadd $p [vsub $q $c]];
                set u [vadd $a [vscale $g [vsub $b $a]]];
                lappend newt [danzer-AL make $p $q $c]
                lappend newt [danzer-AR make $q $p $t]
                lappend newt [danzer-AL make $s $t $b]
                lappend newt [danzer-AR make $t $r $a]
                lappend newt [danzer-BL make $q $t $s]
                lappend newt [danzer-BL make $t $a $u]
                lappend newt [danzer-BR make $t $p $r]
                lappend newt [danzer-CR make $b $t $u]
            }
            danzer-BL {
                upvar \#0 ::danzer::dg g;
                upvar \#0 ::danzer::da ka;
                upvar \#0 ::danzer::db kb;
                upvar \#0 ::danzer::dc kc;
                pset type b a c $t1
                set p [vadd $a [vscale $g [vsub $c $a]]];
                set q [vadd $c [vscale $g*$kb/$kc [vsub $b $c]]];
                set r [vadd $a [vscale $g [vsub $b $a]]];
                set s [vadd $b [vscale $g*$ka/$kc [vsub $c $b]]];
                set t [vadd $b [vscale $g [vsub $a $b]]];
                lappend newt [danzer-AL make $t $s $b]
                lappend newt [danzer-BL make $r $a $p]
                lappend newt [danzer-BL make $r $c $q]
                lappend newt [danzer-BL make $r $s $t]
                lappend newt [danzer-CR make $c $r $p]
                lappend newt [danzer-CR make $s $r $q]
            }
            danzer-BR {
                upvar \#0 ::danzer::dg g;
                upvar \#0 ::danzer::da ka;
                upvar \#0 ::danzer::db kb;
                upvar \#0 ::danzer::dc kc;
                set p [vadd $a [vscale $g [vsub $c $a]]];
                set q [vadd $c [vscale $g*$kb/$kc [vsub $b $c]]];
                set r [vadd $a [vscale $g [vsub $b $a]]];
                set s [vadd $b [vscale $g*$ka/$kc [vsub $c $b]]];
                set t [vadd $b [vscale $g [vsub $a $b]]];
                lappend newt [danzer-AR make $s $t $b]
                lappend newt [danzer-BR make $a $r $p]
                lappend newt [danzer-BR make $c $r $q]
                lappend newt [danzer-BR make $s $r $t]
                lappend newt [danzer-CL make $r $c $p]
                lappend newt [danzer-CL make $r $s $q]
            }
            danzer-CL {
                upvar \#0 ::danzer::dg g;
                upvar \#0 ::danzer::da ka;
                upvar \#0 ::danzer::db kb;
                upvar \#0 ::danzer::dc kc;
                pset type b a c $t1
                set p [vadd $a [vscale $g*$kb/$kc [vsub $c $a]]];
                set q [vadd $c [vscale $g*$ka/$kc [vsub $a $c]]];
                set r [vadd $c [vscale $g*$kb/$kc [vsub $b $c]]];
                set s [vadd $b [vscale $g*$ka/$kc [vsub $c $b]]];
                set t [vadd $b [vscale $g [vsub $a $b]]];
                set u [vadd $a [vscale $g [vsub $b $a]]];
                set v [vadd $q [vscale $g*$kb/$kc [vsub $b $q]]];
                set w [vadd $b [vscale $g*$ka/$kc [vsub $q $b]]];
                lappend newt [danzer-AL make $v $q $c] 
                lappend newt [danzer-AL make $w $s $b] 
                lappend newt [danzer-AL make $t $w $b] 
                lappend newt [danzer-BL make $u $a $p] 
                lappend newt [danzer-BL make $u $q $v] 
                lappend newt [danzer-BL make $v $c $r] 
                lappend newt [danzer-BL make $v $s $w] 
                lappend newt [danzer-BL make $u $w $t] 
                lappend newt [danzer-CR make $q $u $p] 
                lappend newt [danzer-CR make $s $v $r] 
                lappend newt [danzer-CR make $w $u $v]
            }
            danzer-CR {
                upvar \#0 ::danzer::dg g;
                upvar \#0 ::danzer::da ka;
                upvar \#0 ::danzer::db kb;
                upvar \#0 ::danzer::dc kc;
                set p [vadd $a [vscale $g*$kb/$kc [vsub $c $a]]];
                set q [vadd $c [vscale $g*$ka/$kc [vsub $a $c]]];
                set r [vadd $c [vscale $g*$kb/$kc [vsub $b $c]]];
                set s [vadd $b [vscale $g*$ka/$kc [vsub $c $b]]];
                set t [vadd $b [vscale $g [vsub $a $b]]];
                set u [vadd $a [vscale $g [vsub $b $a]]];
                set v [vadd $q [vscale $g*$kb/$kc [vsub $b $q]]];
                set w [vadd $b [vscale $g*$ka/$kc [vsub $q $b]]];
                lappend newt [danzer-AR make $q $v $c] 
                lappend newt [danzer-AR make $s $w $b] 
                lappend newt [danzer-AR make $w $t $b] 
                lappend newt [danzer-BR make $a $u $p] 
                lappend newt [danzer-BR make $q $u $v] 
                lappend newt [danzer-BR make $c $v $r] 
                lappend newt [danzer-BR make $s $v $w] 
                lappend newt [danzer-BR make $w $u $t] 
                lappend newt [danzer-CL make $u $q $p] 
                lappend newt [danzer-CL make $v $s $r] 
                lappend newt [danzer-CL make $u $w $v]
            }
            default {
                error "unknown tile type $type";
            }
        }
    }
    return $newt;
}


