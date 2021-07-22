# ex9.2.2.mod QLR-AY-NLP-10-11-4
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.3 in the Test Collection Book
# Test problem 9.2.2 in the web page
# Test problem from Visweswaran etal 1996
# Originally from Shimizu Aiyoshi 81

set I := 1..4;

var x >= 0;
var y >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: x*x + (y-10)*(y-10);

subject to 

   # ... Outer Problem Constraints
   o1:   x     <= 15;
   o2: - x + y <= 0;
   o3: - x     <= 0;

   # ... Inner Problem Constraints
   c1: x + y + s[1] = 20;
   c2:   - y + s[2] = 0;
   c3:     y + s[3] = 20;

   # ... KKT conditions for the inner problem optimum
   kt1: 2*(x + 2*y - 30) + l[1] - l[2] + l[3] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
