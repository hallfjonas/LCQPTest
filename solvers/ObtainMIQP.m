
function [problem] = ObtainMIQP(casadi_formulation)
%% Import casadi
import casadi.*

%% Extract variables, initial guess and box constraints
x = casadi_formulation.x;
nV = len(x);
lb = casadi_formulation.lb;
ub = casadi_formulation.ub;

%% Compute quadratic representation of objective
J = casadi_formulation.obj;

% Quadratic objective term
Q_Fun = Function('Q_fun', {x}, {hessian(J, x)});
Q = full(Q_Fun(zeros(size(x))));

% Linear objective term
J_Jac_Fun = Function('J_Jac_fun', {x}, {jacobian(J, x)});
g = full(J_Jac_Fun(zeros(size(x))))';

%% Linearize constraints (assumed to be linear)
hasConstraints = isfield(casadi_formulation, 'constr');
nC = 0;
if (hasConstraints)
    constr = casadi_formulation.constr;
    lbA = casadi_formulation.lb_constr;
    ubA = casadi_formulation.ub_constr;
    
    hasConstraints = hasConstraints && ~isempty(constr);
    nC = len(lbA);
end
if (hasConstraints)
    Constr = Function('Constr', {x}, {constr});
    A_Fun = Function('A_Fun', {x}, {jacobian(constr, x)});
    A = full(A_Fun(zeros(size(x))));

    % Linearization correction term
    constr_constant = Constr(zeros(size(x)));
    lbA = lbA - full(constr_constant);
    ubA = ubA - full(constr_constant);
end

%% Complementarities
compl_L = casadi_formulation.compl_L;
compl_R = casadi_formulation.compl_R;
nComp = len(coml_L);

Jac_L = Function('L_Fun', {x}, {jacobian(compl_L, x)});
L = full(Jac_L(zeros(size(x))));
Jac_R = Function('R_Fun', {x}, {jacobian(compl_R, x)});
R = full(Jac_R(zeros(size(x))));

%% Complementarity linear terms + affine term
L_Fun = Function('compl_L', {x}, {compl_L});
R_Fun = Function('compl_R', {x}, {compl_R});
lb_L = -full(L_Fun(zeros(size(x))));
lb_R = -full(R_Fun(zeros(size(x))));
ub_L = inf(size(problem.lb_L));
ub_R = inf(size(problem.lb_R));

%% Now introduce binary variables and extend to that diemnsion
% obj
Q_new = sparse([Q, zeros(nV,2*nComp); zeros(2*nComp,nV); zeros(2*nComp,2*nComp)]);
g_new = [g; zeros(2*nComp,1)];
problem.Q = Q_new;
problem.g = g_new;

% constraints
A_new = sparse([A, zeros(nC,2*nComp)]);
L_new = sparse([L, zeros(nComp,2*nComp)]);
R_new = sparse([R, zeros(nComp,2*nComp)]);
A_bin = sparse([zeros(nComp, nV), eye(nComp), eye(nComp)]);
problem.A = sparse([A_new; -A_new; L_new; -L_new; R_new; -R_new; A_bin; A_bin]);
problem.rhs = [ubA; -lbA; ub_L; -lb_L; ub_R; -lb_R; ones(1,nComp);ones(1,nComp); zeros(1,nComp)];


