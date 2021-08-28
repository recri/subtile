namespace eval ::tags:: {
    set tag -1
}

proc tag-generate {} {
    upvar \#0 ::tags::tag tag
    return tg[incr tag]
}
