proc vertex-atlas-tiling {tiling} {

    set ncw 0
    set nccw 0
    # create a map of tiles incident to each vertex
    foreach tile $tiling {
        # the tile type
        set type [tile-type $tile];
        # the first vertex
        set pj [tile-vertex $tile 0];
        # is this a clockwise tile
        set cw [clockwise-tile-p $tile];
        # from the 2nd to the last and on to the first
        # form the vector from pi to the previous vertex
        set vis {};                     # p
        set vijs {};                    # vector from vi to vj
        set is {};                      # index of vertex in tile
        foreach pi [concat [lrange [tile-vertices $tile] 1 end] [list $pj]] {
            # compute the edge vector
            set vij [vsub $pi $pj];
            # normalize to unit length
            set vij [vscale [expr 1/[vlength $vij]] $vij]
            # remember the edge vector
            lappend vijs $vij;
            # remember the vertices
            lappend vis $pi;
            # remember the vertex index in the tile
            lappend is [lsearch $tile $pi]
            # step to the next vertex
            set pj $pi;
        }
        # extend the vij list by the first
        lappend vijs [lindex $vijs 0];
        # make the list clockwise
        if { ! $cw } {
            # puts "ccw vertices $vijs"
            set vijs [lreverse $vijs];
            # puts "cw vertices $vijs"
            set vis [lreverse $vis];
            set is [lreverse $is]
            incr nccw
        } else {
            incr ncw
        }
        # now install the vertices
        for {set i 0} {$i < [llength $vis]} {incr i} {
            set vi [lindex $vis $i];    # the vertex
            set hi [vertex-hash $vi];   # the vertex in reduced precision for hashing
            set vij [lindex $vijs $i];  # edge leaving vertex
            set vik [vneg [lindex $vijs [expr $i+1]]]; # edge returning to vertex reversed
            set ang [expr {atan2([lindex $vij 1], [lindex $vij 0])}]; # angle of edge leaving vertex
            set cat [vertex-equivalence-class $type [lindex $is $i]]; # the vertex category
            lappend vertices($hi) [list $vij $vik $tile $ang $cat];
            #puts "[lindex $vis $i], cw? $cw,  [lindex $vijs $i] [vneg [lindex $vijs [expr $i+1]]]\n\t$tile"
        }
    }
    # puts "found [array size vertices] vertices"
    # puts "found $ncw cw tiles and $nccw ccw tiles"
    # for each vertex found, we have one record for each tile incident to that vertex
    foreach vertex [array names vertices] {
        # sort the records according to the angle at which they leave the vertex
        set vertices($vertex) [lsort -real -index 3 $vertices($vertex)]
        # eliminate vertices which are not interior
        if { ! [vertex-is-interior $vertices($vertex)]} {
            unset vertices($vertex)
        }
    }
    # puts "found [array size vertices] interior vertices"
    # match the tiles incident to the vertex
    # by their edge vectors
    foreach vertex [array names vertices] {
        # find the unique set of vertex patterns
        set key [vertex-atlas-key $vertices($vertex)]
        if { ! [info exists atlas($key)]} {
            set atlas($key) [vertex-atlas-tiles $vertices($vertex)]
        }
    }
    set tilings {}
    foreach key [lsort [array names atlas]] {
        lappend tilings [list $key $atlas($key)]
    }
    return $tilings;
}

# form a key to identify a vertex configuration
# it is the list of cat's around the vertex where
# a cat is the tile type identifier and the vertex index in the tile
proc vertex-atlas-key {vertex} {
    set key {}
    foreach item $vertex {
        pset vij vik tile ang cat $item;
        lappend key $cat
    }
    return [vertex-atlas-choose-key $key]
}

# form the list of tiles around a vertex
proc vertex-atlas-tiles {vertex} {
    set tiles {}
    foreach item $vertex {
        pset vij vik tile ang cat $item;
        lappend tiles $tile;
    }
    return $tiles
}

# choose the unique key for a vertex by forming
# the keys starting with each tile around the vertex
# and returning the one that sorts first
proc vertex-atlas-choose-key {key} {
    lappend list $key;
    for {set i 1} {$i < [llength $key]} {incr i} {
        lappend list [concat [lrange $key $i end] [lrange $key 0 [expr $i-1]]];
    }
    return [lindex [lsort $list] 0];
}

# test if a vertex is interior
proc vertex-is-interior {vertex} {
    # puts "[llength $vertex] item vertex"
    # to be an interesting interior vertex, there must be at least
    # three tiles meeting here
    if {[llength $vertex] < 3} {
        # puts "too few tiles"
        return 0
    }
    foreach item $vertex {
        pset vij vik tile ang $item;
        # puts "[format %.0f [expr {180*$ang/3.14159}]] {[vertex-hash $vij]} {[vertex-hash $vik]}"
    }
    # for this to be an interior vertex, there must be a returning edge
    # to match each departing edge
    foreach item $vertex {
        pset vij vik tile ang $item;
        if { ! [info exists vij0]} {
            set vij0 $vij
        }
        if {[info exists viki]} {
            if {abs([vangle $vij $viki]) > 0.001} {
                return 0
            }
        }
        set viki $vik
    }
    if {abs([vangle $vij0 $viki]) > 0.001} {
        return 0
    }
    return 1
}

#
# this is wrong, I should ask the tiling how to do this
# ah, let the tiling define the class
#
proc define-vertex-equivalence-class {tile n} {
    upvar \#0 vertex-atlas-vertex-equivalence-class class
    set class($tile) $n
    puts "warning: define-vertex-equivalence-class for $tile to be $n"
}
proc vertex-equivalence-class {tile vertex} {
    return $tile-[expr {$vertex%[$tile veq]}]
    #upvar \#0 vertex-atlas-vertex-equivalence-class class
    #if {[info exists class($tile)]} {
        #return $tile-[expr {$vertex%$class($tile)}]
    #} else {
        # puts "no vertex class for $tile"
        #return $tile-$vertex
    #}
}
