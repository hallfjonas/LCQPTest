function [] = SaveOutput(problems, outdir)

% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% A table containing the columns:
%   - problem name
%   - best known objective (according to MacMPEC library)
%   - solver 1 solution time
%   - solver 1 objective evaluation at solution
%   - solver 2 ...
resultstable = cell(np,2*ns);

% Table headers
resultstable{1,1} = "problem";
for s = 1:ns
    solution = problems{1}.solutions{s};
    resultstable{1,2} = "best_o";
    resultstable{1,2*s+1} = solution.solver.name + "_t";
    resultstable{1,2*s+2} = solution.solver.name + "_o";
end

% Table content
for p = 1:np
    problem = problems{p};
    resultstable{p+1,1} = problem.name;
    resultstable{p+1,2} = GetMacMPECOptimalObjective(problem.name);
    for s = 1:ns
        solution = problem.solutions{s};
        resultstable{p+1,2*s+1} = string(solution.stats.elapsed_time);
        resultstable{p+1,2*s+2} = string(solution.stats.obj);
    end
end

cell2csv(outdir + "/solutions_stats.csv", resultstable)

end