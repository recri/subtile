#
# implement object rotation
#
proc rotate-mark {w x y} {
    upvar \#0 $w d;
    set d(r-m-c) [vmake [$w.c.c canvasx [winfo width $w.c.c]]/2.0 [$w.c.c canvasy [winfo height $w.c.c]]/2.0]
    set d(r-m-p) [vsub [vmake [$w.c.c canvasx $x] [$w.c.c canvasy $y]] $d(r-m-c)]
    #puts "rotate-mark $w $x $y -> $d(r-m-p), c = $d(r-m-c)"
}

proc rotate-dragto {w x y} {
    upvar \#0 $w d;
    set p [vsub [vmake [$w.c.c canvasx $x] [$w.c.c canvasy $y]] $d(r-m-c)]
    set r [vangle $d(r-m-p) $p]
    set d(r-m-p) $p
    rotate-subtiling $w $r
}
