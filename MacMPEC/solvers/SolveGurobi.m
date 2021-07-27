function [x,y,stats] = SolveGurobi(name)

[x,y,stats] = SolveAMPLProblem(name, 'gurobi');

end

