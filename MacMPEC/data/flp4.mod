# flp4.mod	QLR-AN-LCP-v-v-v
# 
# Problem 4 from Fukushima, M. Luo, Z.-Q.Pang, J.-S.,
# "A globally convergent Sequential Quadratic Programming
# Algorithm for Mathematical Programs with Linear Complementarity 
# Constraints", Computational Optimization and Applications, 10(1),
# pp. 5-34, 1998.
#
# This is a QPEC with random data of the form
#
#	minimize    0.5*x^T x + e^T y
#
#	subject to  A x <= b
# 		    0 <= y  _|_  N x + M y + q >= 0
#
# The data files are:
#
#    p     m     n	data-file		dense/sparse
# ----------------------------------------------------------
#   30    30    50	flp4-1.dat		dense
#   50    60    50	flp4-2.dat		dense
#  100    70    70	flp4-3.dat		dense
#  150   100   100	flp4-4.dat		dense
#  300   300   500	flp4-s-1.dat		0.02 %
#  500   600   500	flp4-s-2.dat		0.02 %
# 1000   700   700	flp4-s-3.dat		0.02 % 
# 1500  1500  1500 	flp4-s-4.dat		0.02 % 
#
# ... generated in matlab with genflp4.m/genflp4s.m for dense/sparse.

# ... dimensions of the problem
param m integer;
param n integer;
param p integer;

# ... sets of indices
set MM := 1..m;
set NN := 1..n;
set PP := 1..p;

# ... random data (initialized to zero for sparse problems)
param A{PP,NN} default 0;		# ... A x <= b
param b{PP}    default 0;
param N{MM,NN} default 0;		# ... N x + M y + q >= 0
param M{MM,MM} default 0;
param q{MM}    default 0;

# ... variables
var x{NN} := 1;
var y{MM} := 0;

minimize objf: 0.5*(sum{j in NN} x[j]^2) + sum{i in MM} y[i];

subject to 

   lincs{k in PP}:  sum{j in NN} A[k,j]*x[j] <= b[k];

   compl{i in MM}:  0 <= y[i]   complements
		    0 <=   sum{j in NN} N[i,j]*x[j]
                         + sum{l in MM} M[i,l]*y[l]
                         + q[i];

