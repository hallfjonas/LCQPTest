# bard2.mod	QQR2-MN-
# Original AMPL coding by Sven Leyffer

# An MPEC from J.F. Bard, Convex two-level optimization,
# Mathematical Programming 40(1), 15-27, 1988.
# From Aiyoshi & Shimizu, IEEE Trans Syst Man & Cyb SMC-11 (1981),
# 444-449.

# Corrected index error in constraint lin_12 (S Leyffer)

# Number of variables:   8 + 4 slack + 4 multipliers
# Number of constraints: 9
# Nonlinear complementarity constraints

set N := 1..2;
param u_x{N,N};
param u_y{N,N};

var x{i in N, j in N} >= 0 <= u_x[i,j];
var y{i in N, j in N} >= 0 <= u_y[i,j];

# ... multipliers
var l{N,N};

maximize f:   (200 - y[1,1] - y[2,1])*(y[1,1] + y[2,1])
            + (160 - y[1,2] - y[2,2])*(y[1,2] + y[2,2]);

subject to 

   lincs:  x[1,1] + x[1,2] + x[2,1] + x[2,2] <= 40;

   KKT1_1: 2*(y[1,1] - 4)  + l[1,1]*0.4 + l[1,2]*0.6 = 0;
   KKT1_2: 2*(y[1,2] - 13) + l[1,1]*0.7 + l[1,2]*0.3 = 0;

   lin_11: 0 <= x[1,1] - 0.4*y[1,1] - 0.7*y[1,2]  complements  l[1,1] >= 0;
   lin_12: 0 <= x[1,2] - 0.6*y[1,1] - 0.3*y[1,2]  complements  l[1,2] >= 0;

   KKT2_1: 2*(y[2,1] - 35)  + l[2,1]*0.4 + l[2,2]*0.6 = 0;
   KKT2_2: 2*(y[2,2] - 2) + l[2,1]*0.7 + l[2,2]*0.3 = 0;

   lin_21: 0 <= x[2,1] - 0.4*y[2,1] - 0.7*y[2,2]  complements  l[2,1] >= 0;
   lin_22: 0 <= x[2,2] - 0.6*y[2,1] - 0.3*y[2,2]  complements  l[2,2] >= 0;

data;

param u_x:	 1	 2	 :=
	1	10	 5
	2	15	20;

param u_y:	 1	 2	 :=
	1	20	20
	2	40	40;
