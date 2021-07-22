function [solutions] = SolveLCQP(problem)

addpath("~/LCQPow/build/lib");

LCQP_formulation = problem.LCQP_formulation;

%% Set parameters
params.initialPenaltyParameter = LCQP_formulation.rho0;
params.penaltyUpdateFactor = LCQP_formulation.beta;
params.stationarityTolerance = 1e-6;
params.printLevel = 0;
params.storeSteps = false;
params.maxIterations = 2000;
params.qpSolver = 1;
% params.x0 = LCQP_formulation.x0;
% params.y0 = GetDualGuess(LCQP_formulation, params.x0);

%% Rund solver
[x, y, stats] = LCQPow( ...
    sparse(LCQP_formulation.Q), LCQP_formulation.g, ...
    sparse(LCQP_formulation.L), sparse(LCQP_formulation.R), ...
    LCQP_formulation.lbL, [], LCQP_formulation.lbR, [], ...
    sparse(LCQP_formulation.A), LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    params ...
);

solutions.x = x;
solutions.stats = stats;

IPOPT_formulation = GetIPOPTFormulation(problem.LCQP_formulation);

solutions.obj = full(IPOPT_formulation.Obj(solutions.x));
solutions.compl = full(IPOPT_formulation.Phi(solutions.x));

end