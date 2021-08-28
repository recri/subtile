########################################################################
#
# tiling catalogs.
# 
#

proc catalog-options {initialize} {
    set keepers {}
    foreach {vname value} $initialize {
        switch -glob $vname {
            background -
            activeFill -
            outline -
            activeOutline -
            color -
            tile-fill -
            arrow -
            label -
            decorate -
            partials -
            fillinholes -
            mouse-1 -
            mouse-3 -
            mouse-2 -
            save-postscript-directory -
            save-postscript-file -
            pagesize -
            landscape -
            colormode -
            tiling-* {
                lappend keepers $vname $value
            }
            catalog-* {
                lappend keepers $vname $value [string range $vname 8 end] $value
            }
            watch-tiles -
            overlay -
            no-draw -
            scale -
            edge -
            fill -
            x -
            y -
            dx -
            dy -
            start-tiling -
            start-name -
            r-m-p -
            r-m-c -
            s-m-r2 -
            s-m-x -
            s-m-y -
            toplevel-w -
            current-name -
            current-tiling -
            *-ops-menu -
            *-start-menu -
            tilings -
            home {
            }
            default {
                puts "ignoring $vname"
            }
        }
    }
    return $keepers
}

##
## main window.
##
## the main window has a menu button on top
## and a scrollable canvas below.  The scrollable
## canvas is used to present a graphical menu of
## tilings and start patterns.
##
proc catalog-toplevel {w title {initialize {}}} {
    #
    # the top frame
    #
    if {[string length $w] > 0} {
        toplevel $w
        wm title $w $title
    } else {
        wm title . $title
    }

    #
    # the data store
    #
    upvar \#0 $w subtile
    array set subtile [catalog-options $initialize]
        
    #
    # the subframes
    #
    pack [frame $w.m -border 2 -relief raised] -side top -fill x
    pack [canvasview $w.c -bg $subtile(background) -vscroll 1 ] -fill both -expand true

    #
    # the menu
    #
    pack [menubutton $w.m.o -text file -menu $w.m.o.m] -side left
    menu $w.m.o.m -tearoff no;
    $w.m.o.m add command  -label {about subtile} -command [list about-subtile]
    $w.m.o.m add separator;
    $w.m.o.m add command -label {redraw catalog} -command [list redraw-toplevel-catalog $w]
    $w.m.o.m add separator;
    $w.m.o.m add command -label quit -command [list destroy .]
    pack [menubutton $w.m.p -text options -menu $w.m.p.m] -side left
    menu $w.m.p.m -tearoff no;
    $w.m.p.m add checkbutton -label {draw arrows} -var ${w}(arrow)
    $w.m.p.m add checkbutton -label {draw labels} -var ${w}(label)
    $w.m.p.m add checkbutton -label {decorate} -var ${w}(decorate)
    $w.m.p.m add checkbutton -label {color tiles} -var ${w}(color) -command [list catalog-toggle-color $w]
    $w.m.p.m add separator
    $w.m.p.m add checkbutton -label {make partials} -var ${w}(partials)

    #
    # finished
    #
    return $w
}

proc catalog-generated {w title {initialize {}}} {
    #
    # the top frame
    #
    toplevel $w
    wm title $w $title

    #
    # the data store
    #
    upvar \#0 $w subtile
    array set subtile [catalog-options $initialize]

    #
    # the subframes
    #
    pack [frame $w.m -border 2 -relief raised] -side top -fill x
    pack [canvasview $w.c -bg $subtile(background) -vscroll 1] -fill both -expand true

    #
    # finished
    #
    return $w
}

proc catalog-tilings {w title value tilings} {
    upvar \#0 $w subtile;

    if {[llength [$w.c find all]] == 0} {
        set subtile(x) 5;
        set subtile(y) 5;
    }

    set subtile(dx) [expr $subtile(scale)+10];
    set subtile(dy) [expr $subtile(scale)+10];
    
    # write the title for this tiling
    if {[string length $title] > 0} {
        $w.c create text $subtile(x) $subtile(y) -text $title -anchor nw -tag at$subtile(y);
        set subtile(y) [expr 5+[lindex [$w.c bbox at$subtile(y)] 3]];
    }
    
    # draw the initial tiles for this tiling
    set n [llength $tilings];
    #puts "display $n tilings\n[join $tilings \n]";
    foreach arg [collection-normalize $tilings] {
        if {($n == 4 && $subtile(x) > 2*$subtile(dx)) || $subtile(x) > 3*$subtile(dx)} {
            set subtile(x) 5;
            incr subtile(y) $subtile(dy);
        }
        set tag "$title [lindex $arg 0]";
        regsub -all { } $tag - tag;
        draw-tiling $w $tag [lindex $arg 1];
        $w.c move $tag $subtile(x) $subtile(y);
        $w.c bind $tag <Enter> "catch {$w.c itemconfigure current -outline {$subtile(activeOutline)}}";
        $w.c bind $tag <Leave> "catch {$w.c itemconfigure current -outline {$subtile(outline)}}";
        $w.c bind $tag <1> [list new-subtiling $value [lindex $arg 1]];
        incr subtile(x) $subtile(dx);
    }
    set subtile(x) 5;
    incr subtile(y) $subtile(dy);
    $w.c configure -scrollregion "0 0 [expr 3*$subtile(dx)+10] $subtile(y)" -width [expr 3*$subtile(dx)+10];
}

proc catalog-toggle-color {w} {
    upvar \#0 $w subtile
    if {$subtile(color)} {
        $w.c itemconfigure tile -fill $subtile(tile-fill)
    } else {
        $w.c itemconfigure tile -fill {}
    }
}

