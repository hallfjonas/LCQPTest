
/* -------------------------------------------------------

  MPEC example taken from Gauvin and Savard, "Working Paper G9037",
  GERAD, Ecole Polytechnique de Montreal (1992) (first version).

   Let Y(x) := { y | 0 <= y <= 20 - x }.
   min  f(x,y) := x**2 + (y-10)**2
   s.t.      0 <= x <= 15
             y solves MCP((F(y) := 4(x + 2y - 30)), Y(x))

  We have modified the problem by adding a dual variable and
  incorporating the constraint y <= 20 - x into the MCP function F.

  From a GAMS model by S.P. Dirkse & M.C. Ferris (MPECLIB),
  (see http://www.gams.com/mpec/).

  AMPL coding Sven Leyffer, University of Dundee, Jan. 2000

  ------------------------------------------------------- */

var x >= 0, <= 15;	# design variable
var y >= 0;		# state variable
var u >= 0;             # duals in MCP to determine state vars

minimize theta: x^2 + (y-10)^2;

subject to 

   # ... F(x,y) from original problem
   Fy: 0 <= 4 * (x + 2*y - 30) + u   complements   y >= 0;   

   Fu: 0 <=  20 - x - y              complements   u >= 0;

data;

let x := 7.5;
let u := 1;


