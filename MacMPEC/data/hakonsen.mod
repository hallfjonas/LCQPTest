# hakonsen.mod	OOR2-MY-9-8-4
# Original AMPL coding by Sven Leyffer, Feb. 2001.

# MPEC of taxation model taken from (6)-(10) of
# Light, M., "Optimal taxation: An application of mathematical 
# programming with equilibrium constraints in economics", 
# Department of Economics, University of Colorado, Boulder, 1999.
# attributed to Hakonsen, L. "Essays on Taxation, Efficiency and the 
# Environment", PhD thesis, Norwegian School of Economics & Business 
# Administration, April 1998.

set I := 1..2;

# ... constants
param L  := 100;	# ... units of time
param G  := 25;		# ... collected revenue (tax)
param pL := 1;		# ... wage chosen as numerairs

# ... model variables
var x{I} >= 0, := 1;	# ... consumption (=1 to avoid error with obj)
var l    >= 0, := 1;	# ... leisure
var p{I} >= 0;		# ... prices
var t{I} >= 0;		# ... tax rates

# ... maximize utility function
maximize utility: ( x[1]*x[2]*l )^(1/3);

subject to 

   prices{i in I}: pL >= p[i]   complements   x[i] >= 0;

   # ... multiply lhs by denominator avoids div. by 0
   consum{i in I}: x[i] * (3*p[i]*(1+t[i])) >= 100*pL 
   			complements   p[i] >= 0;

   # ... dropped in reference (?)
   equatn: L*pL = sum{i in I}(x[i]*p[i]) + l*pL + G;

   revenue: sum{i in I} p[i]*t[i]*x[i] >= G;


   




        

