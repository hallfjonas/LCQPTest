# bard1m.mod	QQR2-MN-9-5
# Original AMPL coding by Sven Leyffer

# From GAMS model in mpeclib of Steven Dirkse, see
# http://www1.gams.com/mpec/mpeclib.htm

var x >= 0;
var y >= 0;

var sy >= 0;
var l{1..3} >= 0;

minimize cost: (x-5)^2 + (2*y + 1)^2;

subject to

   cons1: 0 <= 3*x - y - 3      complements   l[1] >= 0;
   cons2: 0 <= -x + 0.5*y + 4   complements   l[2] >= 0;
   cons3: 0 <= -x - y + 7       complements   l[3] >= 0;

   d_y:  sy = (((2*(y-1)-1.5*x)-l[1]*(-1)*1)-l[2]*0.5)-l[3]*(-1)*1;
