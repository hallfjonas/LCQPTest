# bilevel1.mod	QQR2-MN-16-10
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 7

# Number of variables:   10 
# Number of constraints: 9

var x{1..2} >= 0, <= 50;
var y{1..2};
var l{1..6} >= 0;		# Multipliers

minimize f: 2*x[1] + 2*x[2] - 3*y[1] - 3*y[2] - 60;

subject to 

   c1: x[1] + x[2] + y[1] - 2*y[2] - 40 <= 0;
   F1: 0 = 2*y[1] - 2*x[1] + 40 - (l[1] - l[2] - 2*l[5]);
   F2: 0 = 2*y[2] - 2*x[2] + 40 - (l[3] - l[4] - 2*l[6]);

   g1: 0 <= y[1] + 10            complements  l[1] >= 0;
   g2: 0 <= -y[1] + 20           complements  l[2] >= 0;
   g3: 0 <= y[2] + 10            complements  l[3] >= 0;
   g4: 0 <= -y[2] + 20           complements  l[4] >= 0;
   g5: 0 <= x[1] - 2*y[1] - 10   complements  l[5] >= 0;
   g6: 0 <= x[2] - 2*y[2] - 10   complements  l[6] >= 0;





        

