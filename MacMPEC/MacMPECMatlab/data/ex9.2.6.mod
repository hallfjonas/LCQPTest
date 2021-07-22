# ex9.2.6.mod QLR-AY-NLP-16-12-6
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.7 in the Test Collection Book
# Test problem 9.2.6 in the web page
# Test problem from Falk and Liu 1995
# Original example from A.D. De Silva's dissertation 78
# Ouadratic Outer and Inner Objective - Nonlinear

set I := 1..6;

var x1 >= 0;
var x2 >= 0;
var y1 >= 0;
var y2 >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: x1*x1 - 2*x1 + x2*x2 - 2*x2 + y1*y1 + y2*y2;

subject to 

   # ... Inner Problem Constraints
   c1:  0.5 - y1 + s[1] = 0;
   c2:  0.5 - y2 + s[2] = 0;
   c3:  y1 - 1.5 + s[3] = 0;
   c4:  y2 - 1.5 + s[4] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1: 2*(y1 - x1) - l[1] + l[3] = 0;
   kt2: 2*(y2 - x2) - l[2] + l[4] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
