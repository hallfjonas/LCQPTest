# flp2.mod	QLR-AN-LCP-4-2-2
# 
# Problem 2 from Fukushima, M. Luo, Z.-Q.Pang, J.-S.,
# "A globally convergent Sequential Quadratic Programming
# Algorithm for Mathematical Programs with Linear Complementarity 
# Constraints", Computational Optimization and Applications, 10(1),
# pp. 5-34, 1998.
#
# Note: Problem 1 is equivalent to stackelberg1.mod 

var x{1..2} >= 0, <= 10;
var y{1..2} >= 0;

minimize objf: 0.5*( (x[1]+x[2]+y[1]-15)^2 + (x[1]+x[2]+y[2]-15)^2 );

subject to 

   compl1: 0 <= y[1]   complements
	   0 <= 8/3*x[1] + 2*x[2] + 2*y[1] + 8/3*y[2] - 36;

   compl2: 0 <= y[2]   complements
	   0 <= 2*x[1] + 5/4*x[2] + 5/4*y[1] + 2*y[2] - 25;

