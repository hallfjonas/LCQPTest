# bard3.mod	QQR2-MN-8-6
# Original AMPL coding by Sven Leyffer

# An MPEC from J.F. Bard, Convex two-level optimization,
# Mathematical Programming 40(1), 15-27, 1988.

# Number of variables:   4 + 2 multipliers
# Number of constraints: 5

set N := 1..2;

var x{N} >= 0;
var y{N} >= 0;

# ... slack variables & multipliers
var l{N} >= 0;

minimize f: - x[1]^2 - 3*x[2] - 4*y[1] + y[2]^2;

subject to 

   nlncs: x[1]^2 + 2*x[2] <= 4;

   KKT1:  2*y[1] + l[1]*2 - l[2]*3 = 0;
   KKT2:  -5     - l[1]   + l[2]*4 = 0;

   lin_1: 0 <= x[1]^2 - 2*x[1] + x[2]^2 - 2*y[1] + y[2] + 3
	  complements l[1] >= 0;

   lin_2: 0 <= x[2] + 3*y[1] - 4*y[2] - 4
	  complements l[2] >= 0;
   
