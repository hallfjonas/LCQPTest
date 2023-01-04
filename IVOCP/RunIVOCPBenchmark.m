function [] = RunIVOCPBenchmark(outdir)

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

%% Run solvers and save
for i = 1:length(benchmark.problems)    
    fprintf("Solving problem %s (%d/%d).\n", string(benchmark.problems{i}.N), i, length(benchmark.problems));
    for j = 1:length(benchmark.solvers)
        solver = benchmark.solvers{j};
        benchmark.problems{i}.solutions{j} = feval(solver.fun, benchmark.problems{i}.casadi_formulation);
        benchmark.problems{i}.solutions{j}.solver = benchmark.solvers{j};
    end
end

save(fullfile(outdir, "/sol.mat"));

end
