%% Clean Up
close all; clear all; clc;

%% Load libraries
addpath("~/LCQPow/build/lib");
addpath("~/casadi-matlab2014b-v3.5.5");

%% Build benchmark
benchmark = {};
benchmark.solvers = {};
benchmark.problems = {};

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    benchmark.solvers{:}, ... 
    struct('fun', 'SolveLCQP', 'name', 'LCQPow', 'color', 'blue');
};

% Add problems with 2 masses
T = 3;
i = 1;
for N = 90:5:90
    benchmark.problems{i}.nMasses = 2;
    benchmark.problems{i}.T = T;
    benchmark.problems{i}.N = N;    
    benchmark.problems{i}.casadi_formulation = GetMovingMassesLCQP(2, T, N);
    benchmark.problems{i}.LCQP_formulation = ObtainLCQP(benchmark.problems{i}.casadi_formulation);
    
    % TODO: IPOPT formulation(s)
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
for i = 1:length(benchmark.problems)
    PlotSolutions(benchmark.problems{i});
end

