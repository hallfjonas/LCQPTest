# tap-09.mod  OOR-AY-NCP-86-68-32
#
# Traffic equilibrium & toll pricing model derived from 
# tollmpec (Dirkse & Ferris) with data from 9 node model
# by Hearn & Ramana, "Solving congestion toll pricing models",
# University of Florida report.
#
# ampl coding by S. Leyffer, University of Dundee, Feb. 2001.

set N    := 1..9 ;		# set of nodes
set DEST := { 3 , 4 };		# destination nodes

set ARCS within (N cross N);	# arcs

param d{N,N} default 0;		# demand (only /=0 for O-D pairs)
param T{ARCS};			# cost coeff. for separable cost functn
param b{ARCS};			# cost coeff. for separable cost functn

# ... flow along arc i-j to k 
var x {(i,j) in ARCS, k in DEST: i != k} >= 0;	

# ... aggregate flow on arc i-j
var F {ARCS};			

# ... toll on arc i-j (all roads are tolled ?)
var toll {ARCS} >= 0;

# ... time to get from node i to node j
var time {N,N} >= 0;		

### ... maximize system revenue (unbounded !!!)
##maximize nprofit: sum{(i,j) in ARCS, k in DEST: i != k} toll[i,j] * F[i,j];

# ... minimize system cost (or congestion)
minimize congestion: sum{(i,j) in ARCS}
                     ( T[i,j]*(1 + 0.15 * ( F[i,j]/b[i,j] )^4) );

subject to

   # ... 2nd Wardrop principle
   rational {(i,j) in ARCS, k in DEST: i != k}:
	0 <= T[i,j]*(1 + 0.15 * ( F[i,j]/b[i,j] )^4) + time[j,k] 
             + 100 * toll[i,j] - time[i,k]
        complements   x[i,j,k] >= 0;

   # ... the flow into a node equals demand plus flow out:
   balance {i in N, k in DEST: i != k}:
          sum{j in N: (i,j) in ARCS and i != k} x[i,j,k] 
        - sum{j in N: (j,i) in ARCS and j != k} x[j,i,k]
        = d[i,k];

   # ... flow on a given arc constitutes flows to all destinations K:
   fdef{(i,j) in ARCS}: F[i,j] = sum{l in DEST: l != i} x[i,j,l];

