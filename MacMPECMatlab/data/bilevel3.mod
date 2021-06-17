# bilevel3.mod	QQR2-MN-16-12
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 11

# Number of variables:   12 
# Number of constraints: 11
# Nonlinear complementarity constraint

var x{1..2} >= 0;
var y{1..6};
var l{1..4};			# Multipliers

minimize f: - x[1]^2 - 3*x[2] - 4*y[1] + y[2]^2;

subject to 
   c1:  x[1]^2 + 2*x[2] <= 4;
   F1:  0 = 2*y[1] + 2*y[3] - 3*y[4] - y[5];
   F2:  0 = - 5 - y[3] + 4*y[4] - y[6];
   F3:  0 = x[1]^2 - 2*x[1] + x[2]^2 - 2*y[1] + y[2] + 3 - ( l[1] );
   F4:  0 = x[2] + 3*y[1] - 4*y[2] - 4      - ( l[2] );
   F5:  0 = y[1]                            - ( l[3] );
   F6:  0 = y[2]                            - ( l[4] );

   g1:  0 <= l[1]   complements   y[3] >= 0;
   g2:  0 <= l[2]   complements   y[4] >= 0;
   g3:  0 <= l[3]   complements   y[5] >= 0;
   g4:  0 <= l[4]   complements   y[6] >= 0;

data;

let x[1] :=  0;
let x[2] :=  2;


        

