function [solutions] = SolveLCQP(problem)

addpath("~/LCQPow/build/lib");

%% Get formulation
LCQP_formulation = ObtainLCQP(problem.casadi_formulation);

%% Set parameters
params.initialPenaltyParameter = problem.casadi_formulation.rho0;
params.penaltyUpdateFactor = problem.casadi_formulation.beta;
params.stationarityTolerance = 1e-6;
params.complementarityTolerance = problem.casadi_formulation.complementarityTolerance;
params.maxRho = problem.casadi_formulation.rhoMax;
params.printLevel = 0;
params.etaComplHist = 0.5;
params.nComplHist = 0;
params.storeSteps = false;
params.maxIterations = 10000;
params.qpSolver = 1;
params.x0 = LCQP_formulation.x0;
% params.y0 = GetDualGuess(LCQP_formulation, params.x0);

%% Rund solver
[x, y, stats] = LCQPow( ...
    sparse(LCQP_formulation.Q), LCQP_formulation.g, ...
    sparse(LCQP_formulation.L), sparse(LCQP_formulation.R), ...
    LCQP_formulation.lb_L, LCQP_formulation.ub_L, LCQP_formulation.lb_R, LCQP_formulation.ub_R, ...
    sparse(LCQP_formulation.A), LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    LCQP_formulation.lb, LCQP_formulation.ub, ...
    params ...
);

solutions.x = x; %full(problem.casadi_formulation_condensed.AllNodes(x));
solutions.stats = stats;
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));

end