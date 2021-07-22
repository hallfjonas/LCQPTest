# ex9.2.4.mod QLR-AY-NLP-8-7-2
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.5 in the Test Collection Book
# Test problem 9.2.4 in the web page
# Test problem from Yezza 1996

set I := 1..2;

var l1;
var x >= 0;
var y1 >= 0;
var y2 >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: 0.5*( y1- 2)*(y1 - 2) + 0.5*(y2-2)*(y2 - 2);

subject to

   # ... Inner Problem Constraints
   c1:   y1 + y2 = x;
   c2: - y1      + s[1] = 0; 
   c3:      - y2 + s[2] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1: y1 + l1 - l[1] = 0;
   kt2:  1 + l1 - l[2] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
