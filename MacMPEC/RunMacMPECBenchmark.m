%% Clear and Close
clc; clear all; close all;

%% Build benchmark
benchmark = {};
benchmark.problems = ReadMacMPECProblems('MacMPECMatlab');

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP'), ... 
    struct('fun', 'SolveLCQP_OSQP'), ... 
    struct('fun', 'SolveMIQP'), ... 
    struct('fun', 'SolveIPOPT'), ...
    struct('fun', 'SolveSNOPT'), ...
    struct('fun', 'SolveMINOS'), ...    
    % KNITRO and BARON are limited to 10 vars and constraints
    % struct('fun', 'SolveKNITRO', 'name', 'KNITRO', 'lineStyle', ':'), ...
    % struct('fun', 'SolveBARON', 'name', 'BARON', 'lineStyle', '-.') ...
    % NLP method unable to solve anything...
    % struct('fun', 'SolveNLP'), ...
};

% Get the solver visualization settings
for s=1:length(benchmark.solvers)
    benchmark.solvers{s}.style = GetPlotStyle(benchmark.solvers{s}.fun);
end

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

outdir = 'solutions/062522';
if ~exist(outdir, 'dir')
   mkdir(outdir)
end

save(outdir + "/sol.mat");

%% Create Performance Plots
close all; clear all; clc;
outdir = 'solutions/062522';
load(fullfile(outdir, 'sol.mat'));
addpath("helpers");

% Complementarity violation larger than this will count as non-successful
% convergence
compl_tolerance = 10e-2;

% Select a directory to save figures to
% For final results:
% outdir = '../../paper-lcqp-2/figures/benchmarks';
PlotTimings(benchmark.problems, 'MacMPEC', outdir,compl_tolerance);
PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC', outdir, compl_tolerance);
SaveOutput(benchmark.problems, outdir, compl_tolerance);

% Count unsuccessful complementarity convergence too
close all;
compl_tolerance = 1000;

% Select a directory to save figures to
outdir = fullfile(outdir, 'low_compl');

if ~exist(outdir, 'dir')
   mkdir(outdir)
end

% For final results:
% outdir = '../../paper-lcqp-2/figures/benchmarks';
PlotTimings(benchmark.problems, 'MacMPEC', outdir,compl_tolerance);
PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC', outdir, compl_tolerance);
SaveOutput(benchmark.problems, outdir, compl_tolerance);

