
function [problem] = ObtainLCQP(casadi_formulation)
%% Import casadi
import casadi.*

%% Extract penatly settings
problem.rho0 = casadi_formulation.rho0;
problem.beta = casadi_formulation.beta;

%% Extract variables, initial guess and box constraints
x = casadi_formulation.x;
problem.x0 = casadi_formulation.x0;
problem.lb = casadi_formulation.lb;
problem.ub = casadi_formulation.ub;

%% Compute quadratic representation of objective
J = casadi_formulation.obj;

% Quadratic objective term
Q_Fun = Function('Q_fun', {x}, {hessian(J, x)});
problem.Q = full(Q_Fun(zeros(size(x))));

% Linear objective term
J_Jac_Fun = Function('J_Jac_fun', {x}, {jacobian(J, x)});
problem.g = full(J_Jac_Fun(zeros(size(x))))';

%% Linearize constraints (assumed to be linear)
hasConstraints = isfield(casadi_formulation, 'constr');
if (hasConstraints)
    constr = casadi_formulation.constr;
    lbA = casadi_formulation.lb_constr;
    ubA = casadi_formulation.ub_constr;
    
    hasConstraints = hasConstraints && ~isempty(constr);
end
if (hasConstraints)
    Constr = Function('Constr', {x}, {constr});
    A_Fun = Function('A_Fun', {x}, {jacobian(constr, x)});
    problem.A = full(A_Fun(zeros(size(x))));

    % Linearization correction term
    constr_constant = Constr(zeros(size(x)));
    problem.lbA = lbA - full(constr_constant);
    problem.ubA = ubA - full(constr_constant);
end

%% Complementarities
compl_L = casadi_formulation.compl_L;
compl_R = casadi_formulation.compl_R;

Jac_L = Function('L_Fun', {x}, {jacobian(compl_L, x)});
problem.L = full(Jac_L(zeros(size(x))));
Jac_R = Function('R_Fun', {x}, {jacobian(compl_R, x)});
problem.R = full(Jac_R(zeros(size(x))));

%% Complementarity linear terms + affine term
L_Fun = Function('compl_L', {x}, {compl_L});
R_Fun = Function('compl_R', {x}, {compl_R});
problem.lb_L = -full(L_Fun(zeros(size(x))));
problem.lb_R = -full(R_Fun(zeros(size(x))));
problem.ub_L = inf(size(problem.lb_L));
problem.ub_R = inf(size(problem.lb_R));

