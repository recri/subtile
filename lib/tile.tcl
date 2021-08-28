#
# define the tile object 
#
proc make-tile-from-type-and-vertices {type args} {
    return [make-tile-from-type-and-list-of-vertices $type $args]
}

proc make-tile-from-type-and-list-of-vertices {type list} {
    return [concat $type $list]
}

#
# define a tile prototype
#
proc define-tile {name label tile veq {decorator {}}} {
    global tiletable
    set tiletable($name) 1
    set tiletable($name-label) $label
    if {[tile-size $tile] == 0} {
        if {[tile-size [lindex $tile 0]] > 2} {
            puts "converting tiling to tile for $name"
            set tile [lindex $tile 0]
        }
    }
    set tiletable($name-tile) $tile
    set tiletable($name-veq) $veq
    if {[string length $decorator] > 0} {
        set tiletable($name-decorator) $decorator
    }
    proc $name {op args} "return \[defined-tile $name \$op \$args]"
}

#
# implement operations on a tile prototype
#
proc defined-tile {name op {alist {}}} {
    global tiletable
    switch $op {
        is-a-tile { return 1 }
        name { return $name }
        label -
        tile -
        veq { return $tiletable($name-$op) }
        tiling { return [list [$name tile]] }
        vertices { return [tile-vertices [$name tile]] }
        make {
            set tile [$name tile]
            # puts "tile: $tile"
            set type [tile-type $tile]
            # puts "type: $type"
            set vlist [tile-vertices $tile]
            # puts "vlist: $vlist"
            set n [llength $vlist]
            if {[llength $alist] == 1 && [llength [lindex $alist 0]] == $n} {
                set alist [lindex $alist 0]
            }
            if {[llength $alist] != $n} {
                error "wrong number of vertices for $name: [llength $alist] should be $n"
            }
            # make the new tile, provisionally
            set newt [make-tile-from-type-and-list-of-vertices $name $alist]
            # compute translation
            set t [tile-translation $newt]
            # compute scale
            set s [tile-scale $newt]
            # compute rotation angle
            set r [tile-rotation $newt]
            # make a rotation
            set rot [vrotate-make $r]
            # check for congruence
            set e2 0
            # get the origin point
            set v1 [tile-vertex $tile 0]
            set v2 [tile-vertex $tile 1]
            foreach a $alist v $vlist {
                # compute the transformed vertex
                set ap [vadd $v1 [vrotate $rot [vscale $s [vsub [vadd $a $t] $v1]]]]
                lappend aplist $ap
                set e2 [expr {$e2+[vdist2 $ap $v]}]
            }
            set rms [expr {sqrt($e2/$n)}]
            if {$rms > 0.1 * [vdist $v1 $v2]} {
                puts "alignment rms error in tile is $rms"
                foreach a $alist v $vlist ap $aplist {
                    puts "a {$a} v {$v} ap {$ap} e2 [vdist2 $ap $v]"
                }
                error "tile doesn't match prototype"
            }
            return $newt
        }
        just-make { return [make-tile-from-type-and-list-of-vertices $name $alist] }
        interior-angles { return [tile-interior-angles [$name tile]] }
        interior-angles-degrees { return [tile-interior-angles-degrees [$name tile]] }
        turn-angles { return [tile-turn-angles [$name tile]] }
        turn-angles-degrees { return [tile-turn-angles-degrees [$name tile]] }
        edge-lengths { return [tile-edge-lengths [$name tile]] }
        vertex-radii { return [tile-vertex-radii [$name tile]] }
        midpoints { return [tile-midpoints [$name tile]] }
        midpoint-radii { return [tile-midpoint-radii [$name tile]] }
        center { return [tile-center [$name tile]] }
        size { return [tile-size [$name tile]] }
        vertex { return [tile-vertex [$name tile] [lindex $alist 0]] }
        inset { return [tile-inset [$name tile] [lindex $alist 0]] }
        translation { return {0 0} }
        scale { return 1.0 }
        rotation { return 0.0 }
        default {
            set ops [join [lsort {center midpoint-radii midpoints vertex-radii edge-lengths turn-angles interior-angles just-make
                make vertices tiling poly veq tile label name is-a-tile}] {, }]
            error "undefined operation $op, must be one of: $ops"
        }
    }
}

proc tile-name {tile} { return [lindex $tile 0] }
proc tile-type {tile} { return [lindex $tile 0] }
proc tile-vertices {tile} { return [lrange $tile 1 end] }
proc tile-from-label {label {tiling {}}} {
    global tiletable 
    foreach name [array names tiletable $tiling*-label] {
        if {[string equal $label $tiletable($name)]} {
            lappend candidates [string range $name 0 [expr {[string length $name]-[string length -label]-1}]]
        }
    }
    switch [llength $candidates] {
        0 { error "no tile found with label $label" }
        1 { return [lindex $candidates 0] }
        default { error "too many tiles found with label $label: $candidates" }
    }
}
proc tile-delegate {op tile} {
    set tiletable([tile-name $tile]-tile) $tile
    return [[tile-type $tile] $op]
}

proc tile-is-a-tile {tile} {
    return [tile-delegate is-a-tile $tile]
}
proc tile-label {tile} {
    return [tile-delegate label $tile]
}
proc tile-tile {tile} {
    return [tile-delegate tile $tile]
}
proc tile-veq {tile} {
    return [tile-delegate veq $tile]
}
proc tile-poly {tile} { return [tile-delegate poly $tile] }
proc tile-tiling {tile} { return [tile-delegate tiling $tile] }

proc tile-interior-angles {tile} {
    set vs [tile-vertices $tile]
    set ias {}
    foreach u $vs v [list-roll-left $vs 1] w [list-roll-right $vs 1] {
        lappend ias [vangle [vsub $v $u] [vsub $w $u]]
    }
    return $ias
}
proc tile-interior-angles-degrees {tile} {
    return [map degrees [tile-interior-angles $tile]]
}
proc tile-interior-angle {tile i} {
    set u [tile-vertex $tile $i]
    set v [tile-vertex-wrapped $tile [expr {$i-1}]]
    set w [tile-vertex-wrapped $tile [expr {$i+1}]]
    return [vangle [vsub $v $u] [vsub $w $u]]
}
proc tile-interior-angle-degrees {tile i} {
    return [degrees [tile-interior-angle $tile $i]]
}
proc tile-interior-angle-positive-degrees {tile i} {
    return [positive-degrees [tile-interior-angle $tile $i]]
}
proc tile-turn-angles {tile} {
    set vs [tile-vertices $tile]
    set tas {}
    foreach u $vs v [list-roll-left $vs 1] w [list-roll-right $vs 1] {
        lappend tas [vangle [vsub $u $w] [vsub $v $u]]
    }
    return $tas
}
proc tile-turn-angles-degrees {tile} {
    return [map degrees [tile-turn-angles $tile]]
}
proc tile-edge-vectors {tile} {
    set vs [tile-vertices $tile]
    return [map2 vsub $vs [list-roll-left $vs 1]]
}    
proc tile-edge-vector {tile i} {
    return [vsub [tile-vertex-wrapped $tile [expr {$i+1}]] [tile-vertex $tile $i]]
}
proc tile-edge-lengths {tile} {
    return [map vlength [tile-edge-vectors $tile]]
}
proc tile-vertex-radii {tile} {
    set z [tile-center $tile]
    set vs [tile-vertices $tile]
    set vrs {}
    foreach u $vs {
        lappend vrs [vdist $u $z]
    }
    return $vrs
}
proc tile-midpoints {tile} {
    set vs [tile-vertices $tile]
    return [map2 vmidpoint $vs [list-roll-left $vs 1]]
}
proc tile-midpoint-radii {tile} {
    set z [tile-center $tile]
    set ms [tile-midpoints $tile]
    set mpr {}
    foreach u $ms {
        lappend mpr [vdist $z $u]
    }
    return $mpr
}
proc tile-center {tile} {
    set vs [tile-vertices $tile]
    set nv [llength $vs]
    set z [vmake 0 0]
    foreach u $vs {
        set z [vadd $z [vscale 1.0/$nv $u]]
    }
    return $z
}

#
# return the number of vertices
#
proc tile-size {tile} {
    return [llength [tile-vertices $tile]]
}

#
# return a particular vertex
#
proc tile-vertex {tile i} {
    return [lindex [tile-vertices $tile] $i]
}

proc tile-vertex-wrapped {tile i} {
    return [tile-vertex $tile [expr {($i+[tile-size $tile])%[tile-size $tile]}]]
}

#
# create a tile copy inset from the specified tile
#
proc tile-inset {tile p} {
    set c [tile-center $tile]
    set in [tile-type $tile]
    set x [expr {1.0-$p}]
    foreach v [tile-vertices $tile] {
        lappend in [vadd [vscale $x $v] [vscale $p $c]]
    }
    return $in
}

#
# compute the translation relative to the prototile for the type
#
proc tile-translation {tile} {
    return [vsub [[tile-type $tile] vertex 0] [tile-vertex $tile 0]]
}
proc tile-scale {tile} {
    set prot [[tile-type $tile] tile]
    set v12 [vsub [tile-vertex $prot 1] [tile-vertex $prot 0]]
    set a12 [vsub [tile-vertex $tile 1] [tile-vertex $tile 0]]
    return [expr {[vlength $v12]/[vlength $a12]}]
}
proc tile-rotation {tile} {
    set prot [[tile-type $tile] tile]
    set v12 [vsub [tile-vertex $prot 1] [tile-vertex $prot 0]]
    set a12 [vsub [tile-vertex $tile 1] [tile-vertex $tile 0]]
    return [vangle $a12 $v12]
}
#
# rescale a tile
#
proc tile-rescale {s tile} {
    set vs {}
    foreach v [tile-vertices $tile] {
        lappend vs [vscale $s $v]
    }
    return [make-tile-from-type-and-list-of-vertices [tile-type $tile] $vs]
}

#
# recenter a tile
#
proc tile-recenter {dx dy tile} {
    set dv [vmake $dx $dy]
    set vs {}
    foreach v [tile-vertices $tile] {
        lappend vs [vadd $v $dv]
    }
    return [make-tile-from-type-and-list-of-vertices [tile-type $tile] $vs]
}

#
# bound a tile
#
proc tile-bound {tile} {
    pset xmin ymin [tile-vertex $tile 0];
    pset xmax ymax "$xmin $ymin";
    foreach point [lrange [tile-vertices $tile] 1 end] {
        pset x y $point;
        if {$x < $xmin} {
            set xmin $x;
        } elseif {$x > $xmax} {
            set xmax $x;
        }
        if {$y < $ymin} {
            set ymin $y;
        } elseif {$y > $ymax} {
            set ymax $y;
        }
    }
    return "$xmin $ymin $xmax $ymax";
}

#
# dimension of a tile
#
proc tile-dimension {tile} {
    pset xmin ymin [tile-vertex $tile 0];
    pset xmax ymax "$xmin $ymin";
    foreach point [lrange [tile-vertices $tile] 1 end] {
        pset x y $point;
        if {$x < $xmin} {
            set xmin $x;
        } elseif {$x > $xmax} {
            set xmax $x;
        }
        if {$y < $ymin} {
            set ymin $y;
        } elseif {$y > $ymax} {
            set ymax $y;
        }
    }
    return [list [expr $xmax-$xmin] [expr $ymax-$ymin]];
}

#
# normalize a tile
#
proc tile-normalize {tile} {
    pset dx dy [tile-dimension $tile]
    if {$dx > $dy} {
        set s [expr 0.9/$dx]
    } else {
        set s [expr 0.9/$dy]
    }
    return [tile-recenter [tile-rescale $s $tile]]
}

#
# decorate a tile
# according to whatever scheme
# return a tag or id that can be used
# to access the decoration
#
proc tile-decorate {tile w tags} {
    global tiletable
    if {[info exists tiletable([tile-type $tile]-decorator)]} {
        return [$tiletable([tile-type $tile]-decorator) $tile $w $tags]
    } else {
        return [tag-generate]
    }
}