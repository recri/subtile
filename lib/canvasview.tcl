namespace eval canvasview {
    #@
    #@  procedure "canvasview"
    #@------------------------------>  the canvasview widget builds a frame which
    #@                                 containts a canvas, and optionally enables
    #@                                 horizontal and/or vertical scroll bars.
    ##
    proc canvasview {w args} {
	#@
	#@--------------->  establish the widget local state binding.
	##
	upvar #0 $w data;
	#@
	#@--------------->  establish a Tk frame widget.
	##
	frame $w -class Canvasview;
	rename $w $w.frame;
	#@
	#@--------------->  widget method dispatcher.
	##
	proc ::$w {method args} \
	    "return \[eval [namespace current]::method::\$method $w \$args\];"
	#@
	#@--------------->  instantiate the widget.
	##
	pack [canvas $w.c] -expand true -fill both
	#@
	#@--------------->  redirect bindings.
	##
	bindtags $w.c "Canvas $w [winfo toplevel $w] all"
	#@
	#@--------------->  default configuration
	##
	set data(options) {
	    {-vscroll vScroll VScroll 0}
	    {-hscroll hScroll HScroll 0}
	}
	foreach opt $data(options) {
	    set name [lindex $opt 0];
	    set data($name) [lindex $opt 3];
	}
	#@
	#@--------------->  apply the configuration options.
	##
	doconfigure;
	#@
	#@--------------->  return the widget name.
	##
	return $w;
    }
    namespace eval method {
	#@
	#@==============================================================================
	#@
	#@  procedure "canvasview::method::cget"
	#@------------------------------>  widget methods
	##
	proc cget {w args} {
	    if {[llength $args] != 1} {
		error "usage: pathName cget option";
	    } else {
		return [lindex [$w configure $args] 4];
	    }
	}
	#@
	#@==============================================================================
	#@
	#@  procedure "canvasview::method::configure"
	#@------------------------------>  widget methods
	##
	proc configure {w args} {
	    upvar #0 $w data;
	    if {[llength $args] == 0} {
		set options {};
		foreach opt $data(options) {
		    set name [lindex $opt 0];
		    if {[llength $opt] == 4} {
			lappend opt $data($name);
		    }
		    lappend options $opt;
		}
		return [concat $options [$w.c configure]];
	    }
	    if {[llength $args] == 1} {
		foreach opt $data(options) {
		    set name [lindex $opt 0];
		    if {"$name" == "$args"} {
			if {[llength $opt] == 4} {
			    lappend opt $data($name);
			    return $opt;
			} else {
			    return [$w configure -[lindex $opt 2]];
			}
		    }
		}
		return [$w.c configure $args];
	    }
	    return [[namespace parent]::doconfigure];
	}
	#@
	#@==============================================================================
	#@
	#@--------------->  methods from canvasview exclude cget and configure
	##
	foreach method {addtag bbox bind canvasx canvasy coords create dchars \
			    delete dtag find focus gettags icursor index insert \
			    itemcget itemconfigure lower move postscript raise \
			    scale scan select type xview yview} \
	    {
	    proc $method {w args} \
		"return \[eval \$w.c $method \$args]";
	}
    }
    #@
    #@==============================================================================
    #@
    #@  procedure "canvasview::doconfigure"
    #@------------------------------>  internals
    ##
    proc doconfigure {} {
	upvar w w;
	upvar args args;
	upvar data data;
	set cargs {};
	while {[llength $args] >= 2} {
	    set option [lindex $args 0];
	    set value [lindex $args 1];
	    set args [lrange $args 2 end];
	    switch -exact -- $option {
		-hscroll {
		    set data(-hscroll) [merge-boolean $value $data(-hscroll)];
		    #@
		    #@                  Repack canvasview
		    #@--------------------------------------------->  "Lib_tk/canvasview.tcl"
		    ##
		    repack;
		}
		-vscroll {
		    set data(-vscroll) [merge-boolean $value $data(-vscroll)];
		    #@
		    #@                  Repack canvasview
		    #@--------------------------------------------->  "Lib_tk/canvasview.tcl"
		    ##
		    repack;
		}
		default {
		    lappend cargs $option $value;
		}
	    }
	}
	if {[llength $args] != 0} {
	    error "unmatched option argument: $args";
	}
	if {"$cargs" != {}} {
	    #@
	    #@--------------->  call dispatched procedure
	    ##
	    return [eval $w.c configure $cargs];
	} else {
	    return {};
	}
    }
    #@
    #@==============================================================================
    #@
    #@  procedure "canvasview::repack"
    #@------------------------------>  redraw
    ##
    proc repack {} {
	upvar w w;
	upvar data data;
	$w.c configure -xscrollcommand {} -yscrollcommand {};
	#@
	#@--------------->  Destroy widgets
	##
	catch {pack forget $w.c};
	catch {pack forget $w.e};
	catch {destroy $w.e};
	catch {pack forget $w.v};
	catch {destroy $w.v};
	catch {pack forget $w.h};
	catch {destroy $w.h};
	
	switch $data(-hscroll)$data(-vscroll) {
	    10 {
		pack [scrollbar $w.h -orient horizontal -command "$w.c xview"] \
		    -side bottom -fill x;
		pack $w.c -side top -fill both -expand true;
		$w.c configure -xscrollcommand "$w.h set";
	    }
	    01 {
		pack [scrollbar $w.v -orient vertical -command "$w.c yview"] \
		    -side right -fill y;
		pack $w.c -side left -fill both -expand true;
		$w.c configure -yscrollcommand "$w.v set";
	    }
	    11 {
		pack [frame $w.e] -side right -fill y;
		pack [frame $w.e.s] -side bottom;
		pack [scrollbar $w.v -orient vertical -command "$w.c yview"] \
		    -in $w.e -side right -fill y;
		pack [scrollbar $w.h -orient horizontal -command "$w.c xview"] \
		    -side bottom -fill x;
		pack $w.c -side top -fill both -expand true;
		$w.c configure -xscrollcommand "$w.h set" -yscrollcommand "$w.v set";
		bind $w.e.s <Configure> "$w.e.s configure -height \[winfo height $w.h]";
	    }
	}
    }
}

proc canvasview {w args} {
    return [eval canvasview::canvasview $w $args]
}

#@
#@==============================================================================

