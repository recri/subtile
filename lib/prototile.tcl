namespace eval ::prototile:: {
    array set tiles {}
}

#
# a prototile defines the prototype of a tile
# type is the tile type name
# vertices are the vertices of the polygon
# label is the label string for the type
# arrow is a list of polyline coordinates
# markings is a list of polygon coordinate lists
#
proc make-prototile {type vertices label {arrow {}} {markings {}}} {
    upvar \#0 ::prototile::tile tile
    if {[info exists tile($type)]} {
        error "redefinition of prototile: $type"
    }
    set tile($type) [list $type $vertices $label $arrow $markings]
}

proc prototile-get {type} {
    upvar \#0 ::prototile::tile tile
    if {[info exists tile($type)]} {
        return $tile($type)
    }
    error "undefined prototile: $type"
}

proc prototile-vertices {type} {
    return [lindex [prototile-get $type] 1]
}

proc prototile-label {type} {
    return [lindex [prototile-get $type] 2]
}

proc prototile-arrow {type} {
    return [lindex [prototile-get $type] 3]
}

proc prototile-markings {type} {
    return [lindex [prototile-get $type] 4]
}
