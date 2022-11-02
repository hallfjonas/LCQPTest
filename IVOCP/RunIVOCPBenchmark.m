%% Clean Up
close all; clear all; clc;

%% Build benchmark
benchmark = {};
benchmark.problems = {};

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQPow1'), ... 
    struct('fun', 'SolveLCQPow2'), ... 
    struct('fun', 'SolveMIQP'), ... 
    struct('fun', 'SolveIPOPTPen'), ...
    struct('fun', 'SolveIPOPTRegEq'), ...
    struct('fun', 'SolveIPOPTReg'), ...
    struct('fun', 'SolveIPOPTNLP'), ...
};

% Generate problems
i = 1;
for N = 50:5:100
    for x00 = linspace(-1.9, -0.9, 10)
        benchmark.problems{i}.T = 2;
        benchmark.problems{i}.N = N;    
        benchmark.problems{i}.x00 = x00;    
        benchmark.problems{i}.casadi_formulation = GetIVOCP(2, N, x00);        
        i = i+1;
    end
end

%% Run solvers
addpath("../solvers");
addpath("../solvers/LCQPowVariants/");
addpath("../helpers")
for i = 1:length(benchmark.problems)    
    fprintf("Solving problem %s (%d/%d).\n", string(benchmark.problems{i}.N), i, length(benchmark.problems));
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

%% Create Performance Plots
close all; clear all; clc;
outdir = 'solutions/paper';
load(fullfile(outdir, 'sol.mat'));
addpath("helpers");
addpath("../helpers");

% Get the solver visualization settings
for s=1:length(benchmark.solvers)
    for p=1:length(benchmark.problems)
        benchmark.problems{p}.solutions{s}.solver.style = GetPlotStyle(benchmark.problems{p}.solutions{s}.solver.fun);
    end
end

save(outdir + "/sol.mat");

%% Complementarity tolerance
close all;

outdir = 'solutions/paper';
load(fullfile(outdir, 'sol.mat'));

outdir = 'solutions/paper';
addpath("helpers");

% Create the plots
PlotTimings(benchmark.problems, 'IVOCP', outdir);
% PlotTimingswOverhead(benchmark.problems, 'IVOCP', outdir);
PlotAccuracyIVOCP(benchmark.problems, 'IVOCP', outdir);
