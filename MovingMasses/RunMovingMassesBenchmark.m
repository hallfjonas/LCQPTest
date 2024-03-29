function [] = RunMovingMassesBenchmark(outdir)

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

% Add problems with 2 masses
i = 1;
for N = 50:5:100
    for T = 2:0.2:4
        benchmark.problems{i}.nMasses = 2;
        benchmark.problems{i}.T = T;
        benchmark.problems{i}.N = N;    
        benchmark.problems{i}.casadi_formulation = GetMovingMassesLCQP(2, T, N);
        
        i = i+1;
    end
end

%% Run solvers and save
for i = 1:length(benchmark.problems)
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.casadi_formulation);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

% Some warnings are thrown here because CasADi objects can't be stored
% That's OK, because we don't need the CasADi objects for post-processing
save(fullfile(outdir, "/sol.mat"));

end