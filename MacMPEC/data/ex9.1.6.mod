# ex9.1.6.mod LLR-AY-NLP-14-13-6 
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.7 in the Test Collection Book
# Test problem 9.1.6 in the web page
# Test Problem from Anandalingam and White 1990
# They took from Bialas and Karwan 1982

set I := 1..6;

var x >= 0; 
var y >= 0; 
var s{I} >= 0; 
var l{I} >= 0; 

# ... Outer Objective function
minimize ob: -x -3*y;

subject to 

   # ... Inner Problem Constraints
   c1:  - x - 2*y + s[1] = -10;
   c2:    x - 2*y + s[2] = 6;
   c3:  2*x -   y + s[3] = 21;
   c4:    x + 2*y + s[4] = 38;
   c5:   -x + 2*y + s[5] = 18;
   c6:        - y + s[6] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:  3 - 2*l[1] - 2*l[2] - l[3] 
         + 2* l[4] + 2*l[5] - l[6] = 0;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
