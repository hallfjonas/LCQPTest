# outrata31.mod	QUR-AN-NCP-5-0-4
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from S. Scholtes, Research Papers in Management Studies, 26/1997,
# The Judge Institute, University of Cambridge, England.
# See also Outrata, SIAM J. Optim. 4(2), pp.340ff, 1994.

# Number of variables:   5 
# Number of constraints: 5

var x{1..4} >= 0;
var y >= 0, <= 10;

minimize f: ( (x[1] - 3)^2 + (x[2] - 4)^2 )/2;

subject to 

   nlcs1: 0 <= (1 + 0.2*y)*x[1] - (3 + 1.333*y) - 0.333*x[3] + 2*x[1]*x[4]
							   complements  x[1] >= 0;
   nlcs2: 0 <= (1 + 0.1*y)*x[2] - y + x[3] + 2*x[2]*x[4]   complements  x[2] >= 0;
   nlcs3: 0 <= 0.333*x[1] - x[2] + 1 - 0.1*y               complements  x[3] >= 0;
   nlcs4: 0 <= 9 + 0.1*y - x[1]^2 - x[2]^2                 complements  x[4] >= 0;



   



        

