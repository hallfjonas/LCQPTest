%% Close and clear
clc; close all; clear all;

% Experiment 0: easier, 1: harder
exp = '0';

problem = ReadData(['data', exp]);

% Regularization around 0.5
problem.Q = problem.Q + problem.L'*problem.L;
problem.g = problem.g - sum(problem.L,1)';

%% Get Gurobi's solution
gurobi_x_opt = readmatrix(fullfile(['sol', exp], 'x_opt_gurobi.txt'));

%% Solve LCQP
addpath("~/LCQPow/build/lib");
params.qpSolver = 1;
params.printLevel = 2;
params.initialPenaltyParameter = 0.001;
params.penaltyUpdateFactor = 1.2;
% params.stationarityTolerance = 1e-7;
params.maxIterations = 10000;

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
problem.obj = @(x) 1/2*x'*problem.Q*x + problem.g'*x;
problem.phi = @(x) x'*problem.L'*problem.R*x - problem.lbL'*problem.R*x - problem.lbR'*problem.L*x;

fprintf("Gubrobi   obj(x_opt) = %g\n", problem.obj(gurobi_x_opt));
fprintf("LCQPow    obj(x_opt) = %g\n", problem.obj(x));
fprintf("Gubrobi   phi(x_opt) = %g\n", problem.phi(gurobi_x_opt));
fprintf("LCQPow    phi(x_opt) = %g\n", problem.phi(x));