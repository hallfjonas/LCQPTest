%% Close and clear
clc; close all; clear all;

% Experiment 0: easier, 1: harder
exp = '0';

problem = ReadData(['data', exp]);

%% Get Gurobi's solution
gurobi_x_opt = readmatrix(fullfile(['sol', exp], 'x_opt_gurobi.txt'));

%% Regularization
%problem.Q = problem.Q + 2*problem.L'*problem.L;
%problem.g = problem.g - sum(problem.L,1)';
min_eig = min(eig(problem.Q));
if (min_eig < 0)
    problem.Q = problem.Q - 10*min_eig*eye(size(problem.Q));
end

%% In case of OSQP
% OSQP needs the box constraints as regular constraints
 lb = problem.lb;
 ub = problem.ub;
 
 for i = 1:length(lb)
     if (lb(i) > -inf || ub(i) < inf)
         problem.A(end+1, i) = 1;
         problem.lbA(end+1) = lb(i);
         problem.ubA(end+1) = ub(i);
     end
 end

%% Solve LCQP
addpath("~/LCQPow/build/lib");
params.qpSolver = 1;
params.printLevel = 2;
params.initialPenaltyParameter = eps;
params.penaltyUpdateFactor = 2;
params.maxIterations = 10000;
params.maxRho = 1e7;
params.stationarityTolerance = 1e-8;
params.etaDynamicPenalty = 0.5;
params.nDynamicPenalty = 0;

% if you want to try to initialize with gruobis solution do this:
% params.x0 = gurobi_x_opt;
% params.solveZeroPenaltyFirst = false;
% params.initialPenaltyParameter = 2.05e+03;

[x, y, stats] = LCQPow( ...
    sparse(problem.Q), ...
    problem.g, ...
    sparse(problem.L), ...
    sparse(problem.R), ...
    problem.lbL, ...
    problem.ubL, ...
    problem.lbR, ...
    problem.ubR, ...
    sparse(problem.A), ...
    problem.lbA, ...
    problem.ubA, ...
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
