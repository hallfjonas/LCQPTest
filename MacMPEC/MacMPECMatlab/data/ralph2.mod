# ralph2.mod	QUR-AN-LCP-2-0-1 
# Original AMPL coding by Sven Leyffer

# An LPEC from D. Ralph, Judge Inst., University of Cambridge.

var x >=0;
var y;

minimize f: x^2 + y^2 - 4*x*y;

subject to 

   compl:  0 <= x    complements    y >= 0;

data;

let x := 1;
let y := 1;
