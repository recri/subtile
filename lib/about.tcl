proc about-something {title information} {
    if {[winfo exists .about]} {
	wm deiconify .about;
	.about.t delete 0.0 end
    } else {
	toplevel .about;
	pack [textview .about.t -vscroll 1] -side top -fill both -expand true;
	pack [button .about.q -text Done -command {destroy .about}] -side top;
    }
    wm title .about $title
    .about.t insert end $information;
}


