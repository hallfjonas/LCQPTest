addpath("../helpers/");
addpath("helpers/");

%% Complementarity tolerance
close all;

outdir = 'solutions/mpc_review';
load(fullfile(outdir, 'sol.mat'));

% Create the plots
PlotTimings(benchmark.problems, 'IVOCP', outdir);
PlotAccuracyIVOCP(benchmark.problems, 'IVOCP', outdir);
% PlotTimingswOverhead(benchmark.problems, 'IVOCP', outdir);
