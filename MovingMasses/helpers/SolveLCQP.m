function [solutions] = SolveLCQP(problem)

addpath("~/LCQPow/build/lib");

%% Get formulation
LCQP_formulation = ObtainLCQP(problem.casadi_formulation);

%% Set parameters
params.initialPenaltyParameter = LCQP_formulation.rho0;
params.penaltyUpdateFactor = LCQP_formulation.beta;
params.stationarityTolerance = 1e-3;
params.printLevel = 1;
params.storeSteps = false;
params.maxIterations = 2000;
params.qpSolver = 1;
params.x0 = LCQP_formulation.x0;

%% Rund solver
[x, ~, stats] = LCQPow( ...
    LCQP_formulation.Q, LCQP_formulation.g, ...
    LCQP_formulation.L, LCQP_formulation.R, ...
    LCQP_formulation.A, LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    LCQP_formulation.lb, LCQP_formulation.ub, ...
    params ...
);

solutions.x = x;
solutions.stats = stats;
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));

end