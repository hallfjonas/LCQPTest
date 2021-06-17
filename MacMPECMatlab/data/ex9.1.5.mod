# ex9.1.5.mod LLR-AY-NLP-13-12-5 
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.5 in the Test Collection Book
# Test problem 9.1.5 in the web page
# Test problem from Bard 91
# Note there is a typo in the Book corrected here

set I := 1..5;

var x >= 0;
var y1 >= 0;
var y2 >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize ob: - x + 10*y1 - y2;

subject to 

   # ... Inner Problem Constraints
   c1:    x + y1 + s[1]   = 1;
   c2:    x + y2 + s[2]   = 1;
   c3:   y1 +  y2 + s[3] = 1;
   c4:  -y1 + s[4] = 0;
   c5:  -y2 + s[5] = 0;

   # ... KKT conditions for the inner problem optimum
   kt1:    l[1] + l[3] - l[4] = 1;
   kt2:    l[2] + l[3] - l[5] = 1;
   
   compl{i in I}: 0 <= l[i]   complements   s[i] >= 0;
