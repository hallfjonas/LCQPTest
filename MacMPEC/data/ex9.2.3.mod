# ex9.2.3.mod LLR-AY-NLP-16-16-6
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.4 in the Test Collection Book
# Test problem 9.2.3 in the web page
# Test problem from Visweswaran etal 1996
# Originally from Shimizu Aiyoshi 81
# Ouadratic Outer and Inner Objective - Nonlinear

#********************************************
# This program locates the LOCAL minimum
#********************************************

set I := 1..6;

var y1 >= -8;
var y2 >= -8;
var x1 >= 1, <= 50;
var x2 >= 1, <= 50;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: 2*x1 + 2*x2 - 3*y1 - 3*y2 - 60;

subject to 

   # ... Outer Problem Constraints
   o1:   x1 + x2 + y1 - 2*y2  <= 40;

   # ... Inner Problem Constraints
   c1: - x1 + 2*y1 + s[1] = -10;
   c2: - x2 + 2*y2 + s[2] = -10;
   c3:      -   y1 + s[3] = 10;
   c4:          y1 + s[4] = 20;
   c5:      -   y2 + s[5] = 10;
   c6:          y2 + s[6] = 20;

   # ... KKT conditions for the inner problem optimum
   kt1: 2*(y1 - x1 + 20) + 2*l[1] - l[3] + l[4] = 0;
   kt2: 2*(y2 - x2 + 20) + 2*l[2] - l[5] + l[6] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
