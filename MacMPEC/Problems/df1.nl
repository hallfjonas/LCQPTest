g3 0 1 0	# problem tmp
 2 3 1 0 0	# vars, constraints, objectives, ranges, eqns
 3 1 0 1	# nonlinear constrs, objs; ccons: lin, nonlin
 0 0	# network constraints: nonlinear, linear
 2 2 2	# nonlinear vars in constraints, objectives, both
 0 0 0 1	# linear network variables; functions; arith, flags
 0 0 0 0 0	# discrete variables: binary, integer, nonlinear (b,c,o)
 5 2	# nonzeros in Jacobian, gradients
 0 0	# max name lengths: constraints, variables
 0 0 0 0 0	# common exprs: b,c,o,c1,o1
C0
o5
v0
n2
C1
o0
o5
o0
n-1
v0
n2
o5
o0
n-1
v1
n2
C2
o1
n1
o5
v0
n2
O0 0
o5
o1
o0
n-1
v0
v1
n2
r
1 2
1 3
5 1 2
b
0 -1 2
2 0
k1
3
J0 1
0 0
J1 2
0 0
1 0
J2 2
0 0
1 1
G0 2
0 0
1 0
