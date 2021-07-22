%% Clean Up
close all; clear all; clc;

%% Load libraries
addpath("~/LCQPow/build/lib");
addpath("~/casadi-matlab2014b-v3.5.5");
addpath("helpers");

%% Build benchmark
benchmark = {};
benchmark.problems = {};

% Append solvers by specifying a solver strategy and solver name
% Each solver is assumed to take the input of a benchmark.problem struct
% and return [x, y, stats]
benchmark.solvers = { ...
    struct('fun', 'SolveIPOPT', 'name', 'IPOPT Pen', 'color', 'green') ...
    struct('fun', 'SolveLCQP_OSQP', 'name', 'LCQPow OSQP', 'color', 'red'), ... 
    struct('fun', 'SolveLCQP_Matlab', 'name', 'LCQP Matlab', 'color', 'red'), ... 
};

u_bounded = false;

% Add problems with 2 masses
i = 1;
for N = 80:5:100
    for T = 2:0.5:3
        benchmark.problems{i}.nMasses = 2;
        benchmark.problems{i}.T = T;
        benchmark.problems{i}.N = N;    
        % benchmark.problems{i}.casadi_formulation = GetMovingMassesLCQP(2, T, N, u_bounded);
        benchmark.problems{i}.casadi_formulation = GetHoveringMassesLCQP(2, T, N, u_bounded);
        
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

%% Plot solutions
close all;
%for i = 1:length(benchmark.problems)
%    PlotSolutions(benchmark.problems{i});
%end
PlotSolutions(benchmark.problems{1});
PlotTimings(benchmark.problems);

