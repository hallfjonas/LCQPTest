# qpecgen.mod QQR2-MN-v-v
# Original AMPL coding by Sven Leyffer, University of Dundee, Feb 2001.
#
# AMPL file which implements QPs generated by QPECgen.
#
# Reference: H. Jiang and D. Ralph, "QPECgen: A MATLAB generator for 
# mathematical programs with quadratic objectives and affine variational
# inequality constraints", Computational Optimization and Applications.
#
#
# The problems generated here are LCP constrained QPs (i.e. type 300)
# of the form
#
#	min	0.5*(x,y)'*P*(x,y) + c'x + d'y
#	s.t.	A*(x,y) + a <= 0		(1)
#		F(x,y) = N*x + M*y + q >= 0
#		y >= 0
#		F(x,y)*y = 0
#
#		# variables	# constraints	degree of degeneracy
# data files	n_x	n_y	m_1	m_2	deg_1	deg_2	deg_m
# -------------------------------------------------------------------
# qpeq-100-1	 5	100	2	0	1	20	20
# qpeq-100-2	10	100	2	0	1	20	20
# qpeq-100-3	10	100	4	0	1	20	20
# qpeq-100-4	20	100	4	0	1	20	20
# qpeq-200-1	10	200	4	0	2	40	40
# qpeq-200-2	20	200	4	0	2	40	40
# qpeq-200-3	20	200	8	0	2	40	40
# qpeq-200-4	40	200	8	0	2	40	40

# ... dimension of QPEC
param n_x integer;		# ... dimension of x
param n_y integer;		# ... dimension of y
param m_1 integer;		# ... number of upper level constraints

# ... some useful sets
set N_x := 1..n_x;
set N_y := 1..n_y;
set M_1 := 1..m_1;

# ... data for QPEC instance
param Pxx {N_x, N_x};
param Pxy {N_x, N_y};
param Pyy {N_y, N_y};
param c {N_x};
param d {N_y};
param Ax {M_1 , N_x};
param Ay {M_1 , N_y}, default 0;
param a {M_1};
param N {N_y , N_x};
param M {N_y , N_y};
param q {N_y};

# ... definition of variables
var x {N_x};
var y {N_y} >= 0;

# ... problem statement
minimize f:   0.5*( sum{i in N_x} ( x[i] * sum{j in N_x} Pxx[i,j]*x[j] ) )
            + 0.5*( sum{i in N_y} ( y[i] * sum{j in N_y} Pyy[i,j]*y[j] ) )
            +     ( sum{i in N_x} ( x[i] * sum{j in N_y} Pxy[i,j]*y[j] ) )
            + sum{i in N_x} x[i]*c[i] 
            + sum{i in N_y} y[i]*d[i] ;

subject to

   Acon{i in M_1}:   sum{j in N_x} Ax[i,j]*x[j] 
                   + sum{j in N_y} Ay[i,j]*y[j]
                   + a[i] <= 0;

   Fcon{i in N_y}: 0 <= y[i]  complements
		 	q[i] + sum{j in N_x} N[i,j]*x[j]
                             + sum{j in N_y} M[i,j]*y[j] >= 0;


