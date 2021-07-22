/* -------------------------------------------------------

   MPEC due to Danny Ralph, see also

        G Maier, F Giannessi and A Nappi, Indirect
        identification of yield limits by mathematical
        programming, Engineering Structures 4, 1982,
        86-98.

   From a GAMS model by S.P. Dirkse & M.C. Ferris (MPECLIB),
   (see http://www.gams.com/mpec/).

   AMPL coding Sven Leyffer, University of Dundee, Jan. 2000

   ------------------------------------------------------- */

set vars   := 1..104;
set design := 1..4;
set state  := 5..104;
set side   := 1..8;

param P{vars,vars} default 0;
param M{state,vars} default 0;
param q{state} default 0;
param c{vars} default 0;

var x{design} >= 0, <= 1000;
var y{state}  >= 0;

var s{state}  >= 0;

minimize obj: 0.5*( sum{i in design} x[i]*sum{j in design}P[i,j]*x[j] 
                    + 2.0*sum{i in design}x[i]*sum{j in state}P[i,j]*y[i]
                    + sum{ i in state}y[i]*sum{j in state}P[i,j]*y[j]     )
              + sum{i in design}c[i]*x[i] + sum{i in state}c[i]*y[i];

subject to

   F{i in state}: 0 <=  sum{k in design}( M[i,k]*x[k] ) 
                      + sum{j in state}( M[i,j]*y[j] ) + q[i]
                  complements y[i] >= 0;
