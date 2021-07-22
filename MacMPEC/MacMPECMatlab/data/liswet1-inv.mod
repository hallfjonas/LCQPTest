# liswet1-inv.mod  QLR-AN-KKT-v-v-v	
# MPEC AMPL by S. Leyffer, University of Dundee, May 2002.
#
# A QPEC from an idea by Stefan Scholtes:
# Find minimum l_2 norm distance to original QP soln 
# for perturbed right-hand-side
# 
# Original NLP-AMPL Model by Hande Y. Benson
#
# Copyright (C) 2001 Princeton University
# All Rights Reserved
#
# ... from ...
#
#   Source:
#   W. Li and J. Swetits,
#   "A Newton method for convex regression, data smoothing and
#   quadratic programming with bounded constraints",
#   SIAM J. Optimization 3 (3) pp 466-488, 1993.
#
#   SIF input: Nick Gould, August 1994.

# ... parameters
param N;
param K:=2;
param B{i in 0..K} := if (i=0) then 1 else B[i-1]*i;
param C{i in 0..K} := if (i=0) then 1 else (-1)^i*B[K]/(B[i]*B[K-i]);
param T{i in 1..N+K} := (i-1)/(N+K-1);
param x_star{1..N+K};	# ... solution to forward QP

# ... variables
var z{1..N}  >= 0;		# ... control variables (pert. to rhs)
var x{i in 1..N+K} := 0;	# ... state variables
var l{1..N}  >= 0;		# ... multipliers

# ... minimize l_2 norm distance to original solution
minimize l_2_dist: sum{i in 1..N+K}( x[i] - x_star[i] )^2;

subject to

   # ... first order conditions
   KKT{i in 1..N+K}: - (sqrt(T[i])+0.1*sin(i)) + x[i]
		     - sum{j in max(i-K,1)..min(i,N)} C[j+K-i]*l[j] = 0;

   # ... constraints on controls
   controls: sum{j in 1..N} z[j] >= 0.2;

   # ... complementarity condition
   compl{j in 1..N}: 0 <= l[j]   
                     complements   sum{i in 0..K} C[i]*x[j+K-i] >= z[j];


