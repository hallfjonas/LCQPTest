
function [problem] = ObtainLCQP(x, J, constr, compl_L, compl_R, lbA, ubA)

import casadi.*

% Quadratic objective term
Q_Fun = Function('Q_fun', {x}, {hessian(J, x)});
problem.Q = full(Q_Fun(zeros(size(x))));

% Linear objective term
J_Jac_Fun = Function('J_Jac_fun', {x}, {jacobian(J, x)});
problem.g = full(J_Jac_Fun(zeros(size(x))))';

% Linearize constraints (no check is done if they are nonlinear...
if (~isempty(constr))
    Constr = Function('Constr', {x}, {constr});
    A_Fun = Function('A_Fun', {x}, {jacobian(constr, x)});
    problem.A = full(A_Fun(zeros(size(x))));

    % Linearization correction term
    constr_constant = Constr(zeros(size(x)));
    problem.lbA = lbA - full(constr_constant);
    problem.ubA = ubA - full(constr_constant);
end

% Complementarities
L_Fun = Function('L_Fun', {x}, {jacobian(compl_L, x)});
problem.L = full(L_Fun(zeros(size(x))));
R_Fun = Function('R_Fun', {x}, {jacobian(compl_R, x)});
problem.R = full(R_Fun(zeros(size(x))));
problem.obj = Function('Obj', {x}, {J});
end
