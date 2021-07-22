#   b-pn2.mod QOR2-MN-v-v
#
#   MPEC with equilibrium constraint as explicit nonlinear equation
#
#   BEM Quasibrittle Fracture Identification (N, mm)
#   B_pn2.gms = Two-branch law, Penalty, 2-norm
#   Imposed displacement q
#
#   traction    : t = q.te + Z.w
#   load        : p = q.pe + r'.w
#   crack width : w(i) = lw(i,"y3")
#   yield       : phi = tc.v1 - tb.v2 - k.M1.lw - h.M2.lw - t.n
#   phi >= 0, (yield) \perp (lw >= 0)
#
#   Uses 1 data file: bem-milanc30.dat  ... contains Z etc.
#   Calculated p is for full beam, 1 mm thick
#   Beam in expt = 15 mm thick, u_expt in microns
#   p_expt = 15*p Newtons
#   u_expt = 1000*u microns
#
#   F. Tin-Loi : 24 Feb 99
#
#   AMPL coding by Sven Leyffer, University of Dundee, Mar. 2000
#   from a GAMS file by F. Tin-Loi.
#
#   Data files: bem-milanc30-s.dat: set SS = {18,20,22,24,26,28,30,32};
#               bem-milanc30-l.dat: set SS = S;

set I := 1..61;		# ... Num bem nodes, size Z etc
set Y := 1..3;		# ... Num yield modes per node
set S := 1..48;		# ... Load situations

# ... change this set to select different points to be matched
set SS within S;

# ... data originally from bem_expt.dat
param q{S};		# ... parameter q(s)  (mm)
param Qm{S};		# ... parameter Qm(s) (N) total Q for unit thickness

# ... data originally from bem_milanc30.dat
param Z{I,I};		# ... table     Z(i,i) 
param te{I};		# ... parameter te(i)  
param r{I};		# ... parameter r(i)   
param pe;		# ... scalar    pe     

# ... 2-branch parameter
param v1{Y} := 1;
param v2{y in Y} := if y == 1 then 1.0 else 0.0;
param M1{Y, y in Y} := if y == 1 then -1.0 else
                       if y == 2 then -1.0 else
                       if y == 3 then  1.0 else 0.0;
param M2{y in Y, yy in Y} := if (y == 1) && (yy == 1) then -1.0 else 0.0;
param n{y in Y} := if y == 3 then 1.0 else 0.0;

# ... problem variables
var tc >= 1, <= 30,  := 10;	# ... Traction limit 1
var tb >= 1, <= 30,  := 4;	# ... Traction limit 2
var k >= 10, <= 500, := 200;	# ... Slope branch 1
var h >= 10, <= 500, := 200;	# ... Slope branch 1
var errQ{SS} := 1;		# ... Qc - Qm
var t{SS,I};			# ... Tractions
var lw{SS,I,Y} >= 0, := 1;	# ... Lambda-w vector
var Qc{s in SS} := Qm[s]; 	# ... Calculated load
var phi{SS,I,Y} >= 0, := 1;	# ... Yield functions

minimize cost: sum{s in SS} errQ[s]*errQ[s];

subject to

   compl {s in SS, i in I, y in Y}: 
         0 <= phi[s,i,y]    complements   lw[s,i,y] >= 0;

   traction{s in SS,i in I}:
      t[s,i] = q[s]*te[i] + sum{j in I} Z[i,j]*lw[s,j,3];

   yield{s in SS, i in I , y in Y}:
      tc*v1[y] - tb*v2[y] - k*sum{yy in Y} M1[y,yy]*lw[s,i,yy]
      - h*sum{yy in Y} M2[y,yy]*lw[s,i,y] - t[s,i]*n[y] 
      = phi[s,i,y];

   err_Q{s in SS}:  errQ[s] = Qm[s] - Qc[s];

   def_Qc{s in SS}: Qc[s] = q[s]*pe + sum{i in I} r[i]*lw[s,i,3];

   tc_tb: tc >= tb;

