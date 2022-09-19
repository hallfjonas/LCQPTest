
function [problem] = ObtainIPOPTNLP(casadi_formulation)
%% Import casadi
import casadi.*

% Copy variables, box constraints and initial guess
problem.x = casadi_formulation.x;
problem.lb = casadi_formulation.lb;
problem.ub = casadi_formulation.ub;

if (isfield(casadi_formulation, 'x0'))
    problem.x0 = casadi_formulation.x0;
end

% Copy constraints
problem.constr = casadi_formulation.constr;
problem.lb_constr = casadi_formulation.lbA;
problem.ub_constr = casadi_formulation.ubA;

% RHS tolerance
problem.sigma = SX.sym('sigma', 1);

compl_sum = 0;
for i=1:length(casadi_formulation.compl_L)
    % Impose non-negativity
    problem.constr = [problem.constr; casadi_formulation.compl_L{i}];
    problem.constr = [problem.constr; casadi_formulation.compl_R{i}];
    problem.lb_constr = [problem.lb_constr; 0; 0];
    problem.ub_constr = [problem.ub_constr; inf; inf];
    
    % Create sum of complementarity products
    compl_prod = casadi_formulation.compl_L{i}*casadi_formulation.compl_R{i};
    compl_sum = compl_sum + compl_prod;
end    

% Impose complementarity as inequality constraint
problem.constr = [problem.constr; compl_sum - problem.sigma];
problem.lb_constr = [problem.lb_constr; -inf];
problem.ub_constr = [problem.ub_constr; 0];

% Objective function (including penalty term)
problem.obj = casadi_formulation.J;

% Save the complementarity function
problem.Comp_fun = Function('Comp_fun', {problem.x}, {compl_sum});

end

