#!/usr/bin/wish

#
# a program to compute and display fourier transforms of a point set
# in two dimensions.
#

#
# input data
#
set fourier(home) [file dirname [info script]]
set fourier(points) [split [read stdin] \n];
set fourier(npoints) [llength $fourier(points)]

#
# parameters for the user interface
#
set fourier(size) 256;
set fourier(size-menu) {16 32 64 128 256 512 1024};
set fourier(srange) 50;
set fourier(srange-menu) {200 150 100 90 80 70 60 50 40 30 20 10}
set fourier(brightness) 2;
set fourier(brightness-menu) {1 1.5 2 3 4 5 10 20 40 80 100 120}

#
# computed variables
#
set fourier(scale) [expr $fourier(brightness)*256.0];
set fourier(percent) 0;
set fourier(image) {};

#
# menubutton frame
#
pack [frame .m -border 2 -relief raised] -fill x;

#
# operations menu
#
pack [menubutton .m.o -text Operations -menu .m.o.m] -side left;
menu .m.o.m -tearoff no;
.m.o.m add command -label Fourier -command fourier
.m.o.m add separator
.m.o.m add command -label Quit -command {destroy .}

#
# parameter menu
#
pack [menubutton .m.p -text Parameters -menu .m.p.m] -side left
menu .m.p.m -tearoff no;
.m.p.m add cascade -label Size -menu .m.p.m.n;
.m.p.m add cascade -label Srange -menu .m.p.m.s;
.m.p.m add cascade -label Brightness -menu .m.p.m.b;

#
# image size submenu
#
menu .m.p.m.n -tearoff no;
foreach v $fourier(size-menu) {
    .m.p.m.n add radiobutton -label $v -value $v -variable fourier(size) -command {.c configure -width $fourier(size) -height $fourier(size)};
}

#
# fourier space range submenu
#
menu .m.p.m.s -tearoff no;
foreach v $fourier(srange-menu) {
    .m.p.m.s add radiobutton -label $v -value $v -variable fourier(srange);
}

#
# brightness menu
#
menu .m.p.m.b -tearoff no;
foreach v $fourier(brightness-menu) {
    .m.p.m.b add radiobutton -label $v -value $v -variable fourier(brightness) -command set-brightness;
}

#
# number of vertices in data set
#
pack [label .m.n -text "$fourier(npoints) points"] -side left;

#
# canvas for displaying results
#
pack [canvas .c -width $fourier(size) -height $fourier(size)] -fill both -expand true;
pack [scale .s -orient horizontal -from 0 -to 1000 -label {} -showvalue false -variable fourier(percent) -state disabled] -side top -fill x;

#
# compute the fourier transform
#
proc fourier {} {
    global fourier;
    .c delete all;
    set fourier(image) {};
    set fourier(picture) [image create photo -height $fourier(size) -width $fourier(size)];
    .c create image 0 0 -anchor nw -image $fourier(picture);
    transform $fourier(picture) $fourier(size) $fourier(srange) $fourier(npoints) $fourier(points);
}

#
# decide whether the _fourier.c program can be used
#
proc transform {image n srange npoints points} {
    set dir $::fourier(home)
    set src [file join $dir fourier.c]
    set exe [file join $dir fourier]

    if {[file exists $exe]
     || ([file exists $src] && [catch {exec cc -o $exe $src -lm}] == 0)} {
	fast-transform $exe;
    } else {
	slow-transform;
    }
}
	
#
# start the progress monitor
#
proc init-progress {n} {
    global fourier;
    set fourier(percent) 0;
    .s configure -from 0 -to [expr $n*$n];
}

#
# update the progress monitor
#
proc incr-progress {} {
    global fourier;
    .s configure -state normal;
    incr fourier(percent);
    .s configure -state disabled;
}

#
# draw pixels to the output image
#
proc image-pixels {mag x y xn yn} {
    global fourier;
    set mag [expr int($fourier(scale) * $mag)];
    if {$mag > 255} {
	set mag ff;
    } else {
	set mag [format %02x $mag];
    }
    $fourier(picture) put "{{\#$mag$mag$mag}}" -to $x $y $xn $yn;
}

#
# adjust the brightness
#
proc set-brightness {} {
    global fourier;
    set fourier(scale) [expr $fourier(brightness)*256.0];
    foreach region $fourier(image) {
	eval image-pixels $region;
	update;
    }
}

#
# add pixels to the output image
#
proc set-pixels {mag x y xn yn} {
    global fourier;
    lappend fourier(image) [list $mag $x $y $xn $yn];
    image-pixels $mag $x $y $xn $yn;
}

#
# compute the fourier transform in tcl, slowly
#
proc slow-transform {} {
    upvar n n srange srange npoints npoints points points;
    set pi [expr 4*atan(1)];
    if {$npoints == 0} {
	set scale 1;
    } else { 
        set scale [expr 1.0 / $npoints];
    }
    for {set i 0} {$i < $n} {incr i} {
	set c($i) [expr 2 * $pi * $srange * (double($i) / ($n-1) - .5)];
    }
    init-progress $n;
    for {set w $n} {$w >= 1} {set w [expr $w/2]} {
	set wt2 [expr $w*2];
	for {set i 0} {$i < $n} {incr i $w} {
	    set y $c($i);
	    for {set j 0} {$j < $n} {incr j $w} {
		if {($i%$wt2) != 0 || ($j%$wt2) != 0 || $w == $n} {
		    set x $c($j);
		    set re 0;
		    set im 0;
		    foreach p $points {
			set dot $x*[lindex $p 0]+$y*[lindex $p 1];
			append re +cos($dot);
			append im +sin($dot);
		    }
		    set re [expr $re];
		    set im [expr $im];
		    set mag [expr $scale * sqrt($re*$re + $im*$im)];
		    set-pixels $mag $j $i [expr $j+$w] [expr $i+$w];
		    incr-progress;
		    update;
		}
	    }
	}
    }
}

#
# compute the fourier transform with a C program
#
proc fast-transform {exe} {
    global fourier;
    upvar n n srange srange npoints npoints points points;
    set input "$n $srange $npoints\n[join $points \n]";
    set fp [open "|$exe << {$input}" r];
    init-progress $n;
    set fourier(image) {};
    while {[gets $fp line] >= 0} {
	eval set-pixels $line;
	incr-progress;
	update;
    }
    close $fp;
}


