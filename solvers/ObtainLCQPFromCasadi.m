function [problem] = ObtainLCQPFromCasadi(casadi_formulation)

import casadi.*

x = casadi_formulation.x;
J = casadi_formulation.J;
constr = casadi_formulation.constr;
lbA = casadi_formulation.lbA;
ubA = casadi_formulation.ubA;
lb = casadi_formulation.lb;
ub = casadi_formulation.ub;
compl_L = casadi_formulation.compl_L;
compl_R = casadi_formulation.compl_R;

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

% Add box constraints to problem struct
problem.lb = lb;
problem.ub = ub;

% Complementarities
L_Fun_Full = Function('L_Fun_Full', {x}, {compl_L});
L_Fun = Function('L_Fun', {x}, {jacobian(compl_L, x)});
problem.L = full(L_Fun(zeros(size(x))));
problem.lbL = -full(L_Fun_Full(zeros(size(x))));
R_Fun_Full = Function('R_Fun_Full', {x}, {compl_R});
R_Fun = Function('R_Fun', {x}, {jacobian(compl_R, x)});
problem.R = full(R_Fun(zeros(size(x))));
problem.lbR = -full(R_Fun_Full(zeros(size(x))));

% Remember the objective and phi functions
problem.Obj = Function('Obj', {x}, {J});
problem.Phi = Function('Phi', {x}, {max(compl_L.*compl_R)});


end