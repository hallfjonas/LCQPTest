/* -------------------------------------------------------

  TRAFFIC EQUILIBRIUM - MPEC FORMULATION

  From a GAMS model by S.P. Dirkse & M.C. Ferris (MPECLIB),
  (see http://www.gams.com/mpec/).
  See also "Traffic Modeling and Variational Inequalities using 
  GAMS", by Dirkse & Ferris, University of Wisconsin, CS, 1997.

  AMPL coding Sven Leyffer, University of Dundee, Jan. 2000
  (removing redundant complementarity, i.e. to force equations)

  data file is siouxfls.dat
  ------------------------------------------------------- */

set N    := 1..24;		# set of nodes
set DEST := 1..24;		# destination nodes

set ARCS within (N cross N);	# arcs
set TOLL within ARCS;		# tolled arcs

param clo{TOLL};		# lower bnd on cost
param cup{TOLL};		# upper bnd on cost
param d{N,N};			# trip matrix / table
param A{ARCS};			# cost coeff. for separable cost functn
param B{ARCS};			# cost coeff. for separable cost functn
param K{ARCS};			# cost coeff. for separable cost functn

# ... flow along arc i-j to k 
var x{(i,j) in ARCS, k in DEST: i != k} >= 0;	

# ... aggregate flow on arc i-j
var F{ARCS};			

# ... tarriff on arc i-j
var trffcost{(i,j) in TOLL} >= clo[i,j], <= cup[i,j];

# ... time to get from node i to node j
var T{N,N} >= 0;		

# ... minimize system cost (or congestion)
minimize congestion: sum{(i,j) in ARCS}( A[i,j] + B[i,j] * ( F[i,j]/K[i,j] )^4 );

subject to

   # The following constraint imposes individual rationality:
   # The time to reach node k from node i is no greater than
   # the time required to travel from node i to node j and then
   # from node j to node k. (2nd Wardrop principle)

   rational{(i,j) in ARCS, k in DEST: i != k}:
	0 <= A[i,j] + B[i,j] * ( F[i,j]/K[i,j] )^4 + T[j,k] 
             + ( if (i,j) in TOLL then 100 * trffcost[i,j] else 0.0 ) - T[i,k]
        complements   x[i,j,k] >= 0;

   # The flow into a node equals demand plus flow out:

   balance{i in N, k in DEST: i != k}:
          sum{j in N: (i,j) in ARCS and i != k} x[i,j,k] 
        - sum{j in N: (j,i) in ARCS and j != k} x[j,i,k]
        = d[i,k];

   # Flow on a given arc constitutes flows to all destinations K:

   fdef{(i,j) in ARCS}: F[i,j] = sum{l in DEST: l != i} x[i,j,l];

