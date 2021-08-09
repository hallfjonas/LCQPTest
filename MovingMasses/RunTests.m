%% Clean Up
close all; clear all; clc;

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

u_bounded = false;

% Add problems with 2 masses
i = 1;
for N = 50:5:100
    for T = 2:0.1:4
        benchmark.problems{i}.nMasses = 2;
        benchmark.problems{i}.T = T;
        benchmark.problems{i}.N = N;    
        benchmark.problems{i}.casadi_formulation = GetMovingMassesLCQP(2, T, N, u_bounded);
        % benchmark.problems{i}.casadi_formulation_condensed = GetMovingMassesCondensedLCQP(2, T, N, u_bounded);
        
        i = i+1;
    end
end

%% Run solvers
addpath("../solvers");
for i = 1:length(benchmark.problems)
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i});
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

%% Plot solutions
close all;
addpath("../plotters");

% PlotSolutions(benchmark.problems{end});
PlotTimings(benchmark.problems, 'MovingMasses');
PlotAccuracy(benchmark.problems, 'MovingMasses');
