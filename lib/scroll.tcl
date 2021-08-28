#
# implement page scrolling by pushing the page
#
proc scroll-mark {w x y} {
    upvar \#0 $w d;
    set d(s-m-x) $x;
    set d(s-m-y) $y;
}

proc scroll-dragto {w x y} {
    upvar \#0 $w d;
    set dx [expr -($x-$d(s-m-x))];
    set dy [expr -($y-$d(s-m-y))];
    set d(s-m-x) $x;
    set d(s-m-y) $y;
    $w.c xview scroll $dx units;
    $w.c yview scroll $dy units;
}


