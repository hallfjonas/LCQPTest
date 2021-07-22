# ex9.1.4.mod  LLR-AY-10-9-4
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.5 in the Test Collection Book
# Test problem 9.1.4 in the web page
# Test problem from Clark and Westerberg 1988


set I := 1..4;

var x >= 0;
var y >= 0;
var s{I} >= 0;	
var l{I} >= 0;	

# ... Outer Objective function
minimize c1:  x - 4*y;

subject to 

   # ... Inner Problem Constraints
   c2:  -2*x +   y + s[1] = 0;
   c3:   2*x + 5*y + s[2] = 108;
   c4:   2*x - 3*y + s[3] = -4;
   c5:         - y + s[4] = 0; 

   # ... KKT conditions for the inner problem optimum
   kt1:  l[1] + 5*l[2] - 3*l[3] - l[4] = -1;

   # ... Complementarity Constraints
   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;

