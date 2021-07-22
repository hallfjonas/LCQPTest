# scholtes4.mod	LQR2-MN-3-2
# Original AMPL coding by Sven Leyffer

# An LPEC from S. Scholtes, Judge Inst., University of Cambridge.

# Number of variables:   3 slack
# Number of constraints: 2

var z{1..2} >= 0;
var z3;

minimize objf: z[1] + z[2] - z3;

subject to 
   lin1:   -4 * z[1] + z3 <= 0;
   lin2:   -4 * z[2] + z3 <= 0;

   compl:  0 <= z[1]    complements    z[2] >= 0;

data; 

let z[1] := 0;
let z[2] := 1;
let z3   := 0;
