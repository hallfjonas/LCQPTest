# bilin.mod	QQR2-MN-8-5
# Original AMPL coding by Sven Leyffer

# An bilevel linear program due to Hansen, Jaumard and Savard,
# "New branch-and-bound rules for linear bilevel programming,
# SIAM J. Sci. Stat. Comp. 13, 1194-1217, 1992. See also book
# Mathematical Programs with Equilibrium Constraints,
# by Luo, Pang & Ralph, CUP, 1997, p. 357.

# Number of variables:   2 + 3 multipliers
# Number of constraints: 4

var x{1..2} >= 0;

# ...multipliers
var y{1..6} >= 0;

maximize f: 8*x[1] + 4*x[2] - 4*y[1] + 40*y[2] + 4*y[3];

subject to 

   lin:    x[1] + 2*x[2] - y[3] <= 1.3;

   KKT1:   0 <= 2 - y[4] - 2*y[5] + 4*y[6]           complements  y[1] >= 0;
   KKT2:   0 <= 1 + y[4] + 4*y[5] - 2*y[6]           complements  y[2] >= 0;
   KKT3:   0 <= 2 + y[4] - y[5] - y[6]               complements  y[3] >= 0;

   slack1: 0 <= 1 + y[1] - y[2] - y[3]               complements  y[4] >= 0;
   slack2: 0 <= 2 - 4*x[1] + 2*y[1] - 4*y[2] + y[3]  complements  y[5] >= 0;
   slack3: 0 <= 2 - 4*x[2] - 4*y[1] + 2*y[2] + y[3]  complements  y[6] >= 0;

data;

# starting point 1
let{i in {1..2}} x[i] := 1.0;
let{i in {1..6}} y[i] := 1.0;

# starting point 2 (simply uncomment)
## let x[1] := 0.5;
## let x[1] := 1.0;
## let{i in {1..6}} y[i] := 1.0;
## let y[1] := 0.5;
## let y[2] := 0.5;
## let{i in {1..6}} w[i] := 0.1;



        

