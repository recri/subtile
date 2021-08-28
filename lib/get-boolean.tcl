#
# Translate a boolean value to integer
#
proc get-boolean {val} {
    switch -exact -- $val {
	t - true - 1 - on {
	    return 1;
	}
	f - false - 0 - off {
	    return 0;
	}
	default {
	    error "$val is not a boolean value";
	}
    }
}

#
# Translate an extended boolean value and the current
# value into an integer.
#
proc merge-boolean {val curval} {
    if {"$val" == "!"} {
	return [expr ! $curval];
    } else {
	return [get-boolean $val];
    }
}

