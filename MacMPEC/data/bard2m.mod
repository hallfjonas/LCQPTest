# bard2m.mod	QQR2-MN-
# Original AMPL coding by Sven Leyffer

# From GAMS model in mpeclib of Steven Dirkse, see
# http://www1.gams.com/mpec/mpeclib.htm

var x11 >= 0, <= 10;
var x12 >= 0, <=  5;
var x21 >= 0, <= 15;
var x22 >= 0, <= 20;

# ... variables for optimality conds of 2nd level problem a
var y11 >= 0, <= 20;
var y12 >= 0, <= 20;
var m_c11 <= 0;
var m_c12 <= 0;

# ... variables for optimality conds of 2nd level problem b
var y21 >= 0, <= 40;
var y22 >= 0, <= 40;
var m_c21 <= 0;
var m_c22 <= 0;

minimize cost: -(200-y11-y21)*(y11+y21) - (160 - y12 - y22)*(y12 + y22);

subject to

   side: x11 + x12 + x21 + x22 <= 40;

   # ... optimality conds of second level problem a
   c11: 0 <= - ( 0.4*y11 + 0.7*y12 - x11 )     complements  m_c11 <= 0;
   c12: 0 <= - ( 0.6*y11 + 0.3*y12 - x12 )     complements  m_c12 <= 0;

   d_y11: 0 = 2*(y11-4)-m_c11*0.4-m_c12*0.6   complements  y11;
   d_y12: 0 = 2*(y12-13)-m_c11*0.7-m_c12*0.3  complements  y12;

   # ... optimality conds of second level problem b
   c21: 0 <= - ( 0.4*y21 + 0.7*y22 - x21 )     complements  m_c21 <= 0;
   c22: 0 <= - ( 0.6*y21 + 0.3*y22 - x22 )     complements  m_c22 <= 0;

   d_y21: 0 = 2*(y21-35)-m_c21*0.4-m_c22*0.6  complements  y21;
   d_y22: 0 = 2*(y22-2)-m_c21*0.7-m_c22*0.3   complements  y22;