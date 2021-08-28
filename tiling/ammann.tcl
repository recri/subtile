########################################################################
##
## Ammann tilings
##

lappend subtile(tilings) \
    {{Ammann A2} ammann-A2} \
    {{Ammann A3} ammann-A3} \
    {{Ammann A4} ammann-A4} \
    {{Ammann A5 - square and rhomb} ammann-A5} \
    {{Ammann A5 - triangles and rhomb } ammann-A5T};

proc ammann-about {tiles} {
    about-something {About Ammann Tilings} {
        The Ammann tilings are described in Gruenbaum and Shephard (1987) in
        section 10.4.  The Ammann octagonal tiling, A5, is also discussed in
        Senechal (1995) section 7.3.

        There's an error in the	description of the A4 tiling - the tiling has
        a self-similar composition rule when p/q = sqrt(2)/2, not sqrt(2).

        The A5/octagonal tiling has a composition rule which requires half
        squares.
    }
    return $tiles;
}

