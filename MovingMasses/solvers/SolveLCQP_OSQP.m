function [solutions] = SolveLCQP_OSQP(problem)

addpath("~/LCQPow/build/lib");

%% Get formulation
LCQP_formulation = ObtainLCQP(problem.casadi_formulation);

%% Set parameters
params.initialPenaltyParameter = problem.casadi_formulation.rho0;
params.penaltyUpdateFactor = problem.casadi_formulation.beta;
params.complementarityTolerance = problem.casadi_formulation.complementarityTolerance;
params.maxRho = problem.casadi_formulation.rhoMax;
params.printLevel = 0;
params.maxIterations = 10000;
params.etaComplHist = 0.5;
params.nComplHist = 3;
params.qpSolver = 2;
params.x0 = LCQP_formulation.x0;

% OSQP needs the box constraints as regular constraints
lb = LCQP_formulation.lb;
ub = LCQP_formulation.ub;

for i = 1:length(lb)
    if (lb(i) > -inf || ub(i) < inf)
        LCQP_formulation.A(end+1, i) = 1;
        LCQP_formulation.lbA(end+1) = lb(i);
        LCQP_formulation.ubA(end+1) = ub(i);
    end
end

%% Rund solver
[x, ~, stats] = LCQPow( ...
    sparse(LCQP_formulation.Q), LCQP_formulation.g, ...
    sparse(LCQP_formulation.L), sparse(LCQP_formulation.R), ...
    LCQP_formulation.lb_L, LCQP_formulation.ub_L, LCQP_formulation.lb_R, LCQP_formulation.ub_R, ...
    sparse(LCQP_formulation.A), LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    params ...
);

solutions.x = x;
solutions.stats = stats;
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));

end