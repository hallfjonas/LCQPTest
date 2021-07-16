function [solutions] = SolveLCQP(problem)

addpath("~/LCQPow/build/lib");

LCQP_formulation = problem.LCQP_formulation;

params = GetLCQPParameters( );
params.x0 = LCQP_formulation.x0;

[x, y, stats] = LCQPow( ...
    LCQP_formulation.Q, LCQP_formulation.g, ...
    LCQP_formulation.L, LCQP_formulation.R, ...
    LCQP_formulation.A, LCQP_formulation.lbA, LCQP_formulation.ubA, ...
    LCQP_formulation.lb, LCQP_formulation.ub, ...
    params ...
);

solutions.x = x;
solutions.y = y;
solutions.stats = stats;

end