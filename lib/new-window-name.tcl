#
# invent a toplevel window name
#
set new-window-name-nth 0;

proc new-window-name {} {
    upvar \#0 new-window-name-nth nth
    return .f[incr nth];
}


