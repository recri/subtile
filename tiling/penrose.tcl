########################################################################
##
## Penrose tilings.
##
## The penrose kite-and-dart tiling is dissected into the A
## triangulation by dividing kites along their long diagonals and darts
## along their short diagonals.
## The penrose rhomb tiling is dissected into the B triangulation by
## dividing the large rhombs along their long diagonals and the small
## rhomb along their short diagonals.
## The penrose A trianguluation is dissected into the B triangulation
## by renaming the small A triangles into large B triangles and
## dividing the large A triangles into large B and small B
## triangles.
## The penrose B triangulation is dissected into the A triangulation
## by renaming the small B triangles into large A triangles and
## dividing the large B triangles into large A and small A triangles.
##
## The reverse annealing steps are also supported.
##
## There are further complicating details necessary to preserve the
## vertex colorings which distinguish left and right handed forms of
## each triangle.
##
## Each triangle is represented as a name and three vertices.  The
## vertices are listed in counter clockwise order starting from the
## lower left corner when the triangle is sitting on its base with the
## two equal edges pointing up.  (Life would be simpler if I ordered
## the mirror image vertices as clockwise).
##
##         +
##        / \
##       /   \
##      /     \
##     /       \
##    /         \
##   /           \
##  /             \
## o---------------+
##

lappend subtile(tilings) \
    {{Penrose kite and dart} penrose-KD} \
    {{Penrose rhomb} penrose-R} \
    {{Penrose A triangles} penrose-A} \
    {{Penrose B triangles} penrose-B}

#
#
#
proc penrose-about {tiles} {
    about-something {About Penrose Tilings} {
        The Penrose tilings are discussed at length in Senechal (1995) and in
        Gruenbaum and Shephard (1987).

        Subtile implements the kite and dart tiling, the rhomb tiling, and the
        two triangulations generated by slicing kites, darts, and rhombs into
        halves.

        The A triangulation is generated by slicing kites along their long
        diagonals and darts along their short diagonals.

        The B triangulation is generated by slicing large rhombs along their
        long diagonals and small rhombs along their short diagonals.

        The A and B triangulations can be converted into each other by
        dissection or annealing. 
    }
    return $tiles;
}

