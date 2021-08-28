##
## useful routines for lists
##

##
## return the elements of list which are not elements of list2
##
proc list-difference {list1 list2} {
    set l {};
    foreach e $list1 {
	if {[lsearch $list2 $e] < 0} {
	    lappend l $e;
	}
    }
    return $l;
}

##
## return the list generated by repeating c n times.
##
proc lrepeat {c n} {
    set l 0;
    while {[incr n -1] >= 0} {
	lappend l $c;
    }
    return $l;
}

##
## return the list with the elements in reverse order
##
proc lreverse {list} {
    set nlist {};
    foreach e $list {
	set nlist [linsert $nlist 0 $e];
    }
    return $nlist;
}
