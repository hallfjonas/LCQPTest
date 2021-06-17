# ex9.2.5.mod QLR-AY-NLP-8-7-3
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.6 in the Test Collection Book
# Test problem 9.2.5 in the web page
# Test problem from Clark and Westerberg 1990a

set I := 1..3;

var y;

var x >= 0, <= 8;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: (x-3)*(x-3) + (y-2)*(y-2);

subject to 

   # ... Inner Problem Constraints
   c1: -2*x +   y + s[1] = 1;
   c2:    x - 2*y + s[2] = 2;
   c3:    x + 2*y + s[3] = 14;

   # ... KKT conditions for the inner problem optimum
   kt1:  2*(y-5) + l[1] - 2*l[2] + 2*l[3]  = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
