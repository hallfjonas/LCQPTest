%% Clear and Close
clc; clear all; close all;

%% Build benchmark
benchmark = {};
benchmark.problems = ReadMacMPECProblems('MacMPECMatlab');

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP', 'name', 'LCQP', 'lineStyle', '-'), ... 
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT', 'lineStyle', '--'), ...
    struct('fun', 'SolveMIQP', 'name', 'MIQP', 'lineStyle', '-'), ... 
    struct('fun', 'SolveSNOPT', 'name', 'SNOPT', 'lineStyle', '-.'), ...
    struct('fun', 'SolveMINOS', 'name', 'MINOS', 'lineStyle', '-.'), ...    
    % KNITRO and BARON are limited to 10 vars and constraints
    % struct('fun', 'SolveKNITRO', 'name', 'KNITRO', 'lineStyle', ':'), ...
    % struct('fun', 'SolveBARON', 'name', 'BARON', 'lineStyle', '-.') ...
};

%% Run Solvers
addpath("./solvers");
for i = 1:length(benchmark.problems)
    fprintf("Solving problem %s (%d/%d).\n", benchmark.problems{i}.name, i, length(benchmark.problems));
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.name);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

save('solutions/miqp/sol.mat');

%% Create Performance Plots
close all; clear all; clc;
load('solutions/miqp/sol.mat');
addpath("helpers");

% Complementarity violation larger than this will count as non-successful
% convergence
compl_tolerance = 10e-7;

% Select a directory to save figures to
outdir = 'solutions/miqp';
% For final results:
% outdir = '../../paper-lcqp-2/figures/benchmarks';
PlotTimings(benchmark.problems, 'MacMPEC', outdir,compl_tolerance);
PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC', outdir, compl_tolerance);
SaveOutput(benchmark.problems, outdir);

