# scholtes3.mod	QOR2-MN-2-0
# Original AMPL coding by Sven Leyffer

# An QPEC from S. Scholtes

# Number of variables:   2 slack
# Number of constraints: 0

var x{1..2} >= 0;

minimize objf: 0.5*( (x[1] - 1)^2 + (x[2] - 1)^2 );

subject to 
   LCP:  0 <= x[1]   complements   x[2] >= 0;

data;

# start point close to (0,0)
let x[1] := 0.0001;
let x[2] := 0.0001;

#solve;
        
#display _varname, _var.lb, _var.val , _var.ub, _var.dual;
#display _conname, _con.lb, _con.body, _con.ub, _con;

