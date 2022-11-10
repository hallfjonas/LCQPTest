%% Clear and Close
clc; clear all; close all;

%% Build benchmark
benchmark = {};
benchmark.problems = ReadMacMPECProblems('MacMPECMatlab');

benchmark.solvers = { ...
    struct('fun', 'SolveLCQPow0'), ... 
    struct('fun', 'SolveLCQPow2'), ... 
    struct('fun', 'SolveLCQPow0_SmallFast'), ... 
    struct('fun', 'SolveLCQPow2_LargeRho0'), ... 
    struct('fun', 'SolveLCQPow0_NoLeyffer'), ... 
};

%% Run Solvers
addpath("../solvers/LCQPowVariants");
addpath("../solvers");
addpath("../helpers/");
for i = 1:length(benchmark.problems)
    fprintf("Solving problem %s (%d/%d).\n", benchmark.problems{i}.name, i, length(benchmark.problems));
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.casadi_formulation);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

outdir = 'solutions/variants';
if ~exist(outdir, 'dir')
   mkdir(outdir)
end

save(outdir + "/sol.mat");

%% Prepare Performance Plots
close all; clear; clc;
outdir = 'solutions/variants';
load(fullfile(outdir, 'sol.mat'));
addpath("helpers");
addpath("../helpers");

% Get the solver visualization settings and add them to the struct
for s=1:length(benchmark.solvers)
    for p=1:length(benchmark.problems)
        benchmark.problems{p}.solutions{s}.solver.style = GetPlotStyleLCQPowComparison(benchmark.problems{p}.solutions{s}.solver.fun);
    end
end

%% Create plots
close all;

% Create the plots
PlotTimings(benchmark.problems, 'MacMPEC', outdir);
PlotTimingswOverhead(benchmark.problems, 'MacMPEC', outdir);
PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC', outdir, "cutoff_penalized");
