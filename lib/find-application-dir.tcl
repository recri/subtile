#
# find our home, hard to put in library since it's used to find library
#
proc find-application-dir {file script pwd} {
    # translate symbolic links in command name
    if { ! [catch {file readlink $script} result]} {
        set script $result
    }
    # look in the command name directory
    if {[file exists [file join [file dirname $script] $file]]} {
        return [file dirname $script];
    }
    # look in the current directory
    if {[file exists [file join $pwd $file]]} {
        return $pwd
    }
    # look in dot
    if {[file exists [file join . $file]]} {
        return .
    }
    error "cannot file data directory"
}
