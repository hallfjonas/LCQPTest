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

% Sparse LCQPs
i = 1;
for N = 10:10:100
    for n = 2:2:10
        for constraint_fraction = 4:5
            % fraction of linear constraints 
            m = round(n/constraint_fraction);

            if (m <= 0)
                continue;
            end
            
            % fraction of complementarity constraints
            n_cc = m;

            benchmark.problems{i}.n = n*N;
            benchmark.problems{i}.m = m*N;
            benchmark.problems{i}.n_cc = n_cc*N;

            benchmark.problems{i}.LCQP_formulation = GenerateRandomSparseLCQP(n, m, n_cc, N);
            i = i+1;
        end
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

save('solutions/sparse.mat');

%% Plot solutions
close all;
PlotTimings(benchmark.problems);

