%% Clean Up
close all; clear all; clc;

%% Build benchmark
benchmark = {};
benchmark.problems = {};

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
addpath("../solvers/");
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP', 'name', 'LCQP', 'lineStyle', '-'), ...     
    struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQP OSQP', 'lineStyle', '--'), ... 
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Penalty', 'lineStyle', '--'), ...
    %struct('fun', 'SolveIPOPTRegComp', 'name', 'IPOPT Relax', 'lineStyle', ':'), ...    
    %struct('fun', 'SolveIPOPTRegEq', 'name', 'IPOPT Smooth', 'lineStyle', ':'), ...
    %struct('fun', 'SolveLCQP_L0_OSQP', 'name', 'LCQP L0 OSQP', 'lineStyle', '-.'), ... 
    %struct('fun', 'SolveLCQP_L0_qpOASES', 'name', 'LCQP L0 qpOASES', 'lineStyle', '-.'), ... 
    %struct('fun', 'SolveLCQP_Leyffer3', 'name', 'LCQP Leyffer 3', 'lineStyle', '--'), ...
    %struct('fun', 'SolveLCQP_Leyffer5', 'name', 'LCQP Leyffer 5', 'lineStyle', ':'), ...
    %struct('fun', 'SolveLCQP_Leyffer10', 'name', 'LCQP Leyffer 10', 'lineStyle', ':') ...
};

% Generate problems
i = 1;
for N = 50:5:60
    for x00 = linspace(-1.9, -0.9, 10)
        benchmark.problems{i}.T = 2;
        benchmark.problems{i}.N = N;    
        benchmark.problems{i}.x00 = x00;    
        benchmark.problems{i}.casadi_formulation = GetIVOCP(2, N, x00);        
        i = i+1;
    end
end

%% Run solvers
for i = 1:length(benchmark.problems)
    fprintf("Solving problem %s (%d/%d).\n", string(benchmark.problems{i}.N), i, length(benchmark.problems));
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i});
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

outdir = 'solutions';
save(fullfile(outdir, 'sol.mat'));

%% Plot solutions
close all;
outdir = 'solutions';
compl_tol = 10e-7;

load(fullfile(outdir, 'sol.mat'));
%PlotSolutions(benchmark.problems{1});

addpath("helpers");
addpath("../plotters");
PlotTimings(benchmark.problems, 'IVOCP', outdir, compl_tol);
PlotAccuracyIVOCP(benchmark.problems, 'IVOCP', outdir, compl_tol);
