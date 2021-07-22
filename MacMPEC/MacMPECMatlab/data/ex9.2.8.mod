# ex9.2.8.mod QLR-AY-NLP-6-5-2
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.9 in the Test Collection Book
# Test problem 9.2.8 in the web page
# Test problem from Yezza 96
# Bilinear Inner Objective

set I := 1..2;

var x >= 0, <= 1;
var y >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: -4*x*y + 3*y + 2*x + 1;

subject to 

   # ... Inner Problem Constraints
   c1:  -y + s[1] = 0;
   c2:   y + s[2] = 1;

   # ... KKT conditions for the inner problem optimum
   kt1:  -(1 - 4*x) - l[1] + l[2] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
