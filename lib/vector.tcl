#
set Pi [expr 4*atan(1)];

#
proc radians {degrees} { global Pi; return [expr {2*$Pi*$degrees/360.0}] }

#
proc degrees {radians} { global Pi; return [expr {360*$radians/(2*$Pi)}] }

proc positive-degrees {radians} { global Pi; return [expr {fmod(360+fmod(360*$radians/(2*$Pi),360),360)}] }

# unpack a 2d vector into components
proc vunpack {args} {
    foreach v $args {
        upvar $v u ${v}0 u0 ${v}1 u1;
        set u0 [lindex $u 0];
        set u1 [lindex $u 1];
    }
}

# pack two components into a 2d vector
proc vmake {u0 u1} { return [list [uplevel "expr $u0"] [uplevel "expr $u1"]] }

# add two 2d vectors
proc vadd {u v} { vunpack u v; return [vmake ($u0)+($v0) ($u1)+($v1)] }

# subtract two 2d vectors
proc vsub {u v} { vunpack u v; return [vmake ($u0)-($v0) ($u1)-($v1)] }

# scale a vector by a scalar factor
proc vscale {s u} { vunpack u; set s [uplevel "expr $s"]; return [vmake $s*($u0) $s*($u1)] }

# sum the 2d vectors supplied as arguments
proc vsum {args} { return [vsumlist $args] }

# sum a list of 2d vectors
proc vsumlist {l} {
    set u [vmake 0 0]
    vunpack u
    foreach v $l {
        vunpack v;
        append u0 +($v0);
        append u1 +($v1);
    }
    return [vmake $u0 $u1];
}

# compute the midpoint between two points
proc vmidpoint {a b} { return [vscale 0.5 [vadd $a $b]] }

# negate a vector
proc vneg {u} { return [vsub {0 0} $u] }

# random vector
proc vrandom {n} { return [vmake 2*$n*rand()-$n 2*$n*rand()-$n] }

# make a 2d rotation by angle a
proc vrotate-make {a} { return [vmake cos($a) sin($a)]; }

# apply a 2d rotation to a 2d vector
proc vrotate {r u} { vunpack r u; return [vmake ($r0)*($u0)-($r1)*($u1) ($r1)*($u0)+($r0)*($u1)] }

# make a 2d reflection in a line
proc vreflect-make {a b} { return [list $a [vnormalize [vsub $b $a]]] }

# normalize a vector
proc vnormalize {a} { return [vscale 1.0/[vlength $a] $a] }
 
# apply a reflection
proc vreflect {r c} {
    set a [lindex $r 0]
    set ab [lindex $r 1]
    set ac [vsub $c $a]
    set pac [vscale [vdot $ab $ac] $ab]
    set rac [vsub $ac $pac]
    return [vadd $a [vsub $pac $rac]]
}

# dot product of two 2d vectors
proc vdot {a b} { vunpack a b; return [expr {$a0*$b0 + $a1*$b1}] }

# cross product of two 2d vectors
proc vcross {a b} { vunpack a b; return [expr {$a0*$b1-$a1*$b0}] }

# angle between two vectors measured counter clockwise
proc vangle {a b} { return [expr {atan2([vcross $a $b], [vdot $a $b])}] }

# length of a vector
proc vlength {a} { return [expr {sqrt([vlength2 $a])}] }

# square length of vector
proc vlength2 {a} { return [vdot $a $a] }

# distance between two points
proc vdist {a b} { return [expr {sqrt([vdist2 $a $b])}] }

# square distance between two points
proc vdist2 {a b} { return [vlength2 [vsub $b $a]] }

# equality within tolerance
proc vequal {a b tol} { if {[vdist2 $a $b] <= $tol} { return 1 } else { return 0 } }

# equality with no tolerance
proc vequal-exact {a b} { vunpack a b; return [expr {$a0==$b0 && $a1==$b1}] }
