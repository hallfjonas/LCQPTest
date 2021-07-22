# design-init-1.mod    QBR2-MN-
#
# AMPL model to initialize the design centering problem
# design-cent-1.mod. See O. Stein and G. Still, "Solving 
# semi-infinite optimization problems with Interior Point 
# techniques", Lehrstuhl C fuer Mathematik, RWTH Aachen,
# Preprint No. 96, November 2001.
#
# Original AMPL coding by Sven Leyffer, University of Dundee, Jan. 2002

# ... sets
set I := 1..3;				# ... design variables
set J := 1..2;				# ... lower level variables
set K := 1..3;				# ... lower level constraints

# ... parameters
param x{I};				# ... initial guess of design 

# ... variables
var y{J,K};				# ... contact points of B(x), G

# ... maximize the obtain contact points
maximize g1: - y[1,1] - y[2,1]^2;
maximize g2: y[1,2]/4 + y[2,2] - 3/4;
maximize g3: - y[2,3] - 1;

subject to

   ball{k in K}: (y[1,k] - x[1])^2 + (y[2,k] - x[2])^2 - x[3]^2 <= 0;

data;

param	:	x :=
	1	0
	2	0
	3	1 ;

#################################################################
###   solve each minimization in turn and save the solution   ###
#################################################################
model;
# ... define single objective problems
problem init1:
	g1,				# ... objective
	{j in J} y[j,1],	 	# ... variables
	ball[1];			# ... constraints
problem init2:
	g2,				# ... objective
	{j in J} y[j,2],	 	# ... variables
	ball[2];			# ... constraints
problem init3:
	g3,				# ... objective
	{j in J} y[j,3],	 	# ... variables
	ball[3];			# ... constraints

problem init1; solve init1;
problem init2; solve init2;
problem init3; solve init3;

restore ball;

display y;
display ball;
display g1, g2, g3;

################################################################
###   write the initial poin to a data fiel in AMPL format   ###
################################################################

printf "# design-cent-1.dat  \n"				>  init.dat;
printf "# ... initialize variables x & lower bounds \n"		>> init.dat;
printf "param \t: \t\tx0 := "					>> init.dat;
for {i in I} {
   printf "\n \t%2i %20.16g", i, x[i]				>> init.dat;
}; # end for
printf " ;\n\n "						>> init.dat;

printf "# ... initialize variables y  \n"               	>> init.dat;
printf "param y0:\t\t%i  \t\t%i \t\t%i :=", {k in K} k		>> init.dat;
for {j in J} {
   printf "\n\t%2i %20.16g %20.16g %20.16g", j, {k in K} y[j,k]	>> init.dat;
}; # end for
printf " ;\n\n "						>> init.dat;

printf "# ... initialize variables l  \n"			>> init.dat;
printf "param \t: \tl0 := "					>> init.dat;
for {k in K} {
   printf "\n \t%2i %20.16g", k, ball[k]			>> init.dat;
}; # end for
printf " ;\n\n "						>> init.dat;

