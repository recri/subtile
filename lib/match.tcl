namespace eval ::match:: {

    proc print-vertex {vx} {
        foreach r $vx {
            pset i t $r
            lappend vsum [tile-label $t]-$i
        }
        puts $vsum
    }

    # see if the tiles incident at this point cover the circle around the point
    proc vertex-complete {recs} {
        set covered 0
        foreach r $recs {
            pset i tile $r
            # i is the index of the vertex in the tile that is incident at this point
            # tile is the tile incident at this point
            set covered [expr {$covered+[tile-interior-angle-positive-degrees $tile $i]}]
        }
        return [expr {abs($covered-360) < 0.1 ? 1 : 0}]
    }
            
    # put the tiles at the vertex into some order
    proc vertex-order {r1 r2} {
        pset i1 t1 $r1
        pset i2 t2 $r2
        set v1 [tile-edge-vector $t1 $i1]
        set v2 [tile-edge-vector $t2 $i2]
        set d [expr {[vangle $v1 {1 0}]-[vangle $v2 {1 0}]}]
        return [expr {$d < 0 ? -1 : ($d > 0 ? 1 : 0)}]
    }

    # convert the list of tiles at the vertex into a list
    # of tile type vertex index records that starts with
    # the tile under consideration
    proc vertex-config {i tile recs} {
        set j [lsearch $recs [list $i $tile]]
        if {$j < 0} {
            error "didn't find tile in vertex config records"
        }
        set c {}
        foreach r [list-roll-left $recs $j] {
            pset i t $r
            lappend c [tile-label $t]-$i
        }
        return $c
    }

    # convert the incomplete list of tiles at the vertex
    # into a list  of tile type vertex index records that
    # starts with the tile under consideration and interpolate
    # an asterisk where missing tiles occur
    proc vertex-incomplete-config {i tile recs} {
        set j -1
        set c {}
        set tol [expr {[vdist [tile-vertex $tile 0] [tile-vertex $tile 1]]/1000.0}]
        foreach r1 $recs r2 [list-roll-left $recs 1]  {
            pset i1 t1 $r1
            pset i2 t2 $r2
            if {$i == $i1 && [string equal $tile $t1]} {
                set j [llength $c]
            }
            lappend c [tile-label $t1]-$i1
            set v1p [tile-vertex-wrapped $t1 [expr {$i1-1}]]
            set v2n [tile-vertex-wrapped $t2 [expr {$i2+1}]]
            if { ! [vequal $v1p $v2n $tol]} {
                lappend c *
            }
        }
        if {$j < 0} {
            error "didn't find tile in vertex config records"
        }
        return [list-roll-left $c $j]
    }

    # convert a list of tiles, complete or incomplete, into a vertex configuration
    proc vertex-any-config {i t vx} {
        if {[vertex-complete $vx]} {
            return [vertex-config $i $t $vx]
        } else {
            return [vertex-incomplete-config $i $t $vx]
        }
    }

    # see if the tile has vertex configurations at all corners
    proc tile-complete {vname t} {
        upvar $vname vertex
        foreach v [tile-vertices $t] {
            if { ! [info exists vertex([vertex-hash $v])]} {
                return 0
            }
        }
        return 1
    }

    #
    # hash the vertices of a tiling to find holes
    #
    proc hash-tiling {hashname succname tiling} {
        upvar $hashname hash
        upvar $succname succ
        # hash all the vertices in the tiling
        foreach t $tiling {
            for {set i 0} {$i < [tile-size $t]} {incr i} {
                lappend hash([vertex-hash [tile-vertex $t $i]]) [list $i $t]
            }
        }
        # puts "hash has [array size hash] vertices"
        # remove the vertices which are completely surrounded by tiles
        foreach v [array names hash] {
            if {[vertex-complete $hash($v)]} {
                unset hash($v)
            }
        }
        # find the remaining neighbors of each remaining vertex
        # puts "hash has [array size hash] remaining vertices"
        foreach v [array names hash] {
            foreach r $hash($v) {
                pset i t $r
                set u [vertex-hash [tile-vertex-wrapped $t [expr {$i-1}]]]
                if {[info exists hash($u)]} {
                    lappend succ($v) $u
                    set hash($u) [lsort -command vertex-order $hash($u)]
                }
            }
        }
        # puts "succ has [array size succ] successor vertices"
        # at this point, any name in hash() is a vertex with at least one
        # missing tile incident to it, and succ() lists the adjacent
        # vertices with at least one missing tile incident.
    }

    proc printvert {vertname succname} {
        upvar $vertname vert
        upvar $succname succ
        foreach v [array names vert] {
            puts "succ($v) -> $succ($v)"
        }
    }

    #
    # find a loop of incomplete vertices
    #
    proc find-loop {vertname succname} {
        upvar $vertname vert
        upvar $succname succ
        # initialize loop vertex list
        set vs {}

        # pick an initial vertex and an initial edge
        set v0 [lindex [array names succ] 0]

        # find its successor
        set vn [lindex $succ($v0) 0]

        # start the loop lists
        lappend vs $v0 $vn

        # now go
        while {1} {
            set n [llength $vs]
            foreach v $succ($vn) {
                if {[vequal-exact $v $v0] && [llength $vs] > 2} {
                    # this closes the loop
                    return $vs
                } elseif {[lsearch $vs $v] > 0} {
                    # this link closes an internal loop
                    # forget what we were doing and return it
                    return [lrange $vs [lsearch $vs $v] end]
                } else {
                    # this is a good vertex to extend the loop with
                    lappend vs $v
                    set vn $v
                    break
                }
            }
            if {[llength $vs] == $n} {
                puts "failed to extend vertex list $vs"
                printvert vert succ
                error "failed to extend vertex list"
            }
        }
    }

    #
    # find all loops of incomplete vertices
    #
    proc find-loops {vertname succname} {
        upvar $vertname vert
        upvar $succname succ
        while {[array size succ]} {
            # puts "starting loop search on [array size vert] vertices"
            # printvert vert
            set vs [find-loop vert succ]
            # puts "found loop [llength $vs] vertices\nverts: $vs"
            foreach v $vs vn [list-roll-left $vs 1] {
                if { ! [info exists succ($v)]} {
                    error "succ($v) is gone?"
                } else {
                    set i [lsearch -exact $succ($v) $vn]
                    if {$i < 0} {
                        error "succ($v) doesn't contain next $vn!"
                    }
                    set succ($v) [lreplace $succ($v) $i $i]
                    if {[llength $succ($v)] == 0} {
                        unset succ($v)
                    }
                }
            }
            lappend loops $vs
            # puts "processed loop [llength $vs] vertices, [array size succ] vertices left"
        }
        # puts "[llength $loops] loops found"
        return $loops
    }
        
    #
    # discard the largest loop which is the exterior boundary
    #
    proc discard-largest {loops} {
        set l [lindex $loops 0]
        set ls {}
        foreach i [lrange $loops 1 end] {
            if {[llength $l] < [llength $i]} {
                lappend ls $l
                set l $i
            } else {
                lappend ls $i
            }
        }
        return $ls
    }

    #
    # discard all but the largest loop which is the exterior boundary
    #
    proc keep-largest {loops} {
        set l [lindex $loops 0]
        foreach i [lrange $loops 1 end] {
            if {[llength $l] < [llength $i]} {
                set l $i
            }
        }
        return [list $l]
    }

    proc keep-all {loops} {
        return $loops
    }

    proc atlas-configs {c} {
        upvar atlas atlas
        if {[string equal [lindex $c 0] *]} {
            set c [lrange $c 1 end]
        }
        if {[string equal [lindex $c end] *]} {
            set c [lrange $c 0 end-1]
        }
        set v0 [lindex $c 0]
        set configs {}
        foreach a $atlas($v0) {
            foreach u $c v [list-roll-left $a [lsearch $a $v0]] {
                if { ! [string match $u $v]} {
                    continue
                }
            }
            lappend configs $a
        }
        return $configs
    }

    #
    # match a loop against the atlas
    #
    proc match-loop {name vertexname atlasname loop} {
        upvar $vertexname vertex
        upvar $atlasname atlas
        puts "match-loop [llength $loop] vertices"
        set tiles {}
        foreach u [lrange $loop 0 end-2] v [lrange $loop 1 end-1] w [lrange $loop 2 end] {
            puts "match-loop $u $v $w"
            set t [make-tile-from-type-and-list-of-vertices unknown-tile [list $u $v $w]]
            # puts "tile-vertices $t -> [tile-vertices $t]"
            # puts "tile-size $t -> [tile-size $t]"
            set uc [lrange [vertex-any-config 0 $t [lsort -command vertex-order [concat $vertex($u) [list [list 0 $t]]]]] 1 end]
            set vc [lrange [vertex-any-config 1 $t [lsort -command vertex-order [concat $vertex($v) [list [list 1 $t]]]]] 1 end]
            set wc [lrange [vertex-any-config 2 $t [lsort -command vertex-order [concat $vertex($w) [list [list 2 $t]]]]] 1 end]
            # puts "vertex($u) -> $uc"
            # puts "vertex($v) -> $vc"
            # puts "vertex($w) -> $wc"
            set ua [atlas-configs $uc]
            set va [atlas-configs $vc]
            set wa [atlas-configs $wc]
            puts "vertex($u) -> $uc -> [llength $ua] atlas entries"
            puts "vertex($v) -> $vc -> [llength $va] atlas entries"
            puts "vertex($w) -> $wc -> [llength $wa] atlas entries"
            
        }
        return $tiles
    }
    
    proc match-loops {name vertexname atlasname loops} {
        upvar $vertexname vertex
        upvar $atlasname atlas
        set nloops {}
        foreach l $loops {
            foreach t [match-loop $name vertex atlas $l] {
                lappend nloops $t
            }
        }
        return $nloops
    }

    proc match {subtiling which-to-keep} {
        # split the subtiling into name and tiling
        pset name tiling $subtiling
        # get the tiling's atlas
        pset tilename vsuccname atlasname [$name-matching-atlas-setup] 
        upvar $tilename tile $vsuccname vsucc $atlasname atlas
        # hash the tiling onto vertices
        hash-tiling vertex successor $tiling
        # match the desired parts
        set loops [find-loops vertex successor]
        switch ${which-to-keep} {
            holes { set loops [discard-largest $loops] }
            border { set loops [keep-largest $loops] }
            all { }
        }
        set tiles [match-loops $name vertex atlas $loops]
        if {[llength $tiles]} {
            return [list $name [concat $tiling $tiles]]
        } else {
            return $subtiling
        }
    }
}

define-tile unknown-tile un {{0 1} {1 0} {0 -1} {-1 0}} 4

proc match-holes {subtiling} {
    return [::match::match $subtiling holes]
}
    
proc match-border {subtiling} {
    return [::match::match $subtiling border]
}
    
proc match-all {subtiling} {
    return [::match::match $subtiling all]
}
