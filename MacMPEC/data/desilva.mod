# desilva.mod	QQR2-MN-8-5
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 5

# Number of variables:   6 
# Number of constraints: 4

var x{1..2} >= 0, <= 2;
var y{1..2};
var l{1..2} >= 0;		# Multipliers

minimize f: x[1]^2 - 2*x[1] + x[2]^2 - 2*x[2] + y[1]^2 + y[2]^2;

subject to 

   F1: 2*y[1] - 2*x[1] + 2*(y[1] - 1)*l[1] = 0;
   F2: 2*y[2] - 2*x[2] + 2*(y[2] - 1)*l[2] = 0;

   g1: 0 <= 0.25 - (y[1] - 1)^2   complements   l[1] >= 0;
   g2: 0 <= 0.25 - (y[2] - 1)^2   complements   l[2] >= 0; 



        

