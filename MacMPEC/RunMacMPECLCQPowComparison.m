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
    struct('fun', 'SolveLCQPSmallRho0', 'name', 'Small Rho0', 'lineStyle', '-.'), ... 
    struct('fun', 'SolveLCQPSmallSlowUpdates', 'name', 'Small and Slow', 'lineStyle', ':'), ... 
    struct('fun', 'SolveLCQPSmallFastUpdates', 'name', 'Small and Fast', 'lineStyle', '--'), ... 
    struct('fun', 'SolveLCQPLargeRho0', 'name', 'Large Rho0', 'lineStyle', '-.'), ... 
    struct('fun', 'SolveLCQPNoLeyffer', 'name', 'No Leyffer', 'lineStyle', ':'), ... 
    struct('fun', 'SolveLCQPNoZeroPen', 'name', 'No Zero Pen', 'lineStyle', '--'), ... 
    struct('fun', 'SolveLCQP_OSQP', 'name', 'OSQP', 'lineStyle', '-.'), ...
    struct('fun', 'SolveLCQP_Sparse', 'name', 'Sparse', 'lineStyle', ':'), ...   
};

outdir = "solutions/lcqp_comp";
%% Run Solvers
addpath("./solvers");
addpath("./solvers/LCQPowVariants/");
for i = 1:length(benchmark.problems)
    fprintf("Solving problem %s (%d/%d).\n", benchmark.problems{i}.name, i, length(benchmark.problems));
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.name);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

save(outdir + "/sol.mat");

%% Create Performance Plots
close all; clear all; clc;
outdir = 'solutions/lcqp_comp';
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

