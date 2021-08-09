
function [problem] = ObtainIPOPTPen(casadi_formulation)
%% Import casadi
import casadi.*

% Copy penalty settings
problem.rho0 = casadi_formulation.rho0;
problem.beta = casadi_formulation.beta;
problem.rhoMax = casadi_formulation.rhoMax;

% Copy variables, box constraints and initial guess
problem.x = casadi_formulation.x;
problem.lb = casadi_formulation.lb;
problem.ub = casadi_formulation.ub;
problem.x0 = casadi_formulation.x0;

% Copy constraints
problem.constr = casadi_formulation.constr;
problem.lb_constr = casadi_formulation.lb_constr;
problem.ub_constr = casadi_formulation.ub_constr;

% Objective
problem.obj = casadi_formulation.obj;

% Penalty Parameter
problem.sigma = SX.sym('sigma', 1);

for i=1:length(casadi_formulation.compl_L)
    % Impose non-negativity
    problem.constr = [problem.constr; casadi_formulation.compl_L{i}];
    problem.constr = [problem.constr; casadi_formulation.compl_R{i}];
    problem.lb_constr = [problem.lb_constr; 0; 0];
    problem.ub_constr = [problem.ub_constr; inf; inf];
    
    % Create sum of complementarity products
    compl_prod = casadi_formulation.compl_L{i}*casadi_formulation.compl_R{i};
    
    % Impose compl_prod = sigma
    problem.constr = [problem.constr; compl_prod - problem.sigma];
    problem.lb_constr = [problem.lb_constr; 0];
    problem.ub_constr = [problem.ub_constr; 0];
end    

end

