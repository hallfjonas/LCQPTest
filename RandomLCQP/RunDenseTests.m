%% Clean Up
close all; clear all; clc;

%% Load libraries
addpath("~/LCQPow/build/lib");
addpath("~/casadi-matlab2014b-v3.5.5");
addpath("helpers");
addpath("solvers");

%% Build benchmark
benchmark = {};
benchmark.problems = {};

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveLCQP', 'name', 'LCQPow', 'lineStyle', '-'), ...     
    struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'lineStyle', '--'), ... 
    struct('fun', 'SolveLCQP_L0_OSQP', 'name', 'LCQPow L0 OSQP', 'lineStyle', '-.'), ... 
    struct('fun', 'SolveLCQP_L0_qpOASES', 'name', 'LCQPow L0 qpOASES', 'lineStyle', '-.'), ... 
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Penalty', 'lineStyle', '--'), ...
    struct('fun', 'SolveIPOPTRegComp', 'name', 'IPOPT RegComp', 'lineStyle', ':'), ...    
    struct('fun', 'SolveIPOPTReg', 'name', 'IPOPT Reg', 'lineStyle', ':'), ...    
    %struct('fun', 'SolveIPOPTRegEq', 'name', 'IPOPT RegEq', 'lineStyle', ':'), ...
};

% Dense LCQPs
i = 1;
for n = 10:10:500
    for constraint_fraction = 3:4
        % fraction of linear constraints 
        m = round(n/constraint_fraction);

        % fraction of complementarity constraints
        n_cc = m;
        
        benchmark.problems{i}.n = n;
        benchmark.problems{i}.m = m;
        benchmark.problems{i}.n_cc = n_cc;    

        benchmark.problems{i}.LCQP_formulation = GenerateRandomLCQP(n, m, n_cc);
        i = i+1;
    end
end

%% Run solvers
for i = 1:length(benchmark.problems)
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i});
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

save('solutions/dense.mat');

%% Plot solutions
close all;
PlotTimings(benchmark.problems);

