# ex9.1.1.mod LLR-AY-NLP-13-12-5
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.2 in the Test Collection Book
# Test problem 9.1.1 in the web page
# Test problem from Clark and Westerberg 1990
#
# Is there a mistake in constraint kt2? l[2] appears twice!

set I := 1..5;

var y1;
var y2;
var x >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize objf: - x - 3*y1 + 2*y2;

subject to

   # ... Inner Problem Constraints
   c1: -2*x +   y1 + 4*y2 + s[1] = 16;
   c2:  8*x + 3*y1 - 2*y2 + s[2] = 48;
   c3: -2*x +   y1 - 3*y2 + s[3] = -12;
   c4:      -   y1        + s[4] = 0;
   c5:          y1        + s[5] = 4;

   # ... KKT conditions for the inner problem optimum
   kt1:  -1 + l[1] + 3*l[2] + l[3] - l[4] + l[5] = 0;
   kt2:              4*l[2] - 2*l[2] - 3*l[3] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;

