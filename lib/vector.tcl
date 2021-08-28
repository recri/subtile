# unpack a 2d vector into components
proc vunpack {args} {
    foreach v $args {
	upvar $v u ${v}0 u0 ${v}1 u1;
	set u0 [lindex $u 0];
	set u1 [lindex $u 1];
    }
}
# pack two components into a 2d vector
proc vmake {u0 u1} {
    return [list [uplevel "expr $u0"] [uplevel "expr $u1"]];
}
# add two 2d vectors
proc vadd {u v} {
    vunpack u v;
    return [vmake $u0+$v0 $u1+$v1];
}
# subtract two 2d vectors
proc vsub {u v} {
    vunpack u v;
    return [vmake $u0-$v0 $u1-$v1];
}
# scale a vector by a scalar factor
proc vscale {s u} {
    vunpack s u;
    return [vmake $s0*$u0 $s0*$u1];
}
# sum a list of 2d vectors
proc vsum {u args} {
    vunpack u;
    foreach v $args {
	vunpack v;
	append u0 +$v0;
	append u1 +$v1;
    }
    return [vmake $u0 $u1];
}
# negate a vector
proc vneg {u} {
    return [vsub {0 0} $u];
}
# make a 2d rotation by angle a
proc rmake {a} {
    return [vmake cos($a) sin($a)];
}
# apply a 2d rotation to a 2d vector
proc vrotate {r u} {
    vunpack r u;
    return [vmake $r0*$u0-$r1*$u1 $r1*$u0+$r0*$u1];
}
# dot product of two 2d vectors
proc vdot {a b} {
    vunpack a b;
    return [expr $a0*$b0 + $a1*$b1];
}
# cross product of two 2d vectors
proc vcross {a b} {
    vunpack a b;
    return [expr $a0*$b1-$a1*$b0];
}
# angle between two vectors measured counter clockwise
proc vangle {a b} {
    return [expr atan2([vcross $a $b], [vdot $a $b])];
}
# length of a vector
proc vlength {a} {
    return [expr sqrt([vdot $a $a])];
}

