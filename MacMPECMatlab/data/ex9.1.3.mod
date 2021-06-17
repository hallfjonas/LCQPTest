# ex9.1.3.mod LLR-AY-NLP-23-21-6
# AMPL coding by Sven Leyffer, Apr. 2001,

# From Nonconvex Optimization and its Applications, Volume 33
# Kluwer Academic Publishers, Dordrecht, Hardbound, ISBN 0-7923-5801-5
# (see also titan.princeton.edu/TestProblems/)
#
# Test problem 9.2.3 in the Test Collection Book
# Test problem 9.1.3 in the web page
# Test problem from Candler-Townsley 82
#
# Removed MI-model of complementarity.

set I := 1..6;
set J := 1..3;

var y{I}  >= 0;
var mu{J};
var x{J} >= 0;
var s{I} >= 0;
var l{I} >= 0;

# ... Outer Objective function
minimize c1: 4*y[1] - 40*y[2] - 4*y[3] - 8*x[1] - 4*x[2];

subject to 

   # ... Inner Problem Constraints
   c2:  -y[1] +   y[2] +     y[3] + y[4]                    = 1;
   c3:  -y[1] + 2*y[2] - 0.5*y[3]      + y[5]      + 2*x[1] = 1;
   c4: 2*y[1] -   y[2] - 0.5*y[3]           + y[6] + 2*x[2] = 1;
   c5:  - y[1] + s[1] = 0;
   c6:  - y[2] + s[2] = 0; 
   c7:  - y[3] + s[3] = 0;
   c8:  - y[4] + s[4] = 0;
   c9:  - y[5] + s[5] = 0;
   c10: - y[6] + s[6] = 0; 

   # ... KKT conditions for the inner problem optimum
   kt1:  1 - mu[1] -     mu[2] +   2*mu[3] - l[1] = 0;
   kt2:  1 + mu[1] +   2*mu[2] -     mu[3] - l[2] = 0;
   kt3:  2 + mu[1] - 0.5*mu[2] - 0.5*mu[3] - l[3] = 0;
   kt4:  mu[1] - l[4] = 0;
   kt5:  mu[2] - l[5] = 0;
   kt6:  mu[3] - l[6] = 0;


   # ... Complementarity Constraints
   compl {i in I}: 0 <= l[i]    complements   s[i] >= 0;
