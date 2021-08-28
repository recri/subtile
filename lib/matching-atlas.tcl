namespace eval ::matching-atlas:: {

    #
    # given the start of a vertex key, return the shifts
    # of the completed vertex key which match the start
    #
    proc vertex-key-match {key initial} {
        set nk [llength $key]
        set m {}
        for {set k 0} {$k < $nk} {incr k} {
            if {[string first $initial [list-roll-left $key $k]] == 0} {
                lappend m $k
            }
        }
        return $m
    }
    
    #
    # return whether k1 is followed by k2 in the vertex key
    #
    proc vertex-key-successor {vkey k1 k2} {
        if {[string first [concat $k1 $k2] $vkey] == 0} {
            return 1
        } else {
            return 0
        }
    }
    
    #
    # find the vertex at offset o from vertex v
    #
    proc vertex-offset {v o} {
        upvar tile tile
        foreach t $tile(tiles) {
            set i [lsearch -exact $tile($t) $v]
            if {$i >= 0} {
                set n [llength $tile($t)]
                return [lindex $tile($t) [expr {($i+$o+$n)%$n}]]
            }
        }
        error "no predecessor for $v found"
    }
    
    #
    # find the vertex predecessor of v
    #
    proc vertex-predecessor {v} {
        upvar tile tile
        return [vertex-offset $v -1]
    }
    
    #
    # find the vertex successor of v
    #
    proc vertex-successor {v} {
        upvar tile tile
        return [vertex-offset $v 1]
    }
    
    #
    # decide if the edge leaving v1 can lie adjacent to the
    # edge leaving v2
    #
    proc vertex-edge-complement {v1 v2} {
        upvar tile tile
        foreach e $tile(equiv-edge) {
            if {[lsearch $e $v1] >= 0} {
                set e1 $e
            }
            if {[lsearch $e $v2] >= 0} {
                set e2 $e
            }
        }
        if {[string equal $e1 $e2]} {
            return 0
        } else {
            return 1
        }
    }
    
    #
    # generate the valid vertex successor table
    #
    proc vertex-valid-successor-generate {} {
        upvar tile tile atlas atlas vsucc vsucc
        foreach v1 $tile(vertices) {
            set vsucc($v1) {}
            foreach offset [vertex-key-match $tile(vertex-key) $tile($v1)] {
                foreach v2 $tile(vertices) {
                    if {[lsearch $vsucc($v1) $v2] >= 0} {
                        continue
                    }
                    if { ! [vertex-edge-complement $v1 [vertex-predecessor $v2]]} {
                        continue
                    }
                    if { ! [vertex-key-successor [list-roll-left $tile(vertex-key) $offset] $tile($v1) $tile($v2)]} {
                        continue
                    }
                    lappend vsucc($v1) $v2
                }
            }
        }
    }
    
    #
    # choose a canonical rotation of the vertex config
    #
    proc vertex-canonical-config {vs} {
        foreach v $vs {
            lappend configs $vs
            set vs [list-roll-left $vs 1]
        }
        return [lindex [lsort $configs] 0]
    }
    #
    # recursively accumulate the allowed tiles at a vertex
    # and record the complete patterns found
    #
    proc vertex-valid-config-generate {vkey vs ks} {
        upvar tile tile atlas atlas vsucc vsucc
        if {[llength $ks] == [llength $vkey]} {
            # puts "vertex-valid-config-generate {$vkey} {$vs} {$ks} found {$vs}"
            set vs [vertex-canonical-config $vs]
            # set atlas([vertex-canonical-config $vs]) {}
            foreach v $vs {
                if { ! [info exists atlas($v)] || [lsearch $atlas($v) $vs] < 0} {
                    lappend atlas($v) $vs
                }
            }
        } else {
            # puts "vertex-valid-config-generate {$vkey} {$vs} {$ks} searches {$vsucc([lindex $vs end])}"
            foreach v $vsucc([lindex $vs end]) {
                set nks [concat $ks $tile($v)]
                set nvs [concat $vs [list $v]]
                if {[string first $nks $vkey] != 0} {
                    # puts "valid successor did not lead to valid vertex {$nvs} {$nks}"
                } elseif {[llength $nks] > [llength $vkey]} {
                    puts "valid successor overfilled vertex {$nvs} {$nks}"
                } else {
                    vertex-valid-config-generate $vkey $nvs $nks
                }
            }
        }
    }
    
    #
    # generate the set of valid vertex configurations
    #
    proc vertex-valid-generate {} {
        upvar tile tile atlas atlas vsucc vsucc
        foreach v1 $tile(vertices) {
            foreach offset [vertex-key-match $tile(vertex-key) $tile($v1)] {
                vertex-valid-config-generate [list-roll-left $tile(vertex-key) $offset] [list $v1] $tile($v1)
            }
        }
    }
    
    proc report-array-contents {title aname} {
        upvar $aname array
        puts "[array size array] $title"
        foreach v [lsort [array names array]] { puts "$v -> $array($v)" }
    }
    proc report-array-lengths {title aname} {
        upvar $aname array
        puts "[array size array] $title"
        foreach v [lsort [array names array]] { puts "$v -> [llength $array($v)]" }
    }
}    
#
# generate the legal vertex configurations from
# the definitions above
#
proc matching-atlas-generate {tilename vsuccname atlasname} {
    upvar \#0 $tilename tile
    upvar \#0 $atlasname atlas
    ::matching-atlas::vertex-valid-successor-generate
    ::matching-atlas::vertex-valid-generate
}

