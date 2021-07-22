# incid-set1c.mod LQR2-MN-v-v
# Original AMPL coding by Sven Leyffer, University of Dundee
#
# An MPEC from Outrata, Kocvara & Zowe, Nonsmooth Approach to
# Optimization Problems with Equilibrium Constraints, Kluwer, 1998.
#
# The incidence set identification problem of Section 9.4:
# Aim is to bring the membrane of a surface into contact with 
# the obstacle in a prescribed region whose shape is also to 
# be determined.
#
# Modification: Require rhs boundary (alpha=a) to be convex.
# ============  
#
# A 2D obstacle problem on [0,1] x [0,1].
#
# Several discretizations are available (see insid-set-i.dat, 
# i=8,16,32).
#
# Formulation uses FE discretization with similar data
# structure as provided by triangulization routines.

# ... discretization parameters (change for finer grid)
param n integer;			# n = 8, 16, 32, 64
param h := 1/n;				# discretization size

# ... parameters
param Nnd := (n+1)*(n+1);		# Number of nodes
param r := 33.0;			# weight for objective
param n1 := n/4;
param n2 :=3*n/4;

# ... sets of nodes / classes of nodes
set nodes    := 1..Nnd; 		# set of nodes
set bnd_nodes within nodes;		# set of boundary nodes
set int_nodes := nodes diff bnd_nodes;	# set of internal nodes
set elements within nodes cross nodes cross nodes;	# set of elements

# ... Omega0 = region, where membrane is fixed to obstacle
set Omega0 within int_nodes;

# ... [d1,d2] = start/end of Omega0 in x-direction indices
param d1;
param d2;

# ... node positions on i-j grid of indices
param i_ref{nodes} >= 0, <= n, integer;
param j_ref{nodes} >= 0, <= n, integer;

# ... node positions (y fixed)
param y {i in nodes} := j_ref[i]*h;

# ... boundary conditions
param u0 {bnd_nodes};

# ... parameterization of "moving" boundary (alpha)
var a {0..n} >= 0.7, <= 1.2, := 1.0;

# ... parameterization of "moving" obstacle
var w1 {n1..n2} >= 0.15, <= 0.65, := 0.25;
var w2 {n1..n2} >= 0.15, <= 0.65, := 0.50;

# ... node positions (x depends on a and w1, w2)
var x {i in nodes} = if ((y[i] < 0.25) or (y[i] > 0.75)) then 
			i_ref[i] * a[j_ref[i]] / n
                     else 
			if (i_ref[i] < d1) then
			   i_ref[i] * w1[j_ref[i]] / d1
			else if (i_ref[i] <= d2) then
			   w1[j_ref[i]] 
                           +(i_ref[i]-d1)*(w2[j_ref[i]]-w1[j_ref[i]])/(d2-d1)
			else
			   w2[j_ref[i]] 
			   +(i_ref[i]-d2)*(a[j_ref[i]]-w2[j_ref[i]])/(n-d2);

# ... determinant of Je transformation for element stiffness matrix
var detJe {(i,j,k) in elements} 
    = ( (x[j]-x[i])*(y[k]-y[i]) - (y[j]-y[i])*(x[k]-x[i]) );

# ... obstacle 
param xi {i in nodes} := - 0.03;

# ... unknown height of membrane
var u {nodes};

# ... slack variables to deal with complementarity
var s1 {int_nodes} >= 0.0;

# ... global load vector (load is f(x,y) = -1.0 constant)
var l {i in int_nodes} 
    = - sum{(i,j,k) in elements} detJe[i,j,k] / 6.0
      - sum{(j,i,k) in elements} detJe[j,i,k] / 6.0
      - sum{(k,j,i) in elements} detJe[k,j,i] / 6.0;

# ... set up PDE equation at all internal nodes here
var Au {i in int_nodes}

    = sum{(i,j,k) in elements} (
      (  ( (y[k]-y[i])^2 + (x[k]-x[i])^2 + (x[j]-x[i])^2 
          - 2*(x[k]-x[i])*(x[j]-x[i])                              ) * u[i]
       + (-(y[k]-y[i])^2 - (x[k]-x[i])^2 + (x[k]-x[i])*(x[j]-x[i]) ) * u[j]
       + (-(x[j]-x[i])^2 + (x[k]-x[i])*(x[j]-x[i])                 ) * u[k]
      ) / ( 2*detJe[i,j,k] ) )

    + sum{(j,i,k) in elements}(
      (  ( (y[k]-y[j])^2 + (x[k]-x[j])^2                           ) * u[i]
       + (-(y[k]-y[j])^2 - (x[k]-x[j])^2 + (x[k]-x[j])*(x[i]-x[j]) ) * u[j]
       + (-(x[k]-x[j])*(x[i]-x[j])                                 ) * u[k]
      ) / ( 2*detJe[j,i,k] ) )

    + sum{(k,j,i) in elements}(
      (  ( (x[j]-x[k])^2                            ) * u[i]
       + (-(x[i]-x[k])*(x[j]-x[k])                  ) * u[j]
       + (-(x[j]-x[k])^2 + (x[i]-x[k])*(x[j]-x[k])  ) * u[k]
      ) / ( 2*detJe[k,j,i] ) );

minimize Jr: sum{i in int_nodes diff Omega0} s1[i]
	     + r*h^2*sum{i in Omega0}( u[i] - xi[i] );

subject to

   # ... constraint on slope of "moving" boundary
   slope_a {i in 1..n}: -3*h <= a[i-1] - a[i] <= 3*h;

   # ... convexity condition on region bounded by \alpha
   conv {i in 1..n-1}: a[i-1] - 2*a[i] + a[i+1] <= 0;

   # ... constraint on slope of "moving" boundary of Omega0
   slope_w1 {i in n1+1..n2}: -2.5*h <= w1[i-1] - w1[i] <= 2.5*h;

   # ... constraint on slope of "moving" boundary of Omega0
   slope_w2 {i in n1+1..n2}: -2.5*h <= w2[i-1] - w2[i] <= 2.5*h;

   # ... restriction ensure w1 <= w2
   lin {i in n1..n2}: w1[i] + 0.05 <= w2[i];

   # ... boundary conditions
   bnd_cond {i in bnd_nodes}: u[i] = u0[i];

   # ... FE approx to Laplacian
   PDE {i in int_nodes}:  s1[i] = Au[i] - l[i];

   # ... obstacle lower bound
   obst {i in int_nodes}: 0 <= s1[i]   complements   u[i] - xi[i] >= 0;

