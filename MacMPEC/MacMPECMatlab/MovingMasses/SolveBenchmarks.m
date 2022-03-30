%% Clear and load
clc; close all; clear all;

%% Load libraries
addpath("~/LCQPow/build/lib");
addpath("~/casadi");
addpath("helpers");

%% Specify solvers
% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Pen', 'color', 'green') ...
    struct('fun', 'SolveLCQP', 'name', 'LCQPow', 'color', 'blue'), ... 
};

%% Load and run benchmarks
files = dir('benchmarks/*.mat');
for i = 1:length(files)

    
    
    % Load benchmark
    load(fullfile(files.folder, files.name));
    
    % Run solvers
    for i = 1:length(benchmark.problems)
        for j = 1:length(benchmark.solvers)
            solver = benchmark.solvers{j};
            benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i});
            benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
        end
    end
end

%% Plot solutions
close all;
for i = 1:length(benchmark.problems)
    PlotSolutions(benchmark.problems{i});
end

PlotTimings(benchmark.problems);
