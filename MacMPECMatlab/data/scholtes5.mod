# scholtes5.mod	QBR-AN-LCP-3-2-2 
# Original AMPL coding by Sven Leyffer

# A QPEC from S. Scholtes, Judge Inst., University of Cambridge.
# see S. Scholtes, "Convergence properties of a regularization
# scheme for MPCCs", SIAM J. Optimization 11(4):918-936, 2001.

var z{1..3} >= 0, := 1;

minimize objf: (z[1] - 1)^2 + (z[2] - 2)^2 + (z[3] + 1)^2;

subject to 

   compl1:  0 <= z[1]    complements    z[3] >= 0;
   compl2:  0 <= z[2]    complements    z[3] >= 0;

