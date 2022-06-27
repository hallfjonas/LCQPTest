function [] = SaveOutput(problems, outdir, compl_tol)

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
objtable = cell(np,ns);
timetable = cell(np,ns);
comptable = cell(np,ns);

% Table headers
objtable{1,1} = "problem";
timetable{1,1} = "problem";
comptable{1,1} = "problem";
for s = 1:ns
    % Add best known solution header to obj table
    objtable{1,2} = "best known";

    % Need this to extract solver names
    solution = problems{1}.solutions{s};

    % Add solver name header 
    timetable{1,s+1} = solution.solver.style.label;
    comptable{1,s+1} = solution.solver.style.label;
    objtable{1,s+2} = solution.solver.style.label;
end

% Table content
for p = 1:np
    problem = problems{p};
    % Problem names to both tables
    objtable{p+1,1} = problem.name;
    timetable{p+1,1} = problem.name;
    comptable{p+1,1} = problem.name;

    % Best known solution to objective table
    objtable{p+1,2} = GetMacMPECOptimalObjective(problem.name);

    % Solver stats
    for s = 1:ns
        solution = problem.solutions{s};

        if (solution.stats.exit_flag == 0)
            
            comptable{p+1,s+1} = string(solution.stats.compl);
            
            if (solution.stats.compl < compl_tol)
                objtable{p+1,s+2} = string(solution.stats.obj);
                timetable{p+1,s+1} = string(solution.stats.elapsed_time);
            else
                objtable{p+1,s+2} = "-";
                timetable{p+1,s+1} = "-";
            end
        else
            objtable{p+1,s+2} = "-";
            timetable{p+1,s+1} = "-";
            comptable{p+1,s+1} = "-";
        end
    end
end

cell2csv(outdir + "/solutions_obj.csv", objtable)
cell2csv(outdir + "/solutions_time.csv", timetable)
cell2csv(outdir + "/solutions_compl.csv", comptable)

end