########################################################################
##
## tiling window.
##
## when an initial tile or tiling is selected,
## a tiling window is popped up with a menu and
## the initial tiling.
##
##
proc subtiling-options {initialize} {
    set keepers {}
    foreach {vname value} $initialize {
        switch -glob $vname {
            start-name -
            start-tiling -
            background -
            activeFill -
            outline -
            activeOutline -
            tile-fill -
            color -
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
            catalog-* {
                lappend keepers $vname $value
            }
            tiling-* {
                lappend keepers $vname $value [string range $vname 7 end] $value
            }
            scale -
            edge -
            fill -
            overlay -
            watch-tiles -
            no-draw -
            x -
            y -
            dx -
            dy -
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
    
proc new-subtiling {name tiling} {
    new-subtiling-init [subtiling-options [concat [get-default-options] [list start-name $name start-tiling $tiling]]]
}

proc new-subtiling-init {init} {
    set w [new-window-name];
    upvar \#0 $w subtile;

    array set subtile $init

    toplevel $w;
    wm title $w $subtile(start-name);
    pack [frame $w.m -border 2 -relief raised] -side top -fill x;
    pack [menubutton $w.m.o -text operations -menu $w.m.o.m] -side left -anchor w;
    update-ops-menu $w;
    pack [menubutton $w.m.p -text options -menu $w.m.p.m] -side left -anchor w
    update-options-menu $w
    pack [menubutton $w.m.m -text mouse -menu $w.m.m.m] -side left -anchor w
    update-mouse-menu $w

    # adding scrolling here doesn't help without scroll region monitoring
    #               -vscroll 1 -hscroll 1 
    pack [canvasview $w.c \
              -bg $subtile(background) \
              -width [expr 10+$subtile(scale)] \
              -height [expr 10+$subtile(scale)] \
              -xscrollincrement 1 -yscrollincrement 1 \
             ] -fill both -expand true
    

    #
    # the canvas is configured to be larger than the displayed region
    # mouse button 2 allows you to push the displayed region around
    # mouse button 3 allows you to rescale the displayed image
    #
    $w.c bind tile <Enter> "enter-tile $w"
    $w.c bind tile <Leave> "leave-tile $w"
    foreach b {1 2 3} {
        bind-button-to-op $w $b $subtile(mouse-$b)
    }
    redraw-subtiling $w;
}

proc enter-tile {w} {
    upvar \#0 $w subtile;
    # puts "enter-tile [$w.c gettags current]"
    switch -glob [$w.c gettags current] {
        *decorate* -
        *arrow* -
        *label* {
        }
        *tile* {
            $w.c raise current tile
            $w.c itemconfigure current -outline $subtile(activeOutline)
        }
    }
}

proc leave-tile {w} {
    upvar \#0 $w subtile;
    # puts "leave-tile [$w.c gettags current]"
    switch -glob [$w.c gettags current] {
        *decorate* -
        *arrow* -
        *label* {
        }
        *tile* {
            $w.c itemconfigure current -outline $subtile(outline)
        }
    }
}

#
# mouse operations
#
proc bind-button-to-op {w b op} {
    switch $op {
        edit {
            bind $w.c <$b> {}
            $w.c bind tile <$b> "delete-tile $w"
        }
        scroll {
            bind $w.c <$b> "scroll-mark $w %x %y"
            bind $w.c <Button$b-Motion> "scroll-dragto $w %x %y"
        }
        scale {
            bind $w.c <$b> "scale-mark $w %x %y"
            bind $w.c <Button$b-Motion> "scale-dragto $w %x %y"
        }
        rotate {
            bind $w.c <$b> "rotate-mark $w %x %y"
            bind $w.c <Button$b-Motion> "rotate-dragto $w %x %y"
        }
        select {
        }
        default {
            error "unknown button op: $op"
        }
    }
}
    
#
# rewrite the operation menu when the tiling changes
#
proc update-ops-menu {w} {
    global subtile;
    set args $subtile([current-name $w]-ops-menu);
    catch {destroy $w.m.o.m};
    menu $w.m.o.m -tearoff no;
    $w.m.o.m add command -label {subdivide tiling} -command "subdivide-subtiling $w";
    $w.m.o.m add command -label {duplicate tiling} -command "copy-subtiling $w";
    #$w.m.o.m add command -label {match holes tiling} -command "match-holes-subtiling $w";
    #$w.m.o.m add command -label {match border tiling} -command "match-border-subtiling $w";
    $w.m.o.m add separator;
    $w.m.o.m add command -label {redraw tiling} -command "redraw-subtiling $w";
    $w.m.o.m add command -label {reset tiling} -command "reset-subtiling $w";
    $w.m.o.m add separator;
    $w.m.o.m add command -label {save tiling} -command "save-subtiling-as-tiling $w"
    $w.m.o.m add command -label {open tiling} -command "open-subtiling-as-tiling $w"
    $w.m.o.m add command -label {print tiling} -command "save-subtiling-as-postscript $w";
    $w.m.o.m add separator
    if {[llength $args]} {
        foreach arg $args {
            set title [lindex $arg 0];
            set command [lindex $arg 1];
            $w.m.o.m add command -label $title -command "operate-subtiling $w {$command}";
        }
        $w.m.o.m add separator;
    }
    # $w.m.o.m add command -label {make vertex matching atlas} -command "vertex-matching-atlas-subtiling $w"
    # $w.m.o.m add command -label {make edge matching atlas} -command "edge-matching-atlas-subtiling $w"
    $w.m.o.m add command -label {make vertex atlas} -command "vertex-atlas-subtiling $w";
    $w.m.o.m add command -label {make fourier map} -command "fourier-subtiling $w";
    $w.m.o.m add separator
    $w.m.o.m add command -label dismiss -command "destroy $w";
}

proc update-options-menu {w} {
    upvar \#0 $w subtile
    catch {destroy $w.m.p.m}
    menu $w.m.p.m -tearoff no
    $w.m.p.m add checkbutton -label {watch tiling} -variable ${w}(watch-tiles)
    $w.m.p.m add checkbutton -label {overlay tiling} -variable ${w}(overlay)
    $w.m.p.m add separator
    $w.m.p.m add checkbutton -label {show arrows} -variable ${w}(arrow)
    $w.m.p.m add checkbutton -label {show labels} -variable ${w}(label)
    $w.m.p.m add checkbutton -label {decorate} -variable ${w}(decorate)
    $w.m.p.m add checkbutton -label {color tiles} -variable ${w}(color) -command [list subtiling-toggle-color $w]
    $w.m.p.m add command -label {configure tile colors} -command [list subtiling-configure-color $w] 
    
    $w.m.p.m add separator
    $w.m.p.m add checkbutton -label {anneal partial tiles} -variable ${w}(partials)
    #$w.m.p.m add checkbutton -label {fill in holes} -variable ${w}(fillinholes)
}

proc update-mouse-menu {w} {
    upvar \#0 $w subtile
    catch {destroy $w.m.m.m}
    menu $w.m.m.m -tearoff no
    foreach {label button} {{left mouse} 1 {right mouse} 3 {middle mouse} 2} {
        $w.m.m.m add cascade -label $label -menu $w.m.m.m.m$button
        menu $w.m.m.m.m$button -tearoff no
        foreach op {edit scroll scale rotate select} {
            $w.m.m.m.m$button add radiobutton -label $op -variable ${w}(mouse-$button) -command "bind-button-to-op $w $button $op"
        }
    }
}

#
# delete or undelete tiles from the current tiling
#
proc delete-tile {w} {
    upvar \#0 $w subtile;
    foreach tag [$w.c gettags current] {
        if {[regexp {^t([0-9]+)$} $tag all index]} {
            if {"[$w.c itemcget current -outline]" == {}} {
                # undelete
                $w.c itemconfigure current -fill $subtile(fill) -outline black;
                set i [lsearch $subtile(deleted) $index];
                set subtile(deleted) [lreplace $subtile(deleted) $i $i];
            } else {
                # delete
                $w.c itemconfigure current -fill {} -outline {};
                lappend subtile(deleted) $index;
            }
        }
    }
}

#
# start a new drawing
#
proc start-tile-drawing {w} {
    upvar \#0 $w subtile
    if { ! $subtile(no-draw)} {
        if { ! $subtile(overlay)} {
            $w.c delete all;
        }
    }
}

#
# draw all the tiles in a tiling
#
proc draw-tiling {w tags tiles} {
    upvar \#0 $w subtile;
    if {$subtile(no-draw) != 1} {
        start-tile-drawing $w;
        set n -1;
        foreach tile $tiles {
            if {[catch {
                draw-tile $w "$tags t[incr n]" $tile;
            } error]} {
                global errorInfo
                puts "error drawing\n\t[join $tile \n\t]"
                error $error $errorInfo
            }
        }
        $w.c raise arrow tile
        $w.c raise decoration tile
        $w.c raise label tile
    }
}

#
# evaluate without any drawing
#
proc with-no-drawing {w cmd} {
    upvar \#0 $w subtile
    set save $subtile(no-draw);
    set subtile(no-draw) 1;
    if {[catch {uplevel $cmd} result]} {
        set subtile(no-draw) $save;
        global errorInfo;
        error $result $errorInfo;
    } else {
        set subtile(no-draw) $save;
        return $result;
    }
}

########################################################################
##
## user interface commands
##
proc copy-subtiling {w} {
    upvar $w subtile
    new-subtiling-init [concat [get-default-options-from-window $w] \
                            [list start-name [current-name $w] start-tiling [current-subtiling $w]]]
}

proc match-holes-subtiling {w} {
    upvar \#0 $w subtile
    update-subtiling $w [match-holes [[current-name $w]-make [current-subtiling $w] 0 $subtile(partials)]];
    if {$subtile(no-draw) != 1 && "$subtile(current-tiling)" != {}} {
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
}

proc match-border-subtiling {w} {
    upvar \#0 $w subtile
    update-subtiling $w [match-border [[current-name $w]-make [current-subtiling $w] 0 $subtile(partials)]];
    if {$subtile(no-draw) != 1 && "$subtile(current-tiling)" != {}} {
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
}

proc reset-subtiling {w} {
    upvar \#0 $w subtile
    update-subtiling $w [$subtile(start-name)-make $subtile(start-tiling) 0 $subtile(partials)]
    if {$subtile(no-draw) != 1 && "$subtile(current-tiling)" != {}} {
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
}

proc subdivide-subtiling {w} {
    upvar \#0 $w subtile
    update-subtiling $w [[current-name $w]-make [current-subtiling $w] 1 $subtile(partials)];
    if {$subtile(no-draw) != 1 && "$subtile(current-tiling)" != {}} {
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
}

proc redraw-subtiling {w} {
    upvar \#0 $w subtile
    update-subtiling $w [[current-name $w]-make [current-subtiling $w] 0 $subtile(partials)];
    if {$subtile(no-draw) != 1 && "$subtile(current-tiling)" != {}} {
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
}

proc rotate-subtiling {w r} {
    upvar \#0 $w subtile
    if {[info exists subtile(rotation-angle)]} {
        set subtile(rotation-angle) [expr {$subtile(rotation-angle)+$r}]
    } else {
        set subtile(rotation-angle) $r
        after idle "do-rotate-subtiling $w"
    }
}

proc do-rotate-subtiling {w} {
    upvar \#0 $w subtile
    set r $subtile(rotation-angle)
    set subtile(rotation-angle) 0
    set r [vrotate-make $r]
    set tiling {}
    set c [vmake 0.5 0.5]
    set nt 0
    set nv 0
    foreach tile $subtile(current-tiling) {
        incr nt
        set vs {}
        foreach v [tile-vertices $tile] {
            lappend vs [vadd $c [vrotate $r [vsub $v $c]]]
            incr nv
        }
        lappend tiling [make-tile-from-type-and-list-of-vertices [tile-type $tile] $vs]
    }
    update-subtiling $w [[current-name $w]-make $tiling 0 $subtile(partials)] 0;
    if {$subtile(no-draw) != 1 && "$subtile(current-tiling)" != {}} {
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
    if {$subtile(rotation-angle) == 0} {
        unset subtile(rotation-angle)
    } else {
        after idle "do-rotate-subtiling $w"
    }
}

proc fourier-subtiling {w} {
    upvar \#0 $w subtile
    foreach tile $subtile(current-tiling) {
        foreach p [tile-vertices $tile] {
            set xy($p) {};
        }
    }
    set dir $::subtile(home)
    set tcl [file join $dir fourier.tcl]
    exec [info nameofexecutable] $tcl << [join [array names xy] \n] &;
}

proc operate-subtiling {w command} {
    upvar \#0 $w subtile
    if {[string match *-about* $command]} {
        $command {};
    } elseif {[string match *-dissect* $command] || [string match *-anneal* $command] || [string match *-convert* $command]} {
        with-no-drawing $w {
            update-subtiling $w [$command [current-subtiling $w] $subtile(partials)];
        }
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    } elseif {[info exists subtile(current-tiling)]} {
        with-no-drawing $w {
            update-subtiling $w [$command [current-subtiling $w]];
        }
        draw-tiling $w [current-name $w] $subtile(current-tiling);
    }
}

proc current-name {w} {
    upvar \#0 $w subtile;
    if {[info exists subtile(current-name)]} {
        return $subtile(current-name);
    } elseif {[info exists subtile(start-name)]} {
        return $subtile(start-name)
    }
}

proc current-subtiling {w} {
    upvar \#0 $w subtile
    if {[info exists subtile(deleted)]} {
        set newts {}
        set i 0;
        foreach tile $subtile(current-tiling) {
            if {[lsearch $subtile(deleted) $i] < 0} {
                lappend newts $tile;
            }
            incr i;
        }
        unset subtile(deleted);
        return $newts;
    } elseif {[info exists subtile(current-tiling)]} {
        return $subtile(current-tiling);
    } else {
        set subtile(current-name) $subtile(start-name)
        return $subtile(start-tiling)
    }
}

proc update-subtiling {w tt {scale 1}} {
    upvar \#0 $w subtile
    pset name tiling $tt
    if {$subtile(overlay) || $scale == 0} {
        set subtile(current-tiling) $tiling
    } else {
        if {[llength $tiling] == 0} {
            tk_dialog .dialog {Empty Tiling} {The subtiling operation produced no tiles.} {} 0 {Okay}
        } else {
            set subtile(current-tiling) [tiling-normalize $tiling]
        }
    }
    set subtile(current-name) $name;
    wm title $w $name;
    update-ops-menu $w;
}

proc save-subtiling-as-tiling {w} {
    upvar \#0 $w subtile
    upvar \#0 subtile global
    set directory .
    set file tiling.sub
    if {[info exists global(save-tiling-directory)]} {
        set directory $global(save-tiling-directory)
    }
    if {[info exists global(save-tiling-file)]} {
        set file $global(save-tiling-file)
    }
    set f [tk_getSaveFile -defaultextension .sub \
               -filetypes {{tilings {.sub}}} \
               -initialdir $directory \
               -initialfile $file \
               -parent $w \
               -title {save subtiling}]
    if { ! [string equal $f {}]} {
        overwrite-file $f [array get subtile]
        set global(save-tiling-directory) [file dirname $f]
        set global(save-tiling-file) [file tail $f]
    }
}


proc open-subtiling-as-tiling {w} {
    upvar \#0 $w subtile
    upvar \#0 subtile global
    set directory .
    set file tiling.sub
    if {[info exists global(open-tiling-directory)]} {
        set directory $global(open-tiling-directory)
    }
    if {[info exists global(open-tiling-file)]} {
        set file $global(open-tiling-file)
    }
    set f [tk_getOpenFile -defaultextension .sub \
               -filetypes {{tilings {.sub}}} \
               -initialdir $directory \
               -initialfile $file \
               -parent $w \
               -title {open subtiling}]

    if { ! [string equal $f {}]} {
        if { ! [catch {array set temp [read-file $f]} error]} {
            array unset subtile
            array set subtile [array get temp]
            set global(open-tiling-directory) [file dirname $f]
            set global(open-tiling-file) [file tail $f]
            foreach b {1 2 3} {
                bind-button-to-op $w $b $subtile(mouse-$b)
            }
            redraw-subtiling $w
        } else {
            error "error reading $f: $error"
        }
    }
}

proc save-subtiling-as-postscript {w} {
    upvar \#0 $w subtile
    set wp ${w}ps
    if {[winfo exists $wp]} {
        wm title $wp "save [current-name $w]";
        wm deiconify $wp
        raise $wp $w
    } else {
        toplevel $wp;
        wm title $wp "save [current-name $w]";
        # pack [frame $wp.f0] -side top;
        # pack [label $wp.f0.l -text {file:}] -side left;
        # pack [entry $wp.f0.e -textvariable ${w}(postscript)] -side left -expand true -fill x;
        pack [frame $wp.f0] -side top
        pack [label $wp.f0.l -text "pagesize: "] -side left
        pack [button $wp.f0.b -text $subtile(pagesize) -command "pagesize-select $w $wp"] -side left
        pack [checkbutton $wp.landscape -text {landscape} -variable ${w}(landscape)] -side top -anchor w;
        pack [radiobutton $wp.color -text {color} -variable ${w}(colormode) -value color] -side top -anchor w;
        pack [radiobutton $wp.gray -text {gray}  -variable ${w}(colormode) -value gray] -side top -anchor w;
        pack [radiobutton $wp.mono -text {monochrome}  -variable ${w}(colormode) -value mono] -side top -anchor w;
        pack [frame $wp.f1] -side top -fill x
        pack [button $wp.f1.save -text {save to file} -command "do-save-subtiling $w; destroy $wp"] -side left;
        pack [button $wp.f1.print -text {print} -command "do-print-subtiling $w; destroy $wp"] -side left
        pack [button $wp.f1.cancel -text {cancel} -command "destroy $wp"] -side left
    }
}

proc pagesize-select {w wp} {
    # make a selection list, update ${w}(pagesize)
    upvar \#0 $w subtile
    set wps ${wp}ps
    if {[winfo exists $wps]} {
        wm deiconify $wps
        raise $wps $wp
    } else {
        toplevel $wps
        wm title $wps "select page size"
        pack [frame $wps.f1] -side top -fill both -expand true
        pack [listbox $wps.f1.l -yscrollcommand [list $wps.f1.s set] -width 32] -side left -fill both -expand true
        pack [scrollbar $wps.f1.s -orient vertical -command [list $wps.f1.l yview]] -side left -fill y -expand true
        pack [label $wps.l1 -text "pagesize"] -side top
        pack [label $wps.l2 -text "? by ? inches"] -side top
        pack [frame $wps.f2] -side top
        pack [button $wps.f2.okay -text okay -command [list pagesize-select-okay $w $wp $wps]] -side left
        pack [button $wps.f2.cancel -text cancel -command [list pagesize-select-cancel $w $wp $wps]] -side left
        foreach name [catalog-pagesizes] {
            $wps.f1.l insert end $name
        }
        bind $wps.f1.l <<ListboxSelect>> [list pagesize-select-select $wps]
        set i [lsearch [catalog-pagesizes] $subtile(pagesize)]
        $wps.f1.l selection clear 0 end
        $wps.f1.l selection set $i
        $wps.f1.l see $i
        pagesize-select-select $wps
    }
}

proc pagesize-select-select {wps} {
    if {[llength [$wps.f1.l curselection]] == 1} {
        set select [$wps.f1.l get [lindex [$wps.f1.l curselection] 0]]
        pset h w [pagesize $select]
        $wps.l1 configure -text $select
        $wps.l2 configure -text [format "%.3f x %.3f inches" [expr {$h/72.0}] [expr {$w/72.0}]]
    }
}

proc pagesize-select-okay {w wp wps} {
    upvar \#0 $w subtile
    if {[llength [$wps.f1.l curselection]] == 1} {
        set subtile(pagesize) [$wps.f1.l get [lindex [$wps.f1.l curselection] 0]]
        $wp.f0.b configure -text $subtile(pagesize)
    }
    destroy $wps
}
proc pagesize-select-cancel {w wp wps} {
    destroy $wps
}

proc subtiling-postscript-command {w} {
    upvar \#0 $w subtile
    return "$w.c postscript -rotate $subtile(landscape) -colormode $subtile(colormode)"
}

proc do-save-subtiling {w} {
    upvar \#0 $w subtile
    upvar \#0 subtile global
    set directory .
    set file tiling.ps
    if {[info exists global(save-postscript-directory)]} {
        set directory $global(save-postscript-directory)
    }
    if {[info exists global(save-postscript-file)]} {
        set file $global(save-postscript-file)
    }
    set f [tk_getSaveFile -defaultextension .ps \
               -filetypes {{postscript {.ps}}} \
               -initialdir $directory \
               -initialfile $file \
               -parent $w \
               -title {save postscript}]
    if { ! [string equal $f {}]} {
        set global(save-postscript-directory) [file dirname $f]
        set global(save-postscript-file) [file tail $f]
        eval [subtiling-postscript-command $w] -file $f ;
    }
           
}

proc do-print-subtiling {w} {
    set fp [open |lpr w]
    if {[catch {puts -nonewline $fp [eval [subtiling-postscript-command $w]]} error]} {
        global errorInfo
        close $fp
        error $error $errorInfo
    } else {
        close $fp
    }
}
    
proc subtiling-toggle-color {w} {
    upvar \#0 $w subtile
    if {$subtile(color)} {
        $w.c itemconfigure tile -fill $subtile(tile-fill)
    } else {
        $w.c itemconfigure tile -fill {}
    }
}

proc subtiling-configure-color {w} {
    upvar \#0 $w subtile
    set wp ${w}color
    if {[winfo exists $wp]} {
        wm title $wp "colors for [current-name $w]";
        wm deiconify $wp
        raise $wp $w
    } else {
        toplevel $wp;
        wm title $wp "colors for [current-name $w]";
        pack [label $wp.patch -bg $subtile(tile-fill)] -side top -fill x
        pack [button $wp.choose -text {Choose tile color} -command [list subtiling-choose-tile-color $w $wp]] -side top
    }
}

proc subtiling-choose-tile-color {w wp} {
    upvar \#0 $w subtile
    set color [tk_chooseColor -initialcolor $subtile(tile-fill) -title "Choose tile color" -parent $wp]
    if {[string length $color] > 0} {
        set subtile(tile-fill) $color
        $wp.patch configure -bg $color
        subtiling-toggle-color $w
    }
}

proc vertex-atlas-subtiling {w} {
    upvar \#0 $w subtile
    set tilings [vertex-atlas-tiling $subtile(current-tiling)];
    set name [current-name $w]
    if {[llength $tilings] > 0} {
        set w [catalog-generated [new-window-name] "vertex atlas of $name" [get-default-options-from-window $w]]
        catalog-tilings $w {} $name $tilings;
    } else {
        # alert no tilings found
    }
}

proc edge-matching-atlas-subtiling {w} {
    upvar \#0 $w subtile
    array set atlas [edge-matching-atlas-tiling $subtile(current-tiling)]
    foreach name [array names atlas] {
        pset e1 e2 $name
        lappend match($e1) $e2
        lappend match($e2) $e1
    }
    foreach name [lsort [array names match]] {
        puts "$name {[lsort $match($name)]}"
    }
}

proc vertex-matching-atlas-subtiling {w} {
    upvar \#0 $w subtile
    array set atlas [vertex-matching-atlas-tiling $subtile(current-tiling)]
    if {[catch {$subtile(current-name)-vertex-matching-atlas} oldatlasget]} {
        puts "fetching old vertex-matching-atlas returned $oldatlasget"
        foreach name [lsort [array names atlas]]  {
            puts "$name ->\n\t[join [lsort $atlas($name)] \n\t]"
        }
    } else {
        puts "identifying new vertex-matching-atlas entries for $subtile(current-name)"
        array set oldatlas $oldatlasget
        foreach name [array names atlas] {
            foreach config $atlas($name) {
                if {[lsearch $oldatlas($name) $config] < 0} {
                    lappend newatlas($name) $config
                }
            }
            if {[info exists newatlas($name)]} {
                puts "new $name {\n[join $newatlas($name) \n]\n}"
            }
        }
    }
}
