
addpath("../helpers");
addpath("helpers");

% Plot solutions
close all;
outdir = 'solutions/mpc_review';

% Warnings for similar reasons as above
load(outdir + "/sol.mat");

PlotTimings(benchmark.problems, 'MovingMasses', outdir);
PlotAccuracyMM(benchmark.problems, 'MovingMasses', outdir);

PlotSolutionsMM(benchmark.problems{end}, 'MovingMasses', outdir);
%PlotTimingswOverhead(benchmark.problems, 'MovingMasses', outdir);
