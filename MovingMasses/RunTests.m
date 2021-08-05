%% Clean Up
close all; clear all; clc;

%% Load libraries
addpath("~/LCQPow/build/lib");
addpath("~/casadi-matlab2014b-v3.5.5");
addpath("helpers");
addpath("solvers");

%% Build benchmark
benchmark = {};
benchmark.problems = {};

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP', 'name', 'LCQPow', 'lineStyle', '-'), ...     
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Penalty', 'lineStyle', '--'), ...
    struct('fun', 'SolveLCQP_Leyffer3', 'name', 'LCQPow Leyffer 3', 'lineStyle', ':'), ...
    struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'lineStyle', '-.'), ... 
    struct('fun', 'SolveLCQP_Leyffer5', 'name', 'LCQPow Leyffer 5', 'lineStyle', ':'), ...
    %struct('fun', 'SolveLCQPDense', 'name', 'LCQPow Dense', 'lineStyle', '-.'), ... 
    %struct('fun', 'SolveLCQP_Leyffer10', 'name', 'LCQPow Leyffer 10', 'lineStyle', ':') ...
    %struct('fun', 'SolveIPOPTReg', 'name', 'IPOPT Reg', 'lineStyle', '-.'), ...
    %truct('fun', 'SolveIPOPTRegComp', 'name', 'IPOPT RegComp', 'lineStyle', ':'), ...
    %struct('fun', 'SolveIPOPTRegEq', 'name', 'IPOPT RegEq', 'lineStyle', ':'), ...
    %struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'color', 'blue'), ... 
};

u_bounded = false;

% Add problems with 2 masses
i = 1;
for N = 50:5:50
    for T = 2:0.2:3
        benchmark.problems{i}.nMasses = 2;
        benchmark.problems{i}.T = T;
        benchmark.problems{i}.N = N;    
        benchmark.problems{i}.casadi_formulation = GetMovingMassesLCQP(2, T, N, u_bounded);
        % benchmark.problems{i}.casadi_formulation_condensed = GetMovingMassesCondensedLCQP(2, T, N, u_bounded);
        
        i = i+1;
    end
end

%% Run solvers
for i = 1:length(benchmark.problems)
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i});
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

%% Plot solutions
close all;
%for i = 1:length(benchmark.problems)
%    PlotSolutions(benchmark.problems{i});
%end
addpath("plotters")
PlotSolutions(benchmark.problems{1});
PlotTimings(benchmark.problems);
PlotAccuracy(benchmark.problems);
