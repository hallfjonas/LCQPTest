function [solutions] = SolveLCQP_Leyffer3(problem)

addpath("~/LCQPow/build/lib");

%% Get formulation
LCQP_formulation = ObtainLCQP(problem.casadi_formulation);

%% Set parameters
params.initialPenaltyParameter = problem.casadi_formulation.rho0;
params.penaltyUpdateFactor = problem.casadi_formulation.beta;
params.complementarityTolerance = problem.casadi_formulation.complementarityTolerance;
params.maxRho = problem.casadi_formulation.rhoMax;
params.printLevel = 0;
params.storeSteps = false;
params.maxIterations = 10000;
params.etaDynamicPenalty = 0.9;
params.nDynamicPenalty = 0;
params.qpSolver = 1;
params.x0 = LCQP_formulation.x0;

%% Rund solver
[x, ~, stats] = LCQPow( ...
    sparse(LCQP_formulation.Q), LCQP_formulation.g, ...
    sparse(LCQP_formulation.L), sparse(LCQP_formulation.R), ...
    LCQP_formulation.lb_L, LCQP_formulation.ub_L, LCQP_formulation.lb_R, LCQP_formulation.ub_R, ...
    sparse(LCQP_formulation.A), LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    LCQP_formulation.lb, LCQP_formulation.ub, ...
    params ...
);

solutions.x = x; %full(problem.casadi_formulation_condensed.AllNodes(x));
solutions.stats = stats;
solutions.stats.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.stats.compl = full(problem.casadi_formulation.Phi(solutions.x));

end