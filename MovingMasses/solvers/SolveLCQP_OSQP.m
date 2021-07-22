function [solutions] = SolveLCQP_OSQP(problem)

addpath("~/LCQPow/build/lib");

%% Get formulation
LCQP_formulation = ObtainLCQP(problem.casadi_formulation);

%% Set parameters
params.initialPenaltyParameter = LCQP_formulation.rho0;
params.penaltyUpdateFactor = LCQP_formulation.beta;
params.stationarityTolerance = 1e-3;
params.printLevel = 0;
params.storeSteps = false;
params.maxIterations = 2000;
params.qpSolver = 2;
params.x0 = LCQP_formulation.x0;

lb = LCQP_formulation.lb;
ub = LCQP_formulation.ub;

for i = 1:length(lb)
    if (lb(i) > -inf || ub(i) < inf)
        row_idx = size(LCQP_formulation.A, 1)+1;
        LCQP_formulation.A(row_idx, i) = 1;
        LCQP_formulation.lbA(row_idx) = lb(i);
        LCQP_formulation.ubA(row_idx) = ub(i);
    end
end

%% Rund solver
[x, ~, stats] = LCQPow( ...
    sparse(LCQP_formulation.Q), LCQP_formulation.g, ...
    sparse(LCQP_formulation.L), sparse(LCQP_formulation.R), ...
    sparse(LCQP_formulation.A), LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    params ...
);

solutions.x = x;
solutions.stats = stats;
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));

end