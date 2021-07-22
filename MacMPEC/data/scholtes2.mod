# scholtes1.mod	QOR2-MN-4-2
# Original AMPL coding by Sven Leyffer

# An MPEC from S. Scholtes, Research Papers in Management Studies, 26/1997,
# The Judge Institute, University of Cambridge, England.

# Number of variables:   3 
# Number of constraints: 1

var x >= 0, := 1;
var y{1..2} := 1;

minimize f:(x + 1)^2 + y[1]^2 + 10*(y[2] + 1)^2;

subject to 
   lin_cs: y[2] >= 0;
   nln_cs: 0 <= -exp(x) + y[1] - exp(y[2])   complements   x >= 0;

   



        

