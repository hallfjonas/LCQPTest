# pack-comp2.mod LQR2-MN-v-v
# Original AMPL coding by Sven Leyffer, University of Dundee
#
# An MPEC from Outrata, Kocvara & Zowe, Nonsmooth Approach to
# Optimization Problems with Equilibrium Constraints, Kluwer, 1998.
#
# A packaging problem (see Section 9.2, Example 9.3):
# Minimize membrane surface under the condition that 
# the membrane comes into contact with a compliant obstacle.
# Using a different obstacle to Zowe et.al.
#
# A 2D obstacle problem on [0,1] x [0,1].
#
# Several discretizations are available (see pack-comp-i.dat, 
# i=8,16,32).
#
# Formulation uses FE discretization with similar data
# structure as provided by triangulization routines.

# ... discretization parameters (change for finer grid)
param n integer;			# n = 8, 16, 32, 64
param h := 1/n;				# discretization size

# ... parameters
param Nnd := (n+1)*(n+1);		# Number of nodes

param c := 2.0;                               # compliance c

# ... sets of nodes / classes of nodes
set nodes    := 1..Nnd; 		# set of nodes
set bnd_nodes within nodes;		# set of boundary nodes
set int_nodes := nodes diff bnd_nodes;	# set of internal nodes
set fix_nodes within nodes;		# set of fixed node positions
set var_nodes := nodes diff fix_nodes;        # set of variables node pos.
set elements within nodes cross nodes cross nodes;	# set of elements

# ... Omega0 = region, where membrane is fixed to obstacle
set Omega0 within int_nodes;

# ... node positions on i-j grid of indices
param i_ref{nodes} >= 0, <= n, integer;
param j_ref{nodes} >= 0, <= n, integer;

# ... node positions (y fixed)
param y {i in nodes} := j_ref[i]*h;

# ... boundary conditions
param u0 {bnd_nodes};

# ... parameterization of "moving" boundary (alpha)
var a {0..n} >= 0.6, <= 1.0, := 1.0;

# ... node positions (x depends on a - moving boundary)
var x {i in nodes} = if i in fix_nodes then i_ref[i]*h
                     else 0.5+(i_ref[i]-n/2)*(2*a[j_ref[i]]-1)/n;

# ... determinant of Je transformation for element stiffness matrix
var detJe {(i,j,k) in elements} 
    = ( (x[j]-x[i])*(y[k]-y[i]) - (y[j]-y[i])*(x[k]-x[i]) );

# ... obstacle 
var xi {i in nodes} = - 0.05 * x[i];

# ... unknown height of membrane
var u {nodes};

# ... slack variables to deal with complementarity
var s1 {int_nodes} >= 0.0;                 # ... slack of obstacle

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

minimize area: h/2 * sum{i in 1..n} ( a[i] + a[i-1] );

subject to

   # ... boundary conditions
   bnd_cond {i in bnd_nodes}: u[i] = u0[i];

   # ... region where membrane is fixed to obstacle
   fix_mem {i in Omega0}: u[i] - xi[i] - c*(l[i] - Au[i]) <= 0;

   # ... constraint on slope of "moving" boundary
   slope {i in 1..n}: -3*h <= a[i-1] - a[i] <= 3*h;

   # ... FE approx to Laplacian
   PDE {i in int_nodes}: s1[i] = Au[i] - l[i];

   # ... obstacle lower bound
   obst {i in int_nodes}: 0 <= s1[i]   
			  complements   u[i] - xi[i] - c*(l[i] - Au[i]) >= 0;


