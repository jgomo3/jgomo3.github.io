{:title "Rings Go Coordinate System"
 :layout :page
 :page-index 0
 :navbar? true
 :tags ["es"]}

# Rings Coordinate System

Select your ring (1, 2, etc.), then tell how many movements clockwise
(+) or counterclockwise (-).  Select a quadrant (a, b, c or d) only if
needed.

```
9x9

a1   a1+1 a1+2 a1+3 a1b b1-3 b1-2 b1-1 b1
a1-1 a2   a2+1 a2+2 a2b b2-2 b2-1 b2   b1+1
a1-2 a2-1 a3   a3+1 a3b b3-1 b3   b2+1 b1+2
a1-3 a2-2 a3-1 a4   a4b b4   b3+1 b2+2 b1+3
d1a  d2a  d3a  d4a  5   b4c  b3c  b2c  b1c
d1+3 d2+2 d3+1 d4   c4d c4   c3-1 c2-2 c1-3
d1+2 d2+1 d3   d3-1 c3d c3+1 c3   c2-1 c1-2
d1+1 d2   d2-1 d2-2 c2d c2+2 c2+1 c2   c1-1
d1   d1-1 d1-2 d1-3 c1d c1+3 c1+2 c1+1 c1
```

Flexible.  In the 9x9 board, a1b could have been a1+4 or b1-4, and b1
could have been a1+8.  Mention the quadrants (a, b, c, or d) only if
needed.

Examples:

**Tsumego**
Black: 1-1, 2,   2+1, 2+2, 1+4
White: 1-2, 2-1, 3,   3+1, 3+2, 2+3, 1+5

**Fuseki**
4 3-3 3+3 2-2 3 3-6

It is straightforward to point 1 single point on the board.  But until
you get used to "selecting" the ring first, it is harder to point a
sequence of points than other coordinate systems.

This system was Inspired by Audouard Coordinates[1] but with emphasis
on the rings.

[1] https://senseis.xmp.net/?AudouardCoordinates

Jesús Gómez
@jgomo3
October 2024
