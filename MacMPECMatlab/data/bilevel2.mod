# bilevel2.mod	QQR2-MN-32-18
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 10

# Number of variables:   20 + 12 slacks
# Number of constraints: 17
# Nonlinear complementarity constraint

set I := 1..4;
param ubx {I};			# upper bounds on x

var x {i in I} >= 0, <= ubx[i];
var y{I};
var l{1..12} >= 0;		# Multipliers

minimize f: - (200 - y[1] - y[3])*(y[1] + y[3]) - (160 - y[2] - y[4])*(y[2] + y[4]);

subject to 
   l1: x[1] + x[2] + x[3] + x[4] <= 40;
   F1:  0 = y[1] - 4  - ( - 0.4*l[1] - 0.6*l[2] + l[3] - l[4]);
   F2:  0 = y[2] - 13 - ( - 0.7*l[1] - 0.3*l[2] + l[5] - l[6]);
   F3:  0 = y[3] - 35 - ( - 0.4*l[7] - 0.6*l[8] + l[9] - l[10]);
   F4:  0 = y[4] - 2  - ( - 0.7*l[7] - 0.3*l[8] + l[11] - l[12]);
   g1:  0 <= x[1] - 0.4*y[1] - 0.7*y[2]   complements   l[1]  >= 0;
   g2:  0 <= x[2] - 0.6*y[1] - 0.3*y[2]   complements   l[2]  >= 0;
   g3:  0 <= y[1]                         complements   l[3]  >= 0;
   g4:  0 <= - y[1] + 20                  complements   l[4]  >= 0;
   g5:  0 <= y[2]                         complements   l[5]  >= 0;
   g6:  0 <= - y[2] + 20                  complements   l[6]  >= 0;
   g7:  0 <= x[3] - 0.4*y[3] - 0.7*y[4]   complements   l[7]  >= 0;
   g8:  0 <= x[4] - 0.6*y[3] - 0.3*y[4]   complements   l[8]  >= 0;
   g9:  0 <= y[3]                         complements   l[9]  >= 0; 
   g10: 0 <= - y[3] + 40                  complements   l[10] >= 0;
   g11: 0 <= y[4]                         complements   l[11] >= 0;
   g12: 0 <= -y[4] + 40                   complements   l[12] >= 0;

data;
param: 		ubx,	 x := 
	1 	10	 5
	2	 5	 5
	3	15	15	
	4	20	15;

