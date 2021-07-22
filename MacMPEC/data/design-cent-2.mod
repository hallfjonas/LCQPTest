# design-cent-2.mod    QOR-MY-NLP-13-13-3
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
# Original AMPL coding by Sven Leyffer, University of Dundee, Jan. 2002

# ... sets
set I := 1..4;				# ... design variables
set J := 1..2;				# ... lower level variables
set K := 1..3;				# ... lower level constraints

# ... parameters
param pi := 3.141592654;

# ... initial points from solving design-init-1.mod
param x0{I}   default 0.5;
param y0{J,K} default 0;
param l0{K}   default 1;

# ... variables
var x{i in I}         := x0[i];			# ... description of B(x)
var y{j in J, k in K} := y0[j,k];		# ... contact points of B(x), G
var l{k in K} >= 0,   := l0[k];			# ... multipliers gamma

# ... maximize the volume of the inscribed body
maximize volume: pi*x[3]*x[4];

subject to

   # ... lower level solutions lie in body G
   g1: - y[1,1] - y[2,1]^2     <= 0;
   g2: y[1,2]/4 + y[2,2] - 3/4 <= 0;
   g3:          - y[2,3] - 1   <= 0;

   # ... constraints deduced from KKT conditions
   KKT_11n:  y[1,1] - x[1] <= 0;
   KKT_12n:  y[1,2] - x[1] >= 0;
   KKT_22n:  y[2,2] - x[2] >= 0;
   KKT_23n:  y[2,3] - x[2] <= 0;

   # ... first order conditions for 3 lower level problem
   KKT_11:  1           + 2*(y[1,1] - x[1])/(x[3]^2) * l[1] = 0;
   KKT_21:  2*y[2,1]    + 2*(y[2,1] - x[2])/(x[4]^2) * l[1] = 0;

   KKT_12: -1/4         + 2*(y[1,2] - x[1])/(x[3]^2) * l[2] = 0;
   KKT_22:  -1          + 2*(y[2,2] - x[2])/(x[4]^2) * l[2] = 0;

   KKT_13: 0            + 2*(y[1,3] - x[1])/(x[3]^2) * l[3] = 0;
   KKT_23: 1            + 2*(y[2,3] - x[2])/(x[4]^2) * l[3] = 0;

   # ... complementarity & dual feasibility for lower level problem
   compl{k in K}: 
        0 <= l[k]  complements  
        ((y[1,k] - x[1])^2)/(x[3]^2) + ((y[2,k] - x[2])^2)/(x[4]^2) 
        <= 1;

