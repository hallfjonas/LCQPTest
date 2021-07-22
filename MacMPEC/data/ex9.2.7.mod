# ex9.2.7.mod QLR-AY-NLP-10-9-4
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.8 in the Test Collection Book
# Test problem 9.2.7 in the web page
# Test problem from Visweswaran etal 1996

set I := 1..4;

var x >= 0;
var y >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: (x - 5)*(x-5) + (2*y + 1)*(2*y + 1);

subject to 

   # ... Inner Problem Constraints
   c1: -3*x +     y + s[1] = -3;
   c2:    x - 0.5*y + s[2] =  4;
   c3:    x +     y + s[3] =  7;
   c4:      -     y + s[4] =  0;

   # ... KKT conditions for the inner problem optimum
   kt1: 2*(y-1) - 1.5*x + l[1] - 0.5*l[2] + l[3] - l[4] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
