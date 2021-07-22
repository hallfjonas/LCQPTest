# bilevel2m.mod	QQR2-MN-20-13
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 10

# Number of variables:   16 + 4 slacks
# Number of constraints: 13
# Nonlinear complementarity constraint

set I := 1..4;
param ubx {I};			# upper bounds on x

var x {i in I} >= 0, <= ubx[i];
var y{I};
var l{1..8};		# Multipliers

minimize f: - (200 - y[1] - y[3])*(y[1] + y[3]) - (160 - y[2] - y[4])*(y[2] + y[4]);

subject to 
   l1: x[1] + x[2] + x[3] + x[4] <= 40;
   F1:  0 = y[1] - 4  - ( - 0.4*l[1] - 0.6*l[2] + l[3]);
   F2:  0 = y[2] - 13 - ( - 0.7*l[1] - 0.3*l[2] + l[4]);
   F3:  0 = y[3] - 35 - ( - 0.4*l[5] - 0.6*l[6] + l[7]);
   F4:  0 = y[4] - 2  - ( - 0.7*l[5] - 0.3*l[6] + l[8]);

   g1:  0 <= x[1] - 0.4*y[1] - 0.7*y[2]   complements   l[1]  >= 0;
   g2:  0 <= x[2] - 0.6*y[1] - 0.3*y[2]   complements   l[2]  >= 0;
   m1:  0 <= y[1] <= 20                   complements   l[3];
   m2:  0 <= y[2] <= 20                   complements   l[4];
   g7:  0 <= x[3] - 0.4*y[3] - 0.7*y[4]   complements   l[5]  >= 0;
   g8:  0 <= x[4] - 0.6*y[3] - 0.3*y[4]   complements   l[6]  >= 0;
   m3:  0 <= y[3] <= 40                   complements   l[7];
   m4:  0 <= y[4] <= 40                   complements   l[8];

data;
param: 		ubx,	 x := 
	1 	10	 5
	2	 5	 5
	3	15	15	
	4	20	15;

