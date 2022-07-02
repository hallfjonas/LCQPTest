function [solution] = SolveLCQPow_qpOASES(casadi_formulation)

% Retreive the matrix-based LCQP formulation
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

% Penalty settings
penaltySettings = GetPenaltySettings();

% Solver Settings
params.printLevel = 0;
params.initialPenaltyParameter = penaltySettings.rho0;
params.penaltyUpdateFactor = penaltySettings.beta;
params.rhoMax = penaltySettings.rhoMax;
params.storeSteps = true;
params.qpSolver = 0;
params.qpOASES_options = qpOASES_options();
params.qpOASES_options.enableRegularisation = true;
% params.stationarityTolerance = 10e-6;

tic;
[solution.x,solution.y,solution.stats] = LCQPow(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    problem.lbL, ...
    problem.ubL, ...
    problem.lbR, ...
    problem.ubR, ...
    problem.A, ...
    problem.lbA, ...
    problem.ubA, ...
    problem.lb, ...
    problem.ub, ...
    params ...
);
solution.stats.elapsed_time_w_overhead = toc;

solution.stats.obj = full(problem.Obj(solution.x));
solution.stats.compl = full(problem.Phi(solution.x));
solution.stats.n_x = size(problem.Q, 1);
solution.stats.n_c = size(problem.A, 1);
solution.stats.n_comp = size(problem.L, 1);

end

