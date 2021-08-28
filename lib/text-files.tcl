#
# read-file - read a text file
# open a file,
# read its contents into a string,
# close the file,
# and return the string.
#
proc read-file {filename} {
    set string {};
    set fileId [open $filename r];
    catch {
        set string [read $fileId];
        close $fileId;
    }
    return $string;
}
#
# read-file-nonewline - read a text file with no trailing newline
# open a file,
# read its contents into a string,
# close the file,
# and return the string.
#
proc read-file-nonewline {filename} {
    set string {};
    set fileId [open $filename r];
    catch {
        set string [read -nonewline $fileId];
        close $fileId;
    }
    return $string;
}
#
# maybe-read-file - read a text file if it exists
#
proc maybe-read-file {filename} {
    if {[file exists $filename]} {
        return [read-file $filename];
    } else {
        return {};
    }
}
#
# write-file - write a text file
# create a file,
# write the string into the file,
# close the file
# fail if the file exists.
#
proc write-file {filename string} {
    if {[file exists $filename]} {
        error "write-file: $filename: file already exists";
    } else {
        set fileId [open $filename w];
        puts -nonewline $fileId $string;
        close $fileId;
        return {};
    }
}
#
# overwrite-file - write a text file
# create a file,
# write the string into the file,
# close the file
#
proc overwrite-file {filename string} {
    set fileId [open $filename w];
    puts -nonewline $fileId $string;
    close $fileId;
    return {};
}
#
# append-file - append to a file
# open a file for update,
# write the string onto the end of the file,
# close the file.
#
proc append-file {filename string} {
    set fileId [open $filename a+];
    puts -nonewline $fileId $string;
    close $fileId;
    return {};
}
#
# file-line-count - count the lines in a file
#
proc file-line-count {filename} {
    return [lindex [exec wc [glob $filename]] 0];
}    
#
# file-word-count - count the words in a file
#
proc file-word-count {filename} {
    return [lindex [exec wc [glob $filename]] 1];
}

