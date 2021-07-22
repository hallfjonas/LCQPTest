# bard1.mod	QQR2-MN-8-5
# Original AMPL coding by Sven Leyffer

# An MPEC from J.F. Bard, Convex two-level optimization,
# Mathematical Programming 40(1), 15-27, 1988.

# Number of variables:   2 + 3 slack + 3 multipliers
# Number of constraints: 4

var x >= 0;
var y >= 0;

# ... multipliers
var l{1..3};

minimize f:(x - 5)^2 + (2*y + 1)^2;

subject to 

   KKT:    2*(y-1) - 1.5*x + l[1] - l[2]*0.5 + l[3] = 0;

   lin_1:  0 <= 3*x - y - 3        complements l[1] >= 0;
   lin_2:  0 <= - x + 0.5*y + 4    complements l[2] >= 0;
   lin_3:  0 <= - x - y + 7        complements l[3] >= 0;

   



        

