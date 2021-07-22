# ex9.1.10.mod LLR-AY-NLP-14-12-5
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.10 in the Test Collection Book
# Test problem 9.1.10 in the web page
# Test problem from Tuy et al  93


set I := 1..5;

var x1 >= 0;
var x2 >= 0;
var y1 >= 0;
var y2 >= 0;
var y3 >= 0;
var s{I} >= 0; 
var l{I} >= 0; 

# ... Outer Objective function
minimize ob: - 2*x1 + x2 + 0.5*y1;

subject to 

   # ... Outer constraint
   c0:    x1 +   x2  <= 2;

   # ... Inner Problem Constraints
   c1: -2*x1 +   y1 - y2 + s[1]   = -2.5;
   c2:    x1 - 3*x2 + y2 + s[2]   = 2;
   c3:  -y1 + s[3] = 0;
   c4:  -y2 + s[4] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:    l[1] - l[3] = 4;
   kt2:    l[1] + l[2] - l[4] = -1;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
