function [solution] = SolveLCQPow_OSQP(casadi_formulation)

problem = ObtainLCQPFromCasadi(casadi_formulation);

if (~isfield(problem, 'A'))
    problem.A = [];
    problem.lbA = [];
    problem.ubA = [];
end

if (~isfield(problem, 'lbL'))
    problem.lbL = [];
end
if (~isfield(problem, 'ubL'))
    problem.ubL = [];
end
if (~isfield(problem, 'lbR'))
    problem.lbR = [];
end
if (~isfield(problem, 'ubR'))
    problem.ubR = [];
end

if (exist('lb', 'var') && exist('ub', 'var'))
    problem.A = [problem.A; eye(length(lb))];
    problem.lbA = [problem.lbA; lb];
    problem.ubA = [problem.ubA; ub];
end

% Penalty settings
penaltySettings = GetPenaltySettings();

% Solver Settings
params.printLevel = 0;
params.rho0 = penaltySettings.rho0;
params.penaltyUpdateFactor = penaltySettings.beta;
params.rhoMax = penaltySettings.rhoMax;
params.qpSolver = 2;
%params.OSQP_options = osqp.default_settings();
%params.OSQP_options.polish = 1;

tic;
[solution.x,solution.y,solution.stats] = LCQPow(...
    sparse(problem.Q), ...
    problem.g, ...
    sparse(problem.L), ...
    sparse(problem.R), ...
    problem.lbL, ...
    problem.ubL, ...
    problem.lbR, ...
    problem.ubR, ...
    sparse(problem.A), ...
    problem.lbA, ...
    problem.ubA, ...
    params ...
);
solution.stats.elapsed_time_w_overhead = toc;
solution.stats.obj = full(problem.Obj(solution.x));
solution.stats.compl = full(problem.Phi(solution.x));

end

