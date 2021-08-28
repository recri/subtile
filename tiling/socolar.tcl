########################################################################
##
## Socolar dodecagonal tiling
##
## Adding the orientation markers has one glitch
## We label each tile l or r for left or right turning.
## The first edge in the tile, a-b, is taken to be the
## arrowed edge in the orientation mark.  Except for the
## left turn rhomb in which case the second edge, b-c,
## is the marked edge -- the rhomb 

lappend subtile(tilings) {Socolar socolar}

namespace eval ::socolar:: {
    # rhomb, square, and hexagon

    # rhomb
    # long diagonal = 2 cos 15
    # short diagonal = 2 sin 15
    # shrink = sin 15 / cos 15
    set cos15 [expr {cos([radians 15])}]
    set ncos15 [expr {-$cos15}]
    set sin15 [expr {sin([radians 15])}]
    set nsin15 [expr {-$sin15}]
    set rhomb-long-diagonal [expr {2*$cos15}]
    set rhomb-short-diagonal [expr {2*$sin15}]
    set shrink [expr {$sin15/$cos15}]

    # square 
    # diagonal = sqrt 2
    set sqrt2 [expr {sqrt(2.0)}]
    set halfsqrt2 [expr {$sqrt2/2.0}]
    set nhalfsqrt2 [expr {-$halfsqrt2}]

    # hexagon
    # diagonal = 2
    set cos30 [expr {cos([radians 30])}]
    set ncos30 [expr {-$cos30}]

    set rl [make-tile-from-type-and-vertices socolar-rl \
                [vmake $nsin15 0] [vmake 0 $cos15 ] [vmake $sin15 0] [vmake 0 $ncos15]]
    set sl [make-tile-from-type-and-vertices socolar-sl \
                [vmake $nhalfsqrt2 0] [vmake 0 $halfsqrt2] [vmake $halfsqrt2 0] [vmake 0 $nhalfsqrt2]]
    set hl [make-tile-from-type-and-vertices socolar-hl \
                [vmake $ncos30 -0.5] [vmake $ncos30 0.5] [vmake 0 1] [vmake $cos30 0.5] [vmake $cos30 -0.5] [vmake 0 -1]]
    set rr [make-tile-from-type-and-vertices socolar-rr \
                [vmake $nsin15 0] [vmake 0 $cos15 ] [vmake $sin15 0] [vmake 0 $ncos15]]
    set sr [make-tile-from-type-and-vertices socolar-sr \
                [vmake $nhalfsqrt2 0] [vmake 0 $halfsqrt2] [vmake $halfsqrt2 0] [vmake 0 $nhalfsqrt2]]
    set hr [make-tile-from-type-and-vertices socolar-hr \
                [vmake $ncos30 -0.5] [vmake $ncos30 0.5] [vmake 0 1] [vmake $cos30 0.5] [vmake $cos30 -0.5] [vmake 0 -1]]

    array set tile {
        comment {tiling name, tile list, vertex list, edge list}
        name socolar
        tiles {rl rr sl sr hl hr}
        vertices {
            rl-0 rl-1 rl-2 rl-3
            rr-0 rr-1 rr-2 rr-3
            sl-0 sl-1 sl-2 sl-3
            sr-0 sr-1 sr-2 sr-3
            hl-0 hl-1 hl-2 hl-3 hl-4 hl-5
            hr-0 hr-1 hr-2 hr-3 hr-4 hr-5
        }
        comment {tile vertex lists}
        rl {rl-0 rl-1 rl-2 rl-3}
        rr {rr-0 rr-1 rr-2 rr-3}
        sl {sl-0 sl-1 sl-2 sl-3}
        sr {sr-0 sr-1 sr-2 sr-3}
        hl {hl-0 hl-1 hl-2 hl-3 hl-4 hl-5}
        hr {hr-0 hr-1 hr-2 hr-3 hr-4 hr-5}
        comment {the vertex key equivalence classes}
        equiv-vertex {
            {rl-0 rr-0}
            {rl-1 rr-3}
            {rl-2 rr-2}
            {rl-3 rr-1}
            {sl-0 sl-3 sr-0 sr-3}
            {sl-1 sl-2 sr-1 sr-2}
            {hl-0 hl-2 hl-4 hr-0 hr-2 hr-4}
            {hl-1 hl-3 hl-5 hr-1 hr-3 hr-5}
        }
        comment {the edge marking equivalence classes}
        equiv-edge {
            {rl-0 rl-2 rr-0 rr-2 sl-2 sl-3 sr-0 sr-3 hl-3 hl-4 hl-5 hr-4 hr-5 hr-0}
            {rl-1 rl-3 rr-1 rr-3 sl-0 sl-1 sr-1 sr-2 hl-0 hl-1 hl-2 hr-1 hr-2 hr-3}
        }
        comment {the key sequences at each vertex}
        rl-0 {k-0 k-1 k-0 k-1 k-2}
        rl-1 {k-2}
        rl-2 {k-0 k-1 k-2 k-1 k-2}
        rl-3 {k-0}
        rr-0 {k-0 k-1 k-0 k-1 k-2}
        rr-1 {k-0}
        rr-2 {k-0 k-1 k-2 k-1 k-2}
        rr-3 {k-2}
        sl-0 {k-1 k-0 k-1}
        sl-1 {k-1 k-2 k-1}
        sl-2 {k-1 k-2 k-1}
        sl-3 {k-1 k-0 k-1}
        sr-0 {k-1 k-0 k-1}
        sr-1 {k-1 k-2 k-1}
        sr-2 {k-1 k-2 k-1}
        sr-3 {k-1 k-0 k-1}
        hl-0 {k-0 k-1 k-0 k-1}
        hl-1 {k-1 k-2 k-1 k-2}
        hl-2 {k-0 k-1 k-0 k-1}
        hl-3 {k-1 k-2 k-1 k-2}
        hl-4 {k-0 k-1 k-0 k-1}
        hl-5 {k-1 k-2 k-1 k-2}
        hr-0 {k-0 k-1 k-0 k-1}
        hr-1 {k-1 k-2 k-1 k-2}
        hr-2 {k-0 k-1 k-0 k-1}
        hr-3 {k-1 k-2 k-1 k-2}
        hr-4 {k-0 k-1 k-0 k-1}
        hr-5 {k-1 k-2 k-1 k-2}
        comment {the complete vertex key sequence}
        vertex-key {k-1 k-2 k-1 k-2 k-1 k-2 k-1 k-0 k-1 k-0 k-1 k-0}
    }
}

define-tile socolar-rl rl ${::socolar::rl} 2 socolar-decorate
define-tile socolar-rr rr ${::socolar::rr} 2 socolar-decorate
define-tile socolar-sl sl ${::socolar::sl} 1 socolar-decorate
define-tile socolar-sr sr ${::socolar::sr} 1 socolar-decorate
define-tile socolar-hl hl ${::socolar::hl} 1 socolar-decorate
define-tile socolar-hr hr ${::socolar::hr} 1 socolar-decorate

proc socolar-matching-atlas-setup {} {
    if { ! [info exists ::socolar::vertex-successors]} {
        matching-atlas-generate ::socolar::tile ::socolar::vertex-successors ::socolar::atlas
    }
    return [list ::socolar::tile ::socolar::vertex-successors ::socolar::atlas]
}

proc socolar-decorate {tile w tags} {
    # the decorations are the little left/right turning arrow
    # the half arrow heads on the edges
    # and the vertex keys
    set id [tag-generate]
    set tags "$tags $id"
    set vs [tile-vertices $tile]
    set z [tile-center $tile]

#to tri1 :l
#    fd :l*((cos 30) + (sin 30)) rt 135 fd :l*((sin 30) / (cos 45)) rt 75 fd :l rt 150
#end
#to tri2 :l
#    fd :l rt 75 fd :l*((sin 30) / (cos 45)) rt 135 fd :l*((cos 30) + (sin 30)) rt 150
#end
#to tri3 :l
#    fd :l rt 105 fd :l * 2 * sin 15 rt 105 fd :l rt 150
#end
#
#to firsttriangle :l
#    tri1 :l rt 30 tri3 :l rt 30 tri2 :l rt 30
#    tri3 :l rt 30 tri2 :l rt 30
#    tri1 :l rt 30 tri2 :l rt 30
#    tri1 :l rt 30 tri3 :l rt 30
#    tri1 :l rt 30 tri3 :l rt 30 tri2 :l rt 30
#end

    # the angles and edges of the triangles making up the vertex key
    # two triangles are mirror images (L & R) with edges A B C and angles a b c,
    # where a is adjacent to A, b is adjacent to B, and c is adjacent to C.
    # the other triangle (M) has edges A D A and angles a d d.
    # the arrow from which the key is cut is built from twelve triangles
    # arranged clockwise: L M R M R L R L M L M R
    set a 30
    set b 105
    set c 45
    set d 75
    set A 1
    set B [expr {sin([radians 30])/cos([radians 45])}]
    set C [expr {cos([radians 30])+sin([radians 30])}]
    set D [expr {2*sin([radians 15])}]
    set s1 [expr {cos([radians 30])+sin([radians 30])}]
    set s2 [expr {sin([radians 30])/cos([radians 30])}]
    set s3 [expr {2*sin([radians 15])}]
    switch [tile-type $tile] {
        socolar-rr {
            # right turning arrow from vertex 3 to edge 0-1
            tile-arrow $w $tags [lindex $vs 3] $z [vmidpoint [lindex $vs 0] [lindex $vs 1]]
            # edge matching half arrows with/against/with/against the edge direction
            tile-edge-half-arrow $w $tags $tile f r f r
            # vertex key
            tile-vertex-part-arrow $w $tags $tile 0.15 \
                [list $C 180-$c $B+$D+$B 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-5*$a] \
                [list $C 180-$c $B 180-$b $A 180-$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D+$B 180-$c $C 180-5*$a] \
                [list $A 180-$b $B 180-$c $C 180-$a]
        }
        socolar-rl {
            # left turning arrow from vertex 3 to edge 1-2
            tile-arrow $w $tags [lindex $vs 3] $z [vmidpoint [lindex $vs 1] [lindex $vs 2]]
            # edge matching half arrows with/against/with/against the edge direction
            tile-edge-half-arrow $w $tags $tile f r f r
            # vertex key
            tile-vertex-part-arrow $w $tags $tile 0.15 \
                [list $C 180-$c $B+$D+$B 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-5*$a] \
                [list $A 180-$b $B 180-$c $C 180-$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D+$B 180-$c $C 180-5*$a] \
                [list $C 180-$c $B 180-$b $A 180-$a]
        }
        socolar-sr {
            # right turning arrow from vertex 3 to edge 0-1
            tile-arrow $w $tags [lindex $vs 3] $z [vmidpoint [lindex $vs 0] [lindex $vs 1]]
            # edge matching half arrows with/against/against/with the edge direction
            tile-edge-half-arrow $w $tags $tile f r r f
            # vertex key
            tile-vertex-part-arrow $w $tags $tile 0.15 \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $D 180-$d $A 180-3*$a] \
                [list $A 180-$d $D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-3*$a] \
                [list $A 180-$d $D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-3*$a] \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $D 180-$d $A 180-3*$a]
        }
        socolar-sl {
            # left turning arrow from vertex 2 to edge 0-1
            tile-arrow $w $tags [lindex $vs 2] $z [vmidpoint [lindex $vs 0] [lindex $vs 1]]
            # edge matching half arrows against/against/with/with the edge direction
            tile-edge-half-arrow $w $tags $tile r r f f
            # vertex key
            tile-vertex-part-arrow $w $tags $tile 0.15 \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $D 180-$d $A 180-3*$a] \
                [list $A 180-$d $D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-3*$a] \
                [list $A 180-$d $D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-3*$a] \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $D 180-$d $A 180-3*$a]
        }
        socolar-hr {
            # right turning arrow from vertex 4 to edge 0-1
            tile-arrow $w $tags [lindex $vs 4] $z [vmidpoint [lindex $vs 0] [lindex $vs 1]]
            # edge matching half arrows with/against/against/against/with/with the edge direction
            tile-edge-half-arrow $w $tags $tile f r r r f f
            # vertex key
            tile-vertex-part-arrow $w $tags $tile 0.15 \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-4*$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-4*$a] \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-4*$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-4*$a] \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-4*$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-4*$a]
        }
        socolar-hl {
            # left turning arrow from vertex 3 to edge 0-1
            tile-arrow $w $tags [lindex $vs 3] $z [vmidpoint [lindex $vs 0] [lindex $vs 1]]
            # edge matching half arrows against/against/against/with/with/with the edge direction
            tile-edge-half-arrow $w $tags $tile r r r f f f
            # vertex key
            tile-vertex-part-arrow $w $tags $tile 0.15 \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-4*$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-4*$a] \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-4*$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-4*$a] \
                [list $A 180-$d $B+$D 180-$c $C-$A 360-$d $B+$D 180-$c $C 180-4*$a] \
                [list $C 180-$c $B+$D 360-$d $C-$A 180-$c $B+$D 180-$d $A 180-4*$a]
        }
    }
    return $id
}

set subtile(socolar-ops-menu) {
    {{about Socolar tilings} socolar-about} 
    {{convert to shield} socolar-do-convert-to-shield}
    {{convert to plate} socolar-do-convert-to-plate}
    {{convert to wheel} socolar-do-convert-to-wheel}
};

proc socolar-make {tiles divide partials} {
    return [::socolar::socolar-make $tiles $divide $partials]
}

proc socolar-subdivide {tiles partials} {
    return [::socolar::socolar-subdivide $tiles $partials]
}

proc socolar-do-convert-to-shield {tiles partials} {
    return [list shield [socolar-convert-to-shield $tiles $partials]]
}

proc socolar-convert-to-shield {tiles partials} {
    return [::socolar::socolar-to-shield $tiles $partials]
}

proc socolar-do-convert-to-plate {tiles partials} {
    return [list plate [socolar-convert-to-plate $tiles $partials]]
}

proc socolar-convert-to-plate {tiles partials} {
    return [::socolar::socolar-to-plate $tiles $partials]
}

proc socolar-do-convert-to-wheel {tiles partials} {
    return [list wheel [socolar-convert-to-wheel $tiles $partials]]
}

proc socolar-convert-to-wheel {tiles partials} {
    return [::socolar::socolar-to-wheel $tiles $partials]
}

set subtile(socolar-start-menu) \
    [list \
         [list socolarrl [socolar-rl tiling]] \
         [list socolarrr [socolar-rr tiling]] \
         [list socolarsl [socolar-sl tiling]] \
         [list socolarsr [socolar-sr tiling]] \
         [list socolarhl [socolar-hl tiling]] \
         [list socolarhr [socolar-hr tiling]] \
	];

namespace eval ::socolar:: {
    # the proportion of the new small rhomb short diagonal to the old rhomb long diagonal
    set rhomb1 [expr {$shrink*$shrink}]

    # the proportion of the new small rhomb long diagonal to the old rhomb long diagonal
    set rhomb2 $shrink

    # the proportion of the new square diagonal to the old rhomb long diagonal
    set rhomb3 [expr {$shrink*$sqrt2/${rhomb-long-diagonal}}]

    # a rotation of 90 degrees left
    set lt90 [vrotate-make [radians 90]]

    # the proportion of the new square diagonal to the old square diagonal
    set square1 $shrink

    # the proportion of the new rhomb long diagonal to the old square diagonal
    set square2 [expr {$shrink*${rhomb-long-diagonal}/$sqrt2}]

    # the proportion of the new rhomb short diagonal to the old square diagonal
    set square3 [expr {$shrink*${rhomb-short-diagonal}/$sqrt2}]

    # the proportion of the new hex diagonal to the old hex diagonal
    set hex1 $shrink

    # the proportion of the rhomb short diagonal radius to long diagonal
    set hex2 [expr {$sin15/(2*$cos15)}]

    # the turn and scale that takes an oriented square edge to the square center
    set rotate-square-edge-to-center [vrotate-make [radians -45]]
    set scale-square-edge-to-center [expr {sqrt(2)/2.0}]

    # turn a square edge to the orthogonal corner
    set rotate-square-edge-to-corner [vrotate-make [radians -90]]

    # the turn that takes an oriented hex edge to the square center
    set rotate-hex-edge-to-center [vrotate-make [radians -60]]
    set scale-hex-edge-to-center 1

    # turn a hex edge to the next corner
    set rotate-hex-edge-to-corner [vrotate-make [radians -60]]

    proc socolar-center-from-edge {a b rotation scale} {
        return [vadd $a [vrotate $rotation [vscale $scale [vsub $b $a]]]]
    }
                         
    proc socolar-square-center-from-edge {a b} {
        variable rotate-square-edge-to-center
        variable scale-square-edge-to-center
        return [socolar-center-from-edge $a $b ${rotate-square-edge-to-center} ${scale-square-edge-to-center}]
    }

    proc socolar-hex-center-from-edge {a b} {
        variable rotate-hex-edge-to-center
        variable scale-hex-edge-to-center
        return [socolar-center-from-edge $a $b ${rotate-hex-edge-to-center} ${scale-hex-edge-to-center}]
    }

    proc socolar-square-center-from-diagonal {a c} {
        return [vmidpoint $a $c]
    }

    # merge an edge and a diagonal
    proc socolar-square-merge-edge-diagonal {tname hname x y a c st de} {
        global socolar
        upvar $tname tiles
        upvar $hname hash
        # either a is x or c is x or a is y or c is y
        set e [expr {[vdist2 $x $y]/2}]
        if {[vdist2 $a $x] < $e} {
            # a is x
            socolar-finish-square-from-two-edges tiles hash $a $y $c $st $de
        } elseif {[vdist2 $c $x] < $e} {
            # c is x
            socolar-finish-square-from-two-edges tiles hash $c $y $a $st [expr {($de+2)%4}]
        } elseif {[vdist2 $a $y] < $e} {
            # a is y
            socolar-finish-square-from-two-edges tiles hash $c $x $a $st [expr {($de+2)%4}]
        } elseif {[vdist2 $c $y] < $e} {
            # c is y
            socolar-finish-square-from-two-edges tiles hash $a $x $c $st $de
        } else {
            error "socolar-square-merge-edge-diagonal $a $c\n\tfound $t $x $y"
        }
    }
    
    #
    # these piece matchers all use the center of the target tile
    # as the hash code.
    #
    # given one edge of a square, match up to the other three
    proc socolar-finish-square-from-edge {tname hname a b} {
        global socolar
        upvar $tname tiles
        upvar $hname hash
        set h [vertex-hash [socolar-square-center-from-edge $a $b]]
        if { ! [info exists hash($h)]} {
            set hash($h) [list se $a $b]
        } else {
            switch [lindex $hash($h) 0] {
                sd {
                    # merge onto existing diagonal
                    pset t x y st de $hash($h)
                    # we will be returning to this hash point
                    unset hash($h)
                    socolar-square-merge-edge-diagonal tiles hash $a $b $x $y $st $de
                }
                se {
                    # merge onto existing edge
                    pset t x y $hash($h)
                    # we will be returning to this hash point
                    unset hash($h)
                    # either a is y or b is x
                    set hash($h) [list sese $a $b $x $y]
                }
                see {
                    # merge onto existing pair of edges
                    pset t x y z st de $hash($h)
                    # we will not be returning to this hash point
                    unset hash($h)
                    # either a is z or b is x
                    if {[vdist2 $a $z] < [vdist2 $a $b]/2} {
                        switch $de {
                            0 { lappend tiles [socolar-$st make $x $y $z $b] }
                            1 { lappend tiles [socolar-$st make $y $z $b $x] }
                            2 { lappend tiles [socolar-$st make $z $b $x $y] }
                            3 { lappend tiles [socolar-$st make $b $x $y $z] }
                            default { error "socolar-finish-square-from-edge invalid de $de" }
                        }
                    } elseif {[vdist2 $b $x] < [vdist2 $a $b]/2} {
                        switch $de {
                            0 { lappend tiles [socolar-$st make $x $y $z $a] }
                            1 { lappend tiles [socolar-$st make $y $z $a $x] }
                            2 { lappend tiles [socolar-$st make $z $a $x $y] }
                            3 { lappend tiles [socolar-$st make $a $x $y $z] }
                            default { error "socolar-finish-square-from-edge invalid de $de" }
                        }
                    } else {
                        error "socolar-finish-square-from-edge $a $b found $t $x $y $z"
                    }
                }
                default {
                    error "socolar-finish-square-from-edge found $hash($h)"
                }
            }
        }
    }
    
    # given two diagonal vertices of a square, match up to the other two
    proc socolar-finish-square-from-diagonal {tname hname a c st de} {
        global socolar
        upvar $tname tiles
        upvar $hname hash
        set h [vertex-hash [socolar-square-center-from-diagonal $a $c]]
        if { ! [info exists hash($h)]} {
            set hash($h) [list sd $a $c $st $de]
        } else {
            switch [lindex $hash($h) 0] {
                se {
                    # merge onto existing edge
                    pset t x y $hash($h)
                    # we will be returning to this hash point
                    unset hash($h)
                    socolar-square-merge-edge-diagonal tiles hash $x $y $a $c $st $de 
                }
                sese {
                    # merge onto existing pair of edges, which might be adjacent
                    # or opposite
                    pset t x1 y1 x2 y2 $hash($h)
                    # we will be returning to this hash point
                    unset hash($h)
                    socolar-square-merge-edge-diagonal tile hash $x1 $y1 $a $c $st $de
                    socolar-finish-square-from-edge tile hash $x2 $y2
                }
                see {
                    error "found see"
                    # merge onto existing edges
                    pset t x y z st2 de2 $hash($h)
                    # we will not be returning to this hash point
                    unset hash($h)
                    # either a is y or c is y
                    if {[vdist2 $a $y] < [vdist2 $x $y]/2} {
                        lappend tiles [socolar-s make $x $y $z $c]
                    } elseif {[vdist2 $c $y] < [vdist2 $x $y]/2} {
                        lappend tiles [socolar-s make $x $y $z $a]
                    } else {
                        error "socolar-finish-square-from-diagonal found $t $x $y $z"
                    }
                }
                default {
                    error "socolar-finish-square-from-diagonal found $hash($h)"
                }
            }
        }
    }
    
    # given the first three corners of a square, match up to the fourth
    proc socolar-finish-square-from-two-edges {tname hname a b c st de} {
        global socolar
        upvar $tname tiles
        upvar $hname hash
        set h [vertex-hash [socolar-square-center-from-edge $a $b]]
        if { ! [info exists hash($h)]} {
            set hash($h) [list see $a $b $c $st $de]
        } else {
            switch [lindex $hash($h) 0] {
                se {
                    # merge onto existing edge
                    pset t x y $hash($h)
                    # we will not be returning to this hash point
                    unset hash($h)
                    # either a is y yielding x ya b c
                    # or c is x yielding a b cx y
                    if {[vdist2 $a $y] < [vdist2 $a $b]/2} {
                        switch $de {
                            0 { lappend tiles [socolar-$st make $a $b $c $x] }
                            1 { lappend tiles [socolar-$st make $b $c $x $a] }
                            2 { lappend tiles [socolar-$st make $c $x $a $b] }
                            3 { lappend tiles [socolar-$st make $x $a $b $c] }
                        }
                    } elseif {[vdist2 $c $x] < [vdist2 $a $b]/2} {
                        switch $de {
                            0 { lappend tiles [socolar-$st make $a $b $x $y] }
                            1 { lappend tiles [socolar-$st make $b $x $y $a] }
                            2 { lappend tiles [socolar-$st make $x $y $a $b] }
                            3 { lappend tiles [socolar-$st make $y $a $b $x] }
                        }
                    } else {
                        error "socolar-finish-square-from-two-edges $a $b $c found $t $x $y"
                    }
                }
                default {
                    error "socolar-finish-square-from-two-edges found $hash($h)"
                }
            }
        }
    }
    
    # given one edge of a hexagon, match up to the others
    proc socolar-finish-hexagon-from-edge {tname hname a b ht de {tag {}}} {
        global socolar
        upvar $tname tiles
        upvar $hname hash
        set h [vertex-hash [socolar-hex-center-from-edge $a $b]]
        if { ! [info exists hash($h)]} {
            set hash($h) [list he $a $b $ht $de $tag]
        } else {
            switch [lindex $hash($h) 0] {
                heee {
                    pset t c d e f ht2 de2 tag2 $hash($h)
                    if { ! [string equal $ht $ht2]} {
                        error "socolar-finish-hexagon-from-edge: hex type disagreement: $ht $ht2: $tag $tag2"
                    }
                    if {$de != ($de2+2)%6} {
                        error "socolar-finish-hexagon-from-edge: designated edge disagreement"
                    }
                    unset hash($h)
                    switch $de {
                        0 { lappend tiles [socolar-$ht make $a $b $c $d $e $f] }
                        1 { lappend tiles [socolar-$ht make $b $c $d $e $f $a] }
                        2 { lappend tiles [socolar-$ht make $c $d $e $f $a $b] }
                        3 { lappend tiles [socolar-$ht make $d $e $f $a $b $c] }
                        4 { lappend tiles [socolar-$ht make $e $f $a $b $c $d] }
                        5 { lappend tiles [socolar-$ht make $f $a $b $c $d $e] }
                    }
                }
                default {
                    error "socolar-finish-hexagon-from-edge found $hash($h)"
                }
            }
        }
    }
    
    # given three edges of a hexagon, match up to the others
    # ht is the hexagon type, de is the index of the designated
    # edge counting a-b as 0
    proc socolar-finish-hexagon-from-three-edges {tname hname a b c d ht de {tag {}}} {
        upvar $tname tiles
        upvar $hname hash
        set h [vertex-hash [socolar-hex-center-from-edge $a $b]]
        if { ! [info exists hash($h)]} {
            set hash($h) [list heee $a $b $c $d $ht $de]
        } else {
            switch [lindex $hash($h) 0] {
                he {
                    pset t e f ht2 de2 tag2 $hash($h)
                    if { ! [string equal $ht $ht2]} {
                        puts "socolar-finish-hexagon-from-three-edges: hex type disagreement: $ht $ht2: $tag $tag2"
                        set hterr 1
                    }
                    if {$de != ($de2+4)%6} {
                        puts "socolar-finish-hexagon-from-three-edges: designated edge disagreement"
                        set deerr 1
                    }
                    unset hash($h)
                    switch $de {
                        0 { lappend tiles [socolar-$ht make $a $b $c $d $e $f] }
                        1 { lappend tiles [socolar-$ht make $b $c $d $e $f $a] }
                        2 { lappend tiles [socolar-$ht make $c $d $e $f $a $b] }
                        3 { lappend tiles [socolar-$ht make $d $e $f $a $b $c] }
                        4 { lappend tiles [socolar-$ht make $e $f $a $b $c $d] }
                        5 { lappend tiles [socolar-$ht make $f $a $b $c $d $e] }
                    }
                    if {[info exists hterr] || [info exists deerr]} {
                        global socolar-errors
                        lappend socolar-errors [socolar-$ht make $a $b $c $d $e $f]
                    }
                }
                default {
                    error "socolar-finish-hexagon-from-three-edges found $hash($h)"
                }
            }
        }
    }
    
    proc socolar-square-prior-vertex {a b} {
        variable rotate-square-edge-to-corner
        return [vadd $a [vrotate ${rotate-square-edge-to-corner} [vsub $b $a]]]
    }
    
    proc socolar-square-next-vertex {a b} {
        variable rotate-square-edge-to-corner
        return [vadd $b [vrotate ${rotate-square-edge-to-corner} [vsub $b $a]]]
    }
    
    # compute the piece of a rhomb from the center out to a far corner
    proc socolar-rhomb-piece {C b} {
        variable lt90
        variable rhomb1
        variable rhomb2
        # vector from C to b
        set u [vsub $b $C]
        # vector to the left of u
        set v [vrotate $lt90 $u]
        # a little towards b
        set b1 [vadd $C [vscale $rhomb1 $u]]
        # a little further towards b
        set b2 [vadd $b1 [vscale $rhomb2 $u]]
        # off to the left and the right
        set b2a [vadd $b2 [vscale $rhomb1 $v]]
        set b2b [vsub $b2 [vscale $rhomb1 $v]]
        # and still further towards b
        set b3 [vadd $b2 [vscale $rhomb2 $u]]
        return [list $b1 $b2a $b2b $b3]
    }
    
    # compute the piece of a square from the center out to a corner
    proc socolar-square-piece {C a} {
        variable lt90
        variable square1
        variable square2
        variable square3
        set u [vsub $a $C]
        set v [vrotate $lt90 $u]
        set a1 [vadd $C [vscale $square1 $u]]
        set a2 [vadd $a1 [vscale $square2 $u]]
        set a2a [vadd $a2 [vscale $square3 $v]]
        set a2b [vsub $a2 [vscale $square3 $v]]
        return [list $a1 $a2a $a2b]
    }
    
    # compute the piece of a hexagon from the center out to two corners
    proc socolar-hex-piece {C a b} {
        variable lt90
        variable hex1
        variable hex2
        # two corners of hexagon
        set a1 [vadd $C [vscale $hex1 [vsub $a $C]]]
        set b1 [vadd $C [vscale $hex1 [vsub $b $C]]]
        # make the square
        set a2 [socolar-square-next-vertex $b1 $a1]
        set b2 [socolar-square-next-vertex $a1 $a2]
        # rhomb strut to corner a
        set v [vrotate $lt90 [vscale $hex2 [vsub $a $a2]]]
        set a3 [vmidpoint $a2 $a]
        set a3a [vadd $a3 $v]
        set a3b [vsub $a3 $v]
        # rhomb struct to corner b
        set v [vrotate $lt90 [vscale $hex2 [vsub $b $b2]]]
        set b3 [vmidpoint $b2 $b]
        set b3a [vadd $b3 $v]
        set b3b [vsub $b3 $v]
        return [list $a1 $b1 $a2 $b2 $a3a $a3b $b3a $b3b]
    }
    
    # fill the octagonal hole with the right hex, square, and rhombs
    proc socolar-octagon-piece {tname t a b c d e f g h} {
        upvar $tname tiles
        switch $t {
            0 {
                set i [socolar-square-next-vertex $g $h]
                set j [socolar-square-next-vertex $h $i]
                lappend tiles [socolar-sr make $g $h $i $j]
                lappend tiles [socolar-rl make $a $b $i $h]
                lappend tiles [socolar-rr make $j $e $f $g]
                lappend tiles [socolar-hl make $c $d $e $j $i $b]
            }
            1 {
                set i [socolar-square-next-vertex $c $d]
                set j [socolar-square-next-vertex $d $i]
                lappend tiles [socolar-sl make $c $d $i $j]
                lappend tiles [socolar-rr make $j $a $b $c]
                lappend tiles [socolar-rl make $e $f $i $d]
                lappend tiles [socolar-hr make $g $h $a $j $i $f]
            }
        }
    }
    
    # subdivide a socolar tiling
    proc socolar-subdivide {tiles partials} {
        variable scale-square-edge-to-center
        variable rotate-square-edge-to-center
        variable rotate-hex-edge-to-corner
        set newt {};
        foreach tile $tiles {
            # code for right handed parent unless flip
            switch [tile-type $tile] {
                socolar-hr -
                socolar-sr -
                socolar-rr {
                    set flip 0
                }
                socolar-hl -
                socolar-sl -
                socolar-rl {
                    set flip 1
                }
            }
            # deflate
            switch [tile-type $tile] {
                socolar-hl -
                socolar-hr {
                    pset type a b c d e f $tile
                    # socolar hexagon subdivides into 4 hexagons, 6 squares,
                    # 12 rhombs, parts of 6 hexagons, and parts of 12 squares.
                    #
                    # every hex has three square neighbors which are symmetrically
                    # disposed on every other edge and three rhomb neighbors which
                    # fill the other three edges but are always asymmetric.
                    # 
                    # the core of the hexagon subdivision is a hexagon suspended
                    # in the center with squares on the edges which face toward
                    # the rhomb neighbors, and rhombs from the corners of these
                    # new squares to the corners of the old hexagon.
                    # between the square and its two rhombic struts are a part
                    # hexagon and two part squares which cross into the old rhomb
                    # on that edge of the old hexagon.
                    #
                    # so the hexagon must be coded as having squares adjacent to the
                    # odd or even edges, and perhaps also coding where the rhombs
                    # point.
                    #
                    
                    set C [vscale [expr {1.0/6.0}] [vadd $a [vadd $b [vadd $c [vadd $d [vadd $e $f]]]]]]
                    
                    # assume that a-b has a square on it, then a1-b1 should be rotated
                    pset b1 c1 b2 c2 b3a b3b c3a c3b [socolar-hex-piece $C $c $d]
                    pset d1 e1 d2 e2 d3a d3b e3a e3b [socolar-hex-piece $C $e $f]
                    pset f1 a1 f2 a2 f3a f3b a3a a3b [socolar-hex-piece $C $a $b]
                    set a4 [socolar-square-prior-vertex $a3b $b]
                    set c4 [socolar-square-prior-vertex $c3b $d]
                    set e4 [socolar-square-prior-vertex $e3b $f]
                    set b4 [socolar-square-next-vertex $c $b3a]
                    set d4 [socolar-square-next-vertex $e $d3a]
                    set f4 [socolar-square-next-vertex $a $f3a]
                    
                    if {$flip} {
                        lappend newt [socolar-hr make $e1 $f1 $a1 $b1 $c1 $d1]; # might want to rotate for rhomb coding
                    } else {
                        lappend newt [socolar-hl make $a1 $b1 $c1 $d1 $e1 $f1]; # might want to rotate for rhomb coding
                    }
                    lappend newt [socolar-sl make $b2 $c2 $c1 $b1]
                    lappend newt [socolar-sr make $d2 $e2 $e1 $d1]
                    if {$flip} {
                        lappend newt [socolar-sl make $f2 $a2 $a1 $f1]
                    } else {
                        lappend newt [socolar-sr make $f2 $a2 $a1 $f1]
                    }
                    lappend newt [socolar-rr make $b3b $b2 $b3a $c]
                    lappend newt [socolar-rl make $c3b $c2 $c3a $d]
                    lappend newt [socolar-rr make $d3b $d2 $d3a $e]
                    lappend newt [socolar-rl make $e3b $e2 $e3a $f]
                    lappend newt [socolar-rr make $f3b $f2 $f3a $a]
                    lappend newt [socolar-rl make $a3b $a2 $a3a $b]
                    
                    # partial hexagons, three edges
                    socolar-finish-hexagon-from-three-edges newt hash $e3a $e2 $d2 $d3b hr 0 "hex e2-d2"
                    if {$flip} {
                        socolar-finish-hexagon-from-three-edges newt hash $a3a $a2 $f2 $f3b hl 2 "hex a2-f2 flipped"
                    } else {
                        socolar-finish-hexagon-from-three-edges newt hash $a3a $a2 $f2 $f3b hr 0 "hex a2-f2 unflipped"
                    }
                    socolar-finish-hexagon-from-three-edges newt hash $c3a $c2 $b2 $b3b hl 2 "hex c2-b2"
                    
                    # partial hexagons, one edge
                    socolar-finish-hexagon-from-edge newt hash $b4 $a4 hr 2 "hex b4-a4"
                    if {$flip} {
                        socolar-finish-hexagon-from-edge newt hash $d4 $c4 hl 4 "hex d4-c4 flipped"
                    } else {
                        socolar-finish-hexagon-from-edge newt hash $d4 $c4 hr 2 "hex d4-c4 unflipped"
                    }
                    socolar-finish-hexagon-from-edge newt hash $f4 $e4 hl 4 "hex f4-e4"
                    
                    # partial squares, two edges
                    socolar-finish-square-from-two-edges newt hash $a4 $a3b $b sr 1
                    socolar-finish-square-from-two-edges newt hash $c $b3a $b4 sl 0
                    socolar-finish-square-from-two-edges newt hash $c4 $c3b $d sr 1
                    socolar-finish-square-from-two-edges newt hash $e $d3a $d4 sl 0
                    socolar-finish-square-from-two-edges newt hash $e4 $e3b $f sr 1
                    socolar-finish-square-from-two-edges newt hash $a $f3a $f4 sl 0
                    # partial squares, one edge,
                    # orientation not specified in Socolar's deflation mapping
                    socolar-finish-square-from-edge newt hash $b3b $c
                    socolar-finish-square-from-edge newt hash $d3b $e
                    socolar-finish-square-from-edge newt hash $f3b $a
                    socolar-finish-square-from-edge newt hash $b $a3a
                    socolar-finish-square-from-edge newt hash $d $c3a
                    socolar-finish-square-from-edge newt hash $f $e3a
                    
                    # construct octagonal hole filling
                    # each gets two rhombs, a square, and a hexagon
                    # first has square toward b2 b3a
                    socolar-octagon-piece newt 0 $b1 $a1 $a2 $a3b $a4 $b4 $b3a $b2
                    # second has square toward d2 d3a, unless flipped
                    socolar-octagon-piece newt $flip $d1 $c1 $c2 $c3b $c4 $d4 $d3a $d2
                    # third has square toward e2 e3b
                    socolar-octagon-piece newt 1 $f1 $e1 $e2 $e3b $e4 $f4 $f3a $f2
                    
                    # error "dissection of [tile-type $tile] unimplemented";
                }
                socolar-rl -
                socolar-rr {
                    # socolar rhomb subdivides into three smaller rhombs,
                    # parts of 6 squares, and parts of 4 hexagons
                    # there's one small rhomb suspended across the short
                    # diagonal of the old rhomb, which establishes the
                    # scale of the inflation: old short rhomb diagonal = new
                    # long rhomb diagonal.  the remainder of the long
                    # diagonal is filled with two small rhombs and two
                    # squares: old long rhomb diagonal = new short rhomb
                    # diagonal + 2 new long rhomb diagonals + 2 new square
                    # diagonals.  The other 4 part squares are adjacent to the
                    # center rhomb.  The 4 part hexagons are adjacent to the
                    # center squares, the long diagonal rhombs, and the long
                    # diagonal squares.
                    #
                    # we create 6 new vertices inside the rhomb.
                    
                    # a and c are on short diagonal, b and d on long diagonal
                    pset type a b c d $tile
                    
                    # center
                    set C [vscale 0.25 [vadd $a [vadd $b [vadd $c $d]]]]
                    
                    pset b1 b2a b2b b3 [socolar-rhomb-piece $C $b]
                    pset d1 d2a d2b d3 [socolar-rhomb-piece $C $d]
                    
                    # the new center rhomb
                    if {$flip} {
                        lappend newt [socolar-rr make $b1 $c $d1 $a]
                    } else {
                        lappend newt [socolar-rl make $d1 $a $b1 $c]
                    }
                    # the towards b strut
                    if {$flip} {
                        lappend newt [socolar-rl make $b2a $b3 $b2b $b1]
                    } else {
                        lappend newt [socolar-rr make $b2a $b3 $b2b $b1]
                    }
                    # the towards d strut
                    if {$flip} {
                        lappend newt [socolar-rr make $d2a $d3 $d2b $d1]
                    } else {
                        lappend newt [socolar-rl make $d2a $d3 $d2b $d1]
                    }
                    # leftover squares at the tips
                    if {$flip} {
                        socolar-finish-square-from-diagonal newt hash $b $b3 sl 0
                    } else {
                        socolar-finish-square-from-diagonal newt hash $b $b3 sr 3
                    }
                    if {$flip} {
                        socolar-finish-square-from-diagonal newt hash $d $d3 sr 3
                    } else {
                        socolar-finish-square-from-diagonal newt hash $d $d3 sl 0
                    }
                    # leftover squares in the waist
                    socolar-finish-square-from-two-edges newt hash $d2a $d1 $c sr 1
                    socolar-finish-square-from-two-edges newt hash $a $d1 $d2b sl 0
                    socolar-finish-square-from-two-edges newt hash $b2a $b1 $a sr 1
                    socolar-finish-square-from-two-edges newt hash $c $b1 $b2b sl 0
                    
                    # leftover hexagons
                    socolar-finish-hexagon-from-edge newt hash $d2b $d3 hr 2 "rhomb d2b-d3"
                    socolar-finish-hexagon-from-edge newt hash $d3 $d2a hl 4 "rhomb d3-d2a"
                    socolar-finish-hexagon-from-edge newt hash $b2b $b3 hr 2 "rhomb b2b-b3"
                    socolar-finish-hexagon-from-edge newt hash $b3 $b2a hl 4 "rhomb b3-b2a"
                    # error "dissection of [tile-type $tile] unimplemented";
                }
                socolar-sl -
                socolar-sr {
                    # socolar square subdivides into a square, 4 rhombs,
                    # parts of 8 squares, and parts of 4 hexagons
                    # the new square is suspended in the center of the old
                    # square with a new rhomb joining each corner of the new
                    # square to a corner of the old square.  The 4 part hexagons
                    # are adjacent to one edge of the square and an edge of each
                    # of the diagonal rhombs.  The 8 part squares are tucked
                    # between the diagonal rhombs and the part hexagons.
                    #
                    # we create 12 new vertices inside the square.
                    
                    pset type a b c d $tile
                    
                    # center
                    set C [vscale 0.25 [vadd $a [vadd $b [vadd $c $d]]]]
                    
                    # strut towards a
                    pset a1 a2a a2b [socolar-square-piece $C $a]
                    lappend newt [socolar-rr make $a2b $a1 $a2a $a]
                    
                    # strut towards b
                    pset b1 b2a b2b [socolar-square-piece $C $b]
                    lappend newt [socolar-rl make $b2b $b1 $b2a $b]
                    
                    # strut towards c
                    pset c1 c2a c2b [socolar-square-piece $C $c]
                    lappend newt [socolar-rl make $c2b $c1 $c2a $c]
                    
                    # strut towards d
                    pset d1 d2a d2b [socolar-square-piece $C $d]
                    lappend newt [socolar-rr make $d2b $d1 $d2a $d]
                    
                    # center square
                    if {$flip} {
                        lappend newt [socolar-sl make $a1 $b1 $c1 $d1]
                    } else {
                        lappend newt [socolar-sr make $a1 $b1 $c1 $d1]
                    }
                    
                    # partial hexagons
                    socolar-finish-hexagon-from-three-edges newt hash $a2a $a1 $d1 $d2b hr 0 "sq a1-d1"
                    if {$flip} {
                        socolar-finish-hexagon-from-three-edges newt hash $b2a $b1 $a1 $a2b hl 2 "sq b1-a1 flipped"
                    } else {
                        socolar-finish-hexagon-from-three-edges newt hash $b2a $b1 $a1 $a2b hr 0 "sq b1-a1 unflipped"
                    }
                    socolar-finish-hexagon-from-three-edges newt hash $c2a $c1 $b1 $b2b hl 2 "sq c1-b1"
                    if {$flip} {
                        socolar-finish-hexagon-from-three-edges newt hash $d2a $d1 $c1 $c2b hr 0 "sq d1-c1 flipped"
                    } else {
                        socolar-finish-hexagon-from-three-edges newt hash $d2a $d1 $c1 $c2b hl 2 "sq d1-c1 unflipped"
                    }
                    
                    # partial squares
                    # orientation not specified in Socolar's mapping
                    socolar-finish-square-from-edge newt hash $a $a2a
                    socolar-finish-square-from-edge newt hash $b $b2a
                    socolar-finish-square-from-edge newt hash $c $c2a
                    socolar-finish-square-from-edge newt hash $d $d2a
                    socolar-finish-square-from-edge newt hash $a2b $a
                    socolar-finish-square-from-edge newt hash $b2b $b
                    socolar-finish-square-from-edge newt hash $c2b $c
                    socolar-finish-square-from-edge newt hash $d2b $d
                }
                default {
                    error "found tile of type [tile-type $tile]";
                }
            }
        }
        if {$partials} {
            foreach h [array names hash] {
                switch [lindex $hash($h) 0] {
                    se {
                        if {0} {
                            # don't know how to build it
                            # one square edge
                            pset t a b $hash($h)
                            set c [socolar-square-next-vertex $a $b]
                            set d [socolar-square-next-vertex $b $c]
                            switch $de {
                                0 { lappend newt [socolar-$st make $a $b $c $d] }
                                1 { lappend newt [socolar-$st make $b $c $d $a] }
                                2 { lappend newt [socolar-$st make $c $d $a $b] }
                                3 { lappend newt [socolar-$st make $d $a $b $c] }
                                default { error "invalid de $de" }
                            }
                        }
                    }
                    sese {
                        if {0} {
                            # insufficient information to build
                        }
                    }
                    see {
                        # two square edges
                        pset t a b c st de $hash($h)
                        set d [socolar-square-next-vertex $b $c]
                        switch $de {
                            0 { lappend newt [socolar-$st make $a $b $c $d] }
                            1 { lappend newt [socolar-$st make $b $c $d $a] }
                            2 { lappend newt [socolar-$st make $c $d $a $b] }
                            3 { lappend newt [socolar-$st make $d $a $b $c] }
                            default { error "invalid de $de" }
                        }
                    }
                    sd {
                        # square diagonal
                        pset t a c st de $hash($h)
                        set C [socolar-square-center-from-diagonal $a $c]
                        set d [vadd $a [vscale [expr {1.0/${scale-square-edge-to-center}}] \
                                            [vrotate ${rotate-square-edge-to-center} [vsub $C $a]]]]
                        set b [vadd $C [vsub $C $d]]
                        switch $de {
                            0 { lappend newt [socolar-$st make $a $b $c $d] }
                            1 { lappend newt [socolar-$st make $b $c $d $a] }
                            2 { lappend newt [socolar-$st make $c $d $a $b] }
                            3 { lappend newt [socolar-$st make $d $a $b $c] }
                            default { error "invalid de $de" }
                        }
                    }
                    he {
                        # one hex edge
                        pset t a b ht de $hash($h)
                        set c [vadd $b [vrotate ${rotate-hex-edge-to-corner} [vsub $b $a]]]
                        set d [vadd $c [vrotate ${rotate-hex-edge-to-corner} [vsub $c $b]]]
                        set e [vadd $d [vrotate ${rotate-hex-edge-to-corner} [vsub $d $c]]]
                        set f [vadd $e [vrotate ${rotate-hex-edge-to-corner} [vsub $e $d]]]
                        switch $de {
                            0 { lappend newt [socolar-$ht make $a $b $c $d $e $f] }
                            1 { lappend newt [socolar-$ht make $b $c $d $e $f $a] }
                            2 { lappend newt [socolar-$ht make $c $d $e $f $a $b] }
                            3 { lappend newt [socolar-$ht make $d $e $f $a $b $c] }
                            4 { lappend newt [socolar-$ht make $e $f $a $b $c $d] }
                            5 { lappend newt [socolar-$ht make $f $a $b $c $d $e] }
                            default { error "invalid de $de" }
                        }
                    }
                    heee {
                        # three hex edges
                        pset t a b c d ht de $hash($h)
                        set e [vadd $d [vrotate ${rotate-hex-edge-to-corner} [vsub $d $c]]]
                        set f [vadd $e [vrotate ${rotate-hex-edge-to-corner} [vsub $e $d]]]
                        switch $de {
                            0 { lappend newt [socolar-$ht make $a $b $c $d $e $f] }
                            1 { lappend newt [socolar-$ht make $b $c $d $e $f $a] }
                            2 { lappend newt [socolar-$ht make $c $d $e $f $a $b] }
                            3 { lappend newt [socolar-$ht make $d $e $f $a $b $c] }
                            4 { lappend newt [socolar-$ht make $e $f $a $b $c $d] }
                            5 { lappend newt [socolar-$ht make $f $a $b $c $d $e] }
                            default { error "invalid de $de" }
                        }
                    }
                    default {
                        error "socolar-make completing partials found $hash($h)"
                    }
                }
                unset hash($h)
            }
        }
        return $newt;
    }
    
    # make a socolar tiling from the given seed
    proc socolar-make {tiles divide partials} {
        if {$divide == 0} {
            return [list socolar $tiles];
        } else {
            return [list socolar [socolar-subdivide $tiles $partials]]
        }
    }
        
    #
    # convert socolar to plate.
    # 
    proc socolar-to-plate {tiles partials} {
        # The correspondance between Socolar and Plate is obvious - the rhombs
        # are one-to-one with the rhombs, the squares are one-to-one with the
        # octahedra, and the hexagons are one-to-one with the plates, too.
        # And the construction is simple, too.  The hexagon edges are alternately
        # punched out
        set s [expr {0.5*tan([radians 15])}]; # punch out/in for unit edge vector
        set r [vrotate-make [radians 90]]; # rotation of edge vector to outward normal
        set newt {}
        foreach tile $tiles {
            switch [tile-type $tile] {
                socolar-rl -
                socolar-rr {
                    # punch in from 1st and 3rd midpoints (or 2nd and 4th) for new
                    # 2nd and 4th vertices.
                    pset type a b c d $tile
                    set b [vadd [vmidpoint $a $b] [vscale -$s [vrotate $r [vsub $b $a]]]]
                    set d [vadd [vmidpoint $c $d] [vscale -$s [vrotate $r [vsub $d $c]]]]
                    lappend newt [plate-4[string index $type end] make $a $b $c $d]
                }
                socolar-sl -
                socolar-sr {
                    # punch out each edge to make an octagon
                    pset type a b c d $tile
                    # midpoints of edges
                    set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                    set bc [vadd [vmidpoint $b $c] [vscale $s [vrotate $r [vsub $c $b]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                    set da [vadd [vmidpoint $d $a] [vscale $s [vrotate $r [vsub $a $d]]]]
                    lappend newt [plate-8[string index $type end] make $a $ab $b $bc $c $cd $d $da]
                }
                socolar-hl -
                socolar-hr {
                    # punch edges alternately out and in to make a dodecagon
                    pset type a b c d e f $tile
                    set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                    set bc [vadd [vmidpoint $b $c] [vscale -$s [vrotate $r [vsub $c $b]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                    set de [vadd [vmidpoint $d $e] [vscale -$s [vrotate $r [vsub $e $d]]]]
                    set ef [vadd [vmidpoint $e $f] [vscale $s [vrotate $r [vsub $f $e]]]]
                    set fa [vadd [vmidpoint $f $a] [vscale -$s [vrotate $r [vsub $a $f]]]]
                    lappend newt [plate-12[string index $type end] make $a $ab $b $bc $c $cd $d $de $e $ef $f $fa]
                }
                default {
                    error "found tile of type [tile-type $tile]";
                }
            }
        }
        return $newt
    }
    
    #
    # convert socolar to wheel
    # 
    proc socolar-to-wheel {tiles partials} {
        # this is easy.  the odd (1 3 5) midpoints of the hexagon punch out to the
        # center of the adjacent square.  the even (0 2 4) midpoints punch in by
        # the same amount.  the midpoints of the rhomb all punch out by the same
        # amount.
        #
        # small problem, because the square disappears and because I haven't found
        # a dirt cheap way of filling in holes with the correct tiles, I can't get
        # back to the socolar tile from the wheel.  I suppose I could put a little
        # diamond tile into the place of the square
        set s 0.5;                      # punch out/in scale as fraction of edge length
        set r [vrotate-make [radians 90]]; # rotation of edge to make out facing normal 
        set newt {}
        foreach tile $tiles {
            switch [tile-type $tile] {
                socolar-rl -
                socolar-rr {
                    pset type a b c d $tile
                    set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                    set bc [vadd [vmidpoint $b $c] [vscale $s [vrotate $r [vsub $c $b]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                    set da [vadd [vmidpoint $d $a] [vscale $s [vrotate $r [vsub $a $d]]]]
                    lappend newt [wheel-8[string index $type end] make $a $ab $b $bc $c $cd $d $da]
                }
                socolar-sl -
                socolar-sr {
                    # nothing to do, the squares get eaten by the other tiles
                }
                socolar-hl -
                socolar-hr {
                    pset type a b c d e f $tile
                    set ab [vadd [vmidpoint $a $b] [vscale -$s [vrotate $r [vsub $b $a]]]]
                    set bc [vadd [vmidpoint $b $c] [vscale $s [vrotate $r [vsub $c $b]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale -$s [vrotate $r [vsub $d $c]]]]
                    set de [vadd [vmidpoint $d $e] [vscale $s [vrotate $r [vsub $e $d]]]]
                    set ef [vadd [vmidpoint $e $f] [vscale -$s [vrotate $r [vsub $f $e]]]]
                    set fa [vadd [vmidpoint $f $a] [vscale $s [vrotate $r [vsub $a $f]]]]
                    lappend newt [wheel-12[string index $type end] make $a $ab $b $bc $c $cd $d $de $e $ef $f $fa]
                }
                default {
                    error "found tile of type [tile-type $tile]";
                }
            }
        }
        return $newt
    }
    
    #
    # convert socolar to shield
    # 
    proc socolar-to-shield {tiles partials} {
        # 1) each hexagon punches midpoints out/in
        # 2) each square punches midpoints out
        # 3) each rhomb punches two midpoints in

        set s 0.133974596216;           # scale to punch in/out
        set r [vrotate-make [radians 90]]; # rotation of edge to outward normal
        set tr [vrotate-make [radians -120]]; # rotation of edge to next triangle edge
        set newt {}
        foreach tile $tiles {
            switch [tile-type $tile] {
                socolar-rl -
                socolar-rr {
                    # the rhomb dissolves into triangles, but the triangles
                    # must encode the type of the rhomb to be recovered
                    pset type a b c d $tile
                    # the spine edge is a punch in 
                    set ab [vadd [vmidpoint $a $b] [vscale -$s [vrotate $r [vsub $b $a]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale -$s [vrotate $r [vsub $d $c]]]]
                    # note the triangles
                    set o [string index $type end]
                    set x [expr {[string equal $o l] ? {r} : {l}}]
                    lappend triangles([vertex-hash $a]) type shield-3$o edge [list $ab $cd]
                    lappend triangles([vertex-hash $c]) edge [list $cd $ab]
                }
                socolar-sl -
                socolar-sr {
                    # the square becomes a square surrounded by triangles
                    pset type a b c d $tile
                    # construct the square
                    set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                    set bc [vadd [vmidpoint $b $c] [vscale $s [vrotate $r [vsub $c $b]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                    set da [vadd [vmidpoint $d $a] [vscale $s [vrotate $r [vsub $a $d]]]]
                    lappend newt [shield-4[string index $type end] make $ab $bc $cd $da]
                    # note the triangles
                    lappend triangles([vertex-hash $a]) edge [list $ab $da]
                    lappend triangles([vertex-hash $b]) edge [list $bc $ab]
                    lappend triangles([vertex-hash $c]) edge [list $cd $bc]
                    lappend triangles([vertex-hash $d]) edge [list $da $cd]
                }
                socolar-hl -
                socolar-hr {
                    # the hexagon becomes a shield surrounded by triangles
                    pset type a b c d e f $tile
                    # construct the hexagonal shield
                    set ab [vadd [vmidpoint $a $b] [vscale $s [vrotate $r [vsub $b $a]]]]
                    set bc [vadd [vmidpoint $b $c] [vscale -$s [vrotate $r [vsub $c $b]]]]
                    set cd [vadd [vmidpoint $c $d] [vscale $s [vrotate $r [vsub $d $c]]]]
                    set de [vadd [vmidpoint $d $e] [vscale -$s [vrotate $r [vsub $e $d]]]]
                    set ef [vadd [vmidpoint $e $f] [vscale $s [vrotate $r [vsub $f $e]]]]
                    set fa [vadd [vmidpoint $f $a] [vscale -$s [vrotate $r [vsub $a $f]]]]
                    if {[catch {lappend newt [shield-6[string index $type end] make $ab $bc $cd $de $ef $fa]} error]} {
                        puts "error generating shield-6, $error"
                        set t [shield-6[string index $type end] just-make $ab $bc $cd $de $ef $fa] 
                        puts "prototype interior angles [shield-6l interior-angles-degrees]"
                        puts "made interior angles [tile-interior-angles-degrees $t]"
                        puts "prototype vertices [shield-6l vertices]"
                        puts "made vertices [tile-vertices $t]"
                        exit 1
                    }
                    # note the triangles
                    lappend triangles([vertex-hash $a]) edge [list $ab $fa]
                    lappend triangles([vertex-hash $b]) edge [list $bc $ab]
                    lappend triangles([vertex-hash $c]) edge [list $cd $bc]
                    lappend triangles([vertex-hash $d]) edge [list $de $cd]
                    lappend triangles([vertex-hash $e]) edge [list $ef $de]
                    lappend triangles([vertex-hash $f]) edge [list $fa $ef]
                }
                default {
                    error "found tile of type [tile-type $tile]";
                }
            }
        }
        # finish the triangles
        foreach v [array names triangles] {
            catch {array unset vals}
            # this moves the edge that follows the type spec into first position 
            if {[lsearch $triangles($v) type] > 0} {
                set triangles($v) [list-roll-left $triangles($v) [lsearch $triangles($v) type]]
            }
            foreach {name value} $triangles($v) { lappend vals($name) $value }
            if { ! [info exists vals(edge)]} { continue }
            if {[llength $vals(edge)] < 1 || [llength $vals(edge)] > 3} { error "invalid number of edges in triangle" }
            if {[info exists vals(type)]} {
                if {[llength $vals(type)] != 1} { error "multiple type definitions for triangle?" }
                set type [lindex $vals(type) 0]
            } else {
                set type shield-3
            }
            if {[llength $vals(edge)] < 3 && $partials == 0} { continue }
            set e1 [lindex $vals(edge) 0]
            pset a b $e1
            set c [vadd $b [vrotate $tr [vsub $b $a]]]
            lappend newt [$type make $a $b $c]
        }
        return $newt
    }

}



#
# these routines allow you to renumber the edges so that the left and right
# hand tiles increase edge numbers in different directions and start with
# the arrow distinguished tile.
#
proc socolar-edge-rename-all {atlasget} {
    # rename the edges to preserve mirror symmetry in tiles
    set newa {}
    foreach {name value} $atlasget {
        pset e1 e2 $name
        lappend newa [list [socolar-edge-rename $e1] [socolar-edge-rename $e2]] $value
    }
    return $newa
}

proc socolar-edge-rename {e} {
    pset t n [split $e -]
    switch $t {
        hl { return $e }
        sl { return $e }
        rl { return $e }
        hr { return $t-[expr {(6-$n)%6}] }
        sr { return $t-[expr {(4-$n)%4}] }
        rr { return $t-[expr {(4-$n+1)%4}] }
        default { error "found edge $e" }
    }
}

