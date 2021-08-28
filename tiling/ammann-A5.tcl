########################################################################
#
# the octagonal tiling - A5
#
namespace eval ::ammann-A5:: {
    set rl [make-tile-from-type-and-vertices ammann-A5-rl \
                [vmake 0 sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 2*sin(3*$Pi/8)]\
                [vmake 2*cos(3*$Pi/8) sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 0]\
               ]
    set rr [make-tile-from-type-and-vertices ammann-A5-rr \
                [vmake 0 sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 2*sin(3*$Pi/8)]\
                [vmake 2*cos(3*$Pi/8) sin(3*$Pi/8)]\
                [vmake cos(3*$Pi/8) 0]\
               ]
    set s [make-tile-from-type-and-vertices ammann-A5-s\
               [vmake 0 $Sqrt2/2]\
               [vmake $Sqrt2/2 $Sqrt2]\
               [vmake $Sqrt2 $Sqrt2/2]\
               [vmake $Sqrt2/2 0]\
              ]

    #
    # define the tiling
    #
    array set tile {
        comment {tiling name, tile list, vertex list, edge list}
        name ammann-A5
        tiles {rl rr s}
        vertices {rl-0 rl-1 rl-2 rl-3 rr-0 rr-1 rr-2 rr-3 s-0 s-1 s-2 s-3}
        edges {rl-0 rl-1 rl-2 rl-3 rr-0 rr-1 rr-2 rr-3 s-0 s-1 s-2 s-3}
        comment {tile vertex lists}
        rl {rl-0 rl-1 rl-2 rl-3}
        rr {rr-0 rr-1 rr-2 rr-3}
        s {s-0 s-1 s-2 s-3}
        comment {the vertex key equivalence classes}
        equiv-vertex {
            {rl-0 rr-0} {rl-1 rr-3}
            {rl-2 rr-2} {rl-3 rr-1}
            {s-0 s-1 s-2 s-3}
        }
        comment {the edge marking equivalence classes}
        equiv-edge {
            {rl-0 rl-2 rr-0 rr-2 s-0 s-3}
            {rl-1 rl-3 rr-1 rr-3 s-1 s-2}
        }
        comment {the key sequences at each vertex}
        rl-0 {k-1 k-0 k-0}
        rl-1 {k-0}
        rl-2 {k-1 k-1 k-0}
        rl-3 {k-1}
        rr-0 {k-1 k-0 k-0}
        rr-1 {k-1}
        rr-2 {k-1 k-1 k-0}
        rr-3 {k-0}
        s-0 {k-1 k-0}
        s-1 {k-1 k-0}
        s-2 {k-1 k-0}
        s-3 {k-1 k-0}
        comment {the complete vertex key sequence}
        vertex-key {k-0 k-1 k-0 k-1 k-1 k-0 k-1 k-0}
    }
}

define-tile ammann-A5-rl rl ${::ammann-A5::rl} 2 ammann-A5-decorate
define-tile ammann-A5-rr rr ${::ammann-A5::rr} 2 ammann-A5-decorate
define-tile ammann-A5-s s ${::ammann-A5::s} 1 ammann-A5-decorate

proc ammann-A5-matching-atlas-setup {} {
    if { ! [info exists ::ammann-A5::vertex-successors]} {
        matching-atlas-generate ::ammann-A5::tile ::ammann-A5::vertex-successors ::ammann-A5::atlas
    }
    return [list ::ammann-A5::tile ::ammann-A5::vertex-successors ::ammann-A5::atlas]
}

proc ammann-A5-decorate {tile w tags} {
    # the decorations are the little left/right turning arrow
    # the half arrow heads on the edges
    # and the vertex keys
    set id [tag-generate]
    set tags "$tags $id"
    set vs [tile-vertices $tile]
    set z [tile-center $tile]
    switch [tile-type $tile] {
        ammann-A5-rl {
            # left turn arrow from vertex 3 to edge 1-2
            tile-arrow $w $tags [lindex $vs 3] $z [vmidpoint [lindex $vs 1] [lindex $vs 2]]
            # edge matching half arrows
            tile-edge-half-arrow $w $tags $tile f r f r
            # vertex key pieces
            tile-vertex-part-arrow $w $tags $tile 0.1 \
                {1 90 1 135 sqrt(2)-1 270 1 90 1 90} \
                {1 90 1 135} \
                {1 90 1 90 1 270 sqrt(2)-1 135 1 90} \
                {sqrt(2) 135 1 90}
        }
        ammann-A5-rr {
            # right turn arrow from vertex 3 to edge 0-1
            tile-arrow $w $tags [lindex $vs 3] $z [vmidpoint [lindex $vs 0] [lindex $vs 1]]
            # edge matching half arrows
            tile-edge-half-arrow $w $tags $tile f r f r
            # vertex key pieces
            tile-vertex-part-arrow $w $tags $tile 0.1 \
                {1 90 1 135 sqrt(2)-1 270 1 90 1 90} \
                {sqrt(2) 135 1 90} \
                {1 90 1 90 1 270 sqrt(2)-1 135 1 90} \
                {1 90 1 135}
        }
        ammann-A5-s {
            # straight arrow from vertex 3 to vertex 1
            tile-arrow $w $tags [lindex $vs 3] $z [lindex $vs 1]
            # edge matching half arrows 
            tile-edge-half-arrow $w $tags $tile f r r f
            # vertex key pieces
            tile-vertex-part-arrow $w $tags $tile 0.1 \
                {1 90 1 90 1 90} \
                {1 90 1 90 1 90} \
                {1 90 1 90 1 90} \
                {1 90 1 90 1 90}
        }
    }
    return $id
}

set subtile(ammann-A5-ops-menu) \
    [list \
         {{About Amman Tilings} ammann-about} \
         {{Convert to triangles and rhomb} ammann-do-A5-dissect-to-A5T} \
        ];
set subtile(ammann-A5-start-menu) \
    [list \
         [list {Left Rhomb} [ammann-A5-rl tiling]] \
         [list {Right Rhomb} [ammann-A5-rr tiling]] \
         [list Square [ammann-A5-s tiling]] \
        ];

proc ammann-do-A5-dissect-to-A5T {tiles partial} {
    return [list ammann-A5T [ammann-A5-dissect-to-A5T $tiles $partial]];
}
proc ammann-A5-make {tiles divide partial} {
    if {$divide == 0} {
        return [list ammann-A5 $tiles];
    } else {
        return [list ammann-A5 [ammann-A5T-anneal-to-A5 \
                                    [ammann-A5T-dissect \
                                         [ammann-A5-dissect-to-A5T $tiles $partial] \
                                         $partial] \
                                    $partial]];
    }
}
proc ammann-A5-dissect-to-A5T {tiles partial} {
    set newt {};
    foreach t1 $tiles {
        pset type a b c d $t1
        switch -exact $type {
            ammann-A5-rl {
                lappend newt [ammann-A5T-rl make $a $b $c $d]
            }
            ammann-A5-rr {
                lappend newt [ammann-A5T-rr make $a $b $c $d]
            }
            ammann-A5-s {
                lappend newt [ammann-A5T-tL make $a $b $d]
                lappend newt [ammann-A5T-tR make $c $d $b]
            }
        }
    }
    return $newt;
}
