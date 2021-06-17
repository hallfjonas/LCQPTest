# nash1.mod	QQR2-MN-8-5
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 9

# Number of variables:  6 + 2 slacks
# Number of constraints: 4

var x{1..2} >= 0, <= 10;
var y{1..2};
var l{1..2} >= 0;		# Multipliers

minimize f: ( (x[1] - y[1])^2 + (x[2] - y[2])^2 )/2;

subject to 

   F1: 0 = -34 + 2*y[1] + (8/3)*y[2]   - ( -l[1] ) ;
   F2: 0 = -24.25 + 1.25*y[1] + 2*y[2] - ( -l[2] ) ;

   g1: 0 <= - x[2] - y[1] + 15   complements   l[1] >= 0;
   g2: 0 <= - x[1] - y[2] + 15   complements   l[2] >= 0;

set InitPoints;
param iptx1 {InitPoints};
param iptx2 {InitPoints};

