########################################################################
#
# The A3 tiling from G&S.
#
# this has left and right hand tiles which need treatment to preserve
# handedness
#
namespace eval ::ammann-A3:: {
    set Tau2 [expr $Tau*$Tau];
    set Tau3 [expr $Tau2*$Tau];
    set A [make-tile-from-type-and-vertices ammann-A3-a\
               [vmake 0 -1-$Tau]\
               [vmake 0 -1]\
               [vmake $Tau -1]\
               [vmake $Tau 0]\
               [vmake $Tau3 0]\
               [vmake $Tau3 -$Tau2]]
    set B [make-tile-from-type-and-vertices ammann-A3-b\
               [vmake 0 -$Tau3]\
               [vmake 0 -$Tau]\
               [vmake $Tau2 -$Tau]\
               [vmake $Tau2 0]\
               [vmake $Tau3 0]\
               [vmake $Tau3 -$Tau2]\
               [vmake 2*$Tau2 -$Tau2]\
               [vmake 2*$Tau2 -$Tau3]]
    set C [make-tile-from-type-and-vertices ammann-A3-c\
               [vmake $Tau-1 -$Tau3]\
               [vmake $Tau-1 -$Tau2]\
               [vmake 0 -$Tau2]\
               [vmake 0 -$Tau]\
               [vmake $Tau -$Tau]\
               [vmake $Tau 0]\
               [vmake 2*$Tau 0]\
               [vmake 2*$Tau -$Tau2]\
               [vmake 2*$Tau+1 -$Tau2]\
               [vmake 2*$Tau+1 -$Tau3]]
}

define-tile ammann-A3-a a ${::ammann-A3::A} 6
define-tile ammann-A3-b b ${::ammann-A3::B} 8
define-tile ammann-A3-c c ${::ammann-A3::C} 10

set subtile(ammann-A3-ops-menu) \
    [list \
         {{About Amman Tilings} ammann-about} \
        ];

set subtile(ammann-A3-start-menu) \
    [list \
         [list Small [ammann-A3-a tiling]] \
         [list Medium [ammann-A3-b tiling]] \
         [list Large [ammann-A3-c tiling]] \
        ];

proc ammann-A3-make {tiles divide partial} {
    if {$divide == 0} {
        return [list ammann-A3 $tiles];
    } else {
        global Tau;
        set newt {};
        foreach t1 $tiles {
            switch -exact [tile-type $t1] {
                ammann-A3-a {
                    pset type a b c d e f $t1
                    set g [vadd $e [vsub $b $c]];
                    set h [vadd $f [vsub $d $g]];
                    set j [vadd $g [vsub $a $b]];
                    set i [vadd $h [vsub $d $c]];
                    lappend newt [ammann-A3-b make $a $b $c $d $g $j $i $h];
                    lappend newt [ammann-A3-a make $f $h $i $j $g $e];
                }
                ammann-A3-b {
                    pset type a b c d e f g h $t1
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
                    lappend newt [ammann-A3-a make $b $i $l $m $k $a];
                    lappend newt [ammann-A3-c make $n $o $q $r $p $j $k $m $l $i];
                    lappend newt [ammann-A3-a make $f $o $n $c $d $e];
                    lappend newt [ammann-A3-a make $j $p $r $q $g $h];
                }
                ammann-A3-c {
                    pset type a b c d e f g h i j $t1
                    # new vertices
                    set k [vadd $a [vscale 0.5 [vadd [vsub $j $a] [vsub $f $g]]]];
                    set l [vadd $k [vsub $d $c]];
                    set m [vsum $l [vsub $k $a]];
                    set n [vsum $m [vsub $i $j] [vsub $k $l]];
                    set o [vadd $h [vsub $a $k]];
                    set p [vsum $e [vsub $g $f] [vsub $o $h]];
                    lappend newt [ammann-A3-c make $p $o $n $m $l $k $a $b $c $d];
                    lappend newt [ammann-A3-a make $h $o $p $e $f $g];
                    lappend newt [ammann-A3-a make $k $l $m $n $i $j];
                }
                default {
                    error "unknown tile type $type";
                }
            }
        }
        return [list ammann-A3 $newt];
    }
}

