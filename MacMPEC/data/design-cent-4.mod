# design-cent-4.mod        QOR-AY-NLP-22-9-12
# 
# Design centering problem cast as an MPEC, from an idea by
# O. Stein and G. Still, "Solving semi-infinite optimization 
# problems with Interior Point techniques", Lehrstuhl C fuer 
# Mathematik, Rheinisch Westfaelische Technische Hochschule,
# Preprint No. 96, November 2001.
#
# Maximize the volume of the parameterized body B(x) contained 
# in a second body G, described by a set of convex inequalities.
# 
#	maximize volume( B(x) )
#	subj. to B(x) \subset G
#
# where B(x) = { y | x_3 <= y_1 <= x_1 and x_4 <= y_2 <= x_2 }
# is a box.
#
# Original AMPL coding by Sven Leyffer, University of Dundee, Jan. 2002

# ... sets
set I := 1..4;				# ... design variables
set J := 1..2;				# ... lower level variables
set K := 1..3;				# ... lower level constraints
set L := 1..4;				# ... number of constraints in B(x)

# ... parameters
param pi := 3.141592654;

# ... initial points from solving design-init-1.mod
param x0{I}    default 0;
param y0{J,K}  default 0;
param ll0{L,K} default 1;

# ... variables
var x{i in I}                := x0[i];		# ... description of B(x)
var y{j in J, k in K}        := y0[j,k];	# ... contact points of B(x), G
var ll{l in L, k in K} >= 0, := ll0[l,k];	# ... multipliers gamma

# ... maximize the volume of the inscribed body
maximize volume: (x[1]-x[3]) * (x[2] - x[4]);

subject to

   # ... lower level solutions lie in body G
   g1: - y[1,1] - y[2,1]^2     <= 0;
   g2: y[1,2]/4 + y[2,2] - 3/4 <= 0;
   g3:          - y[2,3] - 1   <= 0;

   # ... first order conditions for 3 lower level problem
   KKT_11:  1        + ll[1,1] - ll[3,1] = 0;
   KKT_21:  2*y[2,1] + ll[2,1] - ll[4,1] = 0;

   KKT_12: -1/4      + ll[1,2] - ll[3,2] = 0;
   KKT_22:  -1       + ll[2,2] - ll[4,2] = 0;

   KKT_13: 0         + ll[1,3] - ll[3,3] = 0;
   KKT_23: 1         + ll[2,3] - ll[4,3] = 0;

   # ... complementarity & dual feasibility for lower level problem
   compl_1{k in K}: 0 <= ll[1,k]  complements    y[1,k] - x[1] <= 0;
   compl_2{k in K}: 0 <= ll[2,k]  complements    y[2,k] - x[2] <= 0;
   compl_3{k in K}: 0 <= ll[3,k]  complements  - y[1,k] + x[3] <= 0;
   compl_4{k in K}: 0 <= ll[4,k]  complements  - y[2,k] + x[4] <= 0;

data;
let x0[1] :=  1;
let x0[2] :=  1;
let x0[3] := -1;
let x0[4] := -1;
