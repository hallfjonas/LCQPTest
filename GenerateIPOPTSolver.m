function [IPOPTStruct] = GenerateIPOPTSolver(Q, g, L, R, A, lbA, ubA, lb, ub)

import casadi*;

% Create variables
x   = MX.sym('x', size(Q,1));
rho = MX.sym('rho',1);

% Create MX matrices and vectors
Qmx = MX(Q);
gmx = MX(g);
Amx = MX(A);
Lmx = MX(L);
Rmx = MX(R);

% CasADi complementarity variables
x1 = Lmx*x;
x2 = Rmx*x;

% CasADi objective, constraint, complmentarity penalty
J_qp = x'*Qmx*x+gmx'*x;
g_cc = x1'*x2;

obj = J_qp + rho*g_cc;
constr = Amx*x;

% IPOPT options
opts_ipopt = [];
opts_ipopt.verbose = false;
opts_ipopt.ipopt.mu_strategy = 'adaptive';
opts_ipopt.ipopt.mu_oracle = 'quality-function';
opts_ipopt.ipopt.max_iter = 1000;
opts_ipopt.ipopt.tol = 1e-16;
opts_ipopt.verbose = false;
opts_ipopt.ipopt.print_level = 0;
opts_ipopt.print_time = 0;
opts_ipopt.print_out = 0;
opts_ipopt.ipopt.fixed_variable_treatment = 'make_constraint';  % relax_bounds

% NLP solver object
prob = struct('f', obj, 'x', x, 'g', constr, 'p', rho);
IPOPTStruct.Solver = nlpsol('solver', 'ipopt', prob , opts_ipopt);
IPOPTStruct.lbw = lb;
IPOPTStruct.ubw = ub;
IPOPTStruct.lbg = lbA;
IPOPTStruct.ubg = ubA;

end