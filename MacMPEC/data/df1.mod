# df1.mod	QQR2-MN-4-2
# Original AMPL coding by Sven Leyffer, University of Dundee

# An MPEC from S.P. Dirkse and M.C. Ferris, Modeling & Solution 
# Environment for MPEC: GAMS & MATLAB, University of Wisconsin
# CS report, 1997.

# Number of variables:   3
# Number of constraints: 2

var x >= -1, <= 2;
var y >= 0;

minimize theta: (x - 1 - y)^2;

subject to 
   h:    x^2 <= 2;
   g:    (x - 1)^2 + (y - 1)^2 <= 3;
   MCP:  0 <= y - x^2 + 1   complements y >= 0;





        

