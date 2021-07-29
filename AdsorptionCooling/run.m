%% Close and clear
clc; close all; clear all;

% Experiment 0: easier, 1: harder
exp = '2';

problem = ReadData(['data', exp]);

%% Get Gurobi's solution
gurobi_x_opt = readmatrix(fullfile(['sol', exp], 'x_opt_gurobi.txt'));

%% Solve LCQP
addpath("~/LCQPow/build/lib");
params.qpSolver = 1;
params.printLevel = 2;
params.solveZeroPenaltyFirst = false;
params.initialPenaltyParameter = 10^5;
params.maxIterations = 10000;
params.x0 = gurobi_x_opt;

[x, y, stats] = LCQPow( ...
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

%% Write LCQPow solution
writematrix(x, fullfile(['sol', exp], 'x_opt_LCQPow.txt'));

%% Compare Solutions
problem.obj = @(var) 1/2*var'*problem.Q*var + problem.g'*var;
problem.phi = @(var) (problem.L*var - problem.lbL)'*(problem.R*var - problem.lbR);
problem.phi_inft = @(var) max(abs((problem.L*var - problem.lbL).*(problem.R*var - problem.lbR)));

fprintf("Gubrobi   obj(x_opt) = %g\n", problem.obj(gurobi_x_opt));
fprintf("LCQPow    obj(x_opt) = %g\n", problem.obj(x));
fprintf("Gubrobi   phi(x_opt) = %7.7g   phi_infty(x_opt) = %7.7g\n", problem.phi(gurobi_x_opt), problem.phi_inft(gurobi_x_opt));
fprintf("LCQPow    phi(x_opt) = %7.7g   phi_infty(x_opt) = %7.7g\n", problem.phi(x), problem.phi_inft(x));

%% Plot stored steps
%PlotIterates(stats);
