# portfl-i.mod	QLR2-AY-NLP-87-25-12
# AMPL coding by Sven Leyffer, Feb. 2001,
# from portfl models of Bob Vanderbei.

# A QPEC obtained by varying the grad of portfl1-6
# from an idea communicated by S. Scholtes.
#
# This is almost a sensible problem. Here, ask what 
# vector r of minimum norm perturbations to returns R, 
# gives a solution that is as close as possible to the 
# given solution (obtained by rounding soln to portfl1-6).
#
# Problem has data files portfl1.dat - portfl6.dat with
# different parameters F & R.

param NS := 12;			# ... number of securites in portfolio
param NR := 62;			# ... total number of stocks

param F{1..NS,1..NR};		# ... covariance (?)
param R{1..NR};			# ... expected returns

param sol{1..NS};		# ... primal solution of portfl - QP

# ... primal/dual variables of original QP
var s{1..NS} >= 0.0, := 1/NS;	# ... size of stock i in portfolio
var m{1..NS} >= 0.0;		# ... multipliers of s[i] >= 0
var l;				# ... multipliers of e^T s = 1

# ... perturbations to stock returns
var r{i in 1..NR} >= 0;		# ... perturbation to R

# ... minimize deviation from primal solution PLUS perturbation norm
minimize diff: sum{i in 1..NS} ( s[i] - sol[i] )^2
               + sum{i in 1..NR} ( r[i] )^2;

subject to

   # ... 1st order condition for s
   KKT{k in 1..NS}: 
      0 = sum{i in 1..NR} 2*(sum{j in 1..NS} s[j]*F[j,i] - (R[i]+r[i]))*F[k,i]
          - l - m[k];

   # ... primal feasibility (stock sum to 1)
   cons1: sum{i in 1..NS} s[i] = 1;
   
   # ... complementary slackness condition
   compl_s{i in 1..NS}: 0 <= s[i]   complements   m[i] >= 0;

