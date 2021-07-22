%% Clear and Close
clc; clear all; close all;

%% Load Dirs
addpath("solvers");
addpath("plotters");

%% Build benchmark
benchmark = {};
benchmark.problems = ReadMacMPECProblems();

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP', 'name', 'LCQPow', 'color', 'red', 'lineStyle', '--'), ... 
    struct('fun', 'SolveSNOPT', 'name', 'SNOPT', 'color', 'blue', 'lineStyle', ':'), ...
    struct('fun', 'SolveKNITRO', 'name', 'KNITRO', 'color', 'green', 'lineStyle', '-.'), ...
    % struct('fun', 'SolveIPOPT', 'name', 'IPOPT Pen', 'color', 'green') ...
    %struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'color', 'blue'), ... 
    %struct('fun', 'SolveLCQP_Leyffer3', 'name', 'LCQPow Leyffer 3', 'color', [0.1 0.1 0.1]), ... 
    %struct('fun', 'SolveLCQP_Leyffer10', 'name', 'LCQPow Leyffer 10', 'color', [0.75 0.75 0.75]), ... 
};

%% Run Solvers
for i = 1:length(benchmark.problems)
    
    fprintf("Solving problem %s (%d/%d).\n", benchmark.problems{i}.name, i, length(benchmark.problems));
    
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.name);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

%% Create Performance Plots
close all;
PlotTimings(benchmark.problems);
