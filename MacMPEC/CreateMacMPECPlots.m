
addpath("helpers");
addpath("../helpers");

%% Prepare Performance Plots
close all; clear; clc;
outdir = 'solutions/mpc_review';
load(fullfile(outdir, 'sol.mat'));

% Get the solver visualization settings and add them to the struct
for s=1:length(benchmark.solvers)
    for p=1:length(benchmark.problems)
        benchmark.problems{p}.solutions{s}.solver.style = GetPlotStyle(benchmark.problems{p}.solutions{s}.solver.fun);
    end
end

%% Create plots
close all;

% Create the plots
PlotTimings(benchmark.problems, 'MacMPEC', outdir);
SaveOutput(benchmark.problems, outdir);

% PlotTimingswOverhead(benchmark.problems, 'MacMPEC', outdir);
% PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC', outdir, "cutoff_penalized");
