# ex9.2.9.mod LLR-AY-NLP-9-8-3
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.3.10 in the Test Collection Book
# Test problem 9.2.9 in the web page
# Test problem from Bard 91

set I := 1..3;

var x >= 2, <= 4;
var y1 >= 0;
var y2 >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: x + y2;

subject to 

   # ... Inner Problem Constraints
   c1:    x - y1 - y2 + s[1] = -4;
   c2:      - y1      + s[2] = 0;
   c3:      - y2      + s[3] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:  - l[1] - l[2] = -2;
   kt2:  - l[1] - l[3] = -x;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
