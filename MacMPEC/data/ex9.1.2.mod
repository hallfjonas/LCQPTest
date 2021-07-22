# ex9.1.2.mod LLR-AY-NLP-10-9-4 
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.3 in the Test Collection Book
# Test problem 9.1.2 in the web page
# Test problem from Liu and Hart 1994


set I := 1..4;

var x >= 0;
var y binary;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function

minimize objf: - x -3*y;

subject to 
   # ... Inner Problem    Constraints
   c2:  - x +   y + s[1] = 3;
   c3:    x + 2*y + s[2] = 12;
   c4:  4*x -   y + s[3] = 12;
   c5:       -  y + s[4] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:  l[1] + 2*l[2] - l[3] - l[4] = -1;

   compl {i in I}: 0 <= l[i]   complements   s[i] >= 0;

