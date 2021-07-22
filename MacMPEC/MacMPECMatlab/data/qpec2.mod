# qpec2.mod	QQR2-MN-v-v
# Original AMPL coding by Sven Leyffer, University of Dundee

# A QPEC from H. Jiang and D. Ralph, Smooth SQP methods for mathematical
# programs with nonlinear complementarity constraints, University of
# Melbourne, December 1997.

# Number of variables:  v 
# Number of constraints: v

# ... parameters enlarge the problem 
param n := 10;			# number of controls (upper level vars)
param m := 20;			# number of states (complementary vars)
set N  := 1..n;
set M  := 1..m;			# NOTE: Assume m >= n
set NM := (n+1)..m;

# ... constants
param rr{N} := -1.0;
param ss{M} := -2.0;

# ... variables
var x{N};
var y{M} >= 0;
var s{N} >= 0;

# ... problem statement
minimize f: sum{i in N}( (x[i] + rr[i])^2 ) + sum{j in M}( (y[j] + ss[j])^2 );

subject to 

   lin1{i in N}:  0 <= y[i] - x[i]   complements   y[i] >= 0;

   lin2{i in NM}: 0 <= y[i]          complements   y[i] >= 0;

data;
let {i in N} x[i] := 1.0;
let {j in M} y[j] := 1.0;
