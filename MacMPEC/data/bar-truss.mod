# bar-truss.mod	LQR2-MN-35-29
# Original AMPL coding by Sven Leyffer

# From a GAMS model of a 3-bar truss min weight design problem
# by M.C. Ferris and F. Tin-Loi, "On the solution of a minimum
# weight elastoplastic problem involving displacement and
# complementarity constraints", Comp. Meth. in Appl. Mech & Engng,
# 174:107-120, 1999.

# Number of variables:   35
# Number of constraints: 28 + 1

set d;			# No. of structure dof
set m;			# No. of members
set y;			# No. of yield functs per member

param E;		# Young's modulus
param sigma;		# Yield limit

param L{m};		# length of members
param F{d};
param C{m,d};
param N{m,y};

var S{m} := 1;
var r{m,y} := 1;
var H{m,y,y} := 1;	# hardening parameters in tension  & compression
var Q{m};
var u{d} >= -4, <= 4;	# deflection
var a{m} >= 0, := 1;	# bar areas
var z{m,y} >= 0;
var w{m,y} >= 0, := 1;	# yield function

minimize volume: sum{i in m}( L[i] * a[i] );

subject to 

   tech{i in m}: a[i] = a['m1'];

   stiff{i in m}: S[i] - E*a[i] / L[i] = 0;

   limit{i in m, j in y}: r[i,j] - sigma* a[i] = 0;

   hard{i in m, j in y}: H[i,j,j] - 0.125*E*a[i]/L[i] = 0;
  
   compat{i in m}: - Q[i] + S[i]*sum{k in d}( C[i,k] * u[k] )
                   - S[i]*sum{j in y}( N[i,j] * z[i,j] ) = 0;

   equil{k in d}: sum{i in m}( C[i,k] * Q[i] ) - F[k] = 0;

   yield{i in m, j in y}: - N[i,j]*Q[i] + sum{jj in y}( H[i,j,jj] * z[i,jj] )
                          + r[i,j] = w[i,j];

   compl{i in m, j in y}: 0 <= w[i,j]    complements    z[i,j] >= 0;

