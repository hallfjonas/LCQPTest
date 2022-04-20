function [IPOPTStruct] = GetNLPFormulation(problem)

Q = problem.Q;
g = problem.g;
L = problem.L;
R = problem.R;

if (~isfield(problem, 'A'))
    problem.A = [];
    problem.lbA = [];
    problem.ubA = [];
end

A = problem.A;
lbA = problem.lbA;
ubA = problem.ubA;    

import casadi.*;

% Create variables
x = SX.sym('x', size(Q,1));
sigma = SX.sym('sigma',1);

% Create SX matrices and vectors
Qmx = SX(Q);
gmx = SX(g);
Lmx = SX(L);
Rmx = SX(R);

% CasADi complementarity variables
x1 = Lmx*x;
x2 = Rmx*x;

% CasADi objective and penalty term
J_qp = 1/2*x'*Qmx*x+gmx'*x;
g_cc = x1'*x2 - sigma;

% Linear Bounds
Amx = SX([A; L; R]);

% Create IPOPT Struct
IPOPTStruct.obj = J_qp;
IPOPTStruct.x = x;
IPOPTStruct.sigma = sigma;
IPOPTStruct.constr = vertcat(Amx*x, g_cc);
IPOPTStruct.lb_constr = [lbA; zeros(2*size(L,1), 1);-inf];
IPOPTStruct.ub_constr = [ubA; inf(2*size(L,1), 1);0];
IPOPTStruct.Obj = Function('Obj', {x}, {J_qp});
IPOPTStruct.Phi = Function('Phi', {x}, {g_cc});

end