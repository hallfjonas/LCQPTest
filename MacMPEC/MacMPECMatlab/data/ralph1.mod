# ralph1.mod	LUR-AN-LCP-2-0-1 
# Original AMPL coding by Sven Leyffer

# An LPEC from D. Ralph, Judge Inst., University of Cambridge.
# This problem violates strong stationarity, but is B-stationary.

var x >= 0;
var y >= 0;

minimize f1: 2*x - y;
minimize f2:   x - y;

subject to 

   compl:  0 <= y    complements    y-x >= 0;

