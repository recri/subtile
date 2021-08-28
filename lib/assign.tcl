proc pset {args} {
    set n [llength $args];
    set vals [lindex $args [incr n -1]];
    foreach name [lrange $args 0 [incr n -1]] {
	upvar $name var;
	set var [lindex $vals 0];
	set vals [lrange $vals 1 end];
    }
}

