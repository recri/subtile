namespace eval textview {
    #@
    #@  procedure "textview"
    #@------------------------------>  The textview widget builds a frame which
    #@                                 containts the text of a file, or a stream,
    #@                                 or a list of strings, and optionally 
    #@                                 enables horizontal and or vertical scroll
    #@                                 bars.
    ##
    proc textview {w args} {
	#@
	#@--------------->  establish the widget local state binding.
	##
	upvar #0 $w data;
	#@
	#@--------------->  establish a Tk frame widget.
	##
	frame $w -class Textview;
	rename $w $w.frame;
	#@
	#@--------------->  widget method dispatcher.
	##
	proc ::$w {method args} \
	    "return \[eval [namespace current]::method::\$method $w \$args\];"
	#@
	#@--------------->  instantiate the widget.
	##
	pack [text $w.t] -expand true -fill both
	#@
	#@--------------->  redirect bindings.
	##
	bindtags $w.t "Text $w [winfo toplevel $w] all"
	#@
	#@--------------->  default configuration
	##
	set data(options) {
	    {-vscroll vScroll VScroll 0}
	    {-hscroll hScroll HScroll 0}
	};
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
    #@  procedure "textview::method::cget"
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
	#@  procedure "textview::method::configure"
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
		return [concat $options [$w.t configure]];
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
		return [$w.t configure $name];
	    }
	    return [[namespace parent]::doconfigure];
	}
	#@
	#@==============================================================================
	#@
	#@--------------->  methods from text exclude cget and configure
	##
	foreach method {bbox compare debug delete dlineinfo get index insert mark\
			    scan search see tag window xview yview} \
	    {
	    proc $method {w args} "eval \$w.t $method \$args";
	}
    }
    #@
    #@==============================================================================
    #@
    #@  procedure "textview::doconfigure"
    #@------------------------------>  internals
    ##
    proc doconfigure {} {
	upvar w w;
	upvar args args;
	upvar data data;
	set targs {};
	while {[llength $args] >= 2} {
	    set option [lindex $args 0];
	    set value [lindex $args 1];
	    set args [lrange $args 2 end];
	    switch -exact -- $option {
		-hscroll {
		    set data(-hscroll) [merge-boolean $value $data(-hscroll)];
		    #@
		    #@                  Repack textview
		    #@--------------------------------------------->  "Lib_tk/textview.tcl"
		    ##
		    repack;
		}
		-vscroll {
		    set data(-vscroll) [merge-boolean $value $data(-vscroll)];
		    #@
		    #@                  Repack textview
		    #@--------------------------------------------->  "Lib_tk/textview.tcl"
		    ##
		    repack;
		}
		default {
		    lappend targs $option $value;
		}
	    }
	}
	if {[llength $args] != 0} {
	    error "unmatched option argument: $args";
	}
	if {"$targs" != {}} {
	    #@
	    #@--------------->  call dispatched procedure
	    ##
	    return [eval $w.t configure $targs];
	} else {
	    return {};
	}
    }
    #@
    #@==============================================================================
    #@
    #@  procedure "textview::repack"
    #@------------------------------>  redraw
    ##
    proc repack {} {
	upvar w w;
	upvar data data;
	$w.t configure -xscrollcommand {} -yscrollcommand {};
	#@
	#@--------------->  Destroy widgets
	##
	catch {pack forget $w.e};
	catch {destroy $w.e};
	catch {pack forget $w.v};
	catch {destroy $w.v};
	catch {pack forget $w.h};
	catch {destroy $w.h};
	
	switch $data(-hscroll)$data(-vscroll) {
	    10 {
		pack [scrollbar $w.h -orient horizontal -command "$w.t xview" \
			  -takefocus 0] -before $w.t -side bottom -fill x;
		$w.t configure -xscrollcommand "$w.h set";
	    }
	    01 {
		pack [scrollbar $w.v -orient vertical -command "$w.t yview" \
			  -takefocus 0] -before $w.t -side right -fill y;
		$w.t configure -yscrollcommand "$w.v set";
	    }
	    11 {
		pack [frame $w.e] -before $w.t -side right -fill y;
		pack [frame $w.e.s] -side bottom;
		pack [scrollbar $w.v -orient vertical -command "$w.t yview" \
			  -takefocus 0] -in $w.e -side right -fill y;
		pack [scrollbar $w.h -orient horizontal -command "$w.t xview" \
			  -takefocus 0] -before $w.t -side bottom -fill x;
		$w.t configure -xscrollcommand "$w.h set" -yscrollcommand "$w.v set";
		bind $w.e.s <Configure> "$w.e.s configure -height \[winfo height $w.h]";
	    }
	}
    }
}

proc textview {w args} {
    return [eval textview::textview $w $args]
}
#@
#@==============================================================================

