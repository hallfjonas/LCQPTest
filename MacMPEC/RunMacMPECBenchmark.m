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
    struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'lineStyle', '--'), ... 
    struct('fun', 'SolveBARON', 'name', 'BARON', 'lineStyle', '-.') ...    
    struct('fun', 'SolveSNOPT', 'name', 'SNOPT', 'lineStyle', '-.'), ...
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Penalty', 'lineStyle', '--'), ...
    struct('fun', 'SolveMINOS', 'name', 'MINOS', 'lineStyle', '-.') ...    
    struct('fun', 'SolveKNITRO', 'name', 'KNITRO', 'color', 'green', 'lineStyle', ':'),
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

save('solutions/sol.mat');

%% Create Performance Plots
close all; clear all; clc;
load('solutions/sol.mat');
addpath("helpers");
PlotTimings(benchmark.problems, 'MacMPEC');
% PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC');
