# gnash1.mod	QQR2-MN-21-13
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from F. Facchinei, H. Jiang and L. Qi, A smoothing method for
# mathematical programs with equilibrium constraints, Universita di Roma
# Technical report, 03.96. Problem number 8
#
# Arises from Gournot Nash equilibrium , 10 instances are available 
# (see gnash1i.dat, i=0,1,...,9)

# Number of variables:   13
# Number of constraints: 13

# ... parameters for each firm/company
param c{1..5};			# c_i
param K{1..5};			# K_i
param b{1..5};			# \beta_i

# ... parameters for each problem instance
param L;			# L
param g;			# \gamma

# ... computed constants
param gg := 5000^(1/g);

var x >= 0, <= L;
var y{1..4};
var l{1..8} >= 0;		# Multipliers
var Q = x+y[1]+y[2]+y[3]+y[4];	# defined variable Q

minimize f: c[1]*x + b[1]/(b[1]+1)*K[1]^(-1/b[1])*x^((1+b[1])/b[1])
		- x*( gg*Q^(-1/g) );

subject to 

   F1: 0 = ( c[2] + K[2]^(-1/b[2])*y[1] ) - ( gg*Q^(-1/g) ) 
				- y[1]*( -1/g*gg*Q^(-1-1/g) ) - (l[1] - l[2]);
   F2: 0 = ( c[3] + K[3]^(-1/b[3])*y[2] ) - ( gg*Q^(-1/g) ) 
				- y[2]*( -1/g*gg*Q^(-1-1/g) ) - (l[3] - l[4]);
   F3: 0 = ( c[4] + K[4]^(-1/b[4])*y[3] ) - ( gg*Q^(-1/g) ) 
				- y[3]*( -1/g*gg*Q^(-1-1/g) ) - (l[5] - l[6]);
   F4: 0 = ( c[5] + K[5]^(-1/b[5])*y[4] ) - ( gg*Q^(-1/g) ) 
				- y[4]*( -1/g*gg*Q^(-1-1/g) ) - (l[7] - l[8]);

   g1: 0 <= y[1]       complements   l[1] >= 0;
   g2: 0 <= L - y[1]   complements   l[2] >= 0;
   g3: 0 <= y[2]       complements   l[3] >= 0;
   g4: 0 <= L - y[2]   complements   l[4] >= 0;
   g5: 0 <= y[3]       complements   l[5] >= 0;
   g6: 0 <= L - y[3]   complements   l[6] >= 0;
   g7: 0 <= y[4]       complements   l[7] >= 0;
   g8: 0 <= L - y[4]   complements   l[8] >= 0;



        

