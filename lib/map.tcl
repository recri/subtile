proc map {proc list} {
    set m {}
    foreach item $list {
        lappend m [$proc $item]
    }
    return $m
}

proc map2 {proc list1 list2} {
    set m {}
    foreach i1 $list1 i2 $list2 {
        lappend m [$proc $i1 $i2]
    }
    return $m
}