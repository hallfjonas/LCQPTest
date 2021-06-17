# dempe.mod	QQR2-MN-4-3
# Original AMPL coding by Sven Leyffer

# An MPEC from S. Dempe, "A necessary and sufficient optimality
# condition for bilevel programming problems", Optimization 25,
# pp. 341-354, 1992. From book Math. Progr. with Equil. Constr,
# by Luo, Pang & Ralph, CUP, 1997, p. 354.

# Number of variables:   2 + 1 multipliers
# Number of constraints: 2
# Nonlinear complementarity constraints

var x;
var z;
var w >= 0;

minimize f: (x - 3.5)^2 + (z + 4)^2;

subject to 
    con1:  z - 3 + 2*z*w = 0;
    con2:  0 >= z^2 - x     complements  w >= 0;

data;

# starting point 
let x := 1;
let z := 1;
let w := 1;


let x :=   0.183193 ;
let z := 0.428106;
let w := 3.00379;



        

