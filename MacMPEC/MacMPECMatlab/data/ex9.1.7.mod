# ex9.1.7.mod LLR-AY-NLP-17-15-6
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.8 in the Test Collection Book
# Test problem 9.1.7 in the web page
# Test Problem from Bard and Falk 1982
# Originally from Candler-Townsley 78

set I := 1..6;

var x1 >= 0;
var x2 >= 0;
var y1 >= 0;
var y2 >= 0;
var y3 >= 0;
var s{I} >= 0; 
var l{I} >= 0; 

# ... Outer Objective function
minimize c1: -8*x1 - 4*x2 + 4*y1 - 40*y2 + 4*y3;

subject to 
   # ... Inner Problem Constraints
   c2: -y1 + y2 + y3 + s[1] = 1;
   c3: 2*x1 - y1 + 2*y2 - 0.5*y3 + s[2] = 1;
   c4: 2*x2 + 2*y1 - y2 - 0.5*y3 + s[3] = 1;
   c5: - y1 + s[4] = 0;
   c6: - y2 + s[5] = 0; 
   c7: - y3 + s[6] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:  -l[1] - l[2] + 2*l[3] - l[4] = -1;
   kt2:   l[1] + 2*l[2] - l[3] - l[5] = -1;
   kt3:   l[1] - 0.5*l[2] - 0.5*l[3] - l[6] = -2;

   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
