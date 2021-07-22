function [solutions] = SolveLCQP_Leyffer5(problem)

addpath("~/LCQPow/build/lib");

%% Get formulation
LCQP_formulation = ObtainLCQP(problem.casadi_formulation);

%% Set parameters
params.initialPenaltyParameter = LCQP_formulation.rho0;
params.penaltyUpdateFactor = LCQP_formulation.beta;
params.stationarityTolerance = 1e-6;
params.printLevel = 0;
params.storeSteps = false;
params.maxIterations = 2000;
params.etaComplHist = 0.9;
params.nComplHist = 5;
params.qpSolver = 1;
params.x0 = LCQP_formulation.x0;

%% Rund solver
[x, ~, stats] = LCQPow( ...
    sparse(LCQP_formulation.Q), LCQP_formulation.g, ...
    sparse(LCQP_formulation.L), sparse(LCQP_formulation.R), ...
    sparse(LCQP_formulation.A), LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    LCQP_formulation.lb, LCQP_formulation.ub, ...
    params ...
);

solutions.x = x;
solutions.stats = stats;
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));

end