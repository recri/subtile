#
# arrow in window w with tags tags from v through center z to e
# v and e are vertex and edge in socolar and the arrow curves
# but others won't
#
proc tile-arrow {w tags v z e} {
    set v [vadd [vscale 0.75 $v] [vscale 0.25 $z]]
    set e [vadd [vscale 0.75 $e] [vscale 0.25 $z]]
    $w.c create line [concat $v $z $e] -width 2 -arrow last -fill black -tags $tags -smooth true -splinesteps 2
}

#
# half an arrow along edges for edge matching
# in window w with tags tags on tile tile with
# directions with (f) or against (r) edge direction
#
proc tile-edge-half-arrow {w tags tile args} {
    if {[llength $args] != [tile-size $tile]} {
        error "insufficient edge direction tags for tile [tile-type $tile]: $args"
    }
    set r [vrotate-make [radians -90]]
    foreach v1 [tile-vertices $tile] v2 [list-roll-left [tile-vertices $tile] 1] d $args {
        set m [vmidpoint $v1 $v2]
        set c [vadd $m [vscale 0.1 [vrotate $r [vsub $v2 $v1]]]]
        switch $d {
            f {
                set p [vadd [vscale 0.8 $m] [vscale 0.2 $v2]]
            }
            r {
                set p [vadd [vscale 0.8 $m] [vscale 0.2 $v1]]
            }
            default {
                error "invalid edge direction tag: $d"
            }
        }
        $w.c create line [concat $m $c $p] -fill black -tags $tags
    }
}

#
# draw a vertex key using a forward turn coding
#
proc tile-vertex-part-arrow {w tags tile scale args} {
    if {[llength $args] != [tile-size $tile]} {
        error "insufficient vertex key descriptors: $args"
    }
    set vs [tile-vertices $tile]
    set vns [list-roll-left $vs 1]
    foreach a $args v $vs vn $vns {
        set xy [list $v]
        set f [vsub $vn $v]
        # puts "tile-vertex-part-arrow $w {$tags} [tile-type $tile] $a"
        foreach {forward turn} $a {
            # puts "forward $forward turn $turn"
            set v [vadd $v [vscale $scale*($forward) $f]]
            lappend xy $v
            set f [vrotate [vrotate-make [radians [expr -($turn)]]] $f]
        }
        $w.c create polygon [join $xy] -fill black -outline black -tags $tags
    }
}

#
# mark the first edge of the tile polygon with an arrow
#
proc tile-first-edge-arrow {w tags tile} {
    set v0 [tile-vertex $tile 0]
    set v [vsub [tile-vertex $tile 1] $v0]
    set a0 [vadd $v0 [vscale 0.1 [vadd $v [vrotate [vrotate-make [radians -90]] $v]]]]
    set a1 [vadd $a0 [vscale 0.4 $v]]
    return [$w.c create line [concat $a0 $a1] -tags "$tags arrow1" -fill black -arrow last]
}
    
#
# label the tile polygon with a text identifier
#
proc tile-label-polygon {w tags tile} {
    pset x y [tile-center $tile]
    return [$w.c create text $x $y -text [tile-label $tile] -tags "$tags label" -fill black]
}

#
# draw one tile
#
proc draw-tile {w tags tile} {
    upvar \#0 $w subtile
    set type [tile-type $tile]
    set id [$w.c create polygon [join [tile-vertices $tile] { }]];
    $w.c itemconfigure $id -tags "$tags tile $type" -fill $subtile(fill) -outline black;
    $w.c scale $id 0 0 $subtile(scale) $subtile(scale);
    if {$subtile(color)} {
        $w.c itemconfigure $id -fill $subtile(tile-fill)
    }
    if {$subtile(arrow)} {
        $w.c scale [tile-first-edge-arrow $w $tags $tile] 0 0 $subtile(scale) $subtile(scale)
    }
    if {$subtile(label)} {
        $w.c scale [tile-label-polygon $w $tags $tile] 0 0 $subtile(scale) $subtile(scale)
    }
    if {$subtile(decorate)} {
        $w.c scale [tile-decorate $tile $w "$tags decoration"] 0 0 $subtile(scale) $subtile(scale)
    }
    if {$subtile(watch-tiles)} {
        update;
    }
}

