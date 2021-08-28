namespace eval ::pagesizes:: {
    # this table is taken from the foomatic ppd for my stylus 1520 printer.
    # the sizes are in 72nds of an inch
    set defsize Letter
    set sizes {
        {Letter} {612 792}
        {A4} {595 842}
        {8x10} {576 720}
        {A2} {1191 1684}
        {A3} {842 1191}
        {A5} {420 595}
        {A6} {297 420}
        {A7} {210 297}
        {ArchA} {648 864}
        {ArchA Transverse} {864 648}
        {ArchB} {864 1296}
        {B3 JIS} {1029 1459}
        {B4 JIS} {727 1029}
        {B5 JIS} {518 727}
        {B6 JIS} {362 518}
        {B7 JIS} {257 362}
        {C3} {918 1298}
        {C4} {649 918}
        {C5} {459 649}
        {C6} {323 459}
        {C7} {229 323}
        {Commercial 10} {297 684}
        {DL} {311 623}
        {Executive} {522 756}
        {B3 ISO} {1000 1417}
        {B4 ISO} {708 1000}
        {B5 ISO} {498 708}
        {B6 ISO} {354 498}
        {B7 ISO} {249 354}
        {Legal} {612 1008}
        {Monarch Envelope} {279 540}
        {Postcard} {283 416}
        {Manual} {396 612}
        {Super B 13x19} {936 1368}
        {Tabloid} {792 1224}
        {12x18} {864 1296}
        {3x5} {216 360}
        {C7-6} {229 459}
        {Japanese long envelope \#4} {255 581}
        {Hagaki Card} {283 420}
        {4x6} {288 432}
        {Small paperback} {314 504}
        {Penguin small paperback} {314 513}
        {A2 Invitation} {315 414}
        {Epson 4x6 Photo Paper} {324 495}
        {Japanese long envelope \#3} {340 666}
        {Crown Octavo} {348 527}
        {B6-C4} {354 918}
        {5x7} {360 504}
        {5x8} {360 576}
        {Penguin large paperback} {365 561}
        {Demy Octavo} {391 612}
        {Oufuku Card} {420 567}
        {6x8} {432 576}
        {Royal Octavo} {442 663}
        {Crown Quarto} {535 697}
        {Large Crown Quarto} {569 731}
        {8x12} {576 864}
        {RA4} {609 864}
        {American foolscap} {612 936}
        {Demy Quarto} {620 782}
        {SRA4} {637 907}
        {European foolscap} {648 936}
        {Royal Quarto} {671 884}
        {Japanese Kaku envelope \#4} {680 941}
        {11x14} {792 1008}
        {RA3} {864 1218}
        {SRA3} {907 1275}
        {16x20} {1152 1440}
        {16x24} {1152 1728}
        {RA2} {1218 1729}
    }
}

proc catalog-pagesizes {} {
    upvar \#0 ::pagesizes::sizes sizes
    foreach {name value} $sizes {
        lappend catalog $name
    }
    return $catalog
}

proc default-pagesize {} {
    upvar \#0 ::pagesizes::defsize defsize
    return $defsize
}

proc pagesize {name} {
    upvar \#0 ::pagesizes::sizes sizes
    set i [lsearch -exact $sizes $name]
    if {$i >= 0} {
        return [lindex $sizes [expr {$i+1}]]
    } else {
        error "unknown pagesize name $name"
    }
}
