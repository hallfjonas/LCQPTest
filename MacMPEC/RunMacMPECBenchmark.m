%% Clear and Close
clc; clear; close all;

%% Build benchmark
addpath("helpers");
benchmark = {};
benchmark.problems = ReadMacMPECProblems('MacMPECMatlab');

% Append solvers by specifying their function names.
% Each solver is assumed to take the input of a CasADi formulated 
% LCQP, and returns the primal and dual solution as well as some stats.
benchmark.solvers = { ...
    struct('fun', 'SolveLCQPow0'), ... 
    struct('fun', 'SolveLCQPow2'), ... 
    struct('fun', 'SolveMIQP'), ... 
    struct('fun', 'SolveIPOPTPen'), ...
    struct('fun', 'SolveIPOPTRegEq'), ...
    struct('fun', 'SolveIPOPTReg'), ...
    struct('fun', 'SolveIPOPTNLP'), ...
};

%% Run Solvers
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

outdir = 'solutions/paper';
if ~exist(outdir, 'dir')
   mkdir(outdir)
end

save(outdir + "/sol.mat");

%% Prepare Performance Plots
close all; clear; clc;
outdir = 'solutions/paper';
load(fullfile(outdir, 'sol.mat'));
addpath("helpers");
addpath("../helpers");

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
PlotTimingswOverhead(benchmark.problems, 'MacMPEC', outdir);
PlotAccuracyMacMPEC(benchmark.problems, 'MacMPEC', outdir, "cutoff_penalized");
