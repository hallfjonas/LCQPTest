# ex9.1.9.mod LLR-AY-NLP-12-11-5
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.10 in the Test Collection Book
# Test problem 9.1.9 in the web page
# Test Problem from visweswaran-etal 1996
# Taken from Bard 1983

set I := 1..5;

var x >= 0;
var y >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize c1: x + y;

subject to 

   # ... Inner Problem Constraints
   c2:       -x - 0.5*y + s[1] = -2;
   c3:  -0.25*x +     y + s[2] =  2;
   c4:        x + 0.5*y + s[3] =  8;
   c5:        x -   2*y + s[4] =  2;
   c6: - y + s[5] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:  -0.5*l[1] + l[2] + 0.5*l[3] - 2*l[4] - l[5] = 1;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
