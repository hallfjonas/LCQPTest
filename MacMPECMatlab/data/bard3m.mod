# bard3m.mod	QQR2-MN-
# Original AMPL coding by Sven Leyffer

# From GAMS model in mpeclib of Steven Dirkse, see
# http://www1.gams.com/mpec/mpeclib.htm

# ... upper level variables x
var x1 >= 0;
var x2 >= 0;
 
# .. lower level variables
var y1 >= 0;
var y2 >= 0;
var m_cons1 >= 0;
var m_cons2 >= 0;
 
# .. upper level problem objective
minimize cost: -x1^2 - 3*x2 + y2^2 - 4*y1;

subject to 
   side: x1^2 + 2*x2 <= 4;
 
   # ... optimality conditions of lower level problem
   cons1: 0 <= x1^2 - 2*x1 + x2^2 - 2*y1 + y2 + 3   complements  m_cons1 >= 0;
   cons2: 0 <= x2 + 3*y1 - 4*y2 - 4                 complements  m_cons2 >= 0;
 
   d_y1 : 0 <= (2*y1+2*m_cons1)-3*m_cons2   complements  y1 >= 0;
   d_y2 : 0 <= (-5-m_cons1)+4*m_cons2       complements  y2 >= 0;
