#
# implement page scaling by pulling or pushing away from the
# upper left corner???
#
proc scale-mark {w x y} {
    upvar \#0 $w d;
    set d(s-m-r2) [expr pow($x,2)+pow($y,2)];
}

proc scale-dragto {w x y} {
    upvar \#0 $w d;
    set r2 [expr pow($x,2)+pow($y,2)];
    set s [expr sqrt(double($r2)/$d(s-m-r2))]
    set d(s-m-r2) $r2;
    set d(scale) [expr $d(scale)*$s];
    $w.c scale all 0 0 $s $s;
}


