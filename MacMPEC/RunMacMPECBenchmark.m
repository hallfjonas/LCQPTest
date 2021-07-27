%% Clear and Close
clc; clear all; close all;

%% Build benchmark
benchmark = {};
benchmark.problems = ReadMacMPECProblems();

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP', 'name', 'LCQPow', 'lineStyle', '-'), ... 
    struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'lineStyle', '-.'), ... 
    struct('fun', 'SolveSNOPT', 'name', 'SNOPT', 'lineStyle', '-.'), ...
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Penalty', 'lineStyle', ':') ...
    
    % struct('fun', 'SolveKNITRO', 'name', 'KNITRO', 'color', 'green', 'lineStyle', ':'), ...
};

%% Run Solvers
addpath("solvers");
for i = 1:length(benchmark.problems)
    fprintf("Solving problem %s (%d/%d).\n", benchmark.problems{i}.name, i, length(benchmark.problems));
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.name);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end
save('solutions/lcqp_snopt_ipopt_osqp.mat');

%% Create Performance Plots
close all; clear all; clc;
addpath("plotters");
load('solutions/lcqp_snopt_ipopt_osqp.mat');
PlotTimings(benchmark.problems);
PlotAccuracy(benchmark.problems);
