# stackelberg1.mod	QQR2-MN-4-2
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 6

# Number of variables:   3
# Number of constraints: 2

var x >= 0, <= 200;
var y >= 0;
var l >= 0;		# Multipliers

minimize f: 0.5*x^2 + 0.5*x*y - 95*x;

subject to 
   F: 2*y + 0.5*x - 100 - l = 0;
   g: 0 <= y   complements   l >= 0;



        

