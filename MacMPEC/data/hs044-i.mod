# hs044-i.mod	QLR2-MY-20-14-10
# Original AMPL coding by Sven Leyffer

# A QPEC obtained by varying the rhs of HS44 (a QP)
# from an idea communicated by S. Scholtes.

set I := 1..4;			# ... variables of HS44
set J := 1..6;			# ... constraints of HS44
set K := 1..6;			# ... perturbations to HS44

# ... data of HS44
param sol {I};			# ... solution to HS44
param A {J,I} default 0;	# ... constraint matrix
param b {J} default 0;		# ... rhs of constraints
param H {I,I} default 0;	# ... Hessian matrix of HS44
param g {I} default 0;		# ... linear part of objective of HS44

# ... bounds on perturbations
param zl {K} default 0;
param zu {K} default 10;
param u {K};
param v {K};

# ... variables (states, i.e. primal/dual pair of HS44)
var x {I} >= 0;			# ... original primal variables
var l {J} >= 0;			# ... multipliers of general constraints
var m {I} >= 0;			# ... multipliers of simple bounds

# ... variables (controls, i.e. perturbations to rhs & g)
var z {k in K} >= zl[k], <= zu[k];

# ... minimize l_2 norm of derivation from optimal solution
minimize norm: sum{i in I}( (sol[i] - x[i])^2 );

subject to

   # ... perturbed KKT conditions (1st order)
   KKT {i in I}: sum{ii in I} H[i,ii]*x[ii] + (g[i] + u[i]*z[i])
                - sum{j in J} A[j,i]*l[i] - m[i] = 0;

   # ... perturbed slackness conditions (general c/s)
   slackness_g {j in J}: 0 <= l[j]  complements
			 (b[j] - v[j]*z[j]) + sum{i in I} A[j,i]*x[i] >= 0;
			 
   # ... perturbed slackness conditions (simple bounds)
   slackness_x {i in I}: 0 <= x[i]  complements  m[i] >= 0;

data;
param	:	sol,	g :=
	1	0	1
	2	3	-1	
	3	0	-1
	4	4	0;

param A	:	1	2	3	4	:=
	1	-1	-2	.	.
	2	-4	-1	.	.
	3	-3	-4	.	.	
	4	.	.	-2	-1
	5	.	.	-1	-2
	6	. 	.	-1	-1;

param	:	b :=
	1	8
	2	12
	3	12
	4	8
	5	8
	6	5;

param H	:	1	2	3	4	:=
	1	.	.	-1	1
	2	.	.	1	-1
	3	-1	1	.	.
	4	1	-1	.	. ;

param	:	zl,	zu,	u,	v	:=
	1	0.01	10	0.2	1.2
	2	-10	-0.01	1.2	0.2
	3	0.1	1	2	0.1
	4	-1	-0.1	0.1	2
	5	-1	1	0.1	10
	6	0.001	10	-0.1	-0.2 ;


