# sl1.mod	QQR2-MN-11-6
# Original AMPL coding by Sven Leyffer

# A QPEC obtained by varying the rhs of HS21 (a QP)
# from an idea communicated by S. Scholtes

# Number of variables:   5 + 3 multipliers
# Number of constraints: 5

set I := 1..3;
param zl{I};
param zu{I};

var x{1..2};
var z{i in I} >= zl[i], <= zu[i];

# ... slack variables & multipliers
var l{I} >= 0;

minimize f:(x[1] - 2)^2 + x[2]^2;	# min. deviation from soln

subject to 

   KKT1:   0.02*x[1] - 10*l[1] - l[2] = 0;	# ... KKT in x[1]
   KKT2:   2*x[2]    -    l[1] - l[3] = 0;	# ... KKT in x[2]

   lin_1:  0 <= 10*x[1] + x[2] - (10 + z[1])   complements   l[1] >= 0;
   lin_2:  0 <= x[1] - (2 + z[2])              complements   l[2] >= 0;
   lin_3:  0 <= x[2] - 50*z[3]                 complements   l[3] >= 0;

   
data;

param: 		zl,	zu :=
	1	10	1E10
	2	0.01	10
	3	0	1;




        

